Table 50109 "ZyXEL Employee"
{
    // 001. 25-01-18 ZY-LD 2018011910000116 - New field.
    // 002. 21-02-18 ZY-LD 2018021610000058 - New field.
    // 003. 23-02-18 ZY-LD 2018022310000133 - Fullname is called when name is changed.
    // 004. 06-04-18 ZY-LD 2018040310000195 - If number is renamed, absence need to be renamed too.
    // 005. 11-04-18 ZY-LD 000 - New fields.
    // 006. 16-04-18 ZY-LD 2018041610000072 - New field.
    // 007. 30-04-18 ZY-LD 2018042610000161 - New fields.
    // 008. 22-08-18 ZY-LD 2018050910000191 - Table relation set on Cost Type.
    // 009. 27-07-18 ZY-LD 2018062910000259 - New field.
    // 010. 15-10-18 ZY-LD 2018101510000026 - New fields.
    // 011. 17-10-18 ZY-LD 2018101710000068 - Setup No. Series.
    // 012. 29-11-18 ZY-LD 2018111310000046 - Calc of Probation Date.
    // 013. 26-02-19 ZY-LD 2019022610000055 - New field.
    // 014. 26-06-19 ZY-LD 2019062410000088 - New field.
    // 015. 17-10-19 ZY-LD 2019101610000157 - New field.
    // 016. 24-10-19 ZY-LD 2019102410000052 - Bank Account No. is extended from 30 to 40 charcteres.
    // 017. 28-10-19 ZY-LD 2019102710000047 - Send e-mail if cost type changes.
    // 018. 28-09-20 ZY-LD 2020092810000054 - "Termination Date" has got a new caption "Notice Date".
    // 019. 18-11-20 ZY-LD 2020111010000074 - New field.
    // 020. 16-08-21 ZY-LD 2021081310000064 - Nationality has changed sub table from "Country/Region" to Natiolality.

    Caption = 'Employee';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DrillDownPageID = "Zyxel HR Employee List";
    LookupPageID = "Zyxel HR Employee List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
                    "No. Series" := '';
                end;

                HumanResSetup.Get;
                NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
                "No. Series" := '';
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                "Full Name" := FullName;  // 23-02-18 ZY-LD 003
            end;
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                "Full Name" := FullName;  // 23-02-18 ZY-LD 003
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                "Full Name" := FullName;  // 23-02-18 ZY-LD 003
            end;
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Initials)) or ("Search Name" = '') then
                    "Search Name" := Initials;
            end;
        }
        field(6; "Job Title"; Text[50])
        {
            CalcFormula = lookup("HR Role History"."Job Title" where("Employee No." = field("No."),
                                                                      "Start Date" = field("Date Filter History")));
            Caption = 'Job Title';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
            Description = 'PAB 1.0';
        }
        field(8; Address; Text[50])
        {
            Caption = 'Address';
            Description = 'PAB 1.0';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            Description = 'PAB 1.0';
        }
        field(10; City; Text[30])
        {
            Caption = 'City';
            Description = 'PAB 1.0';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            Description = 'PAB 1.0';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(12; County; Text[30])
        {
            Caption = 'County';
            Description = 'PAB 1.0';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            Description = 'PAB 1.0';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            Description = 'PAB 1.0';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(16; "Alt. Address Code"; Code[10])
        {
            Caption = 'Alt. Address Code';
            Description = 'PAB 1.0';
            TableRelation = "Alternative Address".Code where("Employee No." = field("No."));
        }
        field(17; "Alt. Address Start Date"; Date)
        {
            Caption = 'Alt. Address Start Date';
            Description = 'PAB 1.0';
        }
        field(18; "Alt. Address End Date"; Date)
        {
            Caption = 'Alt. Address End Date';
            Description = 'PAB 1.0';
        }
        field(19; Picture; Blob)
        {
            Caption = 'Picture';
            Description = 'PAB 1.0';
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
            Description = 'PAB 1.0';
        }
        field(21; "Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                Employee: Record Employee;
                Weight: Text[10];
                I: Integer;
                Ok: Boolean;
                V: Integer;
                C: Integer;
                "Sum": Integer;
            begin
            end;
        }
        field(22; "Union Code"; Code[10])
        {
            Caption = 'Union Code';
            Description = 'PAB 1.0';
            TableRelation = Union;
        }
        field(23; "Union Membership No."; Text[30])
        {
            Caption = 'Union Membership No.';
            Description = 'PAB 1.0';
        }
        field(24; Gender; Option)
        {
            Caption = 'Gender';
            Description = 'PAB 1.0';
            OptionCaption = ' ,Female,Male,Non-Binary';
            OptionMembers = " ",Female,Male,"Non-Binary";
        }
        field(25; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";
        }
        field(26; "Manager No."; Code[20])
        {
            CalcFormula = max("HR Role History"."Line Manager" where("Employee No." = field("No."),
                                                                      "Start Date" = field("Date Filter History")));
            Caption = 'Manager No.';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ZyXEL Employee";
        }
        field(27; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            Description = 'PAB 1.0';
            TableRelation = "Employment Contract";
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            Caption = 'Statistics Group Code';
            Description = 'PAB 1.0';
            TableRelation = "Employee Statistics Group";
        }
        field(29; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Validate("Probation Period (Months)");  // 29-11-18 ZY-LD 012
            end;
        }
        field(30; "Next Birth Date"; Date)
        {
            Caption = 'Next Birth Date';
            Description = '25-01-18 ZY-LD 001';
        }
        field(31; Status; Option)
        {
            Caption = 'Status';
            Description = 'PAB 1.0';
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(32; "Inactive Date"; Date)
        {
            Caption = 'Inactive Date';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                bEndingDateReset: Boolean;
                bPeriodFound: Boolean;
            begin
            end;
        }
        field(33; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            Description = 'PAB 1.0';
            TableRelation = "Cause of Inactivity";

            trigger OnValidate()
            var
                CauseOfInactivity: Record "Cause of Inactivity";
            begin
            end;
        }
        field(34; "Termination Date"; Date)
        {
            Caption = 'Notice Date';
            Description = 'PAB 1.0';
        }
        field(35; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            Description = 'PAB 1.0';
            TableRelation = "Grounds for Termination";

            trigger OnValidate()
            var
                GroundsForTerm: Record "Grounds for Termination";
            begin
            end;
        }
        field(36; "Global Dimension 1 Code"; Code[20])
        {
            CalcFormula = max("HR Role History".Division where("Employee No." = field("No."),
                                                                "Start Date" = field("Date Filter History")));
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(37; "Global Dimension 2 Code"; Code[20])
        {
            CalcFormula = max("HR Role History".Department where("Employee No." = field("No."),
                                                                  "Start Date" = field("Date Filter History")));
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(38; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'PAB 1.0';
            TableRelation = Resource where(Type = const(Person));
        }
        field(39; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Human Resources Comment Table Name"::"ZyXEL Employee"), "No." = field("No.")));
            Caption = 'Comment';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
        }
        field(42; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(43; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(44; "Cause of Absence Filter"; Code[10])
        {
            Caption = 'Cause of Absence Filter';
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Absence";
        }
        field(45; "Total Absence"; Decimal)
        {
            CalcFormula = sum("Employee Absence".Quantity where("Employee No." = field("No."),
                                                             "Cause of Absence Code" = field("Cause of Absence Filter"),
                                                             "From Date" = field("Date Filter")));
            Caption = 'Total Absence';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; Extension; Text[30])
        {
            Caption = 'Extension';
            Description = 'PAB 1.0';
        }
        field(47; "Employee No. Filter"; Code[20])
        {
            Caption = 'Employee No. Filter';
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(48; Pager; Text[30])
        {
            Caption = 'Pager';
            Description = 'PAB 1.0';
        }
        field(49; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            Description = 'PAB 1.0';
        }
        field(50; "Company E-Mail"; Text[80])
        {
            Caption = 'Company E-Mail';
            Description = 'PAB 1.0';
        }
        field(51; Title; Text[30])
        {
            Caption = 'Title';
            Description = 'PAB 1.0';
        }
        field(52; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            Description = 'PAB 1.0';
            TableRelation = "Salesperson/Purchaser";
        }
        field(53; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Description = 'PAB 1.0';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(1100; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            Description = 'PAB 1.0';
            TableRelation = "Cost Center";
        }
        field(1101; "Cost Object Code"; Code[20])
        {
            Caption = 'Cost Object Code';
            Description = 'PAB 1.0';
            TableRelation = "Cost Object";
        }
        field(50000; Company; Code[20])
        {
            Caption = 'Office Location';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "HR Offices"."Primary Key";

            trigger OnValidate()
            begin
                //>> 29-11-18 ZY-LD 012
                if recHrOffice.Get(Company) and (recHrOffice."Probation Period (Month)" <> 0) then
                    Validate("Probation Period (Months)", recHrOffice."Probation Period (Month)");
                //<< 29-11-18 ZY-LD 012
            end;
        }
        field(50001; "Known As"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50002; "Marital Status"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Single,Married,Partner,Divorced,Widowed,Common Law,Cohabitate';
            OptionMembers = Single,Married,Partner,Divorced,Widowed,"Common Law",Cohabitate;
        }
        field(50003; "Service Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50004; "Right to Work in Country"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50005; "ID Provided"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50006; "ID Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Passport,ID Card,Driving License,Birth Certificate';
            OptionMembers = Passport,"ID Card","Driving License","Birth Certificate";
        }
        field(50007; "Expiration Date of ID"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50008; Nationality; Code[10])
        {
            Caption = 'Nationality';
            Description = '16-08-21 ZY-LD 020';
            TableRelation = Nationality;
        }
        field(50010; "Driving License Checked"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50011; "Driving License No"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50012; "Driving License Expiry"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50013; "Driving License Copy Attached"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50014; "Division Code Filter"; Code[20])
        {
            CalcFormula = lookup("HR Role History".Department where("Employee No." = field("No."),
                                                                     "End Date" = filter('')));
            Caption = 'Division Code Filter';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "HR Division";
        }
        field(50015; "Full Time Hours Per Week"; Decimal)
        {
            BlankZero = true;
            CalcFormula = lookup("HR Role History"."Full Time Hours Per Week" where("Employee No." = field("No."),
                                                                                     "Start Date" = field("Date Filter History")));
            Caption = 'Full Time Hours Per Week';
            DecimalPlaces = 1 : 1;
            Description = '18-11-20 ZY-LD 019';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "Previous Employment Date"; Date)
        {
            Caption = 'Previous Employment Date';
        }
        field(50017; "Pres. Skills Training Compl."; Boolean)
        {
            Caption = 'Presentation Skills Training Completed';
        }
        field(50020; "Full Name"; Text[100])
        {
            Description = 'PAB 1.0';
        }
        field(50022; "Bank Account No."; Text[40])
        {
            Description = 'PAB 1.0';
        }
        field(50023; "Sort Code"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50024; "Place of Birth"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50025; "Exclude from Reports"; Boolean)
        {
            Caption = 'Exclude from Reports';
            Description = '17-10-19 ZY-LD 015';
        }
        field(50034; "ZyXEL Email Address"; Text[30])
        {
            Caption = 'ZyXEL E-mail Address';
            Description = 'PAB 1.0';
        }
        field(50035; "ZyXEL Telephone No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50036; "ZyXEL Fax No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50037; "Skype Address"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50038; "Date Notice Given"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50039; "Notice Given To"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Employee."No.";
        }
        field(50040; "Notice Given To Name"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Notice Given To")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50041; "Notice Period by EE"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50042; "Notice to be given by ER"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50043; "Notice Period Comments"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50044; "Leaving Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50045; "Last Physical Day Worked"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50046; "Garden Leave"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50047; "Leaving Comments"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50048; "Other Comments"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50049; "Pension Scheme"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50050; "Healthcare Scheme"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50051; "Healthcare Provider"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50052; "Life Assurance"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50053; "Other Benefits"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50054; "Holiday Entitlement"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50055; "Sickness Pay"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50056; Laptop; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50057; "Mobile Phone"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50058; "Home Internet"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50059; "Home Internet Amount"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50060; "Home Internet Amount Currency"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
        }
        field(50061; "Bank Name"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50062; "Name of Account"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50063; "Emergency Contact Name"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50064; "Emergency Contact Relationship"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50065; "Emergency Contact Tel No 1"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50066; "Address 3"; Text[50])
        {
            Caption = 'Address 2';
            Description = 'PAB 1.0';
        }
        field(50067; "Emergency Contact Tel No 2"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50068; "Insight Profile Completed"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50069; "Code of Conduct Signed"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50070; "Probation Period (Months)"; Integer)
        {
            Description = 'PAB 1.0';
            MaxValue = 12;
            MinValue = 0;

            trigger OnValidate()
            begin
                //>> 29-11-18 ZY-LD 012
                if not "Probation Passed" then begin
                    if ("Probation Period (Months)" <> 0) and ("Employment Date" <> 0D) then begin
                        Evaluate(DateFormula, StrSubstNo('<%1M>', "Probation Period (Months)"));
                        "Probation Review Meeting" := CalcDate(DateFormula, "Employment Date");
                    end;
                end else
                    "Probation Period (Months)" := xRec."Probation Period (Months)";
                //<< 29-11-18 ZY-LD 012
            end;
        }
        field(50071; "Probation Review Meeting"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50072; "Probation Passed"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50073; "Company Option"; Option)
        {
            Caption = 'Zyxel Company';
            Description = '26-06-19 ZY-LD 014';
            OptionCaption = ' ,Zyxel Communications,Zyxel Networks,Sphairon';
            OptionMembers = " ","Zyxel Communications","Zyxel Networks",Sphairon;
        }
        field(50076; "Mileage Paid"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50077; "Right To Process EE Data"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50078; "Salary Review Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50079; "Pay Date"; Option)
        {
            Description = 'PAB 1.0';
            InitValue = "2nd";
            OptionCaption = '1st,2nd,3rd,4th,5th,6th,7th,8th,9th,10th,11th,13th,14th,15th,16th,17th,18th,19th,20th,21st,22nd,23rd,24th,25th,26th,27th,28th,29th,30th,31st,Last Thursday,Last Friday,Last Day of Month';
            OptionMembers = "1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st","Last Thursday","Last Friday","Last Day of Month";
        }
        field(50080; "Disciplinary Meeting Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50081; "Disciplinary Meeting Locations"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50082; "Exit Interview"; Boolean)
        {
            Description = 'PAB1.0';
        }
        field(50083; "Active employee"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50084; "Pension Scheme Provider"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50085; "PEN Employee Contr. (%)"; Decimal)
        {
            Caption = 'Pension Employee Contr. (%)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50086; "PEN Employee Contr. (Amount)"; Decimal)
        {
            Caption = 'Pension Employee Contr. (Amount)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50087; "PEN Employer Contr. (%)"; Decimal)
        {
            Caption = 'Pension Employer Contr. (%)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50088; "PEN Employer Contr. (Amount)"; Decimal)
        {
            Caption = 'Pension Employer Contr. (Amount)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50089; "Life Insurance Provider"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50090; "LI Employee Contr. (%)"; Decimal)
        {
            Caption = 'Life Insurance Employee Contr. (%)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50091; "LI Employee Contr. (Amount)"; Decimal)
        {
            Caption = 'Life Insurance Employee Contr. (Amount)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50092; "LI Employer Contr. (%)"; Decimal)
        {
            Caption = 'Life Insurance Employer Contr. (%)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50093; "LI Employer Contr. (Amount)"; Decimal)
        {
            Caption = 'Life Insurance Employer Contr. (Amount)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50095; "Travel Insurance"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50096; "HC Employee Contr. (%)"; Decimal)
        {
            Caption = 'Healthcare Employee Contr. (%)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50097; "HC Employee Contr. (Amount)"; Decimal)
        {
            Caption = 'Healthcare Employee Contr. (Amount)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50098; "HC Employer Contr. (%)"; Decimal)
        {
            Caption = 'Healthcare Employer Contr. (%)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50099; "HC Employer Contr. (Amount)"; Decimal)
        {
            Caption = 'Healthcare Employer Contr. (Amount)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(50100; "HC Currency Code"; Code[20])
        {
            Caption = 'Healthcare Currency Code';
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
            ValidateTableRelation = true;
        }
        field(50101; "PEN Currency Code"; Code[20])
        {
            Caption = 'Pension Currency Code';
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
        }
        field(50102; "LI Currency Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
        }
        field(50119; "ID number"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50120; "Work Mobile No"; Text[20])
        {
            Description = 'PAB 1.0';
        }
        field(50126; "Manager Fullname"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Manager No.")));
            Caption = 'Manager Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50132; "Cost Type"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Cost Type Name" where("Used on Customer" = const(false));

            trigger OnValidate()
            begin
                UpdateEmloyeeHistory;  // 22-08-18 ZY-LD 008

                //>> 28-10-19 ZY-LD 017
                if ("Cost Type" <> xRec."Cost Type") and (xRec."Cost Type" <> '') then begin
                    SI.SetMergefield(100, "No.");
                    SI.SetMergefield(101, xRec."Cost Type");
                    SI.SetMergefield(102, "Cost Type");
                    EmailAddMgt.CreateSimpleEmail('HR-COSTTYP', '', '');
                    EmailAddMgt.Send;
                end;
                //<< 28-10-19 ZY-LD 017
            end;
        }
        field(50133; "Date when fund allocated"; Date)
        {
            Caption = 'Date to confirm when fund allocated';
            Description = 'PAB 1.0';
        }
        field(50134; "Amount allocated"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50135; "Credit Card"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50136; "Card Number"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50137; "Date given"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50138; "Expiry Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50139; "Credit Limit"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50140; "Amount Allocated Currency Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
        }
        field(50141; "Credit Card Currency Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
        }
        field(50142; "No of Salary Lines in Period"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("HR Salary Line" where("Employee No." = field("No."),
                                                        "Valid From" = field("Date Filter")));
            Caption = 'No of Salary Lines in Period';
            Description = '21-02-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50143; "No of Salary Lines"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("HR Salary Line" where("Employee No." = field("No.")));
            Caption = 'No of Salary Lines';
            Description = '21-02-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50144; "Employee Type Filter"; Option)
        {
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            OptionCaption = 'Permanent,Temp/Contractor,Agency Worker,Consultant';
            OptionMembers = Permanent,"Temp/Contractor","Agency Worker",Consultant;
        }
        field(50145; "No of Role_Job Details"; Integer)
        {
            CalcFormula = count("HR Role History" where("Employee No." = field("No."),
                                                         "Employee Type" = field("Employee Type Filter"),
                                                         "Start Date" = field("Date Filter")));
            Caption = 'No of Role/Job Details';
            Description = '11-04-18 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50151; "GDPR Training Completed"; Boolean)
        {
            Caption = 'GDPR Training Completed';
            Description = '30-04-18 ZY-LD 007';

            trigger OnValidate()
            begin
                //>> 30-04-18 ZY-LD 007
                "GDPR Training Completed Date" := 0D;
                if "GDPR Training Completed" then
                    "GDPR Training Completed Date" := Today;
                //<< 30-04-18 ZY-LD 007
            end;
        }
        field(50152; "GDPR Training Completed Date"; Date)
        {
            Caption = 'GDPR Training Completed Date';
            Description = '30-04-18 ZY-LD 007';
        }
        field(50153; "GDPR Consent Form Returned"; Boolean)
        {
            Caption = 'GDPR Consent Form Returned';
            Description = '30-04-18 ZY-LD 007';

            trigger OnValidate()
            begin
                //>> 30-04-18 ZY-LD 007
                "GDPR Consent Form Ret. Date" := 0D;
                if "GDPR Consent Form Returned" then
                    "GDPR Consent Form Ret. Date" := Today;
                //<< 30-04-18 ZY-LD 007
            end;
        }
        field(50154; "GDPR Consent Form Ret. Date"; Date)
        {
            Caption = 'GDPR Consent Form Retudrned Date';
            Description = '30-04-18 ZY-LD 007';
        }
        field(50155; "GDPR Consent Form Signed"; Boolean)
        {
            Caption = 'GDPR Consent Form Signed';
            Description = '30-04-18 ZY-LD 007';

            trigger OnValidate()
            begin
                //>> 30-04-18 ZY-LD 007
                "GDPR Consent Form Signed Date" := 0D;
                if "GDPR Consent Form Signed" then
                    "GDPR Consent Form Signed Date" := Today;
                //<< 30-04-18 ZY-LD 007
            end;
        }
        field(50156; "GDPR Consent Form Signed Date"; Date)
        {
            Caption = 'GDPR Consent Form Signed Date';
            Description = '30-04-18 ZY-LD 007';
        }
        field(50157; "GDPR Consent Withdrawn"; Boolean)
        {
            Caption = 'GDPR Consent Withdrawn';
            Description = '30-04-18 ZY-LD 007';

            trigger OnValidate()
            begin
                //>> 30-04-18 ZY-LD 007
                "GDPR Consent Withdrawn Date" := 0D;
                if "GDPR Consent Withdrawn" then
                    "GDPR Consent Withdrawn Date" := Today;
                //<< 30-04-18 ZY-LD 007
            end;
        }
        field(50158; "GDPR Consent Withdrawn Date"; Date)
        {
            Caption = 'GDPR Consent Withdrawn Date';
            Description = '30-04-18 ZY-LD 007';
        }
        field(50160; "Other Benefits Amount"; Decimal)
        {
            CalcFormula = sum("HR Other Benefits".Amount where("Employee No." = field("No.")));
            Caption = 'Other Benefits Amount';
            Description = '27-07-18 ZY-LD 009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50161; "Severence Pay"; Decimal)
        {
            Caption = 'Severence Pay';
            Description = '27-07-18 ZY-LD 009';
        }
        field(50162; "Housing Allowance"; Decimal)
        {
            Caption = 'Housing Allowance';
            Description = '27-07-18 ZY-LD 009';
        }
        field(50163; "Social Cost"; Decimal)
        {
            Caption = 'Social Cost';
            Description = '27-07-18 ZY-LD 009';
        }
        field(50164; "Medical Insurance"; Decimal)
        {
            Caption = 'Medical Insurance';
            Description = '27-07-18 ZY-LD 009';
        }
        field(50165; "Date Filter History"; Date)
        {
            Caption = 'Date Filter History';
            FieldClass = FlowFilter;
        }
        field(50166; "Employment Hours Type"; Option)
        {
            CalcFormula = max("HR Role History"."Employment Hours Type" where("Employee No." = field("No."),
                                                                               "Start Date" = field("Date Filter History")));
            Description = '26-02-19 ZY-LD 013';
            FieldClass = FlowField;
            OptionCaption = 'Full Time,Part Time';
            OptionMembers = "Full Time","Part Time";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Status, "Union Code")
        {
        }
        key(Key4; Status, "Emplymt. Contract Code")
        {
        }
        key(Key5; "Last Name", "First Name", "Middle Name")
        {
        }
        key(Key6; "Social Security No.")
        {
        }
        key(Key7; "First Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Last Name", Initials, "Job Title")
        {
        }
    }


    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(Database::Employee, "No.");
    end;

    trigger OnInsert()
    begin
        //>> 17-10-18 ZY-LD 011
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Employee Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        //<< 17-10-18 ZY-LD 011
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    var
        EmployeeQualification: Record "Employee Qualification";
        EmployeeQualification2: Record "Employee Qualification";
    begin
        "Last Date Modified" := Today;

        //>> 06-04-18 ZY-LD 004
        EmpAbs.SetRange("Employee No.", xRec."No.");
        if EmpAbs.FindSet then
            repeat
                EmpAbs."Employee No." := "No.";
                EmpAbs.Modify;
            until EmpAbs.Next() = 0;
        //<< 06-04-18 ZY-LD 004
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record "ZyXEL Employee";
        Res: Record Resource;
        PostCode: Record "Post Code";
        EmployeeQualification: Record "Employee Qualification";
        EmployeeAbsence: Record "Employee Absence";
        HumanResComment: Record "Human Resource Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        EmpAbs: Record "Employee Absence";
        recHrOffice: Record "HR Offices";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeResUpdate: Codeunit "Employee/Resource Update";
        EmployeeSalespersonUpdate: Codeunit "Employee/Salesperson Update";
        DimMgt: Codeunit DimensionManagement;
        Text000: label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text1160030000: label '%1 and %2 cannot be entered at the same time.';
        Text1160030001: label 'This field is only used when the Pay Frequency is fortnightly.';
        Text1160030003: label '%1 cannot be blank when %2 is not.';
        Text1160030004: label '%1 cannot be before %2.';
        Text1160030005: label 'An employee cannot both be inactive and absent in the same period.';
        Text1160030002: label 'An employee with this Social Security No. already exists.';
        Text1160030022: label 'Employment Date cannot be blank.';
        Text1160030023: label 'Employment Date cannot be before last Termination Date.';
        Text1160030024: label 'Data cannot be entered in %1 when either %2 or %3 have been entered.';
        Text1160030025: label 'Inactivity Date cannot be before Employment Date.';
        Text1160030026: label 'Inactivity Date cannot be removed.\This happens automatically when entering a new Employment Date.';
        Text1160030027: label 'Termination Date cannot be removed.\This happens automatically when entering a new Employment Date.';
        Text1160030028: label 'Termination Date cannot be before Employment Date.';
        Text1160030029: label 'Employee %1  cannot be deleted. Posted entries exit.';
        Text1240470007: label 'There is already an applicant with this Employee No. %1.';
        Text1161020000: label 'Municipality Address Code %1 does not exist for Municipality Code %2';
        Text1161020003: label 'Employee %1  cannot be deleted. Payroll Documents exit.';
        Text1161020004: label 'It is not possible to pay more than 100 % in tax.';
        Text1161020005: label 'It is not possible to enter a negative number.';
        Text1161020007: label 'SE-No. "%1" is not a valid SE-No.';
        Text1161020008: label 'SE-No. and Social Security No. can not both be applied at the same time.\\Do you wish to delete Social Security No. "%1" for Employee %2 %3?';
        Text1161020009: label 'Action canceled by user.';
        Text1161020010: label 'SE-No. and Social Security No. can not both be applied at the same time.\\Do you wish to delete SE-No. "%1" for Employee %2 %3?';
        Text1161020011: label 'Employee: "%1 %2"\Data in the Absence Reg. Journals will be deleted.\Do you wish to continue?';
        Text1161020012: label 'Ii is not possible to use Nemkonto, because an agreement about it not made.  ';
        EmployeeFilterDelimitation: Code[20];
        bEmployeeTemplate: Boolean;
        Text161024001: label 'The Field  "%1" must be filled.';
        Text161029000: label 'You are about to change the agreement code that has FV Setup.\Do You wish to continue?';
        Text161029001: label 'You have selected an agreement code that has FV Setup.\Do You wish to continue?';
        Text1160030017: label 'This Period covers an existing period.';
        Text1160030009: label '%1 can''t be deleted when %2 are filled.';
        InsertFromHR: Boolean;
        Text1161020015: label 'Do you wish to create a relation to Human Resource for %1 %2?';
        Text1161020016: label '%1 %2 has relations to one Human Resource, which not will be deleted.';
        constLanguageID: label 'Language ID: %1 is not a valid value.';
        constWorkCalChange: label 'Medarbejder %1 %2 er aktiv på LESSOR-Portalen. Du skal være opmærksom på at du selv evt. skal ændre saldi på LESSOR-Portalen.';
        constCPRCheck: label 'Social Security No. %1 does not comply with modulus 11 control.\Do you want to continue?';
        DateFormula: DateFormula;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";


    procedure AssistEdit(OldEmployee: Record "ZyXEL Employee"): Boolean
    begin
        //>> 17-10-18 ZY-LD 011
        begin
            Employee := Rec;
            HumanResSetup.Get;
            HumanResSetup.TestField("Employee Nos.");
            if NoSeriesMgt.SelectSeries(HumanResSetup."Employee Nos.", OldEmployee."No. Series", Employee."No. Series") then begin
                HumanResSetup.Get;
                HumanResSetup.TestField("Employee Nos.");
                NoSeriesMgt.SetSeries(Employee."No.");
                Rec := Employee;
                exit(true);
            end;
        end;
        //<< 17-10-18 ZY-LD 011
    end;


    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("First Name" + ' ' + "Last Name");

        exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::Employee, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    local procedure UpdateEmloyeeHistory()
    var
        recHRRoleHist: Record "HR Role History";
        lText001: label 'There is more than one employee registered on this cost type.';
        recCostTypeName: Record "Cost Type Name";
        RecordIsChanged: Boolean;
    begin
        //>> 22-08-18 ZY-LD 008
        if recCostTypeName.Get("Cost Type") then begin
            recHRRoleHist.SetRange("Employee No.", "No.");
            recHRRoleHist.SetRange("Start Date", Today);
            if not recHRRoleHist.FindFirst then begin
                recHRRoleHist.SetRange("Start Date");
                if recHRRoleHist.FindLast and (recHRRoleHist."Start Date" < Today) then begin
                    recHRRoleHist.UID := recHRRoleHist.GetNextUID("No.");
                    recHRRoleHist."Start Date" := Today;
                    recHRRoleHist.Insert(true);
                end else begin
                    Clear(recHRRoleHist);
                    recHRRoleHist.UID := recHRRoleHist.GetNextUID("No.");
                    recHRRoleHist."Employee No." := "No.";
                    recHRRoleHist."Start Date" := Today;
                    recHRRoleHist.Insert(true);
                end;
            end;

            if recCostTypeName.Division <> recHRRoleHist.Division then begin
                recHRRoleHist.Division := recCostTypeName.Division;
                RecordIsChanged := true;
            end;
            if recCostTypeName.Department <> recHRRoleHist.Department then begin
                recHRRoleHist.Department := recCostTypeName.Department;
                RecordIsChanged := true;
            end;

            if RecordIsChanged then begin
                recHRRoleHist.Changed := true;
                recHRRoleHist.Modify;
            end;
        end;
        //<< 22-08-18 ZY-LD 008
    end;


    procedure GetJobTitle()
    var
        recRoles: Record "HR Role History";
        LastDate: Date;
    begin
        "Job Title" := '';
        recRoles.SetRange("Employee No.", "No.");
        Copyfilter("Date Filter History", recRoles."Start Date");
        if recRoles.FindLast then
            "Job Title" := recRoles."Job Title";
    end;


    procedure GetManager()
    var
        recRoles: Record "HR Role History";
        ManagerCode: Code[20];
        recEmployee: Record "ZyXEL Employee";
    begin
        "Manager Fullname" := '';
        recRoles.SetRange("Employee No.", "No.");
        Copyfilter("Date Filter History", recRoles."Start Date");
        if recRoles.FindLast and (recRoles."Line Manager" <> '') then
            recEmployee.Get(recRoles."Line Manager");
        "Manager Fullname" := recEmployee."Full Name";
    end;
}
