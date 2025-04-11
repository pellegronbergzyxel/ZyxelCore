Table 50091 "HR Cost Centre"
{
    Caption = 'Cost Centre';
    DrillDownPageID = "HR Cost Center List";
    LookupPageID = "HR Cost Center List";

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
