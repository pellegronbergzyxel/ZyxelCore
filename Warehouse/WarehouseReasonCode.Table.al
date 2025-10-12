Table 50025 "Warehouse Reason Code ZY"
{
    Caption = 'Warehouse Reason Code';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Warehouse Reason Codes ZY";
    LookupPageID = "Warehouse Reason Codes ZY";

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
