Page 50052 "Country/Region Card"
{
    PageType = Card;
    SourceTable = "Country/Region";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EU Country/Region Code"; Rec."EU Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Intrastat Code"; Rec."Intrastat Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address Format"; Rec."Address Format")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Contact Address Format"; Rec."Contact Address Format")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Scheme"; Rec."VAT Scheme")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Quote)
            {
                Caption = 'Quote';
                field("Sales Quote Template Code"; Rec."Sales Quote Template Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                field("Show Country of Origin on Inv."; Rec."Show Country of Origin on Inv.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Show Net Weight on Inv."; Rec."Show Net Weight on Inv.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Show Gross Weight on Inv."; Rec."Show Gross Weight on Inv.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Commercial Invoice"; Rec."Commercial Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Some countries must have the text "Commercial Invoice" instead of "Sales Invoice".';
                }
                field("Recycling Fee per. Unit"; Rec."Recycling Fee per. Unit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Recycling Fee Currency Code"; Rec."Recycling Fee Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Shipping)
            {
                field("E-mail Shipping Inv. to Whse."; Rec."E-mail Shipping Inv. to Whse.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Head Desc. on Custom Inv."; Rec."Line Head Desc. on Custom Inv.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Show Net Wgt. Total on Ctm.Inv"; Rec."Show Net Wgt. Total on Ctm.Inv")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Show Grs Wgt. Total on Ctm.Inv"; Rec."Show Grs Wgt. Total on Ctm.Inv")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Del. Doc. Release Message"; Rec."Del. Doc. Release Message")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Del. Doc. Release Limit"; Rec."Del. Doc. Release Limit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customs Customer No."; Rec."Customs Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Method for Customs"; Rec."Shipment Method for Customs")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("VAT Reg. No. Must be Filled"; Rec."VAT Reg. No. Must be Filled")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(RMA)
            {
                Caption = 'RMA';
                field("RMA Location Code"; Rec."RMA Location Code")
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
