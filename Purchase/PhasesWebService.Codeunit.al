Codeunit 62023 "Phases Web Service"
{

    trigger OnRun()
    begin
    end;


    procedure SendPurchaseOrder(PurchaseOrders: XmlPort "PH Purchase Order"): Boolean
    begin
        PurchaseOrders.Import;
        PurchaseOrders.InsertData;
        exit(true);
    end;
}
