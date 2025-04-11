Table 76125 "Registration Country"
{
    //       //CO4.20: Controling - Basic: Firm Registration More Country;
    //       //CO4.20: Controling - Basic: Partner Registration More Country;

    fields
    {
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Customer,Vendor,Contact';
            OptionMembers = " ",Customer,Vendor,Contact;
        }
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Customer)) Customer
            else
            if (Type = const(Vendor)) Vendor
            else
            if (Type = const(Contact)) Contact;
        }
        field(15; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region" where("EU Country/Region Code" = filter(<> ''));
        }
        field(20; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                lreVATRegNoFormat: Record "VAT Registration No. Format";
            begin
                lreVATRegNoFormat.Test("VAT Registration No.", "Country Code", '', Database::"Registration Country");
            end;
        }
        field(25; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                if (Type = 0) and ("No." = '') then
                    TestField("VAT Bus. Posting Group", '');
            end;
        }
        field(30; "Currency Code (Local)"; Code[10])
        {
            Caption = 'Currency Code (Local)';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if (Type <> 0) and ("No." <> '') then
                    TestField("Currency Code (Local)", '');
            end;
        }
        field(35; "VAT Rounding Type"; Option)
        {
            Caption = 'VAT Rounding Type';
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = Nearest,Up,Down;
        }
        field(40; "Rounding VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Rounding VAT Presicion';
            InitValue = 1;

            trigger OnValidate()
            begin
                if (Type <> 0) and ("No." <> '') then
                    TestField("Rounding VAT", 0);
            end;
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Country Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
