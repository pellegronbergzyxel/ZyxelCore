Report 50105 "Customer - Summary Aging LOC"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Summary Aging LOC.rdlc';
    Caption = 'Customer - Summary Aging Simp.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Statistics Group", "Payment Terms Code";
            column(STRSUBSTNO_Text001_FORMAT_StartDate__; StrSubstNo(Text001, Format(StartDate)))
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(COMPANYNAME; CompanyName())
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(CustBalanceDueLCY_6_; CustBalanceDueLCY[6])
            {
            }
            column(CustBalanceDueLCY_5_; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4_; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3_; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2_; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1_; CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(Customer__No__; Customer."No.")
            {
            }
            column(Customer_Name; Customer.Name)
            {
            }
            column(CustBalanceDueLCY_7__Control31; CustBalanceDueLCY[7])
            {
            }
            column(CustBalanceDueLCY_6__Control30; CustBalanceDueLCY[6])
            {
            }
            column(CustBalanceDueLCY_5__Control25; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control26; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control27; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control28; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1__Control29; CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5__Control43; CustBalanceDueLCY[7])
            {
            }
            column(CustBalanceDueLCY_5__Control42; CustBalanceDueLCY[6])
            {
            }
            column(CustBalanceDueLCY_5__Control37; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control38; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control39; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control40; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1__Control41; CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(Customer___Summary_Aging_Simp_Caption; Customer___Summary_Aging_Simp_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Customer__No__Caption; Customer.FieldCaption(Customer."No."))
            {
            }
            column(Customer_NameCaption; Customer.FieldCaption(Customer.Name))
            {
            }
            column(CustBalanceDueLCY_7__Control31Caption; CustBalanceDueLCY_7__Control31CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_6__Control30Caption; CustBalanceDueLCY_6__Control30CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5__Control25Caption; CustBalanceDueLCY_5__Control25CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_4__Control26Caption; CustBalanceDueLCY_4__Control26CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_3__Control27Caption; CustBalanceDueLCY_3__Control27CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_2__Control28Caption; CustBalanceDueLCY_2__Control28CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_1__Control29Caption; CustBalanceDueLCY_1__Control29CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(CurrencyCode; CurrencyCode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintCust := false;
                CurrencyCode := '';
                for i := 1 to 6 do begin
                    DtldCustLedgEntry.SetCurrentkey("Customer No.", "Initial Entry Due Date", "Posting Date");
                    DtldCustLedgEntry.SetRange("Customer No.", Customer."No.");
                    DtldCustLedgEntry.SetRange("Posting Date", 0D, StartDate);
                    DtldCustLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                    DtldCustLedgEntry.CalcSums(Amount);
                    CustBalanceDueLCY[i] := DtldCustLedgEntry.Amount;
                    if CustBalanceDueLCY[i] <> 0 then PrintCust := true;
                end;
                DtldCustLedgEntry1.SetCurrentkey("Customer No.", "Initial Entry Due Date", "Posting Date");
                DtldCustLedgEntry1.SetRange("Customer No.", Customer."No.");
                DtldCustLedgEntry1.SetRange("Posting Date", 0D, StartDate);
                if DtldCustLedgEntry1.FindFirst then CurrencyCode := DtldCustLedgEntry1."Currency Code";

                if not PrintCust then
                    CurrReport.Skip;
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
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if StartDate = 0D then
                StartDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;
        PeriodStartDate[6] := StartDate;
        PeriodStartDate[7] := 99991231D;
        for i := 5 downto 3 do
            PeriodStartDate[i] := CalcDate('<-30D>', PeriodStartDate[i + 1]);
        PeriodStartDate[2] := CalcDate('<-90D>', PeriodStartDate[3]);
    end;

    var
        Text001: label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        StartDate: Date;
        CustFilter: Text;
        PeriodStartDate: array[8] of Date;
        CustBalanceDueLCY: array[7] of Decimal;
        PrintCust: Boolean;
        i: Integer;
        Customer___Summary_Aging_Simp_CaptionLbl: label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in Invoiced Currency';
        CustBalanceDueLCY_7__Control31CaptionLbl: label 'Not Due';
        CustBalanceDueLCY_6__Control30CaptionLbl: label '0-30 days';
        CustBalanceDueLCY_5__Control25CaptionLbl: label '31-60 days';
        CustBalanceDueLCY_4__Control26CaptionLbl: label '61-90 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: label '91-180 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: label 'Over 180 days';
        CustBalanceDueLCY_1__Control29CaptionLbl: label 'Total';
        TotalCaptionLbl: label 'Total';
        CurrencyCode: Text[20];
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";


    procedure InitializeRequest(StartingDate: Date)
    begin
        StartDate := StartingDate;
    end;
}
