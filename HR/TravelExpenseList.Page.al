Page 50358 "Travel Expense List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Travel Expense List';
    CardPageID = "Travel Expense";
    Editable = false;
    PageType = List;
    SourceTable = "Travel Expense Header";
    SourceTableView = where("Document Status" = filter(< Posted));
    UsageCategory = Lists;
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
            action("Replication Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Replication Setup';
                Image = Setup;

                trigger OnAction()
                begin
                    pageReplicationSetup.InitPage(3);
                    pageReplicationSetup.RunModal;
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
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(50118));
                }
            }
        }
        area(processing)
        {
            action("Import Directory")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Directory';
                Image = Travel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ImportDirectory;
                end;
            }
            action("Import Travel Expense")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Travel Expense';
                Image = ImportExcel;

                trigger OnAction()
                begin
                    Clear(ImportConcurTravelExpense);
                    ImportConcurTravelExpense.RunModal;
                    CurrPage.Update;
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
            group(Release)
            {
                Caption = 'Release';
                action(Action23)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Release';
                    Visible = false;

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
                    Visible = false;

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
                action("Post Batch")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Batch';
                    Enabled = PostingEnabled;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Batch Post Travel Expense";
                    Visible = false;
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                action(Action29)
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
                action("Transfer Batch")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Batch';
                    Image = TransferOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Batch Transfer Travel Exp.";
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
        TravelExpPost: Codeunit "TravelExpense-Post";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";
        TransferEnabled: Boolean;
        PostingEnabled: Boolean;
        SetToTransferredVisible: Boolean;
        pageReplicationSetup: Page "Replication Setup";

    local procedure SetActions()
    begin
        TransferEnabled := ZGT.IsRhq and (UpperCase(Rec."Concur Company Name") <> UpperCase(CompanyName()));
        PostingEnabled := UpperCase(Rec."Concur Company Name") = UpperCase(CompanyName);
        SetToTransferredVisible := ZGT.IsRhq and ZGT.IsZComCompany;
    end;

    local procedure ImportDirectory()
    var
        lTest001: label 'Do you want to import directory?';
        recConcurSetup: Record "Concur Setup";
        ProcessConcur: Codeunit "Process Concur";
    begin
        if Confirm(lTest001, true) then begin
            recConcurSetup.Get;
            ProcessConcur.ImportFile(1, recConcurSetup."Import Folder - Travel Expense");
        end;
    end;
}
