Table 50076 "E-mail Address Subject"
{
    // 001. 14-05-18 ZY-LD 2018051410000154 - Created.
    // 002. 22-11-19 ZY-LD 2019112110000029 - New field.

    Caption = 'E-mail Address Subject';
    DataCaptionFields = "E-mail Address Code", "Language Code";
    DrillDownPageID = "E-mail Address Subjects";
    LookupPageID = "E-mail Address Subjects";

    fields
    {
        field(1; "E-mail Address Code"; Code[10])
        {
            Caption = 'E-mail Address Code';
            TableRelation = "E-mail address";
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(4; Subject; Text[250])
        {
            Caption = 'Subject';
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Description = '22-11-19 ZY-LD 002';
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "E-mail Address Code", "Language Code", "Sell-to Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
