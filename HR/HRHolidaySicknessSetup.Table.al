Table 50099 "HR Holiday/Sickness Setup"
{

    fields
    {
        field(1; "Holiday Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Cause of Absence".Code;
        }
        field(2; "Sick Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Cause of Absence".Code;
        }
        field(3; SPHAIRON; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('SPHAIRON')));
            FieldClass = FlowField;
        }
        field(4; "ZYXEL ES"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL ES')));
            FieldClass = FlowField;
        }
        field(5; "ZYXEL CZ"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL CZ')));
            FieldClass = FlowField;
        }
        field(6; "ZYXEL DE"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL DE')));
            FieldClass = FlowField;
        }
        field(7; "ZYXEL DK"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL DK')));
            FieldClass = FlowField;
        }
        field(8; "ZYXEL FI"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL FI')));
            FieldClass = FlowField;
        }
        field(9; "ZYXEL IT"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL IT')));
            FieldClass = FlowField;
        }
        field(10; "ZYXEL NL"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL NL')));
            FieldClass = FlowField;
        }
        field(11; "ZYXEL NO"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL NO')));
            FieldClass = FlowField;
        }
        field(12; "ZYXEL SE"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL SE')));
            FieldClass = FlowField;
        }
        field(13; "ZYXEL UK"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = filter('ZYXEL UK')));
            FieldClass = FlowField;
        }
        field(14; ALL; Integer)
        {
            CalcFormula = count(Employee);
            FieldClass = FlowField;
        }
        field(15; PROBATION; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Probation Review Meeting" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(16; BIRTHDAYS; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Birth Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(17; DISCIPLINARY; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Disciplinary Meeting Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Holiday Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
