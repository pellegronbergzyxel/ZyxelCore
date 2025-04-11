Table 50021 "HR Payment Documentation"
{
    Caption = 'HR Payment Documentation';
    DrillDownPageID = "HR Payment Documentation";
    LookupPageID = "HR Payment Documentation";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Additional Payment,KPI Actual Bonus';
            OptionMembers = "Additional Payment","KPI Actual Bonus";
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }

    keys
    {
        key(Key1; Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
