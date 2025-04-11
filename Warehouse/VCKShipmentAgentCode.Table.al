Table 50051 "VCK Shipment Agent Code"
{
    DrillDownPageID = "VCK Shipment Agent Code";
    LookupPageID = "VCK Shipment Agent Code";

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
        field(3; Default; Boolean)
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
