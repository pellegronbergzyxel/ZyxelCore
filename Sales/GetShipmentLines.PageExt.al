pageextension 50241 GetShipmentLinesZX extends "Get Shipment Lines"
{
    Editable = true;

    layout
    {
        addfirst(Control1)
        {
            field("Picking List No."; Rec."Picking List No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Packing List No."; Rec."Packing List No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Qty. Shipped Not Invoiced")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
