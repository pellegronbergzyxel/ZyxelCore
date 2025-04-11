Table 76126 Segment
{
    Caption = 'Segment';
    DataCaptionFields = "Code";
    Description = 'Segment';
    DrillDownPageID = "Segment Lookup";
    LookupPageID = "Segment Lookup";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            Description = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            Description = 'Description';
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
