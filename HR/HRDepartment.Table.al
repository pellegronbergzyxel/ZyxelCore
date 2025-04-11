Table 50092 "HR Department"
{
    Caption = 'Department';
    DrillDownPageID = "HR Department List";
    LookupPageID = "HR Department List";

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
