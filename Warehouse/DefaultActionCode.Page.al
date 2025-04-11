Page 50197 "Default Action Code"
{
    // 001. 12-01-18 ZY-LD 2018011210000094 - New field.
    // 002. 13-03-10 ZY-LD 000 - New field.

    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Default Action";

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
                        CurrPage.Update();
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
                        CurrPage.Update();
                    end;
                }
                field("Insert Blank After This Line"; Rec."Insert Blank After This Line")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Rec.Modify(true);
                        CurrPage.Update();
                    end;
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
        Rec."Source Type" := SourceType;
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
        SourceType: Option " ",Customer,"Ship-to Code",Item;
        SourceCode: Code[20];
        CustNo: Code[20];
        HeadLine: Option Header,Line;
        CommentTypeHeader: Option General,Picking,Packing,Transport,Export,Customer,,,"E-mail Notification (Pre-Adv)",,,,"E-mail Slot-Request";
        CommentTypeLine: Option ,Picking,Packing,Transport,,Customer;
        CommentTypeHeaderVisible: Boolean;
        CommentTypeLineVisible: Boolean;
        EmailAtWaitingforInoviceVisible: Boolean;


    procedure InitPage(pSourceType: Option " ",Customer,"Ship-to Code",Item; pSourceCode: Code[20]; pCustNo: Code[20]; pHeadLine: Integer)
    begin
        SourceType := pSourceType;
        SourceCode := pSourceCode;
        CustNo := pCustNo;
        HeadLine := pHeadLine;

        CommentTypeHeaderVisible := HeadLine = Headline::Header;
        //CommentTypeLineVisible := HeadLine = HeadLine::Line;
        CommentTypeLineVisible := false;  // Only possible comment type is Packing for lines.
        EmailAtWaitingforInoviceVisible := HeadLine = Headline::Header;
    end;

    local procedure SetActions()
    begin
    end;
}
