Page 50018 "EU Articles"
{
    Caption = 'EU Articles';
    PageType = List;
    SourceTable = "EU Article";

    layout
    {
        area(content)
        {
            repeater(Control2)
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
        }
    }

    actions
    {
    }
}
