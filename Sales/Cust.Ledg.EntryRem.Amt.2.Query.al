Query 50001 "Cust. Ledg. Entry Rem. Amt. 2"
{
    Caption = 'Cust. Ledg. Entry Remain. Amt.';

    elements
    {
        dataitem(Cust_Ledger_Entry; "Cust. Ledger Entry")
        {
            filter(Document_Type; "Document Type")
            {
            }
            filter(IsOpen; Open)
            {
            }
            filter(Due_Date; "Due Date")
            {
            }
            filter(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            filter(Customer_Posting_Group; "Customer Posting Group")
            {
            }
            column(Sum_Remaining_Amt_LCY; "Remaining Amt. (LCY)")
            {
                Method = Sum;
            }
        }
    }
}
