Page 50032 "HR Payment Documentation"
{
    Caption = 'HR Payment Documentation';
    Editable = false;
    PageType = List;
    SourceTable = "HR Payment Documentation";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
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
