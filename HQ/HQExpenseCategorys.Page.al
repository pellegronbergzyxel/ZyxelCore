Page 50009 "HQ Expense Categorys"
{
    // 001. 05-06-18 ZY-LD 2018060410000242 - Created.

    Caption = 'HQ Expense Categorys';
    PageType = List;
    SourceTable = "HQ Expense Category";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
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
        area(navigation)
        {
            action("HQ Department Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'HQ Department Code';
                Image = Category;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HQ Entity Expense Relations";
                RunPageLink = "HQ Expense Category" = field("No.");
            }
        }
    }
}
