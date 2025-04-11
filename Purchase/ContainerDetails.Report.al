Report 50121 "Container Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Container Details.rdlc';
    Caption = 'Container Details';

    dataset
    {
        dataitem("VCK Shipping Detail"; "VCK Shipping Detail")
        {
            column(BillOfLadingNo; "VCK Shipping Detail"."Bill of Lading No.")
            {
            }
            column(ContainerNo; "VCK Shipping Detail"."Container No.")
            {
            }
            column(InvoiceNo; "VCK Shipping Detail"."Invoice No.")
            {
            }
            column(PurchaseOrderNo; "VCK Shipping Detail"."Purchase Order No.")
            {
            }
            column(PurchaseOrderLineNo; "VCK Shipping Detail"."Purchase Order Line No.")
            {
            }
            column(PalletNo; "VCK Shipping Detail"."Pallet No.")
            {
            }
            column(ItemNo; "VCK Shipping Detail"."Item No.")
            {
            }
            column(Quantity; "VCK Shipping Detail".Quantity)
            {
            }
            column(ETADate; "VCK Shipping Detail".ETA)
            {
            }
            column(EDTDate; "VCK Shipping Detail".ETD)
            {
            }
            column(ShippingMethod; "VCK Shipping Detail"."Shipping Method")
            {
            }
            column(OrderNo; "VCK Shipping Detail"."Order No.")
            {
            }
            column(InboundOrderNo; "VCK Shipping Detail"."Document No.")
            {
            }
            column(InboundOrderLineNo; "VCK Shipping Detail"."Line No.")
            {
            }
            column(LocationCode; "VCK Shipping Detail".Location)
            {
            }
            column(BillOfLadingNoCaption; "VCK Shipping Detail".FieldCaption("Bill of Lading No."))
            {
            }
            column(ContainerNoCaption; "VCK Shipping Detail".FieldCaption("Container No."))
            {
            }
            column(InvoiceNoCaption; "VCK Shipping Detail".FieldCaption("Invoice No."))
            {
            }
            column(PurchaseOrderNoCaption; "VCK Shipping Detail".FieldCaption("Purchase Order No."))
            {
            }
            column(PurchaseOrderLineNoCaption; "VCK Shipping Detail".FieldCaption("Purchase Order Line No."))
            {
            }
            column(PalletNoCaption; "VCK Shipping Detail".FieldCaption("Pallet No."))
            {
            }
            column(ItemNoCaption; "VCK Shipping Detail".FieldCaption("Item No."))
            {
            }
            column(QuantityCaption; "VCK Shipping Detail".FieldCaption(Quantity))
            {
            }
            column(ETADateCaption; "VCK Shipping Detail".FieldCaption(ETA))
            {
            }
            column(EDTDateCaption; "VCK Shipping Detail".FieldCaption(ETD))
            {
            }
            column(ShippingMethodCaption; "VCK Shipping Detail".FieldCaption("Shipping Method"))
            {
            }
            column(OrderNoCaption; "VCK Shipping Detail".FieldCaption("Order No."))
            {
            }
            column(InboundOrderNoCaption; Text001)
            {
            }
            column(InbountOrderLineNoCaption; Text002)
            {
            }
            column(LocationCodeCaption; Text003)
            {
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
        Text001: label 'Inbound Order No.';
        Text002: label 'Inbound Order Line No.';
        Text003: label 'Location Code';
}
