Page 50116 Warehouses
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = Location;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Warehouse; Rec.Warehouse)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Outbound FTP Code"; Rec."Warehouse Outbound FTP Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Inbound FTP Code"; Rec."Warehouse Inbound FTP Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Project ID"; Rec."Project ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Message Number Series"; Rec."Message Number Series")
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
