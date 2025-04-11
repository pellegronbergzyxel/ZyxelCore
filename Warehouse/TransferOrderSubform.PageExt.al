pageextension 50249 TransferOrderSubformZX extends "Transfer Order Subform"
{
    layout
    {
        modify(Control1)
        {
            Editable = LineEditable;
        }
        modify("Item No.")
        {
            StyleExpr = StyleExprAdditionalItem;

            trigger OnAfterValidate()
            begin
                CurrPage.Update();  // 15-01-18 ZY-LD 001        
            end;
        }
        addlast(Control1)
        {
            field(ExpectedReceiptDate; Rec.ExpectedReceiptDate)
            {
                ApplicationArea = Basic, Suite, Location, Planning, Warehouse;
                ToolTip = 'Specifies the date you expect the items to be available in your warehouse - copied from the container detail / purchase line.';
            }
            field(PurchaseOrderNo; Rec.PurchaseOrderNo)
            {
                ApplicationArea = Basic, Suite, Location, Planning, Warehouse;
                ToolTip = 'Specifies the purchase order number - copied from the container detail / purchase line.';
            }
            field(PurchaseOrderLineNo; Rec.PurchaseOrderLineNo)
            {
                ApplicationArea = Basic, Suite, Location, Planning, Warehouse;
                ToolTip = 'Specifies the purchase order line number - copied from the container detail / purchase line.';
            }
        }
        modify("Transfer-from Bin Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Transfer-from Bin Code"), Rec."Transfer-from Bin Code");  // 04-04-18 ZY-LD 002
            end;
        }
        modify("Transfer-To Bin Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Transfer-To Bin Code"), Rec."Transfer-To Bin Code");  // 04-04-18 ZY-LD 002        
            end;
        }
        Modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo(Quantity), Rec.Quantity);  // 04-01-18 ZY-LD 002
            end;
        }
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Qty. to Ship"), Rec."Qty. to Ship");
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Qty. to Receive"), Rec."Qty. to Receive");
            end;
        }
        addafter("Shipment Date")
        {
            field("Shipment Date Confirmed"; Rec."Shipment Date Confirmed")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipmentDateConfirmVisible;
            }
            field("Transfer-to Address Code"; Rec."Transfer-to Address Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Delivery Document No."; Rec."Delivery Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipmentDateConfirmVisible;
            }
            field("Warehouse Status"; Rec."Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipmentDateConfirmVisible;
            }
        }
        addafter("ShortcutDimCode[8]")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        moveafter(Quantity; "Shipment Date")
    }

    actions
    {
        addfirst("F&unctions")
        {
            action("Copy Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy Line';
                Image = Copy;
                ShortcutKey = 'Ctrl+Alt+c';

                trigger OnAction()
                begin
                    CopyTransferLine;  // 30-06-22 ZY-LD 005
                end;
            }
        }
        addafter("Item &Tracking Lines")
        {
            action("Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Delivery Document No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 15-01-18 ZY-LD 001
        SI.SetValidateFromPage(true);  // 06-01-21 ZY-LD 004
    end;

    trigger OnClosePage()
    begin
        SI.SetValidateFromPage(false);  // 06-01-21 ZY-LD 004
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 15-01-18 ZY-LD 001
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        TransferOrdersEvents.OnAfterDeleteTransferLinesPage(Rec);  // 05-02-18 ZY-LD 002
    end;

    var
        LineEditable: Boolean;
        TransferOrdersEvents: Codeunit "Transfer Event";
        StyleExprAdditionalItem: Text;
        ShipmentDateConfirmVisible: Boolean;
        SI: Codeunit "Single Instance";

    local procedure UpdateAdditionalLine(pFieldNo: Integer; pFieldValue: Variant)
    var
        lSalesLine: Record "Sales Line";
        lTransferLine: Record "Transfer Line";
    begin
        //>> 04-01-18 ZY-LD 002
        if Rec."Line No." <> 0 then begin
            lTransferLine.SetRange("Document No.", Rec."Document No.");
            lTransferLine.SetRange("Additional Item Line No.", Rec."Line No.");
            if lTransferLine.FindSet() then begin
                repeat
                    case pFieldNo of
                        Rec.FieldNo(Rec.Quantity):
                            lTransferLine.Validate(Quantity, pFieldValue);
                        Rec.FieldNo(Rec."Qty. to Ship"):
                            lTransferLine.Validate("Qty. to Ship", pFieldValue);
                        Rec.FieldNo(Rec."Qty. to Receive"):
                            lTransferLine.Validate("Qty. to Receive", pFieldValue);
                        Rec.FieldNo(Rec."Transfer-from Bin Code"):
                            lTransferLine.Validate("Transfer-from Bin Code", pFieldValue);
                        Rec.FieldNo(Rec."Transfer-To Bin Code"):
                            lTransferLine.Validate("Transfer-To Bin Code", pFieldValue);
                    end;
                    lTransferLine.Modify();
                until lTransferLine.Next() = 0;
                CurrPage.Update(true);
            end;
        end;
        //<< 04-01-18 ZY-LD 002
    end;

    local procedure SetActions()
    var
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        LineEditable := Rec."Additional Item Line No." = 0;  // 15-01-18 ZY-LD 001

        //>> 03-04-18 ZY-LD 003
        StyleExprAdditionalItem := 'Standard';
        if not LineEditable then
            StyleExprAdditionalItem := 'Subordinate';
        //<< 03-04-18 ZY-LD 003

        if Rec."Transfer-from Code" <> '' then
            //ShipmentDateConfirmVisible := ItemLogisticEvents.MainWarehouseLocation("Transfer-from Code");
            ShipmentDateConfirmVisible := ItemLogisticEvents.RequireShipmentLocation(Rec."Transfer-from Code");  // 27-04-23 ZY-LD 006
    end;

    local procedure CopyTransferLine()
    var
        lText001: Label 'Do you want to copy the line?';
        recTransferLine: Record "Transfer Line";
        recTransferLine2: Record "Transfer Line";
        NextLineNo: Integer;
    begin
        //>> 30-06-22 ZY-LD 005
        if Confirm(lText001, true) then begin
            recTransferLine := Rec;
            recTransferLine.SetRange("Document No.", Rec."Document No.");
            if recTransferLine.Next <> 0 then
                NextLineNo := Rec."Line No." + Round((recTransferLine."Line No." - Rec."Line No.") / 2, 1, '<')
            else
                NextLineNo := Rec."Line No." + 10000;

            recTransferLine2 := Rec;
            recTransferLine2."Line No." := NextLineNo;
            recTransferLine2.Validate(Quantity, Round(Rec.Quantity / 2, 1, '<'));
            recTransferLine2.Insert();

            Rec.Validate(Rec.Quantity, Rec.Quantity - recTransferLine2.Quantity);
            Rec.Modify(true);
        end;
        //<< 30-06-22 ZY-LD 005
    end;
}
