Page 50031 "Forecast Territory List"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - New Factbox.

    Caption = 'Forecast Territory List';
    PageType = List;
    SourceTable = "Forecast Territory";

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
                field("Show on Forecast List"; Rec."Show on Forecast List")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Calc. CH Forecast on Cust. No."; Rec."Calc. CH Forecast on Cust. No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Automatic Invoice Handling"; Rec."Automatic Invoice Handling")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control2; "Forecast Territory FactBox")
            {
                SubPageLink = "Forecast Territory Code" = field(Code);
            }
        }
    }

    actions
    {
    }
}
