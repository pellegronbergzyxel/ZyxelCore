Table 50026 Vessel
{
    Caption = 'Vessel';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Vessel List";
    LookupPageID = "Vessel List";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Link; Text[80])
        {
            ExtendedDatatype = URL;
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
