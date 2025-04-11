Table 50097 "HR Disciplinary Line"
{

    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = true;
            Description = 'PAB 1.0';
        }
        field(2; "Employee No."; Code[20])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "ZyXEL Employee";
        }
        field(3; "Date of Warning"; Date)
        {
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(4; "Date of Warning Expiration"; Date)
        {
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(5; "Warning Code"; Code[20])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "HR Disciplinary Code".Code;
        }
        field(6; "Warning Description"; Text[30])
        {
            CalcFormula = lookup("HR Disciplinary Code".Description where(Code = field("Warning Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(7; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Human Resources Comment Table Name"::"HR Disciplinary Line"),
                                                                     "Table Line No." = field(UID)));
            Caption = 'Comment';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Full Name"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Employee No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; UID, "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Date of Warning")
        {
        }
    }

    fieldgroups
    {
    }
}
