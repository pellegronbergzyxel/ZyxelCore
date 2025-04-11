page 50295 "Cost Type Name Card"
{
    // 001. 22-05-18 ZY-LD 2018050910000191 - Created.
    // 002. 05-06-18 ZY-LD 2018060410000242 - New fields.
    // 003. 11-11-19 ZY-LD 2019111110000021 - If a line already exist, then we don't want to insert a new one.
    // 004. 01-10-20 ZY-LD 000 - Send changes that concerns Concur.
    // 005. 03-08-21 ZT-LD 000 - Only editable in ZCom.

    PageType = Card;
    SourceTable = "Cost Type Name";
    ApplicationArea = all;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control17)
                {
                    ShowCaption = false;
                    field(Division; Rec.Division)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Department; Rec.Department)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("HQ Expense Category"; Rec."HQ Expense Category")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Country; Rec.Country)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Control18)
                {
                    ShowCaption = false;
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Manager No."; Rec."Manager No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = true;
                    }
                    field(Manager; Rec.Manager)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Vice President No."; Rec."Vice President No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = true;

                    }
                    field(VP; Rec.VP)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Concur)
            {
                Caption = 'Concur';
                group("Travel Expense")
                {
                    Caption = 'Travel Expense';
                    field("Concur Company Name"; Rec."Concur Company Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Company Name';
                    }
                    group(Control24)
                    {
                        ShowCaption = false;
                        field("Bal. Account Type"; Rec."Bal. Account Type")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field("Concur Credit Card Vendor No."; Rec."Concur Credit Card Vendor No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Credit Card Vendor No';
                        }
                        field("Concur Personal Vendor No."; Rec."Concur Personal Vendor No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Personal Vendor No.';
                        }
                    }
                }
                group("Invoice Capture")
                {
                    Caption = 'Invoice Capture';
                    field("Concur Id"; Rec."Concur Id")
                    {
                        ApplicationArea = Basic, Suite;
                        Visible = ConcurIdVisible;
                    }
                    field("Concur Approval Limit"; Rec."Concur Approval Limit")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approval Limit';
                    }
                    field("Concur Primary Approver"; Rec."Concur Primary Approver")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control15; Links)
            {
            }
            systempart(Control13; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            Action("Dimension Value")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dimension Value';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    recGenSetup.Get();
                    recDimValue.SetRange("Dimension Code", recGenSetup."Shortcut Dimension 4 Code");
                    recDimValue.SetRange(Code, Rec.Code);
                    Page.RunModal(Page::"Dimension Value", recDimValue);
                end;
            }
        }
        area(processing)
        {
            Action("Create Concur ID")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Concur ID';
                Image = CreateSerialNo;
                Visible = ConcurIdVisible;

                trigger OnAction()
                begin
                    if Rec."Concur Id" = '' then begin
                        Rec."Concur Id" := Rec.GetConcurId;
                        Rec.Modify();
                    end;
                end;
            }

            Action(Updatename)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update names';
                Image = CreateSerialNo;
                Visible = true;

                trigger OnAction()
                begin
                    rec.validate("Manager No.", rec."Manager No.");
                    rec.validate("Vice President No.", rec."Vice President No.");
                    CurrPage.Update(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnClosePage()
    begin
        UpdateEmloyeeHistory;
        NewCostType;
        ChangedCostType;  // 01-10-20 ZY-LD 004
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //>> 01-10-20 ZY-LD 004
        if (Rec.Division <> xRec.Division) or
           (Rec.Department <> xRec.Department) or
           (Rec."Concur Company Name" <> xRec."Concur Company Name")
        then begin
            if Rec.Division <> xRec.Division then
                xRecDivision := xRec.Division;
            if Rec.Department <> xRec.Department then
                xRecDepartment := xRec.Department;
            if Rec."Concur Company Name" <> xRec."Concur Company Name" then
                xRecCompanyName := xRec."Concur Company Name";
            ConcurDataModified := true;
        end;
        //<< 01-10-20 ZY-LD 004
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewCostTypeCreated := true;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        NewCostTypeCreated: Boolean;
        ConcurDataModified: Boolean;
        recGenSetup: Record "General Ledger Setup";
        recDimValue: Record "Dimension Value";
        ZGT: Codeunit "ZyXEL General Tools";
        xRecDivision: Code[20];
        xRecDepartment: Code[20];
        xRecCompanyName: Text[80];
        ConcurIdVisible: Boolean;

    local procedure UpdateEmloyeeHistory()
    var
        recZyEmp: Record "ZyXEL Employee";
        recHRRoleHist: Record "HR Role History";
        lText001: Label 'There is more than one employee registered on this cost type.';
        RecordIsChanged: Boolean;
        lText002: Label 'There has been a change on cost type name that will effect employee no. %1. "%2": %3.';
        EmailAddMgt: Codeunit "E-mail Address Management";
    begin
        recZyEmp.SetRange("Cost Type", Rec.Code);
        if recZyEmp.Count() > 1 then
            Error(lText001);

        if recZyEmp.FindFirst() then begin
            recHRRoleHist.SetRange("Employee No.", recZyEmp."No.");
            recHRRoleHist.SetRange("Start Date", Today);
            if not recHRRoleHist.FindFirst() then begin
                recHRRoleHist.SetRange("Start Date");
                if recHRRoleHist.FindLast() and (recHRRoleHist."Start Date" < Today) then begin
                    //>> 11-11-19 ZY-LD 003
                    /*recHRRoleHist.UID := recHRRoleHist.GetNextUID(recZyEmp."No.");
                    recHRRoleHist."Start Date" := TODAY;
                    recHRRoleHist.INSERT(TRUE);*/
                    //<< 11-11-19 ZY-LD 003
                end else begin
                    Clear(recHRRoleHist);
                    recHRRoleHist.UID := recHRRoleHist.GetNextUID(recZyEmp."No.");
                    recHRRoleHist."Employee No." := recZyEmp."No.";
                    recHRRoleHist."Start Date" := Today;
                    recHRRoleHist.Insert(true);
                end;
            end;

            if Rec.Division <> recHRRoleHist.Division then begin
                recHRRoleHist.Division := Rec.Division;
                RecordIsChanged := true;
            end;
            if Rec.Department <> recHRRoleHist.Department then begin
                recHRRoleHist.Department := Rec.Department;
                RecordIsChanged := true;
            end;

            if RecordIsChanged then begin
                recHRRoleHist.Changed := true;
                recHRRoleHist.Modify();

                EmailAddMgt.CreateEmailWithBodytext('COSTTYPE', StrSubstNo(lText002, recZyEmp."No.", recHRRoleHist.FieldCaption("Start Date"), recHRRoleHist."Start Date"), '');
                EmailAddMgt.Send;
            end;
        end;

    end;

    local procedure NewCostType()
    var
        SI: Codeunit "Single Instance";
        EmailAddMgt: Codeunit "E-mail Address Management";
    begin
        if NewCostTypeCreated then begin
            SI.SetMergefield(100, Rec.Code);
            SI.SetMergefield(101, Rec.Name);
            SI.SetMergefield(102, Rec."Concur Id");
            SI.SetMergefield(103, Rec."Concur Company Name");
            SI.SetMergefield(104, Rec.Division);
            SI.SetMergefield(105, Rec.Department);
            EmailAddMgt.CreateSimpleEmail('COSTTYPENW', '', '');
            EmailAddMgt.Send;
        end;
    end;

    local procedure ChangedCostType()
    var
        SI: Codeunit "Single Instance";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: Label '%1 has been changed from "%2" to "%3".';
        lText002: Label '%1 has not been changed.';
    begin
        //>> 01-10-20 ZY-LD 004
        if ConcurDataModified then begin
            SI.SetMergefield(100, Rec.Name);
            SI.SetMergefield(104, Rec."Concur Id");
            if (Rec.Division <> xRecDivision) and (xRecDivision <> '') then
                SI.SetMergefield(101, StrSubstNo(lText001, Rec.FieldCaption(Rec.Division), xRecDivision, Rec.Division))
            else
                SI.SetMergefield(101, StrSubstNo(lText002, Rec.FieldCaption(Rec.Division)));
            if (Rec.Department <> xRecDepartment) and (xRecDepartment <> '') then
                SI.SetMergefield(102, StrSubstNo(lText001, Rec.FieldCaption(Rec.Department), xRecDepartment, Rec.Department))
            else
                SI.SetMergefield(102, StrSubstNo(lText002, Rec.FieldCaption(Rec.Department)));
            if (Rec."Concur Company Name" <> xRecCompanyName) and (xRecCompanyName <> '') then
                SI.SetMergefield(103, StrSubstNo(lText001, Rec.FieldCaption(Rec."Concur Company Name"), xRecCompanyName, Rec."Concur Company Name"))
            else
                SI.SetMergefield(103, StrSubstNo(lText002, Rec.FieldCaption(Rec."Concur Company Name")));
            EmailAddMgt.CreateSimpleEmail('COSTTYPECN', '', '');
            EmailAddMgt.Send;
        end;
        //<< 01-10-20 ZY-LD 004
    end;

    local procedure SetActions()
    begin
        ConcurIdVisible := ZGT.UserIsAccManager('DK');
        CurrPage.Editable(ZGT.IsRhq and ZGT.IsZComCompany);  // 03-08-21 ZT-LD 005
    end;
}
