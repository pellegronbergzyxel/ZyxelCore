Page 50296 "Zyxel Employee Details"
{
    // 001. 22-05-18 ZY-LD 2018050910000191 - New field.

    Caption = 'Zyxel Employee Details';
    PageType = CardPart;
    SourceTable = "ZyXEL Employee";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("First Name"; Rec."First Name")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Middle Name"; Rec."Middle Name")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Name"; Rec."Last Name")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }
}
