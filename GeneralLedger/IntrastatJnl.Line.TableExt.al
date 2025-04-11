tableextension 50146 IntrastatReportLineZX extends "Intrastat Report Line"
{
    fields
    {

        field(50001; "Source No."; Code[20])
        {
            CalcFormula = lookup("Item Ledger Entry"."Source No." where("Entry No." = field("Source Entry No.")));
            FieldClass = FlowField;
        }
        field(50002; "VAT No."; Text[20])
        {
            CalcFormula = lookup(Customer."VAT Registration No." where("No." = field("Source No.")));
            FieldClass = FlowField;
        }
        field(50004; "Posting Description"; Text[100])
        {
            CalcFormula = lookup("Sales Shipment Header"."Posting Description" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50005; "Item Entry Ship-To Co/Reg Code"; Code[10])
        {
            CalcFormula = lookup("Item Ledger Entry"."Country/Region Code" where("Entry No." = field("Source Entry No.")));
            Caption = 'Item Entry Ship-To Country/Region Code';
            Description = '08-08-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "External Document No."; Code[35])
        {
            CalcFormula = lookup("Item Ledger Entry"."External Document No." where("Entry No." = field("Source Entry No.")));
            Caption = 'External Document No.';
            Description = '04-12-20 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Opposite Country/Region Code"; Code[10])
        {
            Caption = 'Opposite Country/Region Code';
            Description = '14-10-22 ZY-LD 003';
            TableRelation = "Country/Region";
        }
    }
}
