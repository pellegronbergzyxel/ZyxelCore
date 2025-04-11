pageextension 50118 VendorLedgerEntriesZX extends "Vendor Ledger Entries"
{
    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 02-11-17 ZY-LD 001
    end;
}
