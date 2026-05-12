page 50140 "Margin App. Update User Com."
{
    //30-10-2025 BK #MarginApproval
    ApplicationArea = Basic, Suite;
    Caption = 'Margin App. Update User Comment';
    ShowFilter = false;
    PageType = Card;
    SourceTable = "Margin Approval";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Enter a user comment to the approver to get the price approved.';
                group(Approver)
                {
                    Caption = 'Approver Comment';
                    field(ApproverComment; rec."Approver Comment")
                    {
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Specifies the value of the Approver Comment field.', Comment = '%';
                        Editable = false;
                    }
                }
                group(User)
                {
                    Caption = 'User Comment';
                    field(UserComment; rec."User Comment")
                    {
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Specifies the value of the User Comment field.', Comment = '%';
                        
                    }
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        
    end;

    var
        
}
