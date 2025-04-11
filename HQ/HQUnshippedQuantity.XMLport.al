xmlport 50048 "HQ Unshipped Quantity"
{
    // 001. 03-11-23 ZY-LD 000 - The field contains a unique ID for the HQ sales order line.

    Caption = 'HQ Unshipped Purchase Order';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/UnshippedQuantity';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement(UnshippedPurchaseOrder; "Unshipped Purchase Order")
            {
                XmlName = 'UnshippedQuantity';
                MinOccurs = Zero;
                UseTemporary = true;
                fieldelement(DocumentNo; UnshippedPurchaseOrder."Purchase Order No.")
                {
                }
                fieldelement(DocumentLineNo; UnshippedPurchaseOrder."Purchase Order Line No.")
                {
                }
                fieldelement(ItemNo; UnshippedPurchaseOrder."Item No.")
                {
                }
                fieldelement(EtdDate; UnshippedPurchaseOrder."ETD Date")
                {
                }
                fieldelement(EtaDate; UnshippedPurchaseOrder."ETA Date")
                {
                }
                fieldelement(ShippingOrderEtd; UnshippedPurchaseOrder."Shipping Order ETD Date")
                {
                }
                fieldelement(ExpectedReceiptDate; UnshippedPurchaseOrder."Expected Receipt Date")
                {
                }
                fieldelement(Quantity; UnshippedPurchaseOrder.Quantity)
                {
                }
                fieldelement(UnitPrice; UnshippedPurchaseOrder."Unit Price")
                {
                }
                fieldelement(HQSalesOrderLineID; UnshippedPurchaseOrder."Sales Order Line ID")  // 03-11-23 ZY-LD 001
                {
                }
            }
            // Unshipped quantity has more than one line with the same Purchase Order Line No. therefore can purchase line not be used.            
            /*            tableelement(PurchaseLine; "Purchase Line")
                        {
                            XmlName = 'UnshippedQuantity';
                            MinOccurs = Zero;
                            UseTemporary = true;
                            fieldelement(DocumentNo; PurchaseLine."Document No.")
                            {
                            }
                            fieldelement(DocumentLineNo; PurchaseLine."Line No.")
                            {
                            }
                            fieldelement(ItemNo; PurchaseLine."No.")
                            {
                            }
                            fieldelement(EtdDate; PurchaseLine."ETD Date")
                            {
                            }
                            fieldelement(EtaDate; PurchaseLine.ETA)
                            {
                            }
                            fieldelement(ShippingOrderEtd; PurchaseLine."Planned Receipt Date")
                            {
                            }
                            fieldelement(ExpectedReceiptDate; PurchaseLine."Expected Receipt Date")
                            {
                            }
                            fieldelement(Quantity; PurchaseLine.Quantity)
                            {
                            }
                            fieldelement(UnitPrice; PurchaseLine."Direct Unit Cost")
                            {
                            }
                            fieldelement(HQSalesOrderLineID; PurchaseLine."Sales Order Line ID")  // 03-11-23 ZY-LD 001
                            {
                            }

                            trigger OnBeforeInsertRecord()
                            begin
                                PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                                PurchaseLine.Type := PurchaseLine.Type::Item;
                            end;
                        }*/
        }
    }

    procedure GetData(var TempUnshipPurchOrder: Record "Unshipped Purchase Order" temporary)
    var
        ServerEnvironment: Record "Server Environment";
        Item: Record Item;
        lText001: Label '%1 must not be blank for %2 %3';
    begin
        if UnshippedPurchaseOrder.FindSet() then
            repeat
                if UnshippedPurchaseOrder."Sales Order Line ID" = '' then
                    Error(lText001, UnshippedPurchaseOrder.FieldCaption("Sales Order Line ID"), UnshippedPurchaseOrder."Purchase Order No.", UnshippedPurchaseOrder."Purchase Order Line No.");

                TempUnshipPurchOrder := UnshippedPurchaseOrder;
                if TempUnshipPurchOrder.Description = '' then begin
                    if item.get(TempUnshipPurchOrder."Item No.") then
                        TempUnshipPurchOrder.Description := item.Description;
                end;
                TempUnshipPurchOrder.Insert();
            until UnshippedPurchaseOrder.Next() = 0;
    end;
}
