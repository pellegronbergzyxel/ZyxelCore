Table 50023 "Chemical Tax Rate"
{
    Caption = 'Chemical Tax Rate';
    DataCaptionFields = "Start Date";
    DrillDownPageID = "Chemical Tax Rates";
    LookupPageID = "Chemical Tax Rates";

    fields
    {
        field(1; "Start Date"; Date)
        {
            Caption = 'Start Date';
            NotBlank = true;
        }
        field(2; "Tax Rate (SEK/kg)"; Decimal)
        {
            Caption = 'Tax Rate (SEK/kg)';
        }
        field(3; "Tax Rate Cap (SEK/Item)"; Decimal)
        {
            Caption = 'Tax Rate Cap (SEK/Item)';
        }
    }

    keys
    {
        key(Key1; "Start Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
