Page 50292 "Container Distances"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Container Distances';
    Description = 'Container Distances to calculate days from landing to customer';
    InstructionalText = 'Container Distances to calculate days from landing to customer';
    PageType = List;
    SourceTable = "Container Distances";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sea Days"; Rec."Sea Days")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Air Days"; Rec."Air Days")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Rail Days"; Rec."Rail Days")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Other Days"; Rec."Other Days")
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
