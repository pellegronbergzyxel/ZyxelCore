Page 50091 "Sales Comment Line FactBox"
{
    Editable = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Comment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}
