tableextension 50133 PurchRcptHeaderZX extends "Purch. Rcpt. Header"
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
        field(50002; "Warehouse Inbound No."; Code[20])
        {
            CalcFormula = max("Purch. Rcpt. Line"."Warehouse Inbound No." where("Document No." = field("No.")));
            Caption = 'Warehouse Inbound No.';
            Description = '25-09-20 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Ship-from Country/Region Code"; Code[10])
        {
            Caption = 'Ship-from Country/Region Code';
            Description = '04-12-20 ZY-LD 005';
            TableRelation = "Country/Region";
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
