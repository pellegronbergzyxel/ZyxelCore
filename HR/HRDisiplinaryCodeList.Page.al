Page 50178 "HR Disiplinary Code List"
{
    Caption = ' Disiplinary Code';
    CardPageID = "HR Disciplinary Code Card";
    PageType = List;
    SourceTable = "HR Disciplinary Code";

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
