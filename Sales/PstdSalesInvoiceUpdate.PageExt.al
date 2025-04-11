pageextension 50154 PstdSalesInvoiceUpdate extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter(Payment)
        {
            group("Zyxel")
            {
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Name 2"; Rec."Bill-to Name 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(NLtoDK)
                {
                    Caption = 'NL to DK Reverse Charge';
                    field("NL to DK Rev. Charge Posted"; Rec."NL to DK Rev. Charge Posted")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("NL to DK Reverse Chg. Doc No."; Rec."NL to DK Reverse Chg. Doc No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
    }
}