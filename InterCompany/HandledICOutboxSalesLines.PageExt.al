pageextension 50226 HandledICOutboxSalesLinesZX extends "Handled IC Outbox Sales Lines"
{
    layout
    {
        addafter("Line Discount Amount")
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
