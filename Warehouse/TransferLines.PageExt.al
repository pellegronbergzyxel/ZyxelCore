PageExtension 50253 TransferLinesZX extends "Transfer Lines"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Shipment Date Confirmed"; Rec."Shipment Date Confirmed")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
