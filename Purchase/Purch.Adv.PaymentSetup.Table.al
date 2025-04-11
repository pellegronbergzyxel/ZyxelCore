Table 75037 "Purch. Adv. Payment Setup"
{
    //       //EZ4.30: Purchase advanced payment;
    //       //EZ4.10: Advanced payment posting;


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Temp. Payable Type"; Code[10])
        {
            Caption = 'Temp. Payable Type';
            TableRelation = "Payable Type";
        }
        field(27; "Copy Comments to Iss.Adv.Paym."; Boolean)
        {
            Caption = 'Copy Comments to Iss.Adv.Paym.';
            InitValue = true;
        }
        field(30; "Apply to Adv. Payment Limit"; Boolean)
        {
            Caption = 'Apply to Adv. Payment Limit';
            InitValue = true;
        }
        field(60; "Check Apply Payment Type"; Boolean)
        {
            Caption = 'Check Apply Payment Type';
            Description = 'EZ4.10';
        }
        field(70; "Check Usage Payment Type"; Boolean)
        {
            Caption = 'Check Usage Payment Type';
            Description = 'EZ4.10';
        }
        field(80; "Dis.Apply Pay.with low date"; Boolean)
        {
            Caption = 'Dis.Apply Pay.with low date';
            InitValue = true;
        }
        field(90; "Post Apply by Payment Type"; Boolean)
        {
            Caption = 'Post Apply by Payment Type';

            trigger OnValidate()
            begin
                if "Post Apply by Payment Type" then begin
                    TestField("Temp. Payable Type");
                    //testfield("Check Usage Payment Type");
                    TestField("Check Apply Payment Type");
                end;
            end;
        }
        field(120; "VAT Rounding Limit"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Rounding Limit';
        }
        field(125; "Currency Rounding Limit"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Currency Rounding Limit';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
