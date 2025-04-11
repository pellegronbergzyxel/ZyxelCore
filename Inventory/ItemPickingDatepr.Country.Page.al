Page 50057 "Item Picking Date pr. Country"
{
    // 001. 19-03-19 ZY-LD 2019031910000031 - Created.

    Caption = 'Item Picking Date pr. Country';
    PageType = List;
    SourceTable = "Item Picking Date pr. Country";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country Code"; Rec."Ship-to Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Picking Start Date"; Rec."Picking Start Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
