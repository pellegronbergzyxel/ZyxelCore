Page 50356 "Travel Expense"
{
    Caption = 'Travel Expense';
    SourceTable = "Travel Expense Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field("Concur Report ID"; Rec."Concur Report ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Batch ID"; Rec."Concur Batch ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Report Name"; Rec."Concur Report Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control13)
                {
                    field("Cost Type Name"; Rec."Cost Type Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Employee Name"; Rec."Employee Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Concur Company Name"; Rec."Concur Company Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Country Code"; Rec."Country Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Control6; "Travel Expense Subform")
            {
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(factboxes)
        {
            part(Control26; "Travel Exp. Milage FactBox")
            {
                Caption = 'Milage Details';
                Provider = Control6;
                SubPageLink = "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        area(navigation)
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
                                  where("Table No." = const(50118));
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."G/L Posting Date", Rec."G/L Document No.");
                    Navigate.Run;
                end;
            }
            group(Release)
            {
                Caption = 'Release';
                action(Action24)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Release';

                    trigger OnAction()
                    begin
                        Rec."Document Status" := Rec."document status"::Released;
                        Rec.Modify(true);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reopen';

                    trigger OnAction()
                    begin
                        Rec."Document Status" := Rec."document status"::Open;
                        Rec.Modify(true);
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                action("Create General Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create General Journal';
                    Enabled = PostingEnabled;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        TravelExpPost.Run(Rec);
                    end;
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                action(Action28)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer';
                    Image = TransferOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        recTrExpHead.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Batch Transfer Travel Exp.", true, false, recTrExpHead);
                    end;
                }
                action("Set to Transferred")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set to Transferred';
                    Image = ChangeStatus;
                    Visible = SetToTransferredVisible;

                    trigger OnAction()
                    begin
                        Rec.SetToTransferred;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        recTrExpHead: Record "Travel Expense Header";
        ImportConcurTravelExpense: Report "Import Concur Travel Expense";
        BatchTransferTravelExp: Report "Batch Transfer Travel Exp.";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        TravelExpPost: Codeunit "TravelExpense-Post";
        ZGT: Codeunit "ZyXEL General Tools";
        TransferEnabled: Boolean;
        PostingEnabled: Boolean;
        Text001: label 'Do you want to transfer %1 to %2?';
        SetToTransferredVisible: Boolean;
        Navigate: Page Navigate;

    local procedure SetActions()
    begin
        TransferEnabled := ZGT.IsRhq and (Rec."Concur Company Name" <> CompanyName());
        PostingEnabled := Rec."Concur Company Name" = CompanyName();
        SetToTransferredVisible := ZGT.IsRhq and ZGT.IsZComCompany;
    end;
}
