Page 50265 "Travel Exp. Expense Types"
{
    Caption = 'Travel Exp. Expense Types';
    PageType = List;
    SourceTable = "Travel Exp. Expense Type";
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Type"; Rec."Posting Type")
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
