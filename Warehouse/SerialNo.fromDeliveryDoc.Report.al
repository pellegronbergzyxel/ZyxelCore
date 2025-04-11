Report 50113 "Serial No. from Delivery Doc"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Serial No. from Delivery Doc.rdlc';
    Caption = 'Serial No. from Delivery Document';

    dataset
    {
        dataitem("VCK Delivery Document Header"; "VCK Delivery Document Header")
        {
            RequestFilterFields = "No.";
            dataitem("VCK Delivery Document SNos"; "VCK Delivery Document SNos")
            {
                DataItemLink = "Delivery Document No." = field("No.");
                DataItemTableView = sorting("Serial No.", "Delivery Document No.", "Delivery Document Line No.");
                column(DeliveryDocumentNo; "VCK Delivery Document Header"."No.")
                {
                }
                column(CustomerOrderNo; "VCK Delivery Document SNos"."Customer Order No.")
                {
                }
                column(ItemNo; "VCK Delivery Document SNos"."Item No.")
                {
                }
                column(SerialNo; "VCK Delivery Document SNos"."Serial No.")
                {
                }
                column(CustomerItemNo; recItemCrossRef."Reference No.")
                {
                }
                column(CountryOfOrigin; recItem."Country/Region of Origin Code")
                {
                }
                column(GrossWeight; recItem."Gross Weight")
                {
                }
                column(NetWeight; recItem."Net Weight")
                {
                }
                column(DeliveryDocumentNo_Caption; "VCK Delivery Document Header".FieldCaption("No."))
                {
                }
                column(CustomerOrderNo_Caption; "VCK Delivery Document SNos".FieldCaption("Customer Order No."))
                {
                }
                column(ItemNo_Caption; "VCK Delivery Document SNos".FieldCaption("Item No."))
                {
                }
                column(SerialNo_Caption; "VCK Delivery Document SNos".FieldCaption("Serial No."))
                {
                }
                column(CustomerItemNo_Caption; Text001)
                {
                }
                column(CountryOfOrigin_Caption; recItem.FieldCaption("Country/Region of Origin Code"))
                {
                }
                column(GrossWeight_Caption; recItem.FieldCaption("Gross Weight"))
                {
                }
                column(NetWeight_Caption; recItem.FieldCaption("Net Weight"))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    recItem.Get("VCK Delivery Document SNos"."Item No.");
                    recItemCrossRef.SetRange("Reference Type", recItemCrossRef."reference type"::Customer);
                    recItemCrossRef.SetRange("Reference Type No.", "VCK Delivery Document Header"."Sell-to Customer No.");
                    recItemCrossRef.SetRange("Item No.", "VCK Delivery Document SNos"."Item No.");
                    if not recItemCrossRef.FindFirst then
                        Clear(recItemCrossRef);
                end;
            }
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
        recItem: Record Item;
        recItemCrossRef: Record "Item Reference";
        Text001: label 'Customer Item No.';
}
