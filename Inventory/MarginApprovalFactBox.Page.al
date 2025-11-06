page 50134 "Margin Approval FactBox"
{
    //30-10-2025 BK #MarginApproval
    ApplicationArea = Basic, Suite;
    Caption = 'Margin Approval Comment FactBox';
    PageType = CardPart;
    SourceTable = "Margin Approval";
    Editable = true;

    layout
    {
        area(Content)
        {
            group(Comment)
            {
                ShowCaption = false;
                group(Approver)
                {
                    Caption = 'Approver';
                    field(ApproverComment; ApproverComment)
                    {
                        ApplicationArea = Basic, Suite;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the approver comment.';
                        Editable = false;
                    }
                }
                group(user)
                {
                    Caption = 'User';

                    field(UserComment; UserComment)
                    {
                        ApplicationArea = Basic, Suite;
                        MultiLine = true;
                        ShowCaption = false;
                        Editable = true;
                        ToolTip = 'Specifies the user comment.';

                        trigger OnValidate()
                        begin
                            Rec.SetComment(CommentType::User, UserComment);
                        end;
                    }
                }
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
                Enabled = EnterUserCommentEnabled;
                ToolTip = 'Allows the user to enter a comment regarding the margin approval request.';

                trigger OnAction()
                begin
                    Rec.EnterUserComment();
                end;
            }
        }
    }

    var
        CommentType: Option User,Approver;
        UserComment: Text;
        ApproverComment: Text;

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();

        // Read comments
        ApproverComment := Rec.GetComment(CommentType::Approver);
        UserComment := Rec.GetComment(CommentType::User);
    end;

    var
        EnterUserCommentEnabled: Boolean;

    procedure SetActions()
    begin
        EnterUserCommentEnabled := Rec.UserCommentEnabled();
    end;
}
