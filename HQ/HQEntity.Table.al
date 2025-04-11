Table 60002 "HQ Entity"
{
    Caption = 'HQ Entity';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "HQ Entitys";
    LookupPageID = "HQ Entitys";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
