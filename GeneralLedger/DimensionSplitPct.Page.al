Page 61309 "Dimension Split Pct."
{
    PageType = List;
    SourceTable = "Dimension Split Pct.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Dimension Split Code"; Rec."Dimension Split Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Split %"; Rec."Split %")
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
