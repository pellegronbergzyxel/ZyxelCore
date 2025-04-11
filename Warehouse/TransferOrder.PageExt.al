pageextension 50248 TransferOrderZX extends "Transfer Order"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ref./ PO"; Rec."Ref./ PO")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addfirst("Transfer-to")
        {
            field("Transfer-to Address Code"; Rec."Transfer-to Address Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Transfer-to Contact")
        {
            field("Transfer-to Forecast Territory"; Rec."Transfer-to Forecast Territory")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control9; "Item Warehouse FactBox")
            {
                Provider = TransferLines;
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field("Transfer-from Code");
            }
            part(Control43; "Transfer Line FactBox")
            {
                Provider = TransferLines;
                SubPageLink = "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
                Visible = FactBoxVisible;
            }
        }
    }

    actions
    {
        addafter("In&vt. Put-away/Pick Lines")
        {
            action(DeliveryDocument)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Document';

                trigger OnAction()
                var
                    recDeliveryLine: Record "VCK Delivery Document Line";
                    recDeliveryHeader: Record "VCK Delivery Document Header";
                begin
                    recDeliveryLine.SetFilter("Transfer Order No.", Rec."No.");
                    if recDeliveryLine.FindFirst() then begin
                        recDeliveryHeader.SetFilter("No.", recDeliveryLine."Document No.");
                        if recDeliveryHeader.FindFirst() then
                            Page.RunModal(50086, recDeliveryHeader);
                        if not recDeliveryHeader.FindFirst() then begin
                            Message(Text002);
                        end;
                    end;
                    if not recDeliveryLine.FindFirst() then begin
                        Message(Text001);
                    end;
                end;
            }
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
                        //>> 30-12-20 ZY-LD 006
                        SI.SetValidateFromPage(false);
                        PickDateConfMgt.PerformManuelConfirm(1, Rec."No.");
                        SI.SetValidateFromPage(true);
                        //<< 30-12-20 ZY-LD 006
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
                        DelDocMgt.CreateDeliveryDocumentTransfer('');  // 30-12-20 ZY-LD 006
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 04-11-20 ZY-LD 006
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 04-11-20 ZY-LD 006
    end;

    var
        DeliveryDays: Integer;
        SuggestedZone: Text[30];
        TextLabel1: Label 'These are pre-defined post codes for the selected delivery zone. Please note that other post codes may be covered by this zone.';
        Text001: Label 'A Delivery Document Could not be found for this Transfer Order (Line).';
        Text002: Label 'A Delivery Document Could not be found for this Transfer Order. (Header)';
        FactBoxVisible: Boolean;

    local procedure SetActions()
    var
        recInvSetup: Record "Inventory Setup";
    begin
        //>> 04-11-20 ZY-LD 006
        recInvSetup.Get();
        FactBoxVisible := Rec."Transfer-from Code" = recInvSetup."AIT Location Code";
        //<< 04-11-20 ZY-LD 006
    end;
}
