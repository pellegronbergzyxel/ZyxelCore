Table 50017 "Zyxel HR Cue"
{
    // 001. 26-06-19 ZY-LD 2019062410000088 - New field.
    // 002. 12-11-19 ZY-LD 2019111110000048 - Headcount Control.

    Caption = 'Zyxel HR Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(41; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
        }
        field(42; "Company Option Filter"; Option)
        {
            Caption = 'Company Option Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Zyxel,ZNet';
            OptionMembers = " ",Zyxel,ZNet;
        }
        field(43; "Headcount Countrol Filter"; Date)
        {
            Caption = 'Headcount Countrol Filter';
            Description = '12-11-19 ZY-LD 002';
            FieldClass = FlowFilter;
        }
        field(50104; SPHAIRON; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('SP'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50105; "ZYXEL ES"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY ES'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50106; "ZYXEL CZ"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY CZ'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50107; "ZYXEL DE"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY DE'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50108; "ZYXEL DK"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY DK'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50109; "ZYXEL FI"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY FI'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50110; "ZYXEL IT"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY IT'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50111; "ZYXEL NL"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY BNL'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50112; "ZYXEL NO"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY NO'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50113; "ZYXEL SE"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY SE'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50114; "ZYXEL UK"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY UK'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50115; ALL; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50116; PROBATION; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Probation Review Meeting" = field("Date Filter"),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50117; BIRTHDAYS; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Next Birth Date" = field("Date Filter"),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50118; DISCIPLINARY; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Disciplinary Meeting Date" = field("Date Filter"),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50121; "ZYXEL HU"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY HU'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50122; "ZYXEL PL"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY PL'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50123; "ZYXEL SK"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY SK'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50124; "ZYXEL TK"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY TR'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50125; "ZYXEL AE"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY UAE'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50127; "Active Employees"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.p';
            FieldClass = FlowField;
        }
        field(50128; "Inactive Employees"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Active employee" = const(false),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.p';
            FieldClass = FlowField;
        }
        field(50129; "ZYXEL BE"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY BE'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50130; "ZYXEL ZY"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50131; "ZYXEL RU"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('ZY RU'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50146; "ZYXEL FR"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where(Company = const('FR'),
                                                        "Active employee" = const(true),
                                                        "Company Option" = field("Company Option Filter")));
            Caption = 'ZYXEL FR';
            Description = '16-04-18 ZY-LD 006';
            FieldClass = FlowField;
        }
        field(50147; "Headcount Controllers"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Leaving Date" = field("Headcount Countrol Filter")));
            Caption = 'Headcount Controllers';
            Description = '12-11-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50159; "Changes in History"; Integer)
        {
            CalcFormula = count("HR Role History");
            Description = '22-05-18 ZY-LD 008';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50165; "Left Zyxel Six Years Ago"; Integer)
        {
            CalcFormula = count("ZyXEL Employee" where("Leaving Date" = field("Leving Date Filter")));
            Description = '15-10-18 ZY-LD 010';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50166; "Leving Date Filter"; Date)
        {
            Description = '15-10-18 ZY-LD 010';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
