page 50115 "Margin Approval FacxBox"
{
    //30-10-2025 BK #MarginApproval
    ApplicationArea = Basic, Suite;
    Caption = 'Margin Approval';
    PageType = CardPart;
    SourceTable = "Margin Approval";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = false;
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the name of the user who initiated the margin approval request.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies status of the approval flow. Status can assume following values: "Waiting for Margin Approval","Waiting for User Comment","Waiting for Approval",Approved,Rejected';
                }
                field("Status Date"; Rec."Status Date")
                {
                    ToolTip = 'Specifies the date when the status of the margin approval request was last updated.';
                }
                field("Approved/Rejected by"; Rec."Approved/Rejected by")
                {
                    Visible = BelowMarginVisible;
                }
                field("Below Margin"; Rec."Below Margin")
                {
                    ToolTip = 'Indicates whether the requested margin is below the predefined threshold.';
                }
            }
        }
    }
    var
        BelowMarginVisible: Boolean;

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    procedure SetActions()
    begin
        BelowMarginVisible := BelowMarginVisible;
    end;
}
