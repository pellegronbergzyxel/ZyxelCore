Page 50156 "Warehouse Reason Codes"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Warehouse Reason Codes';
    PageType = List;
    SourceTable = "Warehouse Reason Code";
    UsageCategory = Administration;

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
