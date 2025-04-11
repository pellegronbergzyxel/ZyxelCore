Page 50308 "Forecast Territory FactBox"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - Created.

    Caption = 'Forecast Territory Countries';
    PageType = ListPart;
    SourceTable = "Forecast Territory Country";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Division Code"; Rec."Division Code")
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
