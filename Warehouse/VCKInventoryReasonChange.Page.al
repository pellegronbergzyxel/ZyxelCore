Page 50098 "VCK Inventory Reason Change"
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "VCK Inventory Reason Change";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
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
