Report 50030 "Confirmation Backlog"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Confirmation Backlog.rdlc';
    Caption = 'Confirmation Backlog';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(PickingDateConfirmedRec; "Picking Date Confirmed")
        {
            CalcFields = "Item Description", "Sell-to Customer Name";
            RequestFilterFields = "Source Type", "Source No.", "Item No.", "Picking Date Confirmed";
            column(CustNo; PickingDateConfirmedRec."Sell-to Customer No.")
            {
            }
            column(CustName; PickingDateConfirmedRec."Sell-to Customer Name")
            {
            }
            column(SourceType; PickingDateConfirmedRec."Source Type")
            {
            }
            column(SourceNo; PickingDateConfirmedRec."Source No.")
            {
            }
            column(PickingDate; PickingDateConfirmedRec."Picking Date")
            {
            }
            column(PickingDateConfirmed; PickingDateConfirmedRec."Picking Date Confirmed")
            {
            }
            column(ItemNo; PickingDateConfirmedRec."Item No.")
            {
            }
            column(ItemDescription; PickingDateConfirmedRec."Item Description")
            {
            }
            column(Quantity; PickingDateConfirmedRec."Outstanding Quantity")
            {
            }
            column(LocationCode; PickingDateConfirmedRec."Location Code")
            {
            }
            column(OrderDate; OrderDate)
            {
            }
            column(CustNo_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Sell-to Customer No."))
            {
            }
            column(CustName_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Sell-to Customer Name"))
            {
            }
            column(SourceType_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Source Type"))
            {
            }
            column(SourceNo_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Source No."))
            {
            }
            column(PickingDate_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Picking Date"))
            {
            }
            column(PickingDateConfirmed_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Picking Date Confirmed"))
            {
            }
            column(ItemNo_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Item No."))
            {
            }
            column(ItemDescription_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Item Description"))
            {
            }
            column(Quantity_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Outstanding Quantity"))
            {
            }
            column(LocationCode_Caption; PickingDateConfirmedRec.FieldCaption(PickingDateConfirmedRec."Location Code"))
            {
            }
            column(OrderDate_Caption; Text001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                OrderDate := 0D;
                case PickingDateConfirmedRec."Source Type" of
                    PickingDateConfirmedRec."source type"::"Sales Order":
                        if recSalesHead.Get(recSalesHead."document type"::Order, PickingDateConfirmedRec."Source No.") then
                            OrderDate := recSalesHead."Order Date";
                    PickingDateConfirmedRec."source type"::"Transfer Order":
                        if recTransHead.Get(PickingDateConfirmedRec."Source No.") then
                            OrderDate := recTransHead."Posting Date";
                end;
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
    }

    var
        recSalesHead: Record "Sales Header";
        recTransHead: Record "Transfer Header";
        OrderDate: Date;
        Text001: label 'Order Date';
}
