reportextension 50005 VendorDetailTrialBalanceZX extends "Vendor - Detail Trial Balance"
{
    dataset
    {
        modify("Vendor Ledger Entry")
        {
            trigger OnAfterPreDataItem()
            begin
                "Vendor Ledger Entry".SetRange(Open, true);
            end;
        }
    }
}