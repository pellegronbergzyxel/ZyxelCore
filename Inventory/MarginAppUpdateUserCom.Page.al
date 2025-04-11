page 50140 "Margin App. Update User Com."
{
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
                    field(ApproverComment; ApproverComment)
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
                    field(UserComment; UserComment)
                    {
                        ShowCaption = false;
                        MultiLine = true;
                        ToolTip = 'Specifies the value of the User Comment field.', Comment = '%';
                        trigger OnValidate()
                        begin
                            Rec.SetComment(0, UserComment);
                        end;
                    }
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        UserComment := Rec.GetComment(0);
        ApproverComment := rec.GetComment(1);
    end;

    var
        UserComment: Text;
        ApproverComment: Text;

    procedure GetUserComment()
    begin
        Message(UserComment);
    end;
}
