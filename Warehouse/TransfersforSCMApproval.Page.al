Page 62030 "Transfers for SCM Approval"
{
    // ZY2.0 BS 12.06.2012 Created form for SCM approvals

    Caption = 'Transfers waiting for SCM Approval';
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Header";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Order")
            {
                Caption = '&Order';
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Transfer Order";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //CLEARMARKS;
        Clear(TempTransHeader);
        TempTransHeader.DeleteAll;
        Transferline.Reset;
        //Transferline.SETRANGE(Transferline."Document No.","No.");
        Transferline.SetRange(Transferline."Shipment Date Confirmed", false);
        repeat
            if TransferHeader.Get(Transferline."Document No.") then begin
                Rec.Init;
                Rec.TransferFields(TransferHeader);
                if Rec.Insert then;
            end;
        until Transferline.Next() = 0;
    end;

    var
        Transferline: Record "Transfer Line";
        TempTransHeader: Record "Transfer Header" temporary;
        TransferHeader: Record "Transfer Header";
}
