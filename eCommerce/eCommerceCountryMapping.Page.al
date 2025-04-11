page 50275 "eCommerce Country Mapping"
{
    ApplicationArea = Basic, Suite;
    CardPageID = "eCommerce Country Mapping Card";
    PageType = List;
    SourceTable = "eCommerce Country Mapping";
    UsageCategory = Administration;
    AdditionalSearchTerms = 'ecommerce setup';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Market Place ID"; Rec."Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country Code"; Rec."Ship-to Country Code")
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
                field("Use Reverce Charge - DOM Bus"; Rec."Use Reverce Charge - DOM Bus")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to VAT No."; Rec."Ship-to VAT No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Applicale"; Rec."VAT Applicale")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Threshold"; Rec."Ship-to Threshold")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Domestic Reverse Charge"; Rec."Domestic Reverse Charge")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Without Zyxel VAT Reg. No"; Rec."Post Without Zyxel VAT Reg. No")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }
}
