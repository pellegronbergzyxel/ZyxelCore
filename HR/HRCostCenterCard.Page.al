Page 50173 "HR Cost Center Card"
{
    Caption = 'Cost Center';
    PageType = Card;
    SourceTable = "HR Cost Centre";

    layout
    {
        area(content)
        {
            group(General)
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
        area(factboxes)
        {
            systempart(Control1000000000; Links)
            {
                Visible = true;
            }
            systempart(Control1000000001; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}
