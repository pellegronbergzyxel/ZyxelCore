Page 50031 "Forecast Territory List"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - New Factbox.

    Caption = 'Forecast Territory List';
    PageType = List;
    SourceTable = "Forecast Territory";
    applicationarea = Basic, Suite;
    usagecategory = Lists;
    // 
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the code of the forecast territory.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the description of the forecast territory.';
                }
                field("Show on Forecast List"; Rec."Show on Forecast List")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the forecast territory is shown on the forecast list.';
                }
                field("Calc. CH Forecast on Cust. No."; Rec."Calc. CH Forecast on Cust. No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the forecast territory is calculated on the customer number.';
                }
                field("Automatic Invoice Handling"; Rec."Automatic Invoice Handling")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the forecast territory has automatic invoice handling enabled.';
                }
            }
        }
        area(factboxes)
        {
            part(Control2; "Forecast Territory FactBox")
            {
                SubPageLink = "Forecast Territory Code" = field(Code);
                tooltip = 'Specifies the forecast territory factbox.';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            Group(Territory)
            {
                Caption = 'Territory';
                Tooltip = 'Specifies the territory actions.';

                action("Territory Countries") //10-08-2026 BK #588815
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the territory countries.';
                    Caption = 'Territory Countries';
                    Image = ItemAvailbyLoc;
                    Promoted = true;
                    RunPageLink = "Forecast Territory Code" = field(Code);
                    RunObject = Page "Forecast Territory Countries";
                }
            }
        }
    }
}
