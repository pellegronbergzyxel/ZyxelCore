codeunit 50035 "Exch. Rate Adjmt. Proc. Zyxel"
{
    EventSubscriberInstance = Manual;
    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Exch. Rate Adjmt. Reg." = rimd,
                  TableData "Exch. Rate Adjmt. Ledg. Entry" = rimd,
                  TableData "VAT Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd;
    TableNo = "Exch. Rate Adjmt. Parameters";

    trigger OnRun()
    begin
        ExchRateAdjmtParameters.Copy(Rec);

        SourceCodeSetup.Get();
        GetGLSetup();

        if ExchRateAdjmtReg.FindLast() then
            LastRegNo := ExchRateAdjmtReg."No.";

        CheckPostingDate();

        Window.Open(
            AdjustingExchangeRatesTxt +
            BankAccountProgressBarTxt +
            CustomerProgressBarTxt +
            VendorProgressBarTxt +
            AdjustmentProgressBarTxt);

        if Rec."Adjust G/L Accounts" then
            SetAdditionalReportingCurrency();

        RunAdjustment();

        if Rec."Preview Posting" then
            GenJnlPostPreview.ThrowError();

        if GenJnlPostLine.IsGLEntryInconsistent() then
            GenJnlPostLine.ShowInconsistentEntries()
        else begin
            UpdateAnalysisView.UpdateAll(0, true);
            if not ExchRateAdjmtParameters."Hide UI" then
                if ExchRateAdjmtReg."No." > LastRegNo then
                    Message(RatesAdjustedMsg)
                else
                    Message(NothingToAdjustMsg)
        end;
    end;

    var
        Currency: Record Currency;
        ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        TempDtldCustLedgEntrySums: Record "Detailed Cust. Ledg. Entry" temporary;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        TempDtldVendLedgEntrySums: Record "Detailed Vendor Ledg. Entry" temporary;
        ExchRateAdjmtReg: Record "Exch. Rate Adjmt. Reg.";
        TempExchRateAdjmtLedgEntry: Record "Exch. Rate Adjmt. Ledg. Entry" temporary;
        SourceCodeSetup: Record "Source Code Setup";
        TempExchRateAdjmtBuffer: Record "Exch. Rate Adjmt. Buffer" temporary;
        TempExchRateAdjmtBuffer2: Record "Exch. Rate Adjmt. Buffer" temporary;
        TempCurrencyToAdjust: Record Currency temporary;
        AddRepCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrExchRate2: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        VATEntryTotalBase: Record "VAT Entry";
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        TotalAdjBase: Decimal;
        TotalAdjBaseLCY: Decimal;
        TotalAdjAmount: Decimal;
        GainsAmount: Decimal;
        LossesAmount: Decimal;
        CurrAdjBase: Decimal;
        CurrAdjBaseLCY: Decimal;
        CurrAdjAmount: Decimal;
        CustNo: Decimal;
        CustNoTotal: Decimal;
        VendNo: Decimal;
        VendNoTotal: Decimal;
        BankAccNo: Decimal;
        BankAccNoTotal: Decimal;
        GLAccNo: Decimal;
        GLAccNoTotal: Decimal;
        GLAmtTotal: Decimal;
        GLAddCurrAmtTotal: Decimal;
        GLNetChangeTotal: Decimal;
        GLAddCurrNetChangeTotal: Decimal;
        GLNetChangeBase: Decimal;
        GLAddCurrNetChangeBase: Decimal;
        AdjPerEntry: Boolean;
        AddCurrCurrencyFactor: Decimal;
        VATEntryNoTotal: Decimal;
        VATEntryNo: Decimal;
        NewEntryNo: Integer;
        NewRegLedgEntryNo: Integer;
        LastRegNo: Integer;
        GLSetupRead: Boolean;
        MaxAdjExchRateBufIndex: Integer;
        AdjustingExchangeRatesTxt: Label 'Adjusting exchange rates...\\';
        BankAccountProgressBarTxt: Label 'Bank Account    @1@@@@@@@@@@@@@\\';
        CustomerProgressBarTxt: Label 'Customer        @2@@@@@@@@@@@@@\';
        VendorProgressBarTxt: Label 'Vendor          @3@@@@@@@@@@@@@\';
        AdjustmentProgressBarTxt: Label 'Adjustment      #4#############', Comment = '#4 - progress bar';
        AdjustingVATEntriesTxt: Label 'Adjusting VAT Entries...\\';
        VATEntryProgressBarTxt: Label 'VAT Entry    @1@@@@@@@@@@@@@';
        AdjustingGeneralLedgerTxt: Label 'Adjusting general ledger...\\';
        GLAccountProgressBarTxt: Label 'G/L Account    @1@@@@@@@@@@@@@';
        PostingDescriptionTxt: Label 'Adjmt. of %1 %2, Ex.Rate Adjust.', Comment = '%1 = Currency Code, %2= Adjust Amount';
        ExchangeRateAdjmtMustBeErr: Label '%1 on %2 %3 must be %4. When this %2 is used in %5, the exchange rate adjustment is defined in the %6 field in the %7. %2 %3 is used in the %8 field in the %5. ', Comment = '%1, %2, &%3, %4, %5, %6, %7, %8 - field names';
        PostingDateNotInPeriodErr: Label 'This posting date cannot be entered because it does not occur within the adjustment period. Reenter the posting date.';
        RatesAdjustedMsg: Label 'One or more currency exchange rates have been adjusted.';
        NothingToAdjustMsg: Label 'There is nothing to adjust.';

    local procedure RunAdjustment()
    begin
        AdjustCurrency(ExchRateAdjmtParameters);

        if ExchRateAdjmtParameters."Adjust Customers" then
            AdjustCustomers(ExchRateAdjmtParameters);

        if ExchRateAdjmtParameters."Adjust Vendors" then
            AdjustVendors(ExchRateAdjmtParameters);

        AdjustGLAccountsAndVATEntries(ExchRateAdjmtParameters);

        OnAfterRunAdjustment(ExchRateAdjmtParameters);
    end;

    local procedure AdjustCurrency(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.SetFilter("No.", ExchRateAdjmtParameters.GetFilter("Bank Account Filter"));
        BankAccount.FilterGroup(2);
        BankAccount.SetFilter("Currency Code", '<>%1', '');
        BankAccount.FilterGroup(0);
        BankAccNoTotal := BankAccount.Count();
        BankAccount.Reset();

        Currency.SetView(ExchRateAdjmtParameters."Currency Filter");
        if Currency.FindSet() then
            repeat
                Currency."Last Date Adjusted" := ExchRateAdjmtParameters."Posting Date";
                Currency.Modify();

                Currency."Currency Factor" := CurrExchRate.ExchangeRateAdjmt(ExchRateAdjmtParameters."Posting Date", Currency.Code);

                TempCurrencyToAdjust := Currency;
                TempCurrencyToAdjust.Insert();

                BankAccount.SetCurrentKey("Bank Acc. Posting Group");
                BankAccount.SetRange("Currency Code", Currency.Code);
                BankAccount.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
                if BankAccount.FindSet() then
                    repeat
                        BankAccNo := BankAccNo + 1;
                        Window.Update(1, Round(BankAccNo / BankAccNoTotal * 10000, 1));
                        ProcessBankAccount(BankAccount, Currency);
                    until BankAccount.Next() = 0;
            until Currency.Next() = 0;
    end;

    local procedure AdjustCustomers(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    var
        Customer: Record Customer;
    begin
        CustNo := 0;
        GetNewCustLedgEntryNo();

        CustNoTotal := Customer.Count();
        Customer.SetView(ExchRateAdjmtParameters."Customer Filter");
        Customer.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        if Customer.FindSet() then
            repeat
                CustNo := CustNo + 1;
                Window.Update(2, Round(CustNo / CustNoTotal * 10000, 1));

                ProcessCustomerAdjustment(Customer);
            until Customer.Next() = 0;

        if CustNo <> 0 then
            HandlePostAdjmt("Exch. Rate Adjmt. Account Type"::Customer);
    end;

    local procedure AdjustVendors(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary);
    var
        Vendor: Record Vendor;
    begin
        VendNo := 0;
        GetNewVendLedgEntryNo();

        VendNoTotal := Vendor.Count();
        Vendor.SetView(ExchRateAdjmtParameters."Vendor Filter");
        Vendor.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        if Vendor.FindSet() then
            repeat
                VendNo := VendNo + 1;
                Window.Update(2, Round(VendNo / VendNoTotal * 10000, 1));

                ProcessVendorAdjustment(Vendor);
            until Vendor.Next() = 0;

        if VendNo <> 0 then
            HandlePostAdjmt("Exch. Rate Adjmt. Account Type"::Vendor);
    end;

    local procedure AdjustGLAccountsAndVATEntries(ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters")
    begin
        OnBeforeAdjustGLAccountsAndVATEntries(ExchRateAdjmtParameters, Currency, GenJnlPostLine);

        if ExchRateAdjmtParameters."Adjust G/L Accounts" and
            (GLSetup."VAT Exchange Rate Adjustment" <> GLSetup."VAT Exchange Rate Adjustment"::"No Adjustment")
        then
            AdjustVAT(ExchRateAdjmtParameters);

        if ExchRateAdjmtParameters."Adjust G/L Accounts" then
            AdjustGLAccounts(ExchRateAdjmtParameters);
    end;

    local procedure AdjustVAT(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    var
        VATEntry: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        Window.Open(AdjustingVATEntriesTxt + VATEntryProgressBarTxt);

        VATEntryNoTotal := VATEntry.Count();
        IF VATEntryNoTotal = 0 then  // 23-09-24 ZY-LD 000
            VATEntryNoTotal := 1;  // 23-09-24 ZY-LD 000
        SetVATEntryFilters(VATEntry, ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        if VATPostingSetup.FindSet() then
            repeat
                VATEntryNo := VATEntryNo + 1;
                Window.Update(1, Round(VATEntryNo / VATEntryNoTotal * 10000, 1));

                ProcessVATAdjustment(VATPostingSetup);
            until VATPostingSetup.Next() = 0;
    end;

    local procedure AdjustGLAccounts(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    var
        GLAccount: Record "G/L Account";
    begin
        Window.Open(AdjustingGeneralLedgerTxt + GLAccountProgressBarTxt);

        GLAccNo := 0;
        GLAccNoTotal := GLAccount.Count();
        GLAccount.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        if GLAccount.FindSet() then
            repeat
                GLAccNo := GLAccNo + 1;
                Window.Update(1, Round(GLAccNo / GLAccNoTotal * 10000, 1));
                if GLAccount."Exchange Rate Adjustment" <> GLAccount."Exchange Rate Adjustment"::"No Adjustment" then
                    ProcessGLAccountAdjustment(GLAccount);
            until GLAccount.Next() = 0;

        PostGLAccAdjmtTotal();
    end;

    local procedure SetAdditionalReportingCurrency()
    var
        GLAccount: Record "G/L Account";
        VATPostingSetup2: Record "VAT Posting Setup";
        TaxJurisdiction2: Record "Tax Jurisdiction";
    begin
        GetGLSetup();
        GLSetup.TestField("Additional Reporting Currency");

        AddRepCurrency.Get(GetAdditionalReportingCurrency());
        GLAccount.Get(AddRepCurrency.GetRealizedGLGainsAccount());
        GLAccount.TestField("Exchange Rate Adjustment", GLAccount."Exchange Rate Adjustment"::"No Adjustment");

        GLAccount.Get(AddRepCurrency.GetRealizedGLLossesAccount());
        GLAccount.TestField("Exchange Rate Adjustment", GLAccount."Exchange Rate Adjustment"::"No Adjustment");

        if VATPostingSetup2.Find('-') then
            repeat
                if VATPostingSetup2."VAT Calculation Type" <> "Tax Calculation Type"::"Sales Tax" then begin
                    CheckExchRateAdjustment(
                        VATPostingSetup2."Purchase VAT Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Purchase VAT Account"));
                    CheckExchRateAdjustment(
                        VATPostingSetup2."Reverse Chrg. VAT Acc.", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Reverse Chrg. VAT Acc."));
                    CheckExchRateAdjustment(
                        VATPostingSetup2."Purch. VAT Unreal. Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Purch. VAT Unreal. Account"));
                    CheckExchRateAdjustment(
                        VATPostingSetup2."Reverse Chrg. VAT Unreal. Acc.", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Reverse Chrg. VAT Unreal. Acc."));
                    CheckExchRateAdjustment(
                        VATPostingSetup2."Sales VAT Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Sales VAT Account"));
                    CheckExchRateAdjustment(
                        VATPostingSetup2."Sales VAT Unreal. Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Sales VAT Unreal. Account"));
                end;
            until VATPostingSetup2.Next() = 0;

        if TaxJurisdiction2.Find('-') then
            repeat
                CheckExchRateAdjustment(
                    TaxJurisdiction2."Tax Account (Purchases)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Tax Account (Purchases)"));
                CheckExchRateAdjustment(
                    TaxJurisdiction2."Reverse Charge (Purchases)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Reverse Charge (Purchases)"));
                CheckExchRateAdjustment(
                    TaxJurisdiction2."Unreal. Tax Acc. (Purchases)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Unreal. Tax Acc. (Purchases)"));
                CheckExchRateAdjustment(
                    TaxJurisdiction2."Unreal. Rev. Charge (Purch.)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Unreal. Rev. Charge (Purch.)"));
                CheckExchRateAdjustment(
                    TaxJurisdiction2."Tax Account (Sales)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Tax Account (Sales)"));
                CheckExchRateAdjustment(
                    TaxJurisdiction2."Unreal. Tax Acc. (Sales)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Unreal. Tax Acc. (Sales)"));
            until TaxJurisdiction2.Next() = 0;

        AddCurrCurrencyFactor :=
            CurrExchRate2.ExchangeRateAdjmt(ExchRateAdjmtParameters."Posting Date", GetAdditionalReportingCurrency());
    end;

    local procedure ProcessBankAccount(var BankAccount: Record "Bank Account"; Currency: Record Currency)
    var
        NextBankAccount: Record "Bank Account";
        GroupTotal: Boolean;
    begin
        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        TempDimBuf.Reset();
        TempDimBuf.DeleteAll();

        BankAccount.CalcFields("Balance at Date", "Balance at Date (LCY)");
        OnProcessBankAccountOnAfterCalcFields(BankAccount, Currency);
        CurrAdjBase := BankAccount."Balance at Date";
        CurrAdjBaseLCY := BankAccount."Balance at Date (LCY)";
        CurrAdjAmount :=
            Round(
            CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                ExchRateAdjmtParameters."Posting Date", Currency.Code, BankAccount."Balance at Date", Currency."Currency Factor")) -
            BankAccount."Balance at Date (LCY)";

        if CurrAdjAmount <> 0 then begin
            PostBankAccAdjmt(BankAccount);

            TotalAdjBase := TotalAdjBase + CurrAdjBase;
            TotalAdjBaseLCY := TotalAdjBaseLCY + CurrAdjBaseLCY;
            TotalAdjAmount := TotalAdjAmount + CurrAdjAmount;
            Window.Update(4, TotalAdjAmount);
        end;

        NextBankAccount.Copy(BankAccount);
        if NextBankAccount.Next() = 1 then begin
            if NextBankAccount."Bank Acc. Posting Group" <> BankAccount."Bank Acc. Posting Group" then
                GroupTotal := true;
        end else
            GroupTotal := true;

        if GroupTotal then
            if TotalAdjAmount <> 0 then begin
                PostBankAccAdjmtGroupTotal(BankAccount, TotalAdjBase, TotalAdjBaseLCY, TotalAdjAmount);
                TotalAdjBase := 0;
                TotalAdjBaseLCY := 0;
                TotalAdjAmount := 0;
            end;
    end;

    local procedure PostBankAccAdjmtGroupTotal(BankAccount: Record "Bank Account"; TotalAdjBase: Decimal; TotalAdjBaseLCY: Decimal; TotalAdjamount: Decimal)
    begin
        ExchRateAdjmtBufferUpdate(
            BankAccount."Currency Code", BankAccount."Bank Acc. Posting Group", GetBankAccountNo(BankAccount),
            TotalAdjBase, TotalAdjBaseLCY, TotalAdjAmount, 0, 0, 0, ExchRateAdjmtParameters."Posting Date", '', 0);
        InsertExchRateAdjmtReg(
            "Exch. Rate Adjmt. Account Type"::"Bank Account", BankAccount."Bank Acc. Posting Group", BankAccount."Currency Code");
        ResetTempAdjmtBuffer();
    end;

    local procedure ProcessGLAccountAdjustment(var GLAccount: Record "G/L Account")
    begin
        if GLAccount."Exchange Rate Adjustment" = GLAccount."Exchange Rate Adjustment"::"No Adjustment" then
            exit;

        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        GLAccount.CalcFields("Net Change", "Additional-Currency Net Change");
        case GLAccount."Exchange Rate Adjustment" of
            GLAccount."Exchange Rate Adjustment"::"Adjust Amount":
                PostGLAccAdjmt(
                    GLAccount."No.", GLAccount."Exchange Rate Adjustment"::"Adjust Amount",
                    Round(
                    CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                        ExchRateAdjmtParameters."Posting Date", GetAdditionalReportingCurrency(),
                        GLAccount."Additional-Currency Net Change", AddCurrCurrencyFactor) -
                    GLAccount."Net Change"),
                    GLAccount."Net Change",
                    GLAccount."Additional-Currency Net Change");
            GLAccount."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                PostGLAccAdjmt(
                    GLAccount."No.", GLAccount."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                    Round(
                    CurrExchRate2.ExchangeAmtLCYToFCY(
                        ExchRateAdjmtParameters."Exchange Rate Date", GetAdditionalReportingCurrency(),
                        GLAccount."Net Change", AddCurrCurrencyFactor) -
                    GLAccount."Additional-Currency Net Change",
                    AddRepCurrency."Amount Rounding Precision"),
                    GLAccount."Net Change",
                    GLAccount."Additional-Currency Net Change");
        end;
    end;

    local procedure ProcessVATAdjustment(var VATPostingSetup: Record "VAT Posting Setup")
    var
        TotalVATEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.SetRange("VAT Bus. Posting Group", VATPostingSetup."VAT Bus. Posting Group");
        VATEntry.SetRange("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");

        if VATPostingSetup."VAT Calculation Type" <> "Tax Calculation Type"::"Sales Tax" then begin
            AdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Purchase, false);
            if (TotalVATEntry.Amount <> 0) or (TotalVATEntry."Additional-Currency Amount" <> 0) then begin
                AdjustVATAccount(
                    VATPostingSetup.GetPurchAccount(false),
                    TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
                    VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
                if VATPostingSetup."VAT Calculation Type" = "Tax Calculation Type"::"Reverse Charge VAT" then
                    AdjustVATAccount(
                        VATPostingSetup.GetRevChargeAccount(false),
                        -TotalVATEntry.Amount, -TotalVATEntry."Additional-Currency Amount",
                        -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
            end;
            if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
                (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
            then begin
                VATPostingSetup.TestField("Unrealized VAT Type");
                AdjustVATAccount(
                    VATPostingSetup.GetPurchAccount(true),
                    TotalVATEntry."Remaining Unrealized Amount",
                    TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                    VATEntryTotalBase."Remaining Unrealized Amount",
                    VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                if VATPostingSetup."VAT Calculation Type" = "Tax Calculation Type"::"Reverse Charge VAT" then
                    AdjustVATAccount(
                        VATPostingSetup.GetRevChargeAccount(true),
                        -TotalVATEntry."Remaining Unrealized Amount",
                        -TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                        -VATEntryTotalBase."Remaining Unrealized Amount",
                        -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;

            AdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Sale, false);
            if (TotalVATEntry.Amount <> 0) or (TotalVATEntry."Additional-Currency Amount" <> 0) then
                AdjustVATAccount(
                    VATPostingSetup.GetSalesAccount(false),
                    TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
                    VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
            if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
                (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
            then begin
                VATPostingSetup.TestField("Unrealized VAT Type");
                AdjustVATAccount(
                    VATPostingSetup.GetSalesAccount(true),
                    TotalVATEntry."Remaining Unrealized Amount",
                    TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                    VATEntryTotalBase."Remaining Unrealized Amount",
                    VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;
        end else begin
            if TaxJurisdiction.Find('-') then
                repeat
                    VATEntry.SetRange("Tax Jurisdiction Code", TaxJurisdiction.Code);
                    AdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Purchase, false);
                    AdjustPurchTax(TaxJurisdiction, TotalVATEntry, false);
                    AdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Purchase, true);
                    AdjustPurchTax(TaxJurisdiction, TotalVATEntry, true);
                    AdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Sale, false);
                    AdjustSalesTax(TaxJurisdiction, TotalVATEntry);
                until TaxJurisdiction.Next() = 0;
            VATEntry.SetRange("Tax Jurisdiction Code");
        end;
        Clear(VATEntryTotalBase);
    end;

    local procedure SetVATEntryFilters(var VATEntry: Record "VAT Entry"; StartDate: Date; EndDate: Date)
    begin
        if not
            VATEntry.SetCurrentKey(
                Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
        then
            VATEntry.SetCurrentKey(
                Type, Closed, "Tax Jurisdiction Code", "Use Tax", "Posting Date");
        VATEntry.SetRange(Closed, false);
        VATEntry.SetRange("Posting Date", StartDate, EndDate);
    end;

    local procedure ProcessCustomerAdjustment(var Customer: Record Customer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntryToAdjust: Record "Detailed Cust. Ledg. Entry";
        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
    begin
        TotalAdjAmount := 0;
        PrepareTempCustLedgEntry(Customer, TempCustLedgerEntry);

        if TempCustLedgerEntry.Find('-') then
            repeat
                TempDtldCustLedgEntrySums.DeleteAll();

                CustLedgerEntry.Get(TempCustLedgerEntry."Entry No.");
                if ShouldAdjustCustLedgEntry(CustLedgerEntry) then begin
                    AdjustCustomerLedgerEntry(Customer, CustLedgerEntry, ExchRateAdjmtParameters."Posting Date", false);

                    SetDtldCustLedgEntryFilters(DtldCustLedgEntryToAdjust, CustLedgerEntry);
                    if DtldCustLedgEntryToAdjust.FindSet() then
                        repeat
                            AdjustCustomerLedgerEntry(Customer, CustLedgerEntry, DtldCustLedgEntryToAdjust."Posting Date", true);
                        until DtldCustledgEntryToAdjust.Next() = 0;
                end;
            until TempCustLedgerEntry.Next() = 0;

        OnAfterProcessCustomerAdjustment(TempCustLedgerEntry);
    end;

    local procedure ShouldAdjustCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry") ShouldAdjust: Boolean
    begin
        ShouldAdjust := true;

        OnAfterShouldAdjustCustLedgEntry(CustLedgEntry, ShouldAdjust);
    end;

    local procedure GetNewCustLedgEntryNo()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        DtldCustLedgEntry.LockTable();
        CustLedgerEntry.LockTable();

        CustNo := 0;

        if DtldCustLedgEntry.Find('+') then
            NewEntryNo := DtldCustLedgEntry."Entry No." + 1
        else
            NewEntryNo := 1;
    end;

    local procedure SetDtldCustLedgEntryFilters(var DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry"; CustLedgEntry2: Record "Cust. Ledger Entry")
    begin
        DtldCustLedgEntry2.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry2.SetRange("Cust. Ledger Entry No.", CustLedgEntry2."Entry No.");
        DtldCustLedgEntry2.SetFilter("Posting Date", '%1..', CalcDate('<+1D>', ExchRateAdjmtParameters."Posting Date"));

        OnAfterSetDtldCustLedgEntryFilters(DtldCustLedgEntry2, CustLedgEntry2);
    end;

    local procedure ProcessVendorAdjustment(var Vendor: Record Vendor)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntryToAdjust: Record "Detailed Vendor Ledg. Entry";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
    begin
        TotalAdjAmount := 0;
        PrepareTempVendLedgEntry(Vendor, TempVendorLedgerEntry);

        if TempVendorLedgerEntry.Find('-') then
            repeat
                TempDtldVendLedgEntrySums.DeleteAll();

                VendorLedgerEntry.Get(TempVendorLedgerEntry."Entry No.");
                if ShouldAdjustVendLedgEntry(VendorLedgerEntry) then begin
                    AdjustVendorLedgerEntry(Vendor, VendorLedgerEntry, ExchRateAdjmtParameters."Posting Date", false);

                    SetDtldVendLedgEntryFilters(DtldVendLedgEntryToAdjust, VendorLedgerEntry);
                    if DtldVendLedgEntryToAdjust.FindSet() then
                        repeat
                            AdjustVendorLedgerEntry(Vendor, VendorLedgerEntry, ExchRateAdjmtParameters."Posting Date", true);
                        until DtldVendLedgEntryToAdjust.Next() = 0;
                end;
            until TempVendorLedgerEntry.Next() = 0;

        OnAfterProcessVendorAdjustment(TempVendorLedgerEntry);
    end;

    local procedure ShouldAdjustVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry") ShouldAdjust: Boolean
    begin
        ShouldAdjust := true;

        OnAfterShouldAdjustVendLedgEntry(VendLedgEntry, ShouldAdjust);
    end;

    local procedure GetNewVendLedgEntryNo()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        DtldVendLedgEntry.LockTable();
        VendorLedgerEntry.LockTable();

        VendNo := 0;

        if DtldVendLedgEntry.Find('+') then
            NewEntryNo := DtldVendLedgEntry."Entry No." + 1
        else
            NewEntryNo := 1;
    end;

    local procedure SetDtldVendLedgEntryFilters(var DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; VendLedgEntry2: Record "Vendor Ledger Entry")
    begin
        DtldVendLedgEntry2.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry2.SetRange("Vendor Ledger Entry No.", VendLedgEntry2."Entry No.");
        DtldVendLedgEntry2.SetFilter("Posting Date", '%1..', CalcDate('<+1D>', ExchRateAdjmtParameters."Posting Date"));

        OnAfterSetDtldVendLedgEntryFilters(DtldVendLedgEntry2, VendLedgEntry2);
    end;

    local procedure PostAdjmt(ExchRateAdjmtBuffer: Record "Exch. Rate Adjmt. Buffer"; TempDimSetEntry: Record "Dimension Set Entry" temporary): Integer
    begin
        exit(
            PostAdjmt(
                ExchRateAdjmtBuffer."Account No.", ExchRateAdjmtBuffer."Adjmt. Amount",
                ExchRateAdjmtBuffer."Adjmt. Base", ExchRateAdjmtBuffer."Currency Code", TempDimSetEntry,
                ExchRateAdjmtBuffer."Posting Date", ExchRateAdjmtBuffer."IC Partner Code")
        );
    end;

    local procedure PostAdjmt(GLAccNo: Code[20]; PostingAmount: Decimal; AdjBase2: Decimal; CurrencyCode2: Code[10]; var DimSetEntry: Record "Dimension Set Entry"; PostingDate2: Date; ICCode: Code[20]) TransactionNo: Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        defaultdim: Record "Default Dimension";
        GLsetup: Record "General Ledger Setup";
    begin
        if PostingAmount = 0 then
            exit;

        GenJnlLine.Init();
        GenJnlLine.Validate("Posting Date", PostingDate2);
        GenJnlLine."Document No." := ExchRateAdjmtParameters."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine.Validate("Account No.", GLAccNo);

        // 495872 : defualt dim 
        GLsetup.get();
        defaultdim.setrange("Table ID", database::"G/L Account");
        defaultdim.setrange("No.", GLAccNo);
        defaultdim.Setfilter("Dimension Value Code", '<>%1', '');
        if defaultdim.findset then
            repeat
                case defaultdim."Dimension Code" OF
                    GLsetup."Shortcut Dimension 1 Code":
                        GenJnlLine.ValidateShortcutDimCode(1, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 2 Code":
                        GenJnlLine.ValidateShortcutDimCode(2, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 3 Code":
                        GenJnlLine.ValidateShortcutDimCode(3, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 4 Code":
                        GenJnlLine.ValidateShortcutDimCode(4, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 5 Code":
                        GenJnlLine.ValidateShortcutDimCode(5, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 6 Code":
                        GenJnlLine.ValidateShortcutDimCode(6, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 7 Code":
                        GenJnlLine.ValidateShortcutDimCode(7, defaultdim."Dimension Value Code");
                    GLsetup."Shortcut Dimension 8 Code":
                        GenJnlLine.ValidateShortcutDimCode(8, defaultdim."Dimension Value Code");
                end;
            Until defaultdim.next = 0;

        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine.Description :=
PadStr(StrSubstNo(ExchRateAdjmtParameters."Posting Description", CurrencyCode2, AdjBase2), MaxStrLen(GenJnlLine.Description));
        GenJnlLine.Validate(Amount, PostingAmount);
        GenJnlLine."Source Currency Code" := CurrencyCode2;
        GenJnlLine."IC Partner Code" := ICCode;
        if CurrencyCode2 = GetAdditionalReportingCurrency() then
            GenJnlLine."Source Currency Amount" := 0;
        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
        GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
        GenJnlLine."System-Created Entry" := true;
        GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
        TransactionNo := PostGenJnlLine(GenJnlLine, TempDimSetEntry);
    end;

    local procedure PostBankAccAdjmt(BankAccount: Record "Bank Account")
    var
        GenJnlLine: Record "Gen. Journal Line";
        AccNo: Code[20];
    begin
        GenJnlLine.Init();
        GenJnlLine.Validate("Posting Date", ExchRateAdjmtParameters."Posting Date");
        GenJnlLine."Document No." := ExchRateAdjmtParameters."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine.Validate("Account No.", BankAccount."No.");
        GenJnlLine.Description :=
          PadStr(StrSubstNo(ExchRateAdjmtParameters."Posting Description", Currency.Code, CurrAdjBase), MaxStrLen(GenJnlLine.Description));
        GenJnlLine.Validate(Amount, 0);
        GenJnlLine."Amount (LCY)" := CurrAdjAmount;
        GenJnlLine."Source Currency Code" := BankAccount."Currency Code";
        if BankAccount."Currency Code" = GetAdditionalReportingCurrency() then
            GenJnlLine."Source Currency Amount" := 0;
        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::"Bank Account";
        GenJnlLine."Source No." := BankAccount."No.";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
        GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
        GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
        CopyDimSetEntryToDimBuf(TempDimSetEntry, TempDimBuf);
        PostGenJnlLine(GenJnlLine, TempDimSetEntry);

        if CurrAdjAmount <> 0 then begin
            GetDimSetEntry(GetDimCombID(TempDimBuf), TempDimSetEntry);
            if CurrAdjAmount > 0 then
                AccNo := GetRealizedGainsAccount(Currency)
            else
                AccNo := GetRealizedLossesAccount(Currency);
            PostAdjmt(
                AccNo, -CurrAdjAmount, CurrAdjBase, BankAccount."Currency Code", TempDimSetEntry,
                ExchRateAdjmtParameters."Posting Date", '');
            InsertExchRateAdjmtBankAccLedgerEntry(BankAccount);
        end;
    end;

    local procedure GetRealizedGainsAccount(Currency: Record Currency) AccountNo: Code[20]
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetRealizedGainsAccount(Currency, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        exit(Currency.GetRealizedGainsAccount());
    end;

    local procedure GetRealizedLossesAccount(Currency: Record Currency) AccountNo: Code[20]
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetRealizedLossesAccount(Currency, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        exit(Currency.GetRealizedLossesAccount());
    end;

    local procedure PostCustAdjmt(ExchRateAdjmtBuffer: Record "Exch. Rate Adjmt. Buffer"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary; var TempDimSetEntry: Record "Dimension Set Entry" temporary)
    begin
        TempDtldCVLedgEntryBuf."Transaction No." := PostAdjmt(ExchRateAdjmtBuffer, TempDimSetEntry);
        if TempDtldCVLedgEntryBuf.Insert() then;
        InsertExchRateAdjmtReg(
            "Exch. Rate Adjmt. Account Type"::Customer, ExchRateAdjmtBuffer."Posting Group", ExchRateAdjmtBuffer."Currency Code");
        TempDtldCVLedgEntryBuf.Get(TempDtldCVLedgEntryBuf."Entry No.");
        TempDtldCVLedgEntryBuf."Exch. Rate Adjmt. Reg. No." := ExchRateAdjmtReg."No.";
        TempDtldCVLedgEntryBuf.Modify();
    end;

    local procedure PostVendAdjmt(ExchRateAdjmtBuffer: Record "Exch. Rate Adjmt. Buffer"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary; var TempDimSetEntry: Record "Dimension Set Entry" temporary)
    begin
        TempDtldCVLedgEntryBuf."Transaction No." := PostAdjmt(ExchRateAdjmtBuffer, TempDimSetEntry);
        if TempDtldCVLedgEntryBuf.Insert() then;
        InsertExchRateAdjmtReg(
            "Exch. Rate Adjmt. Account Type"::Vendor, ExchRateAdjmtBuffer."Posting Group", ExchRateAdjmtBuffer."Currency Code");
        TempDtldCVLedgEntryBuf.Get(TempDtldCVLedgEntryBuf."Entry No.");
        TempDtldCVLedgEntryBuf."Exch. Rate Adjmt. Reg. No." := ExchRateAdjmtReg."No.";
        TempDtldCVLedgEntryBuf.Modify();
    end;

    local procedure GetDimSetEntry(EntryNo: Integer; var TempDimSetEntry: Record "Dimension Set Entry" temporary)
    begin
        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        TempDimBuf.Reset();
        TempDimBuf.DeleteAll();
        DimBufMgt.GetDimensions(EntryNo, TempDimBuf);
        DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
    end;

    local procedure InsertExchRateAdjmtReg(AdjustAccType: Enum "Exch. Rate Adjmt. Account Type"; PostingGrCode: Code[20];
                                                              CurrencyCode: Code[10])
    var
        ExchRateAdjmtLedgEntry: Record "Exch. Rate Adjmt. Ledg. Entry";
    begin
        if TempCurrencyToAdjust.Code <> CurrencyCode then
            TempCurrencyToAdjust.Get(CurrencyCode);

        ExchRateAdjmtReg."No." := ExchRateAdjmtReg."No." + 1;
        ExchRateAdjmtReg."Creation Date" := ExchRateAdjmtParameters."Posting Date";
        ExchRateAdjmtReg."Account Type" := AdjustAccType;
        ExchRateAdjmtReg."Posting Group" := PostingGrCode;
        ExchRateAdjmtReg."Currency Code" := TempCurrencyToAdjust.Code;
        ExchRateAdjmtReg."Currency Factor" := TempCurrencyToAdjust."Currency Factor";
        ExchRateAdjmtReg."Adjusted Base" := TempExchRateAdjmtBuffer."Adjmt. Base";
        ExchRateAdjmtReg."Adjusted Base (LCY)" := TempExchRateAdjmtBuffer."Adjmt. Base (LCY)";
        ExchRateAdjmtReg."Adjusted Amt. (LCY)" := TempExchRateAdjmtBuffer."Adjmt. Amount";
        ExchRateAdjmtReg.Insert();

        TempExchRateAdjmtLedgEntry.Reset();
        if TempExchRateAdjmtLedgEntry.Find('-') then
            repeat
                ExchRateAdjmtLedgEntry := TempExchRateAdjmtLedgEntry;
                ExchRateAdjmtLedgEntry."Register No." := ExchRateAdjmtReg."No.";
                ExchRateAdjmtLedgEntry.Insert();
            until TempExchRateAdjmtLedgEntry.Next() = 0;
        TempExchRateAdjmtLedgEntry.DeleteAll();
    end;

    local procedure GetBankAccountNo(BankAccount: Record "Bank Account") AccountNo: Code[20]
    var
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetBankAccountNo(BankAccount, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        if AccountNo = '' then begin
            BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group");
            BankAccountPostingGroup.TestField("G/L Account No.");
            AccountNo := BankAccountPostingGroup."G/L Account No.";
        end;
    end;

    local procedure GetCustAccountNo(CustLedgerEntry: Record "Cust. Ledger Entry") AccountNo: Code[20]
    var
        CustPostingGr: Record "Customer Posting Group";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetCustAccountNo(CustLedgerEntry, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        if AccountNo = '' then
            GetLocalCustAccountNo(CustLedgerEntry, AccountNo);

        if AccountNo = '' then begin
            CustPostingGr.Get(CustLedgerEntry."Customer Posting Group");
            AccountNo := CustPostingGr.GetReceivablesAccount();
        end;
    end;

    local procedure GetLocalCustAccountNo(CustLedgerEntry: Record "Cust. Ledger Entry"; AccountNo: Code[20]): Boolean
    var
        IsHandled: Boolean;
    begin
        // reserved for local implementation
        IsHandled := false;
        OnBeforeGetLocalCustAccountNo(CustLedgerEntry, AccountNo, IsHandled);
        exit(IsHandled);
    end;

    local procedure GetVendAccountNo(VendLedgerEntry: Record "Vendor Ledger Entry") AccountNo: Code[20]
    var
        VendPostingGr: Record "Vendor Posting Group";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetVendAccountNo(VendLedgerEntry, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        if AccountNo = '' then
            GetLocalVendAccountNo(VendLedgerEntry, AccountNo);

        if AccountNo = '' then begin
            VendPostingGr.Get(VendLedgerEntry."Vendor Posting Group");
            AccountNo := VendPostingGr.GetPayablesAccount();
        end;
    end;

    local procedure GetLocalVendAccountNo(VendLedgerEntry: Record "Vendor Ledger Entry"; AccountNo: Code[20]): Boolean
    var
        IsHandled: Boolean;
    begin
        // reserved for local implementation
        IsHandled := false;
        OnBeforeGetLocalVendAccountNo(VendLedgerEntry, AccountNo, IsHandled);
        exit(IsHandled);
    end;

    local procedure ExchRateAdjmtBufferUpdate(CurrencyCode2: Code[10]; PostingGroup2: Code[20]; AccountNo2: Code[20]; AdjBase2: Decimal; AdjBaseLCY2: Decimal; AdjAmount2: Decimal; GainsAmount2: Decimal; LossesAmount2: Decimal; DimEntryNo2: Integer; PostingDate2: Date; ICCode2: Code[20]; EntryNo2: Integer): Integer
    var
        Found: Boolean;
    begin
        TempExchRateAdjmtBuffer.Reset();
        TempExchRateAdjmtBuffer.SetRange("Currency Code", CurrencyCode2);
        TempExchRateAdjmtBuffer.SetRange("Posting Group", PostingGroup2);
        TempExchRateAdjmtBuffer.SetRange("Account No.", AccountNo2);
        TempExchRateAdjmtBuffer.SetRange("Dimension Entry No.", DimEntryNo2);
        TempExchRateAdjmtBuffer.SetRange("IC Partner Code", ICCode2);
        TempExchRateAdjmtBuffer.SetRange("Posting Date", PostingDate2);
        if AdjPerEntry then
            TempExchRateAdjmtBuffer.SetRange("Entry No.", EntryNo2);

        Found := TempExchRateAdjmtBuffer.FindFirst();

        if not Found then begin
            TempExchRateAdjmtBuffer.BuildPrimaryKey();
            TempExchRateAdjmtBuffer."Currency Code" := CurrencyCode2;
            TempExchRateAdjmtBuffer."Posting Group" := PostingGroup2;
            TempExchRateAdjmtBuffer."Account No." := AccountNo2;
            TempExchRateAdjmtBuffer."Dimension Entry No." := DimEntryNo2;
            TempExchRateAdjmtBuffer."IC Partner Code" := ICCode2;
            TempExchRateAdjmtBuffer."Posting Date" := PostingDate2;
            TempExchRateAdjmtBuffer."Adjmt. Base" := AdjBase2;
            TempExchRateAdjmtBuffer."Adjmt. Base (LCY)" := AdjBaseLCY2;
            TempExchRateAdjmtBuffer."Adjmt. Amount" := AdjAmount2;
            TempExchRateAdjmtBuffer."Gains Amount" := GainsAmount2;
            TempExchRateAdjmtBuffer."Losses Amount" := LossesAmount2;
            if AdjPerEntry then
                TempExchRateAdjmtBuffer."Entry No." := EntryNo2;
            MaxAdjExchRateBufIndex += 1;
            TempExchRateAdjmtBuffer.Index := MaxAdjExchRateBufIndex;
            TempExchRateAdjmtBuffer.Insert();
        end else begin
            TempExchRateAdjmtBuffer."Adjmt. Base" += AdjBase2;
            TempExchRateAdjmtBuffer."Adjmt. Base (LCY)" += AdjBaseLCY2;
            TempExchRateAdjmtBuffer."Adjmt. Amount" += AdjAmount2;
            TempExchRateAdjmtBuffer."Gains Amount" += GainsAmount2;
            TempExchRateAdjmtBuffer."Losses Amount" += LossesAmount2;
            TempExchRateAdjmtBuffer.Modify();
        end;

        exit(TempExchRateAdjmtBuffer.Index);
    end;

    local procedure HandlePostAdjmt(AdjustAccType: Enum "Exch. Rate Adjmt. Account Type")
    var
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
    begin
        TempExchRateAdjmtBuffer.Reset;  // 01-03-24 ZY-LD 001
        SummarizeExchRateAdjmtBuffer(TempExchRateAdjmtBuffer, TempExchRateAdjmtBuffer2);
        TempExchRateAdjmtBuffer2.Reset;  // 01-03-24 ZY-LD 001


        // Post per posting group and per currency
        if TempExchRateAdjmtBuffer2.Find('-') then
            repeat
                TempExchRateAdjmtBuffer.SetRange("Currency Code", TempExchRateAdjmtBuffer2."Currency Code");
                TempExchRateAdjmtBuffer.SetRange("Dimension Entry No.", TempExchRateAdjmtBuffer2."Dimension Entry No.");
                TempExchRateAdjmtBuffer.SetRange("Posting Date", TempExchRateAdjmtBuffer2."Posting Date");
                TempExchRateAdjmtBuffer.SetRange("IC Partner Code", TempExchRateAdjmtBuffer2."IC Partner Code");
                TempExchRateAdjmtBuffer.Find('-');

                GetDimSetEntry(TempExchRateAdjmtBuffer."Dimension Entry No.", TempDimSetEntry);
                repeat
                    TempDtldCVLedgEntryBuf.Init();
                    TempDtldCVLedgEntryBuf."Entry No." := TempExchRateAdjmtBuffer.Index;
                    if TempExchRateAdjmtBuffer."Adjmt. Amount" <> 0 then
                        case AdjustAccType of
                            "Exch. Rate Adjmt. Account Type"::Customer:
                                PostCustAdjmt(TempExchRateAdjmtBuffer, TempDtldCVLedgEntryBuf, TempDimSetEntry);
                            "Exch. Rate Adjmt. Account Type"::Vendor:
                                PostVendAdjmt(TempExchRateAdjmtBuffer, TempDtldCVLedgEntryBuf, TempDimSetEntry);
                        end;
                until TempExchRateAdjmtBuffer.Next() = 0;

                TempCurrencyToAdjust.Get(TempExchRateAdjmtBuffer2."Currency Code");
                if TempExchRateAdjmtBuffer2."Gains Amount" <> 0 then
                    PostAdjmt(
                        GetUnrealizedGainsAccount(TempCurrencyToAdjust),
                        -TempExchRateAdjmtBuffer2."Gains Amount", -TempExchRateAdjmtBuffer2."Adjmt. Base",
                        TempExchRateAdjmtBuffer2."Currency Code", TempDimSetEntry,
                        TempExchRateAdjmtBuffer2."Posting Date", TempExchRateAdjmtBuffer2."IC Partner Code");
                if TempExchRateAdjmtBuffer2."Losses Amount" <> 0 then
                    PostAdjmt(
                        GetUnrealizedLossesAccount(TempCurrencyToAdjust),
                        -TempExchRateAdjmtBuffer2."Losses Amount", -TempExchRateAdjmtBuffer2."Adjmt. Base",
                        TempExchRateAdjmtBuffer2."Currency Code", TempDimSetEntry,
                        TempExchRateAdjmtBuffer2."Posting Date", TempExchRateAdjmtBuffer2."IC Partner Code");
            until TempExchRateAdjmtBuffer2.Next() = 0;

        case AdjustAccType of
            "Exch. Rate Adjmt. Account Type"::Customer:
                InsertCustLedgEntries(TempDtldCustLedgEntry, TempDtldCVLedgEntryBuf);
            "Exch. Rate Adjmt. Account Type"::Vendor:
                InsertVendLedgEntries(TempDtldVendLedgEntry, TempDtldCVLedgEntryBuf);
        end;

        ResetTempAdjmtBuffer();
        ResetTempAdjmtBuffer2();

        TempDtldCustLedgEntry.Reset();
        TempDtldCustLedgEntry.DeleteAll();
        TempDtldVendLedgEntry.Reset();
        TempDtldVendLedgEntry.DeleteAll();
    end;

    local procedure SummarizeExchRateAdjmtBuffer(var TempExchRateAdjmtBuffer: Record "Exch. Rate Adjmt. Buffer" temporary; var TempExchRateAdjmtBuffer2: Record "Exch. Rate Adjmt. Buffer" temporary)
    var
        Found: Boolean;
    begin
        if TempExchRateAdjmtBuffer.Find('-') then
            // Summarize per currency and dimension combination
            repeat
                TempExchRateAdjmtBuffer2.Reset();
                TempExchRateAdjmtBuffer2.SetRange("Currency Code", TempExchRateAdjmtBuffer."Currency Code");
                TempExchRateAdjmtBuffer2.SetRange("Dimension Entry No.", TempExchRateAdjmtBuffer."Dimension Entry No.");
                TempExchRateAdjmtBuffer2.SetRange("Posting Date", TempExchRateAdjmtBuffer."Posting Date");
                TempExchRateAdjmtBuffer2.SetRange("IC Partner Code", TempExchRateAdjmtBuffer."IC Partner Code");
                if AdjPerEntry then
                    TempExchRateAdjmtBuffer2.SetRange("Entry No.", TempExchRateAdjmtBuffer."Entry No.");

                Found := TempExchRateAdjmtBuffer2.FindFirst();

                if not Found then begin
                    TempExchRateAdjmtBuffer2.BuildPrimaryKey();
                    TempExchRateAdjmtBuffer2."Currency Code" := TempExchRateAdjmtBuffer."Currency Code";
                    TempExchRateAdjmtBuffer2."Dimension Entry No." := TempExchRateAdjmtBuffer."Dimension Entry No.";
                    TempExchRateAdjmtBuffer2."Posting Date" := TempExchRateAdjmtBuffer."Posting Date";
                    TempExchRateAdjmtBuffer2."IC Partner Code" := TempExchRateAdjmtBuffer."IC Partner Code";
                    if AdjPerEntry then
                        TempExchRateAdjmtBuffer2."Entry No." := TempExchRateAdjmtBuffer."Entry No.";
                    TempExchRateAdjmtBuffer2."Adjmt. Base" := TempExchRateAdjmtBuffer."Adjmt. Base";
                    TempExchRateAdjmtBuffer2."Gains Amount" := TempExchRateAdjmtBuffer."Gains Amount";
                    TempExchRateAdjmtBuffer2."Losses Amount" := TempExchRateAdjmtBuffer."Losses Amount";
                    TempExchRateAdjmtBuffer2.Insert();
                end else begin
                    TempExchRateAdjmtBuffer2."Adjmt. Base" += TempExchRateAdjmtBuffer."Adjmt. Base";
                    TempExchRateAdjmtBuffer2."Gains Amount" += TempExchRateAdjmtBuffer."Gains Amount";
                    TempExchRateAdjmtBuffer2."Losses Amount" += TempExchRateAdjmtBuffer."Losses Amount";
                    TempExchRateAdjmtBuffer2.Modify();
                end;
            until TempExchRateAdjmtBuffer.Next() = 0;
    end;

    local procedure InsertCustLedgEntries(var TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary)
    var
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        GLEntry: Record "G/L Entry";
        LastEntryNo: Integer;
        LastTransactionNo: Integer;
    begin
        GLEntry.GetLastEntry(LastEntryNo, LastTransactionNo);

        if TempDtldCustLedgEntry.Find('-') then
            repeat
                if TempDtldCVLedgEntryBuf.Get(TempDtldCustLedgEntry."Transaction No.") then
                    TempDtldCustLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                else
                    TempDtldCustLedgEntry."Transaction No." := LastTransactionNo;
                DtldCustLedgEntry2 := TempDtldCustLedgEntry;
                DtldCustLedgEntry2."Exch. Rate Adjmt. Reg. No." := TempDtldCVLedgEntryBuf."Exch. Rate Adjmt. Reg. No.";
                DtldCustLedgEntry2.Insert(true);
            until TempDtldCustLedgEntry.Next() = 0;
    end;

    local procedure InsertVendLedgEntries(var TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary)
    var
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        GLEntry: Record "G/L Entry";
        LastEntryNo: Integer;
        LastTransactionNo: Integer;
    begin
        GLEntry.GetLastEntry(LastEntryNo, LastTransactionNo);

        if TempDtldVendLedgEntry.Find('-') then
            repeat
                if TempDtldCVLedgEntryBuf.Get(TempDtldVendLedgEntry."Transaction No.") then
                    TempDtldVendLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                else
                    TempDtldVendLedgEntry."Transaction No." := LastTransactionNo;
                DtldVendLedgEntry2 := TempDtldVendLedgEntry;
                DtldVendLedgEntry2."Exch. Rate Adjmt. Reg. No." := TempDtldCVLedgEntryBuf."Exch. Rate Adjmt. Reg. No.";
                DtldVendLedgEntry2.Insert(true);
            until TempDtldVendLedgEntry.Next() = 0;
    end;

    local procedure PrepareTempCustLedgEntry(var Customer: Record Customer; var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    var
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        TempCustLedgerEntry.DeleteAll();

        Currency.CopyFilter(Code, CustLedgerEntry2."Currency Code");
        CustLedgerEntry2.FilterGroup(2);
        CustLedgerEntry2.SetFilter("Currency Code", '<>%1', '');
        CustLedgerEntry2.FilterGroup(0);

        DtldCustLedgEntry2.Reset();
        DtldCustLedgEntry2.SetCurrentKey("Customer No.", "Posting Date", "Entry Type");
        DtldCustLedgEntry2.SetRange("Customer No.", Customer."No.");
        DtldCustLedgEntry2.SetRange("Posting Date", CalcDate('<+1D>', ExchRateAdjmtParameters."End Date"), DMY2Date(31, 12, 9999));
        if DtldCustLedgEntry2.Find('-') then
            repeat
                CustLedgerEntry2."Entry No." := DtldCustLedgEntry2."Cust. Ledger Entry No.";
                if CustLedgerEntry2.Find('=') then
                    if (CustLedgerEntry2."Posting Date" >= ExchRateAdjmtParameters."Start Date") and
                        (CustLedgerEntry2."Posting Date" <= ExchRateAdjmtParameters."End Date")
                    then begin
                        TempCustLedgerEntry."Entry No." := CustLedgerEntry2."Entry No.";
                        if TempCustLedgerEntry.Insert() then;
                    end;
            until DtldCustLedgEntry2.Next() = 0;

        CustLedgerEntry2.SetCurrentKey("Customer No.", Open);
        CustLedgerEntry2.SetRange("Customer No.", Customer."No.");
        CustLedgerEntry2.SetRange(Open, true);
        CustLedgerEntry2.SetRange("Posting Date", 0D, ExchRateAdjmtParameters."End Date");
        if CustLedgerEntry2.Find('-') then
            repeat
                TempCustLedgerEntry."Entry No." := CustLedgerEntry2."Entry No.";
                if TempCustLedgerEntry.Insert() then;
            until CustLedgerEntry2.Next() = 0;
        CustLedgerEntry2.Reset();
    end;

    local procedure PrepareTempVendLedgEntry(var Vendor: Record Vendor; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary);
    var
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        TempVendorLedgerEntry.DeleteAll();

        Currency.CopyFilter(Code, VendorLedgerEntry2."Currency Code");
        VendorLedgerEntry2.FilterGroup(2);
        VendorLedgerEntry2.SetFilter("Currency Code", '<>%1', '');
        VendorLedgerEntry2.FilterGroup(0);

        DtldVendLedgEntry2.Reset();
        DtldVendLedgEntry2.SetCurrentKey("Vendor No.", "Posting Date", "Entry Type");
        DtldVendLedgEntry2.SetRange("Vendor No.", Vendor."No.");
        DtldVendLedgEntry2.SetRange("Posting Date", CalcDate('<+1D>', ExchRateAdjmtParameters."End Date"), DMY2Date(31, 12, 9999));
        if DtldVendLedgEntry2.Find('-') then
            repeat
                VendorLedgerEntry2."Entry No." := DtldVendLedgEntry2."Vendor Ledger Entry No.";
                if VendorLedgerEntry2.Find('=') then
                    if (VendorLedgerEntry2."Posting Date" >= ExchRateAdjmtParameters."Start Date") and
                        (VendorLedgerEntry2."Posting Date" <= ExchRateAdjmtParameters."End Date")
                    then begin
                        TempVendorLedgerEntry."Entry No." := VendorLedgerEntry2."Entry No.";
                        if TempVendorLedgerEntry.Insert() then;
                    end;
            until DtldVendLedgEntry2.Next() = 0;

        VendorLedgerEntry2.SetCurrentKey("Vendor No.", Open);
        VendorLedgerEntry2.SetRange("Vendor No.", Vendor."No.");
        VendorLedgerEntry2.SetRange(Open, true);
        VendorLedgerEntry2.SetRange("Posting Date", 0D, ExchRateAdjmtParameters."End Date");
        if VendorLedgerEntry2.Find('-') then
            repeat
                TempVendorLedgerEntry."Entry No." := VendorLedgerEntry2."Entry No.";
                if TempVendorLedgerEntry.Insert() then;
            until VendorLedgerEntry2.Next() = 0;
        VendorLedgerEntry2.Reset();
    end;

    local procedure AdjustVATEntries(var VATEntry: Record "VAT Entry"; var TotalVATEntry: Record "VAT Entry"; VATType: Enum "General Posting Type"; UseTax: Boolean)
    begin
        Clear(TotalVATEntry);
        VATEntry.SetRange(Type, VATType);
        VATEntry.SetRange("Use Tax", UseTax);
        if VATEntry.Find('-') then
            repeat
                Accumulate(TotalVATEntry.Base, VATEntry.Base);
                Accumulate(TotalVATEntry.Amount, VATEntry.Amount);
                Accumulate(TotalVATEntry."Unrealized Amount", VATEntry."Unrealized Amount");
                Accumulate(TotalVATEntry."Unrealized Base", VATEntry."Unrealized Base");
                Accumulate(TotalVATEntry."Remaining Unrealized Amount", VATEntry."Remaining Unrealized Amount");
                Accumulate(TotalVATEntry."Remaining Unrealized Base", VATEntry."Remaining Unrealized Base");
                Accumulate(TotalVATEntry."Additional-Currency Amount", VATEntry."Additional-Currency Amount");
                Accumulate(TotalVATEntry."Additional-Currency Base", VATEntry."Additional-Currency Base");
                Accumulate(TotalVATEntry."Add.-Currency Unrealized Amt.", VATEntry."Add.-Currency Unrealized Amt.");
                Accumulate(TotalVATEntry."Add.-Currency Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                Accumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                Accumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Base", VATEntry."Add.-Curr. Rem. Unreal. Base");

                Accumulate(VATEntryTotalBase.Base, VATEntry.Base);
                Accumulate(VATEntryTotalBase.Amount, VATEntry.Amount);
                Accumulate(VATEntryTotalBase."Unrealized Amount", VATEntry."Unrealized Amount");
                Accumulate(VATEntryTotalBase."Unrealized Base", VATEntry."Unrealized Base");
                Accumulate(VATEntryTotalBase."Remaining Unrealized Amount", VATEntry."Remaining Unrealized Amount");
                Accumulate(VATEntryTotalBase."Remaining Unrealized Base", VATEntry."Remaining Unrealized Base");
                Accumulate(VATEntryTotalBase."Additional-Currency Amount", VATEntry."Additional-Currency Amount");
                Accumulate(VATEntryTotalBase."Additional-Currency Base", VATEntry."Additional-Currency Base");
                Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Amt.", VATEntry."Add.-Currency Unrealized Amt.");
                Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                Accumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                Accumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Base", VATEntry."Add.-Curr. Rem. Unreal. Base");

                AdjustVATAmount(VATEntry.Base, VATEntry."Additional-Currency Base");
                AdjustVATAmount(VATEntry.Amount, VATEntry."Additional-Currency Amount");
                AdjustVATAmount(VATEntry."Unrealized Amount", VATEntry."Add.-Currency Unrealized Amt.");
                AdjustVATAmount(VATEntry."Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                AdjustVATAmount(VATEntry."Remaining Unrealized Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                AdjustVATAmount(VATEntry."Remaining Unrealized Base", VATEntry."Add.-Curr. Rem. Unreal. Base");
                VATEntry.Modify();

                Accumulate(TotalVATEntry.Base, -VATEntry.Base);
                Accumulate(TotalVATEntry.Amount, -VATEntry.Amount);
                Accumulate(TotalVATEntry."Unrealized Amount", -VATEntry."Unrealized Amount");
                Accumulate(TotalVATEntry."Unrealized Base", -VATEntry."Unrealized Base");
                Accumulate(TotalVATEntry."Remaining Unrealized Amount", -VATEntry."Remaining Unrealized Amount");
                Accumulate(TotalVATEntry."Remaining Unrealized Base", -VATEntry."Remaining Unrealized Base");
                Accumulate(TotalVATEntry."Additional-Currency Amount", -VATEntry."Additional-Currency Amount");
                Accumulate(TotalVATEntry."Additional-Currency Base", -VATEntry."Additional-Currency Base");
                Accumulate(TotalVATEntry."Add.-Currency Unrealized Amt.", -VATEntry."Add.-Currency Unrealized Amt.");
                Accumulate(TotalVATEntry."Add.-Currency Unrealized Base", -VATEntry."Add.-Currency Unrealized Base");
                Accumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Amount", -VATEntry."Add.-Curr. Rem. Unreal. Amount");
                Accumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Base", -VATEntry."Add.-Curr. Rem. Unreal. Base");
            until VATEntry.Next() = 0;
    end;

    local procedure AdjustVATAmount(var AmountLCY: Decimal; var AmountAddCurr: Decimal)
    begin
        case GLSetup."VAT Exchange Rate Adjustment" of
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                AmountLCY :=
                  Round(
                    CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                      ExchRateAdjmtParameters."Posting Date", GetAdditionalReportingCurrency(),
                      AmountAddCurr, AddCurrCurrencyFactor));
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                AmountAddCurr :=
                  Round(
                    CurrExchRate2.ExchangeAmtLCYToFCY(
                      ExchRateAdjmtParameters."Exchange Rate Date", GetAdditionalReportingCurrency(),
                      AmountLCY, AddCurrCurrencyFactor));
        end;
    end;

    local procedure AdjustVATAccount(AccNo: Code[20]; AmountLCY: Decimal; AmountAddCurr: Decimal; BaseLCY: Decimal; BaseAddCurr: Decimal)
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Get(AccNo);
        GLAccount.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        case GLSetup."VAT Exchange Rate Adjustment" of
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                PostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount",
                  -AmountLCY, BaseLCY, BaseAddCurr);
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                PostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                  -AmountAddCurr, BaseLCY, BaseAddCurr);
        end;
    end;

    local procedure AdjustPurchTax(TaxJurisdiction: Record "Tax Jurisdiction"; var TotalVATEntry: Record "VAT Entry"; UseTax: Boolean)
    begin
        if (TotalVATEntry.Amount <> 0) or (TotalVATEntry."Additional-Currency Amount" <> 0) then begin
            TaxJurisdiction.TestField("Tax Account (Purchases)");
            AdjustVATAccount(
              TaxJurisdiction."Tax Account (Purchases)",
              TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
              VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
            if UseTax then begin
                TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                AdjustVATAccount(
                  TaxJurisdiction."Reverse Charge (Purchases)",
                  -TotalVATEntry.Amount, -TotalVATEntry."Additional-Currency Amount",
                  -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
            end;
        end;
        if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
           (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
        then begin
            TaxJurisdiction.TestField("Unrealized VAT Type");
            TaxJurisdiction.TestField("Unreal. Tax Acc. (Purchases)");
            AdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Purchases)",
              TotalVATEntry."Remaining Unrealized Amount", TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount", TotalVATEntry."Add.-Curr. Rem. Unreal. Amount");

            if UseTax then begin
                TaxJurisdiction.TestField("Unreal. Rev. Charge (Purch.)");
                AdjustVATAccount(
                  TaxJurisdiction."Unreal. Rev. Charge (Purch.)",
                  -TotalVATEntry."Remaining Unrealized Amount",
                  -TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                  -VATEntryTotalBase."Remaining Unrealized Amount",
                  -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;
        end;
    end;

    local procedure AdjustSalesTax(TaxJurisdiction: Record "Tax Jurisdiction"; var TotalVATEntry: Record "VAT Entry")
    begin
        TaxJurisdiction.TestField("Tax Account (Sales)");
        AdjustVATAccount(
          TaxJurisdiction."Tax Account (Sales)",
          TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
        if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
           (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
        then begin
            TaxJurisdiction.TestField("Unrealized VAT Type");
            TaxJurisdiction.TestField("Unreal. Tax Acc. (Sales)");
            AdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Sales)",
              TotalVATEntry."Remaining Unrealized Amount",
              TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount",
              VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
        end;
    end;

    local procedure Accumulate(var TotalAmount: Decimal; AmountToAdd: Decimal)
    begin
        TotalAmount := TotalAmount + AmountToAdd;
    end;

    local procedure PostGLAccAdjmt(GLAccNo: Code[20]; ExchRateAdjmt: Enum "Exch. Rate Adjustment Type"; Amount: Decimal;
                                                                         NetChange: Decimal;
                                                                         AddCurrNetChange: Decimal)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init();
        case ExchRateAdjmt of
            "Exch. Rate Adjustment Type"::"Adjust Amount":
                begin
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                    GenJnlLine."Currency Code" := '';
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GLAmtTotal := GLAmtTotal + GenJnlLine.Amount;
                    GLAddCurrNetChangeTotal := GLAddCurrNetChangeTotal + AddCurrNetChange;
                    GLNetChangeBase := GLNetChangeBase + NetChange;
                end;
            "Exch. Rate Adjustment Type"::"Adjust Additional-Currency Amount":
                begin
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                    GenJnlLine."Currency Code" := GetAdditionalReportingCurrency();
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := 0;
                    GLAddCurrAmtTotal := GLAddCurrAmtTotal + GenJnlLine.Amount;
                    GLNetChangeTotal := GLNetChangeTotal + NetChange;
                    GLAddCurrNetChangeBase := GLAddCurrNetChangeBase + AddCurrNetChange;
                end;
        end;
        if GenJnlLine.Amount <> 0 then begin
            GenJnlLine."Document No." := ExchRateAdjmtParameters."Document No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GLAccNo;
            GenJnlLine."Posting Date" := ExchRateAdjmtParameters."Posting Date";
            case GenJnlLine."Additional-Currency Posting" of
                GenJnlLine."Additional-Currency Posting"::"Amount Only":
                    GenJnlLine.Description :=
                        StrSubstNo(
                            ExchRateAdjmtParameters."Posting Description", GetAdditionalReportingCurrency(), AddCurrNetChange);
                GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only":
                    GenJnlLine.Description := StrSubstNo(ExchRateAdjmtParameters."Posting Description", '', NetChange);
            end;
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
            GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
        end;
    end;

    local procedure PostGLAccAdjmtTotal()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init();
        GenJnlLine."Document No." := ExchRateAdjmtParameters."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Posting Date" := ExchRateAdjmtParameters."Posting Date";
        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        GenJnlLine."System-Created Entry" := true;

        if GLAmtTotal <> 0 then begin
            if GLAmtTotal < 0 then
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLLossesAccount()
            else
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLGainsAccount();
            GenJnlLine.Description :=
                StrSubstNo(ExchRateAdjmtParameters."Posting Description", GetAdditionalReportingCurrency(), GLAddCurrNetChangeTotal);
            GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
            GenJnlLine."Currency Code" := '';
            GenJnlLine.Amount := -GLAmtTotal;
            GenJnlLine."Amount (LCY)" := -GLAmtTotal;
            GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
            GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
        end;
        if GLAddCurrAmtTotal <> 0 then begin
            if GLAddCurrAmtTotal < 0 then
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLLossesAccount()
            else
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLGainsAccount();
            GenJnlLine.Description := StrSubstNo(ExchRateAdjmtParameters."Posting Description", '', GLNetChangeTotal);
            GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
            GenJnlLine."Currency Code" := GetAdditionalReportingCurrency();
            GenJnlLine.Amount := -GLAddCurrAmtTotal;
            GenJnlLine."Amount (LCY)" := 0;
            GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
            GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
        end;

        ExchRateAdjmtReg."No." := ExchRateAdjmtReg."No." + 1;
        ExchRateAdjmtReg."Creation Date" := ExchRateAdjmtParameters."Posting Date";
        ExchRateAdjmtReg."Account Type" := ExchRateAdjmtReg."Account Type"::"G/L Account";
        ExchRateAdjmtReg."Posting Group" := '';
        ExchRateAdjmtReg."Currency Code" := GetAdditionalReportingCurrency();
        ExchRateAdjmtReg."Currency Factor" := CurrExchRate2."Adjustment Exch. Rate Amount";
        ExchRateAdjmtReg."Adjusted Base" := 0;
        ExchRateAdjmtReg."Adjusted Base (LCY)" := GLNetChangeBase;
        ExchRateAdjmtReg."Adjusted Amt. (LCY)" := GLAmtTotal;
        ExchRateAdjmtReg."Adjusted Base (Add.-Curr.)" := GLAddCurrNetChangeBase;
        ExchRateAdjmtReg."Adjusted Amt. (Add.-Curr.)" := GLAddCurrAmtTotal;
        ExchRateAdjmtReg.Insert();
    end;

    local procedure CheckExchRateAdjustment(AccNo: Code[20]; SetupTableName: Text; SetupFieldName: Text)
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo = '' then
            exit;

        GLAcc.Get(AccNo);
        if GLAcc."Exchange Rate Adjustment" <> GLAcc."Exchange Rate Adjustment"::"No Adjustment" then begin
            GLAcc."Exchange Rate Adjustment" := GLAcc."Exchange Rate Adjustment"::"No Adjustment";
            Error(
              ExchangeRateAdjmtMustBeErr,
              GLAcc.FieldCaption("Exchange Rate Adjustment"), GLAcc.TableCaption(),
              GLAcc."No.", GLAcc."Exchange Rate Adjustment",
              SetupTableName, GLSetup.FieldCaption("VAT Exchange Rate Adjustment"),
              GLSetup.TableCaption(), SetupFieldName);
        end;
    end;

    local procedure HandleCustDebitCredit(Correction: Boolean; AdjAmount: Decimal)
    begin
        if (AdjAmount > 0) and not Correction or
           (AdjAmount < 0) and Correction
        then begin
            TempDtldCustLedgEntry."Debit Amount (LCY)" := AdjAmount;
            TempDtldCustLedgEntry."Credit Amount (LCY)" := 0;
        end else begin
            TempDtldCustLedgEntry."Debit Amount (LCY)" := 0;
            TempDtldCustLedgEntry."Credit Amount (LCY)" := -AdjAmount;
        end;
    end;

    local procedure HandleVendDebitCredit(Correction: Boolean; AdjAmount: Decimal)
    begin
        if (AdjAmount > 0) and not Correction or
           (AdjAmount < 0) and Correction
        then begin
            TempDtldVendLedgEntry."Debit Amount (LCY)" := AdjAmount;
            TempDtldVendLedgEntry."Credit Amount (LCY)" := 0;
        end else begin
            TempDtldVendLedgEntry."Debit Amount (LCY)" := 0;
            TempDtldVendLedgEntry."Credit Amount (LCY)" := -AdjAmount;
        end;
    end;

    local procedure GetJnlLineDefDim(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        DimSetID: Integer;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::"G/L Account":
                DimMgt.AddDimSource(DefaultDimSource, Database::"G/L Account", GenJnlLine."Account No.");
            GenJnlLine."Account Type"::"Bank Account":
                DimMgt.AddDimSource(DefaultDimSource, Database::"Bank Account", GenJnlLine."Account No.");
        end;
        DimSetID :=
            DimMgt.GetDefaultDimID(
                DefaultDimSource, GenJnlLine."Source Code",
                GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code",
                GenJnlLine."Dimension Set ID", 0);
        DimMgt.GetDimensionSet(DimSetEntry, DimSetID);
    end;

    local procedure CopyDimSetEntryToDimBuf(var DimSetEntry: Record "Dimension Set Entry"; var DimBuf: Record "Dimension Buffer")
    begin
        if DimSetEntry.Find('-') then
            repeat
                DimBuf."Table ID" := DATABASE::"Dimension Buffer";
                DimBuf."Entry No." := 0;
                DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
                DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                DimBuf.Insert();
            until DimSetEntry.Next() = 0;
    end;

    local procedure GetDimCombID(var DimBuf: Record "Dimension Buffer"): Integer
    var
        DimEntryNo: Integer;
    begin
        DimEntryNo := DimBufMgt.FindDimensions(DimBuf);
        if DimEntryNo = 0 then
            DimEntryNo := DimBufMgt.InsertDimensions(DimBuf);
        exit(DimEntryNo);
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry"): Integer
    begin
        GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
        GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
        GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimSetEntry);
        GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimSetEntry);
        GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        OnPostGenJnlLineOnBeforeGenJnlPostLineRun(GenJnlLine, ExchRateAdjmtParameters);
        GenJnlPostLine.Run(GenJnlLine);
        OnPostGenJnlLineOnAfterGenJnlPostLineRun(GenJnlLine, GenJnlPostLine);
        exit(GenJnlPostLine.GetNextTransactionNo());
    end;

    local procedure GetGlobalDimVal(GlobalDimCode: Code[20]; var DimSetEntry: Record "Dimension Set Entry"): Code[20]
    var
        DimVal: Code[20];
    begin
        if GlobalDimCode = '' then
            DimVal := ''
        else begin
            DimSetEntry.SetRange("Dimension Code", GlobalDimCode);
            if DimSetEntry.Find('-') then
                DimVal := DimSetEntry."Dimension Value Code"
            else
                DimVal := '';
            DimSetEntry.SetRange("Dimension Code");
        end;
        exit(DimVal);
    end;

    local procedure CheckPostingDate()
    begin
        if ExchRateAdjmtParameters."Posting Date" < ExchRateAdjmtParameters."Start Date" then
            Error(PostingDateNotInPeriodErr);
        if ExchRateAdjmtParameters."Posting Date" > ExchRateAdjmtParameters."End Date" then
            Error(PostingDateNotInPeriodErr);
    end;

    procedure Preview(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    var
        ExchRateAdjmtProcess: Codeunit "Exch. Rate Adjmt. Proc. Zyxel";  // 01-03-24 ZY-LD 001
    begin
        BindSubscription(ExchRateAdjmtProcess);
        GenJnlPostPreview.Preview(ExchRateAdjmtProcess, ExchRateAdjmtParameters);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        ExchRateAdjmtProcess: Codeunit "Exch. Rate Adjmt. Proc. Zyxel";  // 01-03-24 ZY-LD 001
    begin
        ExchRateAdjmtParameters.Copy(RecVar);
        Result := ExchRateAdjmtProcess.Run(ExchRateAdjmtParameters);
    end;

    local procedure AdjustCustomerLedgerEntry(Customer: Record Customer; CustLedgerEntry: Record "Cust. Ledger Entry"; PostingDate2: Date; Application: Boolean)
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimEntryNo: Integer;
        OldAdjAmount: Decimal;
        Adjust: Boolean;
        AdjExchRateBufIndex: Integer;
        Correction: Boolean;
        ShouldExit: Boolean;
    begin
        CustLedgerEntry.SetRange("Date Filter", 0D, PostingDate2);
        TempCurrencyToAdjust.Get(CustLedgerEntry."Currency Code");
        if not ShouldAdjustCurrency(TempCurrencyToAdjust) then
            exit;

        GainsAmount := 0;
        LossesAmount := 0;
        OldAdjAmount := 0;
        Adjust := false;

        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        TempDimBuf.Reset();
        TempDimBuf.DeleteAll();
        DimSetEntry.SetRange("Dimension Set ID", CustLedgerEntry."Dimension Set ID");
        CopyDimSetEntryToDimBuf(DimSetEntry, TempDimBuf);
        DimEntryNo := GetDimCombID(TempDimBuf);

        CustLedgerEntry.CalcFields(
            Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
            "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

        // Calculate Old Unrealized Gains and Losses
        SetUnrealizedGainLossFilterCust(DtldCustLedgEntry, CustLedgerEntry."Entry No.");
        DtldCustLedgEntry.CalcSums("Amount (LCY)");

        SetUnrealizedGainLossFilterCust(TempDtldCustLedgEntrySums, CustLedgerEntry."Entry No.");
        TempDtldCustLedgEntrySums.CalcSums("Amount (LCY)");
        OldAdjAmount := DtldCustLedgEntry."Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
        CustLedgerEntry."Remaining Amt. (LCY)" += TempDtldCustLedgEntrySums."Amount (LCY)";
        CustLedgerEntry."Debit Amount (LCY)" += TempDtldCustLedgEntrySums."Amount (LCY)";
        CustLedgerEntry."Credit Amount (LCY)" += TempDtldCustLedgEntrySums."Amount (LCY)";
        TempDtldCustLedgEntrySums.Reset();

        // Calculate New Unrealized Gains and Losses
        CurrAdjAmount :=
            Round(
                CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                    ExchRateAdjmtParameters."Exchange Rate Date", TempCurrencyToAdjust.Code, CustLedgerEntry."Remaining Amount", TempCurrencyToAdjust."Currency Factor")) -
                CustLedgerEntry."Remaining Amt. (LCY)";

        OnAfterAdjustCustomerLedgerEntryOnAfterCalcAdjmtAmount(CustLedgerEntry, ExchRateAdjmtParameters, CurrAdjAmount, Application, ShouldExit);
        if ShouldExit then
            exit;

        // Modify Currency Factor on Customer Ledger Entry
        if CustLedgerEntry."Adjusted Currency Factor" <> TempCurrencyToAdjust."Currency Factor" then begin
            CustLedgerEntry."Adjusted Currency Factor" := TempCurrencyToAdjust."Currency Factor";
            CustLedgerEntry.Modify();
        end;

        if CurrAdjAmount <> 0 then begin
            OnAdjustCustomerLedgerEntryOnBeforeInitDtldCustLedgEntry(Customer, CustLedgerEntry);
            InitDtldCustLedgEntry(CustLedgerEntry, TempDtldCustLedgEntry);
            TempDtldCustLedgEntry."Entry No." := NewEntryNo;
            TempDtldCustLedgEntry."Posting Date" := PostingDate2;
            TempDtldCustLedgEntry."Document No." := ExchRateAdjmtParameters."Document No.";

            Correction :=
                (CustLedgerEntry."Debit Amount" < 0) or
                (CustLedgerEntry."Credit Amount" < 0) or
                (CustLedgerEntry."Debit Amount (LCY)" < 0) or
                (CustLedgerEntry."Credit Amount (LCY)" < 0);

            if OldAdjAmount > 0 then
                case true of
                    (CurrAdjAmount > 0):
                        begin
                            TempDtldCustLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                            HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                            InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            GainsAmount := CurrAdjAmount;
                            Adjust := true;
                        end;
                    (CurrAdjAmount < 0):
                        if -CurrAdjAmount <= OldAdjAmount then begin
                            TempDtldCustLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                            HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                            InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            LossesAmount := CurrAdjAmount;
                            Adjust := true;
                        end else begin
                            CurrAdjAmount := CurrAdjAmount + OldAdjAmount;
                            TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                            HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                            InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            AdjExchRateBufIndex :=
                                ExchRateAdjmtBufferUpdate(
                                    CustLedgerEntry."Currency Code", CustLedgerEntry."Customer Posting Group", GetCustAccountNo(CustLedgerEntry),
                                    0, 0, -OldAdjAmount, 0, -OldAdjAmount, DimEntryNo, PostingDate2, Customer."IC Partner Code",
                                    CustLedgerEntry."Entry No.");
                            TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                            ModifyTempDtldCustomerLedgerEntry();
                            Adjust := false;
                        end;
                end;
            if OldAdjAmount < 0 then
                case true of
                    (CurrAdjAmount < 0):
                        begin
                            TempDtldCustLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                            HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                            InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            LossesAmount := CurrAdjAmount;
                            Adjust := true;
                        end;
                    (CurrAdjAmount > 0):
                        if CurrAdjAmount <= -OldAdjAmount then begin
                            TempDtldCustLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                            HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                            InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            GainsAmount := CurrAdjAmount;
                            Adjust := true;
                        end else begin
                            CurrAdjAmount := OldAdjAmount + CurrAdjAmount;
                            TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                            HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                            InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            AdjExchRateBufIndex :=
                                ExchRateAdjmtBufferUpdate(
                                    CustLedgerEntry."Currency Code", CustLedgerEntry."Customer Posting Group", GetCustAccountNo(CustLedgerEntry),
                                    0, 0, -OldAdjAmount, -OldAdjAmount, 0, DimEntryNo, PostingDate2, Customer."IC Partner Code",
                                    CustLedgerEntry."Entry No.");
                            TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                            ModifyTempDtldCustomerLedgerEntry();
                            Adjust := false;
                        end;
                end;

            OnAdjustCustomerLedgerEntryOnAfterPrepareAdjust(CustLedgerEntry, CurrAdjAmount, OldAdjAmount);

            if not Adjust then begin
                TempDtldCustLedgEntry."Amount (LCY)" := CurrAdjAmount;
                HandleCustDebitCredit(Correction, TempDtldCustLedgEntry."Amount (LCY)");
                TempDtldCustLedgEntry."Entry No." := NewEntryNo;
                if CurrAdjAmount < 0 then begin
                    TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                    GainsAmount := 0;
                    LossesAmount := CurrAdjAmount;
                end else
                    if CurrAdjAmount > 0 then begin
                        TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                        GainsAmount := CurrAdjAmount;
                        LossesAmount := 0;
                    end;
                InsertTempDtldCustomerLedgerEntry(CustLedgerEntry);
                NewEntryNo := NewEntryNo + 1;
            end;

            TotalAdjAmount := TotalAdjAmount + CurrAdjAmount;
            if not ExchRateAdjmtParameters."Hide UI" then
                Window.Update(4, TotalAdjAmount);
            AdjExchRateBufIndex :=
                ExchRateAdjmtBufferUpdate(
                    CustLedgerEntry."Currency Code", CustLedgerEntry."Customer Posting Group", GetCustAccountNo(CustLedgerEntry),
                    CustLedgerEntry."Remaining Amount", CustLedgerEntry."Remaining Amt. (LCY)", TempDtldCustLedgEntry."Amount (LCY)",
                    GainsAmount, LossesAmount, DimEntryNo, PostingDate2, Customer."IC Partner Code",
                    CustLedgerEntry."Entry No.");
            TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
            ModifyTempDtldCustomerLedgerEntry();
        end;
    end;

    local procedure AdjustVendorLedgerEntry(Vendor: Record Vendor; VendLedgerEntry: Record "Vendor Ledger Entry"; PostingDate2: Date; Application: Boolean): Boolean
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimEntryNo: Integer;
        OldAdjAmount: Decimal;
        Adjust: Boolean;
        AdjExchRateBufIndex: Integer;
        Correction: Boolean;
        ShouldExit: Boolean;
    begin
        VendLedgerEntry.SetRange("Date Filter", 0D, PostingDate2);
        TempCurrencyToAdjust.Get(VendLedgerEntry."Currency Code");
        if not ShouldAdjustCurrency(TempCurrencyToAdjust) then
            exit;

        GainsAmount := 0;
        LossesAmount := 0;
        OldAdjAmount := 0;
        Adjust := false;

        TempDimBuf.Reset();
        TempDimBuf.DeleteAll();
        DimSetEntry.SetRange("Dimension Set ID", VendLedgerEntry."Dimension Set ID");
        CopyDimSetEntryToDimBuf(DimSetEntry, TempDimBuf);
        DimEntryNo := GetDimCombID(TempDimBuf);

        VendLedgerEntry.CalcFields(
            Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
            "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

        // Calculate Old Unrealized GainLoss
        SetUnrealizedGainLossFilterVend(DtldVendLedgEntry, VendLedgerEntry."Entry No.");
        DtldVendLedgEntry.CalcSums("Amount (LCY)");

        SetUnrealizedGainLossFilterVend(TempDtldVendLedgEntrySums, VendLedgerEntry."Entry No.");
        TempDtldVendLedgEntrySums.CalcSums("Amount (LCY)");
        OldAdjAmount := DtldVendLedgEntry."Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
        VendLedgerEntry."Remaining Amt. (LCY)" += TempDtldVendLedgEntrySums."Amount (LCY)";
        VendLedgerEntry."Debit Amount (LCY)" += TempDtldVendLedgEntrySums."Amount (LCY)";
        VendLedgerEntry."Credit Amount (LCY)" += TempDtldVendLedgEntrySums."Amount (LCY)";
        TempDtldVendLedgEntrySums.Reset();

        // Calculate New Unrealized Gains and Losses
        CurrAdjAmount :=
            Round(
                CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                    ExchRateAdjmtParameters."Exchange Rate Date", TempCurrencyToAdjust.Code, VendLedgerEntry."Remaining Amount", TempCurrencyToAdjust."Currency Factor")) -
                VendLedgerEntry."Remaining Amt. (LCY)";

        OnAfterAdjustVendorLedgerEntryOnAfterCalcAdjmtAmount(VendLedgerEntry, ExchRateAdjmtParameters, CurrAdjAmount, Application, ShouldExit);
        if ShouldExit then
            exit;

        // Modify Currency Factor on Vendor Ledger Entry
        if VendLedgerEntry."Adjusted Currency Factor" <> TempCurrencyToAdjust."Currency Factor" then begin
            VendLedgerEntry."Adjusted Currency Factor" := TempCurrencyToAdjust."Currency Factor";
            VendLedgerEntry.Modify();
        end;

        if CurrAdjAmount <> 0 then begin
            OnAdjustVendorLedgerEntryOnBeforeInitDtldVendLedgEntry(Vendor, VendLedgerEntry);
            InitDtldVendLedgEntry(VendLedgerEntry, TempDtldVendLedgEntry);
            TempDtldVendLedgEntry."Entry No." := NewEntryNo;
            TempDtldVendLedgEntry."Posting Date" := PostingDate2;
            TempDtldVendLedgEntry."Document No." := ExchRateAdjmtParameters."Document No.";

            Correction :=
                (VendLedgerEntry."Debit Amount" < 0) or
                (VendLedgerEntry."Credit Amount" < 0) or
                (VendLedgerEntry."Debit Amount (LCY)" < 0) or
                (VendLedgerEntry."Credit Amount (LCY)" < 0);

            if OldAdjAmount > 0 then
                case true of
                    (CurrAdjAmount > 0):
                        begin
                            TempDtldVendLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                            HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                            InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            GainsAmount := CurrAdjAmount;
                            Adjust := true;
                        end;
                    (CurrAdjAmount < 0):
                        if -CurrAdjAmount <= OldAdjAmount then begin
                            TempDtldVendLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                            HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                            InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            LossesAmount := CurrAdjAmount;
                            Adjust := true;
                        end else begin
                            CurrAdjAmount := CurrAdjAmount + OldAdjAmount;
                            TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                            HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                            InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            AdjExchRateBufIndex :=
                                ExchRateAdjmtBufferUpdate(
                                    VendLedgerEntry."Currency Code", VendLedgerEntry."Vendor Posting Group", GetVendAccountNo(VendLedgerEntry),
                                    0, 0, -OldAdjAmount, 0, -OldAdjAmount, DimEntryNo, PostingDate2, Vendor."IC Partner Code",
                                    VendLedgerEntry."Entry No.");
                            TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                            ModifyTempDtldVendorLedgerEntry();
                            Adjust := false;
                        end;
                end;
            if OldAdjAmount < 0 then
                case true of
                    (CurrAdjAmount < 0):
                        begin
                            TempDtldVendLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                            HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                            InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            LossesAmount := CurrAdjAmount;
                            Adjust := true;
                        end;
                    (CurrAdjAmount > 0):
                        if CurrAdjAmount <= -OldAdjAmount then begin
                            TempDtldVendLedgEntry."Amount (LCY)" := CurrAdjAmount;
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                            HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                            InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            GainsAmount := CurrAdjAmount;
                            Adjust := true;
                        end else begin
                            CurrAdjAmount := OldAdjAmount + CurrAdjAmount;
                            TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                            HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                            InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                            NewEntryNo := NewEntryNo + 1;
                            AdjExchRateBufIndex :=
                                ExchRateAdjmtBufferUpdate(
                                    VendLedgerEntry."Currency Code", VendLedgerEntry."Vendor Posting Group", GetVendAccountNo(VendLedgerEntry),
                                    0, 0, -OldAdjAmount, -OldAdjAmount, 0, DimEntryNo, PostingDate2, Vendor."IC Partner Code",
                                    VendLedgerEntry."Entry No.");
                            TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                            ModifyTempDtldVendorLedgerEntry();
                            Adjust := false;
                        end;
                end;

            OnAdjustVendorLedgerEntryOnAfterPrepareAdjust(VendLedgerEntry, CurrAdjAmount, OldAdjAmount);

            if not Adjust then begin
                TempDtldVendLedgEntry."Amount (LCY)" := CurrAdjAmount;
                HandleVendDebitCredit(Correction, TempDtldVendLedgEntry."Amount (LCY)");
                TempDtldVendLedgEntry."Entry No." := NewEntryNo;
                if CurrAdjAmount < 0 then begin
                    TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                    GainsAmount := 0;
                    LossesAmount := CurrAdjAmount;
                end else
                    if CurrAdjAmount > 0 then begin
                        TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                        GainsAmount := CurrAdjAmount;
                        LossesAmount := 0;
                    end;
                InsertTempDtldVendorLedgerEntry(VendLedgerEntry);
                NewEntryNo := NewEntryNo + 1;
            end;

            TotalAdjAmount := TotalAdjAmount + CurrAdjAmount;
            if not ExchRateAdjmtParameters."Hide UI" then
                Window.Update(4, TotalAdjAmount);
            AdjExchRateBufIndex :=
                ExchRateAdjmtBufferUpdate(
                    VendLedgerEntry."Currency Code", VendLedgerEntry."Vendor Posting Group", GetVendAccountNo(VendLedgerEntry),
                    VendLedgerEntry."Remaining Amount", VendLedgerEntry."Remaining Amt. (LCY)",
                    TempDtldVendLedgEntry."Amount (LCY)", GainsAmount, LossesAmount, DimEntryNo, PostingDate2, Vendor."IC Partner Code",
                    VendLedgerEntry."Entry No.");
            TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
            ModifyTempDtldVendorLedgerEntry();
        end;
    end;

    procedure AdjustExchRateCust(GenJournalLine: Record "Gen. Journal Line"; var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    var
        Customer: Record Customer;
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PostingDate2: Date;
    begin
        PostingDate2 := GenJournalLine."Posting Date";
        if TempCustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry2.Get(TempCustLedgerEntry."Entry No.");
                CustLedgerEntry2.SetRange("Date Filter", 0D, PostingDate2);
                CustLedgerEntry2.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                if ShouldAdjustEntry(
                        ExchRateAdjmtParameters."Exchange Rate Date", CustLedgerEntry2."Currency Code", CustLedgerEntry2."Remaining Amount",
                        CustLedgerEntry2."Remaining Amt. (LCY)", CustLedgerEntry2."Adjusted Currency Factor")
                then begin
                    InitVariablesForSetLedgEntry(GenJournalLine);
                    SetCustLedgEntry(Customer, CustLedgerEntry2);
                    AdjustCustomerLedgerEntry(Customer, CustLedgerEntry2, PostingDate2, false);

                    DetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");
                    DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry2."Entry No.");
                    DetailedCustLedgEntry.SetFilter("Posting Date", '%1..', CalcDate('<+1D>', PostingDate2));
                    if DetailedCustLedgEntry.FindSet() then
                        repeat
                            AdjustCustomerLedgerEntry(Customer, CustLedgerEntry2, DetailedCustLedgEntry."Posting Date", true);
                        until DetailedCustLedgEntry.Next() = 0;
                    HandlePostAdjmt("Exch. Rate Adjmt. Account Type"::Customer);
                end;
            until TempCustLedgerEntry.Next() = 0;
    end;

    procedure AdjustExchRateVend(GenJournalLine: Record "Gen. Journal Line"; var TempVendLedgerEntry: Record "Vendor Ledger Entry" temporary)
    var
        Vendor: Record Vendor;
        VendLedgerEntry2: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PostingDate2: Date;
    begin
        PostingDate2 := GenJournalLine."Posting Date";
        if TempVendLedgerEntry.FindSet() then
            repeat
                VendLedgerEntry2.Get(TempVendLedgerEntry."Entry No.");
                VendLedgerEntry2.SetRange("Date Filter", 0D, PostingDate2);
                VendLedgerEntry2.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                if ShouldAdjustEntry(
                    ExchRateAdjmtParameters."Exchange Rate Date", VendLedgerEntry2."Currency Code",
                    VendLedgerEntry2."Remaining Amount", VendLedgerEntry2."Remaining Amt. (LCY)", VendLedgerEntry2."Adjusted Currency Factor")
                then begin
                    InitVariablesForSetLedgEntry(GenJournalLine);
                    SetVendLedgEntry(Vendor, VendLedgerEntry2);
                    AdjustVendorLedgerEntry(Vendor, VendLedgerEntry2, PostingDate2, false);

                    DetailedVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.");
                    DetailedVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry2."Entry No.");
                    DetailedVendLedgEntry.SetFilter("Posting Date", '%1..', CalcDate('<+1D>', PostingDate2));
                    if DetailedVendLedgEntry.FindSet() then
                        repeat
                            AdjustVendorLedgerEntry(Vendor, VendLedgerEntry2, DetailedVendLedgEntry."Posting Date", true);
                        until DetailedVendLedgEntry.Next() = 0;
                    HandlePostAdjmt("Exch. Rate Adjmt. Account Type"::Vendor);
                end;
            until TempVendLedgerEntry.Next() = 0;
    end;

    local procedure ResetTempAdjmtBuffer()
    begin
        TempExchRateAdjmtBuffer.Reset();
        TempExchRateAdjmtBuffer.DeleteAll();
    end;

    local procedure ResetTempAdjmtBuffer2()
    begin
        TempExchRateAdjmtBuffer2.Reset();
        TempExchRateAdjmtBuffer2.DeleteAll();
    end;

    local procedure SetCustLedgEntry(var Customer: Record Customer; CustLedgerEntryToAdjust: Record "Cust. Ledger Entry")
    begin
        Customer.Get(CustLedgerEntryToAdjust."Customer No.");
        AddCurrency(CustLedgerEntryToAdjust."Currency Code", CustLedgerEntryToAdjust."Adjusted Currency Factor");
        DtldCustLedgEntry.LockTable();
        CustLedgerEntryToAdjust.LockTable();
        NewEntryNo := DtldCustLedgEntry.GetLastEntryNo() + 1;
    end;

    local procedure SetVendLedgEntry(var Vendor: Record Vendor; VendLedgerEntryToAdjust: Record "Vendor Ledger Entry")
    begin
        Vendor.Get(VendLedgerEntryToAdjust."Vendor No.");
        AddCurrency(VendLedgerEntryToAdjust."Currency Code", VendLedgerEntryToAdjust."Adjusted Currency Factor");
        DtldVendLedgEntry.LockTable();
        VendLedgerEntryToAdjust.LockTable();
        NewEntryNo := DtldVendLedgEntry.GetLastEntryNo() + 1;
    end;

    local procedure ShouldAdjustEntry(PostingDate: Date; CurCode: Code[10]; RemainingAmount: Decimal; RemainingAmtLCY: Decimal; AdjCurFactor: Decimal): Boolean
    begin
        exit(Round(CurrExchRate.ExchangeAmtFCYToLCYAdjmt(PostingDate, CurCode, RemainingAmount, AdjCurFactor)) - RemainingAmtLCY <> 0);
    end;

    local procedure InitVariablesForSetLedgEntry(GenJournalLine: Record "Gen. Journal Line")
    begin
        ExchRateAdjmtParameters."Start Date" := GenJournalLine."Posting Date";
        ExchRateAdjmtParameters."End Date" := GenJournalLine."Posting Date";
        ExchRateAdjmtParameters."Posting Date" := GenJournalLine."Posting Date";
        ExchRateAdjmtParameters."Posting Description" := PostingDescriptionTxt;
        ExchRateAdjmtParameters."Document No." := GenJournalLine."Document No.";
        ExchRateAdjmtParameters."Journal Template Name" := GenJournalLine."Journal Template Name";
        ExchRateAdjmtParameters."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        ExchRateAdjmtParameters."Hide UI" := true;
        GetGLSetup();
        SourceCodeSetup.Get();
        if ExchRateAdjmtReg.FindLast() then
            ExchRateAdjmtReg.Init();
        OnAfterInitVariablesForSetLedgEntry(ExchRateAdjmtParameters, GenJournalLine);
    end;

    local procedure AddCurrency(CurrencyCode: Code[10]; CurrencyFactor: Decimal)
    var
        CurrencyToAdd: Record Currency;
    begin
        if TempCurrencyToAdjust.Get(CurrencyCode) then begin
            TempCurrencyToAdjust."Currency Factor" := CurrencyFactor;
            TempCurrencyToAdjust.Modify();
        end else begin
            CurrencyToAdd.Get(CurrencyCode);
            TempCurrencyToAdjust := CurrencyToAdd;
            TempCurrencyToAdjust."Currency Factor" := CurrencyFactor;
            TempCurrencyToAdjust.Insert();
        end;
    end;

    local procedure ShouldAdjustCurrency(Currency: Record Currency) ShouldAdjust: Boolean
    begin
        ShouldAdjust := true;

        OnAfterShouldAdjustCurrency(Currency, ShouldAdjust);
    end;

    local procedure InitDtldCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        DtldCustLedgEntry.Init();
        DtldCustLedgEntry."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
        DtldCustLedgEntry.Amount := 0;
        DtldCustLedgEntry."Customer No." := CustLedgEntry."Customer No.";
        DtldCustLedgEntry."Currency Code" := CustLedgEntry."Currency Code";
        DtldCustLedgEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(DtldCustLedgEntry."User ID"));
        DtldCustLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        DtldCustLedgEntry."Journal Batch Name" := CustLedgEntry."Journal Batch Name";
        DtldCustLedgEntry."Reason Code" := CustLedgEntry."Reason Code";
        DtldCustLedgEntry."Initial Entry Due Date" := CustLedgEntry."Due Date";
        DtldCustLedgEntry."Initial Entry Global Dim. 1" := CustLedgEntry."Global Dimension 1 Code";
        DtldCustLedgEntry."Initial Entry Global Dim. 2" := CustLedgEntry."Global Dimension 2 Code";
        DtldCustLedgEntry."Initial Document Type" := CustLedgEntry."Document Type";

        OnAfterInitDtldCustLedgerEntry(DtldCustLedgEntry);
    end;

    local procedure InitDtldVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        DtldVendLedgEntry.Init();
        DtldVendLedgEntry."Vendor Ledger Entry No." := VendLedgEntry."Entry No.";
        DtldVendLedgEntry.Amount := 0;
        DtldVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        DtldVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        DtldVendLedgEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(DtldVendLedgEntry."User ID"));
        DtldVendLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        DtldVendLedgEntry."Journal Batch Name" := VendLedgEntry."Journal Batch Name";
        DtldVendLedgEntry."Reason Code" := VendLedgEntry."Reason Code";
        DtldVendLedgEntry."Initial Entry Due Date" := VendLedgEntry."Due Date";
        DtldVendLedgEntry."Initial Entry Global Dim. 1" := VendLedgEntry."Global Dimension 1 Code";
        DtldVendLedgEntry."Initial Entry Global Dim. 2" := VendLedgEntry."Global Dimension 2 Code";
        DtldVendLedgEntry."Initial Document Type" := VendLedgEntry."Document Type";

        OnAfterInitDtldVendLedgerEntry(DtldVendLedgEntry);
    end;

    local procedure GetUnrealizedGainsAccount(Currency: Record Currency) AccountNo: Code[20]
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetUnrealizedGainsAccount(Currency, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        exit(Currency.GetUnrealizedGainsAccount());
    end;

    local procedure GetUnrealizedLossesAccount(Currency: Record Currency) AccountNo: Code[20]
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetUnrealizedLossesAccount(Currency, AccountNo, IsHandled);
        if IsHandled then
            exit(AccountNo);

        exit(Currency.GetUnrealizedLossesAccount());
    end;

    local procedure SetUnrealizedGainLossFilterCust(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; EntryNo: Integer)
    begin
        with DtldCustLedgEntry do begin
            Reset();
            SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
            SetRange("Cust. Ledger Entry No.", EntryNo);
            SetRange("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        end;
    end;

    local procedure SetUnrealizedGainLossFilterVend(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; EntryNo: Integer)
    begin
        with DtldVendLedgEntry do begin
            Reset();
            SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
            SetRange("Vendor Ledger Entry No.", EntryNo);
            SetRange("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        end;
    end;

    local procedure InsertTempDtldCustomerLedgerEntry(CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        TempDtldCustLedgEntry.Insert();
        InsertExchRateAdjmtCustLedgerEntry(CustLedgerEntry, TempDtldCustLedgEntry);
        TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
        TempDtldCustLedgEntrySums.Insert();
    end;

    local procedure InsertTempDtldVendorLedgerEntry(VendLedgerEntry: Record "Vendor Ledger Entry")
    begin
        TempDtldVendLedgEntry.Insert();
        InsertExchRateAdjmtVendLedgerEntry(VendLedgerEntry, TempDtldVendLedgEntry);
        TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
        TempDtldVendLedgEntrySums.Insert();
    end;

    local procedure ModifyTempDtldCustomerLedgerEntry()
    begin
        TempDtldCustLedgEntry.Modify();
        TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
        TempDtldCustLedgEntrySums.Modify();
    end;

    local procedure ModifyTempDtldVendorLedgerEntry()
    begin
        TempDtldVendLedgEntry.Modify();
        TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
        TempDtldVendLedgEntrySums.Modify();
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get();

        GLSetupRead := true;
    end;

    local procedure GetAdditionalReportingCurrency(): Code[10]
    begin
        GetGLSetup();
        exit(GLSetup."Additional Reporting Currency");
    end;

    local procedure InsertExchRateAdjmtBankAccLedgerEntry(BankAccount: Record "Bank Account");
    begin
        TempExchRateAdjmtLedgEntry.Init();
        NewRegLedgEntryNo += 1;
        TempExchRateAdjmtLedgEntry."Entry No." := NewRegLedgEntryNo;
        TempExchRateAdjmtLedgEntry."Account Type" := "Exch. Rate Adjmt. Account Type"::"Bank Account";
        TempExchRateAdjmtLedgEntry."Account No." := BankAccount."No.";
        TempExchRateAdjmtLedgEntry."Posting Date" := ExchRateAdjmtParameters."Posting Date";
        TempExchRateAdjmtLedgEntry."Currency Code" := BankAccount."Currency Code";
        TempExchRateAdjmtLedgEntry."Currency Factor" := Currency."Currency Factor";
        TempExchRateAdjmtLedgEntry."Base Amount" := BankAccount."Balance at Date";
        TempExchRateAdjmtLedgEntry."Base Amount (LCY)" := BankAccount."Balance at Date (LCY)";
        TempExchRateAdjmtLedgEntry."Adjustment Amount" := CurrAdjAmount;
        TempExchRateAdjmtLedgEntry.Insert();
    end;

    local procedure InsertExchRateAdjmtCustLedgerEntry(CustLedgEntry: Record "Cust. Ledger Entry"; DtldCustledgEntry: Record "Detailed Cust. Ledg. Entry");
    begin
        TempExchRateAdjmtLedgEntry.Init();
        NewRegLedgEntryNo += 1;
        TempExchRateAdjmtLedgEntry."Entry No." := NewRegLedgEntryNo;
        TempExchRateAdjmtLedgEntry."Detailed Ledger Entry Type" := DtldCustLedgEntry."Entry Type";
        TempExchRateAdjmtLedgEntry."Detailed Ledger Entry No." := DtldCustLedgEntry."Entry No.";
        TempExchRateAdjmtLedgEntry."Account Type" := "Exch. Rate Adjmt. Account Type"::Customer;
        TempExchRateAdjmtLedgEntry."Account No." := CustLedgEntry."Customer No.";
        TempExchRateAdjmtLedgEntry."Document Type" := CustLedgEntry."Document Type";
        TempExchRateAdjmtLedgEntry."Document No." := CustLedgEntry."Document No.";
        TempExchRateAdjmtLedgEntry."Posting Date" := ExchRateAdjmtParameters."Posting Date";
        TempExchRateAdjmtLedgEntry."Currency Code" := Currency.Code;
        TempExchRateAdjmtLedgEntry."Currency Factor" := Currency."Currency Factor";
        TempExchRateAdjmtLedgEntry."Base Amount" := CustLedgEntry."Remaining Amount";
        TempExchRateAdjmtLedgEntry."Base Amount (LCY)" := CustLedgEntry."Remaining Amt. (LCY)";
        TempExchRateAdjmtLedgEntry."Adjustment Amount" := CurrAdjAmount;
        TempExchRateAdjmtLedgEntry.Insert();
    end;

    local procedure InsertExchRateAdjmtVendLedgerEntry(VendLedgEntry: Record "Vendor Ledger Entry"; DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry");
    begin
        TempExchRateAdjmtLedgEntry.Init();
        NewRegLedgEntryNo += 1;
        TempExchRateAdjmtLedgEntry."Entry No." := NewRegLedgEntryNo;
        TempExchRateAdjmtLedgEntry."Detailed Ledger Entry Type" := DtldVendLedgEntry."Entry Type";
        TempExchRateAdjmtLedgEntry."Detailed Ledger Entry No." := DtldVendLedgEntry."Entry No.";
        TempExchRateAdjmtLedgEntry."Account Type" := "Exch. Rate Adjmt. Account Type"::Vendor;
        TempExchRateAdjmtLedgEntry."Account No." := VendLedgEntry."Vendor No.";
        TempExchRateAdjmtLedgEntry."Document Type" := VendLedgEntry."Document Type";
        TempExchRateAdjmtLedgEntry."Document No." := VendLedgEntry."Document No.";
        TempExchRateAdjmtLedgEntry."Posting Date" := ExchRateAdjmtParameters."Posting Date";
        TempExchRateAdjmtLedgEntry."Currency Code" := Currency.Code;
        TempExchRateAdjmtLedgEntry."Currency Factor" := Currency."Currency Factor";
        TempExchRateAdjmtLedgEntry."Base Amount" := VendLedgEntry."Remaining Amount";
        TempExchRateAdjmtLedgEntry."Base Amount (LCY)" := VendLedgEntry."Remaining Amt. (LCY)";
        TempExchRateAdjmtLedgEntry."Adjustment Amount" := CurrAdjAmount;
        TempExchRateAdjmtLedgEntry.Insert();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDtldCustLedgerEntry(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDtldVendLedgerEntry(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitVariablesForSetLedgEntry(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetDtldCustLedgEntryFilters(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; CustLedgEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetDtldVendLedgEntryFilters(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; VendLedgEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldAdjustCurrency(Currency: Record Currency; var ShouldAdjust: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldAdjustCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry"; var ShouldAdjust: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldAdjustVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry"; var ShouldAdjust: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAdjustCustomerLedgerEntryOnBeforeInitDtldCustLedgEntry(var Customer: Record Customer; CusLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAdjustCustomerLedgerEntryOnAfterPrepareAdjust(var CustLedgerEntry: Record "Cust. Ledger Entry"; CurrAdjAmount: Decimal; OldAdjAmount: Decimal);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAdjustCustomerLedgerEntryOnAfterCalcAdjmtAmount(CustLedgerEntry: Record "Cust. Ledger Entry"; ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters"; AdjmtAmount: Decimal; Application: Boolean; var ShouldExit: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAdjustVendorLedgerEntryOnBeforeInitDtldVendLedgEntry(var Vendor: Record Vendor; VendLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAdjustVendorLedgerEntryOnAfterPrepareAdjust(var VendorLedgerEntry: Record "Vendor Ledger Entry"; CurrAdjAmount: Decimal; OldAdjAmount: Decimal);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAdjustVendorLedgerEntryOnAfterCalcAdjmtAmount(VendLedgerEntry: Record "Vendor Ledger Entry"; ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters"; AdjmtAmount: Decimal; Application: Boolean; var ShouldExit: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcessCustomerAdjustment(var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcessVendorAdjustment(var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRunAdjustment(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetBankAccountNo(BankAccount: Record "Bank Account"; AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetCustAccountNo(CustLedgerEntry: Record "Cust. Ledger Entry"; AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    internal procedure OnBeforeGetLocalCustAccountNo(CustLedgerEntry: Record "Cust. Ledger Entry"; var AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetVendAccountNo(VendLedgerEntry: Record "Vendor Ledger Entry"; AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    internal procedure OnBeforeGetLocalVendAccountNo(VendLedgerEntry: Record "Vendor Ledger Entry"; var AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetRealizedGainsAccount(Currency: Record Currency; var AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetRealizedLossesAccount(Currency: Record Currency; var AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetUnrealizedGainsAccount(Currency: Record Currency; var AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetUnrealizedLossesAccount(Currency: Record Currency; var AccountNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostGenJnlLineOnAfterGenJnlPostLineRun(var GenJnlLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessBankAccountOnAfterCalcFields(var BankAccount: Record "Bank Account"; Currency: Record Currency)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostGenJnlLineOnBeforeGenJnlPostLineRun(var GenJnlLine: Record "Gen. Journal Line"; var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAdjustGLAccountsAndVATEntries(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters"; var Currency: Record Currency; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
    end;
}