page 50010 "eCommerce Warehouse"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Warehouse';
    PageType = List;
    SourceTable = "eCommerce Warehouse";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the unique code for the warehouse.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Sales Channel"; Rec."Sales Channel")
                {
                    ToolTip = 'Specifies the value of the Sales Channel field.';
                    Visible = false;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies in which country the warehouse is located.';
                }
            }
        }
    }
}
