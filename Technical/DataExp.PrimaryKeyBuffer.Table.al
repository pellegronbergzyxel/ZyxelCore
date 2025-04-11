Table 73007 "Data Exp. Primary Key Buffer"
{
    Caption = 'Data Exp. Primary Key Buffer';

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            Description = 'PAB 1.0';
        }
        field(2; "Index Value 1"; Text[30])
        {
            Caption = 'Index Value 1';
            Description = 'PAB 1.0';
        }
        field(3; "Index Value 2"; Text[30])
        {
            Caption = 'Index Value 2';
            Description = 'PAB 1.0';
        }
        field(4; "Index Value 3"; Text[30])
        {
            Caption = 'Index Value 3';
            Description = 'PAB 1.0';
        }
        field(5; "Index Value 4"; Text[30])
        {
            Caption = 'Index Value 4';
            Description = 'PAB 1.0';
        }
        field(6; "Index Value 5"; Text[30])
        {
            Caption = 'Index Value 5';
            Description = 'PAB 1.0';
        }
        field(7; "Index Value 6"; Text[30])
        {
            Caption = 'Index Value 6';
            Description = 'PAB 1.0';
        }
        field(8; "Index Value 7"; Text[30])
        {
            Caption = 'Index Value 7';
            Description = 'PAB 1.0';
        }
        field(9; "Best Key Index"; Integer)
        {
            Caption = 'Best Key Index';
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; "Table No.", "Index Value 1", "Index Value 2", "Index Value 3", "Index Value 4", "Index Value 5", "Index Value 6", "Index Value 7")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
