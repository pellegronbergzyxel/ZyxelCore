Page 50035 "Select Company"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Select Company';
    Editable = false;
    PageType = List;
    SourceTable = Company;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
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
