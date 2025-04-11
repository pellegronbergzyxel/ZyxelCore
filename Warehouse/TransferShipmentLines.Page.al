page 50139 "Transfer Shipment Lines"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Transfer Shipment Lines';
    PageType = List;
    SourceTable = "Transfer Shipment Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { }
                field("Transfer Order No."; Rec."Transfer Order No.") { }
                field("Shipment Date"; Rec."Shipment Date") { }
                field("Posting Date"; TransShipHead."Posting Date") { }
                field("Transfer-from Code"; Rec."Transfer-from Code") { }
                field("Transfer-to Code"; Rec."Transfer-to Code") { }
                field("In-Transit Code"; Rec."In-Transit Code") { }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field(Quantity; Rec.Quantity) { }
                field("Unit of Measure"; Rec."Unit of Measure") { }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = false;
                }
            }
        }
    }
    var
        TransShipHead: Record "Transfer Shipment Header";

    trigger OnAfterGetRecord()
    begin
        TransShipHead.get(Rec."Document No.");
    end;
}
