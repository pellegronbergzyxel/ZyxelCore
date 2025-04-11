tableextension 50233 WarehouseReceiptHeaderZX extends "Warehouse Receipt Header"
{
    fields
    {
        field(50000; "Purchase Order No."; Code[20])
        {
            CalcFormula = lookup("Warehouse Receipt Line"."Source No." where("No." = field("No."),
                                                                             "Source Type" = const(39),
                                                                             "Source Document" = const("Purchase Order")));
            Caption = 'Purchase Order No.';
            Description = '20-02-19 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purchase Header";
        }
        field(50001; "Sales Return Order No."; Code[20])
        {
            CalcFormula = lookup("Warehouse Receipt Line"."Source No." where("No." = field("No."),
                                                                             "Source Type" = const(37),
                                                                             "Source Document" = const("Sales Return Order")));
            Caption = 'Sales Return Order No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Sales Header";
        }
        field(50002; "Transfer Order No."; Code[20])
        {
            CalcFormula = lookup("Warehouse Receipt Line"."Source No." where("No." = field("No."),
                                                                             "Source Type" = const(5741),
                                                                             "Source Document" = const("Inbound Transfer")));
            Caption = 'Transfer Order No.';
            Description = '13-10-20 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66001; "DSV Status"; Option)
        {
            OptionCaption = ' ,New,Sent,Recieved,Mismatch';
            OptionMembers = " ",New,Sent,Recieved,Mismatch;
        }
        field(66002; "Expected Receipt Date"; Date)
        {
        }
    }

    local procedure ">>Zyxel"()
    begin
    end;

    procedure DeleteUnpostedSalesReturnOrderLines()
    var
        recSalesLine: Record "Sales Line";
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        //>> 10-06-20 ZY-LD 002
        // We only want to update "Completely Invoiced" after warehouse response post. That is why it´s not an Event.
        WhseRcptLine.Reset();
        WhseRcptLine.SetRange("No.", Rec."No.");
        if WhseRcptLine.FindSet(true) then
            repeat
                if recSalesLine.Get(recSalesLine."document type"::"Return Order", WhseRcptLine."Source No.", WhseRcptLine."Source Line No.") then begin
                    recSalesLine."Completely Invoiced" := true;
                    recSalesLine.Modify(true);
                end;
            until WhseRcptLine.Next() = 0;

        Rec.DeleteRelatedLines(false);
        //<< 10-06-20 ZY-LD 002
    end;
}
