tableextension 50143 VATEntryZX extends "VAT Entry"
{
    fields
    {
        modify("Posting Date")
        {
            Caption = 'Posting Date';
        }
        modify("Document No.")
        {
            Caption = 'Document No.';
        }
        modify(Amount)
        {
            Caption = 'Amount';
        }
        field(50000; "VAT Prod. Posting Group Desc."; Text[100])
        {
            CalcFormula = lookup("VAT Product Posting Group".Description where(Code = field("VAT Prod. Posting Group")));
            Caption = 'VAT Prod. Posting Group Description';
            Description = '02-12-20 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Bill-to/Pay-to Name"; Text[100])
        {
            Caption = 'Bill-to/Pay-to Name';
            Description = '02-12-20 ZY-LD 002';
        }
        field(50002; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            Description = '02-12-20 ZY-LD 002';
        }
        field(50003; "Bill-to/Pay-to Post Code"; Code[20])
        {
            Caption = 'Bill-to/Pay-to Post Code';
            Description = '04-11-21 ZY-LD 003';
            TableRelation = "Post Code";
        }
        field(50004; "Vendor Document No."; Code[35])
        {
            Caption = 'Vendor Document No.';
            Description = '04-11-21 ZY-LD 003';
        }
        field(50005; "eCommerce Customer Type"; Option)
        {
            Caption = 'eCommerce Customer Type';
            OptionCaption = ' ,Consumer,Business';
            OptionMembers = " ",Consumer,Business;
        }
        field(50006; "Company Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            Description = '17-10-23 ZY-LD 001';
        }
        field(50007; "Company VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No. - Zyxel';
            Description = '17-10-23 ZY-LD 001';
        }
        field(50008; "EU Country/Region Code"; Code[10])
        {
            CalcFormula = lookup("Country/Region"."EU Country/Region Code" where(Code = field("Company Country/Region Code")));
            Caption = 'EU Country/Region Code';
            Description = '18-10-23 ZY-LD 000';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Ship-from Country/Region Code"; Code[10])
        {
            Caption = 'Ship-from Country/Region Code';
            TableRelation = "Country/Region";
            Description = '17-10-23 ZY-LD 001';
        }
        field(50010; "VAT Registration No. ZX"; Text[20])
        {
            Caption = 'VAT Registration No.';
            Description = '17-10-23 ZY-LD 001';
        }
        field(50011; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(50012; "VAT Registration No. VIES"; Code[20])  // 29-05-24 ZY-LD 000
        {
            Caption = 'VAT Registration No. - VIES';
        }
    }
}
