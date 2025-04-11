Table 50089 "Battery UN Codes"
{
    DrillDownPageID = "Battery UN Codes";
    LookupPageID = "Battery UN Codes";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
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
