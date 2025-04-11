tableextension 50184 HandledICOutboxSalesHeaderZX extends "Handled IC Outbox Sales Header"
{
    fields
    {
        field(50000; "Ship-to Name 2"; Text[50])
        {
            Description = 'RD 2.0';
        }
        field(50001; "Ship-to Address 2 x"; Text[50])
        {
            Description = 'RD 2.0';
        }
        field(50002; "Ship-to Post Code x"; Code[20])
        {
            Description = 'RD 2.0';
        }
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
        field(50013; "E-Invoice Comment"; Text[50])
        {
            Caption = 'E-Invoice Comment';
            Description = '01-02-19 ZY-LD 007';
        }
        field(50025; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            Description = '23-02-21 ZY-LD 004';
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
            Description = '10-07-20 ZY-LD 003';
            TableRelation = "Shipment Method";
        }
        field(62036; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                LocationRec: Record Location;
                LEMSG000: Label 'Location %1 can not match Sales Order Type %2!';
                LEMSG001: Label 'Can not find location %1!';
            begin
            end;
        }
        field(67001; "End Customer"; Code[20])
        {
            Caption = 'End Customer';
            Description = '07-11-18 ZY-LD 001';
        }
    }
}
