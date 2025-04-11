Page 50064 "Posted Travel Expense List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Travel Expense List';
    CardPageID = "Travel Expense";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Travel Expense Header";
    SourceTableView = order(descending)
                      where("Document Status" = filter(>= Posted));
    UsageCategory = History;
    AdditionalSearchTerms = 'concur';

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Report Name"; Rec."Concur Report Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Batch ID"; Rec."Concur Batch ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Report ID"; Rec."Concur Report ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
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
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    recTrExpHead.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Travel Expense Document", true, false, recTrExpHead);
                    recTrExpHead.SetRange("No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error(Text002);
    end;

    trigger OnOpenPage()
    begin
        SetActions;
        if not Rec.FindFirst then;
    end;

    var
        recTrExpHead: Record "Travel Expense Header";
        ImportConcurTravelExpense: Report "Import Concur Travel Expense";
        TravelExpPost: Codeunit "TravelExpense-Post";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        Text001: label 'Do you want to transfer %1 to %2?';
        ZGT: Codeunit "ZyXEL General Tools";
        TransferEnabled: Boolean;
        PostingEnabled: Boolean;
        Navigate: Page Navigate;
        Text002: label 'You are not allowed to delete the document.';

    local procedure SetActions()
    begin
        TransferEnabled := ZGT.IsRhq and (Rec."Concur Company Name" <> CompanyName());
        PostingEnabled := Rec."Concur Company Name" = CompanyName();
    end;
}
