pageextension 50229 HandledICInboxPurchLinesZX extends "Handled IC Inbox Purch. Lines"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
