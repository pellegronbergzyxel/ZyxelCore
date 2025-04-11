Report 50050 "Vendor - Open Entries"
{
    // 16-58056  17/10/16  TB
    //   PES-JLP-16-58056 refers
    //   Created.
    // 001. 09-03-23 ZY-LD 000 - Minor changes due to upgrade.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Open Entries.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Vendor - Open Entries';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Date Filter";
            column(TodayFormatted; Format(Today))
            {
            }
            column(PeriodVendDatetFilter; StrSubstNo(Text000, VendorDateFilter))
            {
            }
            column(CompanyName; CompanyName())
            {
            }
            column(VendFilterCaption; Vendor.TableCaption + ': ' + VendorFilter)
            {
            }
            column(VendFilter; VendorFilter)
            {
            }
            column(No_Vend; Vendor."No.")
            {
            }
            column(Name_Vend; Vendor.Name)
            {
            }
            column(PhoneNo_Vend; Vendor."Phone No.")
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
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter");
                DataItemTableView = sorting("Vendor No.", "Posting Date") where(Open = const(true));
                column(PostDate_VendLedgEntry; Format("Vendor Ledger Entry"."Posting Date"))
                {
                }
                column(DocType_VendLedgEntry; "Vendor Ledger Entry"."Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_VendLedgEntry; "Vendor Ledger Entry"."Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_VendLedgEntry; "Vendor Ledger Entry".Description)
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode_VendLedgEntry; "Vendor Ledger Entry"."Currency Code")
                {
                    IncludeCaption = true;
                }
                column(Amount_VendLedgEntry; "Vendor Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    IncludeCaption = true;
                }
                column(RemainAmount_VendLedgEntry; "Vendor Ledger Entry"."Remaining Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    IncludeCaption = true;
                }
                column(VendEntryDueDate; Format(VendorEntryDueDate))
                {
                }
                column(EntryNo_VendLedgEntry; "Vendor Ledger Entry"."Entry No.")
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_VendLedgEntry; "Vendor Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                    IncludeCaption = true;
                }
                column(RemainAmtLCY_VendLedgEntry; "Vendor Ledger Entry"."Remaining Amt. (LCY)")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocNo; "Vendor Ledger Entry"."External Document No.")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."document type"::Payment then
                        VendorEntryDueDate := 0D
                    else
                        VendorEntryDueDate := "Vendor Ledger Entry"."Due Date";
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Vendor';
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

    trigger OnPreReport()
    begin
        VendorFilter := Vendor.GetFilters;
        VendorDateFilter := Vendor.GetFilter("Date Filter");
    end;

    var
        PrintOnlyOnePerPage: Boolean;
        VendorFilter: Text[250];
        VendorDateFilter: Text[30];
        VendorEntryDueDate: Date;
        PageGroupNo: Integer;
        Text000: label 'Period: %1';
        VendOpenEntriesCaptionLbl: label 'Vendor - Open Entries';
        PageNoCaptionLbl: label 'Page';
}
