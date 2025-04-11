Page 50168 "HR Department List"
{
    Caption = 'Department';
    CardPageID = "HR Department Card";
    PageType = List;
    SourceTable = "HR Department";

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
