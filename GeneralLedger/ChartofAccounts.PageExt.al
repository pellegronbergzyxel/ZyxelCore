pageextension 50109 ChartOfAccountsZX extends "Chart of Accounts"
{
    layout
    {
        modify("No. 2")
        {
            Caption = 'HQ G/L Account No.';
        }
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'HQ G/L Account Name';
            }
        }
    }

    actions
    {
        addafter("Where-Used List")
        {
            action(Action29)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VCK Ship. Detail Received';
                Image = MapAccounts;
                RunObject = Page "VCK Ship. Detail Received";
                RunPageLink = "Container No." = field("No.");
            }
        }
        addafter("G/L Register")
        {
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
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(15));
                }
            }
        }
        addafter(IndentChartOfAccounts)
        {
            action("Replicate Chart of Account to Subs")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Replicate Chart of Account to Subs';
                Image = Copy;

                trigger OnAction()
                begin
                    //>> 14-08-18 ZY-LD 002
                    if Confirm(Text001) then begin
                        ZyWebSrvMgt.ReplicateGlAccounts('', '');
                        Message(Text002);
                    end;
                    //<< 14-08-18 ZY-LD 002
                end;
            }
        }
    }

    var
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        Text001: Label 'Do you want to replicate "Chart of Account" to subs?';
        Text002: Label '"Chart of Account" is replicated to subs.';
}
