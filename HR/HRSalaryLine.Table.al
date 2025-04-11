Table 50095 "HR Salary Line"
{
    // 001. 13-04-18 ZY-LD 000 - New field.
    // 002. 01-08-18 ZY-LD 2018062910000259 - New field.
    // 003. 05-11-18 ZY-LD 2018102210000156 - New field.
    // 004. 17-08-20 ZY-LD 2020062510000207 - New fields.
    // 005. 11-03-21 ZY-LD 2021022310000191 - New field.


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
            TableRelation = "ZyXEL Employee"."No.";

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(3; "Valid From"; Date)
        {
            Description = 'PAB 1.0';
            NotBlank = true;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(4; "Valid To"; Date)
        {
            Description = 'PAB 1.0';
            NotBlank = true;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(5; Currency; Code[20])
        {
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(6; "Base Salary P.A."; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            NotBlank = true;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(7; "No of Salaries"; Integer)
        {
            BlankZero = true;
            Description = 'PAB 1.0';
            InitValue = 12;

            trigger OnValidate()
            begin
                //Calculate;
            end;
        }
        field(8; "Commission Pay P.A."; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(9; "KPI Plan Payment"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'None,Annual,Half Yearly,Quarterly,Monthly,January to December,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = "None",Annual,"Half Yearly",Quarterly,Monthly,"January to December",January,February,March,April,May,June,July,August,September,October,November,December;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(10; "KPI Plan Attached"; Boolean)
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(11; "Car Allowance P.A."; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(12; "Car Level"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "HR Car Levels".Code;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(13; "Car Registration No"; Text[30])
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(14; "Car Leasing Company"; Text[50])
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(15; "Car Lease Valid From"; Date)
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(16; "Car Lease Valid To"; Date)
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(17; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Human Resources Comment Table Name"::"HR Salary Line"),
                                                                     "Table Line No." = field(UID)));
            Caption = 'Comment';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
        field(18; "Base Salary P.M."; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(19; "Total OTE P.A."; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(20; "Base % Split"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(21; "Commission % Split"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(22; "Car Allowance P.M."; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(23; "KPI Holdback %"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(24; "Full Name"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Employee No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(25; "Company Car"; Boolean)
        {
            Caption = 'Company Car';
            Description = '13-04-18 ZY-LD 001';
        }
        field(26; "Company Car P.A."; Decimal)
        {
            BlankZero = true;
            Caption = 'Company Car P.A.';
            Description = '01-08-18 ZY-LD 002';
        }
        field(27; "Salary Reimbursement"; Decimal)
        {
            Caption = 'Salary Reimbursement';
            Description = '01-08-18 ZY-LD 002';
        }
        field(28; "Gurantiedeed Bonus (Months)"; Integer)
        {
            BlankZero = true;
            Caption = 'Gurantiedeed Bonus (Months)';
            Description = '05-11-18 ZY-LD 003';
            MinValue = 0;
        }
        field(29; "Tracking Document Id"; Code[20])
        {
            Caption = 'Tracking Document Id';
            Description = '17-08-20 ZY-LD 004';
        }
        field(30; "Tracking Document Attached"; Boolean)
        {
            Caption = 'Tracking Document Attached';
            Description = '17-08-20 ZY-LD 004';
        }
        field(31; "Pre-paid Bonus (per Month)"; Decimal)
        {
            Caption = 'Pre-paid Bonus (per Month)';
            Description = '11-03-21 ZY-LD 005';
        }
        field(32; "No of Salaries - Decimal"; Decimal)
        {
            BlankZero = true;
            Caption = 'No of Salaries';
            DecimalPlaces = 0 : 2;
            Description = 'PAB 1.0';
            InitValue = 12;

            trigger OnValidate()
            begin
                Calculate;
            end;
        }
    }

    keys
    {
        key(Key1; UID, "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Valid From")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure Calculate()
    begin
        "Base Salary P.M." := ROUND("Base Salary P.A." / "No of Salaries - Decimal");
        "Car Allowance P.M." := ROUND("Car Allowance P.A." / "No of Salaries - Decimal");

        "Total OTE P.A." := "Base Salary P.A." + "Commission Pay P.A.";
        if "Base Salary P.A." > 0 then
            if "Total OTE P.A." > 0 then
                "Base % Split" := "Base Salary P.A." / "Total OTE P.A."
            else
                "Base % Split" := 0;

        if "Total OTE P.A." > 0 then
            if "Commission Pay P.A." > 0 then
                "Commission % Split" := "Commission Pay P.A." / "Total OTE P.A."
            else
                "Commission % Split" := 0;
    end;
}
