pageextension 50200 PurchaseLinesZX extends "Purchase Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Variant Code")
        {
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Actual shipment date"; Rec."Actual shipment date")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Line No.")
        {
            field(OriginalLineNo; Rec.OriginalLineNo)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
