tableextension 50104 CountryRegionZX extends "Country/Region"
{
    fields
    {
        modify("Code")
        {
            Caption = 'Code';
        }
        modify(Name)
        {
            Caption = 'Name';
        }
        modify("EU Country/Region Code")
        {
            Caption = 'EU Country/Region Code';
        }
        field(50000; "Cost Split Country"; Boolean)
        {
        }
        field(50001; "Show Country of Origin on Inv."; Boolean)
        {
            Caption = 'Show Country/Region of Origin on Inv./Cr.Memo';
            Description = '31-10-17 ZY-LD 001';
        }
        field(50002; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = '04-01-18 ZY-LD 002';
            TableRelation = "Country/Region";
        }
        field(50003; "VAT Reg. No. Must be Filled"; Boolean)
        {
            Caption = 'VAT Registration No. Must be Filled on the Customer';
            Description = '18-10-18 ZY-LD 003';
            InitValue = true;
        }
        field(50004; "RMA Location Code"; Code[10])
        {
            Description = '11-12-18 ZY-LD 004';
            TableRelation = Location;
        }
        field(50005; "Commercial Invoice"; Boolean)
        {
            Caption = 'Commercial Invoice';
            Description = '11-02-19 ZY-LD 005';
        }
        field(50006; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(50007; "Show Gross Weight on Inv."; Boolean)
        {
            Caption = 'Show Gross Weight on Invoice';
            Description = '09-08-19 ZY-LD 006';
        }
        field(50008; "Item Country Code"; Boolean)
        {
            Caption = 'Item Country Code';
        }
        field(50009; "Sales Quote Template Code"; Code[10])
        {
            Caption = 'Sales Quote Template Code';
            Description = '08-07-20 ZY-LD 008';
            TableRelation = "Customer Templ.";
        }
        field(50010; "Customs Customer No."; Code[20])
        {
            Caption = 'Customs Customer No.';
            Description = '25-01-21 ZY-LD 009';
            TableRelation = Customer;
        }
        field(50011; "Shipment Method for Customs"; Code[10])
        {
            Caption = 'Shipment Method / Incoterms for Customs Invoice';
            TableRelation = "Shipment Method";
        }
        field(50012; "Show Net Weight on Inv."; Boolean)
        {
            Caption = 'Show Net Weight on Invoice';
            Description = '25-01-31 ZY-LD 009';
        }
        field(50013; "Recycling Fee per. Unit"; Decimal)
        {
            BlankZero = true;
            Caption = 'Recycling Fee per. Unit';
            Description = '20-10-21 ZY-LD 010';
        }
        field(50014; "Recycling Fee Currency Code"; Code[10])
        {
            Caption = 'Recycling Fee Currency Code';
            Description = '20-10-21 ZY-LD 010';
            TableRelation = Currency;
        }
        field(50015; "E-mail Shipping Inv. to Whse."; Boolean)
        {
            Caption = 'E-mail Shipping Inv. to Warehouse';
            Description = '26-10-21 ZY-LD 011';
        }
        field(50017; "Line Head Desc. on Custom Inv."; Text[50])
        {
            Caption = 'Line Header Description on Customs/Shipping Invoice';
            Description = '15-11-21 ZY-LD 013';
        }
        field(50018; "EORI No."; Code[20])
        {
            Caption = 'EORI No.';
            Description = '01-12-21 ZY-LD 014';
        }
        field(50019; "Block Lines without Unit Price"; Boolean)
        {
            Caption = 'Block Lines without Unit Price on Customs/Shipping Invoice';
            Description = '07-12-21 ZY-LD 015';
            InitValue = true;
        }
        field(50020; "Show Net Wgt. Total on Ctm.Inv"; Boolean)
        {
            Caption = 'Show "Net Weight Total" on Customs/Shipping Inv.';
            Description = '07-12-21 ZY-LD 015';
        }
        field(50021; "Show Grs Wgt. Total on Ctm.Inv"; Boolean)
        {
            Caption = 'Show "Gross Weight Total" on Customs/Shipping Inv.';
            Description = '07-12-21 ZY-LD 015';
        }
        field(50040; "Currence for IC-Posting"; Code[10])
        {
            Caption = 'Currence for IC-Posting';
            TableRelation = Currency;
        }
        field(50041; "LMR Enabled"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50042; "Del. Doc. Release Message"; Text[150])
        {
            Caption = 'Delivery Document Release Message';
            Description = '24-01-20 ZY-LD 007';
        }
        field(50043; "Del. Doc. Release Limit"; Decimal)
        {
            BlankZero = true;
            Caption = 'Delivery Document Release Limit (EUR)';
            Description = '24-01-20 ZY-LD 007';
        }
    }
    keys
    {
        key(Key1; "RMA Location Code")
        {
        }
    }
}
