report 50118 "Create G/L Acc. Jnl Lines-Open"
{
    Caption = 'Create G/L Acc. Journal Lines - Open Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = Balance;
            DataItemTableView = sorting("No.") where(Hidden = const(false), "Account Type" = const(Posting));
            RequestFilterFields = "No.", "Account Type", Blocked, "Direct Posting", "No. 2";
            dataitem(DimSetEntryTmp; "Dimension Set Entry")
            {
                DataItemTableView = sorting("Dimension Set ID", "Dimension Code");
                UseTemporary = true;
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemTableView = sorting("G/L Account No.", "Dimension Set ID");
                    RequestFilterFields = "Posting Date";

                    trigger OnAfterGetRecord()
                    begin
                        TotalAmount += "G/L Entry".Amount;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if TotalAmount <> 0 then begin
                            GenJnlLine.Init();
                            GenJnlLine.Validate("Journal Template Name", JournalTemplate);
                            GenJnlLine.Validate("Journal Batch Name", BatchName);
                            GenJnlLine."Line No." := LineNo;
                            LineNo := LineNo + 10000;

                            GenJnlLine.Validate("Document Type", DocumentTypes);
                            GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
                            GenJnlLine.Validate("Account No.", "G/L Entry"."G/L Account No.");
                            GenJnlLine.Validate("Gen. Posting Type", GenJnlLine."gen. posting type"::" ");
                            GenJnlLine.Validate("Gen. Bus. Posting Group", '');
                            GenJnlLine.Validate("Gen. Prod. Posting Group", '');
                            GenJnlLine.Validate("VAT Bus. Posting Group", '');
                            GenJnlLine.Validate("VAT Prod. Posting Group", '');
                            if ZGT.IsZComCompany and ZGT.IsRhq then
                                GenJnlLine.Validate("Document No.", 'Open.Bal.G/L-RHQ')
                            else
                                GenJnlLine.Validate("Document No.", 'Open.Bal.G/L');
                            GenJnlLine.Validate(Description, 'Opening Balance');
                            //GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                            GenJnlLine.Validate("Posting Date", PostingDate);
                            GenJnlLine.Validate(Amount, TotalAmount);
                            GenJnlLine.Insert(true);

                            GenJnlLine.Validate("Shortcut Dimension 1 Code", '');
                            GenJnlLine.Validate("Shortcut Dimension 2 Code", '');
                            recDimSetEntry.SetRange("Dimension Set ID", DimSetEntryTmp."Dimension Set ID");
                            if recDimSetEntry.FindSet() then begin
                                repeat
                                    case recDimSetEntry."Dimension Code" of
                                        recGenLedgSetup."Shortcut Dimension 1 Code":
                                            GenJnlLine.Validate("Shortcut Dimension 1 Code", recDimSetEntry."Dimension Value Code");
                                        recGenLedgSetup."Shortcut Dimension 2 Code":
                                            GenJnlLine.Validate("Shortcut Dimension 2 Code", recDimSetEntry."Dimension Value Code");
                                        recGenLedgSetup."Shortcut Dimension 3 Code":
                                            GenJnlLine.ValidateShortcutDimCode(3, recDimSetEntry."Dimension Value Code");
                                        recGenLedgSetup."Shortcut Dimension 4 Code":
                                            GenJnlLine.ValidateShortcutDimCode(4, recDimSetEntry."Dimension Value Code");
                                        recGenLedgSetup."Shortcut Dimension 7 Code":
                                            GenJnlLine.ValidateShortcutDimCode(7, recDimSetEntry."Dimension Value Code");
                                    end;
                                until recDimSetEntry.Next() = 0;
                            end else
                                GenJnlLine.Validate("Dimension Set ID", DimSetEntryTmp."Dimension Set ID");
                            GenJnlLine.Validate(Description, StrSubstNo('Opening Balance (%1-%2)', DimSetEntryTmp."Dimension Set ID", GenJnlLine."Dimension Set ID"));
                            GenJnlLine.Modify(true);
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "G/L Entry".SetRange("G/L Entry"."G/L Account No.", "G/L Account"."No.");
                        "G/L Entry".SetRange("G/L Entry"."Dimension Set ID", DimSetEntryTmp."Dimension Set ID");

                        TotalAmount := 0;

                        if "G/L Entry".GetFilter("G/L Entry"."Posting Date") = '' then
                            Error('Posting Date must be filled on G/L Entry.');
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DimSetEntryTmp.SetRange(DimSetEntryTmp."Dimension Set ID", DimSetEntryTmp."Dimension Set ID");
                    ZGT2.UpdateProgressWindow("G/L Account"."No." + ' - ' + Format(DimSetEntryTmp."Dimension Set ID"), DimSetEntryTmp.Count(), true);
                    DimSetEntryTmp.FindLast();
                    DimSetEntryTmp.SetRange(DimSetEntryTmp."Dimension Set ID");
                end;

                trigger OnPostDataItem()
                begin
                    ZGT2.CloseProgressWindow;
                end;

                trigger OnPreDataItem()
                begin
                    if "G/L Account"."Income/Balance" = "G/L Account"."income/balance"::"Balance Sheet" then
                        CurrReport.Break();

                    ZGT2.OpenProgressWindow('', DimSetEntryTmp.Count());
                end;
            }

            trigger OnAfterGetRecord()
            var
                StdGenJournalLine: Record "Standard General Journal Line";
            begin
                ZGT.UpdateProgressWindow("G/L Account"."No.", 0, true);

                if ("G/L Account"."Income/Balance" = "G/L Account"."income/balance"::"Balance Sheet") and ("G/L Account".Balance <> 0) then begin
                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", JournalTemplate);
                    GenJnlLine.Validate("Journal Batch Name", BatchName);
                    GenJnlLine."Line No." := LineNo;
                    LineNo := LineNo + 10000;

                    GenJnlLine.Validate("Document Type", DocumentTypes);
                    GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", "G/L Account"."No.");
                    GenJnlLine.Validate("Gen. Posting Type", GenJnlLine."gen. posting type"::" ");
                    GenJnlLine.Validate("Gen. Bus. Posting Group", '');
                    GenJnlLine.Validate("Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate("VAT Bus. Posting Group", '');
                    GenJnlLine.Validate("VAT Prod. Posting Group", '');
                    if ZGT.IsZComCompany and ZGT.IsRhq then
                        GenJnlLine.Validate("Document No.", 'Open.Bal.G/L-RHQ')
                    else
                        GenJnlLine.Validate("Document No.", 'Open.Bal.G/L');
                    GenJnlLine.Validate(Description, 'Opening Balance');
                    //GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                    GenJnlLine.Validate("Posting Date", PostingDate);
                    GenJnlLine.Validate(Amount, "G/L Account".Balance);
                    GenJnlLine.Insert(true);

                    GenJnlLine.Validate("Shortcut Dimension 1 Code", '');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", '');
                    GenJnlLine.Modify(true);
                end;

                /*GenJnlLine.INIT;
                IF GetStandardJournalLine THEN BEGIN
                  Initialize(StdGenJournal,GenJnlBatch.Name);
                
                  StdGenJournalLine.SETRANGE("Journal Template Name",StdGenJournal."Journal Template Name");
                  StdGenJournalLine.SETRANGE("Standard Journal Code",StdGenJournal.Code);
                  IF StdGenJournalLine.FINDSET THEN
                    REPEAT
                      CopyGenJnlFromStdJnl(StdGenJournalLine,GenJnlLine);
                      GenJnlLine.VALIDATE("Document Type",DocumentTypes);
                      GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
                      GenJnlLine.VALIDATE("Account No.","No.");
                      GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                      IF PostingDate <> 0D THEN
                        GenJnlLine.VALIDATE("Posting Date",PostingDate);
                      GenJnlLine.MODIFY(TRUE);
                    UNTIL StdGenJournalLine.Next() = 0;
                END ELSE BEGIN
                  GenJnlLine.VALIDATE("Journal Template Name",JournalTemplate);
                  GenJnlLine.VALIDATE("Journal Batch Name",BatchName);
                  GenJnlLine."Line No." := LineNo;
                  LineNo := LineNo + 10000;
                
                  GenJnlLine.VALIDATE("Document Type",DocumentTypes);
                  GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
                  GenJnlLine.VALIDATE("Account No.","No.");
                  GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                
                  IF PostingDate <> 0D THEN
                    GenJnlLine.VALIDATE("Posting Date",PostingDate);
                
                  IF NOT GenJnlLine.INSERT(TRUE) THEN
                    GenJnlLine.MODIFY(TRUE);
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

                GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
                GenJnlLine.SetRange("Journal Batch Name", BatchName);
                if GenJnlLine.FindLast() then
                    LineNo := GenJnlLine."Line No." + 10000
                else
                    LineNo := 10000;

                GenJnlBatch.Get(JournalTemplate, BatchName);
                if TemplateCode <> '' then
                    StdGenJournal.Get(JournalTemplate, TemplateCode);

                ZGT.OpenProgressWindow('', "G/L Account".Count());
                Sleep(1000 * 15);
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
                    field(DocumentTypes; DocumentTypes)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Type';
                        OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
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
                    field(JournalTemplate; JournalTemplate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Template';
                        TableRelation = "Gen. Journal Batch".Name;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            GenJnlTemplate: Record "Gen. Journal Template";
                            GenJnlTemplates: Page "General Journal Templates";
                        begin
                            GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::General);
                            GenJnlTemplate.SetRange(Recurring, false);
                            GenJnlTemplates.SetTableView(GenJnlTemplate);

                            GenJnlTemplates.LookupMode := true;
                            GenJnlTemplates.Editable := false;
                            if GenJnlTemplates.RunModal = Action::LookupOK then begin
                                GenJnlTemplates.GetRecord(GenJnlTemplate);
                                JournalTemplate := GenJnlTemplate.Name;
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
                        TableRelation = "Gen. Journal Batch".Name;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            GenJnlBatches: Page "General Journal Batches";
                        begin
                            if JournalTemplate <> '' then begin
                                GenJnlBatch.SetRange("Journal Template Name", JournalTemplate);
                                GenJnlBatches.SetTableView(GenJnlBatch);
                            end;

                            GenJnlBatches.LookupMode := true;
                            GenJnlBatches.Editable := false;
                            if GenJnlBatches.RunModal = Action::LookupOK then begin
                                GenJnlBatches.GetRecord(GenJnlBatch);
                                BatchName := GenJnlBatch.Name;
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
                        Caption = 'Standard General Journal';
                        TableRelation = "Standard General Journal".Code;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            StdGenJournal1: Record "Standard General Journal";
                            StdGenJnls: Page "Standard General Journals";
                        begin
                            if JournalTemplate <> '' then begin
                                StdGenJournal1.SetRange("Journal Template Name", JournalTemplate);
                                StdGenJnls.SetTableView(StdGenJournal1);
                            end;

                            StdGenJnls.LookupMode := true;
                            StdGenJnls.Editable := false;
                            if StdGenJnls.RunModal = Action::LookupOK then begin
                                StdGenJnls.GetRecord(StdGenJournal1);
                                TemplateCode := StdGenJournal1.Code;
                            end;
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if PostingDate = 0D then
                PostingDate := WorkDate;
        end;
    }

    trigger OnPostReport()
    begin
        Message(Text004);
    end;

    trigger OnPreReport()
    begin
        if recDimSetEntry.FindFirst() then begin
            DimSetEntryTmp.Insert();
            repeat
                DimSetEntryTmp := recDimSetEntry;
                DimSetEntryTmp.Insert();
            until recDimSetEntry.Next() = 0;
        end;

        recGenLedgSetup.Get();
    end;

    var
        StdGenJournal: Record "Standard General Journal";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        LastGenJnlLine: Record "Gen. Journal Line";
        DocumentTypes: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        PostingDate: Date;
        BatchName: Code[10];
        TemplateCode: Code[20];
        LineNo: Integer;
        Text001: Label 'Gen. Journal Template name is blank.';
        Text002: Label 'Gen. Journal Batch name is blank.';
        JournalTemplate: Text[10];
        Text004: Label 'General journal lines are successfully created.';
        PostingDateIsEmptyErr: Label 'The posting date is empty.';
        TotalAmount: Decimal;
        ZGT: Codeunit "ZyXEL General Tools";
        ZGT2: Codeunit "ZyXEL General Tools";
        recDimSetEntry: Record "Dimension Set Entry";
        recGenLedgSetup: Record "General Ledger Setup";

    local procedure GetStandardJournalLine(): Boolean
    var
        StdGenJounalLine: Record "Standard General Journal Line";
    begin
        if TemplateCode = '' then
            exit;
        StdGenJounalLine.SetRange("Journal Template Name", StdGenJournal."Journal Template Name");
        StdGenJounalLine.SetRange("Standard Journal Code", StdGenJournal.Code);
        exit(StdGenJounalLine.FindFirst());
    end;

    procedure Initialize(var StdGenJnl: Record "Standard General Journal"; JnlBatchName: Code[10])
    begin
        GenJnlLine."Journal Template Name" := StdGenJnl."Journal Template Name";
        GenJnlLine."Journal Batch Name" := JnlBatchName;
        GenJnlLine.SetRange("Journal Template Name", StdGenJnl."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", JnlBatchName);

        LastGenJnlLine.SetRange("Journal Template Name", StdGenJnl."Journal Template Name");
        LastGenJnlLine.SetRange("Journal Batch Name", JnlBatchName);

        if LastGenJnlLine.FindLast() then;

        GenJnlBatch.SetRange("Journal Template Name", StdGenJnl."Journal Template Name");
        GenJnlBatch.SetRange(Name, JnlBatchName);

        if GenJnlBatch.FindFirst() then;
    end;

    local procedure CopyGenJnlFromStdJnl(StdGenJnlLine: Record "Standard General Journal Line"; var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlManagement: Codeunit GenJnlManagement;
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
    begin
        GenJnlLine.Init();
        GenJnlLine."Line No." := 0;
        GenJnlManagement.CalcBalance(GenJnlLine, LastGenJnlLine, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        GenJnlLine.SetUpNewLine(LastGenJnlLine, Balance, true);
        if LastGenJnlLine."Line No." <> 0 then
            GenJnlLine."Line No." := LastGenJnlLine."Line No." + 10000
        else
            GenJnlLine."Line No." := 10000;

        GenJnlLine.TransferFields(StdGenJnlLine, false);
        GenJnlLine.UpdateLineBalance;
        GenJnlLine.Validate("Currency Code");

        if GenJnlLine."VAT Prod. Posting Group" <> '' then
            GenJnlLine.Validate("VAT Prod. Posting Group");
        if (GenJnlLine."VAT %" <> 0) and GenJnlBatch."Allow VAT Difference" then
            GenJnlLine.Validate("VAT Amount", StdGenJnlLine."VAT Amount");
        GenJnlLine.Validate("Bal. VAT Prod. Posting Group");

        if GenJnlBatch."Allow VAT Difference" then
            GenJnlLine.Validate("Bal. VAT Amount", StdGenJnlLine."Bal. VAT Amount");
        GenJnlLine.Insert(true);

        LastGenJnlLine := GenJnlLine;
    end;

    procedure InitializeRequest(DocumentTypesFrom: Option; PostingDateFrom: Date; JournalTemplateFrom: Text[10]; BatchNameFrom: Code[10]; StandardTemplateCodeFrom: Code[20])
    begin
        DocumentTypes := DocumentTypesFrom;
        PostingDate := PostingDateFrom;
        JournalTemplate := JournalTemplateFrom;
        BatchName := BatchNameFrom;
        TemplateCode := StandardTemplateCodeFrom;
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
