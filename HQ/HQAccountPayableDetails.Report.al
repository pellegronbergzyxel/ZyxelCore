Report 50184 "HQ Account Payable Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HQ Account Payable Details.rdlc';
    Caption = 'HQ Account Payable Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Replication Company"; "Replication Company")
        {
            RequestFilterFields = "Company Name";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Replication Company"."Company Name", 0, true);
                ZyWebServMgt.GetAccountPay_Receivable(0, "Replication Company"."Company Name", EndDate, CurrencyDate, ReportingCurrency, "Account Pay./Receiv Buffer");
                RunCurrentCompany := false;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                if "Replication Company".GetFilter("Replication Company"."Company Name") = '' then
                    "Replication Company".SetRange("Replication Company"."HQ Account Payable Details", true);

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
            column(VendorNo; "Account Pay./Receiv Buffer"."Source No.")
            {
            }
            column(VendorName; "Account Pay./Receiv Buffer"."Source Name")
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
            column(VendorInvoiceNo; "Account Pay./Receiv Buffer"."Vendor Invoice No.")
            {
            }
            column(PostingDate; "Account Pay./Receiv Buffer"."Posting Date")
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
            column(DueDate; "Account Pay./Receiv Buffer"."Due Date")
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
            column(GlAccNo_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."G/L Account No."))
            {
            }
            column(GlAccName_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."G/L Account Name"))
            {
            }
            column(VendorNo_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Source No."))
            {
            }
            column(VendorName_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Source Name"))
            {
            }
            column(Division_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer".Division))
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
            column(PostingDate_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Posting Date"))
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
            column(LcyEndingBalance_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."LCY Ending Balance"))
            {
            }
            column(RptCurrencyCode_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."RPT Currency Code"))
            {
            }
            column(RptAmount_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."RPT Amount"))
            {
            }
            column(RptEndingBalance_Caption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."RPT Ending Balance"))
            {
            }
            column(DueDateCaption; "Account Pay./Receiv Buffer".FieldName("Account Pay./Receiv Buffer"."Due Date"))
            {
            }

            trigger OnPreDataItem()
            begin
                if RunCurrentCompany then
                    xmlAccountPayReceiv.GetDataPayReceive(0, EndDate, CurrencyDate, ReportingCurrency, "Account Pay./Receiv Buffer");
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
        EndDate: Date;
        CurrencyDate: Date;
        ReportingCurrency: Code[10];
        RunCurrentCompany: Boolean;
        Text001: label 'Entity Name';
}
