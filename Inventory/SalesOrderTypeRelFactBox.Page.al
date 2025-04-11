page 50136 "Sales Order Type Rel. FactBox"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Order Type Rel. FactBox';
    PageType = ListPart;
    SourceTable = "Sales Order Type Relation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sales Order Type"; Rec."Sales Order Type") { }
                field("Default Order Type Location"; Rec."Default Order Type Location") { }
            }
        }
    }
}
