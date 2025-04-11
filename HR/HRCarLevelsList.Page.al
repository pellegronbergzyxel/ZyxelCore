Page 50176 "HR Car Levels List"
{
    Caption = 'Car Levels';
    CardPageID = "HR Car Levels Card";
    PageType = List;
    SourceTable = "HR Car Levels";

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
