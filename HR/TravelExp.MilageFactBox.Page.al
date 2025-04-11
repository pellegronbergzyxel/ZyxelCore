Page 50274 "Travel Exp. Milage FactBox"
{
    PageType = CardPart;
    SourceTable = "Travel Expense Line";

    layout
    {
        area(content)
        {
            field("Car Business Distance"; Rec."Car Business Distance")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Car Business Distance (KM)';
            }
            field("Car Personal Distance"; Rec."Car Personal Distance")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Car Personal Distance (KM)';
            }
            field("Vehicle Id"; Rec."Vehicle Id")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }
}
