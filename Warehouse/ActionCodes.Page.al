Page 50145 "Action Codes"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Action Codes';
    PageType = List;
    SourceTable = "Action Codes";
    SourceTableView = sorting("Default Comment Type", Description)
                      where(Blocked = const(false));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1161059011)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Default Comment Type"; Rec."Default Comment Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Used on Def. Action Code Head"; Rec."Used on Def. Action Code Head")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Used on Def. Action Code Line"; Rec."Used on Def. Action Code Line")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Used on Del. Doc. Action Code"; Rec."Used on Del. Doc. Action Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Original Description"; Rec."Original Description")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Where Used")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Where Used';
                Image = "Where-Used";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Action Codes - Where Used";
                RunPageLink = "Action Code" = field(Code);
            }
            action("Update Description")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Description';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+u';

                trigger OnAction()
                begin
                    recActionCode.SetRange(Code, Rec.Code);
                    Report.RunModal(Report::"Update Action Code (One off)", false, false, recActionCode);
                end;
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
                                  where("Table No." = const(66005));
                }
            }
        }
        area(processing)
        {
            action("Copy Action Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy Action Code';
                Image = CopyFromTask;

                trigger OnAction()
                begin
                    CopyActionCode;
                end;
            }
        }
    }

    var
        recActionCode: Record "Action Codes";

    local procedure CopyActionCode()
    var
        recActCode: Record "Action Codes";
        recDefAction: Record "Default Action";
        recDefAction2: Record "Default Action";
        recDelDocActCode: Record "Delivery Document Action Code";
        lText001: label 'Do you want to copy Action Code %1?';
        recDelDocActCode2: Record "Delivery Document Action Code";
    begin
        if Confirm(lText001, true, Rec.Code) then begin
            recActCode.Insert(true);
            recActCode.Init;
            recActCode.Validate(Description, Rec.Description);
            recActCode.Validate("Sales Order Type", Rec."Sales Order Type");
            recActCode.Validate(Blocked, Rec.Blocked);
            recActCode.Validate("Default Comment Type", Rec."Default Comment Type");
            recActCode.Validate("End Date", Rec."End Date");
            recActCode.Modify(true);

            recDefAction.SetRange("Action Code", Rec.Code);
            if recDefAction.FindSet then
                repeat
                    recDefAction2 := recDefAction;
                    recDefAction2."Action Code" := recActCode.Code;
                    recDefAction2.Insert(true);
                until recDefAction.Next() = 0;

            recDelDocActCode.SetRange("Action Code", Rec.Code);
            if recDelDocActCode.FindSet then
                repeat
                    recDelDocActCode2 := recDelDocActCode;
                    recDelDocActCode2."Action Code" := recActCode.Code;
                    if not recDelDocActCode2.Insert(true) then;
                until recDelDocActCode.Next() = 0;

            CurrPage.Update;
        end;
    end;
}
