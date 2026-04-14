Page 50205 "Item List API"
{
    //AdditionalSearchTerms = 'product,finished good,component,raw material,assembly item';
    ApplicationArea = All;
    Caption = 'Item List API';
    CardPageID = "Item Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Item List';
    SourceTable = Item;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Caption = 'Item';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a number to identify the item. You can use ranges of item numbers to logically group products or to imply information about them. Or use simple numbers and item categories to group items.';
                }
                field("No. 2"; Rec."No. 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. 2 field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a default text to describe the item on related documents such as orders or invoices. You can translate the descriptions so that they show up in the language of the customer or vendor.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                /*field("Price Unit Conversion"; Rec."Price Unit Conversion")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Unit Conversion field.';
                } */

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item card represents a physical inventory unit (Inventory), a labor time unit (Service), or a physical unit that is not tracked in inventory (Non-Inventory).';
                }
                field(InventoryField; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                }
                field("Created From Nonstock Item"; Rec."Created From Nonstock Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the item was created from a catalog item.';
                }
                field("Substitutes Exist"; Rec."Substitutes Exist")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that a substitute exists for this item.';
                }
                field("Stockkeeping Unit Exists"; Rec."Stockkeeping Unit Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that a stockkeeping unit exists for this item.';
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item is an assembly BOM.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies where to find the item in the warehouse. This is informational only.';
                }
                field("Costing Method"; Rec."Costing Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';
                }
                field("Cost is Adjusted"; Rec."Cost is Adjusted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item''s unit cost has been adjusted, either automatically or manually.';
                }
                field("Standard Cost"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost per unit of the item.';
                }
                field("Last Direct Cost"; Rec."Last Direct Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the most recent direct unit cost that was paid for the item.';
                }
                field("Price/Profit Calculation"; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';
                }
                field("Profit %"; Rec."Profit %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price for one unit of the item, in LCY.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                }
                field("Item Disc. Group"; Rec."Item Disc. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code of who supplies this item by default.';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number that the vendor uses for this item.';
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the item''s tariff number.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a search description that you use to find the item in lists.';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that transactions with the item cannot be posted, for example, because the item is in quarantine.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the item card was last modified.';
                }
                field("Sales Unit of Measure"; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code used when you sell the item.';
                }
                field("Replenishment System"; Rec."Replenishment System")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
                }
                field("Coupled to Dataverse"; Rec."Coupled to Dataverse")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the item is coupled to a product in Dynamics 365 Sales.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Actual FOB Price"; Rec."Actual FOB Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual FOB Price field.';
                }
                field("Add Additional Item"; Rec."Add Additional Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Add Additional Item field.';
                }
                field("Add Bromine Wgt. PCB"; Rec."Add Bromine Wgt. PCB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additive Bromine Weight PCB field.';
                }
                field("Add Bromine Wgt. Plastic Part"; Rec."Add Bromine Wgt. Plastic Part")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additive Bromine Weight Plastic Part field.';
                }
                field("Add Chlorine Wgt. PCB"; Rec."Add Chlorine Wgt. PCB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additive Chlorine Weight PCB field.';
                }
                field("Add Chlorine Wgt. Plastic Part"; Rec."Add Chlorine Wgt. Plastic Part")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additive Chlorine Weight Plastic Part field.';
                }
                field("Add Phos. Wgt. PCB"; Rec."Add Phos. Wgt. PCB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additive  Phosphorus Weight PCB field.';
                }
                field("Add Phos. Wgt. Plastic Part"; Rec."Add Phos. Wgt. Plastic Part")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additive Phosphorus Weight Plastic Part field.';
                }
                field("Additional Content Weight"; Rec."Additional Content Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additional Content Weight (kg) field.';
                }
                field("Aged Country Code"; Rec."Aged Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.';
                }
                field("Allow Online Adjustment"; Rec."Allow Online Adjustment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Online Adjustment field.';
                }
                field("Alternative Item No."; Rec."Alternative Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Alternative Item No. field.';
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that an extended text that you have set up will be added automatically on sales or purchase documents for this item.';
                }
                field("Automatic Purchase Visible Fee"; Rec."Automatic Purchase Visible Fee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Automatic Purchase Visible Fee field.';
                }
                field(B2B; Rec.B2B)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business to Business field.';
                }
                field(B2C; Rec.B2C)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business to Consumer field.';
                }
                field("Battery Certificate"; Rec."Battery Certificate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Battery Certificate field.';
                }
                field("Battery weight"; Rec."Battery weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Battery weight field.';
                }
                field("Block on Sales Order"; Rec."Block on Sales Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked on Sales Order field.';
                }
                field("Block Reason"; Rec."Block Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Block Reason field.';
                }
                field(blockedReason; Rec."Block Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the blockedReason field.';
                }
                field("Budget Profit"; Rec."Budget Profit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget Profit field.';
                }
                field("Budget Quantity"; Rec."Budget Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget Quantity field.';
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field("Business Center"; Rec."Business Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business Center field.';
                }
                field("Business to"; Rec."Business to")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business to field.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business Unit field.';
                }
                field("Carton Weight"; Rec."Carton Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carton Weight (kg) field.';
                }
                field("Cartons Per Pallet"; Rec."Cartons Per Pallet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cartons Per Pallet field.';
                }
                field("Category 1 Code"; Rec."Category 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 1 Code field.';
                }
                field("Category 2 Code"; Rec."Category 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 2 Code field.';
                }
                field("Category 3 Code"; Rec."Category 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 3 Code field.';
                }
                field("Category 4 Code"; Rec."Category 4 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 4 Code field.';
                }
                field("COGS (LCY)"; Rec."COGS (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the COGS (LCY) field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field.';
                }

                field("Common Item No."; Rec."Common Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique common item number that the intercompany partners agree upon.';
                }
                field("Confirmed Picking Date"; Rec."Confirmed Picking Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirmed Picking Date field.';
                }
                field("Cost Amount (Actual LCY)"; Rec."Cost Amount (Actual LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Amount (Actual LCY) field.';
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Amount (Actual) field.';
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Amount (Expected) field.';
                }
                field("Cost is Posted to G/L"; Rec."Cost is Posted to G/L")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that all the inventory costs for this item have been posted to the general ledger.';
                }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Posted to G/L field.';
                }
                field("Cost Posted to G/L (LCY)"; Rec."Cost Posted to G/L (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Posted to G/L (LCY) field.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field("Country/Region Exists"; Rec."Country/Region Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Exists field.';
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the country/region where the item was produced or processed.';
                }
                field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Purchased Code field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field(Critical; Rec.Critical)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item is included in availability calculations to promise a shipment date for its parent item.';
                }
                field("Deal Reg"; Rec."Deal Reg")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deal Reg. field.';
                }
                field("Defect service"; Rec."Defect service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Defect service field.';
                }
                field("Dim Per Carton LxWxH"; Rec."Dim Per Carton LxWxH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dim Per Carton LxWxH field.';
                }
                field("Dim Per Unit LxWxH"; Rec."Dim Per Unit LxWxH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dim Per Unit LxWxH field.';
                }
                field("Discrete Order Quantity"; Rec."Discrete Order Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discrete Order Quantity field.';
                }
                field("DSV Inv DM1"; Rec."DSV Inv DM1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DSV Inv DM1 field.';
                }
                field("DSV Inv DM2"; Rec."DSV Inv DM2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DSV Inv DM2 field.';
                }
                field("DSV Inv HO1"; Rec."DSV Inv HO1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DSV Inv HO1 field.';
                }
                field("DSV Inv OK1"; Rec."DSV Inv OK1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DSV Inv OK1 field.';
                }
                field("DSV Inv RW1"; Rec."DSV Inv RW1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DSV Inv RW1 field.';
                }
                field("DSV Inv TE1"; Rec."DSV Inv TE1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DSV Inv TE1 field.';
                }
                field("EAC Ready"; Rec."EAC Ready")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EAC Ready field.';
                }
                field("EMS License"; Rec."EMS License")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EMS License field.';
                }
                field("End of Life Date"; Rec."End of Life Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of Life Date field.';
                }
                field("End of RMA Date"; Rec."End of RMA Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of RMA Date field.';
                }
                field("End of Technical Support Date"; Rec."End of Technical Support Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of Technical Support Date field.';
                }
                field("Enter Security for Eicard on"; Rec."Enter Security for Eicard on")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enter Security for Eicard on field.';
                }
                field(EU2Inventory; Rec.EU2Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU2Inventory field.';
                }
                field(EU2SOQty; Rec.EU2SOQty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU2SOQty field.';
                }
                field(EU2SOQtyall; Rec.EU2SOQtyall)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU2SOQtyall field.';
                }
                field(EU2SOQtyConfirmed; Rec.EU2SOQtyConfirmed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU2SOQtyConfirmed field.';
                }
                field("Exclude from Forecast"; Rec."Exclude from Forecast")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exclude from Forecast field.';
                }
                field("Exclude from Intrastat Report"; Rec."Exclude from Intrastat Report")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item shall be excluded from Intrastat report.';
                }
                field("Expected Cost Posted to G/L"; Rec."Expected Cost Posted to G/L")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Cost Posted to G/L field.';
                }
                field("Expiration Calculation"; Rec."Expiration Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date formula for calculating the expiration date on the item tracking line. Note: This field will be ignored if the involved item has Require Expiration Date Entry set to Yes on the Item Tracking Code page.';
                }
                field("Forecast Category 2"; Rec."Forecast Category 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Forecast Category 2 field.';
                }
                field("Forecast Expired Date"; Rec."Forecast Expired Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Forecast Expired Date field.';
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = All;
                    ToolTip = '"Forecast Territory" is used for the "Aged Stock Report". If the field is filld on the item card, it will be used in the report.';
                }
                field("Forecast Visibility excl. UK"; Rec."Forecast Visibility excl. UK")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Forecast Visibility excl. UK field.';
                }
                field("FP Order Receipt (Qty.)"; Rec."FP Order Receipt (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FP Order Receipt (Qty.) field.';
                }
                field("Freight Cost Item"; Rec."Freight Cost Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Freight Cost Item field.';
                }
                field("Freight Type"; Rec."Freight Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Freight Type field.';
                }
                field("Gen. Prod. Posting Group Id"; Rec."Gen. Prod. Posting Group Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group Id field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross weight of the item.';
                }
                field(GTIN; Rec.GTIN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the item. For example, the GTIN is used with bar codes to track items, and when sending and receiving documents electronically. The GTIN number typically contains a Universal Product Code (UPC), or European Article Number (EAN).';
                }
                field("Height (cm)"; Rec."Height (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Height (cm) field.';
                }
                field("Height (ctn)"; Rec."Height (ctn)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Height (ctn) field.';
                }
                field("HQ Model Phase"; Rec."HQ Model Phase")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HQ Model Phase field.';
                }
                field("HQ Unshipped Purchase Order"; Rec."HQ Unshipped Purchase Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HQ Unshipped Purchase Order field.';
                }
                field("Identifier Code"; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique code for the item in terms that are useful for automatic data capture.';
                }
                field("Ignore Missing Data"; Rec."Ignore Missing Data")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ignore Missing Data field.';
                }
                field(Inactive; Rec.Inactive)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inactive field.';
                }
                field("Include Inventory"; Rec."Include Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the inventory quantity is included in the projected available balance when replenishment orders are calculated.';
                }
                field(Include_in_SnOP; Rec.Include_in_SnOP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Include_in_SnOP field.';
                }
                field("Inventory Posting Group Id"; Rec."Inventory Posting Group Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory Posting Group Id field.';
                }
                field("Inventory Value Zero"; Rec."Inventory Value Zero")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item on inventory must be excluded from inventory valuation. This is relevant if the item is kept on inventory on someone else''s behalf.';
                }
                field("Is For ZyUK"; Rec."Is For ZyUK")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is For ZyUK field.';
                }
                field(IsEICard; Rec.IsEICard)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is EICard field.';
                }
                field("Item Category Id"; Rec."Item Category Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Category Id field.';
                }
                field("Item Country Code"; Rec."Item Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Country Code field.';
                }
                field("Last Buy Date"; Rec."Last Buy Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Buy Date field.';
                }
                field("Last Counting Period Update"; Rec."Last Counting Period Update")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date on which you calculated the counting period. It is updated when you use the function Calculate Counting Period.';
                }
                field("Last DateTime Modified"; Rec."Last DateTime Modified")
                {
                    ToolTip = 'Specifies the value of the Last DateTime Modified field.';
                }
                field("Last Order Date"; Rec."Last Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Order Date field.';
                }
                field("Last Phys. Invt. Date"; Rec."Last Phys. Invt. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.';
                }
                field("Last Time Modified"; Rec."Last Time Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Time Modified field.';
                }
                field("Last Unit Cost Calc. Date"; Rec."Last Unit Cost Calc. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Unit Cost Calc. Date field.';
                }
                field("Length (cm)"; Rec."Length (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Length (cm) field.';
                }
                field("Length (ctn)"; Rec."Length (ctn)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Length (ctn) field.';
                }
                field("Lifecycle Phase"; Rec."Lifecycle Phase")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lifecycle Phase field.';
                }
                field("Lot Accumulation Period"; Rec."Lot Accumulation Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.';
                }
                field("Lot Nos."; Rec."Lot Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code that will be used when assigning lot numbers.';
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default number of units of the item that are processed in one production operation. This affects standard cost calculations and capacity planning. If the item routing includes fixed costs such as setup time, the value in this field is used to calculate the standard cost and distribute the setup costs. During demand planning, this value is used together with the value in the Default Dampener % field to ignore negligible changes in demand and avoid re-planning. Note that if you leave the field blank, it will be threated as 1.';
                }
                field("Low-Level Code"; Rec."Low-Level Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Low-Level Code field.';
                }
                field("Manually OLAP"; Rec."Manually OLAP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manually OLAP PO Fcst. field.';
                }/*                field("Manufacturing Cell"; Rec."Manufacturing Cell")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manufacturing Cell field.';
                } */
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the manufacturer of the catalog item.';
                }
                field("Marked Picking Date"; Rec."Marked Picking Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New/Marked Picking Date field.';
                }
                field("Maximum Inventory"; Rec."Maximum Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a quantity that you want to use as a maximum inventory level.';
                }
                field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a maximum allowable quantity for an item order proposal.';
                }
                field(MDM; Rec.MDM)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MDM field.';
                }
                field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a minimum allowable quantity for an item order proposal.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field("Model Description"; Rec."Model Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model Description field.';
                }
                field("Model ID"; Rec."Model ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model ID field.';
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Modified By field.';
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Modified Date field.';
                }
                field("Module Repair"; Rec."Module Repair")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Module Repair field.';
                }
                field("Negative Adjmt. (LCY)"; Rec."Negative Adjmt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Negative Adjmt. (LCY) field.';
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net weight of the item.';
                }
                field("Next Counting End Date"; Rec."Next Counting End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the next counting period.';
                }
                field("Next Counting Start Date"; Rec."Next Counting Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the next counting period.';
                }
                field(NFR; Rec.NFR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Available for NFR field.';
                }
                field("No PLMS Update"; Rec."No PLMS Update")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No PLMS Update from HQ field.';
                }
                field("No Tariff Code"; Rec."No Tariff Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No Tariff No. field.';
                }
                field("No. of Substitutes"; Rec."No. of Substitutes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of substitutions that have been registered for the item.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Non ZyXEL License"; Rec."Non ZyXEL License")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Non ZyXEL License field.';
                }
                field("Non ZyXEL License Vendor"; Rec."Non ZyXEL License Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Non ZyXEL License Vendor field.';
                }
                field("Number per carton"; Rec."Number per carton")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Box per Carton field.';
                }
                field("Number per parcel"; Rec."Number per parcel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number per parcel field.';
                }
                field("Order Multiple"; Rec."Order Multiple")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a parameter used by the planning system to modify the quantity of planned supply orders.';
                }
                field("Order Tracking Policy"; Rec."Order Tracking Policy")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if and how order tracking entries are created and maintained between supply and its corresponding demand.';
                }
                field("Over-Receipt Code"; Rec."Over-Receipt Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the policy that will be used for the item if more items than ordered are received.';
                }
                field("Overflow Level"; Rec."Overflow Level")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a quantity you allow projected inventory to exceed the reorder point, before the system suggests to decrease supply orders.';
                }
                field(Overpack; Rec.Overpack)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Overpack field.';
                }
                field("Pallet Height (cm)"; Rec."Pallet Height (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pallet Height (cm) field.';
                }
                field("Pallet Length (cm)"; Rec."Pallet Length (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pallet Length (cm) field.';
                }
                field("Pallet Width (cm)"; Rec."Pallet Width (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pallet Width (cm) field.';
                }
                field("Paper Weight"; Rec."Paper Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paper Weight (kg) field.';
                }
                field("Part Number Type"; Rec."Part Number Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Part Number Type field.';
                }
                field("PCB error repair"; Rec."PCB error repair")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PCB error repair field.';
                }
                field(PFEInventory; Rec.PFEInventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PFEInventory field.';
                }
                field("Phys Invt Counting Period Code"; Rec."Phys Invt Counting Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the counting period that indicates how often you want to count the item in a physical inventory.';
                }
                field("Physical Item"; Rec."Physical Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Physical Item field.';
                }
                field("Plastic Weight"; Rec."Plastic Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Plastic Weight (kg) field.';
                }
                field("Positive Adjmt. (LCY)"; Rec."Positive Adjmt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Positive Adjmt. (LCY) field.';
                }
                field("Positive Adjmt. (Qty.)"; Rec."Positive Adjmt. (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Positive Adjmt. (Qty.) field.';
                }
                field("PP-Product CAT"; Rec."PP-Product CAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Partner Program Product Category field.';
                }
                field("Prevent Empty Volume"; Rec."Prevent Empty Volume")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prevent Empty Volume field.';
                }
                field("Prevent Negative Inventory"; Rec."Prevent Negative Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether you can post a transaction that will bring the item''s inventory below zero. Negative inventory is always prevented for Consumption and Transfer type transactions.';
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without VAT.';
                }
                field("Prod. Forecast Quantity (Base)"; Rec."Prod. Forecast Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prod. Forecast Quantity (Base) field.';
                }
                field("Product Length (cm)"; Rec."Product Length (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Length (cm) (WEEE) field.';
                }
                field("Product use Battery"; Rec."Product use Battery")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product or Accessory use Battery field.';
                }
                field("Purch. Req. Receipt (Qty.)"; Rec."Purch. Req. Receipt (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purch. Req. Receipt (Qty.) field.';
                }
                field("Purch. Req. Release (Qty.)"; Rec."Purch. Req. Release (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purch. Req. Release (Qty.) field.';
                }
                field("Purchases (LCY)"; Rec."Purchases (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchases (LCY) field.';
                }
                field("Purchases (Qty.)"; Rec."Purchases (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchases (Qty.) field.';
                }
                field("Purchasing Blocked"; Rec."Purchasing Blocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the item cannot be entered on purchase documents, except return orders and credit memos, and journals.';
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for a special procurement method, such as drop shipment.';
                }
                field("Put-away Template Code"; Rec."Put-away Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the put-away template by which the program determines the most appropriate zone and bin for storage of the item after receipt.';
                }
                field("Put-away Unit of Measure Code"; Rec."Put-away Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the item unit of measure in which the program will put the item away.';
                }
                field("Qty Per Pallet"; Rec."Qty Per Pallet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty Per Pallet field.';
                }
                field("Reac Bromine Wgt. PCB"; Rec."Reac Bromine Wgt. PCB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reactive Bromine Weight PCB field.';
                }
                field("Reac Bromine Wgt. Plastic Part"; Rec."Reac Bromine Wgt. Plastic Part")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reactive Bromine Weight Plastic Part field.';
                }
                field("Reac Chlorine Wgt. PCB"; Rec."Reac Chlorine Wgt. PCB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reactive Chlorine Weight PCB field.';
                }
                field("Reac Chlorine Wgt. Plas. Part"; Rec."Reac Chlorine Wgt. Plas. Part")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reactive Chlorine Weight Plastic Part field.';
                }
                field("Reac Phos. Wgt. PCB"; Rec."Reac Phos. Wgt. PCB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reactive Phosphorus Weight PCB field.';
                }
                field("Reac Phos. Wgt. Plastic Part"; Rec."Reac Phos. Wgt. Plastic Part")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reactive Phosphorus Weight Plastic Part field.';
                }
                field("Refurbish Cost"; Rec."Refurbish Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refurbish Cost field.';
                }
                field("Rel. Order Receipt (Qty.)"; Rec."Rel. Order Receipt (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rel. Order Receipt (Qty.) field.';
                }
                field("Reorder Point"; Rec."Reorder Point")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a stock quantity that sets the inventory below the level that you must replenish the item.';
                }
                field("Reorder Quantity"; Rec."Reorder Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a standard lot size quantity to be used for all order proposals.';
                }
                field("Reordering Policy"; Rec."Reordering Policy")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reordering policy.';
                }
                field("Repair Cost"; Rec."Repair Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Repair Cost field.';
                }
                field("Rework BOM"; Rec."Rework BOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rework BOM field.';
                }
                field("RMA Category"; Rec."RMA Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RMA Category field.';
                }
                field("RMA count"; Rec."RMA count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RMA count field.';
                }
                field("RMA Vendor Cost"; Rec."RMA Vendor Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RMA Vendor Cost field.';
                }
                field("Rounding Precision"; Rec."Rounding Precision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how calculated consumption quantities are rounded when entered on consumption journal lines.';
                }
                field("Safety Lead Time"; Rec."Safety Lead Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a date formula to indicate a safety lead time that can be used as a buffer period for production and other delays.';
                }
                field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a quantity of stock to have in inventory to protect against supply-and-demand fluctuations during replenishment lead time.';
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales (LCY) field.';
                }
                field("Sales (Qty.)"; Rec."Sales (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales (Qty.) field.';
                }
                field("Sales Blocked"; Rec."Sales Blocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the item cannot be entered on sales documents, except return orders and credit memos, and journals.';
                }
                field(SBU; Rec.SBU)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SBU field.';
                }
                field("SBU Company"; Rec."SBU Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SBU Company field.';
                }
                field("SCIP No."; Rec."SCIP No.")  // 18-04-24 ZY-LD 000
                {
                    ApplicationArea = All;
                    ToolTip = 'SCIP is the database for information on Substances of Concern In articles as such or in complex objects (Products) established under the Waste Framework Directive (WFD).';
                }
                field(SCM; Rec.SCM)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SCM field.';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                }
                field(Segment; Rec.Segment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Segment field.';
                }
                field("Serial Code"; Rec."Serial Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial Code field.';
                }
                field("Serial Nos."; Rec."Serial Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a number series code to assign consecutive serial numbers to items produced.';
                }
                field("Serial Number Required"; Rec."Serial Number Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial Number Required field.';
                }
                field("Show In Web"; Rec."Show In Web")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show In Web field.';
                }
                field("Special Equipment Code"; Rec."Special Equipment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the equipment that warehouse employees must use when handling the item.';
                }
                field("Statistics Group"; Rec."Statistics Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statistics Group field.';
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Statistics Group Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Stockout Warning"; Rec."Stockout Warning")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory below zero.';
                }
                field("Supplementary Unit of Measure"; Rec."Supplementary Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code used in Intrastat report as supplementary unit.';
                }
                field("SVHC > 1000 ppm"; Rec."SVHC > 1000 ppm")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SVHC > 1000 ppm field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Tax rate (SEK/kg)"; Rec."Tax rate (SEK/kg)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax rate (SEK/kg) field.';
                }
                field("Tax Reduction rate"; Rec."Tax Reduction rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Reduction Rate field.';
                }
                field("Tax Reduction Rate Active"; Rec."Tax Reduction Rate Active")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Reduction Rate Active field.';
                }
                field("Time Bucket"; Rec."Time Bucket")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a time period that defines the recurring planning horizon used with Fixed Reorder Qty. or Maximum Qty. reordering policies.';
                }
                field("Total Chemical Tax"; Rec."Total Chemical Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Chemical Tax field.';
                }
                field("Total Inventory"; Rec."Total Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory field.';
                }
                field("Total Qty. per Carton"; Rec."Total Qty. per Carton")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Qty. per Carton field.';
                }
                field("UN Code"; Rec."UN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UN Code field.';
                }
                field("Unconfirmed Picking Date"; Rec."Unconfirmed Picking Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unconfirmed Picking Date field.';
                }
                field("Unit Group Exists"; Rec."Unit Group Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Group Exists field.';
                }
                field("Unit List Price"; Rec."Unit List Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit List Price field.';
                }
                field("Unit of Measure Id"; Rec."Unit of Measure Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure Id field.';
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the volume of one unit of the item.';
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Units per Parcel field.';
                }
                field("Update PLMS from Item No."; Rec."Update PLMS from Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Update PLMS from Item No. field.';
                }
                field(UpdateAllIn; Rec.UpdateAllIn)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UpdateAllIn field.';
                }
                field(UPSInventory; Rec.UPSInventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UPSInventory field.';
                }
                field(UPSSOQty; Rec.UPSSOQty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UPSSOQty field.';
                }
                field("Use Cross-Docking"; Rec."Use Cross-Docking")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this item can be cross-docked.';
                }
                field("Variant Mandatory if Exists"; Rec."Variant Mandatory if Exists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a variant must be selected if variants exist for the item. ';
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT business posting group for customers for whom you want the sales price including VAT to apply.';
                }
                field("Volume (cm3)"; Rec."Volume (cm3)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Volume (cm3) field.';
                }
                field("Volume (ctn)"; Rec."Volume (ctn)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Volume (ctn) field.';
                }
                field("Warehouse Class Code"; Rec."Warehouse Class Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the warehouse class code for the item.';
                }
                field("Warehouse Inventory"; Rec."Warehouse Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warehouse Inventory field.';
                }
                field("Warranty Period"; Rec."Warranty Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warranty Period field.';
                }
                field("Web Description"; Rec."Web Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Web Description field.';
                }
                field("WEEE Category"; Rec."WEEE Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WEEE Category field.';
                }
                field("Weight p_Carton"; Rec."Weight p_Carton")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weight p_Carton field.';
                }
                field("Weight Per Unit"; Rec."Weight Per Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weight Per Unit (kg) field.';
                }
                field("Width (cm)"; Rec."Width (cm)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Width (cm) field.';
                }
                field("Width (ctn)"; Rec."Width (ctn)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Width (ctn) field.';
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        SCIPNumber: Record "SCIP Number";
    begin
        SCIPNumber.SetRange("Item No.", Rec."No.");
        if SCIPNumber.FindFirst() then
            Rec."SCIP No." := SCIPNumber."SCIP No.";
    end;
}
