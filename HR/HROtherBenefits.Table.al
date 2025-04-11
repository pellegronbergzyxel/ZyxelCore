Table 60008 "HR Other Benefits"
{
    Caption = 'HR Other Benefits';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = "ZyXEL Employee";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Benefit; Text[250])
        {
        }
        field(4; Amount; Decimal)
        {
            BlankZero = true;
        }
        field(5; Currency; Code[10])
        {
            TableRelation = Currency;
        }
        field(6; "ER %"; Decimal)
        {
            BlankZero = true;
            MaxValue = 100;
            MinValue = 0;
        }
        field(7; "EE %"; Decimal)
        {
            BlankZero = true;
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}
