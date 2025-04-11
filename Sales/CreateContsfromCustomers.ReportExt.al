reportextension 50002 CreateContsFromCustomersZX extends "Create Conts. from Customers"
{
    dataset
    {
        modify(Customer)
        {
            trigger OnAfterPreDataItem()
            var
                recCust: Record Customer;
                zText001: Label 'Customer No. %1 does not exist.';
            begin
                //>> 07-02-20 ZY-LD 001
                if not recCust.Get(Customer.GetFilter("No.")) then
                    Error(zText001, Customer.GetFilter("No."));
                //<< 07-02-20 ZY-LD 001
            end;
        }
    }
}
