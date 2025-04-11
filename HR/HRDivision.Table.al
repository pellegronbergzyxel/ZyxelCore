Table 50093 "HR Division"
{
    Caption = 'Division';
    DrillDownPageID = "HR Division List";
    LookupPageID = "HR Division List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Description = 'PAB 1.0';
        }
        field(2; Description; Text[30])
        {
            Description = 'PAB 1.0';
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
