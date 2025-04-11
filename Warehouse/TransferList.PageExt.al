pageextension 50250 TransferOrdersZX extends "Transfer Orders"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Ref./ PO"; Rec."Ref./ PO")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Receipt Date")
        {
            field("Completely Confirmed"; Rec."Completely Confirmed")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        modify("Reo&pen")
        {
            Visible = HasReopenPermision;
        }
        addafter("F&unctions")
        {
            group("Order")
            {
                Caption = 'Order';
                Image = Documents;
                action(Autoconfirm)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Auto Confirm';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PickDateConfMgt: Codeunit "Pick. Date Confirm Management";
                        SI: Codeunit "Single Instance";
                    begin
                        //>> 30-12-20 ZY-LD 003
                        SI.SetValidateFromPage(false);
                        PickDateConfMgt.PerformManuelConfirm(1, Rec."No.");
                        SI.SetValidateFromPage(true);
                        //<< 30-12-20 ZY-LD 003
                    end;
                }
                action("Create Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Delivery Document';
                    Image = TransferReceipt;

                    trigger OnAction()
                    var
                        DelDocMgt: Codeunit "Delivery Document Management";
                    begin
                        DelDocMgt.CreateDeliveryDocumentTransfer('');  // 30-12-20 ZY-LD 003
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        WhseShptHdr: Record "Warehouse Shipment Header";
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 15-01-17 ZY-LD 001
        Rec.SetFilter("Date Filter", '..%1', WORKDATE + 5);  // 04-12-20 ZY-LD 003

        HasReopenPermision := WhseShptHdr.WritePermission;
    end;

    var
        HasReopenPermision: Boolean;
}
