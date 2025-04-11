report 50040 "Post LMR Stock"
{
    // 001. 09-09-24 ZY-LD 000 - Roules about Bin-code is changed.

    Caption = 'Post LMR Stock';
    ProcessingOnly = true;
    ShowPrintStatus = false;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostJournal; PostJournal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Item Journal';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        PostJournal := true;
    end;

    trigger OnPostReport()
    begin
        if not PostJournal then begin
            Message(Text002);
            Page.Run(Page::"Item Journal");
        end else
            Message(Text003);
    end;

    trigger OnPreReport()
    var
        Batch: Code[20];
        Template: Code[20];
    begin
        SI.UseOfReport(3, 50040, 2);  // 14-10-20 ZY-LD 000
        recSalesSetup.Get();

        CreateItemJournal;
        PostItemJournal;
        ReblockItems;
    end;

    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recItemTmp: Record Item temporary;
        SI: Codeunit "Single Instance";
        ItemJournalPosted: Boolean;
        Text001: Label 'Automatic Adjustment of LMR Inventory';
        PostJournal: Boolean;
        Text002: Label 'Item Journal "RMA" has been created, but not posted.\You need to post it manually to make the item adjustment.';
        Text003: Label 'The LMR Journal has been successfully posted and items has been adjusted.';

    local procedure PostItemJournal()
    var
        recItemJnlLine: Record "Item Journal Line";
    begin
        if PostJournal then begin
            Commit();
            recItemJnlLine.SetRange("Journal Template Name", recSalesSetup."LMR Item Journal Template Name");
            recItemJnlLine.SetRange("Journal Batch Name", recSalesSetup."LMR Item Journal Batch Name");
            if recItemJnlLine.FindFirst() then begin
                Codeunit.Run(Codeunit::"Item Jnl.-Post", recItemJnlLine);
                ItemJournalPosted := true;
            end;
        end;
    end;

    local procedure ReblockItems()
    var
        recItem: Record Item;
    begin
        if recItemTmp.FindSet() then
            repeat
                recItem.Get(recItemTmp."No.");
                recItem.Blocked := true;
                recItem.Modify(true);
            until recItemTmp.Next() = 0;
    end;

    local procedure CreateItemJournal()
    var
        recItem: Record Item;
        recLMRStock: Record "LMR Stock";
        recLMRStockTmp: Record "LMR Stock" temporary;
        recItemJnlLine: Record "Item Journal Line";
        xrecItemJnlLine: Record "Item Journal Line";
        ZGT: Codeunit "ZyXEL General Tools";
        lText006: Label 'Import Excel File';
        lText001: Label 'You must specify an Excel file first.';
        lText002: Label 'You must specify the sheet name to import first.';
        lText003: Label 'Analyzing Data...\\';
        lText001a: Label 'The location code of the All-In Logistics warehouse has not been set in the Sales & Receivables Setup.';
        lText004: Label 'Posting LMR Stock';
        NextLineNo: Integer;
    begin
        recLMRStock.SetCurrentkey(Open);
        recLMRStock.SetRange(Open, true);
        //recLMRStock.SetRange(Bin, recSalesSetup."LMR Value Bin");  // 09-09-24 ZY-LD 001
        if recLMRStock.FindSet(true) then begin
            ZGT.OpenProgressWindow(lText004, recLMRStock.Count());

            // Delete old lines before insert
            recItemJnlLine.SetRange("Journal Template Name", recSalesSetup."LMR Item Journal Template Name");
            recItemJnlLine.SetRange("Journal Batch Name", recSalesSetup."LMR Item Journal Batch Name");
            if recItemJnlLine.FindFirst() then begin
                recItemJnlLine.DeleteAll(true);
                Commit();
            end;
            recItemJnlLine.Reset();

            NextLineNo := GetNextLineNo(recSalesSetup."LMR Item Journal Template Name", recSalesSetup."LMR Item Journal Batch Name");

            repeat
                ZGT.UpdateProgressWindow(lText004, 0, true);

                if recLMRStock."Location Code" = 'RMA GB' then
                    recLMRStock."Location Code" := 'RMA UK';

                recItem.SetRange("Location Filter", recLMRStock."Location Code");
                recItem.SetAutoCalcFields(Inventory);
                if recItem.Get(recLMRStock."Item No.") and (recItem.Inventory <> recLMRStock.Quantity) then begin
                    NextLineNo += 10000;

                    if recItem.Blocked then begin
                        recItemTmp."No." := recItem."No.";
                        if not recItemTmp.Insert() then;

                        recItem.Blocked := false;
                        recItem.Modify(true);
                    end;

                    Clear(recItemJnlLine);
                    recItemJnlLine.Init();
                    recItemJnlLine.Validate("Journal Template Name", recSalesSetup."LMR Item Journal Template Name");
                    recItemJnlLine.Validate("Journal Batch Name", recSalesSetup."LMR Item Journal Batch Name");
                    recItemJnlLine.Validate("Line No.", NextLineNo);
                    Commit();
                    recItemJnlLine.SetUpNewLine(xrecItemJnlLine);
                    recItemJnlLine.Validate("Item No.", recLMRStock."Item No.");
                    recItemJnlLine.Validate("Location Code", recLMRStock."Location Code");
                    if recItem.Inventory > recLMRStock.Quantity then begin
                        recItemJnlLine.Validate("Entry Type", recItemJnlLine."entry type"::"Negative Adjmt.");
                        recItemJnlLine.Validate(Quantity, recItem.Inventory - recLMRStock.Quantity);
                    end else begin
                        recItemJnlLine."Entry Type" := recItemJnlLine."entry type"::"Positive Adjmt.";
                        recItemJnlLine.Validate(Quantity, recLMRStock.Quantity - recItem.Inventory);
                    end;
                    recItemJnlLine.Description := Text001;
                    if recLMRStock.Bin <> '' then  // 09-09-24 ZY-LD 001
                        recItemJnlLine.Validate("Bin Code", recLMRStock.Bin);
                    recItemJnlLine.Validate("Gen. Prod. Posting Group", recSalesSetup."LMR Gen. Prod. Posting Group");
                    recItemJnlLine.Validate("Shortcut Dimension 1 Code", recSalesSetup."LMR Division");
                    recItemJnlLine.Validate("Shortcut Dimension 2 Code", recSalesSetup."LMR Department");

                    recItemJnlLine.Insert(true);
                    recItemJnlLine.ValidateShortcutDimCode(3, recSalesSetup."LMR Country Code");
                    recItemJnlLine.Modify(true);
                    xrecItemJnlLine := recItemJnlLine;
                end;

                recLMRStock.Processed := true;
                recLMRStock.Modify(true)
            until recLMRStock.Next() = 0;

            //>> 09-09-24 ZY-LD 001
            //recLMRStock.SetRange(Bin);
            //recLMRStock.ModifyAll(Open, false); 
            recLMRStock.DeleteAll(true);
            //<< 09-09-24 ZY-LD 001

            ZGT.CloseProgressWindow;
        end;
    end;

    local procedure GetNextLineNo(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Integer
    var
        recItemJnlLine: Record "Item Journal Line";
    begin
        recItemJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        recItemJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if recItemJnlLine.FindLast() then
            exit(recItemJnlLine."Line No.")
    end;

    procedure GetPostingStatus() rValue: Boolean;
    begin
        rValue := ItemJournalPosted;
    end;
}
