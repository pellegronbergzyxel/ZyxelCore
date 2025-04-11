Query 50004 "Qty. on Sales Order pr. Countr"
{

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            filter(Document_Type; "Document Type")
            {
            }
            filter(Type; Type)
            {
            }
            filter(No; "No.")
            {
            }
            filter(Location_Code; "Location Code")
            {
            }
            filter(Country_Code; "Country Code")
            {
            }
            filter(Outstanding_Quantity; "Outstanding Quantity")
            {
            }
            column(Sum_Outstanding_Quantity; "Outstanding Quantity")
            {
                Method = Sum;
            }
        }
    }
}
