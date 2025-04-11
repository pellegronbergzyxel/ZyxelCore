Table 50025 "Warehouse Reason Code"
{
    Caption = 'Warehouse Reason Code';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Warehouse Reason Codes";
    LookupPageID = "Warehouse Reason Codes";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
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
