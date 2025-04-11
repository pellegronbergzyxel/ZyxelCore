page 50233 "eCommerce Company Mapping Card"
{
    PageType = Card;
    SourceTable = "eCommerce Market Place";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Market Place Name"; Rec."Market Place Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Main Market Place ID"; Rec."Main Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Use Main Market Place ID"; Rec."Use Main Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Default Mapping"; Rec."Default Mapping")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Settle eCommerce Documents"; Rec."Settle eCommerce Documents")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Exception Start Date"; Rec."Tax Exception Start Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Exception End Date"; Rec."Tax Exception End Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Posting)
            {
                field("Import Data from"; Rec."Import Data from")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Prod. Posting Group (GB)"; Rec."VAT Prod. Posting Group (GB)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code (GB)"; Rec."Country/Region Code (GB)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping G/L Account No."; Rec."Shipping G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Advertising G/L Account No."; Rec."Advertising G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fee Account No."; Rec."Fee Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Charge Account No."; Rec."Charge Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax G/L Account No."; Rec."Tax G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Waste G/L Account No."; Rec."Waste G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code for Discount"; Rec."Code for Discount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Discount G/L Account No."; Rec."Discount G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code for Compensation Fee"; Rec."Code for Compensation Fee")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Compensation Fee is coming from Zyxel Store (Magento)';
                }
                field("Return Reason Code for Cr. Mem"; Rec."Return Reason Code for Cr. Mem")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus Posting Group (EU)"; Rec."VAT Bus Posting Group (EU)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus Posting Group (No VAT)"; Rec."VAT Bus Posting Group (No VAT)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus Post. Grp. (Ship-From)"; Rec."VAT Bus Post. Grp. (Ship-From)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Accepted Rounding"; Rec."Accepted Rounding")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Person Code"; Rec."Sales Person Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code for Shipping Fee"; Rec."Code for Shipping Fee")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Method"; Rec."Shipment Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Export Outside EU"; Rec."Export Outside EU")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Allow export outside EU';
                }
                field("Export Outside Country Code"; Rec."Export Outside Country Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Key in a country code "NO,CH" if export outside EU only is allowed to specific countries. If it is left blank, export to all countries outside EU is allowed.';
                }
                field("Transaction Type - Order"; Rec."Transaction Type - Order")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transaction Type - Refund"; Rec."Transaction Type - Refund")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Cash Recipt Journal")
            {
                Caption = 'Cash Recipt Journal';
                field("Cach Recipt G/L Template"; Rec."Cach Recipt G/L Template")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cash Recipt G/L Batch"; Rec."Cash Recipt G/L Batch")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cash Recipt Number Series"; Rec."Cash Recipt Number Series")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cash Recipt Description"; Rec."Cash Recipt Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Periodic Account No."; Rec."Periodic Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Periodic Posting Description"; Rec."Periodic Posting Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Payment Journal")
            {
                Caption = 'Payment Journal';
                field("Payment G/L Template"; Rec."Payment G/L Template")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment G/L Batch"; Rec."Payment G/L Batch")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Number Series"; Rec."Payment Number Series")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Roundings; Rec.Roundings)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
