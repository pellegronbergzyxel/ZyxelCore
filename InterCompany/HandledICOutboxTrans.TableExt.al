tableextension 50178 HandledICOutboxTransZX extends "Handled IC Outbox Trans."
{
    fields
    {
        field(50000; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Header"."Sell-to Customer No." where("No." = field("Document No.")));
            Caption = 'Sell-to Customer No.';
            Description = 'Can be deleted again';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Bill-to Customer No."; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Header"."Bill-to Customer No." where("No." = field("Document No.")));
            Caption = 'Bill-to Customer No.';
            Description = 'Can be deleted again';
            FieldClass = FlowField;
        }
        field(50002; "Location Code"; Code[10])
        {
            CalcFormula = lookup("Sales Invoice Header"."Location Code" where("No." = field("Document No.")));
            Caption = 'Location Code';
            Description = 'Can be deleted again';
            FieldClass = FlowField;
        }
    }
}
