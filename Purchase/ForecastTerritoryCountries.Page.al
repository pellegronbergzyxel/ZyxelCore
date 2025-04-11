Page 50282 "Forecast Territory Countries"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - New fields.

    Caption = 'Forecast Territory Countries';
    DataCaptionFields = "Territory Code", "Territory Name";
    PageType = List;
    SourceTable = "Forecast Territory Country";
    ApplicationArea = all;
    UsageCategory = none;
    Permissions = tabledata "Forecast Territory Country" = RIMD;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Territory Name"; Rec."Territory Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecast Territory Code"; Rec."Forecast Territory Code")
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
