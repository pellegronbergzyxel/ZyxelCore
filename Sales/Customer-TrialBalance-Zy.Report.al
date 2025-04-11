Report 50005 "Customer - Trial Balance - Zy"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Trial Balance - Zy.rdlc';
    Caption = 'Customer - Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("Customer Posting Group");
            RequestFilterFields = "No.", "Date Filter", "Customer Posting Group";
            column(CompanyName; CompanyName())
            {
            }
            column(PeriodFilter; StrSubstNo(Text003, PeriodFilter))
            {
            }
            column(CustFieldCaptPostingGroup; StrSubstNo(Text005, Customer.FieldCaption(Customer."Customer Posting Group")))
            {
            }
            column(CustTableCaptioncustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(PeriodStartDate; Format(PeriodStartDate))
            {
            }
            column(PeriodFilter1; PeriodFilter)
            {
            }
            column(FiscalYearStartDate; Format(FiscalYearStartDate))
            {
            }
            column(FiscalYearFilter; FiscalYearFilter)
            {
            }
            column(PeriodEndDate; Format(PeriodEndDate))
            {
            }
            column(PostingGroup_Customer; Customer."Customer Posting Group")
            {
            }
            column(YTDTotal; YTDTotal)
            {
                AutoFormatType = 1;
            }
            column(YTDCreditAmt; YTDCreditAmt)
            {
                AutoFormatType = 1;
            }
            column(YTDDebitAmt; YTDDebitAmt)
            {
                AutoFormatType = 1;
            }
            column(YTDBeginBalance; YTDBeginBalance)
            {
            }
            column(PeriodCreditAmt; PeriodCreditAmt)
            {
            }
            column(PeriodDebitAmt; PeriodDebitAmt)
            {
            }
            column(PeriodBeginBalance; PeriodBeginBalance)
            {
            }
            column(Name_Customer; Customer.Name)
            {
                IncludeCaption = true;
            }
            column(No_Customer; Customer."No.")
            {
                IncludeCaption = true;
            }
            column(TotalPostGroup_Customer; Text004 + Format(' ') + Customer."Customer Posting Group")
            {
            }
            column(CustTrialBalanceCaption; CustTrialBalanceCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AmtsinLCYCaption; AmtsinLCYCaptionLbl)
            {
            }
            column(inclcustentriesinperiodCaption; inclcustentriesinperiodCaptionLbl)
            {
            }
            column(YTDTotalCaption; YTDTotalCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(FiscalYearToDateCaption; FiscalYearToDateCaptionLbl)
            {
            }
            column(NetChangeCaption; NetChangeCaptionLbl)
            {
            }
            column(TotalinLCYCaption; TotalinLCYCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcAmounts(
                  PeriodStartDate, PeriodEndDate,
                  PeriodBeginBalance, PeriodDebitAmt, PeriodCreditAmt, YTDTotal);

                CalcAmounts(
                  FiscalYearStartDate, PeriodEndDate,
                  YTDBeginBalance, YTDDebitAmt, YTDCreditAmt, YTDTotal);
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := Customer.FieldNo(Customer."Customer Posting Group");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        PeriodBeginBalanceCaption = 'Beginning Balance';
        PeriodDebitAmtCaption = 'Debit';
        PeriodCreditAmtCaption = 'Credit';
    }

    trigger OnInitReport()
    begin
        HideZeroAmounts := true;
    end;

    trigger OnPreReport()
    begin
        begin
            PeriodFilter := Customer.GetFilter(Customer."Date Filter");
            PeriodStartDate := Customer.GetRangeMin(Customer."Date Filter");
            PeriodEndDate := Customer.GetRangemax(Customer."Date Filter");
            Customer.SetRange(Customer."Date Filter");
            CustFilter := Customer.GetFilters;
            Customer.SetRange(Customer."Date Filter", PeriodStartDate, PeriodEndDate);
            AccountingPeriod.SetRange("Starting Date", 0D, PeriodEndDate);
            AccountingPeriod.SetRange("New Fiscal Year", true);
            if AccountingPeriod.FindLast then
                FiscalYearStartDate := AccountingPeriod."Starting Date"
            else
                Error(Text000, AccountingPeriod.FieldCaption("Starting Date"), AccountingPeriod.TableCaption);
            FiscalYearFilter := Format(FiscalYearStartDate) + '..' + Format(PeriodEndDate);
        end;
    end;

    var
        Text000: label 'It was not possible to find a %1 in %2.';
        AccountingPeriod: Record "Accounting Period";
        PeriodBeginBalance: Decimal;
        PeriodDebitAmt: Decimal;
        PeriodCreditAmt: Decimal;
        YTDBeginBalance: Decimal;
        YTDDebitAmt: Decimal;
        YTDCreditAmt: Decimal;
        YTDTotal: Decimal;
        LastFieldNo: Integer;
        HideZeroAmounts: Boolean;
        PeriodFilter: Text[250];
        FiscalYearFilter: Text[250];
        CustFilter: Text;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        FiscalYearStartDate: Date;
        Text003: label 'Period: %1';
        Text004: label 'Total for';
        Text005: label 'Group Totals: %1';
        CustTrialBalanceCaptionLbl: label 'Customer - Trial Balance';
        CurrReportPageNoCaptionLbl: label 'Page';
        AmtsinLCYCaptionLbl: label 'Amounts in LCY';
        inclcustentriesinperiodCaptionLbl: label 'Only includes customers with entries in the period';
        YTDTotalCaptionLbl: label 'Ending Balance';
        PeriodCaptionLbl: label 'Period';
        FiscalYearToDateCaptionLbl: label 'Fiscal Year-To-Date';
        NetChangeCaptionLbl: label 'Net Change';
        TotalinLCYCaptionLbl: label 'Total in LCY';

    local procedure CalcAmounts(DateFrom: Date; DateTo: Date; var BeginBalance: Decimal; var DebitAmt: Decimal; var CreditAmt: Decimal; var TotalBalance: Decimal)
    var
        CustomerCopy: Record Customer;
    begin
        CustomerCopy.Copy(Customer);

        CustomerCopy.SetRange("Date Filter", 0D, DateFrom - 1);
        CustomerCopy.CalcFields("Net Change (LCY)");
        BeginBalance := CustomerCopy."Net Change (LCY)";

        CustomerCopy.SetRange("Date Filter", DateFrom, DateTo);
        CustomerCopy.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
        DebitAmt := CustomerCopy."Debit Amount (LCY)";
        CreditAmt := CustomerCopy."Credit Amount (LCY)";

        TotalBalance := BeginBalance + DebitAmt - CreditAmt;
    end;
}
