Table 50094 "HR Working Pattern"
{
    Caption = 'Working Pattern';
    DrillDownPageID = "HR Working Pattern List";
    LookupPageID = "HR Working Pattern List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(2; Description; Text[50])
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
