report 50080 "Import VCK RMA"
{
    //ApplicationArea = Basic, Suite;
    Caption = 'Import VCK RMA';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") where("Quanty Type Filter" = Const("On Hand"));
            CalcFields = Inventory, "Warehouse Inventory";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Item."No.", 0, true);

                IF Item.Inventory - Item."Warehouse Inventory" <> 0 then begin
                    UID += 10000;

                    Clear(RMAStockJnl);
                    RMAStockJnl.Init;
                    RMAStockJnl.Validate(UID, UID);
                    RMAStockJnl.Validate("Item No.", "Item"."No.");
                    RMAStockJnl.Validate(Quantity, Item."Warehouse Inventory");  // - Item.Inventory);
                    RMAStockJnl."Country Code" := Location."Country/Region Code";
                    RMAStockJnl.Validate("Location Code", Location.Code);
                    RMAStockJnl.Insert(true);
                end;
            end;

            trigger OnPreDataItem()
            var
                AutoSetup: Record "Automation Setup";
            begin
                AutoSetup.Get;
                AutoSetup.TestField("Last Imported Inventory Date");
                Location.SetRange("RMA Location", true);
                Location.FindFirst();
                Location.TestField("Country/Region Code");

                Item.SETFILTER("Date Filter", '..%1', AutoSetup."Last Imported Inventory Date");
                Item.SetRange("Location Filter", Location.Code);

                RMAStockJnl.DeleteAll(true);
                ZGT.OpenProgressWindow('', Item.Count);
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow();
            end;
        }
    }

    var
        RMAStockJnl: Record "LMR Stock";
        Location: Record Location;
        ZGT: Codeunit "ZyXEL General Tools";
        UID: Integer;
}
