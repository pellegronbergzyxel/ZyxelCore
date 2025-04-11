XmlPort 50032 "HQ ContainerDetail"
{
    // 001. 23-04-20 ZY-LD 000 - "Bill of Lading No." should always be filled, according to Steven Su.

    DefaultNamespace = 'urn:microsoft-dynamics-nav/cd';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("VCK Shipping Detail"; "VCK Shipping Detail")
            {
                XmlName = 'ContainerDetail';
                UseTemporary = true;
                fieldelement(BillOfLadingNo; "VCK Shipping Detail"."Bill of Lading No.")
                {
                }
                fieldelement(ContainerNo; "VCK Shipping Detail"."Container No.")
                {
                }
                fieldelement(InvoiceNo; "VCK Shipping Detail"."Invoice No.")
                {
                }
                fieldelement(PurchaseOrderNo; "VCK Shipping Detail"."Purchase Order No.")
                {
                }
                fieldelement(PurchaseOrderLineNo; "VCK Shipping Detail"."Purchase Order Line No.")
                {
                }
                fieldelement(PalletNo; "VCK Shipping Detail"."Pallet No.")
                {
                }
                fieldelement(ItemNo; "VCK Shipping Detail"."Item No.")
                {
                }
                fieldelement(Quantity; "VCK Shipping Detail".Quantity)
                {
                }
                fieldelement(ETA; "VCK Shipping Detail".ETA)
                {
                }
                fieldelement(ETD; "VCK Shipping Detail".ETD)
                {
                }
                fieldelement(ShippingMethod; "VCK Shipping Detail"."Shipping Method")
                {
                }
                fieldelement(OrderNo; "VCK Shipping Detail"."Order No.")
                {
                }
                fieldelement(MainWarehouse; "VCK Shipping Detail"."Main Warehouse")
                {
                }
                fieldelement(VesselCode; "VCK Shipping Detail"."Vessel Code")
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    EntryNo += 1;
                    "VCK Shipping Detail"."Entry No." := EntryNo;
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

    var
        EntryNo: Integer;


    procedure GetData(var pContainerDetail: Record "VCK Shipping Detail" temporary)
    var
        lText001: label '"%1" is blank on: %2: %3, %4: %5, %6: %7. Container details has not been imported.';
    begin
        if "VCK Shipping Detail".FindSet then
            repeat
                //>> 23-04-20 ZY-LD 001
                if ("VCK Shipping Detail"."Container No." = '') and
                   ("VCK Shipping Detail"."Bill of Lading No." = '')
                then
                    Error(lText001,
                      "VCK Shipping Detail".FieldCaption("Bill of Lading No."),
                      "VCK Shipping Detail".FieldCaption("Invoice No."), "VCK Shipping Detail"."Invoice No.",
                      "VCK Shipping Detail".FieldName("Purchase Order No."), "VCK Shipping Detail"."Purchase Order No.",
                      "VCK Shipping Detail".FieldName("Purchase Order Line No."), "VCK Shipping Detail"."Purchase Order Line No.");
                //<< 23-04-20 ZY-LD 001

                pContainerDetail := "VCK Shipping Detail";
                pContainerDetail.Insert;
            until "VCK Shipping Detail".Next() = 0;
    end;
}
