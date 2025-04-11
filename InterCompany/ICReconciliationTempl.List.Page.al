Page 50363 "IC Reconciliation Templ. List"
{
    Caption = 'IC Reconciliation Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "IC Reconciliation Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}
