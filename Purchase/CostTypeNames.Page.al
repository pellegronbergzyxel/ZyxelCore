Page 50193 "Cost Type Names"
{
    // 001. 22-05-18 ZY-LD 2018050910000191 - Page visibility.
    // 002. 05-06-18 ZY-LD 2018060410000242 - New field.
    // 003. 01-05-20 ZY-LD P0417 - Run only in RHQ.
    // 004. 07-08-20 ZY-LD 2020073110000042 - Page Action Dimension Value is added.
    // 005. 22-08-22 ZY-LD 2022080810000063 - Setup split entry for cost type name.
    // 006. 02-02-23 ZY-LD #8882881 - UK accounting manager must also create.

    ApplicationArea = Basic, Suite;
    Caption = 'Cost Type Name List';
    CardPageID = "Cost Type Name Card";
    PageType = List;
    SourceTable = "Cost Type Name";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                //Visible = PageVisible;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Control6; Rec.Division)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Manager; Rec.Manager)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(VP; Rec.VP)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Primary Approver"; Rec."Concur Primary Approver")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("HQ Expense Category"; Rec."HQ Expense Category")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Leaving Date"; Rec."Leaving Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control13; "Zyxel Employee Details")
            {
                SubPageLink = "Cost Type" = field(Code);
            }
            systempart(Control12; Links)
            {
            }
            systempart(Control14; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Dimension Value")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Dimension Value';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    recGenSetup.Get;
                    recDimValue.SetRange("Dimension Code", recGenSetup."Shortcut Dimension 4 Code");
                    recDimValue.SetRange(Code, Rec.Code);
                    Page.RunModal(Page::"Dimension Value", recDimValue);
                end;
            }
            group(Split)
            {
                Caption = 'Split';
                action(Division)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Split - Division';
                    Enabled = CompanyEnable;
                    Image = Splitlines;
                    RunObject = Page "Dimension Split Pct.";
                    RunPageLink = "Source Type" = const(Division),
                                  "Dimension Code" = field(Division);
                }
                action("Cost Type Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Split - Cost Type Name';
                    Enabled = CompanyEnable;
                    Image = Splitlines;
                    RunObject = Page "Dimension Split Pct.";
                    RunPageLink = "Source Type" = const("Cost Type Name"),
                                  "Dimension Code" = field(Code);
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(62018));
                }
            }
        }
        area(processing)
        {
            action("Update Manager and Vice Precident")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Manager and Vice Precident';
                Enabled = CompanyEnable;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.UpdateManagerAndVP;  // 07-06-18 ZY-LD 002
                end;
            }
            action("Update Division and Department")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Division and Department';
                Enabled = CompanyEnable;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.UpdateDivisionAndDepart;  // 07-06-18 ZY-LD 002
                end;
            }
            action("Replicate Cost Type Names to Subs")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Replicate Cost Type Names to Subs';
                Enabled = CompanyEnable;
                Image = Copy;

                trigger OnAction()
                begin
                    //>> 14-08-18 ZY-LD 002
                    if Confirm(Text001) then begin
                        ZyWebSrvMgt.ReplicateCostTypeName('', '');
                        Message(Text002);
                    end;
                    //<< 14-08-18 ZY-LD 002
                end;
            }
            action("Create Concur ID")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Concur ID';
                Image = CreateSerialNo;
                Visible = ConcurIdVisible;

                trigger OnAction()
                begin
                    if Rec."Concur Id" = '' then begin
                        Rec."Concur Id" := Rec.GetConcurId;
                        Rec.Modify;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        recGenSetup: Record "General Ledger Setup";
        recDimValue: Record "Dimension Value";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        CompanyEnable: Boolean;
        ConcurIdVisible: Boolean;
        Text001: label 'Do you want to replicate "Cost Type Names" to subs?';
        Text002: label '"Cost Type Names" is replicated to subs.';

    local procedure SetActions()
    var
        CostTypeName: Record "Cost Type Name";
        UserSetup: Record "User Setup";
    begin
        /*PageVisible :=
          ZGT.UserIsAccManager('DK') or ZGT.UserIsHr or  // 22-05-18 ZY-LD 001
          ZGT.UserIsAccManager('UK');  // 02-02-23 ZY-LD 006*/
        CompanyEnable := ZGT.IsRhq and not ZGT.IsZNetCompany;  // 01-05-20 ZY-LD 003
        //ConcurIdVisible := ZGT.UserIsAccManager('DK');
        if not UserSetup.get(UserId) then
            Clear(UserSetup);
        ConcurIdVisible := CostTypeName.WritePermission and UserSetup."Show Concur ID";
    end;
}
