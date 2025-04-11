Page 50170 "HR Division List"
{
    Caption = 'Division';
    CardPageID = "HR Division Card";
    PageType = List;
    SourceTable = "HR Division";

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
