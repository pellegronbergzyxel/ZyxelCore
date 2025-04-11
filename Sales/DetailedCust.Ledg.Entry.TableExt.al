tableextension 50170 DetailedCustLedgEntryZX extends "Detailed Cust. Ledg. Entry"
{
    fields
    {

        field(50000; "Cust. Ledger Entry Document No"; Code[20])
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Document No." where("Entry No." = field("Cust. Ledger Entry No.")));
            Caption = 'Cust. Ledger Entry Document No';
            Description = '17-06-21 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
