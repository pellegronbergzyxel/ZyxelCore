Page 50300 "HQ Entitys"
{
    Caption = 'HQ Entitys';
    PageType = List;
    SourceTable = "HQ Entity";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("No."; Rec."No.")
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
        }
    }

    actions
    {
    }
}
