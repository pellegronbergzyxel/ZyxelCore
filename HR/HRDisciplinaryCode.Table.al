Table 50098 "HR Disciplinary Code"
{
    Caption = 'Disciplinary Code';
    DrillDownPageID = "HR Disiplinary Code List";
    LookupPageID = "HR Disiplinary Code List";

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
