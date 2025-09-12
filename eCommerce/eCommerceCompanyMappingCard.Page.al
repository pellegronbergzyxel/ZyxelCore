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
                    ToolTip = 'Specifies the ID of the marketplace.';
                }
                field("Market Place Name"; Rec."Market Place Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the marketplace.';
                }
                field("Main Market Place ID"; Rec."Main Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the main marketplace ID if this marketplace is a sub-marketplace.';
                }
                field("Use Main Market Place ID"; Rec."Use Main Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to use the main marketplace ID for transactions.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description for the marketplace.';
                }
                field("Default Mapping"; Rec."Default Mapping")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether this marketplace mapping is the default mapping.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the marketplace mapping is active.';
                }
                field("Settle eCommerce Documents"; Rec."Settle eCommerce Documents")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to settle eCommerce documents automatically.';
                }
                field("Tax Exception Start Date"; Rec."Tax Exception Start Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Exception Start Date';
                }
                field("Tax Exception End Date"; Rec."Tax Exception End Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Exception EndDate';
                }
            }
            group(Posting)
            {
                field("Import Data from"; Rec."Import Data from")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the starting point for importing data.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer number associated with the marketplace.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor number associated with the marketplace.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the currency code used for transactions in the marketplace.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Product Posting Group for the marketplace.';
                }
                field("VAT Prod. Posting Group (GB)"; Rec."VAT Prod. Posting Group (GB)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Product Posting Group for the marketplace in Great Britain.';
                }
                field("Country/Region Code (GB)"; Rec."Country/Region Code (GB)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Country/Region Code for the marketplace in Great Britain.';
                }
                field("Shipping G/L Account No."; Rec."Shipping G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the General Ledger account number for shipping costs associated with the marketplace.';
                }
                field("Advertising G/L Account No."; Rec."Advertising G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the General Ledger account number for advertising expenses associated with the marketplace.';
                }
                field("Fee Account No."; Rec."Fee Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the account number for fees associated with the marketplace.';
                }
                field("Charge Account No."; Rec."Charge Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the account number for charges associated with the marketplace.';
                }
                field("Tax G/L Account No."; Rec."Tax G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the General Ledger account number for tax associated with the marketplace.';
                }
                field("Waste G/L Account No."; Rec."Waste G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the General Ledger account number for waste associated with the marketplace.';
                }
                field("Code for Discount"; Rec."Code for Discount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code used for discounts associated with the marketplace.';
                }
                field("Discount G/L Account No."; Rec."Discount G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the General Ledger account number for discounts associated with the marketplace.';
                }
                field("Code for Compensation Fee"; Rec."Code for Compensation Fee")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Compensation Fee is coming from Zyxel Store (Magento)';
                }
                field("Return Reason Code for Cr. Mem"; Rec."Return Reason Code for Cr. Mem")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the return reason code used for credit memos associated with the marketplace.';
                }
                field("VAT Bus Posting Group (EU)"; Rec."VAT Bus Posting Group (EU)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Business Posting Group for the marketplace in the European Union.';
                }
                field("VAT Bus Posting Group (No VAT)"; Rec."VAT Bus Posting Group (No VAT)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Business Posting Group for the marketplace when no VAT is applicable.';
                }
                field("VAT Bus Post. Grp. (Ship-From)"; Rec."VAT Bus Post. Grp. (Ship-From)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Business Posting Group for the marketplace based on the ship-from location.';
                }
                field("Accepted Rounding"; Rec."Accepted Rounding")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No Comsuner VAT Check"; Rec."No Comsuner VAT Check") // 08-09-2025 BK #522911
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If this field is checked, the system will not check if the customer is a consumer when importing orders. This is useful for marketplaces that do not provide information about whether the customer is a consumer or a business.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the location code for shipping associated with the marketplace.';
                }
                field("Sales Person Code"; Rec."Sales Person Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sales person code associated with the marketplace.';
                }
                field("Code for Shipping Fee"; Rec."Code for Shipping Fee")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code used for shipping fees associated with the marketplace.';
                }
                field("Shipment Method"; Rec."Shipment Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the shipment method used for shipping associated with the marketplace.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the shipping agent code associated with the marketplace.';
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the transport method used for shipping associated with the marketplace.';
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
                    ToolTip = 'Specifies Transaction Type for Order';
                }
                field("Transaction Type - Refund"; Rec."Transaction Type - Refund")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Transaction Type for Refund';
                }
            }
            group("Cash Recipt Journal")
            {
                Caption = 'Cash Recipt Journal';

                field("Cach Recipt G/L Template"; Rec."Cach Recipt G/L Template")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the Cash Receipt G/L Template for the Cash Receipt Journal.';
                }
                field("Cash Recipt G/L Batch"; Rec."Cash Recipt G/L Batch")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the Cash Receipt G/L Batch for the Cash Receipt Journal.';
                }
                field("Cash Recipt Number Series"; Rec."Cash Recipt Number Series")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the Cash Receipt Number Series for the Cash Receipt Journal.';
                }
                field("Cash Recipt Description"; Rec."Cash Recipt Description")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the description for cash receipts in the Cash Receipt Journal.';
                }
                field("Periodic Account No."; Rec."Periodic Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the periodic account number for the Cash Receipt Journal.';
                }
                field("Periodic Posting Description"; Rec."Periodic Posting Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description for periodic postings in the Cash Receipt Journal.';
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country dimension for the Cash Receipt Journal.';
                }
            }
            group("Payment Journal")
            {
                Caption = 'Payment Journal';

                field("Payment G/L Template"; Rec."Payment G/L Template")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the Payment G/L Template for the Payment Journal.';
                }
                field("Payment G/L Batch"; Rec."Payment G/L Batch")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the Payment G/L Batch for the Payment Journal.';
                }
                field("Payment Number Series"; Rec."Payment Number Series")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the Payment Number Series for the Payment Journal.';
                }
                field(Roundings; Rec.Roundings)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to handle roundings in the Payment Journal.';
                }
            }
        }
    }
}
