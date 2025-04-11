Page 50256 "Aging Code"
{
    // 001. 23-07-18 ZY-LD 2018072310000062 - New field.

    ApplicationArea = Basic, Suite;
    Caption = 'Aging Code';
    PageType = List;
    SourceTable = "Aging Code";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Due Days"; Rec."Due Days")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Aging Code"; Rec."Aging Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Allowance; Rec.Allowance)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; Notes)
            {
            }
            systempart(Control8; MyNotes)
            {
            }
            systempart(Control9; Links)
            {
            }
        }
    }

    actions
    {
    }
}
