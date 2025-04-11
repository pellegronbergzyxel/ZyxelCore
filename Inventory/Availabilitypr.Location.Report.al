Report 50097 "Availability pr. Location"
{
    // 001. 10-12-20 ZY-LD 2020121010000054 - "Buy-from Vendor No. Filter" must be used on "Qty. on Shipping Detail" and "Qty. on Ship. Detail Received", that is why "Qty. on Purch. Order" is calculated separate.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Availability pr. Location.rdlc';

    Caption = 'Availability pr. Location';
    ShowPrintStatus = false;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(ItemMain; Item)
        {
            CalcFields = Inventory, "Qty. on Purch. Order", "Qty. on Sales Order", "Qty. on Reciept Lines", "Qty. on Shipping Detail", "Qty. on Ship. Detail Received", "HQ Unshipped Purchase Order";
            RequestFilterFields = "No.", "Date Filter", "Location Filter";
            dataitem(LocationTmp; Location)
            {
                DataItemTableView = sorting(Code);
                UseTemporary = true;
                dataitem(Item; Item)
                {
                    CalcFields = Inventory, "Qty. on Purch. Order", "Qty. on Sales Order", "Qty. on Reciept Lines", "Qty. on Shipping Detail", "Qty. on Ship. Detail Received", "HQ Unshipped Purchase Order", "Trans. Ord. Shipment (Qty.)";
                    DataItemTableView = sorting("No.");
                    column(ItemNo; Item."No.")
                    {
                    }
                    column(Location; LocationTmp.Code)
                    {
                    }
                    column(Description; Descript)
                    {
                    }
                    column(Inventory; Item.Inventory)
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(QtyOnSalesOrder; Item."Qty. on Sales Order")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(QtyOnTransOrder; Item."Trans. Ord. Shipment (Qty.)")
                    {
                    }
                    column(QtyOnPurchOrder; Item."Qty. on Purch. Order")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(ExpectedAvaliable; Item.Inventory - Item."Qty. on Sales Order" - Item."Trans. Ord. Shipment (Qty.)" + Item."Qty. on Purch. Order")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(ActualAvaliable; Item.Inventory - Item."Qty. on Sales Order" - Item."Trans. Ord. Shipment (Qty.)")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(QtyOnRecieptLine; Item."Qty. on Reciept Lines")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(QtyOnShippingDetail; Item."Qty. on Shipping Detail" - Item."Qty. on Ship. Detail Received")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(HQUnshippedPurchOrder; Item."HQ Unshipped Purchase Order")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(ItemNo_Caption; ItemNo_Caption)
                    {
                    }
                    column(Location_Caption; Location_Caption)
                    {
                    }
                    column(Description_Caption; Description_Caption)
                    {
                    }
                    column(Inventory_Caption; Inventory_Caption)
                    {
                    }
                    column(QtyOnSalesOrder_Caption; QtyOnSalesOrder_Caption)
                    {
                    }
                    column(QtyOnTransOrder_Caption; QtyOnTransOrder_Caption)
                    {
                    }
                    column(QtyOnPurchOrder_Caption; QtyOnPurchOrder_Caption)
                    {
                    }
                    column(ExpectedAvailable_Caption; ExpectedAvailable_Caption)
                    {
                    }
                    column(ActualAvailable_Caption; ActualAvailable_Caption)
                    {
                    }
                    column(QtyOnReceiptLine_Caption; QtyOnReceiptLine_Caption)
                    {
                    }
                    column(QtyOnShipDetail_Caption; QtyOnShipDetail_Caption)
                    {
                    }
                    column(QtyUnshippedOrder_Caption; QtyUnshippedOrder_Caption)
                    {
                    }
                    column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                    {
                    }
                    column(DateFilter; DateFilter)
                    {
                    }
                    column(LocationFilter; LocationFilter)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Item.SetRange(Item."Buy-from Vendor No. Filter");  // 10-12-20 ZY-LD 001
                        Item.CalcFields(Item."Qty. on Purch. Order");  // 10-12-20 ZY-LD 001
                        if (Item.Inventory = 0) and
                           (Item."Qty. on Sales Order" = 0) and
                           (Item."Qty. on Purch. Order" = 0) and
                           (Item."Qty. on Reciept Lines" = 0) and
                           (Item."HQ Unshipped Purchase Order" = 0)
                        then
                            CurrReport.Skip;

                        if LocationTmp.Code = '' then
                            Descript := Item.Description
                        else
                            Descript := LocationTmp.Name;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Item.SetRange(Item."No.", ItemMain."No.");
                        if LocationTmp.Code = '' then begin
                            if ItemMain.GetFilter("Location Filter") <> '' then
                                ItemMain.Copyfilter("Location Filter", Item."Location Filter")
                            else
                                Item.SetRange(Item."Location Filter")
                        end else
                            Item.SetRange(Item."Location Filter", LocationTmp.Code);
                        ItemMain.Copyfilter("Buy-from Vendor No. Filter", Item."Buy-from Vendor No. Filter");  // 10-12-20 ZY-LD 001
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(ItemMain."No.", 0, true);

                ItemMain.SetRange(ItemMain."Buy-from Vendor No. Filter");  // 10-12-20 ZY-LD 001
                ItemMain.CalcFields(ItemMain."Qty. on Purch. Order");  // 10-12-20 ZY-LD 001
                if (ItemMain.Inventory = 0) and
                   (ItemMain."Qty. on Sales Order" = 0) and
                   (ItemMain."Qty. on Purch. Order" = 0) and
                   (ItemMain."Qty. on Reciept Lines" = 0) and
                   (ItemMain."HQ Unshipped Purchase Order" = 0)
                then
                    CurrReport.Skip;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ItemMain.Copyfilter(ItemMain."Location Filter", recLocation.Code);
                LocationTmp.Insert;
                if recLocation.FindSet then
                    repeat
                        LocationTmp := recLocation;
                        LocationTmp.Insert;
                    until recLocation.Next() = 0;

                ZGT.OpenProgressWindow('', ItemMain.Count);
                DateFilter := ItemMain.GetFilter(ItemMain."Date Filter");
                LocationFilter := ItemMain.GetFilter(ItemMain."Location Filter");
                ItemMain.SetFilter(ItemMain."Buy-from Vendor No. Filter", VendorEvent.GetFilterZyxelVendors(0, false));  // 10-12-20 ZY-LD 001
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'Availability pr. Location';
    }

    var
        recLocation: Record Location;
        ZGT: Codeunit "ZyXEL General Tools";
        VendorEvent: Codeunit "Vendor Event";
        Descript: Text;
        ItemNo_Caption: label 'Item No.';
        Location_Caption: label 'Location';
        Description_Caption: label 'Description';
        Inventory_Caption: label 'Inventory';
        QtyOnSalesOrder_Caption: label 'Qty. on Sales Order';
        QtyOnPurchOrder_Caption: label 'Qty. on Purch. Order';
        ExpectedAvailable_Caption: label 'Expected Available';
        ActualAvailable_Caption: label 'Actual Available';
        QtyOnReceiptLine_Caption: label 'Qty. on Receipt. Line';
        QtyOnShipDetail_Caption: label 'Goods in Transit';
        QtyUnshippedOrder_Caption: label 'Unship. Purch Order';
        DateFilter: Text;
        LocationFilter: Text;
        CurrReportPageNoCaptionLbl: label 'Page';
        QtyOnTransOrder_Caption: label 'Qty. on Transfer Order';
}
