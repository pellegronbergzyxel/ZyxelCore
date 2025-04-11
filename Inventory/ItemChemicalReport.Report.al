Report 50047 "Item Chemical Report"
{
    // 001. 18-04-24 ZY-LD 000 - Get SCIP No. from subtable.

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Chemical Report.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Item Chemical Report';
    UsageCategory = ReportsandAnalysis;
    Permissions = tabledata "Sales Invoice Header" = rm;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";
            column(DocumentNo_SalesInvHead; "Sales Invoice Header"."No.")
            {
            }
            column(DocumentNo_SalesInvHead_Caption; Text002)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item), "Hide Line" = const(false));
                PrintOnlyIfDetail = true;
                column(Quantity_SalesInvLine; "Sales Invoice Line".Quantity)
                {
                }
                column(LineNo_SalesInvLine; "Sales Invoice Line"."Line No.")
                {
                }
                column(Quantity_SalesInvLine_Caption; "Sales Invoice Line".FieldCaption("Sales Invoice Line".Quantity))
                {
                }
                column(LineNo_SalesInvLine_Caption; "Sales Invoice Line".FieldCaption("Sales Invoice Line"."Line No."))
                {
                }
                dataitem(Item; Item)
                {
                    CalcFields = "Tax rate (SEK/kg)";
                    DataItemLink = "No." = field("No.");
                    DataItemTableView = sorting("No.") where("Tax Reduction Rate Active" = const(true));
                    column(No_Item; Item."No.")
                    {
                    }
                    column(Description_Item; Item.Description)
                    {
                    }
                    column(Length_Item; Item."Length (cm)")
                    {
                    }
                    column(Width_Item; Item."Width (cm)")
                    {
                    }
                    column(Height_Item; Item."Height (cm)")
                    {
                    }
                    column(Volume_Item; Item."Volume (cm3)")
                    {
                    }
                    column(TaxRedRate_Item; Item."Tax Reduction rate")
                    {
                    }
                    /*column(ScipNo_Item; Item."SCIP No.")  // 18-04-24 ZY-LD 001
                    {
                    }*/
                    column(ScipNo_Item; Item.GetScipNo)  // 18-04-24 ZY-LD 001
                    {
                    }
                    column(TaxRate_Item; Item."Tax rate (SEK/kg)")
                    {
                    }
                    column(NetWeight_Item; Item."Net Weight")
                    {
                    }
                    column(No_Caption; Text001)
                    {
                    }
                    column(Description_Caption; Item.FieldCaption(Item.Description))
                    {
                    }
                    column(Length_Caption; Item.FieldCaption(Item."Length (cm)"))
                    {
                    }
                    column(Width_Caption; Item.FieldCaption(Item."Width (cm)"))
                    {
                    }
                    column(Height_Caption; Item.FieldCaption(Item."Height (cm)"))
                    {
                    }
                    column(Volume_Caption; Item.FieldCaption(Item."Volume (cm3)"))
                    {
                    }
                    column(TaxRedRate_Caption; Item.FieldCaption(Item."Tax Reduction rate"))
                    {
                    }
                    column(ScipNo_Caption; Item.FieldCaption(Item."SCIP No."))
                    {
                    }
                    column(TaxRate_Caption; Item.FieldCaption(Item."Tax rate (SEK/kg)"))
                    {
                    }
                    column(NetWeight_Caption; Item.FieldCaption(Item."Net Weight"))
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        Item.SetFilter(Item."Tax Reduction Rate Date Filter", '..%1', WorkDate);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                "Sales Invoice Header"."Chemical Report Sent" := MarkAsSent;
                "Sales Invoice Header".Modify;
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
                    field(MarkAsSent; MarkAsSent)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mark Invoices as Sent';
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

    var
        Text001: label 'Item No.';
        Text002: label 'Invoice No.';
        MarkAsSent: Boolean;


    procedure Init(NewMarkAsSent: Boolean)
    begin
        MarkAsSent := NewMarkAsSent;
    end;
}
