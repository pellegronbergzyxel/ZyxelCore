page 50276 "eCommerce Country Mapping Card"
{
    PageType = Card;
    SourceTable = "eCommerce Country Mapping";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Country Code"; Rec."Ship-to Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Default Mapping"; Rec."Default Mapping")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Use Country VAT Bus. Post Grp."; Rec."Use Country VAT Bus. Post Grp.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Alt. VAT Bus. Posting Group"; Rec."Alt. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to VAT No."; Rec."Ship-to VAT No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Tax Theshold")
            {
                Caption = 'Tax Theshold';
                field("Threshold Amount"; Rec."Threshold Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Threshold Reached"; Rec."Threshold Reached")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
