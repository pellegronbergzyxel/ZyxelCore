page 50137 "Transfer Order Lines"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Transfer Order Lines';
    PageType = List;
    SourceTable = "Transfer Line";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { }
                field("Transfer-from Code"; Rec."Transfer-from Code") { }
                field("Transfer-to Code"; Rec."Transfer-to Code") { }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field(Quantity; Rec.Quantity) { }
                field("Unit of Measure"; Rec."Unit of Measure") { }
                field("Quantity Shipped"; Rec."Quantity Shipped") { }
                field("Quantity Received"; Rec."Quantity Received") { }
                field(ShipmentDateConfirmed; Rec."Shipment Date Confirmed") { }
                field("Shipment Date"; Rec."Shipment Date") { }
                field("Delivery Document No."; Rec."Delivery Document No.") { }
                field("Warehouse Status"; Rec."Warehouse Status") { }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = false;
                }
            }
        }
    }
}
