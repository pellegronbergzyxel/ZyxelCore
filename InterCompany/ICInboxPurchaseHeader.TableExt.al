tableextension 50189 ICInboxPurchaseHeaderZX extends "IC Inbox Purchase Header"
{
    fields
    {
        field(50001; "Ship-to Name 2"; Text[50])
        {
            Description = 'RD 2.0';
        }
        field(50002; "Ship-to Address 2 x"; Text[50])
        {
            Description = 'RD 2.0';
        }
        field(50003; "Ship-to Post Code x"; Code[20])
        {
            Description = 'RD 2.0';
        }
        field(50006; "Ship-to E-Mail"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50007; "Ship-to VAT"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50008; "Ship-to Contact"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50009; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            Description = '20-03-18 ZY-LD 004';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50011; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Description = '09-10-18 ZY-LD 005';
            TableRelation = "Ship-to Address";
        }
        field(50012; "Order Date"; Date)
        {
            Caption = 'Order Date';
            Description = '18-12-18 ZY-LD 006';
        }
        field(50013; "E-Invoice Comment"; Text[25])
        {
            Caption = 'E-Invoice Comment';
            Description = '01-02-19 ZY-LD 007';
        }
        field(50025; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            Description = '23-02-21 ZY-LD 011';
        }
        field(50026; "eCommerce Order"; Boolean)
        {
            Description = 'eCommerce';
        }
        field(50027; "Your Reference 2"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50030; "Currency Code Sales Doc SUB"; Code[10])
        {
            Caption = 'Currency Code on Sales Document SUB';
            Description = '09-12-19 ZY-LD 009';
            Editable = false;
            TableRelation = Currency;
        }
        field(50033; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code / Incoterms';
            Description = '10-07-20 ZY-LD 010';
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
