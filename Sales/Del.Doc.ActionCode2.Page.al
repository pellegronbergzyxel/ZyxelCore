Page 50348 "Del. Doc. Action Code 2"
{
    // 001. 12-01-18 ZY-LD 2018011210000094 - New field.
    // 002. 13-03-10 ZY-LD 000 - New field.

    Caption = 'Del. Doc. Action Code 2';
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Delivery Document Action Code";

    layout
    {
        area(content)
        {
            repeater(Control1161059011)
            {
                field("Action Code"; Rec."Action Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Rec.Insert(true);
                    end;
                }
                field("Action Description"; Rec."Action Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(CommentTypeHeader; CommentTypeHeader)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comment Type';
                    Visible = CommentTypeHeaderVisible;

                    trigger OnValidate()
                    begin
                        Rec.Validate(Rec."Comment Type", CommentTypeHeader);
                    end;
                }
                field(CommentTypeLine; CommentTypeLine)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comment Type';
                    Visible = CommentTypeLineVisible;

                    trigger OnValidate()
                    begin
                        Rec.Validate(Rec."Comment Type", CommentTypeLine);
                    end;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Rec.Modify(true);
                    end;
                }
                field("Insert Blank After This Line"; Rec."Insert Blank After This Line")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetActions;
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec."Header / Line" of
            Rec."header / line"::Header:
                CommentTypeHeader := Rec."Comment Type";
            Rec."header / line"::Line:
                CommentTypeLine := Rec."Comment Type";
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Header / Line" = Rec."header / line"::Line then begin
            Rec."Comment Type" := Rec."comment type"::Packing;
            CommentTypeLine := Rec."Comment Type";
        end;
        Rec.Sequence := xRec.Sequence + 5;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        DelDocNo: Code[20];
        HeadLine: Option Header,Line;
        CommentTypeHeader: Option General,Picking,Packing,Transport,Export,Customer,,,"E-mail Notification (Pre-Adv)",,,,"E-mail Slot-Request";
        CommentTypeLine: Option ,Picking,Packing,Transport,,Customer;
        CommentTypeHeaderVisible: Boolean;
        CommentTypeLineVisible: Boolean;
        EmailAtWaitingforInoviceVisible: Boolean;


    procedure InitPage(pDelDocNo: Code[20]; pHeadLine: Integer)
    begin
        DelDocNo := pDelDocNo;
        HeadLine := pHeadLine;

        CommentTypeHeaderVisible := HeadLine = Headline::Header;
        CommentTypeLineVisible := HeadLine = Headline::Line;
        EmailAtWaitingforInoviceVisible := HeadLine = Headline::Header;
    end;

    local procedure SetActions()
    begin
    end;
}
