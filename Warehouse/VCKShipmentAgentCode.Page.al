Page 50103 "VCK Shipment Agent Code"
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "VCK Shipment Agent Code";
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
                field(Default; Rec.Default)
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
