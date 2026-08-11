Page 50282 "Forecast Territory Countries"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - New fields.

    Caption = 'Forecast Territory Countries';
    DataCaptionFields = "Territory Code", "Territory Name";
    PageType = List;
    SourceTable = "Forecast Territory Country";
    ApplicationArea = all;
    UsageCategory = None;
    Permissions = tabledata "Forecast Territory Country" = RIMD;

    //10-08-2026 BK #588815
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the code of the territory.';
                    //Visible = false;
                }
                field("Territory Name"; Rec."Territory Name")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the name of the territory.';
                    //Visible = false;
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the code of the division.';
                }
                field("Forecast Territory Code"; Rec."Forecast Territory Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the code of the forecast territory.';
                    visible = false;
                }
            }
        }
    }

    actions
    {
    }
}
