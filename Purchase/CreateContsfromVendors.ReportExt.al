reportextension 50001 CreateContsFromVendorsZX extends "Create Conts. from Vendors"
{
    dataset
    {
        modify(Vendor)
        {
            trigger OnAfterPreDataItem()
            var
                recVend: Record Vendor;
                zText001: Label 'Vendor No. %1 does not exist.';
            begin
                //>> 07-02-20 ZY-LD 001
                if not recVend.Get(Vendor.GetFilter("No.")) then
                    Error(zText001, Vendor.GetFilter("No."));
                //<< 07-02-20 ZY-LD 001
            end;
        }
    }
}
