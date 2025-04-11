tableextension 50138 PurchCrMemoLineZX extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50001; "Requested Date From Factory"; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50002; "ETD Date"; Date)
        {
            Caption = 'Factory Schedule Date';
            Description = 'DT1.0';
            Editable = false;
        }
        field(50003; ETA; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50004; "Actual shipment date"; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50028; "GLC Serial No."; Code[20])
        {
            Caption = 'GLC Serial No.';
            Description = '23-02-23 ZY-LD 009';
        }
        field(50029; "GLC Mac Address"; Code[20])
        {
            Caption = 'GLC Mac Address';
            Description = '23-02-23 ZY-LD 009';
        }
        field(50036; "Original No."; Code[20])  // 01-05-24 ZY-LD 000
        {
            Caption = 'Original No.';
            Description = 'In case of samples we need to store the original item no. so we can use it in intrastat reporting.';
        }
        field(50102; "EMS Machine Code"; Code[35])
        {
            Caption = 'EMS Machine Code';
            Description = 'PAB 1.0';
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = '17-11-17 ZY-LD 002';
        }
    }
}
