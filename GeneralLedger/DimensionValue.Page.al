Page 50146 "Dimension Value"
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "Dimension Value";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Dimension Value Type"; Rec."Dimension Value Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Consolidation Code"; Rec."Consolidation Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension No."; Rec."Global Dimension No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Map-to IC Dimension Code"; Rec."Map-to IC Dimension Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Map-to IC Dimension Value Code"; Rec."Map-to IC Dimension Value Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Dimension Value ID"; Rec."Dimension Value ID")
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
