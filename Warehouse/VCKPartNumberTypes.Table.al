Table 50083 "VCK Part Number Types"
{
    DataCaptionFields = "CODE";
    DrillDownPageID = "VCK Part Number Types";
    LookupPageID = "VCK Part Number Types";

    fields
    {
        field(1; "CODE"; Code[20])
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
        key(Key1; "CODE")
        {
            Clustered = true;
        }
    }
}
