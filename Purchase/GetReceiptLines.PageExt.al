pageextension 50242 GetReceiptLinesZX extends "Get Receipt Lines"
{
    layout
    {
        addafter("Location Code")
        {
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Qty. Rcd. Not Invoiced")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
