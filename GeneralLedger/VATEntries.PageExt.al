pageextension 50176 VATEntriesZX extends "VAT Entries"
{
    layout
    {
        modify("Country/Region Code")
        {
            Caption = 'Country/Region Code - Default';
            Visible = false;
        }
        modify("VAT Registration No.")
        {
            Caption = 'VAT Registration No. - Default';
        }

        addafter("VAT Prod. Posting Group")
        {
            field("VAT Prod. Posting Group Desc."; Rec."VAT Prod. Posting Group Desc.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Bill-to/Pay-to No.")
        {
            field("Bill-to/Pay-to Name"; Rec."Bill-to/Pay-to Name")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Bill-to/Pay-to Post Code"; Rec."Bill-to/Pay-to Post Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("EU Service")
        {
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Vendor Document No."; Rec."Vendor Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("eCommerce Customer Type"; Rec."eCommerce Customer Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("VAT Registration No.")
        {
            field("VAT Registration No. ZX"; Rec."VAT Registration No. ZX")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The field is a replacement for "VAT Registration No. - Default" On the vendor is the value identical with "VAT Registration No. - Default". On the customer is the value copied from "VAT Registration No." on the sales document.';
            }
            field("VAT Registration No. VIES"; Rec."VAT Registration No. VIES")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the "VAT Registration No." for VIES. If "Bill-to Country/Region Code" is similar to "Ship-to Country/Region Code" then "VAT Reg. No. - VIES" is similar to the "VAT Reg. No. - Default" (Bill-to) othervise it will be the "VAT Reg. No." (Ship-to).';
            }
            field("Company VAT Registration No."; Rec."Company VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the "VAT Registration No." for Zyxel. The field is only in use on the sales side.';
            }
        }
        addafter("Country/Region Code")
        {
            field("Company Country/Region Code"; Rec."Company Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The field is a replacement for "Country/Region Code - Default". On the purchase side is the value identical with the "Country/Region Code - Default". On the sales side is the value copied from "Ship-to Country/Region Code" on the sales document. If the "Country/Region Code" is identical with the "Ship-from Country/Region Code" the line will not be shown on the VIES report.';
            }
            field("Ship-from Country/Region Code"; Rec."Ship-from Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the "Ship-from Country/Region Code" from the eCommerce order or from the "Location Code" on the sales document. If the "Country/Region Code" is identical with the "Ship-from Country/Region Code" the line will not be shown on the VIES report.';
                Visible = false;
            }
            field("EU Country/Region Code"; Rec."EU Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the "EU Country/Region Code" based on the field "Country/Region Code".';
                Visible = false;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the location code from the posted purchase-/sales document.';
                Visible = false;
            }
        }
    }
}
