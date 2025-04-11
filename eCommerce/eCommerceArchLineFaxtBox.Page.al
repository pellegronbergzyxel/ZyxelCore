page 50315 "eCommerce Arch. Line FaxtBox"
{
    PageType = CardPart;
    SourceTable = "eCommerce Order Line Archive";

    layout
    {
        area(content)
        {
            field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Total Tax Amount"; Rec."Total Tax Amount")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
            }
            field("Total Shipping (Exc. Tax)"; Rec."Total Shipping (Exc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Total Shipping Tax Amount"; Rec."Total Shipping Tax Amount")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Total Shipping (Inc. Tax)"; Rec."Total Shipping (Inc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
            }
            field("Shipping Promo (Exc. Tax)"; Rec."Shipping Promo (Exc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Shipping Promo Tax Amount"; Rec."Shipping Promo Tax Amount")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Shipping Promo (Inc. Tax)"; Rec."Shipping Promo (Inc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
            }
            field("Total Promo (Exc. Tax)"; Rec."Total Promo (Exc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Total Promo Tax Amount"; Rec."Total Promo Tax Amount")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Total Promo (Inc. Tax)"; Rec."Total Promo (Inc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
            }
            field("Gift Wrap (Exc. Tax)"; Rec."Gift Wrap (Exc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Gift Wrap Tax Amount"; Rec."Gift Wrap Tax Amount")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Gift Wrap (Inc. Tax)"; Rec."Gift Wrap (Inc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
            }
            field("Gift Wrap Promo (Exc. Tax)"; Rec."Gift Wrap Promo (Exc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Gift Wrap Promo Tax Amount"; Rec."Gift Wrap Promo Tax Amount")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Visible = false;
            }
            field("Gift Wrap Promo (Inc. Tax)"; Rec."Gift Wrap Promo (Inc. Tax)")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
            }
        }
    }
}
