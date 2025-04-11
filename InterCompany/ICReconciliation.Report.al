Report 50115 "IC Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/IC Reconciliation.rdlc';
    Caption = 'IC Reconciliation';
    ShowPrintStatus = false;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("IC Reconciliation Name"; "IC Reconciliation Name")
        {
            DataItemTableView = sorting("Reconciliation Template Name", Name);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Reconciliation Template Name", Name;
            column(StmtName1_VatStmtName; "IC Reconciliation Name"."Reconciliation Template Name")
            {
            }
            column(Name1_VatStmtName; "IC Reconciliation Name".Name)
            {
            }
            dataitem("IC Reconciliation Line"; "IC Reconciliation Line")
            {
                DataItemLink = "Reconciliation Template Name" = field("Reconciliation Template Name"), "Reconciliation Name" = field(Name);
                DataItemTableView = sorting("Reconciliation Template Name", "Reconciliation Name") where(Print = const(true));
                RequestFilterFields = "Row No.";
                column(Heading; Heading)
                {
                }
                column(CompanyName; CompanyName())
                {
                }
                column(StmtName_VatStmtName; "IC Reconciliation Name"."Reconciliation Template Name")
                {
                }
                column(Name_VatStmtName; "IC Reconciliation Name".Name)
                {
                }
                column(Heading2; Heading2)
                {
                }
                column(HeaderText; HeaderText)
                {
                }
                column(GlSetupLCYCode; GLSetup."LCY Code")
                {
                }
                column(Allamountsarein; AllamountsareinLbl)
                {
                }
                column(TxtGLSetupAddnalReportCur; StrSubstNo(Text003, GLSetup."Additional Reporting Currency"))
                {
                }
                column(GLSetupAddRepCurrency; GLSetup."Additional Reporting Currency")
                {
                }
                column(VatStmLineTableCaptFilter; "IC Reconciliation Line".TableCaption + ': ' + IcReconLineFilter)
                {
                }
                column(VatStmtLineFilter; IcReconLineFilter)
                {
                }
                column(VatStmtLineRowNo; "IC Reconciliation Line"."Row No.")
                {
                    IncludeCaption = true;
                }
                column(Description_VatStmtLine; "IC Reconciliation Line".Description)
                {
                    IncludeCaption = true;
                }
                column(TotalAmountCUR; TotalAmountCUR)
                {
                    AutoFormatExpression = GetCurrency;
                    AutoFormatType = 1;
                }
                column(TotalAmountEUR; TotalAmountEUR)
                {
                }
                column(CurrencyCode; CurrencyCode)
                {
                }
                column(UseAmtsInAddCurr; UseAmtsInAddCurr)
                {
                }
                column(Selection; Selection)
                {
                }
                column(PeriodSelection; PeriodSelection)
                {
                }
                column(PrintInIntegers; PrintInIntegers)
                {
                }
                column(BlankZero; "IC Reconciliation Line"."Blank Zero")
                {
                }
                column(Strong; "IC Reconciliation Line".Strong)
                {
                }
                column(Type; "IC Reconciliation Line".Type)
                {
                }
                column(CompanyNameLine; "IC Reconciliation Line"."Company Name")
                {
                }
                column(Totaling; "IC Reconciliation Line".Totaling)
                {
                }
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(VATStmtCaption; VATStmtCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(VATStmtTemplateCaption; VATStmtTemplateCaptionLbl)
                {
                }
                column(VATStmtNameCaption; VATStmtNameCaptionLbl)
                {
                }
                column(AmtsareinwholeLCYsCaption; AmtsareinwholeLCYsCaptionLbl)
                {
                }
                column(ReportinclallVATentriesCaption; ReportinclallVATentriesCaptionLbl)
                {
                }
                column(RepinclonlyclosedVATentCaption; RepinclonlyclosedVATentCaptionLbl)
                {
                }
                column(TotalAmountEURCaption; TotalAmountEURCaptionLbl)
                {
                }
                column(TotalAmountCURCaption; TotalAmountCURCaptionLbl)
                {
                }
                column(CurrencyCodeCaption; CurrencyCodeCaptionLbl)
                {
                }
                column(CompanyNameLineCaption; CompanyNameLineCaptionLbl)
                {
                }
                column(TypeLineCaption; TypeLineCaptionLbl)
                {
                }
                column(TotalingLineCaption; TotalingLineCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ZGT.UpdateProgressWindow(Format("IC Reconciliation Line"."Line No."), 0, true);

                    // EURO
                    ReportingCurrency := 'EUR';
                    CalcLineTotal("IC Reconciliation Line", TotalAmount, 0);
                    TotalAmountEUR := TotalAmount;
                    if PrintInIntegers then
                        TotalAmountEUR := ROUND(TotalAmountEUR, 1, '<');
                    if "IC Reconciliation Line"."Print with" = "IC Reconciliation Line"."print with"::"Opposite Sign" then
                        TotalAmountEUR := -TotalAmountEUR;

                    // Customer or Vendor currency
                    ReportingCurrency := '';
                    CurrencyCode := '';
                    TotalAmountCUR := 0;
                    if "IC Reconciliation Line".Type in ["IC Reconciliation Line".Type::"Account Totaling", "IC Reconciliation Line".Type::"Customer Totaling", "IC Reconciliation Line".Type::"Vendor Totaling"] then begin
                        CalcLineTotal("IC Reconciliation Line", TotalAmount, 0);
                        TotalAmountCUR := TotalAmount;
                        if TotalAmountCUR <> 0 then
                            CurrencyCode := ReportingCurrency;
                        if PrintInIntegers then
                            TotalAmountCUR := ROUND(TotalAmountCUR, 1, '<');
                        if "IC Reconciliation Line"."Print with" = "IC Reconciliation Line"."print with"::"Opposite Sign" then
                            TotalAmountCUR := -TotalAmountCUR;
                    end;

                    PageGroupNo := NextPageGroupNo;
                    if "IC Reconciliation Line"."New Page" then
                        NextPageGroupNo := PageGroupNo + 1;
                end;

                trigger OnPostDataItem()
                begin
                    ZGT.CloseProgressWindow;
                end;

                trigger OnPreDataItem()
                begin
                    PageGroupNo := 1;
                    NextPageGroupNo := 1;
                    ZGT.OpenProgressWindow('', "IC Reconciliation Line".Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
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
                    group("Statement Period")
                    {
                        Caption = 'Statement Period';
                        field(StartingDate; StartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Date';
                        }
                        field(EndingDate; EndDateReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                        }
                    }
                    field(Selection; Selection)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include VAT Entries';
                        OptionCaption = 'Open,Closed,Open and Closed';
                        Visible = false;
                    }
                    field(PeriodSelection; PeriodSelection)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include VAT Entries';
                        OptionCaption = 'Before and Within Period,Within Period';
                        Visible = false;
                    }
                    field(RoundToWholeNumbers; PrintInIntegers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Round to Whole Numbers';
                        Visible = false;
                    }
                    field(ShowAmtInAddCurrency; UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                        Visible = false;
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
    begin
        SI.SetHideSalesDialog(false);
    end;

    trigger OnPreReport()
    begin
        if EndDateReq = 0D then
            EndDate := 99991231D
        else
            EndDate := EndDateReq;
        CurrencyDate := EndDate + 1;
        if CurrencyDate = 0D then
            Error(Text006);

        IcReconLine.SetRange("Date Filter", StartDate, EndDateReq);
        if PeriodSelection = Periodselection::"Before and Within Period" then
            Heading := Text000
        else
            Heading := Text004;
        Heading2 := StrSubstNo(Text005, StartDate, EndDateReq);
        IcReconLineFilter := IcReconLine.GetFilters;
        SI.SetHideSalesDialog(true);
    end;

    var
        Text000: label 'VAT entries before and within the period';
        Text003: label 'Amounts are in %1, rounded without decimals.';
        Text004: label 'VAT entries within the period';
        Text005: label 'Period: %1..%2';
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        VATEntry: Record "VAT Entry";
        GLSetup: Record "General Ledger Setup";
        recGenLedgSetup: Record "General Ledger Setup";
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        PrintInIntegers: Boolean;
        IcReconLineFilter: Text;
        Heading: Text[50];
        Amount: Decimal;
        TotalAmount: Decimal;
        TotalAmountEUR: Decimal;
        TotalAmountCUR: Decimal;
        CurrencyCode: Code[10];
        RowNo: array[6] of Code[10];
        ErrorText: Text[80];
        i: Integer;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        UseAmtsInAddCurr: Boolean;
        HeaderText: Text[50];
        EndDate: Date;
        StartDate: Date;
        EndDateReq: Date;
        CurrencyDate: Date;
        IcReconLine: Record "VAT Statement Line";
        Heading2: Text[50];
        Text006: label 'Currency Date must not be must not be blank.';
        AllamountsareinLbl: label 'All amounts are in';
        VATStmtCaptionLbl: label 'IC Reconciliation';
        CurrReportPageNoCaptionLbl: label 'Page';
        VATStmtTemplateCaptionLbl: label 'IC Reconciliation Template';
        VATStmtNameCaptionLbl: label 'IC Reconciliation Name';
        CompanyNameLineCaptionLbl: label 'Company Name';
        AmtsareinwholeLCYsCaptionLbl: label 'Amounts are in whole LCYs.';
        ReportinclallVATentriesCaptionLbl: label 'The report includes all VAT entries.';
        RepinclonlyclosedVATentCaptionLbl: label 'The report includes only closed VAT entries.';
        TotalAmountEURCaptionLbl: label 'Amount (EUR)';
        ZGT: Codeunit "ZyXEL General Tools";
        TotalAmountCURCaptionLbl: label 'Amount (CUR)';
        CurrencyCodeCaptionLbl: label '';
        TypeLineCaptionLbl: label 'Type';
        TotalingLineCaptionLbl: label 'Totaling';
        ReportingCurrency: Code[10];
        SI: Codeunit "Single Instance";


    procedure CalcLineTotal(IcReconLine2: Record "IC Reconciliation Line"; var TotalAmount: Decimal; Level: Integer): Boolean
    var
        recCustLedgEntry: Record "Cust. Ledger Entry";
        recVendLedgEntry: Record "Vendor Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        ReturnDecimalValue: Decimal;
        DummyAmount: Decimal;
        AmountRepCurr: Decimal;
        CurrRate: Decimal;
        CurrDate: Date;
    begin
        //ReportingCurrency := 'EUR';
        recGenLedgSetup.Get;

        if Level = 0 then
            TotalAmount := 0;
        case IcReconLine2.Type of
            IcReconLine2.Type::"Account Totaling":
                begin
                    if IcReconLine2."Company Name" in ['', CompanyName()] then begin
                        GLAcc.SetFilter("No.", IcReconLine2.Totaling);
                        if EndDateReq = 0D then
                            EndDate := 99991231D
                        else
                            EndDate := EndDateReq;
                        GLAcc.SetRange("Date Filter", StartDate, EndDate);
                        Amount := 0;
                        if GLAcc.Find('-') and (IcReconLine2.Totaling <> '') then begin
                            if ReportingCurrency = '' then
                                ReportingCurrency := recGenLedgSetup."LCY Code";

                            repeat
                                GLAcc.CalcFields("Net Change", "Additional-Currency Net Change");
                                if recGenLedgSetup."LCY Code" = ReportingCurrency then
                                    AmountRepCurr := GLAcc."Net Change"
                                else
                                    if recGenLedgSetup."Additional Reporting Currency" = ReportingCurrency then
                                        AmountRepCurr := GLAcc."Additional-Currency Net Change"
                                    else
                                        AmountRepCurr := CurrExchRate.ExchangeAmount(GLAcc."Net Change", recGenLedgSetup."LCY Code", ReportingCurrency, CurrencyDate);
                                Amount := ConditionalAdd(Amount, AmountRepCurr, 0);
                            until GLAcc.Next() = 0;
                        end;
                        CalcTotalAmount(IcReconLine2, TotalAmount);
                    end else begin
                        Amount := 0;
                        ReturnDecimalValue := ZyWebServMgt.GetIcReconciliation("IC Reconciliation Name", IcReconLine2, Level, StartDate, EndDate, ReportingCurrency);
                        Amount := ConditionalAdd(Amount, ReturnDecimalValue, 0);
                        CalcTotalAmount(IcReconLine2, TotalAmount);
                    end;
                end;
            IcReconLine2.Type::"Customer Totaling":
                begin
                    if IcReconLine2."Company Name" in ['', CompanyName()] then begin
                        recCustLedgEntry.SetCurrentkey("Customer No.", "Posting Date", "Currency Code");

                        Cust.SetFilter("No.", IcReconLine2.Totaling);
                        if EndDateReq = 0D then
                            EndDate := 99991231D
                        else
                            EndDate := EndDateReq;
                        Cust.SetRange("Date Filter", StartDate, EndDate);
                        Amount := 0;
                        if Cust.Find('-') and (IcReconLine2.Totaling <> '') then begin
                            if ReportingCurrency = '' then
                                if Cust."Currency Code" <> '' then
                                    ReportingCurrency := Cust."Currency Code"
                                else
                                    ReportingCurrency := recGenLedgSetup."LCY Code";

                            repeat
                                recCustLedgEntry.SetCurrentkey("Customer No.", Open);
                                recCustLedgEntry.SetAutocalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                                recCustLedgEntry.SetRange("Customer No.", Cust."No.");
                                recCustLedgEntry.SetRange("Date Filter", StartDate, EndDate);
                                recCustLedgEntry.SetFilter("Remaining Amount", '<>0');
                                if recCustLedgEntry.FindSet then
                                    repeat
                                        if recGenLedgSetup."LCY Code" = ReportingCurrency then
                                            AmountRepCurr := recCustLedgEntry."Remaining Amt. (LCY)"
                                        else
                                            if recCustLedgEntry."Currency Code" = ReportingCurrency then
                                                AmountRepCurr := recCustLedgEntry."Remaining Amount"
                                            else
                                                AmountRepCurr := CurrExchRate.ExchangeAmount(recCustLedgEntry."Remaining Amt. (LCY)", recGenLedgSetup."LCY Code", ReportingCurrency, CurrencyDate);
                                        Amount := ConditionalAdd(Amount, AmountRepCurr, 0);
                                    until recCustLedgEntry.Next() = 0;
                            until Cust.Next() = 0;
                        end;
                        CalcTotalAmount(IcReconLine2, TotalAmount);
                    end else begin
                        Amount := 0;
                        ReturnDecimalValue := ZyWebServMgt.GetIcReconciliation("IC Reconciliation Name", IcReconLine2, Level, StartDate, EndDate, ReportingCurrency);
                        Amount := ConditionalAdd(Amount, ReturnDecimalValue, 0);
                        CalcTotalAmount(IcReconLine2, TotalAmount);
                    end;
                end;
            IcReconLine2.Type::"Vendor Totaling":
                begin
                    if IcReconLine2."Company Name" in ['', CompanyName()] then begin
                        Vend.SetFilter("No.", IcReconLine2.Totaling);
                        if EndDateReq = 0D then
                            EndDate := 99991231D
                        else
                            EndDate := EndDateReq;
                        Vend.SetRange("Date Filter", StartDate, EndDate);
                        Amount := 0;
                        if Vend.Find('-') and (IcReconLine2.Totaling <> '') then begin
                            if ReportingCurrency = '' then
                                if Vend."Currency Code" <> '' then
                                    ReportingCurrency := Vend."Currency Code"
                                else
                                    ReportingCurrency := recGenLedgSetup."LCY Code";

                            repeat
                                recVendLedgEntry.SetCurrentkey("Vendor No.", Open);
                                recVendLedgEntry.SetAutocalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                                recVendLedgEntry.SetRange("Vendor No.", Vend."No.");
                                recVendLedgEntry.SetRange("Date Filter", StartDate, EndDate);
                                recVendLedgEntry.SetFilter("Remaining Amount", '<>0');
                                if recVendLedgEntry.FindSet then
                                    repeat
                                        if recGenLedgSetup."LCY Code" = ReportingCurrency then
                                            AmountRepCurr := recVendLedgEntry."Remaining Amt. (LCY)"
                                        else
                                            if recVendLedgEntry."Currency Code" = ReportingCurrency then
                                                AmountRepCurr := recVendLedgEntry."Remaining Amount"
                                            else
                                                AmountRepCurr := CurrExchRate.ExchangeAmount(recVendLedgEntry."Remaining Amt. (LCY)", recGenLedgSetup."LCY Code", ReportingCurrency, CurrencyDate);
                                        Amount := ConditionalAdd(Amount, AmountRepCurr, 0);
                                    until recVendLedgEntry.Next() = 0;
                            until Vend.Next() = 0;
                        end;
                        CalcTotalAmount(IcReconLine2, TotalAmount);
                    end else begin
                        Amount := 0;
                        ReturnDecimalValue := ZyWebServMgt.GetIcReconciliation("IC Reconciliation Name", IcReconLine2, Level, StartDate, EndDate, ReportingCurrency);
                        Amount := ConditionalAdd(Amount, ReturnDecimalValue, 0);
                        CalcTotalAmount(IcReconLine2, TotalAmount);
                    end;
                end;
            IcReconLine2.Type::"Row Totaling":
                begin
                    if Level >= ArrayLen(RowNo) then
                        exit(false);
                    Level := Level + 1;
                    RowNo[Level] := IcReconLine2."Row No.";

                    if IcReconLine2."Row Totaling" = '' then
                        exit(true);
                    IcReconLine2.SetRange("Reconciliation Template Name", IcReconLine2."Reconciliation Template Name");
                    IcReconLine2.SetRange("Reconciliation Name", IcReconLine2."Reconciliation Name");
                    IcReconLine2.SetFilter("Row No.", IcReconLine2."Row Totaling");
                    if IcReconLine2.Find('-') then
                        repeat
                            if not CalcLineTotal(IcReconLine2, TotalAmount, Level) then begin
                                if Level > 1 then
                                    exit(false);
                                for i := 1 to ArrayLen(RowNo) do
                                    ErrorText := ErrorText + RowNo[i] + ' => ';
                                ErrorText := ErrorText + '...';
                                IcReconLine2.FieldError("Row No.", ErrorText);
                            end;
                        until IcReconLine2.Next() = 0;
                end;
            IcReconLine2.Type::Description:
                ;
        end;

        exit(true);
    end;

    local procedure CalcAccountTotaling(IcReconLine2: Record "IC Reconciliation Line"; var TotalAmount: Decimal; pReportingCurrency: Code[10])
    var
        AmountRepCurr: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        GLAcc.SetFilter("No.", IcReconLine2.Totaling);
        if EndDateReq = 0D then
            EndDate := 99991231D
        else
            EndDate := EndDateReq;
        GLAcc.SetRange("Date Filter", StartDate, EndDate);
        Amount := 0;
        if GLAcc.Find('-') and (IcReconLine2.Totaling <> '') then
            repeat
                GLAcc.CalcFields("Net Change", "Additional-Currency Net Change");
                if recGenLedgSetup."LCY Code" = ReportingCurrency then
                    AmountRepCurr := GLAcc."Net Change"
                else
                    if recGenLedgSetup."Additional Reporting Currency" = ReportingCurrency then
                        AmountRepCurr := GLAcc."Additional-Currency Net Change"
                    else
                        AmountRepCurr := CurrExchRate.ExchangeAmount(GLAcc."Net Change", recGenLedgSetup."LCY Code", pReportingCurrency, CurrencyDate);
                Amount := ConditionalAdd(Amount, AmountRepCurr, 0);
            until GLAcc.Next() = 0;
        CalcTotalAmount(IcReconLine2, TotalAmount);
    end;

    local procedure CalcTotalAmount(IcReconLine2: Record "IC Reconciliation Line"; var TotalAmount: Decimal)
    begin
        if IcReconLine2."Calculate with" = 1 then
            Amount := -Amount;
        if PrintInIntegers and IcReconLine2.Print then
            Amount := ROUND(Amount, 1, '<');
        TotalAmount := TotalAmount + Amount;
    end;


    procedure InitializeRequest(var NewVATStmtName: Record "IC Reconciliation Name"; var NewVATStatementLine: Record "IC Reconciliation Line"; NewReportingCurrency: Code[10])
    begin
        "IC Reconciliation Name".Copy(NewVATStmtName);
        "IC Reconciliation Line".Copy(NewVATStatementLine);
        ReportingCurrency := NewReportingCurrency;
        //Selection := NewSelection;
        //PeriodSelection := NewPeriodSelection;
        //PrintInIntegers := NewPrintInIntegers;
        //UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        if NewVATStatementLine.GetFilter("Date Filter") <> '' then begin
            if NewVATStatementLine.GetRangeMin("Date Filter") <> 0D then
                StartDate := NewVATStatementLine.GetRangeMin("Date Filter")
            else
                StartDate := 0D;

            if NewVATStatementLine.GetRangemax("Date Filter") <> 0D then
                EndDateReq := NewVATStatementLine.GetRangemax("Date Filter")
            else
                EndDateReq := 0D;

            EndDate := EndDateReq;
        end else begin
            StartDate := 0D;
            EndDateReq := 0D;
            EndDate := 99991231D
        end;
    end;


    procedure FinalizeRequest(): Code[10]
    begin
        exit(ReportingCurrency);
    end;

    local procedure ConditionalAdd(pAmount: Decimal; pAmountToAdd: Decimal; pAddCurrAmountToAdd: Decimal): Decimal
    begin
        if UseAmtsInAddCurr then
            exit(pAmount + pAddCurrAmountToAdd);

        exit(pAmount + pAmountToAdd);
    end;

    local procedure GetCurrency(): Code[10]
    begin
        if UseAmtsInAddCurr then
            exit(GLSetup."Additional Reporting Currency");

        exit('');
    end;
}
