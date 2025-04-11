page 50115 "Margin Approval FacxBox"
{
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
                field("User Name"; Rec."User Name") { }
                field(Status; Rec.Status) { }
                field("Status Date"; Rec."Status Date") { }
                field("Approved/Rejected by"; Rec."Approved/Rejected by")
                {
                    Visible = BelowMarginVisible;
                }
                field("Below Margin"; Rec."Below Margin") { }
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
