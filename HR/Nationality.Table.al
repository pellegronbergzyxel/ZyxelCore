Table 62010 Nationality
{
    Caption = 'Nationality';
    DataCaptionFields = "Code", Name;
    DrillDownPageID = Nationalies;
    LookupPageID = Nationalies;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
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
