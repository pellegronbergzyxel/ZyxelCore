xmlport 50033 "WS Replicate Item"
{
    // 001. 29-01-18 ZY-LD 2018012910000124 - HQ Category is added.
    // 002. 23-10-18 ZY-LD 000 - Keep "Unit Cost". It will be changed back when posting the next entry, so it makes no sence to change it.
    // 003. 06-11-18 ZY-LD 0032018110510000105 - Date filter is set, because the file was too large for communicating with NL.
    // 004. 13-12-18 ZY-LD 2018121010000059 - It happens, that some items are not replicated when intercompany. I can't figure out why, but I have tried this.
    // 005. 01-01-19 ZY-LD 000 - Forece replication.
    // 006. 28-01-24 ZY-LD 000 - We need to replicate the Type in order to make a correct posting.
    // 007. 04-06-24 ZY-LD 000 - The previous code generated too many chang log entries, so part of the code has been rewritten.

    Caption = 'WS Replicate Item';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                MinOccurs = Zero;
                XmlName = 'Item';
                SourceTableView = where(Blocked = const(false));
                UseTemporary = true;
                fieldelement(No; Item."No.")
                {
                }
                fieldelement(No2; Item."No. 2")
                {
                }
                fieldelement(Description; Item.Description)
                {
                }
                fieldelement(Description2; Item."Description 2")
                {
                }
                fieldelement(SearchDescription; Item."Search Description")
                {
                }
                fieldelement(BaseUnitOfMeasure; Item."Base Unit of Measure")
                {
                }
                fieldelement(PriceUnitConversion; Item."Price Unit Conversion")
                {
                }
                fieldelement(Type; Item.Type)
                {
                }
                fieldelement(InventoryPostGrp; Item."Inventory Posting Group")
                {
                }
                fieldelement(ShelfNo; Item."Shelf No.")
                {
                }
                fieldelement(ItemDescGrp; Item."Item Disc. Group")
                {
                }
                fieldelement("AllowInvDisc."; Item."Allow Invoice Disc.")
                {
                }
                fieldelement(StatGroup; Item."Statistics Group")
                {
                }
                fieldelement(CommGroup; Item."Commission Group")
                {
                }
                fieldelement(UnitPrice; Item."Unit Price")
                {
                }
                fieldelement(PriceProfitCalc; Item."Price/Profit Calculation")
                {
                }
                fieldelement(ProfitPct; Item."Profit %")
                {
                }
                fieldelement(CostMethod; Item."Costing Method")
                {
                }
                fieldelement(StandardCost; Item."Standard Cost")
                {
                }
                fieldelement(IndirectCostPct; Item."Indirect Cost %")
                {
                }
                fieldelement(AllowOnlineAdj; Item."Allow Online Adjustment")
                {
                }
                fieldelement(VendorNo; Item."Vendor No.")
                {
                }
                fieldelement(VendorItemNo; Item."Vendor Item No.")
                {
                }
                fieldelement(LeadTimeCalc; Item."Lead Time Calculation")
                {
                }
                fieldelement(RecorderPoint; Item."Reorder Point")
                {
                }
                fieldelement(MaxInv; Item."Maximum Inventory")
                {
                }
                fieldelement(RecorderQty; Item."Reorder Quantity")
                {
                }
                fieldelement(AltItemNo; Item."Alternative Item No.")
                {
                }
                fieldelement(UnitListPrice; Item."Unit List Price")
                {
                }
                fieldelement(DutyDuePct; Item."Duty Due %")
                {
                }
                fieldelement(DutyCode; Item."Duty Code")
                {
                }
                fieldelement(GrossWeight; Item."Gross Weight")
                {
                }
                fieldelement(NetWeight; Item."Net Weight")
                {
                }
                fieldelement(UnitPerParcel; Item."Units per Parcel")
                {
                }
                fieldelement(UnitVolume; Item."Unit Volume")
                {
                }
                fieldelement(Durability; Item.Durability)
                {
                }
                fieldelement(FreightType; Item."Freight Type")
                {
                }
                fieldelement(TariffNo; Item."Tariff No.")
                {
                }
                fieldelement(DutyUnitConv; Item."Duty Unit Conversion")
                {
                }
                fieldelement(CtryRegPurchCode; Item."Country/Region Purchased Code")
                {
                }
                fieldelement(BudgetQty; Item."Budget Quantity")
                {
                }
                fieldelement(BudgetAmount; Item."Budgeted Amount")
                {
                }
                fieldelement(BudgetProfit; Item."Budget Profit")
                {
                }
                fieldelement(Blocked; Item.Blocked)
                {
                }
                fieldelement(PriceInclVAT; Item."Price Includes VAT")
                {
                }
                fieldelement(VatBusPostGrp; Item."VAT Bus. Posting Gr. (Price)")
                {
                }
                fieldelement(GenProdPostGrp; Item."Gen. Prod. Posting Group")
                {
                }
                fieldelement(CtryRegOfOrgin; Item."Country/Region of Origin Code")
                {
                }
                fieldelement(AutoExtText; Item."Automatic Ext. Texts")
                {
                }
                fieldelement(NoSeries; Item."No. Series")
                {
                }
                fieldelement(TaxGrpCode; Item."Tax Group Code")
                {
                }
                fieldelement(VatProdPostGrp; Item."VAT Prod. Posting Group")
                {
                }
                fieldelement(Reserve; Item.Reserve)
                {
                }
                fieldelement(GloDim1Code; Item."Global Dimension 1 Code")
                {
                }
                fieldelement(GloDim2Code; Item."Global Dimension 2 Code")
                {
                }
                fieldelement(StockoutWarn; Item."Stockout Warning")
                {
                }
                fieldelement(PrevNegInv; Item."Prevent Negative Inventory")
                {
                }
                fieldelement(AppWkshUserID; Item."Application Wksh. User ID")
                {
                }
                fieldelement(AssemblyPolicy; Item."Assembly Policy")
                {
                }
                fieldelement(GTIN; Item.GTIN)
                {
                }
                fieldelement(DefDefTemplate; Item."Default Deferral Template Code")
                {
                }
                fieldelement(LowLevCode; Item."Low-Level Code")
                {
                }
                fieldelement(LotSize; Item."Lot Size")
                {
                }
                fieldelement(SerialNos; Item."Serial Nos.")
                {
                }
                fieldelement(LastUnitCostCalcDate; Item."Last Unit Cost Calc. Date")
                {
                }
                fieldelement(RolledUpMatCost; Item."Rolled-up Material Cost")
                {
                }
                fieldelement(RelledUpCapCost; Item."Rolled-up Capacity Cost")
                {
                }
                fieldelement(ScarpPct; Item."Scrap %")
                {
                }
                fieldelement(InvValZero; Item."Inventory Value Zero")
                {
                }
                fieldelement(DiscOrderQty; Item."Discrete Order Quantity")
                {
                }
                fieldelement(MinOrdQty; Item."Minimum Order Quantity")
                {
                }
                fieldelement(MaxOrdQty; Item."Maximum Order Quantity")
                {
                }
                fieldelement(SafetyStockQty; Item."Safety Stock Quantity")
                {
                }
                fieldelement(OrderMultiple; Item."Order Multiple")
                {
                }
                fieldelement(SafetyLeadTime; Item."Safety Lead Time")
                {
                }
                fieldelement(FlushingMethod; Item."Flushing Method")
                {
                }
                fieldelement(ReplSystem; Item."Replenishment System")
                {
                }
                fieldelement(RoundPricision; Item."Rounding Precision")
                {
                }
                fieldelement(SalesUnitOfMeasure; Item."Sales Unit of Measure")
                {
                }
                fieldelement(PurchUnitOfMeasure; Item."Purch. Unit of Measure")
                {
                }
                fieldelement(TimeBucket; Item."Time Bucket")
                {
                }
                fieldelement(ReorderingPolicy; Item."Reordering Policy")
                {
                }
                fieldelement(IncludeInv; Item."Include Inventory")
                {
                }
                fieldelement(ManfPolicy; Item."Manufacturing Policy")
                {
                }
                fieldelement(RescPeriod; Item."Rescheduling Period")
                {
                }
                fieldelement(LotAccPeriod; Item."Lot Accumulation Period")
                {
                }
                fieldelement(DampenerPeriod; Item."Dampener Period")
                {
                }
                fieldelement(DampenerQty; Item."Dampener Quantity")
                {
                }
                fieldelement(OverflLevel; Item."Overflow Level")
                {
                }
                fieldelement(ManfCode; Item."Manufacturer Code")
                {
                }
                fieldelement(ItemCatCode; Item."Item Category Code")
                {
                }
                fieldelement(CreatedFromNonStock; Item."Created From Nonstock Item")
                {
                }
                fieldelement(ServiceItemGrp; Item."Service Item Group")
                {
                }
                fieldelement(ItemTrackCode; Item."Item Tracking Code")
                {
                }
                fieldelement(LotNos; Item."Lot Nos.")
                {
                }
                fieldelement(ExpCalc; Item."Expiration Calculation")
                {
                }
                fieldelement(SpecialEquipCode; Item."Special Equipment Code")
                {
                }
                fieldelement(PutAwayTempCode; Item."Put-away Template Code")
                {
                }
                fieldelement(PutAwayUnitOfMea; Item."Put-away Unit of Measure Code")
                {
                }
                fieldelement(PhusInvCountingPer; Item."Phys Invt Counting Period Code")
                {
                }
                fieldelement(LastCountingPerUp; Item."Last Counting Period Update")
                {
                }
                fieldelement(UseCrossDoc; Item."Use Cross-Docking")
                {
                }
                fieldelement(NextCountStartDate; Item."Next Counting Start Date")
                {
                }
                fieldelement(NextCountEndDate; Item."Next Counting End Date")
                {
                }
                fieldelement(EMSLicense; Item."Enter Security for Eicard on")
                {
                }
                fieldelement(NoTariffCode; Item."No Tariff Code")
                {
                }
                fieldelement(HqModelPhase; Item."HQ Model Phase")
                {
                }
                fieldelement(LengthCm; Item."Length (cm)")
                {
                }
                fieldelement(WidthCm; Item."Width (cm)")
                {
                }
                fieldelement(HeightCm; Item."Height (cm)")
                {
                }
                fieldelement(VolumeCm3; Item."Volume (cm3)")
                {
                }
                fieldelement(Status; Item.Status)
                {
                }
                fieldelement(WarrentyPeriod; Item."Warranty Period")
                {
                }
                fieldelement(EndOfLifeDate; Item."End of Life Date")
                {
                }
                fieldelement(Cat4Code; Item."Category 4 Code")
                {
                }
                fieldelement(ModelID; Item."Model ID")
                {
                }
                fieldelement(PalletLengthCm; Item."Pallet Length (cm)")
                {
                }
                fieldelement(PalletWidthCm; Item."Pallet Width (cm)")
                {
                }
                fieldelement(PalletHeightCm; Item."Pallet Height (cm)")
                {
                }
                fieldelement(EndOfTechSup; Item."End of Technical Support Date")
                {
                }
                fieldelement(EndOfRmaDate; Item."End of RMA Date")
                {
                }
                fieldelement(ManOlap; Item."Manually OLAP")
                {
                }
                fieldelement(BusinessUnit; Item."Business Unit")
                {
                }
                fieldelement(RmaCat; Item."RMA Category")
                {
                }
                fieldelement(RmaCount; Item."RMA count")
                {
                }
                fieldelement(DefectService; Item."Defect service")
                {
                }
                fieldelement(ModuleRepair; Item."Module Repair")
                {
                }
                fieldelement(PchErrorRepair; Item."PCB error repair")
                {
                }
                fieldelement(RefurbishCost; Item."Refurbish Cost")
                {
                }
                fieldelement(RepairCost; Item."Repair Cost")
                {
                }
                fieldelement(RmaVendorCost; Item."RMA Vendor Cost")
                {
                }
                fieldelement(NumberPrParcel; Item."Number per parcel")
                {
                }
                fieldelement(Overpack; Item.Overpack)
                {
                }
                fieldelement(PaperWeight; Item."Paper Weight")
                {
                }
                fieldelement(PlasticWeight; Item."Plastic Weight")
                {
                }
                fieldelement(AddContentWeight; Item."Additional Content Weight")
                {
                }
                fieldelement(WebDescript; Item."Web Description")
                {
                }
                fieldelement(ShowInWeb; Item."Show In Web")
                {
                }
                fieldelement(UpdateAllIn; Item.UpdateAllIn)
                {
                }
                fieldelement(UnCode; Item."UN Code")
                {
                }
                fieldelement(MDM; Item.MDM)
                {
                }
                fieldelement(SCM; Item.SCM)
                {
                }
                fieldelement(BatteryWeight; Item."Battery weight")
                {
                }
                fieldelement(CartonWeight; Item."Carton Weight")
                {
                }
                fieldelement(PartNoType; Item."Part Number Type")
                {
                }
                fieldelement(BlockOnSalesOrder; Item."Block on Sales Order")
                {
                }
                fieldelement(PPProdCat; Item."PP-Product CAT")
                {
                }
                fieldelement(Inactive; Item.Inactive)
                {
                }
                fieldelement(NonZyxelLicense; Item."Non ZyXEL License")
                {
                }
                fieldelement(NonZyxelLicVendor; Item."Non ZyXEL License Vendor")
                {
                }
                fieldelement(IsEiCard; Item.IsEICard)
                {
                }
                fieldelement(BlockedReason; Item."Block Reason")
                {
                }
                fieldelement(DimPrUnitLx; Item."Dim Per Unit LxWxH")
                {
                }
                fieldelement(WeithtPrUnit; Item."Weight Per Unit")
                {
                }
                fieldelement(DimPerCartonLx; Item."Dim Per Carton LxWxH")
                {
                }
                fieldelement(WeightPrCarton; Item."Weight p_Carton")
                {
                }
                textelement(SuccItemNo)
                {
                    trigger OnBeforePassVariable()
                    var
                        ItemSubst: Record "Item Substitution";
                    begin
                        ItemSubst.SetRange("Type", Item.Type);
                        ItemSubst.SetRange("No.", Item."No.");
                        ItemSubst.SetRange("Substitute Type", Item.Type);

                        if ItemSubst.FindFirst() then
                            SuccItemNo := ItemSubst."Substitute No.";
                    end;
                }
                fieldelement(CartPrPallet; Item."Cartons Per Pallet")
                {
                }
                fieldelement(GTIN; Item.GTIN)
                {
                }
                fieldelement(SerialNoReq; Item."Serial Number Required")
                {
                }
                fieldelement(LengthCtn; Item."Length (ctn)")
                {
                }
                fieldelement(WidthCtn; Item."Width (ctn)")
                {
                }
                fieldelement(HeightCtn; Item."Height (ctn)")
                {
                }
                fieldelement(VolumeCtn; Item."Volume (ctn)")
                {
                }
                fieldelement(NumberPrCarton; Item."Number per carton")
                {
                }
                fieldelement(LastOrderDate; Item."Last Order Date")
                {
                }
                fieldelement(QtyPrPallet; Item."Qty Per Pallet")
                {
                }
                fieldelement(BusinessTo; Item."Business to")
                {
                }
                fieldelement(AddBromWgtPcb; Item."Add Bromine Wgt. PCB")
                {
                }
                fieldelement(AddChlWgtPcb; Item."Add Chlorine Wgt. PCB")
                {
                }
                fieldelement(AddPhoWgtPcb; Item."Add Phos. Wgt. PCB")
                {
                }
                fieldelement(AddBomWgtPlastic; Item."Add Bromine Wgt. Plastic Part")
                {
                }
                fieldelement(AddChoWgtPlastic; Item."Add Chlorine Wgt. Plastic Part")
                {
                }
                fieldelement(AddPhoWgtPlastic; Item."Add Phos. Wgt. Plastic Part")
                {
                }
                fieldelement(ReaBroWgtBcb; Item."Reac Bromine Wgt. PCB")
                {
                }
                fieldelement(ReaChlWgtPcb; Item."Reac Chlorine Wgt. PCB")
                {
                }
                fieldelement(ReaPhoWgtPcb; Item."Reac Phos. Wgt. PCB")
                {
                }
                fieldelement(ReaBroWgtPlastic; Item."Reac Bromine Wgt. Plastic Part")
                {
                }
                fieldelement(ReaChlWftPlastic; Item."Reac Chlorine Wgt. Plas. Part")
                {
                }
                fieldelement(ReaPhoWftPlastic; Item."Reac Phos. Wgt. Plastic Part")
                {
                }
                fieldelement(TaxRateSekKg; Item."Tax rate (SEK/kg)")
                {
                }
                fieldelement(TotalChemicalTax; Item."Total Chemical Tax")
                {
                }
                fieldelement(TaxRedRate; Item."Tax Reduction rate")
                {
                }
                fieldelement(Cat1Code; Item."Category 1 Code")
                {
                }
                fieldelement(Cat2Code; Item."Category 2 Code")
                {
                }
                fieldelement(Cat3Code; Item."Category 3 Code")
                {
                }
                fieldelement(BusinessCenter; Item."Business Center")
                {
                }
                fieldelement(SBU; Item.SBU)
                {
                }
                fieldelement(NoPlmsUpdate; Item."No PLMS Update")
                {
                }
                fieldelement(RoutingNo; Item."Routing No.")
                {
                }
                fieldelement(ProductionBomNo; Item."Production BOM No.")
                {
                }
                fieldelement(SingelLevelMatCost; Item."Single-Level Material Cost")
                {
                }
                fieldelement(SingelLevelCapCost; Item."Single-Level Capacity Cost")
                {
                }
                fieldelement(SingelLevelSubcontrd; Item."Single-Level Subcontrd. Cost")
                {
                }
                fieldelement(SingleLevelCapOvhd; Item."Single-Level Cap. Ovhd Cost")
                {
                }
                fieldelement(SingleLevelMfgOvhd; Item."Single-Level Mfg. Ovhd Cost")
                {
                }
                fieldelement(OverheadRate; Item."Overhead Rate")
                {
                }
                fieldelement(RolledUpSubc; Item."Rolled-up Subcontracted Cost")
                {
                }
                fieldelement(RolledupMfgOvhdCost; Item."Rolled-up Mfg. Ovhd Cost")
                {
                }
                fieldelement(RolledUpCapOverh; Item."Rolled-up Cap. Overhead Cost")
                {
                }
                fieldelement(OrderTrackingPolicy; Item."Order Tracking Policy")
                {
                }
                fieldelement(Critical; Item.Critical)
                {
                }
                fieldelement(CommonItemNo; Item."Common Item No.")
                {
                }
                fieldelement(ProductLengthCm; Item."Product Length (cm)")
                {
                }
                fieldelement(StatisticsGroupCode; Item."Statistics Group Code")
                {
                }
                /*fieldelement(Type; Item.Type)  // 28-01-24 ZY-LD 006
                {
                }*/
                tableelement("Default Dimension"; "Default Dimension")
                {
                    MinOccurs = Zero;
                    XmlName = 'Dimension';
                    SourceTableView = where("Table ID" = const(27));
                    UseTemporary = true;
                    fieldelement(TableID; "Default Dimension"."Table ID")
                    {
                    }
                    fieldelement(DimNo; "Default Dimension"."No.")
                    {
                    }
                    fieldelement(DimCode; "Default Dimension"."Dimension Code")
                    {
                    }
                    fieldelement(DimValueCode; "Default Dimension"."Dimension Value Code")
                    {
                    }
                    fieldelement(ValuePosting; "Default Dimension"."Value Posting")
                    {
                    }
                    fieldelement(MultiSelectAction; "Default Dimension"."Multi Selection Action")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Default Dimension".SetRange("Table ID", 27);
                        "Default Dimension".SetRange("No.", Item."No.");
                    end;
                }
                tableelement("Item Unit of Measure"; "Item Unit of Measure")
                {
                    MinOccurs = Zero;
                    XmlName = 'ItemUnitOfMeasure';
                    UseTemporary = true;
                    fieldelement(UmItemNo; "Item Unit of Measure"."Item No.")
                    {
                    }
                    fieldelement(UmCode; "Item Unit of Measure".Code)
                    {
                    }
                    fieldelement(UmQtyPrUnit; "Item Unit of Measure"."Qty. per Unit of Measure")
                    {
                    }
                    fieldelement(UmLength; "Item Unit of Measure".Length)
                    {
                    }
                    fieldelement(UmWidth; "Item Unit of Measure".Width)
                    {
                    }
                    fieldelement(UmHeight; "Item Unit of Measure".Height)
                    {
                    }
                    fieldelement(UmCubage; "Item Unit of Measure".Cubage)
                    {
                    }
                    fieldelement(UmWeight; "Item Unit of Measure".Weight)
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Item Unit of Measure".SetRange("Item No.", Item."No.");
                    end;
                }
                tableelement("Sales Price"; "Price List Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'SalesPrice';
                    UseTemporary = true;
                    fieldelement(SpPriceListCode; "Sales Price"."Price List Code")
                    {
                    }
                    fieldelement(SpLineNo; "Sales Price"."Line No.")
                    {
                    }
                    fieldelement(SpSalesType; "Sales Price"."Source Type")
                    {
                    }
                    fieldelement(SpSourceNo; "Sales Price"."Source No.")
                    {
                    }
                    fieldelement(SpParentSourceNo; "Sales Price"."Parent Source No.")
                    {
                    }
                    fieldelement(SpAssertType; "Sales Price"."Asset Type")
                    {
                    }
                    fieldelement(SpAssetNo; "Sales Price"."Asset No.")
                    {
                    }
                    fieldelement(SpVariantCode; "Sales Price"."Variant Code")
                    {
                    }
                    fieldelement(SpCurrencyCode; "Sales Price"."Currency Code")
                    {
                    }
                    fieldelement(SpWorkTypeCode; "Sales Price"."Work Type Code")
                    {
                    }
                    fieldelement(SpStartingDate; "Sales Price"."Starting Date")
                    {
                    }
                    fieldelement(SpEndingDate; "Sales Price"."Ending Date")
                    {
                    }
                    fieldelement(SpMinQty; "Sales Price"."Minimum Quantity")
                    {
                    }
                    fieldelement(SpUnitOfMeasureCode; "Sales Price"."Unit of Measure Code")
                    {
                    }
                    fieldelement(SpAmountType; "Sales Price"."Amount Type")
                    {
                    }
                    fieldelement(SpUnitPrice; "Sales Price"."Unit Price")
                    {
                    }
                    fieldelement(SpCostFactor; "Sales Price"."Cost Factor")
                    {
                    }
                    fieldelement(SpUnitCost; "Sales Price"."Unit Cost")
                    {
                    }
                    fieldelement(SpLineDiscPct; "Sales Price"."Line Discount %")
                    {
                    }
                    fieldelement(SpAllowLineDisc; "Sales Price"."Allow Line Disc.")
                    {
                    }
                    fieldelement(SpAllowInvDisc; "Sales Price"."Allow Invoice Disc.")
                    {
                    }
                    fieldelement(SpPriceInclVat; "Sales Price"."Price Includes VAT")
                    {
                    }
                    fieldelement(SpVatBusPostGrp; "Sales Price"."VAT Bus. Posting Gr. (Price)")
                    {
                    }
                    fieldelement(SpVatProdPostGrp; "Sales Price"."VAT Prod. Posting Group")
                    {
                    }
                    fieldelement(SpLineAmount; "Sales Price"."Line Amount")
                    {
                    }
                    fieldelement(SpPriceType; "Sales Price"."Price Type")
                    {
                    }
                    fieldelement(SpDescription; "Sales Price".Description)
                    {
                    }
                    fieldelement(SpStatus; "Sales Price".Status)
                    {
                    }
                    fieldelement(SpDirectUnitCost; "Sales Price"."Direct Unit Cost")
                    {
                    }
                    fieldelement(SpSourceGroup; "Sales Price"."Source Group")
                    {
                    }
                    fieldelement(SpProductNo; "Sales Price"."Product No.")
                    {
                    }
                    fieldelement(SpAssignToNo; "Sales Price"."Assign-to No.")
                    {
                    }
                    fieldelement(SpAssignToParentNo; "Sales Price"."Assign-to Parent No.")
                    {
                    }
                    fieldelement(SpVariantCodeLookup; "Sales Price"."Variant Code Lookup")
                    {
                    }
                    fieldelement(SpUnitOfMeasureCodeLookup; "Sales Price"."Unit of Measure Code Lookup")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Sales Price".SetFilter("Source Type", '<%1', "Sales Price"."Source Type"::"All Vendors");
                        "Sales Price".SetRange("Asset Type", "Sales Price"."Asset Type"::Item);
                        "Sales Price".SetRange("Asset No.", Item."No.");
                    end;
                }
                tableelement("Item Identifier"; "Item Identifier")
                {
                    LinkFields = "Item No." = field("No.");
                    LinkTable = Item;
                    MinOccurs = Zero;
                    XmlName = 'ItemIdentifier';
                    SourceTableView = sorting("Item No.", "Variant Code", "Unit of Measure Code");
                    UseTemporary = true;
                    fieldelement(IdCode; "Item Identifier".ExtendedCodeZX)
                    {
                    }
                    fieldelement(IdItemNo; "Item Identifier"."Item No.")
                    {
                    }
                    fieldelement(IdVariantCode; "Item Identifier"."Variant Code")
                    {
                    }
                    fieldelement(IdUoM; "Item Identifier"."Unit of Measure Code")
                    {
                    }
                }
            }
            tableelement("Unit of Measure"; "Unit of Measure")
            {
                MinOccurs = Zero;
                XmlName = 'UnitOfMeasure';
                UseTemporary = true;
                fieldelement(UomCode; "Unit of Measure".Code)
                {
                }
                fieldelement(UomDescript; "Unit of Measure".Description)
                {
                }
                fieldelement(UomInternat; "Unit of Measure"."International Standard Code")
                {
                }
            }
            tableelement("Gen. Product Posting Group"; "Gen. Product Posting Group")
            {
                MinOccurs = Zero;
                XmlName = 'GenProdPostGrp';
                UseTemporary = true;
                fieldelement(GpgCode; "Gen. Product Posting Group".Code)
                {
                }
                fieldelement(GpgDescription; "Gen. Product Posting Group".Description)
                {
                }
                fieldelement(GpgDefVatProdPostGrp; "Gen. Product Posting Group"."Def. VAT Prod. Posting Group")
                {
                }
                fieldelement(GpgAutoInsert; "Gen. Product Posting Group"."Auto Insert Default")
                {
                }
            }
            tableelement("General Posting Setup"; "General Posting Setup")
            {
                MinOccurs = Zero;
                XmlName = 'GenPostSetup';
                UseTemporary = true;
                fieldelement(GpsGenBusPostGrp; "General Posting Setup"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(GpsGenProdPostGrp; "General Posting Setup"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(GpsSalesAcc; "General Posting Setup"."Sales Account")
                {
                }
                fieldelement(GpsSalesLineDisc; "General Posting Setup"."Sales Line Disc. Account")
                {
                }
                fieldelement(GpsSalesInvDisc; "General Posting Setup"."Sales Inv. Disc. Account")
                {
                }
                fieldelement(GpsSalesPmtDisc; "General Posting Setup"."Sales Pmt. Disc. Debit Acc.")
                {
                }
                fieldelement(GpsPurchAcc; "General Posting Setup"."Purch. Account")
                {
                }
                fieldelement(GpsPurchLineDisc; "General Posting Setup"."Purch. Line Disc. Account")
                {
                }
                fieldelement(GpsPurchInvDisc; "General Posting Setup"."Purch. Inv. Disc. Account")
                {
                }
                fieldelement(GpsPurchPmtDisc; "General Posting Setup"."Purch. Pmt. Disc. Credit Acc.")
                {
                }
                fieldelement(GpsCogsAcc; "General Posting Setup"."COGS Account")
                {
                }
                fieldelement(GpsInvAdjAcc; "General Posting Setup"."Inventory Adjmt. Account")
                {
                }
                fieldelement(GpsSalesCrMemoAcc; "General Posting Setup"."Sales Credit Memo Account")
                {
                }
                fieldelement(GpsPurchCrMemoAcc; "General Posting Setup"."Purch. Credit Memo Account")
                {
                }
                fieldelement(GpsSalesPmtCredAcc; "General Posting Setup"."Sales Pmt. Disc. Credit Acc.")
                {
                }
                fieldelement(GpsPurchPmdDebAcc; "General Posting Setup"."Purch. Pmt. Disc. Debit Acc.")
                {
                }
                fieldelement(GpsSalesPmtDebAcc; "General Posting Setup"."Sales Pmt. Tol. Debit Acc.")
                {
                }
                fieldelement(GpsSalesPmtTolCreditAcc; "General Posting Setup"."Sales Pmt. Tol. Credit Acc.")
                {
                }
                fieldelement(GpsPurchPmtTolDebAcc; "General Posting Setup"."Purch. Pmt. Tol. Debit Acc.")
                {
                }
                fieldelement(GpsPurchPmtTolCreditAcc; "General Posting Setup"."Purch. Pmt. Tol. Credit Acc.")
                {
                }
                fieldelement(GpsSalesPrePayAcc; "General Posting Setup"."Sales Prepayments Account")
                {
                }
                fieldelement(GpsPurchPrePayAcc; "General Posting Setup"."Purch. Prepayments Account")
                {
                }
                fieldelement(GpsPurchFaDiscAcc; "General Posting Setup"."Purch. FA Disc. Account")
                {
                }
                fieldelement(GpsInvAccAccInterim; "General Posting Setup"."Invt. Accrual Acc. (Interim)")
                {
                }
                fieldelement(GpsCogsAccInterim; "General Posting Setup"."COGS Account (Interim)")
                {
                }
                fieldelement(GpsDirCostAppAcc; "General Posting Setup"."Direct Cost Applied Account")
                {
                }
                fieldelement(GpsOverhAppAcc; "General Posting Setup"."Overhead Applied Account")
                {
                }
                fieldelement(GpsPurchVariAcc; "General Posting Setup"."Purchase Variance Account")
                {
                }
            }
            tableelement("VAT Product Posting Group"; "VAT Product Posting Group")
            {
                MinOccurs = Zero;
                XmlName = 'VatProdPostGrp';
                UseTemporary = true;
                fieldelement(VpgCode; "VAT Product Posting Group".Code)
                {
                }
                fieldelement(VpgDescription; "VAT Product Posting Group".Description)
                {
                }
            }
            tableelement("VAT Posting Setup"; "VAT Posting Setup")
            {
                MinOccurs = Zero;
                XmlName = 'VatPostSetup';
                UseTemporary = true;
                fieldelement(VpsVatBusPostGrp; "VAT Posting Setup"."VAT Bus. Posting Group")
                {
                }
                fieldelement(VpsVatProdPostGrp; "VAT Posting Setup"."VAT Prod. Posting Group")
                {
                }
                fieldelement(VpsVatCalcType; "VAT Posting Setup"."VAT Calculation Type")
                {
                }
                fieldelement(VpsVatPct; "VAT Posting Setup"."VAT %")
                {
                }
                fieldelement(VpsUnrealVatType; "VAT Posting Setup"."Unrealized VAT Type")
                {
                }
                fieldelement(VpsAdjPayDisc; "VAT Posting Setup"."Adjust for Payment Discount")
                {
                }
                fieldelement(VpsSalesVatAcc; "VAT Posting Setup"."Sales VAT Account")
                {
                }
                fieldelement(VpsSalesVatUnrealAcc; "VAT Posting Setup"."Sales VAT Unreal. Account")
                {
                }
                fieldelement(VpsPurchVatAcc; "VAT Posting Setup"."Purchase VAT Account")
                {
                }
                fieldelement(VpsPurchVatUnrealAcc; "VAT Posting Setup"."Purch. VAT Unreal. Account")
                {
                }
                fieldelement(VpsRevCngVatAcc; "VAT Posting Setup"."Reverse Chrg. VAT Acc.")
                {
                }
                fieldelement(VpsRevCngVatUnrealAcc; "VAT Posting Setup"."Reverse Chrg. VAT Unreal. Acc.")
                {
                }
                fieldelement(VpsVatIdentifier; "VAT Posting Setup"."VAT Identifier")
                {
                }
                fieldelement(VpsEuService; "VAT Posting Setup"."EU Service")
                {
                }
                fieldelement(VpsClauseCode; "VAT Posting Setup"."VAT Clause Code")
                {
                }
                fieldelement(VpsCertifSupplyReq; "VAT Posting Setup"."Certificate of Supply Required")
                {
                }
                fieldelement(VpsTaxCategory; "VAT Posting Setup"."Tax Category")
                {
                }
                fieldelement(VpsEuArticle; "VAT Posting Setup"."EU Article Code")
                {
                }
            }
            tableelement("Inventory Posting Group"; "Inventory Posting Group")
            {
                MinOccurs = Zero;
                XmlName = 'InvPostGrp';
                UseTemporary = true;
                fieldelement(IpgCode; "Inventory Posting Group".Code)
                {
                }
                fieldelement(IpgDescription; "Inventory Posting Group".Description)
                {
                }
            }
            tableelement("Inventory Posting Setup"; "Inventory Posting Setup")
            {
                MinOccurs = Zero;
                XmlName = 'InvPostSetup';
                UseTemporary = true;
                fieldelement(IpsLocation; "Inventory Posting Setup"."Location Code")
                {
                }
                fieldelement(IpsInvPostGrpcode; "Inventory Posting Setup"."Invt. Posting Group Code")
                {
                }
                fieldelement(IpsInvAcc; "Inventory Posting Setup"."Inventory Account")
                {
                }
                fieldelement(IpsInvAccInterim; "Inventory Posting Setup"."Inventory Account (Interim)")
                {
                }
                fieldelement(IpsWipAcc; "Inventory Posting Setup"."WIP Account")
                {
                }
                fieldelement(IpsMatVarAcc; "Inventory Posting Setup"."Material Variance Account")
                {
                }
                fieldelement(IpsCapVarAcc; "Inventory Posting Setup"."Capacity Variance Account")
                {
                }
                fieldelement(IpsOverVarAcc; "Inventory Posting Setup"."Mfg. Overhead Variance Account")
                {
                }
                fieldelement(IpsCapOverVarAcc; "Inventory Posting Setup"."Cap. Overhead Variance Account")
                {
                }
                fieldelement(IpsSubconVarAcc; "Inventory Posting Setup"."Subcontracted Variance Account")
                {
                }
            }
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

    var
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetData(pCompany: Text; pItemNoFilter: Text; pReplicateDummy: Boolean; pForceReplication: Boolean): Boolean
    var
        recItem: Record Item;
        recItemUOM: Record "Item Unit of Measure";
        recDefDim: Record "Default Dimension";
        recGenProdPostGrp: Record "Gen. Product Posting Group";
        recGenPostSetup: Record "General Posting Setup";
        recVatProdPostGrp: Record "VAT Product Posting Group";
        recVatPostSetup: Record "VAT Posting Setup";
        recInvPostGrp: Record "Inventory Posting Group";
        recInvPostSetup: Record "Inventory Posting Setup";
        recUnitofMeasure: Record "Unit of Measure";
        recSalesPrice: Record "Price List Line";
        recSalesPriceRep: Record "Price List Line Replicated";
        recRepCompany: Record "Replication Company";
        recItemIdent: Record "Item Identifier";
        CompanyRegionFilter: Text[100];
    begin
        if pReplicateDummy then begin
            recItem.SetFilter("No.", 'DMY*');
        end else begin
            if recRepCompany.Get(pCompany) and
               not pForceReplication  // 01-01-19 ZY-LD 005
            then begin
                recRepCompany.TestField("Country/Region Code");
                //recItem.SETRANGE("Date Filter",CALCDATE('<-1Y>',TODAY),TODAY);  // 06-11-18 ZY-LD 003  // 13-12-18 ZY-LD 004
                recItem.SetFilter("Date Filter", '%1..', CalcDate('<-1Y>', Today));  // 13-12-18 ZY-LD 004
                CompanyRegionFilter := recRepCompany."Country/Region Code";
                recItem.SetFilter("Country/Region Filter", CompanyRegionFilter);
                recItem.SetRange("Country/Region Exists", true);
            end;

            if pItemNoFilter <> '' then
                recItem.SetFilter("No.", pItemNoFilter)
            else
                recItem.SetRange(Inactive, false);
        end;

        if recItem.FindSet() then begin
            ZGT.OpenProgressWindow('', recItem.Count());

            repeat
                ZGT.UpdateProgressWindow(recItem."No.", 0, true);

                Item := recItem;
                Item.Insert();

                recItemUOM.SetRange("Item No.", recItem."No.");
                if recItemUOM.FindSet() then
                    repeat
                        if recItemUOM.Code <> '' then begin
                            if not "Unit of Measure".Get(recItemUOM.Code) then begin
                                recUnitofMeasure.Get(recItemUOM.Code);
                                "Unit of Measure" := recUnitofMeasure;
                                "Unit of Measure".Insert();
                            end;

                            "Item Unit of Measure" := recItemUOM;
                            "Item Unit of Measure".Insert();
                        end;
                    until recItemUOM.Next() = 0;

                recDefDim.SetRange("Table ID", Database::Item);
                recDefDim.SetRange("No.", recItem."No.");
                if recDefDim.FindFirst() then
                    repeat
                        "Default Dimension" := recDefDim;
                        "Default Dimension".Insert();
                    until recDefDim.Next() = 0;

                if Item."Gen. Prod. Posting Group" <> '' then
                    if not "Gen. Product Posting Group".Get(Item."Gen. Prod. Posting Group") then begin
                        recGenProdPostGrp.Get(Item."Gen. Prod. Posting Group");
                        "Gen. Product Posting Group" := recGenProdPostGrp;
                        "Gen. Product Posting Group".Insert();

                        recGenPostSetup.SetRange("Gen. Bus. Posting Group", Item."Gen. Prod. Posting Group");
                        if recGenPostSetup.FindSet() then
                            repeat
                                "General Posting Setup" := recGenPostSetup;
                                "General Posting Setup".Insert();
                            until recGenPostSetup.Next() = 0;
                    end;

                if Item."VAT Prod. Posting Group" <> '' then
                    if not "VAT Product Posting Group".Get(Item."VAT Prod. Posting Group") then begin
                        recVatProdPostGrp.Get(Item."VAT Prod. Posting Group");
                        "VAT Product Posting Group" := recVatProdPostGrp;
                        "VAT Product Posting Group".Insert();

                        recVatPostSetup.SetRange("VAT Bus. Posting Group", Item."VAT Prod. Posting Group");
                        if recVatPostSetup.FindSet() then
                            repeat
                                "VAT Posting Setup" := recVatPostSetup;
                                "VAT Posting Setup".Insert();
                            until recVatPostSetup.Next() = 0;
                    end;

                if Item."Inventory Posting Group" <> '' then
                    if not "Inventory Posting Group".Get(Item."Inventory Posting Group") then begin
                        recInvPostGrp.Get(Item."Inventory Posting Group");
                        "Inventory Posting Group" := recInvPostGrp;
                        "Inventory Posting Group".Insert();

                        recInvPostSetup.SetRange("Invt. Posting Group Code", recInvPostGrp.Code);
                        if recInvPostSetup.FindSet() then
                            repeat
                                "Inventory Posting Setup" := recInvPostSetup;
                                "Inventory Posting Setup".Insert();
                            until recInvPostSetup.Next() = 0;
                    end;

                recSalesPrice.SetRange("Asset Type", recSalesPrice."Asset Type"::Item);
                recSalesPrice.SetRange("Asset No.", recItem."No.");
                if recSalesPrice.FindSet() then
                    repeat
                        if not
                          recSalesPriceRep.Get(
                            recSalesPrice."Price List Code",
                            recSalesPrice."Line No.")
                          then begin
                            "Sales Price" := recSalesPrice;
                            "Sales Price".Insert();

                            recSalesPriceRep.TransferFields("Sales Price");
                            recSalesPriceRep."Company Name" := pCompany;
                            recSalesPriceRep.Insert();
                        end;
                    until recSalesPrice.Next() = 0;

                //>> 31-03-20 ZY-LD 006
                recItemIdent.SetRange("Item No.", recItem."No.");
                if recItemIdent.FindSet() then
                    repeat
                        "Item Identifier" := recItemIdent;
                        "Item Identifier".Insert();
                    until recItemIdent.Next() = 0;
            //<< 31-03-20 ZY-LD 006
            until recItem.Next() = 0;

            ZGT.CloseProgressWindow;
        end;

        exit(Item.Count() > 0);
    end;


    procedure ReplicateData()
    var
        recItem: Record Item;
        recItemKeepValues: Record Item;
        recDefDim: Record "Default Dimension";
        recItemUOM: Record "Item Unit of Measure";
        recGenProdPostGrp: Record "Gen. Product Posting Group";
        recGenPostSetup: Record "General Posting Setup";
        recVatProdPostGrp: Record "VAT Product Posting Group";
        recVatPostSetup: Record "VAT Posting Setup";
        recInvPostGrp: Record "Inventory Posting Group";
        recInvPostSetup: Record "Inventory Posting Setup";
        recUnitofMeasure: Record "Unit of Measure";
        recSalesPrice: Record "Price List Line";
        recItemIdent: Record "Item Identifier";
    begin
        if Item.FindSet() then
            repeat
                if recItem.Get(Item."No.") then begin
                    recItemKeepValues := recItem;
                    recItem := Item;
                    if recItemKeepValues."No." <> '' then begin
                        recItem."Cost is Adjusted" := recItemKeepValues."Cost is Adjusted";
                        recItem."Unit Cost" := recItemKeepValues."Unit Cost";  // 23-10-18 ZY-LD 002
                        recItem."Last Direct Cost" := recItemKeepValues."Last Direct Cost";  // 23-10-18 ZY-LD 002
                    end;
                    recItem.Modify();
                end else begin
                    recItem := Item;
                    recItem.Insert();
                end;

                // Default Dimensions
                recDefDim.SetRange("Table ID", Database::Item);
                recDefDim.SetRange("No.", Item."No.");
                //>> 04-06-24 ZY-LD 007
                //recDefDim.DeleteAll();
                if recDefDim.FindSet then
                    repeat
                        "Default Dimension".SetRange("No.", Item."No.");
                        "Default Dimension".SetRange("Dimension Code", recDefDim."Dimension Code");
                        if not "Default Dimension".FindFirst then
                            recDefDim.Delete(true);
                    until recDefDim.Next = 0;
                //<< 04-06-24 ZY-LD 007
                recDefDim.Reset();

                "Default Dimension".Reset();
                "Default Dimension".SetRange("No.", Item."No.");
                if "Default Dimension".FindSet() then
                    repeat
                        recDefDim := "Default Dimension";
                        if not recDefDim.Modify(true) then  // 04-06-24 ZY-LD 007
                            recDefDim.Insert();
                    until "Default Dimension".Next() = 0;

                // Item Unit of Measure
                //>> 04-06-24 ZY-LD 007
                /*recItemUOM.SetRange("Item No.", Item."No.");
                recItemUOM.DeleteAll();
                recItemUOM.Reset();*/
                //<< 04-06-24 ZY-LD 007

                "Item Unit of Measure".SetRange("Item No.", Item."No.");
                if "Item Unit of Measure".FindSet() then
                    repeat
                        recItemUOM := "Item Unit of Measure";
                        if not recItemUOM.Insert(true) then;  // 04-06-24 ZY-LD 007 - If is added.
                    until "Item Unit of Measure".Next() = 0;

                "Sales Price".SetRange("Asset Type", "Sales Price"."Asset Type"::Item);
                "Sales Price".SetRange("Asset No.", Item."No.");
                if "Sales Price".FindSet() then
                    repeat
                        if not
                          recSalesPrice.Get(
                            "Sales Price"."Price List Code",
                            "Sales Price"."Line No.")
                          then begin
                            recSalesPrice := "Sales Price";
                            recSalesPrice.Insert();
                        end;
                    until "Sales Price".Next() = 0;

            //>> 04-06-24 ZY-LD 007 - Code has moved outside the item loop.
            //>> 31-03-20 ZY-LD 006
            /*recItemIdent.SetRange("Item No.", Item."No.");
            recItemIdent.DeleteAll(true);

            "Item Identifier".SetRange("Item No.", Item."No.");
            if "Item Identifier".FindSet() then begin
                recItemIdent.SetRange("Item No.", Item."No.");
                recItemIdent.DeleteAll(true);

                repeat
                    recItemIdent := "Item Identifier";
                    recItemIdent.Insert(true);
                until "Item Identifier".Next() = 0;
            end;*/
            //<< 31-03-20 ZY-LD 006
            //<< 04-06-24 ZY-LD 007
            until Item.Next() = 0;

        //>> 04-06-24 ZY-LD 007
        if recItemIdent.FindSet then
            repeat
                if not "Item Identifier".get(recItemIdent.code) then
                    recItemIdent.Delete(true);
            until recItemIdent.Next = 0;

        if "Item Identifier".FindSet() then
            repeat
                recItemIdent := "Item Identifier";
                if not recItemIdent.Modify(true) then
                    recItemIdent.Insert(true);
            until "Item Identifier".Next() = 0;
        //<< 04-06-24 ZY-LD 007

        if "Gen. Product Posting Group".FindSet() then
            repeat
                if not recGenProdPostGrp.Get("Gen. Product Posting Group".Code) then begin
                    recGenProdPostGrp.Code := "Gen. Product Posting Group".Code;
                    recGenProdPostGrp.Description := "Gen. Product Posting Group".Description;
                    recGenProdPostGrp.Insert();
                end;
            until "Gen. Product Posting Group".Next() = 0;

        if "General Posting Setup".FindSet() then
            repeat
                if not recGenPostSetup.Get("General Posting Setup"."Gen. Bus. Posting Group", "General Posting Setup"."Gen. Prod. Posting Group") then begin
                    recGenPostSetup."Gen. Bus. Posting Group" := "General Posting Setup"."Gen. Bus. Posting Group";
                    recGenPostSetup."Gen. Prod. Posting Group" := "General Posting Setup"."Gen. Prod. Posting Group";
                    recGenPostSetup.Insert();
                end;
            until "General Posting Setup".Next() = 0;

        if "VAT Product Posting Group".FindSet() then
            repeat
                if not recVatProdPostGrp.Get("VAT Product Posting Group".Code) then begin
                    recVatProdPostGrp := "VAT Product Posting Group";
                    recVatProdPostGrp.Insert();
                end;
            until "VAT Product Posting Group".Next() = 0;

        if "VAT Posting Setup".FindSet() then
            repeat
                if not recVatPostSetup.Get("VAT Posting Setup"."VAT Bus. Posting Group", "VAT Posting Setup"."VAT Prod. Posting Group") then begin
                    recVatPostSetup."VAT Bus. Posting Group" := "VAT Posting Setup"."VAT Bus. Posting Group";
                    recVatPostSetup."VAT Prod. Posting Group" := "VAT Posting Setup"."VAT Prod. Posting Group";
                    recVatPostSetup.Insert();
                end;
            until "VAT Posting Setup".Next() = 0;

        if "Inventory Posting Group".FindSet() then
            repeat
                if not recInvPostGrp.Get("Inventory Posting Group".Code) then begin
                    recInvPostGrp := "Inventory Posting Group";
                    recInvPostGrp.Insert();
                end;
            until "Inventory Posting Group".Next() = 0;

        if "Inventory Posting Setup".FindSet() then
            repeat
                if not recInvPostSetup.Get("Inventory Posting Setup"."Location Code", "Inventory Posting Setup"."Invt. Posting Group Code") then begin
                    recInvPostSetup."Location Code" := "Inventory Posting Setup"."Location Code";
                    recInvPostSetup."Invt. Posting Group Code" := "Inventory Posting Setup"."Invt. Posting Group Code";
                    recInvPostSetup.Insert();
                end;
            until "Inventory Posting Setup".Next() = 0;

        if "Unit of Measure".FindSet() then
            repeat
                if not recUnitofMeasure.Get("Unit of Measure".Code) then begin
                    recUnitofMeasure := "Unit of Measure";
                    recUnitofMeasure.Insert();
                end;
            until "Unit of Measure".Next() = 0;
    end;


}
