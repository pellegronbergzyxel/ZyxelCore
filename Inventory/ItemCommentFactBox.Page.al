page 50097 "Item Comment FactBox"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Item Comment';
    PageType = ListPart;
    SourceTable = "Comment Line";
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Date; Rec.Date)
                { }
                field(Comment; Rec.Comment)
                { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Edit)
            {
                Caption = 'Edit';
                Image = Edit;
                RunObject = Page "Comment Sheet";
                RunPageView = where("Table Name" = const(Item));
                RunPageLink = "No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        InsertCommentLine;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InsertCommentLine;
    end;

    local procedure InsertCommentLine()
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
        CommentLine.SetRange("No.", Rec."No.");
        if not CommentLine.FindFirst() then begin
            CommentLine.Init();
            CommentLine.Validate("Table Name", CommentLine."Table Name"::Item);
            CommentLine.Validate("No.", Rec."No.");
            CommentLine.Validate("Line No.", 10000);
            CommentLine.Validate(Date, WorkDate);
            CommentLine.Insert(true);
        end else
            if (CommentLine.FindFirst()) and
               (CommentLine.Count = 1) and
               (CommentLine.Comment = '') and
               (CommentLine."Line No." = 10000) and
               (CommentLine.Date <> WorkDate)
            then begin
                CommentLine.Validate(Date, WorkDate);
                CommentLine.Modify(true);
            end;
    end;
}
