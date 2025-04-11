Report 50111 "Create Cust. Jnl. Lines OEntry"
{
    Caption = 'Create Customer Journal Lines - Open Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.") where("Bill-to Customer No." = filter(''));
            RequestFilterFields = "No.", "Currency Code", "Country/Region Code", "Salesperson Code", "Customer Posting Group", Blocked;
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = Amount;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Customer No.", Open, Positive, "Due Date", "Currency Code") where(Open = const(true));

                trigger OnAfterGetRecord()
                begin
                    ZGT2.UpdateProgressWindow(Format("Cust. Ledger Entry"."Posting Date"), 0, true);

                    if not CustomerUnblocked then
                        if Customer.Blocked <> Customer.Blocked::" " then begin
                            CustomerUnblocked := true;
                            CustTmp := Customer;

                            Customer.Blocked := Customer.Blocked::" ";
                            Customer.Modify;
                        end;

                    Clear(GenJnlLine);
                    GenJnlLine.Init;

                    GenJnlLine.Validate("Journal Template Name", JournalTemplate);
                    GenJnlLine.Validate("Journal Batch Name", BatchName);
                    GenJnlLine."Line No." := LineNo;
                    LineNo := LineNo + 10000;

                    //IF PostingDate <> 0D THEN
                    //GenJnlLine.VALIDATE("Posting Date","Posting Date");
                    GenJnlLine.Validate("Posting Date", PostingDate);
                    GenJnlLine.Validate("Document Date", "Cust. Ledger Entry"."Document Date");
                    GenJnlLine.Validate("Due Date", "Cust. Ledger Entry"."Due Date");
                    GenJnlLine.Validate("Document Type", "Cust. Ledger Entry"."Document Type");
                    GenJnlLine.Validate("Document No.", "Cust. Ledger Entry"."Document No.");
                    GenJnlLine.Validate("Account Type", GenJnlLine."account type"::Customer);
                    GenJnlLine.Validate("Account No.", "Cust. Ledger Entry"."Customer No.");
                    GenJnlLine.Validate(Description, Text005);
                    //GenJnlLine.VALIDATE("Dimension Set ID","Dimension Set ID");
                    GenJnlLine.Validate("Currency Code", "Cust. Ledger Entry"."Currency Code");
                    GenJnlLine.Validate(Amount, "Cust. Ledger Entry".Amount);

                    if (GenJnlBatch."Bal. Account Type" = GenJnlBatch."bal. account type"::"G/L Account") and
                        (GenJnlBatch."Bal. Account No." <> '')
                    then begin
                        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."bal. account type"::"G/L Account");
                        GenJnlLine.Validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
                    end else
                        if "Cust. Ledger Entry"."Customer Posting Group" <> '' then
                            if CustPostGrp.Get("Cust. Ledger Entry"."Customer Posting Group") then begin
                                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."bal. account type"::"G/L Account");
                                GenJnlLine.Validate("Bal. Account No.", CustPostGrp."Receivables Account");
                            end;
                    if DocumentDate <> 0D then begin
                        GenJnlLine.Validate("Posting Date", DocumentDate);
                        GenJnlLine."Posting Date" := PostingDate;
                    end;

                    GenJnlLine.Insert(true);

                    GenJnlLine.Validate("Shortcut Dimension 1 Code", '');
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", '');
                    recDimSetEntry.SetRange("Dimension Set ID", "Cust. Ledger Entry"."Dimension Set ID");
                    if recDimSetEntry.FindSet then begin
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
                        GenJnlLine.Validate("Dimension Set ID", 0);
                    GenJnlLine.Validate(Description, StrSubstNo('Opening Balance (%1-%2)', "Cust. Ledger Entry"."Dimension Set ID", GenJnlLine."Dimension Set ID"));
                    GenJnlLine.Modify(true);
                end;

                trigger OnPostDataItem()
                begin
                    ZGT2.CloseProgressWindow;

                    if CustomerUnblocked then begin
                        CustomerUnblocked := false;

                        Customer.Blocked := CustTmp.Blocked;
                        Customer.Modify;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    ZGT2.OpenProgressWindow('', "Cust. Ledger Entry".Count);
                end;
            }

            trigger OnAfterGetRecord()
            var
                StdGenJournalLine: Record "Standard General Journal Line";
            begin
                ZGT.UpdateProgressWindow(Customer."No.", 0, true);

                /*GenJnlLine.INIT;
                IF GetStandardJournalLine THEN BEGIN
                  Initialize(StdGenJournal,GenJnlBatch.Name);
                
                  StdGenJournalLine.SETRANGE("Journal Template Name",StdGenJournal."Journal Template Name");
                  StdGenJournalLine.SETRANGE("Standard Journal Code",StdGenJournal.Code);
                  IF StdGenJournalLine.FINDSET THEN
                    REPEAT
                      CopyGenJnlFromStdJnl(StdGenJournalLine,GenJnlLine);
                
                      IF PostingDate <> 0D THEN
                        GenJnlLine.VALIDATE("Posting Date",PostingDate);
                
                      GenJnlLine.VALIDATE("Document Type",DocumentTypes);
                      GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                      GenJnlLine.VALIDATE("Account No.","No.");
                      IF (GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"G/L Account") AND
                         (GenJnlBatch."Bal. Account No." <> '')
                      THEN BEGIN
                        GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                      END ELSE
                        IF "Customer Posting Group" <> '' THEN
                          IF CustPostGrp.GET("Customer Posting Group") THEN BEGIN
                            GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                            GenJnlLine.VALIDATE("Bal. Account No.",CustPostGrp."Receivables Account");
                          END;
                
                      IF DocumentDate <> 0D THEN BEGIN
                        GenJnlLine.VALIDATE("Posting Date",DocumentDate);
                        GenJnlLine."Posting Date" := PostingDate;
                      END;
                
                      GenJnlLine.MODIFY(TRUE);
                    UNTIL StdGenJournalLine.Next() = 0;
                END ELSE BEGIN
                  GenJnlLine.VALIDATE("Journal Template Name",GenJnlLine.GETFILTER("Journal Template Name"));
                  GenJnlLine.VALIDATE("Journal Batch Name",BatchName);
                  GenJnlLine."Line No." := LineNo;
                  LineNo := LineNo + 10000;
                
                  IF PostingDate <> 0D THEN
                    GenJnlLine.VALIDATE("Posting Date",PostingDate);
                
                  GenJnlLine.VALIDATE("Document Type",DocumentTypes);
                  GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                  GenJnlLine.VALIDATE("Account No.","No.");
                  IF (GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"G/L Account") AND
                     (GenJnlBatch."Bal. Account No." <> '')
                  THEN BEGIN
                    GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                  END ELSE
                    IF "Customer Posting Group" <> '' THEN
                      IF CustPostGrp.GET("Customer Posting Group") THEN BEGIN
                        GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Bal. Account No.",CustPostGrp."Receivables Account");
                      END;
                  IF DocumentDate <> 0D THEN BEGIN
                    GenJnlLine.VALIDATE("Posting Date",DocumentDate);
                    GenJnlLine."Posting Date" := PostingDate;
                  END;
                
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
                if GenJnlLine.FindLast then
                    LineNo := GenJnlLine."Line No." + 10000
                else
                    LineNo := 10000;

                GenJnlBatch.Get(JournalTemplate, BatchName);
                if TemplateCode <> '' then
                    StdGenJournal.Get(JournalTemplate, TemplateCode);

                ZGT.OpenProgressWindow('', Customer.Count);
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
                            GenJnlTemplate: Record "Gen. Journal Template";
                            GenJnlTemplates: Page "General Journal Templates";
                        begin
                            GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::General);
                            GenJnlTemplate.SetRange(Recurring, false);
                            GenJnlTemplates.SetTableview(GenJnlTemplate);

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
                                GenJnlBatches.SetTableview(GenJnlBatch);
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
                                StdGenJnls.SetTableview(StdGenJournal1);
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

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(Text004);
    end;

    trigger OnPreReport()
    begin
        recGenLedgSetup.Get;
    end;

    var
        StdGenJournal: Record "Standard General Journal";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        LastGenJnlLine: Record "Gen. Journal Line";
        CustPostGrp: Record "Customer Posting Group";
        DocumentTypes: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        PostingDate: Date;
        DocumentDate: Date;
        BatchName: Code[10];
        TemplateCode: Code[20];
        LineNo: Integer;
        JournalTemplate: Text[10];
        Text001: label 'Gen. Journal Template name is blank.';
        Text002: label 'Gen. Journal Batch name is blank.';
        Text004: label 'General journal lines are successfully created.';
        PostingDateIsEmptyErr: label 'The posting date is empty.';
        ZGT: Codeunit "ZyXEL General Tools";
        ZGT2: Codeunit "ZyXEL General Tools";
        CustomerUnblocked: Boolean;
        CustTmp: Record Customer temporary;
        Text005: label 'Opening Balance';
        recDimSetEntry: Record "Dimension Set Entry";
        recGenLedgSetup: Record "General Ledger Setup";

    local procedure GetStandardJournalLine(): Boolean
    var
        StdGenJounalLine: Record "Standard General Journal Line";
    begin
        if TemplateCode = '' then
            exit(false);
        StdGenJounalLine.SetRange("Journal Template Name", StdGenJournal."Journal Template Name");
        StdGenJounalLine.SetRange("Standard Journal Code", StdGenJournal.Code);
        exit(StdGenJounalLine.FindFirst)
    end;


    procedure Initialize(var StdGenJnl: Record "Standard General Journal"; JnlBatchName: Code[10])
    begin
        GenJnlLine."Journal Template Name" := StdGenJnl."Journal Template Name";
        GenJnlLine."Journal Batch Name" := JnlBatchName;
        GenJnlLine.SetRange("Journal Template Name", StdGenJnl."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", JnlBatchName);

        LastGenJnlLine.SetRange("Journal Template Name", StdGenJnl."Journal Template Name");
        LastGenJnlLine.SetRange("Journal Batch Name", JnlBatchName);

        if LastGenJnlLine.FindLast then;

        GenJnlBatch.SetRange("Journal Template Name", StdGenJnl."Journal Template Name");
        GenJnlBatch.SetRange(Name, JnlBatchName);

        if GenJnlBatch.FindFirst then;
    end;

    local procedure CopyGenJnlFromStdJnl(StdGenJnlLine: Record "Standard General Journal Line"; var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlManagement: Codeunit GenJnlManagement;
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
    begin
        GenJnlLine.Init;
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


    procedure InitializeRequest(DocumentTypesFrom: Option; PostingDateFrom: Date; DocumentDateFrom: Date)
    begin
        DocumentTypes := DocumentTypesFrom;
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
