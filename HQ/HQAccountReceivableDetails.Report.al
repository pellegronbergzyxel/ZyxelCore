Report 50183 "HQ Account Receivable Details"
{
    // 001. 31-01-22 ZY-LD 2022013110000031 - "Reporting Currency" is added to the "Credit Limit" caption.
    // 002. 15-08-22 ZY-LD 2022081510000077 - Preparing for Web Service.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HQ Account Receivable Details.rdlc';

    Caption = 'HQ Account Receivable Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Replication Company"; "Replication Company")
        {
            RequestFilterFields = "Company Name";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Replication Company"."Company Name", 0, true);
                ZyWebServMgt.GetAccountPay_Receivable(1, "Replication Company"."Company Name", EndDate, CurrencyDate, ReportingCurrency, "Account Pay./Receiv Buffer");
                RunCurrentCompany := false;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                if "Replication Company".GetFilter("Replication Company"."Company Name") = '' then
                    case ReportType of
                        Reporttype::Client:
                            "Replication Company".SetRange("Replication Company"."HQ Account Receivable Details", true);
                        Reporttype::"Web Service":
                            "Replication Company".SetRange("Replication Company"."HQ Account Receivable WebSrv.", true);  // 15-08-22 ZY-LD 002
                    end;

                RunCurrentCompany := true;
                ZGT.OpenProgressWindow('', "Replication Company".Count);
            end;
        }
        dataitem("Account Pay./Receiv Buffer"; "Account Pay./Receiv Buffer")
        {
            DataItemTableView = sorting("Entry No.");
            UseTemporary = true;
            column(CompanyName; "Account Pay./Receiv Buffer"."Company Name")
            {
            }
            column(HQAccNo; "Account Pay./Receiv Buffer"."HQ Account No.")
            {
            }
            column(HQAccName; "Account Pay./Receiv Buffer"."HQ Account Name")
            {
            }
            column(GlAccNo; "Account Pay./Receiv Buffer"."G/L Account No.")
            {
            }
            column(GlAccName; "Account Pay./Receiv Buffer"."G/L Account Name")
            {
            }
            column(CustNo; "Account Pay./Receiv Buffer"."Source No.")
            {
            }
            column(CustName; "Account Pay./Receiv Buffer"."Source Name")
            {
            }
            column(CreditLimit; "Account Pay./Receiv Buffer"."Credit Limit")
            {
            }
            column(Division; "Account Pay./Receiv Buffer".Division)
            {
            }
            column(PaymentTerms; "Account Pay./Receiv Buffer"."Payment Terms")
            {
            }
            column(InvoiceNo; "Account Pay./Receiv Buffer"."Invoice No.")
            {
            }
            column(PostingDate; "Account Pay./Receiv Buffer"."Posting Date")
            {
            }
            column(DocumentDate; "Account Pay./Receiv Buffer"."Document Date")
            {
            }
            column(DueDate; "Account Pay./Receiv Buffer"."Due Date")
            {
            }
            column(DueDays; DueDays)
            {
            }
            column(ClosedAtDate; "Account Pay./Receiv Buffer"."Closed at Date")
            {
            }
            column(TxnCurrencyCode; "Account Pay./Receiv Buffer"."TXN Currency Code")
            {
            }
            column(TxnAmount; "Account Pay./Receiv Buffer"."TXN Amount")
            {
            }
            column(TxnEndingBalance; "Account Pay./Receiv Buffer"."TXN Ending Balance")
            {
            }
            column(LcyCurrencyCode; "Account Pay./Receiv Buffer"."LCY Currency Code")
            {
            }
            column(LcyAmount; "Account Pay./Receiv Buffer"."LCY Amount")
            {
            }
            column(LcyEndingBalance; "Account Pay./Receiv Buffer"."LCY Ending Balance")
            {
            }
            column(RptCurrencyCode; "Account Pay./Receiv Buffer"."RPT Currency Code")
            {
            }
            column(RptAmount; "Account Pay./Receiv Buffer"."RPT Amount")
            {
            }
            column(RptEndingBalance; "Account Pay./Receiv Buffer"."RPT Ending Balance")
            {
            }
            column(CompanyName_Caption; Text001)
            {
            }
            column(HQAccNo_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."HQ Account No."))
            {
            }
            column(HQAccName_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."HQ Account Name"))
            {
            }
            column(GlAccNo_Caption; Text003)
            {
            }
            column(GlAccName_Caption; Text004)
            {
            }
            column(SourceNo_Caption; Text005)
            {
            }
            column(SourceName_Caption; Text006)
            {
            }
            column(CreditLimit_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Credit Limit") + ' (' + ReportingCurrency + ')')
            {
            }
            column(Division_Caption; Text007)
            {
            }
            column(PaymentTerms_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Payment Terms"))
            {
            }
            column(InvoiceNo_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Invoice No."))
            {
            }
            column(VendorInvoiceNo_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Vendor Invoice No."))
            {
            }
            column(PostingDate_Caption; Text009)
            {
            }
            column(DocumentDate_Caption; Text008)
            {
            }
            column(DueDate_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Due Date"))
            {
            }
            column(DueDays_Caption; Text002)
            {
            }
            column(ClosedAtDate_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Closed at Date"))
            {
            }
            column(TxnCurrencyCode_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."TXN Currency Code"))
            {
            }
            column(TxnAmount_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."TXN Amount"))
            {
            }
            column(TxnEndingBalance_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."TXN Ending Balance"))
            {
            }
            column(LcyCurrencyCode_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."LCY Currency Code"))
            {
            }
            column(LcyAmount_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."LCY Amount"))
            {
            }
            column(LcyEndingBalance_Caption; Text011)
            {
            }
            column(RptCurrencyCode_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."RPT Currency Code"))
            {
            }
            column(RptAmount_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."RPT Amount"))
            {
            }
            column(RptEndingBalance_Caption; Text010)
            {
            }
            column(Open_Caption; Text012)
            {
            }
            column(ExchangeError_Caption; Text013)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Account Pay./Receiv Buffer"."TXN Amount" > 0 then
                    DueDays := EndDate - "Account Pay./Receiv Buffer"."Due Date"
                else
                    DueDays := 0;
            end;

            trigger OnPreDataItem()
            begin
                if RunCurrentCompany then
                    xmlAccountPayReceiv.GetDataPayReceive(1, EndDate, CurrencyDate, ReportingCurrency, "Account Pay./Receiv Buffer");
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
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';

                        trigger OnValidate()
                        begin
                            CurrencyDate := EndDate + 1;
                        end;
                    }
                    field(CurrencyDate; CurrencyDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Date';
                    }
                    field(ReportingCurrency; ReportingCurrency)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reporting Currency';
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

    trigger OnInitReport()
    begin
        recGLSetup.Get;
        ReportingCurrency := recGLSetup."LCY Code";
    end;

    trigger OnPreReport()
    begin
        //SI.UseOfReport(3,50184,3);  // 14-10-20 ZY-LD 000
    end;

    var
        recGLSetup: Record "General Ledger Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        SI: Codeunit "Single Instance";
        xmlAccountPayReceiv: XmlPort "WS Account Pay./Receiv";
        Text001: label 'Entity Name';
        EndDate: Date;
        CurrencyDate: Date;
        ReportingCurrency: Code[10];
        RunCurrentCompany: Boolean;
        Text002: label 'Due Days';
        Text003: label 'Sub Account No.';
        Text004: label 'Sub Account Name';
        Text005: label 'Customer No.';
        Text006: label 'Customer Name';
        Text007: label 'Business Model';
        Text008: label 'Invoice Date';
        Text009: label 'Book Date';
        Text010: label 'Local Ending Balance (EUR)';
        Text011: label 'Remaining Amount (LCY)';
        Text012: label 'Open';
        Text013: label 'Exchange Error';
        DueDays: Integer;
        ReportType: Option Client,"Web Service";


    procedure InitReqest(NewEndDate: Date; NewReportType: Option Client,"Web Service")
    begin
        EndDate := NewEndDate;
        CurrencyDate := EndDate + 1;
        ReportType := NewReportType;  // 15-08-22 ZY-LD 002
    end;


    procedure GetData(var pAccountReceivableTmp: Record "Account Pay./Receiv Buffer" temporary)
    var
        lText001: label 'Transfer Data';
    begin
        //>> 15-08-22 ZY-LD 002
        if "Account Pay./Receiv Buffer".FindSet then begin
            repeat
                pAccountReceivableTmp := "Account Pay./Receiv Buffer";
                pAccountReceivableTmp.Insert;
            until "Account Pay./Receiv Buffer".Next() = 0;
        end;
        //<< 15-08-22 ZY-LD 002
    end;
}
