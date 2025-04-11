Report 50011 "Customer - Summary Aging LCY 2"
{
    // 001. 28-12-17 ZY-LD New columns.
    // 002. 08-02-18 ZY-LD At Zyxel it's due date is the day after NAV due date.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Summary Aging LCY 2.rdlc';

    Caption = 'Customer - Summary Aging (Year)';
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
            column(CustBalanceDueLCY_14_; CustBalanceDueLCY[14])
            {
            }
            column(CustBalanceDueLCY_13_; CustBalanceDueLCY[13])
            {
            }
            column(CustBalanceDueLCY_12_; CustBalanceDueLCY[12])
            {
            }
            column(CustBalanceDueLCY_11_; CustBalanceDueLCY[11])
            {
            }
            column(CustBalanceDueLCY_10_; CustBalanceDueLCY[10])
            {
            }
            column(CustBalanceDueLCY_9_; CustBalanceDueLCY[9])
            {
            }
            column(CustBalanceDueLCY_8_; CustBalanceDueLCY[8])
            {
            }
            column(CustBalanceDueLCY_7_; CustBalanceDueLCY[7])
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
            column(CaptionArray_14_; CaptionArray[14])
            {
            }
            column(CaptionArray_13_; CaptionArray[13])
            {
            }
            column(CaptionArray_12_; CaptionArray[12])
            {
            }
            column(CaptionArray_11_; CaptionArray[11])
            {
            }
            column(CaptionArray_10_; CaptionArray[10])
            {
            }
            column(CaptionArray_9_; CaptionArray[9])
            {
            }
            column(CaptionArray_8_; CaptionArray[8])
            {
            }
            column(CaptionArray_7_; CaptionArray[7])
            {
            }
            column(CaptionArray_6_; CaptionArray[6])
            {
            }
            column(CaptionArray_5_; CaptionArray[5])
            {
            }
            column(CaptionArray_4_; CaptionArray[4])
            {
            }
            column(CaptionArray_3_; CaptionArray[3])
            {
            }
            column(CaptionArray_2_; CaptionArray[2])
            {
            }
            column(CaptionArray_1_; CaptionArray[1])
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintCust := false;
                for i := 1 to ArrayLen(PeriodStartDate) - 1 do begin
                    DtldCustLedgEntry.SetCurrentkey("Customer No.", "Initial Entry Due Date", "Posting Date");
                    DtldCustLedgEntry.SetRange("Customer No.", Customer."No.");
                    DtldCustLedgEntry.SetRange("Posting Date", 0D, StartDate);
                    DtldCustLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                    DtldCustLedgEntry.CalcSums("Amount (LCY)");
                    CustBalanceDueLCY[i] := DtldCustLedgEntry."Amount (LCY)";
                    if CustBalanceDueLCY[i] <> 0 then
                        PrintCust := true;
                end;
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
        CaptionArray[ArrayLen(PeriodStartDate) - 1] := Text004;  // 28-12-17 ZY-LD 001
        //PeriodStartDate[ARRAYLEN(PeriodStartDate) - 1] := StartDate;  // 08-02-18 ZY-LD 002
        PeriodStartDate[ArrayLen(PeriodStartDate) - 1] := StartDate - 1;  // 08-02-18 ZY-LD 002
        PeriodStartDate[ArrayLen(PeriodStartDate)] := 99991231D;
        for i := ArrayLen(PeriodStartDate) - 2 downto 3 do begin
            PeriodStartDate[i] := CalcDate('<-30D>', PeriodStartDate[i + 1]);
            CaptionArray[i] := StrSubstNo(Text002, NoOfDaysStart, PeriodStartDate[ArrayLen(PeriodStartDate) - 1] - PeriodStartDate[i]);  // 28-12-17 ZY-LD 001
            NoOfDaysStart := PeriodStartDate[ArrayLen(PeriodStartDate) - 1] - PeriodStartDate[i] + 1;  // 28-12-17 ZY-LD 001
        end;
        PeriodStartDate[2] := CalcDate('<-35D>', PeriodStartDate[3]);
        //>> 28-12-17 ZY-LD 001
        CaptionArray[2] := StrSubstNo(Text002, NoOfDaysStart, PeriodStartDate[ArrayLen(PeriodStartDate) - 1] - PeriodStartDate[2]);
        NoOfDaysStart := PeriodStartDate[ArrayLen(PeriodStartDate) - 1] - PeriodStartDate[2];
        CaptionArray[1] := StrSubstNo(Text003, NoOfDaysStart);
        //<< 28-12-17 ZY-LD 001
    end;

    var
        Text001: label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        StartDate: Date;
        CustFilter: Text;
        PeriodStartDate: array[15] of Date;
        CustBalanceDueLCY: array[14] of Decimal;
        CaptionArray: array[15] of Text;
        PrintCust: Boolean;
        i: Integer;
        Text002: label '%1-%2 days';
        Text003: label 'Over %1 days';
        Text004: label 'Not Due';
        Customer___Summary_Aging_Simp_CaptionLbl: label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in LCY';
        CustBalanceDueLCY_7__Control31CaptionLbl: label 'Not Due';
        CustBalanceDueLCY_6__Control30CaptionLbl: label '0-30 days';
        CustBalanceDueLCY_5__Control25CaptionLbl: label '31-60 days';
        CustBalanceDueLCY_4__Control26CaptionLbl: label '61-90 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: label '91-180 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: label 'Over 180 days';
        CustBalanceDueLCY_1__Control29CaptionLbl: label 'Total';
        TotalCaptionLbl: label 'Total';
        NoOfDaysStart: Integer;


    procedure InitializeRequest(StartingDate: Date)
    begin
        StartDate := StartingDate;
    end;
}
