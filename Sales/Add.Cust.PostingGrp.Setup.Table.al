Table 50039 "Add. Cust. Posting Grp. Setup"
{
    Caption = 'Additional Cust. Posting Grp. Setup';
    DrillDownPageID = "Add. Cust. Posting Grp. Setup";
    LookupPageID = "Add. Cust. Posting Grp. Setup";

    fields
    {
        field(1; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            NotBlank = true;
            TableRelation = Location;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            ValidateTableRelation = false;
        }
        field(4; "Company Type"; Option)
        {
            Caption = 'Company Type';
            OptionCaption = 'Main,Subsidary';
            OptionMembers = Main,Subsidary;
        }
        field(11; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(13; "Location Code in SUB"; Code[10])
        {
            Caption = 'Location Code in Subsidary';
            TableRelation = Location;
        }
        field(14; "Replace Loc. Code on Cr. Memo"; Code[10])
        {
            Caption = 'Replace Location Code on Cr. Memo With';
            TableRelation = Location;
        }
        field(21; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(45; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            NotBlank = true;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
                VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
            begin
                TestField("Customer No.");
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", '', 0);
            end;
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(99; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(110; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
    }

    keys
    {
        key(Key1; "Country/Region Code", "Location Code", "Customer No.", "Company Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        VATRegNoFormat: Record "VAT Registration No. Format";
}
