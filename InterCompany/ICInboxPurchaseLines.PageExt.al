pageextension 50228 ICInboxPurchaseLinesZX extends "IC Inbox Purchase Lines"
{
    layout
    {
        modify("IC Partner Ref. Type")
        {
            Editable = false;
        }
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
