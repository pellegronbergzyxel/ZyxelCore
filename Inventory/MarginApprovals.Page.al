page 50118 "Margin Approvals"
{
    //30-10-2025 BK #MarginApproval  
    ApplicationArea = Basic, Suite;
    Caption = 'Margin Approvals';
    PageType = List;
    SourceTable = "Margin Approval";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = true;
    Editable = true;
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
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the type of sales document for which the margin approval is requested (e.g., Quote, Order, Invoice).';
                    Editable = false;
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ToolTip = 'Specifies the specific type of sales document (e.g., Quote, Order, Invoice) associated with the margin approval request.';
                    Editable = false;
                }

                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the number of the sales document for which the margin approval is requested.';
                    Editable = false;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ToolTip = 'Specifies the line number within the sales document for which the margin approval is requested.';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies status of the approval flow. Status can assume following values: "Waiting for Margin Approval","Waiting for User Comment","Waiting for Approval",Approved,Rejected';
                    Editable = false;
                }
                field("Status Date"; Rec."Status Date")
                {
                    ToolTip = 'Specifies the date when the status of the margin approval request was last updated.';
                    Editable = false;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the name of the user who initiated the margin approval request.';
                    Editable = false;
                }
                field("Approved/Rejected by"; Rec."Approved/Rejected by")
                {
                    ToolTip = 'Specifies the name of the user who approved or rejected the margin approval request.';
                    Editable = false;
                }
                field("Below Margin"; Rec."Below Margin")
                {
                    ToolTip = 'Indicates whether the requested margin is below the predefined threshold.';
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Editable = false;
                    ToolTip = 'Specifies the unit price requested in the margin approval.';
                }
                field("Original Unit Price"; Rec."Original Unit Price")
                {
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the original unit price before any margin adjustments.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                    Visible = true;
                    ToolTip = 'Specifies the customer number associated with the margin approval request.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = true;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the name of the customer associated with the margin approval request.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Visible = true;
                    Editable = false;
                    ToolTip = 'Specifies the item number associated with the margin approval request.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
                }
                field(is_low_margin; Rec.is_low_margin)
                {
                    Visible = true;
                    Editable = false;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
                }
                field("User Comment"; Rec."User Comment")
                {
                    Visible = true;
                    Editable = true;
                }
                field("Approver Comment"; Rec."Approver Comment")
                {
                    Visible = true;
                    Editable = false;
                }
                field(requeststatus; Rec.requeststatus)
                {
                    Visible = true;
                    Editable = false;
                    ToolTip = 'Specifies the description of the item associated with the margin approval request.';
                }
                field(requeststatusDT; Rec.requeststatusDT)
                {
                    Visible = true;
                    Editable = false;
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
                    Helper.ProcessMarginApproval(rec, false);
                end;
            }
            action(testAllmargincheck)
            {
                Caption = 'Run ALL margin check API';
                Image = UpdateDescription;


                trigger OnAction()
                var
                    Helper: codeunit AmazonHelper;

                begin
                    Helper.ProcessMarginApproval(rec, true);
                end;
            }
            action(testPricecheck)
            {
                Caption = 'Run Price approval API';
                Image = UpdateDescription;


                trigger OnAction()
                var
                    Helper: codeunit AmazonHelper;

                begin
                    if rec."Source Type" = rec."Source Type"::"Price Book" then
                        Helper.ProcessPriceApproval(rec, false);
                end;
            }
            action(testAllPricecheck)
            {
                Caption = 'Run All Price approval API';
                Image = UpdateDescription;


                trigger OnAction()
                var
                    Helper: codeunit AmazonHelper;

                begin
                    if rec."Source Type" = rec."Source Type"::"Price Book" then
                        Helper.ProcessPriceApproval(rec, true);
                end;
            }
            action(testSalesordercheck)
            {
                Caption = 'Run Salesorder approval API';
                Image = UpdateDescription;


                trigger OnAction()
                var
                    Helper: codeunit AmazonHelper;

                begin
                    if rec."Source Type" = rec."Source Type"::Sales then
                        Helper.ProcessOrderApproval(rec);
                end;
            }
            action(ReturnpriceApprovaltoPricelist)
            {
                Caption = 'Confirm approval in price list';
                Image = Apply;
                ApplicationArea = all;

                trigger OnAction()
                var


                begin
                    rec.Setapprovedpricebookline(rec);
                end;
            }
            action(force)
            {
                Caption = 'Force approval';
                Image = Approval;
                ApplicationArea = all;

                trigger OnAction()
                var


                begin
                    rec.Setapprovedpricebookline(rec);
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
