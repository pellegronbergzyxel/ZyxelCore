namespace ZyxelCore.ZyxelCore;

page 50036 "Marginal Approval Activities"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Marginal Approval Activities';
    PageType = CardPart;
    RefreshOnActivate = true;


    layout
    {
        area(content)
        {
            cuegroup(Approvals)
            {
                //
                ShowCaption = false;
                field(AwaitingComments; AwaitingCom(false))
                {
                    ApplicationArea = Basic, Suite;
                    Image = Calendar;
                    Caption = 'Awaiting Comments';
                    trigger OnDrillDown()
                    begin
                        AwaitingCom(true);
                    end;

                }



                field(rejectedprices; Rejectedprice(false))
                {
                    Caption = 'Rejected price margin';
                    ApplicationArea = Basic, Suite;
                    Image = Calendar;
                    //Style = Favorable;
                    trigger OnDrillDown()
                    begin
                        Rejectedprice(true);
                    end;

                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MarginalApprovals)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'All Marginal Approvals';
                Image = Log;

                trigger OnAction()
                var
                    MarginalApproval: record "Margin Approval";
                    MarginalApprovalPage: Page "Margin Approvals";

                begin

                    MarginalApprovalPage.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;

    procedure AwaitingCom(Show: Boolean): Integer
    var
        MarginalApproval: record "Margin Approval";
        MarginalApprovalPage: Page "Margin Approvals";

    begin
        MarginalApproval.setfilter(status, '%1..', MarginalApproval.Status::"Waiting for Approval");
        MarginalApproval.setrange(requeststatus, MarginalApproval.requeststatus::SendPrice);
        MarginalApproval.setfilter("User Comment", '<>%1', '');
        if not Show then
            exit(MarginalApproval.count);
        MarginalApprovalPage.SetTableView(MarginalApproval);
        MarginalApprovalPage.Run();
    end;

    procedure Rejectedprice(Show: Boolean): Integer
    var
        MarginalApproval: record "Margin Approval";
        MarginalApprovalPage: Page "Margin Approvals";

    begin
        MarginalApproval.setrange(status, MarginalApproval.Status::Rejected);
        MarginalApproval.setrange(requeststatus, MarginalApproval.requeststatus::RejectedPrice);
        MarginalApproval.setfilter("User Comment", '<>%1', '');
        if not Show then
            exit(MarginalApproval.count);
        MarginalApprovalPage.SetTableView(MarginalApproval);
        MarginalApprovalPage.Run();
    end;

    var
}

