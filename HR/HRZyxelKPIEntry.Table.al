Table 50072 "HR Zyxel KPI Entry"
{
    Caption = 'HR Zyxel KPI Entry';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = KPI,"Additional Payment";
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = "ZyXEL Employee";
        }
        field(3; Year; Integer)
        {
            BlankZero = true;
            Caption = 'Year';
            MinValue = 2000;
            NotBlank = true;
        }
        field(4; Amount; Decimal)
        {
            BlankZero = true;
            Caption = 'Amount';
            MinValue = 0;
        }
        field(5; "Quarter 1"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quarter 1';
            MinValue = 0;
        }
        field(6; "Quarter 2"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quarter 2';
            MinValue = 0;
        }
        field(7; "Quarter 3"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quarter 3';
            MinValue = 0;
        }
        field(8; "Quarter 4"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quarter 4';
            MinValue = 0;
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(10; Month; Integer)
        {
            Caption = 'Month';
            MaxValue = 12;
            MinValue = 0;
        }
        field(11; "Justification / Explanation"; Text[80])
        {
            Caption = 'Justification / Explanation';
        }
        field(12; "Tracking Document"; Text[30])
        {
            Caption = 'Tracking Document';
        }
        field(13; "Tracking Document Attached"; Boolean)
        {
            Caption = 'Tracking Document Attached';
        }
    }

    keys
    {
        key(Key1; Type, "Employee No.", Year, Month)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
