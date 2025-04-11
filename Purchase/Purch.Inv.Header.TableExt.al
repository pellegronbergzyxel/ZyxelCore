tableextension 50135 PurchInvHeaderZX extends "Purch. Inv. Header"
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50001; "Requested Date From Factory"; Date)
        {
            Description = 'DT1.00';
            Editable = false;
        }
        field(50003; "Ship-from Country/Region Code"; Code[10])
        {
            Caption = 'Ship-from Country/Region Code';
            Description = '04-12-20 ZY-LD 004';
            TableRelation = "Country/Region";
        }
        field(50005; "CZ Sales Order No."; Code[20])
        {
            Description = 'ZY2.0 Used in Auto Routine when sales order is created in RHQ Live from CZ';
        }
        field(50006; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
            Description = '30-05-19 ZY-LD 018';
        }
        field(50053; "SII Spain - Document Sent"; Boolean)
        {
            Caption = 'SII Spain - Document Sent';
        }
        field(50056; "NL to DK Reverse Chg. Doc No."; Code[20])  // 13-03-24 ZY-LD 000
        {
            Caption = 'NL to DK Rev. Charge Document No.';
        }
        field(62015; IsEICard; Boolean)
        {
            Caption = 'Is EICard';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62033; "Dist. PO#"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62034; "Dist. E-mail"; Text[250])
        {
            Description = 'Tectura Taiwan';
        }
        field(62035; "Create User ID"; Code[30])
        {
        }
        field(62036; "From SO No."; Code[20])
        {
        }
        field(62037; "SO Sell-to Customer No"; Code[20])
        {
        }
        field(62038; "SO Sell-to Customer Name"; Text[50])
        {
        }
    }
}
