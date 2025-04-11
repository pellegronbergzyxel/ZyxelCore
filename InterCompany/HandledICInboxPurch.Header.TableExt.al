tableextension 50192 HandledICInboxPurchHeaderZX extends "Handled IC Inbox Purch. Header"
{
    fields
    {
        field(50006; "Ship-to E-Mail"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50007; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Sell-to)';
            Description = 'eCommerce';
        }
        field(50008; "Ship-to Contact"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50011; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address";
        }
        field(50025; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            Description = '23-02-21 ZY-LD 005';
        }
        field(50026; "eCommerce Order"; Boolean)
        {
            Description = 'eCommerce';
        }
        field(50027; "Your Reference 2"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50033; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code / Incoterms';
            Description = '10-07-20 ZY-LD 004';
            TableRelation = "Shipment Method";
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.';
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;
        }
        field(62036; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(67001; "End Customer"; Code[20])
        {
        }
    }
}
