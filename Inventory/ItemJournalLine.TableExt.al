tableextension 50124 ItemJournalLineZX extends "Item Journal Line"
{
    fields
    {
        field(50000; "Auto Created by Transfer order"; Code[20])
        {
            Description = 'ZY1.0 - Populates in ZYND CZ when transfer order is shipped in RHQ';
        }
        field(50001; "Unit Cost (Difference)"; Decimal)
        {
            Caption = 'Unit Cost (Difference)';
            Description = '14-02-20 ZY-LD 002';
            Editable = false;
        }
        field(50002; "Item Ledg. Entry Doc. Type"; Enum "Item Ledger Document Type")
        {
            CalcFormula = lookup("Item Ledger Entry"."Document Type" where("Entry No." = field("Applies-to Entry")));
            Caption = 'Item Ledg. Entry Document Type';
            Description = '31-03-20 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50036; "Original No."; Code[20])  // 01-05-24 ZY-LD 000
        {
            Caption = 'Original No.';
            Description = 'In case of samples we need to store the original item no. so we can use it in intrastat reporting.';
        }

    }
    keys
    {
        key(Key50000; "Journal Batch Name", "Journal Template Name", "Item No.", "Posting Date", "Entry Type")
        {
            SumIndexFields = "Unit Amount", Amount;
        }
    }
}
