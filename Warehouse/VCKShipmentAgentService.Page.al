Page 50104 "VCK Shipment Agent Service"
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "VCK Shipment Agent Service";
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
                field("Shipment Agent Code"; Rec."Shipment Agent Code")
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
