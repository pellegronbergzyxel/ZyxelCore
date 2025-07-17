xmlport 50048 "HQ Unshipped Quantity"
{

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
                fieldelement(HQSalesOrderLineID; UnshippedPurchaseOrder."Sales Order Line ID")
                {
                }
                /*
                fieldelement(DNNumber; UnshippedPurchaseOrder."DN Number")
                {
                }
                */ //Mail from John in HQ - first in test BK
            }

        }
    }

    procedure GetData(var TempUnshipPurchOrder: Record "Unshipped Purchase Order" temporary)
    var
        Item: Record Item;
        lText001: Label '%1 must not be blank for %2 %3';
    begin
        if UnshippedPurchaseOrder.FindSet() then
            repeat
                if UnshippedPurchaseOrder."Sales Order Line ID" = '' then
                    Error(lText001, UnshippedPurchaseOrder.FieldCaption("Sales Order Line ID"), UnshippedPurchaseOrder."Purchase Order No.", UnshippedPurchaseOrder."Purchase Order Line No.");

                TempUnshipPurchOrder := UnshippedPurchaseOrder;
                if TempUnshipPurchOrder.Description = '' then
                    if item.get(TempUnshipPurchOrder."Item No.") then
                        TempUnshipPurchOrder.Description := item.Description;
                TempUnshipPurchOrder.Insert();
            until UnshippedPurchaseOrder.Next() = 0;
    end;
}
