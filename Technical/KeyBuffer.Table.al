Table 73009 "Key Buffer"
{
    Caption = 'Key Buffer';

    fields
    {
        field(1; "Table No"; Integer)
        {
            Caption = 'Table No';
            Description = 'PAB 1.0';
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            Description = 'PAB 1.0';
        }
        field(3; "Key"; Text[250])
        {
            Caption = 'Key';
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; "Table No", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
