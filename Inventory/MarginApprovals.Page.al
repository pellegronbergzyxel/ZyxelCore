page 50118 "Margin Approvals"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Margin Approvals';
    PageType = List;
    SourceTable = "Margin Approval";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    //Editable = false;  // Must be active in production.

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Source Type"; Rec."Source Type") { }
                field("Sales Document Type"; Rec."Sales Document Type") { }
                field("Source No."; Rec."Source No.") { }
                field("Source Line No."; Rec."Source Line No.") { }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies status of the approval flow. Status can assume following values: "Waiting for Margin Approval","Waiting for User Comment","Waiting for Approval",Approved,Rejected';
                }
                field("Status Date"; Rec."Status Date") { }
                field("User Name"; Rec."User Name") { }
                field("Approved/Rejected by"; Rec."Approved/Rejected by") { }
                field("Below Margin"; Rec."Below Margin") { }
                field("Unit Price"; Rec."Unit Price") { }
                field("Original Unit Price"; Rec."Original Unit Price")
                {
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Visible = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(Comment; "Margin Approval FactBox")
            {
                Caption = 'Comments';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(EnterUserComment)
            {
                Caption = 'Enter User Comment';
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = EnterUserCommentEnabled;
                trigger OnAction()
                begin
                    Rec.EnterUserComment();
                end;
            }
            action(Update)
            {
                Caption = 'Update Existing';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.UpdateOnSetup();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    var
        EnterUserCommentEnabled: Boolean;

    procedure SetActions()
    begin
        EnterUserCommentEnabled := Rec.UserCommentEnabled();
    end;
}
