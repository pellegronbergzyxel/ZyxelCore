Table 50050 "VCK Inventory Reason Change"
{
    DrillDownPageID = "VCK Inventory Reason Change";
    LookupPageID = "VCK Inventory Reason Change";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
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
