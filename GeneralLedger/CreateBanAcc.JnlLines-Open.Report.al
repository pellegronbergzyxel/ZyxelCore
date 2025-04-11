report 50124 "Create Ban Acc. Jnl Lines-Open"
{
    Caption = 'Create Bank Acc. Journal Lines - Open Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            CalcFields = Balance;
            DataItemTableView = where(Blocked = const(false));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Bank Account"."No.", 0, true);

                if "Bank Account".Balance <> 0 then begin
                    recBankAcc.Get("Bank Account"."No.");
                    recBankAccPostGrp.Get(recBankAcc."Bank Acc. Posting Group");

                    Clear(GenJnlLine);
                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", JournalTemplate);
                    GenJnlLine.Validate("Journal Batch Name", BatchName);
                    GenJnlLine."Line No." := LineNo;
                    LineNo := LineNo + 10000;

                    GenJnlLine.Validate("Document Type", DocumentTypes);
                    GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"Bank Account");
                    GenJnlLine.Validate("Account No.", "Bank Account"."No.");
                    if ZGT.IsZComCompany and ZGT.IsRhq then
                        GenJnlLine.Validate("Document No.", 'Open.Bal.Bank-RHQ')
                    else
                        GenJnlLine.Validate("Document No.", 'Open.Bal.Bank');
                    GenJnlLine.Validate(Description, 'Opening Balance');
                    //GenJnlLine.VALIDATE("Bal. Account No.",recBankAccPostGrp."G/L Bank Account No.");
                    GenJnlLine.Validate("Posting Date", PostingDate);
                    GenJnlLine.Validate(Amount, "Bank Account".Balance);
                    GenJnlLine.Insert(true);

                    GenJnlLine.Validate("Shortcut Dimension 1 Code", '');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", '');
                    GenJnlLine.ValidateShortcutDimCode(3, BlankDim);
                    GenJnlLine.ValidateShortcutDimCode(4, BlankDim);
                    GenJnlLine.Modify(true);

                    // Balance Entry
                    SaveCurrCode := GenJnlLine."Currency Code";
                    Clear(GenJnlLine);
                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", JournalTemplate);
                    GenJnlLine.Validate("Journal Batch Name", BatchName);
                    GenJnlLine."Line No." := LineNo;
                    LineNo := LineNo + 10000;

                    GenJnlLine.Validate("Document Type", DocumentTypes);
                    GenJnlLine.Validate("Account Type", GenJnlLine."account type"::"G/L Account");
                    GenJnlLine.Validate("Account No.", recBankAccPostGrp."G/L Account No.");
                    GenJnlLine.Validate("Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate("Currency Code", SaveCurrCode);
                    if ZGT.IsZComCompany and ZGT.IsRhq then
                        GenJnlLine.Validate("Document No.", 'Open.Bal.Bank-RHQ')
                    else
                        GenJnlLine.Validate("Document No.", 'Open.Bal.Bank');
                    GenJnlLine.Validate(Description, 'Opening Balance');
                    GenJnlLine.Validate("Posting Date", PostingDate);
                    GenJnlLine.Validate(Amount, -"Bank Account".Balance);
                    GenJnlLine.Insert(true);

                    GenJnlLine.Validate("Shortcut Dimension 1 Code", '');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", '');
                    GenJnlLine.ValidateShortcutDimCode(3, BlankDim);
                    GenJnlLine.ValidateShortcutDimCode(4, BlankDim);
                    GenJnlLine.Modify(true);

                end;
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

                ZGT.OpenProgressWindow('', "Bank Account".Count());
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

        actions
        {
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
        ZGT: Codeunit "ZyXEL General Tools";
        recBankAcc: Record "Bank Account";
        recBankAccPostGrp: Record "Bank Account Posting Group";
        BlankDim: Code[10];
        SaveCurrCode: Code[10];

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
