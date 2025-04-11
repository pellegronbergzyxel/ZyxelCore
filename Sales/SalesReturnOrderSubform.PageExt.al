pageextension 50266 SalesReturnOrderSubformZX extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Returns Deferral Start Date")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("ShortcutDimCode8")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Zero Unit Price Accepted"; Rec."Zero Unit Price Accepted")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter(Quantity)
        {
            field(getTotalQTYperCarton; item.getTotalQTYperCarton(Rec."No."))
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                caption = 'Total Qty. per Carton';
                BlankZero = true;
            }
        }
        addlast(Control1)
        {
            field("Completely Invoiced"; Rec."Completely Invoiced")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                Editable = CompletelyInvoicedEditable;
            }
            field("Not Returnable"; Rec."Not Returnable")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addafter("Order &Tracking")
        {
            action("""filter on ""Completely Invoiced = No""""")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Filter on "Completely Invoiced = No"';
                Image = FilterLines;

                trigger OnAction()
                begin
                    //>> 11-08-20 ZY-LD 001
                    Rec.SetRange(Rec."Completely Invoiced", false);
                    CurrPage.Update();
                    //<< 11-08-20 ZY-LD 001
                end;
            }
            action("Set to Completely Invoiced")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set to Completely Invoiced';
                Image = CompleteLine;

                trigger OnAction()
                begin
                    SetLinesToCompleteInvoiced; // 11-08-20 ZY-LD 001
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        CompletelyInvoicedEditable := ZGT.UserIsDeveloper();
    end;

    local procedure SetLinesToCompleteInvoiced()
    var
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        RcdNotInv: Integer;
        lText001: Label 'Do you want to set %1 line(s) to "Completely Invoiced"?';
        lText002: Label 'There are %1 line(s) which is received but not invoiced.\You must either undo the lines, or make a sales credit memo and reverse it by a sales invoice.';
    begin
        //>> 11-08-20 ZY-LD 001
        CurrPage.SetSelectionFilter(SalesLine);
        if Confirm(lText001, false, SalesLine.Count()) then
            if SalesLine.FindSet() then begin
                repeat
                    if SalesLine."Return Qty. Rcd. Not Invd." = 0 then begin
                        SalesLine2 := SalesLine;
                        SalesLine2.Validate("Completely Invoiced", true);
                        SalesLine2.Modify(true);
                    end else
                        RcdNotInv += 1;
                until SalesLine.Next() = 0;
                if RcdNotInv > 0 then
                    Message(lText002, RcdNotInv);
            end;
        //<< 11-08-20 ZY-LD 001
    end;

    var
        CompletelyInvoicedEditable: Boolean;
        item: Record item;
}
