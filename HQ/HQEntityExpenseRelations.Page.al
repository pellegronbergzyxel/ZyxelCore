Page 50049 "HQ Entity Expense Relations"
{
    // 001. 05-06-18 ZY-LD 2018060410000242 - Created.

    Caption = 'HQ Entity Expense Relations';
    PageType = List;
    SourceTable = "HQ Entity Expense Relation";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("HQ Expense Category"; Rec."HQ Expense Category")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("HQ Entity"; Rec."HQ Entity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("HQ Department Code"; Rec."HQ Department Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }
}
