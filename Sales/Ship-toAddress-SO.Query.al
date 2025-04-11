Query 50000 "Ship-to Address - SO"
{

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = const(Order);
            column(Document_Type; "Document Type")
            {
            }
            column(No; "No.")
            {
            }
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {
            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {
            }
            column(Sales_Order_Type; "Sales Order Type")
            {
            }
            column(Salesperson_Code; "Salesperson Code")
            {
            }
            column(Completely_Invoiced; "Completely Invoiced")
            {
            }
        }
    }
}
