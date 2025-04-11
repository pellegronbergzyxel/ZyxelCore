Page 50126 "Purchase Order FactBox"
{
    Caption = 'Purchase Order FactBox';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }
}
