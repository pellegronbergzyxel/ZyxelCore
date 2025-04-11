Table 50096 "HR Car Levels"
{
    Caption = 'HR Car Levels';
    DrillDownPageID = "HR Car Levels List";
    LookupPageID = "HR Car Levels List";

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
