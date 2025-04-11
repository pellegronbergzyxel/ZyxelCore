pageextension 50153 PostedPurchaseRcptSubformZX extends "Posted Purchase Rcpt. Subform"
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
        addafter("Expected Receipt Date")
        {
            field("Requested Date From Factory"; Rec."Requested Date From Factory")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Actual shipment date"; Rec."Actual shipment date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
