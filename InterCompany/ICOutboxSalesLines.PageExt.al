pageextension 50225 ICOutboxSalesLinesZX extends "IC Outbox Sales Lines"
{
    layout
    {
        addafter("Unit Price")
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
        addafter("Requested Delivery Date")
        {
            field("IC Payment Terms"; Rec."IC Payment Terms")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
