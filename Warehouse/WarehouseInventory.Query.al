Query 50005 "Warehouse Inventory"
{

    elements
    {
        dataitem(Item; Item)
        {
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Net_Change; "Net Change")
            {
            }
            column(Warehouse_Inventory; "Warehouse Inventory")
            {
            }
            filter(Date_Filter; "Date Filter")
            {
            }
            filter(Location_Filter; "Location Filter")
            {
            }
            filter(Quanty_Type_Filter; "Quanty Type Filter")
            {
                ColumnFilter = Quanty_Type_Filter = const("On Hand");
            }
        }
    }
}

