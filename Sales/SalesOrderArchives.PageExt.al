pageextension 50011 "Sales Order Archives" extends "Sales Order Archives"
{
    layout
    {
        addlast(Control1)
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
