report 50077 "Customer - Open Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Open Entries.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Customer - Open Entries';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Date Filter";
            column(TodayFormatted; Format(Today))
            {
            }
            column(PeriodVendDatetFilter; StrSubstNo(Text000, VendorDateFilter))
            {
            }
            column(CompanyName; CompanyName())
            {
            }
            column(VendFilterCaption; Customer.TableCaption + ': ' + VendorFilter)
            {
            }
            column(VendFilter; VendorFilter)
            {
            }
            column(No_Vend; Customer."No.")
            {
            }
            column(Name_Vend; Customer.Name)
            {
            }
            column(PhoneNo_Vend; Customer."Phone No.")
            {
                IncludeCaption = true;
            }
            column(VendOpenEntriesCaption; VendOpenEntriesCaptionLbl)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter");
                DataItemTableView = sorting("Customer No.", "Posting Date") where(Open = const(true));
                column(PostDate_VendLedgEntry; Format("Cust. Ledger Entry"."Posting Date"))
                {
                }
                column(DocType_VendLedgEntry; "Cust. Ledger Entry"."Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_VendLedgEntry; "Cust. Ledger Entry"."Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_VendLedgEntry; "Cust. Ledger Entry".Description)
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode_VendLedgEntry; "Cust. Ledger Entry"."Currency Code")
                {
                    IncludeCaption = true;
                }
                column(Amount_VendLedgEntry; "Cust. Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    IncludeCaption = true;
                }
                column(RemainAmount_VendLedgEntry; "Cust. Ledger Entry"."Remaining Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    IncludeCaption = true;
                }
                column(VendEntryDueDate; Format(VendorEntryDueDate))
                {
                }
                column(EntryNo_VendLedgEntry; "Cust. Ledger Entry"."Entry No.")
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_VendLedgEntry; "Cust. Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                    IncludeCaption = true;
                }
                column(RemainAmtLCY_VendLedgEntry; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocNo; "Cust. Ledger Entry"."External Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."document type"::Payment then
                        VendorEntryDueDate := 0D
                    else
                        VendorEntryDueDate := "Cust. Ledger Entry"."Due Date";
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CREATETOTALS("Remaining Amt. (LCY)","Amount (LCY)");  // 09-03-23 ZY-LD 001
                    //SETRANGE(Open,TRUE);  // 09-03-23 ZY-LD 001
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                //CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;  // 09-03-23 ZY-LD 001
                //CurrReport.CREATETOTALS("Vendor Ledger Entry"."Remaining Amt. (LCY)","Vendor Ledger Entry"."Amount (LCY)");  // 09-03-23 ZY-LD 001
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Customer';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        VendorFilter := Customer.GetFilters;
        VendorDateFilter := Customer.GetFilter("Date Filter");
    end;

    var
        PrintOnlyOnePerPage: Boolean;
        VendorFilter: Text[250];
        VendorDateFilter: Text[30];
        VendorEntryDueDate: Date;
        PageGroupNo: Integer;
        VendOpenEntriesCaptionLbl: label 'Customer - Open Entries';
        PageNoCaptionLbl: label 'Page';
        Text000: label 'Period: %1';
}