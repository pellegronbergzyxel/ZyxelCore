page 50118 "Margin Approvals"
{
    //30-10-2025 BK #MarginApproval  
    ApplicationArea = Basic, Suite;
    Caption = 'Margin Approvals';
    PageType = List;
    SourceTable = "Margin Approval";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("Entry No.") order(descending);
    //Editable = false;  // Must be active in production.

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number of the margin approval request.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the type of sales document for which the margin approval is requested (e.g., Quote, Order, Invoice).';
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ToolTip = 'Specifies the specific type of sales document (e.g., Quote, Order, Invoice) associated with the margin approval request.';
                }

                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the number of the sales document for which the margin approval is requested.';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ToolTip = 'Specifies the line number within the sales document for which the margin approval is requested.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies status of the approval flow. Status can assume following values: "Waiting for Margin Approval","Waiting for User Comment","Waiting for Approval",Approved,Rejected';
                }
                field("Status Date"; Rec."Status Date")
                {
                    ToolTip = 'Specifies the date when the status of the margin approval request was last updated.';
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the name of the user who initiated the margin approval request.';
                }
                field("Approved/Rejected by"; Rec."Approved/Rejected by")
                {
                    ToolTip = 'Specifies the name of the user who approved or rejected the margin approval request.';
                }
                field("Below Margin"; Rec."Below Margin")
                {
                    ToolTip = 'Indicates whether the requested margin is below the predefined threshold.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the unit price requested in the margin approval.';
                }
                field("Original Unit Price"; Rec."Original Unit Price")
                {
                    Visible = false;
                    ToolTip = 'Specifies the original unit price before any margin adjustments.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Visible = true;
                    ToolTip = 'Specifies the customer number associated with the margin approval request.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = true;

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Visible = false;
                    ToolTip = 'Specifies the name of the customer associated with the margin approval request.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Visible = true;
                    ToolTip = 'Specifies the item number associated with the margin approval request.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    Visible = false;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
                }
                field(is_low_margin; Rec.is_low_margin)
                {
                    Visible = true;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
                }
                field(requeststatus; Rec.requeststatus)
                {
                    Visible = true;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
                }
                field(requeststatusDT; Rec.requeststatusDT)
                {
                    Visible = true;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
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
        area(Navigation)
        {
            action(pricebook)
            {
                Caption = 'Card price book';

                Image = Card;
                Promoted = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    pricebook: page "Sales Price List";
                    salesprice: record "Price List Header";
                begin
                    if rec."Source Type" = rec."Source Type"::"Price Book" then begin
                        salesprice.setrange(Code, rec."Source No.");
                        salesprice.setrange("Price Type", salesprice."Price Type"::Sale);
                        pricebook.SetTableView(salesprice);
                        pricebook.Run();
                    end;

                end;
            }
        }


        area(Processing)
        {
            action(EnterUserComment)
            {
                Caption = 'Enter User Comment';
                ToolTip = 'Allows the user to enter a comment regarding the margin approval request.';
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
                ToolTip = 'Updates existing margin approval requests based on the current setup.';

                trigger OnAction()
                begin
                    Rec.UpdateOnSetup();
                end;
            }
            action(testmargincheck)
            {
                Caption = 'Run margin check API';
                Image = UpdateDescription;


                trigger OnAction()
                var
                    Helper: codeunit AmazonHelper;

                begin
                    Helper.ProcessMarginApproval(rec);
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
