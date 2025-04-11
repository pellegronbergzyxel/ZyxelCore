Table 50100 "HR Role History"
{
    // 001. 09-04-18 ZY-LD 2018032810000364 - Table relation added to field no. 2.
    // 002. 03-05-18 ZY-LD 2018050310000201 - New field.
    // 003. 08-05-18 ZY-LD 2018050810000201 - New key "Employee No.", "Start Date".
    // 004. 22-05-18 ZY-LD 2018050910000191 - Link of Cost Type and Employee.
    // 005. 05-06-18 ZY-LD 2018060410000242 - New fields.
    // 006. 07-08-18 ZY-LD 2018062910000259 - New field.
    // 007. 14-09-18 ZY-LD 2018091210000123 - "Job Title" has extented from 30 to 50 characters.
    // 008. 17-08-20 ZY-LD 2020062510000207 - New fields.
    // 009. 04-02-22 ZY-LD 2022020310000047 - E-mail on line manager change.
    // 010. 01-08-22 ZY-LD 2022072510000087 - "Full Name" has been added to calcfields. Changed to SETAUTOCALCFIELDS.

    Caption = 'Role History';
    DataPerCompany = true;
    Description = 'Role History';
    TableType = Normal;

    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = true;
            Description = 'PAB 1.0';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'PAB 1.0';
            TableRelation = "ZyXEL Employee";
        }
        field(3; "Job Title"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(4; "Start Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(5; "End Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(6; Department; Code[20])
        {
            Caption = 'Department';
            Description = 'PAB 1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(7; "Cost Centre"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "HR Cost Centre".Code;
        }
        field(8; "People Manager"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(9; "Line Manager"; Code[20])
        {
            Caption = 'Line Manager No.';
            Description = 'PAB 1.0';
            TableRelation = "ZyXEL Employee"."No.";

            trigger OnValidate()
            begin
                CalcFields("Line Manager Name", "Full Name");  // 01-08-22 ZY-LD 010

                //>> 05-06-18 ZY-LD 005
                recZyEmp.Get("Employee No.");
                if recZyEmp."Cost Type" <> '' then
                    if recCostType.Get(recZyEmp."Cost Type") then
                        if recZyEmp2.Get("Line Manager") and (recZyEmp2."Cost Type" <> '') then begin
                            recCostType.Validate("Manager No.", recZyEmp2."Cost Type");
                            recCostType.Modify;
                        end;
                //<< 05-06-18 ZY-LD 005

                //>> 04-02-22 ZY-LD 009
                if "Line Manager" <> xRec."Line Manager" then begin
                    recHrRoleHist := Rec;
                    recHrRoleHist.SetAutocalcFields("Line Manager Name");  // 01-08-22 ZY-LD 010
                    if (recHrRoleHist.Next(-1) <> 0) and ("Line Manager" <> recHrRoleHist."Line Manager") then begin
                        Clear(SI);
                        SI.SetMergefield(100, "Full Name");
                        SI.SetMergefield(101, recHrRoleHist."Line Manager Name");
                        SI.SetMergefield(102, "Line Manager Name");
                        EmailAddMgt.CreateSimpleEmail('HR-LINEMAN', '', '');
                        EmailAddMgt.Send;
                    end;
                end;
                //<< 04-02-22 ZY-LD 009
            end;
        }
        field(10; "Line Manager Name"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Line Manager")));
            Caption = 'Line Manager Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Employee Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Permanent,Temp/Contractor,Agency Worker,Consultant';
            OptionMembers = Permanent,"Temp/Contractor","Agency Worker",Consultant;
        }
        field(12; "Employment Hours Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Full Time,Part time';
            OptionMembers = "Full Time","Part time";
        }
        field(13; "Part Time Hours Per Week"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 1 : 1;
            Description = 'PAB 1.0';
        }
        field(14; "Full Time Hours Per Week"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 1 : 1;
            Description = 'PAB 1.0';
        }
        field(15; "Working Pattern"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "HR Working Pattern".Code;
        }
        field(16; "Overtime Paid"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(17; FTE; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(18; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Human Resources Comment Table Name"::"HR Role History"),
                                                                     "Table Line No." = field(UID)));
            Caption = 'Comment';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Job Specification"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(20; "Full Name"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Employee No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(21; Division; Code[20])
        {
            Caption = 'Division';
            Description = '03-05-18 ZY-LD 002';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
        }
        field(22; Changed; Boolean)
        {
            Caption = 'Changed';
            Description = '22-05-18 ZY-LD 004';

            trigger OnValidate()
            begin
                //>> 22-05-18 ZY-LD 004
                "Change Date" := Today;
                "Changed By" := UserId;
                //<< 22-05-18 ZY-LD 004
            end;
        }
        field(23; "Change Date"; Date)
        {
            Caption = 'Change Date';
            Description = '22-05-18 ZY-LD 004';
        }
        field(24; "Changed By"; Code[50])
        {
            Caption = 'Changed By';
            Description = '22-05-18 ZY-LD 004';
        }
        field(25; "Vice President No."; Code[20])
        {
            Description = '05-06-18 ZY-LD 005';
            TableRelation = "ZyXEL Employee";

            trigger OnValidate()
            begin
                //>> 05-06-18 ZY-LD 005
                CalcFields("Vice President Name");

                recZyEmp.Get("Employee No.");
                if recZyEmp."Cost Type" <> '' then
                    if recCostType.Get(recZyEmp."Cost Type") then
                        if recZyEmp2.Get("Vice President No.") and (recZyEmp2."Cost Type" <> '') then begin
                            recCostType.Validate("Vice President No.", recZyEmp2."Cost Type");
                            recCostType.Modify;
                        end;
                //<< 05-06-18 ZY-LD 005
            end;
        }
        field(26; "Vice President Name"; Text[100])
        {
            CalcFormula = lookup("ZyXEL Employee"."Full Name" where("No." = field("Vice President No.")));
            Caption = 'Vice President Name';
            Description = '05-06-18 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Third Party Staff"; Boolean)
        {
            BlankZero = true;
            Caption = 'Third Party Staff';
            Description = '07-08-18 ZY-LD 006';
        }
        field(29; "Tracking Document Id"; Code[20])
        {
            Caption = 'Tracking Document Id';
            Description = '17-08-20 ZY-LD 007';
        }
        field(30; "Tracking Document Attached"; Boolean)
        {
            Caption = 'Tracking Document Attached';
            Description = '17-08-20 ZY-LD 007';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Start Date")
        {
            Clustered = true;
        }
        key(Key2; UID)
        {
        }
    }

    fieldgroups
    {
    }

    var
        recZyEmp: Record "ZyXEL Employee";
        recZyEmp2: Record "ZyXEL Employee";
        recCostType: Record "Cost Type Name";
        recHrRoleHist: Record "HR Role History";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";


    procedure GetNextUID(pEmployeeNo: Code[20]): Integer
    var
        recHRRoleHistory: Record "HR Role History";
    begin
        //>> 22-05-18 ZY-LD 004
        recHRRoleHistory.SetRange("Employee No.", pEmployeeNo);
        if recHRRoleHistory.FindFirst then
            exit(recHRRoleHistory.UID + 10000)
        else
            exit(10000);
        //<< 22-05-18 ZY-LD 004
    end;
}
