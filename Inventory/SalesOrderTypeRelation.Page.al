page 50135 "Sales Order Type Relation"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Order Type Relation';
    PageType = List;
    SourceTable = "Sales Order Type Relation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field("Sales Order Type"; Rec."Sales Order Type") { }
                field("Default Order Type Location"; Rec."Default Order Type Location") { }
            }
        }
    }
}
