page 50113 "Zyxel Companies"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Zyxel Companies';
    PageType = List;
    SourceTable = "Zyxel Company";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("HQ Company"; Rec."HQ Company")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Option"; Rec."Company Option")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
