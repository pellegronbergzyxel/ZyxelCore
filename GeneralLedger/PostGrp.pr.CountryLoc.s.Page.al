Page 50045 "Post Grp. pr. Country / Loc.s"
{
    // 001. 25-02-19 ZY-LD 2019022010000075 - Created for handling consignment stock.

    Caption = 'Post Grp. pr. Country / Location';
    PageType = List;
    SourceTable = "Post Grp. pr. Country / Loc.";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Prod. Post. Group - Purch"; Rec."VAT Prod. Post. Group - Purch")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Prod. Post. Group - Sales"; Rec."VAT Prod. Post. Group - Sales")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }
}
