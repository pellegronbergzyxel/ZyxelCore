Report 50027 "Export G/L Entries - Tax Audit"
{
    // 001. 27-11-20 ZY-LD 2020112710000042 - The fields that doesn´t exist in W1 is commented out.

    Caption = 'Export G/L Entries - Tax Audit';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.";
            dataitem(Customer; Customer)
            {
                DataItemTableView = sorting("No.");

                trigger OnAfterGetRecord()
                begin
                    DetailedBalance +=
                      WriteDetailedGLAccountBySource(GLAccount."No.", GLEntry."source type"::Customer, Customer."No.");
                end;

                trigger OnPreDataItem()
                begin
                    // IF NOT GLAccount."Detailed Balance" THEN
                    //  CurrReport.BREAK;
                end;
            }
            dataitem(Vendor; Vendor)
            {
                DataItemTableView = sorting("No.");

                trigger OnAfterGetRecord()
                begin
                    DetailedBalance +=
                      WriteDetailedGLAccountBySource(GLAccount."No.", GLEntry."source type"::Vendor, Vendor."No.");
                end;

                trigger OnPreDataItem()
                begin
                    // IF NOT GLAccount."Detailed Balance" THEN
                    //  CurrReport.BREAK;
                end;
            }
            dataitem("Bank Account"; "Bank Account")
            {
                DataItemTableView = sorting("No.");

                trigger OnAfterGetRecord()
                begin
                    DetailedBalance +=
                      WriteDetailedGLAccountBySource(GLAccount."No.", GLEntry."source type"::"Bank Account", "Bank Account"."No.");
                end;

                trigger OnPreDataItem()
                begin
                    // IF NOT GLAccount."Detailed Balance" THEN
                    //  CurrReport.BREAK;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                trigger OnAfterGetRecord()
                begin
                    if OpeningBalance - DetailedBalance <> 0 then
                        WriteGLAccountToFile(GLAccount, OpeningBalance - DetailedBalance);
                end;

                trigger OnPreDataItem()
                begin
                    // IF NOT GLAccount."Detailed Balance" THEN
                    //  CurrReport.BREAK;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpeningBalance := GetOpeningBalance;
                DetailedBalance := 0;
                if OpeningBalance = 0 then
                    exit;

                //IF NOT "Detailed Balance" THEN
                WriteGLAccountToFile(GLAccount, OpeningBalance);
            end;

            trigger OnPreDataItem()
            begin
                GLAccount.SetFilter(GLAccount."No.", GLAccNoFilter);
                if not IncludeOpeningBalances then
                    CurrReport.Break();
            end;
        }
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");

            trigger OnAfterGetRecord()
            begin
                if GLEntry."Posting Date" <> ClosingDate(GLEntry."Posting Date") then
                    ProcessGLEntry;
            end;

            trigger OnPreDataItem()
            begin
                GLEntry.SetRange(GLEntry."Posting Date", StartingDate, EndingDate);
                //SETRANGE("Entry Type","Entry Type"::Definitive);
                GLEntry.SetFilter(GLEntry."G/L Account No.", GLAccount.GetFilter("No."));
                GLEntry.SetFilter(GLEntry.Amount, '<>%1', 0);
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
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ClosingDates = true;
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ClosingDates = true;
                    }
                    field("Include Opening Balances"; IncludeOpeningBalances)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Opening Balances';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        ClientTempFileName: Text[250];
    begin
        ToFileName := GetFileName;
        Writer.Close;

        FileManagement.DownloadHandler(OutputFileName, '', '', FileManagement.GetToFilterText('', '.txt'), ToFileName);

        Clear(oStream);

        FileManagement.DeleteServerFile(OutputFileName);
        Message(FileCreatedMsg);
    end;

    trigger OnPreReport()
    begin
        if StartingDate = 0D then
            Error(MissingStartingDateErr);
        if EndingDate = 0D then
            Error(MissingEndingDateErr);
        if GLAccount.GetFilter("No.") <> '' then
            GLAccNoFilter := GLAccount.GetFilter("No.");
        GLEntry.SetRange("Posting Date", StartingDate, EndingDate);
        //GLEntry.SETRANGE("Entry Type",GLEntry."Entry Type"::Definitive);
        GLEntry.SetFilter("G/L Account No.", GLAccNoFilter);
        GLEntry.SetFilter(Amount, '<>%1', 0);
        if GLEntry.IsEmpty then
            Error(NoEntriestoExportErr);

        CreateServerFile;
        WriteHeaderToFile;
    end;

    var
        FileManagement: Codeunit "File Management";
        OutputFile: File;
        oStream: OutStream;
        Writer: dotnet StreamWriter;
        encoding: dotnet Encoding;
        OutputFileName: Text[250];
        StartingDate: Date;
        EndingDate: Date;
        GLAccNoFilter: Code[250];
        ToFileName: Text[250];
        ToFileFullName: Text[250];
        MissingStartingDateErr: label 'You must enter a Starting Date.';
        MissingEndingDateErr: label 'You must enter an Ending Date.';
        FileCreatedMsg: label 'The text file was created successfully.';
        NoEntriestoExportErr: label 'There are no entries to export within the defined filter. The file was not created.';
        InvalidWindowsChrStringTxt: label '""#%&*:<>?\/{|}~';
        ServerFileExtensionTxt: label 'TXT';
        IncludeOpeningBalances: Boolean;
        CurrentTransactionNo: Integer;
        CurrentSourceType: Enum "Gen. Journal Source Type";
        CustVendLedgEntryPartyNo: Code[20];
        CustVendLedgEntryPartyName: Text[50];
        CustVendLedgEntryFCYAmount: Text[250];
        CustVendLedgEntryCurrencyCode: Code[10];
        CustVendDocNoSet: Text;
        CustVendDateApplied: Date;
        PayRecAccount: Code[20];
        OpeningBalance: Decimal;
        DetailedBalance: Decimal;


    procedure Init(StartingDateValue: Date; EndingDateValue: Date; IncludeOpeningBalancesValue: Boolean; AccNoFilter: Code[250]; ReportFileNameValue: Text[250])
    begin
        StartingDate := StartingDateValue;
        EndingDate := EndingDateValue;
        IncludeOpeningBalances := IncludeOpeningBalancesValue;
        GLAccNoFilter := AccNoFilter;
        ToFileFullName := ReportFileNameValue;
    end;

    local procedure CreateServerFile()
    begin
        OutputFileName := FileManagement.ServerTempFileName(ServerFileExtensionTxt);
        if Exists(OutputFileName) then
            Erase(OutputFileName);

        OutputFile.TextMode(true);
        OutputFile.WriteMode(true);
        OutputFile.CreateOutstream(oStream);

        Writer := Writer.StreamWriter(OutputFileName, false, encoding.Default); // append = FALSE
    end;

    local procedure FindGLRegister(var GLRegister: Record "G/L Register"; EntryNo: Integer)
    begin
        GLRegister.SetFilter("From Entry No.", '<=%1', EntryNo);
        GLRegister.SetFilter("To Entry No.", '>=%1', EntryNo);
        GLRegister.FindFirst;
    end;

    local procedure FormatAmount(Amount: Decimal): Text[250]
    begin
        exit(Format(Amount, 0, '<Precision,2:2><Sign><Integer><Decimals><comma,,>'));
    end;

    local procedure GetAppliedBankLedgEntry(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var DocNo: Text; var AppliedDate: Date)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if CustLedgerEntry.Get(BankAccountLedgerEntry."Entry No.") then
            GetAppliedCustLedgEntry(CustLedgerEntry, DocNo, AppliedDate)
        else
            if VendorLedgerEntry.Get(BankAccountLedgerEntry.Get) then
                GetAppliedVendorLedgEntry(VendorLedgerEntry, DocNo, AppliedDate);
    end;

    local procedure GetAppliedCustLedgEntry(CustLedgerEntryOriginal: Record "Cust. Ledger Entry"; var DocNo: Text; var AppliedDate: Date)
    var
        DetailedCustLedgEntryOriginal: Record "Detailed Cust. Ledg. Entry";
        DetailedCustLedgEntryApplied: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntryApplied: Record "Cust. Ledger Entry";
    begin
        AppliedDate := 0D;
        DetailedCustLedgEntryOriginal.SetCurrentkey("Cust. Ledger Entry No.");
        DetailedCustLedgEntryOriginal.SetRange("Cust. Ledger Entry No.", CustLedgerEntryOriginal."Entry No.");
        DetailedCustLedgEntryOriginal.SetRange(Unapplied, false);
        if DetailedCustLedgEntryOriginal.FindSet then
            repeat
                if DetailedCustLedgEntryOriginal."Cust. Ledger Entry No." =
                   DetailedCustLedgEntryOriginal."Applied Cust. Ledger Entry No."
                then begin
                    DetailedCustLedgEntryApplied.Init;
                    DetailedCustLedgEntryApplied.SetCurrentkey(DetailedCustLedgEntryApplied."Applied Cust. Ledger Entry No.", DetailedCustLedgEntryApplied."Entry Type");
                    DetailedCustLedgEntryApplied.SetRange(DetailedCustLedgEntryApplied."Applied Cust. Ledger Entry No.", DetailedCustLedgEntryOriginal."Applied Cust. Ledger Entry No.");
                    DetailedCustLedgEntryApplied.SetRange(DetailedCustLedgEntryApplied."Entry Type", DetailedCustLedgEntryApplied."entry type"::Application);
                    DetailedCustLedgEntryApplied.SetRange(DetailedCustLedgEntryApplied.Unapplied, false);
                    if DetailedCustLedgEntryApplied.FindSet then
                        repeat
                            if DetailedCustLedgEntryApplied."Cust. Ledger Entry No." <> DetailedCustLedgEntryApplied."Applied Cust. Ledger Entry No." then
                                if CustLedgEntryApplied.Get(DetailedCustLedgEntryApplied."Cust. Ledger Entry No.") and
                                   (DetailedCustLedgEntryApplied."Posting Date" < EndingDate)
                                then begin
                                    AddAppliedDocNo(DocNo, CustLedgEntryApplied."Document No.");
                                    GetCustAppliedDate(CustLedgEntryApplied, AppliedDate);
                                end;
                        until DetailedCustLedgEntryApplied.Next() = 0;
                end
                else
                    if CustLedgEntryApplied.Get(DetailedCustLedgEntryOriginal."Applied Cust. Ledger Entry No.") then
                        if CustLedgEntryApplied."Posting Date" < EndingDate then begin
                            AddAppliedDocNo(DocNo, CustLedgEntryApplied."Document No.");
                            GetCustAppliedDate(CustLedgEntryApplied, AppliedDate);
                        end;
            until DetailedCustLedgEntryOriginal.Next() = 0;
    end;

    local procedure GetAppliedVendorLedgEntry(VendorLedgerEntryOriginal: Record "Vendor Ledger Entry"; var DocNo: Text; var AppliedDate: Date)
    var
        DetailedVendorLedgEntryOriginal: Record "Detailed Vendor Ledg. Entry";
        DetailedVendorLedgEntryApplied: Record "Detailed Vendor Ledg. Entry";
        VendorLedgEntryApplied: Record "Vendor Ledger Entry";
    begin
        AppliedDate := 0D;
        DetailedVendorLedgEntryOriginal.SetCurrentkey("Vendor Ledger Entry No.");
        DetailedVendorLedgEntryOriginal.SetRange("Vendor Ledger Entry No.", VendorLedgerEntryOriginal."Entry No.");
        DetailedVendorLedgEntryOriginal.SetRange(Unapplied, false);
        if DetailedVendorLedgEntryOriginal.FindSet then
            repeat
                if DetailedVendorLedgEntryOriginal."Vendor Ledger Entry No." =
                   DetailedVendorLedgEntryOriginal."Applied Vend. Ledger Entry No."
                then begin
                    DetailedVendorLedgEntryApplied.Init;
                    DetailedVendorLedgEntryApplied.SetCurrentkey(DetailedVendorLedgEntryApplied."Applied Vend. Ledger Entry No.", DetailedVendorLedgEntryApplied."Entry Type");
                    DetailedVendorLedgEntryApplied.SetRange(
                      DetailedVendorLedgEntryApplied."Applied Vend. Ledger Entry No.", DetailedVendorLedgEntryOriginal."Applied Vend. Ledger Entry No.");
                    DetailedVendorLedgEntryApplied.SetRange(DetailedVendorLedgEntryApplied."Entry Type", DetailedVendorLedgEntryApplied."entry type"::Application);
                    DetailedVendorLedgEntryApplied.SetRange(DetailedVendorLedgEntryApplied.Unapplied, false);
                    if DetailedVendorLedgEntryApplied.FindSet then
                        repeat
                            if DetailedVendorLedgEntryApplied."Vendor Ledger Entry No." <> DetailedVendorLedgEntryApplied."Applied Vend. Ledger Entry No." then
                                if VendorLedgEntryApplied.Get(DetailedVendorLedgEntryApplied."Vendor Ledger Entry No.") and
                                   (DetailedVendorLedgEntryApplied."Posting Date" < EndingDate)
                                then begin
                                    AddAppliedDocNo(DocNo, VendorLedgEntryApplied."Document No.");
                                    GetVendorAppliedDate(VendorLedgEntryApplied, AppliedDate);
                                end;
                        until DetailedVendorLedgEntryApplied.Next() = 0;
                end
                else
                    if VendorLedgEntryApplied.Get(DetailedVendorLedgEntryOriginal."Applied Vend. Ledger Entry No.") then
                        if VendorLedgEntryApplied."Posting Date" < EndingDate then begin
                            AddAppliedDocNo(DocNo, VendorLedgEntryApplied."Document No.");
                            GetVendorAppliedDate(VendorLedgEntryApplied, AppliedDate);
                        end;
            until DetailedVendorLedgEntryOriginal.Next() = 0;
    end;

    local procedure GetBankLedgerEntryData(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var PartyNo: Code[20]; var PartyName: Text[50]; var Amount: Text[250]; var CurrencyCode: Code[10]; DocNoApplied: Text; DateApplied: Date)
    var
        BankAcc: Record "Bank Account";
    begin
        if BankAcc.Get(BankAccountLedgerEntry."Bank Account No.") then begin
            PartyNo := BankAcc."No.";
            PartyName := BankAcc.Name;
        end;
        if BankAccountLedgerEntry."Currency Code" <> '' then begin
            Amount := FormatAmount(Abs(BankAccountLedgerEntry.Amount));
            CurrencyCode := BankAccountLedgerEntry."Currency Code";
        end;
        GetAppliedBankLedgEntry(BankAccountLedgerEntry, DocNoApplied, DateApplied);
    end;

    local procedure GetBankAccountData(BankAccountNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[50])
    var
        BankAccount: Record "Bank Account";
    begin
        if BankAccount.Get(BankAccountNo) then begin
            PartyNo := BankAccount."No.";
            PartyName := BankAccount.Name;
        end;
    end;

    local procedure AddAppliedDocNo(var AppliedDocNo: Text; DocNo: Code[20])
    begin
        if StrPos(';' + AppliedDocNo, ';' + DocNo + ';') = 0 then
            AppliedDocNo += DocNo + ';';
    end;

    local procedure GetCustAppliedDate(CustLedgEntryApplied: Record "Cust. Ledger Entry"; var AppliedDate: Date)
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if GetDetailedCustLedgEntry(DetailedCustLedgEntry, CustLedgEntryApplied."Entry No.") then begin
            if DetailedCustLedgEntry."Posting Date" > AppliedDate then
                AppliedDate := DetailedCustLedgEntry."Posting Date";
        end else
            AppliedDate := CustLedgEntryApplied."Posting Date";
    end;

    local procedure GetCustomerData(CustomerNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[50])
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then begin
            PartyNo := Customer."No.";
            PartyName := Customer.Name;
        end;
    end;

    local procedure GetDetailedCustLedgEntry(var DetailedCustLedgEntryApplied: Record "Detailed Cust. Ledg. Entry"; AppliedCustLedgerEntryNo: Integer): Boolean
    begin
        DetailedCustLedgEntryApplied.SetRange("Applied Cust. Ledger Entry No.", AppliedCustLedgerEntryNo);
        DetailedCustLedgEntryApplied.SetRange("Entry Type", DetailedCustLedgEntryApplied."entry type"::Application);
        DetailedCustLedgEntryApplied.SetRange(Unapplied, false);
        exit(DetailedCustLedgEntryApplied.FindFirst);
    end;

    local procedure GetDetailedVendorLedgEntry(var DetailedVendorLedgEntryApplied: Record "Detailed Vendor Ledg. Entry"; AppliedVendorLedgerEntryNo: Integer): Boolean
    begin
        DetailedVendorLedgEntryApplied.SetRange("Applied Vend. Ledger Entry No.", AppliedVendorLedgerEntryNo);
        DetailedVendorLedgEntryApplied.SetRange("Entry Type", DetailedVendorLedgEntryApplied."entry type"::Application);
        DetailedVendorLedgEntryApplied.SetRange(Unapplied, false);
        exit(DetailedVendorLedgEntryApplied.FindFirst);
    end;

    local procedure GetVendorAppliedDate(VendorLedgEntryApplied: Record "Vendor Ledger Entry"; var AppliedDate: Date)
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        if GetDetailedVendorLedgEntry(DetailedVendorLedgEntry, VendorLedgEntryApplied."Entry No.") then begin
            if DetailedVendorLedgEntry."Posting Date" > AppliedDate then
                AppliedDate := DetailedVendorLedgEntry."Posting Date";
        end else
            AppliedDate := VendorLedgEntryApplied."Posting Date";
    end;

    local procedure GetFileName(): Text[250]
    var
        CompanyInformation: Record "Company Information";
        FileName: Text[250];
    begin
        CompanyInformation.Get;
        CompanyInformation.TestField("Registration No.");
        FileName := Format(CompanyInformation.GetSIREN) +
          'FEC' +
          GetFormattedDate(EndingDate) +
          '.txt';
        exit(DelChr(FileName, '=', InvalidWindowsChrStringTxt));
    end;

    local procedure GetFormattedDate(GLEntryDate: Date): Text[8]
    begin
        if GLEntryDate <> 0D then
            exit(Format(GLEntryDate, 8, '<Year4><Month,2><Day,2>'));
        exit('')
    end;

    local procedure GetOpeningBalance(): Decimal
    begin
        GLAccount.SetFilter("Date Filter", StrSubstNo('..%1', ClosingDate(CalcDate('<-1D>', StartingDate))));
        GLAccount.CalcFields("Balance at Date");
        exit(GLAccount."Balance at Date")
    end;

    local procedure GetPayablesAccount(VendorPostingGroupCode: Code[10]): Code[20]
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        VendorPostingGroup.Get(VendorPostingGroupCode);
        exit(VendorPostingGroup."Payables Account")
    end;

    local procedure GetReceivablesAccount(CustomerPostingGroupCode: Code[10]): Code[20]
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        CustomerPostingGroup.Get(CustomerPostingGroupCode);
        exit(CustomerPostingGroup."Receivables Account")
    end;

    local procedure GetSourceCodeDesc("Code": Code[10]): Text[50]
    var
        SourceCode: Record "Source Code";
    begin
        if SourceCode.Get(Code) then
            exit(SourceCode.Description);
    end;

    local procedure GetVendorData(VendorNo: Code[20]; var PartyNo: Code[20]; var PartyName: Text[50])
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(VendorNo) then begin
            PartyNo := Vendor."No.";
            PartyName := Vendor.Name;
        end;
    end;


    procedure GetLedgerEntryDataForCustVend(TransactionNo: Integer; SourceType: Enum "Gen. Journal Source Type"; var PartyNo: Code[20]; var PartyName: Text[50]; var FCYAmount: Text[250]; var CurrencyCode: Code[10]; var DocNoSet: Text; var DateApplied: Date)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GLEntry: Record "G/L Entry";
        CountOfGLEntriesInTransaction: Integer;
        LedgerAmount: Decimal;
    begin
        DocNoSet := '';
        DateApplied := 0D;
        if SourceType = GLEntry."source type"::Customer then begin
            CustLedgerEntry.SetRange("Transaction No.", TransactionNo);
            if CustLedgerEntry.FindFirst then begin
                CustLedgerEntry.SetFilter("Customer No.", '<>%1', CustLedgerEntry."Customer No.");
                if CustLedgerEntry.FindFirst then begin
                    PartyName := 'multi-clients';
                    PartyNo := '*';
                    FCYAmount := '';
                    exit;
                end;

                CustLedgerEntry.SetRange("Customer No.");
                GetCustomerData(CustLedgerEntry."Customer No.", PartyNo, PartyName);
                PayRecAccount := GetReceivablesAccount(CustLedgerEntry."Customer Posting Group");
                CountOfGLEntriesInTransaction := GetTransPayRecEntriesCount(CustLedgerEntry."Transaction No.", PayRecAccount);
                if CustLedgerEntry.FindSet then
                    repeat
                        GetAppliedCustLedgEntry(CustLedgerEntry, DocNoSet, DateApplied);
                        if (CustLedgerEntry."Currency Code" <> '') and (CountOfGLEntriesInTransaction = 1) then begin
                            CustLedgerEntry.CalcFields("Original Amount");
                            LedgerAmount += CustLedgerEntry."Original Amount";
                            CurrencyCode := CustLedgerEntry."Currency Code";
                            FCYAmount := FormatAmount(Abs(LedgerAmount));
                        end;
                    until CustLedgerEntry.Next() = 0;
                DocNoSet := DelChr(DocNoSet, '>', ';');
            end;
            exit;
        end;

        VendorLedgerEntry.SetRange("Transaction No.", TransactionNo);
        if VendorLedgerEntry.FindFirst then begin
            VendorLedgerEntry.SetFilter("Vendor No.", '<>%1', VendorLedgerEntry."Vendor No.");
            if VendorLedgerEntry.FindFirst then begin
                PartyName := 'multi-fournisseurs';
                PartyNo := '*';
                FCYAmount := '';
                exit;
            end;

            VendorLedgerEntry.SetRange("Vendor No.");
            GetVendorData(VendorLedgerEntry."Vendor No.", PartyNo, PartyName);
            PayRecAccount := GetPayablesAccount(VendorLedgerEntry."Vendor Posting Group");
            CountOfGLEntriesInTransaction := GetTransPayRecEntriesCount(VendorLedgerEntry."Transaction No.", PayRecAccount);
            if VendorLedgerEntry.FindSet then
                repeat
                    GetAppliedVendorLedgEntry(VendorLedgerEntry, DocNoSet, DateApplied);
                    if (VendorLedgerEntry."Currency Code" <> '') and (CountOfGLEntriesInTransaction = 1) then begin
                        VendorLedgerEntry.CalcFields("Original Amount");
                        LedgerAmount += VendorLedgerEntry."Original Amount";
                        CurrencyCode := VendorLedgerEntry."Currency Code";
                        FCYAmount := FormatAmount(Abs(LedgerAmount));
                    end;
                until VendorLedgerEntry.Next() = 0;
            DocNoSet := DelChr(DocNoSet, '>', ';');
        end;
    end;

    local procedure GetTransPayRecEntriesCount(TransactionNo: Integer; PayRecAccount: Code[20]): Integer
    var
        GLEntryCount: Integer;
        GLAccNoFilter: Code[250];
    begin
        GLAccNoFilter := GLEntry.GetFilter("G/L Account No.");
        GLEntry.SetRange("G/L Account No.", PayRecAccount);
        GLEntry.SetRange("Transaction No.", TransactionNo);
        GLEntryCount := GLEntry.Count;
        GLEntry.SetRange("Transaction No.");
        GLEntry.SetFilter("G/L Account No.", GLAccNoFilter);
        exit(GLEntryCount)
    end;

    local procedure GetCustomerUnrealizedAmount(GLAccountNo: Code[20]; CustomerNo: Code[20]): Decimal
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        begin
            DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Customer No.", CustomerNo);
            DetailedCustLedgEntry.SetFilter(DetailedCustLedgEntry."Entry Type", '%1|%2', DetailedCustLedgEntry."entry type"::"Unrealized Gain", DetailedCustLedgEntry."entry type"::"Unrealized Loss");
            DetailedCustLedgEntry.SetFilter(DetailedCustLedgEntry."Posting Date", '..%1', StartingDate - 1);
            DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry.Unapplied, false);
            //SETRANGE("Curr. Adjmt. G/L Account No.",GLAccountNo);
            DetailedCustLedgEntry.CalcSums(DetailedCustLedgEntry."Amount (LCY)");
            exit(DetailedCustLedgEntry."Amount (LCY)");
        end;
    end;

    local procedure GetVendorUnrealizedAmount(GLAccountNo: Code[20]; VendorNo: Code[20]): Decimal
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        begin
            DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Vendor No.", VendorNo);
            DetailedVendorLedgEntry.SetFilter(DetailedVendorLedgEntry."Entry Type", '%1|%2', DetailedVendorLedgEntry."entry type"::"Unrealized Gain", DetailedVendorLedgEntry."entry type"::"Unrealized Loss");
            DetailedVendorLedgEntry.SetFilter(DetailedVendorLedgEntry."Posting Date", '..%1', StartingDate - 1);
            DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry.Unapplied, false);
            //SETRANGE("Curr. Adjmt. G/L Account No.",GLAccountNo);
            DetailedVendorLedgEntry.CalcSums(DetailedVendorLedgEntry."Amount (LCY)");
            exit(DetailedVendorLedgEntry."Amount (LCY)");
        end;
    end;

    local procedure ProcessGLEntry()
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        GLRegister: Record "G/L Register";
        PartyNo: Code[20];
        PartyName: Text[50];
        FCYAmount: Text[250];
        CurrencyCode: Code[10];
        DocNoApplied: Text;
        DateApplied: Date;
    begin
        if (GLEntry."Transaction No." <> CurrentTransactionNo) or (GLEntry."Source Type" <> CurrentSourceType) then begin
            ResetTransactionData;
            GetLedgerEntryDataForCustVend(
              GLEntry."Transaction No.", GLEntry."Source Type",
              CustVendLedgEntryPartyNo,
              CustVendLedgEntryPartyName,
              CustVendLedgEntryFCYAmount,
              CustVendLedgEntryCurrencyCode,
              CustVendDocNoSet,
              CustVendDateApplied);

            CurrentTransactionNo := GLEntry."Transaction No.";
            CurrentSourceType := GLEntry."Source Type";
        end;

        if BankAccountLedgerEntry.Get(GLEntry."Entry No.") then
            GetBankLedgerEntryData(BankAccountLedgerEntry, PartyNo, PartyName, FCYAmount, CurrencyCode, DocNoApplied, DateApplied);

        case true of
            GLEntry."G/L Account No." = PayRecAccount:
                begin
                    PartyNo := CustVendLedgEntryPartyNo;
                    PartyName := CustVendLedgEntryPartyName;
                    FCYAmount := CustVendLedgEntryFCYAmount;
                    CurrencyCode := CustVendLedgEntryCurrencyCode;
                    DocNoApplied := CustVendDocNoSet;
                    DateApplied := CustVendDateApplied;
                end;
            (GLEntry."Source Type" = GLEntry."source type"::Customer) and (GLEntry."Source No." <> ''):
                GetCustomerData(GLEntry."Source No.", PartyNo, PartyName);
            (GLEntry."Source Type" = GLEntry."source type"::Vendor) and (GLEntry."Source No." <> ''):
                GetVendorData(GLEntry."Source No.", PartyNo, PartyName);
        end;

        FindGLRegister(GLRegister, GLEntry."Entry No.");

        WriteGLEntryToFile(
          GLRegister."No.",
          GLRegister."Creation Date",
          PartyNo,
          PartyName,
          FCYAmount,
          CurrencyCode,
          DocNoApplied,
          DateApplied);
    end;

    local procedure ResetTransactionData()
    begin
        CustVendLedgEntryPartyNo := '';
        CustVendLedgEntryPartyName := '';
        CustVendLedgEntryFCYAmount := '';
        CustVendLedgEntryCurrencyCode := '';
        PayRecAccount := '';
    end;

    local procedure WriteHeaderToFile()
    begin
        Writer.WriteLine('JournalCode|JournalLib|EcritureNum|EcritureDate|CompteNum|CompteLib|CompAuxNum|CompAuxLib|PieceRef|' +
          'PieceDate|EcritureLib|Debit|Credit|EcritureLet|DateLet|ValidDate|Montantdevise|Idevise');
    end;

    local procedure WriteGLAccountToFile(GLAccount: Record "G/L Account"; OpeningBalance: Decimal)
    var
        CreditAmount: Decimal;
        DebitAmount: Decimal;
    begin
        if OpeningBalance > 0 then
            DebitAmount := OpeningBalance
        else
            CreditAmount := Abs(OpeningBalance);

        Writer.WriteLine('00000|' +
          'BALANCE OUVERTURE|' +
          '0|' +
          GetFormattedDate(StartingDate) + '|' +
          GLAccount."No." + '|' +
          GLAccount.Name + '|' +
          '||' +
          '00000|' +
          GetFormattedDate(StartingDate) + '|' +
          'BAL OUV ' + GLAccount.Name + '|' +
          FormatAmount(DebitAmount) + '|' +
          FormatAmount(CreditAmount) + '|' +
          '||' +
          GetFormattedDate(StartingDate) +
          '||');
    end;

    local procedure WriteGLEntryToFile(GLRegisterNo: Integer; GLRegisterCreationDate: Date; PartyNo: Code[20]; PartyName: Text[50]; FCYAmount: Text[250]; CurrencyCode: Code[10]; DocNoSet: Text; DateApplied: Date)
    begin
        begin
            GLEntry.CalcFields(GLEntry."G/L Account Name");
            Writer.WriteLine(
              GLEntry."Source Code" + '|' +
              GetSourceCodeDesc(GLEntry."Source Code") + '|' +
              Format(GLRegisterNo) + '|' +
              GetFormattedDate(GLEntry."Posting Date") + '|' +
              GLEntry."G/L Account No." + '|' +
              GLEntry."G/L Account Name" + '|' +
              Format(PartyNo) + '|' +
              PartyName + '|' +
              GLEntry."Document No." + '|' +
              GetFormattedDate(GLEntry."Document Date") + '|' +
              GLEntry.Description + '|' +
              FormatAmount(GLEntry."Debit Amount") + '|' +
              FormatAmount(GLEntry."Credit Amount") + '|' +
              DocNoSet + '|' +
              GetFormattedDate(DateApplied) + '|' +
              GetFormattedDate(GLRegisterCreationDate) + '|' +
              FCYAmount + '|' +
              CurrencyCode);
        end;
    end;

    local procedure WriteDetailedGLAccountBySource(GLAccountNo: Code[20]; SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]) TotalAmt: Decimal
    var
        GLEntry: Record "G/L Entry";
        PartyNo: Code[20];
        PartyName: Text[50];
        DebitAmt: Decimal;
        CreditAmt: Decimal;
        UnrealizedAmt: Decimal;
    begin
        GLEntry.SetFilter("Posting Date", '..%1', StartingDate - 1);
        GLEntry.SetFilter("G/L Account No.", GLAccountNo);
        GLEntry.SetRange("Source Type", SourceType);
        GLEntry.SetRange("Source No.", SourceNo);
        case SourceType of
            GLEntry."source type"::Customer:
                GLEntry.SetFilter("Bal. Account Type", '<>%1', GLEntry."bal. account type"::Customer);
            GLEntry."source type"::Vendor:
                GLEntry.SetFilter("Bal. Account Type", '<>%1', GLEntry."bal. account type"::Vendor);
            GLEntry."source type"::"Bank Account":
                GLEntry.SetFilter("Bal. Account Type", '<>%1', GLEntry."bal. account type"::"Bank Account");
        end;
        GLEntry.CalcSums(Amount);

        case SourceType of
            GLEntry."source type"::Customer:
                UnrealizedAmt := GetCustomerUnrealizedAmount(GLAccountNo, SourceNo);
            GLEntry."source type"::Vendor:
                UnrealizedAmt := GetVendorUnrealizedAmount(GLAccountNo, SourceNo);
        end;

        TotalAmt := GLEntry.Amount + UnrealizedAmt;
        if TotalAmt = 0 then
            exit;

        if TotalAmt > 0 then
            DebitAmt := TotalAmt
        else
            CreditAmt := -TotalAmt;

        case SourceType of
            GLEntry."source type"::Customer:
                GetCustomerData(SourceNo, PartyNo, PartyName);
            GLEntry."source type"::Vendor:
                GetVendorData(SourceNo, PartyNo, PartyName);
            GLEntry."source type"::"Bank Account":
                GetBankAccountData(SourceNo, PartyNo, PartyName);
        end;

        Writer.WriteLine('00000|' +
          'BALANCE OUVERTURE|' +
          '0|' +
          GetFormattedDate(StartingDate) + '|' +
          GLAccount."No." + '|' +
          GLAccount.Name + '|' +
          PartyNo + '|' +
          PartyName + '|' +
          '00000|' +
          GetFormattedDate(StartingDate) + '|' +
          'BAL OUV ' + PartyName + '|' +
          FormatAmount(DebitAmt) + '|' +
          FormatAmount(CreditAmt) + '|' +
          '||' +
          GetFormattedDate(StartingDate) +
          '||');
    end;
}
