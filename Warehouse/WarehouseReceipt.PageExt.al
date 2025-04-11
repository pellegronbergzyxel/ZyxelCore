pageextension 50256 WarehouseReceiptZX extends "Warehouse Receipt"
{
    layout
    {
        modify(Control1905767507)
        {
            Visible = false;
        }
        addfirst(FactBoxes)
        {
            part(Control3; "Rcpt. Response FactBox")
            {
                Caption = 'VCK Response';
                Provider = WhseReceiptLines;
                SubPageLink = "Customer Reference" = field("Source No.");
            }
            part(Control4; "Container Details FactBox")
            {
                Provider = WhseReceiptLines;
                SubPageLink = "Purchase Order No." = field("Source No."),
                              "Purchase Order Line No." = field("Source Line No."),
                              Archive = const(false);
            }
        }
    }

    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Use Filters to Get Src. Docs.")
        {
            Promoted = false;
        }
        modify("Get Source Documents")
        {
            Promoted = false;
        }
        modify(CalculateCrossDock)
        {
            Promoted = false;
        }
        modify("Post and Print P&ut-away")
        {
            Promoted = false;
        }
        addafter("F&unctions")
        {
            action("Delete and update sales return order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete and update sales return order';
                Enabled = DeleteSalesReturnOrderEditable;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                Visible = DeleteSalesReturnOrderVisible;

                trigger OnAction()
                begin
                    if Confirm(zText001, true, Rec."No.") then begin
                        Rec.DeleteUnpostedSalesReturnOrderLines;
                        Rec.Delete();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 10-06-20 ZY-LD 001
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 10-06-20 ZY-LD 001
    end;

    var
        DeleteSalesReturnOrderVisible: Boolean;
        DeleteSalesReturnOrderEditable: Boolean;
        zText001: Label 'Delete %1 and set "Completely Invoiced" = Yes on unposted "Sales Return Order Lines".';

    local procedure SetActions()
    begin
        //>> 10-06-20 ZY-LD 001
        Rec.CalcFields(Rec."Sales Return Order No.");
        DeleteSalesReturnOrderVisible := Rec."Sales Return Order No." <> '';
        DeleteSalesReturnOrderEditable := (Rec."Sales Return Order No." <> '') and (Rec."Document Status" = Rec."document status"::"Partially Received");
        //<< 10-06-20 ZY-LD 001
    end;
}
