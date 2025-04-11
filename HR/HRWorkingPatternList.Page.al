Page 50174 "HR Working Pattern List"
{
    Caption = 'Working Pattern';
    CardPageID = "HR Working Pattern Card";
    PageType = List;
    SourceTable = "HR Working Pattern";

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
                field(Description; Rec.Description)
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
