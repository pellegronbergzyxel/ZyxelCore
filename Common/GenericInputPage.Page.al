page 50218 "Generic Input Page"
{
    Caption = 'Generic Input Page';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(InputText; InputText)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputText30Visible;
            }
            field(InputInt; InputInt)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputIntVisible;
            }
            field(InputDec; InputDec)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputDecVisible;
            }
            field(InputCode20; InputCode20)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputCode20Visible;
            }
            field(InputCode20Lookup; InputCode20Lookup)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputCode20LookupVisible;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    case LookupType of
                        Lookuptype::Contact:
                            InputCode20Lookup := LookupContact;
                        Lookuptype::Item:
                            InputCode20Lookup := LookupItem;
                    end;
                end;

                trigger OnValidate()
                begin
                    InputCode20 := InputCode20Lookup;
                end;
            }
            field(InputDate; InputDate)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputDateVisible;
            }
            field(InputDateTime; InputDateTime)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputDateTimeVisible;
            }
            field(inputtime; InputTime)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputTimeVisible;
            }
            field(InputOptionCustBlock; InputOptionCustBlock)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputOptionCustBlockVisible;

                trigger OnValidate()
                begin
                    InputOption := InputOptionCustBlock;
                end;
            }
            field(InputOptionBacklogComment; InputOptionBacklogComment)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = '1,5,,' + CaptionText;
                Visible = InputOptionBacklogCommentVisible;

                trigger OnValidate()
                begin
                    InputOption := InputOptionBacklogComment;
                end;
            }
        }
    }

    var
        InputText: Text;
        InputInt: Integer;
        InputDec: Decimal;
        InputCode20: Code[100];
        InputCode20Lookup: Code[20];
        InputDate: Date;
        InputDateTime: DateTime;
        InputTime: Time;
        InputOption: Integer;
        CaptionText: Text[120];
        [InDataSet]
        InputText30Visible: Boolean;
        [InDataSet]
        InputIntVisible: Boolean;
        [InDataSet]
        InputDecVisible: Boolean;
        [InDataSet]
        InputCode20Visible: Boolean;
        InputCode20LookupVisible: Boolean;
        [InDataSet]
        InputDateVisible: Boolean;
        [InDataSet]
        InputDateTimeVisible: Boolean;
        InputTimeVisible: Boolean;
        InputOptionCustBlockVisible: Boolean;
        InputOptionBacklogCommentVisible: Boolean;
        LookupType: Option Contact,Item;
        InputOptionCustBlock: Option " ",Ship,Invoice,All;
        InputOptionBacklogComment: Option " ","Awaiting Prepayment","Credit Blocked","On Hold by Customer",Other;


    procedure GetText(): Text
    begin
        exit(InputText);
    end;


    procedure GetInt(): Integer
    begin
        exit(InputInt);
    end;


    procedure GetDec(): Decimal
    begin
        exit(InputDec);
    end;


    procedure GetCode20(): Code[100]
    begin
        exit(InputCode20);
    end;


    procedure GetCode20Lookup(): Code[20]
    begin
        exit(InputCode20Lookup);
    end;


    procedure GetDate(): Date
    begin
        exit(InputDate);
    end;


    procedure GetDateTime(): DateTime
    begin
        exit(InputDateTime);
    end;


    procedure GetTime(): Time
    begin
        exit(InputTime);
    end;


    procedure GetOption(): Integer
    begin
        exit(InputOption);
    end;


    procedure SetText(NewText: Text)
    begin
        InputText := NewText;
    end;


    procedure SetInt(NewInt: Integer)
    begin
        InputInt := NewInt;
    end;


    procedure SetDec(NewDec: Decimal)
    begin
        InputDec := NewDec;
    end;


    procedure SetCode20(NewCode20: Code[100])
    begin
        InputCode20 := NewCode20;
    end;


    procedure SetCode20Lookup(NewCode20: Code[20])
    begin
        InputCode20Lookup := NewCode20;
    end;


    procedure SetDate(NewDate: Date)
    begin
        InputDate := NewDate;
    end;


    procedure SetDateTime(NewDateTime: DateTime)
    begin
        InputDateTime := NewDateTime;
    end;


    procedure SetTime(NewTime: Time)
    begin
        InputTime := NewTime;
    end;


    procedure SetOption(NewOption: Option "0","1","2","3")
    begin
        InputOptionCustBlock := NewOption;
        InputOptionBacklogComment := NewOption;
    end;


    procedure SetPageCaption(NewCaptionTxt: Text)
    begin
        CurrPage.Caption := NewCaptionTxt;
    end;


    procedure SetFieldCaption(NewCaptionTxt: Text[120])
    begin
        CaptionText := NewCaptionTxt;
    end;


    procedure SetVisibleField(FieldType: Option Text,"Integer",Decimal,Code20,Date,DateTime,Code20Lookup,Time,OpCustBlock,OpBacklogComment)
    begin
        case FieldType of
            Fieldtype::Text:
                InputText30Visible := true;
            Fieldtype::Integer:
                InputIntVisible := true;
            Fieldtype::Decimal:
                InputDecVisible := true;
            Fieldtype::Code20:
                InputCode20Visible := true;
            Fieldtype::Code20Lookup:
                InputCode20LookupVisible := true;
            Fieldtype::Date:
                InputDateVisible := true;
            Fieldtype::DateTime:
                InputDateTimeVisible := true;
            Fieldtype::Time:
                InputTimeVisible := true;
            Fieldtype::OpCustBlock:
                InputOptionCustBlockVisible := true;
            Fieldtype::OpBacklogComment:
                InputOptionBacklogCommentVisible := true;
        end;
    end;


    procedure SetLookupType(pLookupType: Option Contact,Item)
    begin
        LookupType := pLookupType;
    end;

    local procedure LookupContact(): Code[20]
    var
        lCont: Record Contact;
    begin
        if Page.RunModal(Page::"Contact List", lCont) = Action::LookupOK then
            exit(lCont."No.");
    end;

    local procedure LookupItem(): Code[20]
    var
        lItem: Record Item;
    begin
        if Page.RunModal(Page::"Item List", lItem) = Action::LookupOK then
            exit(lItem."No.");
    end;
}
