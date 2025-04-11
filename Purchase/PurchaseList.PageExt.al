pageextension 50135 PurchaseListZX extends "Purchase List"
{
    layout
    {
        modify("No.")
        {
            Style = Strong;
            StyleExpr = true;
        }
        addfirst(Control1)
        {
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = Basic, Suite;
            }
            field(IsEICard; Rec.IsEICard)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vendor Status"; Rec."Vendor Status")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Warehouse Status"; Rec."Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("EiCard Status"; Rec."EiCard Status")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
