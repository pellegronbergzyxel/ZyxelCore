pageextension 50280 WhseShipmentSubformZX extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Control3)
        {
            field("Delivery Document No."; Rec."Delivery Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
