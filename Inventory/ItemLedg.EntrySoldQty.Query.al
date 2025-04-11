Query 50003 "Item Ledg. Entry Sold Qty."
{

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            filter(Item_No; "Item No.")
            {
            }
            filter(Entry_Type; "Entry Type")
            {
            }
            filter(Posting_Date; "Posting Date")
            {
            }
            filter(Country_Region_Code; "Country/Region Code")
            {
            }
            filter(Location_Code; "Location Code")
            {
            }
            column(Sum_Quantity; Quantity)
            {
                Method = Sum;
                ReverseSign = true;
            }
        }
    }
}
