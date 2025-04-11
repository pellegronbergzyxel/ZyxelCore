Table 73006 "Data Export Buffer"
{
    Caption = 'Data Export Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = 'PAB 1.0';
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
            Description = 'PAB 1.0';
        }
        field(3; "Line Feed"; Boolean)
        {
            Caption = 'Line Feed';
            Description = 'PAB 1.0';
        }
        field(4; "Field Value"; Text[250])
        {
            Caption = 'Field Value';
            Description = 'PAB 1.0';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Table No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}
