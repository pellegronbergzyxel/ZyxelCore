Report 50116 "Create Item Jnl. Lines OEntry"
{
    Caption = 'Create Item Journal Lines - Open Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Statistics Group", "Vendor No.", Blocked;
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                CalcFields = "Cost Amount (Expected)", "Cost Amount (Actual)";
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date") where(Open = const(true), "Location Code" = filter(<> 'PP*'), Positive = const(true));

                trigger OnAfterGetRecord()
                var
                    ShortcutDimCode: array[8] of Code[20];
                    DimMgt: Codeunit DimensionManagement;
                    i: Integer;
                    CtryCode: Code[10];
                    recCountry: Record "Country/Region";
                begin
                    ItemJnlLine.SetRange("Journal Template Name", JournalTemplate);
                    ItemJnlLine.SetRange("Journal Batch Name", BatchName);
                    ItemJnlLine.SetRange("Posting Date", "Item Ledger Entry"."Posting Date");
                    ItemJnlLine.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                    ItemJnlLine.SetRange("Entry Type", "Item Ledger Entry"."Entry Type");
                    //ItemJnlLine.SETRANGE("Document Type","Document Type");
                    ItemJnlLine.SetRange("Document No.", "Item Ledger Entry"."Document No.");
                    ItemJnlLine.SetRange("Shortcut Dimension 1 Code", "Item Ledger Entry"."Global Dimension 1 Code");
                    ItemJnlLine.SetRange("Shortcut Dimension 2 Code", "Item Ledger Entry"."Global Dimension 2 Code");
                    ItemJnlLine.SetRange("Expiration Date", "Item Ledger Entry"."Expiration Date");
                    if ItemJnlLine.FindFirst then begin
                        ItemJnlLine.Validate(Quantity, ItemJnlLine.Quantity + "Item Ledger Entry"."Remaining Quantity");
                        ItemJnlLine.Modify(true);
                    end else begin
                        ItemJnlLine.Reset;
                        Clear(ItemJnlLine);
                        ItemJnlLine.Init;
                        ItemJnlLine.Validate("Journal Template Name", JournalTemplate);
                        ItemJnlLine.Validate("Journal Batch Name", BatchName);
                        ItemJnlLine."Line No." := LineNo;
                        LineNo := LineNo + 10000;

                        ItemJnlLine.Validate("Posting Date", "Item Ledger Entry"."Posting Date");
                        /*IF "Entry Type" IN ["Entry Type"::Sale,"Entry Type"::Purchase] THEN BEGIN
                          ItemJnlLine.VALIDATE("Entry Type","Entry Type");
                          ItemJnlLine.VALIDATE("Document Type","Document Type");
                        END ELSE */
                        ItemJnlLine.Validate("Entry Type", "Item Ledger Entry"."entry type"::"Positive Adjmt.");
                        ItemJnlLine.Validate("Document No.", "Item Ledger Entry"."Document No.");
                        ItemJnlLine.Validate("Item No.", "Item Ledger Entry"."Item No.");
                        ItemJnlLine.Validate(Description, 'Opening Balance');
                        ItemJnlLine.Validate("External Document No.", "Item Ledger Entry"."External Document No.");
                        ItemJnlLine.Validate("Location Code", "Item Ledger Entry"."Location Code");
                        ItemJnlLine.Validate("Document Date", "Item Ledger Entry"."Document Date");
                        ItemJnlLine.Validate(Quantity, "Item Ledger Entry"."Remaining Quantity");
                        ItemJnlLine.Validate("Unit Cost", ROUND(("Item Ledger Entry"."Cost Amount (Expected)" + "Item Ledger Entry"."Cost Amount (Actual)") / "Item Ledger Entry".Quantity));
                        ItemJnlLine.Validate("Shortcut Dimension 1 Code", "Item Ledger Entry"."Global Dimension 1 Code");
                        ItemJnlLine.Validate("Shortcut Dimension 2 Code", "Item Ledger Entry"."Global Dimension 2 Code");
                        ItemJnlLine.Validate("Source Type", "Item Ledger Entry"."Source Type");
                        ItemJnlLine.Validate("Source No.", "Item Ledger Entry"."Source No.");
                        ItemJnlLine.Validate("Country/Region Code", "Item Ledger Entry"."Country/Region Code");
                        ItemJnlLine.Validate("Expiration Date", "Item Ledger Entry"."Expiration Date");
                        ItemJnlLine.Validate("Return Reason Code", "Item Ledger Entry"."Return Reason Code");
                        ItemJnlLine.Insert(true);

                        /*DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
                        ItemJnlLine.ValidateNewShortcutDimCode(3,ShortcutDimCode[3]);
                        ItemJnlLine.MODIFY(TRUE);*/

                        // Country Dimension
                        CtryCode := 'RHQ';
                        for i := StrLen("Item Ledger Entry"."Item No.") downto 1 do begin
                            if "Item Ledger Entry"."Item No."[i] = '-' then begin
                                CtryCode := CopyStr("Item Ledger Entry"."Item No.", i + 1, 2);
                                i := 0;
                            end;

                            if recCountry.Get(CtryCode) and (CtryCode <> 'EU') then
                                ItemJnlLine.ValidateShortcutDimCode(3, CtryCode)
                            else begin
                                CtryCode := 'RHQ';
                                ItemJnlLine.ValidateShortcutDimCode(3, CtryCode);
                            end;
                        end;

                        ItemJnlLine.Validate(Description, StrSubstNo('Opening Balance (%1-%2)', "Item Ledger Entry"."Dimension Set ID", ItemJnlLine."Dimension Set ID"));
                        ItemJnlLine.Modify(true);

                        if not Item.Active then begin
                            Item.Active := true;
                            Item.Modify;
                        end;
                    end;

                end;
            }

            trigger OnAfterGetRecord()
            var
                StdItemJnlLine: Record "Standard Item Journal Line";
            begin
                ZGT.UpdateProgressWindow(Item."No.", 0, true);

                Item.Active := false;
                Item.Modify;

                /*ItemJnlLine.INIT;
                IF GetStandardJournalLine THEN BEGIN
                  Initialize(StdItemJnl,ItemJnlBatch.Name);
                
                  StdItemJnlLine.SETRANGE("Journal Template Name",StdItemJnl."Journal Template Name");
                  StdItemJnlLine.SETRANGE("Standard Journal Code",StdItemJnl.Code);
                  IF StdItemJnlLine.FINDSET THEN
                    REPEAT
                      CopyItemJnlFromStdJnl(StdItemJnlLine,ItemJnlLine);
                      ItemJnlLine.VALIDATE("Entry Type",EntryTypes);
                      ItemJnlLine.VALIDATE("Item No.","No.");
                
                      IF PostingDate <> 0D THEN
                        ItemJnlLine.VALIDATE("Posting Date",PostingDate);
                
                      IF DocumentDate <> 0D THEN BEGIN
                        ItemJnlLine.VALIDATE("Posting Date",DocumentDate);
                        ItemJnlLine."Posting Date" := PostingDate;
                      END;
                
                      IF NOT ItemJnlLine.INSERT(TRUE) THEN
                        ItemJnlLine.MODIFY(TRUE);
                    UNTIL StdItemJnlLine.Next() = 0;
                END ELSE BEGIN
                  ItemJnlLine.VALIDATE("Journal Template Name",ItemJnlLine.GETFILTER("Journal Template Name"));
                  ItemJnlLine.VALIDATE("Journal Batch Name",BatchName);
                  ItemJnlLine."Line No." := LineNo;
                  LineNo := LineNo + 10000;
                
                  ItemJnlLine.VALIDATE("Entry Type",EntryTypes);
                  ItemJnlLine.VALIDATE("Item No.","No.");
                
                  IF PostingDate <> 0D THEN
                    ItemJnlLine.VALIDATE("Posting Date",PostingDate);
                
                  IF DocumentDate <> 0D THEN BEGIN
                    ItemJnlLine.VALIDATE("Posting Date",DocumentDate);
                    ItemJnlLine."Posting Date" := PostingDate;
                  END;
                
                  IF NOT ItemJnlLine.INSERT(TRUE) THEN
                    ItemJnlLine.MODIFY(TRUE);
                END;*/

            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                CheckJournalTemplate;
                CheckBatchName;
                CheckPostingDate;

                ItemJnlLine.SetRange("Journal Template Name", JournalTemplate);
                ItemJnlLine.SetRange("Journal Batch Name", BatchName);
                if ItemJnlLine.FindLast then
                    LineNo := ItemJnlLine."Line No." + 10000
                else
                    LineNo := 10000;

                ItemJnlBatch.Get(JournalTemplate, BatchName);
                if TemplateCode <> '' then
                    StdItemJnl.Get(JournalTemplate, TemplateCode);

                ZGT.OpenProgressWindow('', Item.Count);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(EntryTypes; EntryTypes)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Entry Type';
                        OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';

                        trigger OnValidate()
                        begin
                            CheckPostingDate;
                        end;
                    }
                    field(DocumentDate; DocumentDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date';
                    }
                    field(JournalTemplate; JournalTemplate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Template';
                        TableRelation = "Gen. Journal Batch".Name;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemJnlTemplate: Record "Item Journal Template";
                            ItemJnlTemplates: Page "Item Journal Templates";
                        begin
                            ItemJnlTemplate.SetRange(Type, ItemJnlTemplate.Type::Item);
                            ItemJnlTemplate.SetRange(Recurring, false);
                            ItemJnlTemplates.SetTableview(ItemJnlTemplate);

                            ItemJnlTemplates.LookupMode := true;
                            ItemJnlTemplates.Editable := false;
                            if ItemJnlTemplates.RunModal = Action::LookupOK then begin
                                ItemJnlTemplates.GetRecord(ItemJnlTemplate);
                                JournalTemplate := ItemJnlTemplate.Name;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            CheckJournalTemplate;
                        end;
                    }
                    field(BatchName; BatchName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Batch Name';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemJnlBatches: Page "Item Journal Batches";
                        begin
                            if JournalTemplate <> '' then begin
                                ItemJnlBatch.SetRange("Journal Template Name", JournalTemplate);
                                ItemJnlBatches.SetTableview(ItemJnlBatch);
                            end;

                            ItemJnlBatches.LookupMode := true;
                            ItemJnlBatches.Editable := false;
                            if ItemJnlBatches.RunModal = Action::LookupOK then begin
                                ItemJnlBatches.GetRecord(ItemJnlBatch);
                                BatchName := ItemJnlBatch.Name;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            CheckBatchName;
                        end;
                    }
                    field(TemplateCode; TemplateCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Standard Item Journal';
                        TableRelation = "Standard Item Journal".Code;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            StdItemJnl1: Record "Standard Item Journal";
                            StdItemJnls: Page "Standard Item Journals";
                        begin
                            if JournalTemplate <> '' then begin
                                StdItemJnl1.SetRange("Journal Template Name", JournalTemplate);
                                StdItemJnls.SetTableview(StdItemJnl1);
                            end;

                            StdItemJnls.LookupMode := true;
                            StdItemJnls.Editable := false;
                            if StdItemJnls.RunModal = Action::LookupOK then begin
                                StdItemJnls.GetRecord(StdItemJnl1);
                                TemplateCode := StdItemJnl1.Code;
                            end;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDate = 0D then
                PostingDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(Text004);
    end;

    var
        StdItemJnl: Record "Standard Item Journal";
        ItemJnlBatch: Record "Item Journal Batch";
        LastItemJnlLine: Record "Item Journal Line";
        ItemJnlLine: Record "Item Journal Line";
        EntryTypes: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.";
        PostingDate: Date;
        DocumentDate: Date;
        BatchName: Code[10];
        TemplateCode: Code[20];
        LineNo: Integer;
        JournalTemplate: Text[10];
        Text001: label 'Item Journal Template name is blank.';
        Text002: label 'Item Journal Batch name is blank.';
        Text004: label 'Item Journal lines are successfully created.';
        PostingDateIsEmptyErr: label 'The Posting Date is empty.';
        ZGT: Codeunit "ZyXEL General Tools";
        recDimSetEntry: Record "Dimension Set Entry";
        recGenLedgSetup: Record "General Ledger Setup";

    local procedure GetStandardJournalLine(): Boolean
    var
        StdItemJnlLine: Record "Standard Item Journal Line";
    begin
        if TemplateCode = '' then
            exit;
        StdItemJnlLine.SetRange("Journal Template Name", StdItemJnl."Journal Template Name");
        StdItemJnlLine.SetRange("Standard Journal Code", StdItemJnl.Code);
        exit(StdItemJnlLine.FindFirst);
    end;


    procedure Initialize(StdItemJnl: Record "Standard Item Journal"; JnlBatchName: Code[10])
    begin
        ItemJnlLine."Journal Template Name" := StdItemJnl."Journal Template Name";
        ItemJnlLine."Journal Batch Name" := JnlBatchName;
        ItemJnlLine.SetRange("Journal Template Name", StdItemJnl."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", JnlBatchName);

        LastItemJnlLine.SetRange("Journal Template Name", StdItemJnl."Journal Template Name");
        LastItemJnlLine.SetRange("Journal Batch Name", JnlBatchName);

        if LastItemJnlLine.FindLast then;
    end;

    local procedure CopyItemJnlFromStdJnl(StdItemJnlLine: Record "Standard Item Journal Line"; var ItemJnlLine: Record "Item Journal Line")
    begin
        ItemJnlLine.Init;
        ItemJnlLine."Line No." := 0;
        ItemJnlLine.SetUpNewLine(LastItemJnlLine);
        if LastItemJnlLine."Line No." <> 0 then
            ItemJnlLine."Line No." := LastItemJnlLine."Line No." + 10000
        else
            ItemJnlLine."Line No." := 10000;

        ItemJnlLine.TransferFields(StdItemJnlLine, false);

        if (ItemJnlLine."Item No." <> '') and (ItemJnlLine."Unit Amount" = 0) then
            ItemJnlLine.RecalculateUnitAmount;

        if (ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::Output) and
           (ItemJnlLine."Value Entry Type" <> ItemJnlLine."value entry type"::Revaluation)
        then
            ItemJnlLine."Invoiced Quantity" := 0
        else
            ItemJnlLine."Invoiced Quantity" := ItemJnlLine.Quantity;
        ItemJnlLine.TestField("Qty. per Unit of Measure");
        ItemJnlLine."Invoiced Qty. (Base)" := ROUND(ItemJnlLine."Invoiced Quantity" * ItemJnlLine."Qty. per Unit of Measure", 0.00001);

        ItemJnlLine.Insert(true);

        LastItemJnlLine := ItemJnlLine;
    end;


    procedure InitializeRequest(EntryTypesFrom: Option; PostingDateFrom: Date; DocumentDateFrom: Date)
    begin
        EntryTypes := EntryTypesFrom;
        PostingDate := PostingDateFrom;
        DocumentDate := DocumentDateFrom;
    end;


    procedure InitializeRequestTemplate(JournalTemplateFrom: Text[10]; BatchNameFrom: Code[10]; TemplateCodeFrom: Code[20])
    begin
        JournalTemplate := JournalTemplateFrom;
        BatchName := BatchNameFrom;
        TemplateCode := TemplateCodeFrom;
    end;

    local procedure CheckPostingDate()
    begin
        if PostingDate = 0D then
            Error(PostingDateIsEmptyErr);
    end;

    local procedure CheckBatchName()
    begin
        if BatchName = '' then
            Error(Text002);
    end;

    local procedure CheckJournalTemplate()
    begin
        if JournalTemplate = '' then
            Error(Text001);
    end;
}
