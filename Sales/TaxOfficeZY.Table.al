Table 60003 "Tax Office ZY"
{
    Caption = 'Tax Office ZY';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Tax Office List";
    LookupPageID = "Tax Office List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Tax Office ID"; Code[20])
        {
            Caption = 'Tax Office ID';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
