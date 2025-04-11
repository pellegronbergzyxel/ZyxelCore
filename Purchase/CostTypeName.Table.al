Table 62018 "Cost Type Name"
{
    // 001. 22-05-18 ZY-LD 2018050910000191 - New field.
    // 002. 05-06-18 ZY-LD 2018060410000242 - New fields.
    // 003. 07-08-20 ZY-LD 2020073110000042 - Create dimension.
    // 004. 03-09-20 ZY-LD P0464 - New field.
    // 005. 10-11-20 ZY-LD 2020110610000108 - Update travel expence when vendor no. is changed.
    // 006. 12-09-23 ZY-LD 000 - Minor Updates.

    Caption = 'Cost Type Name';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            Description = 'PAB1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('COSTTYPE'));
            ValidateTableRelation = false;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            Description = 'PAB1.0';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
            Description = 'PAB1.0';
        }
        field(4; Division; Code[20])
        {
            Caption = 'Division';
            Description = 'PAB1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
        }
        field(5; Department; Code[20])
        {
            Caption = 'Department';
            Description = 'PAB1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));

            trigger OnValidate()
            begin
                //>> 08-06-18 ZY-LD 002
                recGlSetup.Get;
                if recDimValue.Get(recGlSetup."Global Dimension 2 Code", Department) then
                    "HQ Expense Category" := recDimValue."HQ Expense Category";
                //<< 08-06-18 ZY-LD 002
            end;
        }
        field(6; Country; Code[20])
        {
            Caption = 'Country';
            Description = 'PAB1.0';
            TableRelation = "Country/Region".Code;
        }
        field(7; Manager; Text[100])
        {
            Caption = 'Manager Name';
            Description = 'PAB1.0';
            Editable = false;
        }
        field(8; VP; Text[100])
        {
            Caption = 'Vice Precident Name';
            Description = 'PAB1.0';
            Editable = false;
        }
        field(9; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Description = 'PAB1.0';

            trigger OnValidate()
            begin
                //>> 07-08-20 ZY-LD 003
                recGlSetup.Get;
                if recDimValue.Get(recGlSetup."Shortcut Dimension 4 Code", Code) then begin
                    recDimValue.Blocked := Blocked;
                    recDimValue.Modify(true);
                end;
                //<< 07-08-20 ZY-LD 003
            end;
        }
        field(10; "Used on Customer"; Boolean)
        {
            CalcFormula = exist("ZyXEL Employee" where("Cost Type" = field(Code)));
            Caption = 'Used on Customer';
            Description = '22-05-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Manager No."; Code[20])
        {
            Caption = 'Manager Cost Type';
            Description = '05-06-18 ZY-LD 002';
            TableRelation = "Cost Type Name";

            trigger OnValidate()
            begin
                IF "Manager No." <> '' THEN BEGIN  // 12-09-23 ZY-LD 006
                    recZyEmp.SetRange("Code", "Manager No.");
                    if recZyEmp.FindFirst then
                        Manager := recZyEmp.Name;
                END ELSE  // 12-09-23 ZY-LD 006
                    Manager := '';  // 12-09-23 ZY-LD 006
            end;
        }
        field(12; "Vice President No."; Code[20])
        {
            Caption = 'Vice President Cost Type';
            Description = '05-06-18 ZY-LD 002';
            TableRelation = "Cost Type Name";

            trigger OnValidate()
            begin
                IF "Vice President No." <> '' THEN BEGIN  // 12-09-23 ZY-LD 006
                    recZyEmp.SetRange("Code", "Vice President No.");
                    if recZyEmp.FindFirst then
                        VP := recZyEmp.Name;
                END ELSE  // 12-09-23 ZY-LD 006
                    VP := '';  // 12-09-23 ZY-LD 006
            end;
        }
        field(13; "HQ Expense Category"; Code[10])
        {
            Caption = 'HQ Expense Category';
            Description = '05-06-18 ZY-LD 002';
            TableRelation = "HQ Expense Category";
        }
        field(14; "Employee No."; Code[20])
        {
            CalcFormula = lookup("ZyXEL Employee"."No." where("Cost Type" = field(Code)));
            Caption = 'Employee No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "ZyXEL Employee";
        }
        field(15; "Concur Company Name"; Text[30])
        {
            Caption = 'Concur Company Name';
            TableRelation = "Zyxel Company".Name;
            ValidateTableRelation = false;
        }
        field(16; "Concur Credit Card Vendor No."; Code[20])
        {
            Caption = 'Concur Credit Card Account No.';
            TableRelation = /*if ("Bal. Account Type" = const(Vendor)) Vendor  // 18-04-24 ZY-LD 000 - It´s confusing that there is a lookup on the vendor
            else*/
            if ("Bal. Account Type" = const("G/L Account")) "G/L Account";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateConcurVendorNo;  // 10-11-20 ZY-LD 005
            end;
        }
        field(17; "Concur Personal Vendor No."; Code[20])
        {
            Caption = 'Concur Personal Account No.';
            TableRelation = /*if ("Bal. Account Type" = const(Vendor)) Vendor  // 18-04-24 ZY-LD 000 - It´s confusing that there is a lookup on the vendor
            else*/
            if ("Bal. Account Type" = const("G/L Account")) "G/L Account";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateConcurVendorNo;  // 10-11-20 ZY-LD 005
            end;
        }
        field(18; "Concur Approval Limit"; Decimal)
        {
            Caption = 'Concur Approval Limit';
            Description = '03-09-20 ZY-LD 004';
            MinValue = 0;
        }
        field(19; "Concur Id"; Code[20])
        {
            Caption = 'Concur Id';
            Description = '23-09-20 ZY-LD 004';
            Editable = false;
        }
        field(20; "Leaving Date"; Date)
        {
            CalcFormula = lookup("ZyXEL Employee"."Leaving Date" where("No." = field("Employee No.")));
            Caption = 'Leaving Date';
            Description = '23-09-20 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            InitValue = Vendor;
            OptionCaption = 'G/L Account,,Vendor,Bank';
            OptionMembers = "G/L Account",,Vendor,Bank;
        }
        field(22; "Concur Primary Approver"; Boolean)
        {
            Caption = 'Concur Primary Approver';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name)
        {
        }
    }

    trigger OnInsert()
    begin
        InsertDimension;  // 07-08-20 ZY-LD 003
        if ZGT.IsRhq and ZGT.IsZComCompany then  // 23-09-20 ZY-LD 004
            "Concur Id" := GetConcurId;  // 23-09-20 ZY-LD 00
    end;

    var
        recZyEmp: Record "Cost Type Name";
        recDimValue: Record "Dimension Value";
        recGlSetup: Record "General Ledger Setup";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure UpdateManagerAndVP()
    var
        recCostType: Record "Cost Type Name";
        lText001: label 'Do you want to update manager and vice precident?';
        recCostType2: Record "Cost Type Name";
        recZyEmp: Record "ZyXEL Employee";
        recZyEmp2: Record "ZyXEL Employee";
        recRoleHist: Record "HR Role History";
        lText002: label 'Manager name and Vice Precident Name is updated.';
    begin
        //>> 07-06-18 ZY-LD 002
        if Confirm(lText001) then begin
            recCostType.SetRange(Blocked, false);
            if recCostType.FindSet then
                repeat
                    recZyEmp.SetRange("Cost Type", recCostType.Code);
                    if recZyEmp.FindFirst then begin
                        recRoleHist.SetCurrentkey("Employee No.", "Start Date");
                        recRoleHist.SetRange("Employee No.", recZyEmp."No.");
                        recRoleHist.SetFilter("Start Date", '..%1', CalcDate('<CM>', Today));
                        if recRoleHist.FindLast then begin
                            // Line Manager
                            if recRoleHist."Line Manager" <> '' then begin
                                if recZyEmp2.Get(recRoleHist."Line Manager") and (recZyEmp2."Cost Type" <> '') then
                                    if recCostType2.Get(recZyEmp2."Cost Type") then
                                        recCostType.Validate("Manager No.", recZyEmp2."Cost Type");
                            END ELSE  // 12-09-23 ZY-LD 006
                                recCostType.VALIDATE("Manager No.", '');  // 12-09-23 ZY-LD 006
                            // Vice President
                            if recRoleHist."Vice President No." <> '' then begin
                                if recZyEmp2.Get(recRoleHist."Vice President No.") and (recZyEmp2."Cost Type" <> '') then
                                    if recCostType2.Get(recZyEmp2."Cost Type") then
                                        recCostType.Validate("Vice President No.", recZyEmp2."Cost Type");
                            END ELSE  // 12-09-23 ZY-LD 006
                                recCostType.VALIDATE("Vice President No.", '');  // 12-09-23 ZY-LD 006

                            recCostType.Modify;
                        end;
                    end;
                until recCostType.Next() = 0;

            Message(lText002);
        end;
        //<< 07-06-18 ZY-LD 002
    end;


    procedure UpdateDivisionAndDepart()
    var
        recCostType: Record "Cost Type Name";
        lText001: label 'Do you want to update Division and Department on the employee?';
        recZyEmp: Record "ZyXEL Employee";
        recRoleHist: Record "HR Role History";
        lText002: label 'Division and Department has been updated.';
    begin
        //>> 07-06-18 ZY-LD 002
        if Confirm(lText001) then begin
            recCostType.SetRange(Blocked, false);
            if recCostType.FindSet then
                repeat
                    recZyEmp.SetRange("Cost Type", recCostType.Code);
                    if recZyEmp.FindFirst then begin
                        recRoleHist.SetCurrentkey("Employee No.", "Start Date");
                        recRoleHist.SetRange("Employee No.", recZyEmp."No.");
                        if recRoleHist.FindLast then begin
                            recRoleHist.Division := recCostType.Division;
                            recRoleHist.Department := recCostType.Department;
                            recRoleHist.Modify;
                        end;
                    end;
                until recCostType.Next() = 0;

            Message(lText002);
        end;
        //<< 07-06-18 ZY-LD 002
    end;

    local procedure UpdateConcurVendorNo()
    var
        recTrExpHead: Record "Travel Expense Header";
        recTrExpLine: Record "Travel Expense Line";
        ModifyLine: Boolean;
    begin
        //>> 10-11-20 ZY-LD 005
        recTrExpHead.SetRange("Cost Type Name", Code);
        recTrExpHead.SetFilter("Document Status", '<%1', recTrExpHead."document status"::Posted);
        if recTrExpHead.FindSet then
            repeat
                recTrExpLine.SetRange("Document No.", recTrExpHead."No.");
                if recTrExpLine.FindSet(true) then
                    repeat
                        ModifyLine := false;

                        case recTrExpLine.Type of
                            recTrExpLine.Type::"Personal Expense":
                                begin
                                    if (recTrExpLine."Account Type" = recTrExpLine."account type"::Vendor) and
                                       (recTrExpLine."Account No." = xRec."Concur Personal Vendor No.")
                                    then begin
                                        recTrExpLine."Account No." := "Concur Personal Vendor No.";
                                        ModifyLine := true;
                                    end;

                                    if (recTrExpLine."Bal. Account Type" = recTrExpLine."bal. account type"::Vendor) and
                                       (recTrExpLine."Bal. Account No." = xRec."Concur Credit Card Vendor No.")
                                    then begin
                                        recTrExpLine."Bal. Account No." := "Concur Credit Card Vendor No.";
                                        ModifyLine := true;
                                    end;
                                end;
                            recTrExpLine.Type::"Out of Pocket":
                                begin
                                    if (recTrExpLine."Bal. Account Type" = recTrExpLine."bal. account type"::Vendor) and
                                       (recTrExpLine."Bal. Account No." = xRec."Concur Personal Vendor No.")
                                    then begin
                                        recTrExpLine."Bal. Account No." := "Concur Personal Vendor No.";
                                        ModifyLine := true;
                                    end;

                                    if ModifyLine then
                                        recTrExpLine.Modify(true);
                                end;
                        end;
                    until recTrExpLine.Next() = 0;
            until recTrExpHead.Next() = 0;
        //<< 10-11-20 ZY-LD 005
    end;

    local procedure InsertDimension()
    var
        recDimValue: Record "Dimension Value";
        recGenLedgSetup: Record "General Ledger Setup";
        lText001: label 'Employee';
        GenLedgEvent: Codeunit "General Ledger Event";
    begin
        //>> 07-08-20 ZY-LD 003
        recGenLedgSetup.Get;

        if not recDimValue.Get(recGenLedgSetup."Shortcut Dimension 4 Code", Code) then begin
            recDimValue.Init;
            recDimValue.Validate("Dimension Code", recGenLedgSetup."Shortcut Dimension 4 Code");
            recDimValue.Validate(Code, Code);
            recDimValue.Validate(Name, lText001);
            recDimValue.Insert(true);

            recDimValue.Validate("Global Dimension No.", GenLedgEvent.GetGlobalDimensionNo(recDimValue));
            recDimValue.Modify(true);
        end;
        //<< 07-08-20 ZY-LD 003
    end;


    procedure GetConcurId() rValue: Code[20]
    var
        recConcurSetup: Record "Concur Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        lText001: label 'Concur Id was not created.';
    begin
        recConcurSetup.Get;
        recConcurSetup.TestField("Travel Exp. Concur Id Nos");
        rValue := NoSeriesMgt.GetNextNo(recConcurSetup."Travel Exp. Concur Id Nos", Today, true);
        if rValue = '' then
            Error(lText001);
    end;
}
