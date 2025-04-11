report 50041 RMAStockControlZX
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/RMA Stock Control.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'RMA Stock Control';
    UseRequestPage = false;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(CountryLoop; "Country/Region")
        {
            DataItemTableView = sorting("RMA Location Code") where("RMA Location Code" = filter(<> ''));
            RequestFilterFields = "RMA Location Code";
            dataitem("Country/Region"; "Country/Region")
            {
                DataItemLink = "RMA Location Code" = field("RMA Location Code");
                DataItemTableView = sorting("RMA Location Code");

                trigger OnAfterGetRecord()
                begin
                    if CountryRegionFilter <> '' then
                        CountryRegionFilter := CountryRegionFilter + '|';
                    CountryRegionFilter := CountryRegionFilter + "Country/Region".Code;
                end;

                trigger OnPreDataItem()
                begin
                    CountryRegionFilter := '';
                end;
            }
            dataitem(Item; Item)
            {
                CalcFields = Inventory;
                DataItemTableView = sorting("No.") where(Status = const(Live));
                RequestFilterFields = "No.";
                column(ItemNoCaption; Item.FieldCaption(Item."No."))
                {
                }
                column(ItemDescriptionCaption; Item.FieldCaption(Item.Description))
                {
                }
                column(QuantitySoldCaption; QuantitySoldCaption)
                {
                }
                column(ItemNo; Item."No.")
                {
                }
                column(ItemDescription; Item.Description)
                {
                }
                column(RMAWarehouse; CountryLoop."RMA Location Code")
                {
                }
                column(RMAInventory; Item.Inventory)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SoldQuantity; QuantitySold)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(QtyOnSalesOrder; CalcQtyOnSalesOrder)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(VCKOnHand; recItemVCK.Inventory)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    QuantitySold := CalcSoldQuantity;
                    if QuantitySold <= 0 then
                        CurrReport.Skip();

                    if recItemVCK."No." <> Item."No." then
                        recItemVCK.Get(Item."No.");
                end;

                trigger OnPreDataItem()
                begin
                    if CountryRegionFilter = '' then
                        CurrReport.Break();

                    Item.SetRange(Item."Location Filter", CountryLoop."RMA Location Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CountryLoop.SetRange(CountryLoop."RMA Location Code", CountryLoop."RMA Location Code");
                ZGT.UpdateProgressWindow(CountryLoop."RMA Location Code", CountryLoop.Count(), true);
                CountryLoop.FindLast();
                CountryLoop.SetRange(CountryLoop."RMA Location Code");
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', CountryLoop.Count());
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        RMALocationCaption = 'RMA Location Code';
        RMAInventoryCaption = 'RMA Inventory';
        QuantityOnSalesOrderCaption = 'Qty. on Sales Order';
        QuantityOnHand = 'Qty. on Hand (VCK)';
    }

    trigger OnPreReport()
    begin
        StartDate := CalcDate('<-1Y>', Today);
        EndDate := Today - 1;
        QuantitySoldCaption := StrSubstNo(Text001, StartDate);
        recInventorySetup.Get();
        recInventorySetup.TestField("AIT Location Code");
        recItemVCK.SetRange("Location Filter", ItemLogEvent.GetMainWarehouseLocation);
        recItemVCK.SetAutoCalcFields(Inventory);
    end;

    var
        recInventorySetup: Record "Inventory Setup";
        recItemVCK: Record Item;
        CountryRegionFilter: Text;
        Text001: Label 'Sold in period %1..';
        QuantitySoldCaption: Text;
        QuantitySold: Decimal;
        StartDate: Date;
        EndDate: Date;
        ZGT: Codeunit "ZyXEL General Tools";
        ItemLogEvent: Codeunit "Item / Logistic Events";

    local procedure CalcSoldQuantity(): Decimal
    var
        ItemLedgEntrySoldQty: Query "Item Ledg. Entry Sold Qty.";
    begin
        ItemLedgEntrySoldQty.SetRange(Item_No, Item."No.");
        ItemLedgEntrySoldQty.SetRange(Entry_Type, 1);  // Sale
        ItemLedgEntrySoldQty.SetRange(Posting_Date, StartDate, EndDate);
        ItemLedgEntrySoldQty.SetFilter(Country_Region_Code, CountryRegionFilter);
        ItemLedgEntrySoldQty.SetRange(Location_Code, recInventorySetup."AIT Location Code");
        ItemLedgEntrySoldQty.Open;

        if ItemLedgEntrySoldQty.Read then
            exit(ItemLedgEntrySoldQty.Sum_Quantity);
    end;

    local procedure CalcQtyOnSalesOrder(): Decimal
    var
        QtyonSalesOrderprCountry: Query "Qty. on Sales Order pr. Countr";
    begin
        QtyonSalesOrderprCountry.SetRange(Document_Type, 1);  // Order
        QtyonSalesOrderprCountry.SetRange(Type, 2);  // Item
        QtyonSalesOrderprCountry.SetRange(No, Item."No.");
        QtyonSalesOrderprCountry.SetRange(Location_Code, recInventorySetup."AIT Location Code");
        QtyonSalesOrderprCountry.SetFilter(Country_Code, CountryRegionFilter);
        QtyonSalesOrderprCountry.SetFilter(Outstanding_Quantity, '<>0');
        QtyonSalesOrderprCountry.Open;

        if QtyonSalesOrderprCountry.Read then
            exit(QtyonSalesOrderprCountry.Sum_Outstanding_Quantity);
    end;
}
