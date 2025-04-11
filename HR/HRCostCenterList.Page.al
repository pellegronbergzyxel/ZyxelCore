Page 50172 "HR Cost Center List"
{
    Caption = 'Cost Center';
    CardPageID = "HR Cost Center Card";
    PageType = List;
    SourceTable = "HR Cost Centre";

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
