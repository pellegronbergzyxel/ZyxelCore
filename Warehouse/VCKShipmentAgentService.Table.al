Table 50052 "VCK Shipment Agent Service"
{
    DrillDownPageID = "VCK Shipment Agent Service";
    LookupPageID = "VCK Shipment Agent Service";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(2; "Shipment Agent Code"; Code[10])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "VCK Shipment Agent Code".Code;
        }
        field(3; Description; Text[30])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(4; Default; Boolean)
        {
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; "Code", "Shipment Agent Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
