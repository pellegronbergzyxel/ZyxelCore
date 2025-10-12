Page 50217 "Item List (All fields)"
{
    // 001.  DT1.01  01-07-2010  SH
    //  .Documention for tectura customasation
    //  .IsEICard added to tablebox
    // 
    // 003. DT5.0 05-01-2012 TS
    //   .New fielde
    //   50080 Cost Amount (Actual)
    //   50081 Cost Amount (Actual LCY)
    //   50082 Cost Posted to G/L
    //   50083 Coat Posted to G/L (LCY)
    // ZY2.0 BS 15.06.2012 Added Qty. fields on form
    //       BS 03.08.2012 Added Serial code,business unit,country code,sp/channel code
    // 004. Steven Su
    //      . Modify "Quantity per Pallet" wording to "Cartons per Pallet" according to Kim's demand
    // 005. 25-09-17 ZY-LD Change Log is added.
    // 006. 08-03-18 ZY-LD 2018022810000231 - Old category code has been removed.
    // 007. 22-03-18 ZY-LD 2018032310000168 - "Category Code 4" is now back.
    // 008. 05-07-19 ZY-LD P0213 - EU2Inventory is replaced by Inventory.
    // 009. 09-08-19 ZY-LD 2019080810000097 - New field.

    AdditionalSearchTerms = 'product,finished good,component,raw material,assembly item';
    ApplicationArea = Basic, Suite, Assembly, Service;
    Caption = 'Item List  (All fields)';
    CardPageID = "Item Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Item List';
    SourceTable = Item;
    SourceTableView = where(Inactive = const(false),
                            "Quanty Type Filter" = const("On Hand"));
    UsageCategory = Lists;

    AboutTitle = 'About items';
    AboutText = '**Items** represent the products and services you buy and sell. For each item, you can manage the default sales and purchase prices used when creating documents, as well as track inventory numbers. With [Item Templates](?page=1383 "Opens the Item Templates") you can quickly create new items having common details defined by the template.';

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
                    ToolTip = 'Specifies the value of the No. 2 field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a default text to describe the item on related documents such as orders or invoices. You can translate the descriptions so that they show up in the language of the customer or vendor.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Price Unit Conversion"; Rec."Price Unit Conversion")
                {
                    ToolTip = 'Specifies the value of the Price Unit Conversion field.';
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the item card represents a physical inventory unit (Inventory), a labor time unit (Service), or a physical unit that is not tracked in inventory (Non-Inventory).';
                    Visible = IsFoundationEnabled;
                }
                field(InventoryField; Rec.Inventory)
                {
                    ApplicationArea = Invoicing, Basic, Suite;
                    HideValue = IsNonInventoriable;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                }
                field("Created From Nonstock Item"; Rec."Created From Nonstock Item")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the item was created from a catalog item.';
                    Visible = false;
                }
                field("Substitutes Exist"; Rec."Substitutes Exist")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that a substitute exists for this item.';
                }
                field("Stockkeeping Unit Exists"; Rec."Stockkeeping Unit Exists")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies that a stockkeeping unit exists for this item.';
                    Visible = false;
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                    AccessByPermission = TableData "BOM Component" = R;
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies if the item is an assembly BOM.';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the production BOM that the item represents.';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the production routing that the item is used in.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = Invoicing, Basic, Suite;
                    ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies where to find the item in the warehouse. This is informational only.';
                    Visible = false;
                }
                field("Costing Method"; Rec."Costing Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';
                    Visible = false;
                }
                field("Cost is Adjusted"; Rec."Cost is Adjusted")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the item''s unit cost has been adjusted, either automatically or manually.';
                }
                field("Standard Cost"; Rec."Standard Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost per unit of the item.';
                }
                field("Last Direct Cost"; Rec."Last Direct Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the most recent direct unit cost that was paid for the item.';
                    Visible = false;
                }
                field("Price/Profit Calculation"; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';
                    Visible = false;
                }
                field("Profit %"; Rec."Profit %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Invoicing, Basic, Suite;
                    ToolTip = 'Specifies the price for one unit of the item, in LCY.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                    Visible = false;
                }
                field("Item Disc. Group"; Rec."Item Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
                    Visible = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor code of who supplies this item by default.';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number that the vendor uses for this item.';
                    Visible = false;
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for the item''s tariff number.';
                    Visible = false;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a search description that you use to find the item in lists.';
                    Visible = false;
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the item''s indirect cost as an absolute amount.';
                    Visible = false;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                    Visible = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that transactions with the item cannot be posted, for example, because the item is in quarantine.';
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the item card was last modified.';
                    Visible = false;
                }
                field("Sales Unit of Measure"; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code used when you sell the item.';
                    Visible = false;
                }
                field("Replenishment System"; Rec."Replenishment System")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';
                    Visible = false;
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
                    Visible = false;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                    Visible = false;
                }
                field("Manufacturing Policy"; Rec."Manufacturing Policy")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies if additional orders for any related components are calculated.';
                    Visible = false;
                }
                field("Flushing Method"; Rec."Flushing Method")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
                    Visible = false;
                }
                field("Assembly Policy"; Rec."Assembly Policy")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies which default order flow is used to supply this assembly item.';
                    Visible = false;
                }
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies how items are tracked in the supply chain.';
                    Visible = false;
                }
                field("Default Deferral Template Code"; Rec."Default Deferral Template Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Default Deferral Template';
                    Importance = Additional;
                    ToolTip = 'Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
                field("Coupled to Dataverse"; Rec."Coupled to Dataverse")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the item is coupled to a product in Dynamics 365 Sales.';
                    Visible = CRMIntegrationEnabled;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Actual FOB Price"; Rec."Actual FOB Price")
                {
                    ToolTip = 'Specifies the value of the Actual FOB Price field.';
                }
                field("Add Additional Item"; Rec."Add Additional Item")
                {
                    ToolTip = 'Specifies the value of the Add Additional Item field.';
                }
                field("Add Bromine Wgt. PCB"; Rec."Add Bromine Wgt. PCB")
                {
                    ToolTip = 'Specifies the value of the Additive Bromine Weight PCB field.';
                }
                field("Add Bromine Wgt. Plastic Part"; Rec."Add Bromine Wgt. Plastic Part")
                {
                    ToolTip = 'Specifies the value of the Additive Bromine Weight Plastic Part field.';
                }
                field("Add Chlorine Wgt. PCB"; Rec."Add Chlorine Wgt. PCB")
                {
                    ToolTip = 'Specifies the value of the Additive Chlorine Weight PCB field.';
                }
                field("Add Chlorine Wgt. Plastic Part"; Rec."Add Chlorine Wgt. Plastic Part")
                {
                    ToolTip = 'Specifies the value of the Additive Chlorine Weight Plastic Part field.';
                }
                field("Add Phos. Wgt. PCB"; Rec."Add Phos. Wgt. PCB")
                {
                    ToolTip = 'Specifies the value of the Additive  Phosphorus Weight PCB field.';
                }
                field("Add Phos. Wgt. Plastic Part"; Rec."Add Phos. Wgt. Plastic Part")
                {
                    ToolTip = 'Specifies the value of the Additive Phosphorus Weight Plastic Part field.';
                }
                field("Additional Content Weight"; Rec."Additional Content Weight")
                {
                    ToolTip = 'Specifies the value of the Additional Content Weight (kg) field.';
                }
                field("Aged Country Code"; Rec."Aged Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ToolTip = 'Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.';
                }
                field("Allow Online Adjustment"; Rec."Allow Online Adjustment")
                {
                    ToolTip = 'Specifies the value of the Allow Online Adjustment field.';
                }
                field("Alternative Item No."; Rec."Alternative Item No.")
                {
                    ToolTip = 'Specifies the value of the Alternative Item No. field.';
                }
                field("Application Wksh. User ID"; Rec."Application Wksh. User ID")
                {
                    ToolTip = 'Specifies the ID of a user who is working in the Application Worksheet window.';
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                    ToolTip = 'Specifies that an extended text that you have set up will be added automatically on sales or purchase documents for this item.';
                }
                field("Automatic Purchase Visible Fee"; Rec."Automatic Purchase Visible Fee")
                {
                    ToolTip = 'Specifies the value of the Automatic Purchase Visible Fee field.';
                }
                field(B2B; Rec.B2B)
                {
                    ToolTip = 'Specifies the value of the Business to Business field.';
                }
                field(B2C; Rec.B2C)
                {
                    ToolTip = 'Specifies the value of the Business to Consumer field.';
                }
                field("Battery Certificate"; Rec."Battery Certificate")
                {
                    ToolTip = 'Specifies the value of the Battery Certificate field.';
                }
                field("Battery weight"; Rec."Battery weight")
                {
                    ToolTip = 'Specifies the value of the Battery weight field.';
                }
                field("Block on Sales Order"; Rec."Block on Sales Order")
                {
                    ToolTip = 'Specifies the value of the Blocked on Sales Order field.';
                }
                field("Block Reason"; Rec."Block Reason")
                {
                    ToolTip = 'Specifies the value of the Block Reason field.';
                }
                field(blockedReason; Rec."Block Reason")
                {
                    ToolTip = 'Specifies the value of the blockedReason field.';
                }
                field("Budget Profit"; Rec."Budget Profit")
                {
                    ToolTip = 'Specifies the value of the Budget Profit field.';
                }
                field("Budget Quantity"; Rec."Budget Quantity")
                {
                    ToolTip = 'Specifies the value of the Budget Quantity field.';
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field("Business Center"; Rec."Business Center")
                {
                    ToolTip = 'Specifies the value of the Business Center field.';
                }
                field("Business to"; Rec."Business to")
                {
                    ToolTip = 'Specifies the value of the Business to field.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ToolTip = 'Specifies the value of the Business Unit field.';
                }
                field("Carton Weight"; Rec."Carton Weight")
                {
                    ToolTip = 'Specifies the value of the Carton Weight (kg) field.';
                }
                field("Cartons Per Pallet"; Rec."Cartons Per Pallet")
                {
                    ToolTip = 'Specifies the value of the Cartons Per Pallet field.';
                }
                field("Category 1 Code"; Rec."Category 1 Code")
                {
                    ToolTip = 'Specifies the value of the Category 1 Code field.';
                }
                field("Category 2 Code"; Rec."Category 2 Code")
                {
                    ToolTip = 'Specifies the value of the Category 2 Code field.';
                }
                field("Category 3 Code"; Rec."Category 3 Code")
                {
                    ToolTip = 'Specifies the value of the Category 3 Code field.';
                }
                field("Category 4 Code"; Rec."Category 4 Code")
                {
                    ToolTip = 'Specifies the value of the Category 4 Code field.';
                }
                field("COGS (LCY)"; Rec."COGS (LCY)")
                {
                    ToolTip = 'Specifies the value of the COGS (LCY) field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Commission Group"; Rec."Commission Group")
                {
                    ToolTip = 'Specifies the value of the Commission Group field.';
                }
                field("Common Item No."; Rec."Common Item No.")
                {
                    ToolTip = 'Specifies the unique common item number that the intercompany partners agree upon.';
                }
                field("Confirmed Picking Date"; Rec."Confirmed Picking Date")
                {
                    ToolTip = 'Specifies the value of the Confirmed Picking Date field.';
                }
                field("Cost Amount (Actual LCY)"; Rec."Cost Amount (Actual LCY)")
                {
                    ToolTip = 'Specifies the value of the Cost Amount (Actual LCY) field.';
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ToolTip = 'Specifies the value of the Cost Amount (Actual) field.';
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    ToolTip = 'Specifies the value of the Cost Amount (Expected) field.';
                }
                field("Cost is Posted to G/L"; Rec."Cost is Posted to G/L")
                {
                    ToolTip = 'Specifies that all the inventory costs for this item have been posted to the general ledger.';
                }
                field("Cost of Open Production Orders"; Rec."Cost of Open Production Orders")
                {
                    ToolTip = 'Specifies the value of the Cost of Open Production Orders field.';
                }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L")
                {
                    ToolTip = 'Specifies the value of the Cost Posted to G/L field.';
                }
                field("Cost Posted to G/L (LCY)"; Rec."Cost Posted to G/L (LCY)")
                {
                    ToolTip = 'Specifies the value of the Cost Posted to G/L (LCY) field.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field("Country/Region Exists"; Rec."Country/Region Exists")
                {
                    ToolTip = 'Specifies the value of the Country/Region Exists field.';
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    ToolTip = 'Specifies a code for the country/region where the item was produced or processed.';
                }
                field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Purchased Code field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field(Critical; Rec.Critical)
                {
                    ToolTip = 'Specifies if the item is included in availability calculations to promise a shipment date for its parent item.';
                }
                field("Dampener Period"; Rec."Dampener Period")
                {
                    ToolTip = 'Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders forward. The dampener period limits the number of insignificant rescheduling of existing supply to a later date if that new date is within the dampener period. The dampener period function is only initiated if the supply can be rescheduled to a later date and not if the supply can be rescheduled to an earlier date. Accordingly, if the suggested new supply date is after the dampener period, then the rescheduling suggestion is not blocked. If the lot accumulation period is less than the dampener period, then the dampener period is dynamically set to equal the lot accumulation period. This is not shown in the value that you enter in the Dampener Period field. The last demand in the lot accumulation period is used to determine whether a potential supply date is in the dampener period. If this field is empty, then the value in the Default Dampener Period field in the Manufacturing Setup window applies. The value that you enter in the Dampener Period field must be a date formula, and one day (1D) is the shortest allowed period.';
                }
                field("Dampener Quantity"; Rec."Dampener Quantity")
                {
                    ToolTip = 'Specifies a dampener quantity to block insignificant change suggestions for an existing supply, if the change quantity is lower than the dampener quantity.';
                }
                field("Deal Reg"; Rec."Deal Reg")
                {
                    ToolTip = 'Specifies the value of the Deal Reg. field.';
                }
                field("Defect service"; Rec."Defect service")
                {
                    ToolTip = 'Specifies the value of the Defect service field.';
                }
                field("Dim Per Carton LxWxH"; Rec."Dim Per Carton LxWxH")
                {
                    ToolTip = 'Specifies the value of the Dim Per Carton LxWxH field.';
                }
                field("Dim Per Unit LxWxH"; Rec."Dim Per Unit LxWxH")
                {
                    ToolTip = 'Specifies the value of the Dim Per Unit LxWxH field.';
                }
                field("Discrete Order Quantity"; Rec."Discrete Order Quantity")
                {
                    ToolTip = 'Specifies the value of the Discrete Order Quantity field.';
                }
                field("DSV Inv DM1"; Rec."DSV Inv DM1")
                {
                    ToolTip = 'Specifies the value of the DSV Inv DM1 field.';
                }
                field("DSV Inv DM2"; Rec."DSV Inv DM2")
                {
                    ToolTip = 'Specifies the value of the DSV Inv DM2 field.';
                }
                field("DSV Inv HO1"; Rec."DSV Inv HO1")
                {
                    ToolTip = 'Specifies the value of the DSV Inv HO1 field.';
                }
                field("DSV Inv OK1"; Rec."DSV Inv OK1")
                {
                    ToolTip = 'Specifies the value of the DSV Inv OK1 field.';
                }
                field("DSV Inv RW1"; Rec."DSV Inv RW1")
                {
                    ToolTip = 'Specifies the value of the DSV Inv RW1 field.';
                }
                field("DSV Inv TE1"; Rec."DSV Inv TE1")
                {
                    ToolTip = 'Specifies the value of the DSV Inv TE1 field.';
                }
                field(Durability; Rec.Durability)
                {
                    ToolTip = 'Specifies the value of the Durability field.';
                }
                field("Duty Code"; Rec."Duty Code")
                {
                    ToolTip = 'Specifies the value of the Duty Code field.';
                }
                field("Duty Due %"; Rec."Duty Due %")
                {
                    ToolTip = 'Specifies the value of the Duty Due % field.';
                }
                field("Duty Unit Conversion"; Rec."Duty Unit Conversion")
                {
                    ToolTip = 'Specifies the value of the Duty Unit Conversion field.';
                }
                field("EAC Ready"; Rec."EAC Ready")
                {
                    ToolTip = 'Specifies the value of the EAC Ready field.';
                }
                field("EMS License"; Rec."EMS License")
                {
                    ToolTip = 'Specifies the value of the EMS License field.';
                }
                field("End of Life Date"; Rec."End of Life Date")
                {
                    ToolTip = 'Specifies the value of the End of Life Date field.';
                }
                field("End of RMA Date"; Rec."End of RMA Date")
                {
                    ToolTip = 'Specifies the value of the End of RMA Date field.';
                }
                field("End of Technical Support Date"; Rec."End of Technical Support Date")
                {
                    ToolTip = 'Specifies the value of the End of Technical Support Date field.';
                }
                field("Enter Security for Eicard on"; Rec."Enter Security for Eicard on")
                {
                    ToolTip = 'Specifies the value of the Enter Security for Eicard on field.';
                }
                field(EU2Inventory; Rec.EU2Inventory)
                {
                    ToolTip = 'Specifies the value of the EU2Inventory field.';
                }
                field(EU2SOQty; Rec.EU2SOQty)
                {
                    ToolTip = 'Specifies the value of the EU2SOQty field.';
                }
                field(EU2SOQtyall; Rec.EU2SOQtyall)
                {
                    ToolTip = 'Specifies the value of the EU2SOQtyall field.';
                }
                field(EU2SOQtyConfirmed; Rec.EU2SOQtyConfirmed)
                {
                    ToolTip = 'Specifies the value of the EU2SOQtyConfirmed field.';
                }
                field("Exclude from Forecast"; Rec."Exclude from Forecast")
                {
                    ToolTip = 'Specifies the value of the Exclude from Forecast field.';
                }
                field("Exclude from Intrastat Report"; Rec."Exclude from Intrastat Report")
                {
                    ToolTip = 'Specifies if the item shall be excluded from Intrastat report.';
                }
                field("Expected Cost Posted to G/L"; Rec."Expected Cost Posted to G/L")
                {
                    ToolTip = 'Specifies the value of the Expected Cost Posted to G/L field.';
                }
                field("Expiration Calculation"; Rec."Expiration Calculation")
                {
                    ToolTip = 'Specifies the date formula for calculating the expiration date on the item tracking line. Note: This field will be ignored if the involved item has Require Expiration Date Entry set to Yes on the Item Tracking Code page.';
                }
                field("Forecast Category 2"; Rec."Forecast Category 2")
                {
                    ToolTip = 'Specifies the value of the Forecast Category 2 field.';
                }
                field("Forecast Expired Date"; Rec."Forecast Expired Date")
                {
                    ToolTip = 'Specifies the value of the Forecast Expired Date field.';
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ToolTip = '"Forecast Territory" is used for the "Aged Stock Report". If the field is filld on the item card, it will be used in the report.';
                }
                field("Forecast Visibility excl. UK"; Rec."Forecast Visibility excl. UK")
                {
                    ToolTip = 'Specifies the value of the Forecast Visibility excl. UK field.';
                }
                field("FP Order Receipt (Qty.)"; Rec."FP Order Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the value of the FP Order Receipt (Qty.) field.';
                }
                field("Freight Cost Item"; Rec."Freight Cost Item")
                {
                    ToolTip = 'Specifies the value of the Freight Cost Item field.';
                }
                field("Freight Type"; Rec."Freight Type")
                {
                    ToolTip = 'Specifies the value of the Freight Type field.';
                }
                field("Gen. Prod. Posting Group Id"; Rec."Gen. Prod. Posting Group Id")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group Id field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ToolTip = 'Specifies the gross weight of the item.';
                }
                field(GTIN; Rec.GTIN)
                {
                    ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the item. For example, the GTIN is used with bar codes to track items, and when sending and receiving documents electronically. The GTIN number typically contains a Universal Product Code (UPC), or European Article Number (EAN).';
                }
                field("Height (cm)"; Rec."Height (cm)")
                {
                    ToolTip = 'Specifies the value of the Height (cm) field.';
                }
                field("Height (ctn)"; Rec."Height (ctn)")
                {
                    ToolTip = 'Specifies the value of the Height (ctn) field.';
                }
                field("HQ Model Phase"; Rec."HQ Model Phase")
                {
                    ToolTip = 'Specifies the value of the HQ Model Phase field.';
                }
                field("HQ Unshipped Purchase Order"; Rec."HQ Unshipped Purchase Order")
                {
                    ToolTip = 'Specifies the value of the HQ Unshipped Purchase Order field.';
                }
                field("Identifier Code"; Rec."Identifier Code")
                {
                    ToolTip = 'Specifies a unique code for the item in terms that are useful for automatic data capture.';
                }
                field("Ignore Missing Data"; Rec."Ignore Missing Data")
                {
                    ToolTip = 'Specifies the value of the Ignore Missing Data field.';
                }
                field(Inactive; Rec.Inactive)
                {
                    ToolTip = 'Specifies the value of the Inactive field.';
                }
                field("Include Inventory"; Rec."Include Inventory")
                {
                    ToolTip = 'Specifies that the inventory quantity is included in the projected available balance when replenishment orders are calculated.';
                }
                field(Include_in_SnOP; Rec.Include_in_SnOP)
                {
                    ToolTip = 'Specifies the value of the Include_in_SnOP field.';
                }
                field("Inventory Posting Group Id"; Rec."Inventory Posting Group Id")
                {
                    ToolTip = 'Specifies the value of the Inventory Posting Group Id field.';
                }
                field("Inventory Value Zero"; Rec."Inventory Value Zero")
                {
                    ToolTip = 'Specifies whether the item on inventory must be excluded from inventory valuation. This is relevant if the item is kept on inventory on someone else''s behalf.';
                }
                field("Is For ZyUK"; Rec."Is For ZyUK")
                {
                    ToolTip = 'Specifies the value of the Is For ZyUK field.';
                }
                field(IsEICard; Rec.IsEICard)
                {
                    ToolTip = 'Specifies the value of the Is EICard field.';
                }
                field("Item Category Id"; Rec."Item Category Id")
                {
                    ToolTip = 'Specifies the value of the Item Category Id field.';
                }
                field("Item Country Code"; Rec."Item Country Code")
                {
                    ToolTip = 'Specifies the value of the Item Country Code field.';
                }
                field("Last Buy Date"; Rec."Last Buy Date")
                {
                    ToolTip = 'Specifies the value of the Last Buy Date field.';
                }
                field("Last Counting Period Update"; Rec."Last Counting Period Update")
                {
                    ToolTip = 'Specifies the last date on which you calculated the counting period. It is updated when you use the function Calculate Counting Period.';
                }
                field("Last DateTime Modified"; Rec."Last DateTime Modified")
                {
                    ToolTip = 'Specifies the value of the Last DateTime Modified field.';
                }
                field("Last Order Date"; Rec."Last Order Date")
                {
                    ToolTip = 'Specifies the value of the Last Order Date field.';
                }
                field("Last Phys. Invt. Date"; Rec."Last Phys. Invt. Date")
                {
                    ToolTip = 'Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.';
                }
                field("Last Time Modified"; Rec."Last Time Modified")
                {
                    ToolTip = 'Specifies the value of the Last Time Modified field.';
                }
                field("Last Unit Cost Calc. Date"; Rec."Last Unit Cost Calc. Date")
                {
                    ToolTip = 'Specifies the value of the Last Unit Cost Calc. Date field.';
                }
                field("Length (cm)"; Rec."Length (cm)")
                {
                    ToolTip = 'Specifies the value of the Length (cm) field.';
                }
                field("Length (ctn)"; Rec."Length (ctn)")
                {
                    ToolTip = 'Specifies the value of the Length (ctn) field.';
                }
                field("Lifecycle Phase"; Rec."Lifecycle Phase")
                {
                    ToolTip = 'Specifies the value of the Lifecycle Phase field.';
                }
                field("Lot Accumulation Period"; Rec."Lot Accumulation Period")
                {
                    ToolTip = 'Specifies a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.';
                }
                field("Lot Nos."; Rec."Lot Nos.")
                {
                    ToolTip = 'Specifies the number series code that will be used when assigning lot numbers.';
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ToolTip = 'Specifies the default number of units of the item that are processed in one production operation. This affects standard cost calculations and capacity planning. If the item routing includes fixed costs such as setup time, the value in this field is used to calculate the standard cost and distribute the setup costs. During demand planning, this value is used together with the value in the Default Dampener % field to ignore negligible changes in demand and avoid re-planning. Note that if you leave the field blank, it will be threated as 1.';
                }
                field("Low-Level Code"; Rec."Low-Level Code")
                {
                    ToolTip = 'Specifies the value of the Low-Level Code field.';
                }
                field("Manually OLAP"; Rec."Manually OLAP")
                {
                    ToolTip = 'Specifies the value of the Manually OLAP PO Fcst. field.';
                }
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    ToolTip = 'Specifies a code for the manufacturer of the catalog item.';
                }
                field("Marked Picking Date"; Rec."Marked Picking Date")
                {
                    ToolTip = 'Specifies the value of the New/Marked Picking Date field.';
                }
                field("Maximum Inventory"; Rec."Maximum Inventory")
                {
                    ToolTip = 'Specifies a quantity that you want to use as a maximum inventory level.';
                }
                field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
                {
                    ToolTip = 'Specifies a maximum allowable quantity for an item order proposal.';
                }
                field(MDM; Rec.MDM)
                {
                    ToolTip = 'Specifies the value of the MDM field.';
                }
                field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                {
                    ToolTip = 'Specifies a minimum allowable quantity for an item order proposal.';
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field("Model Description"; Rec."Model Description")
                {
                    ToolTip = 'Specifies the value of the Model Description field.';
                }
                field("Model ID"; Rec."Model ID")
                {
                    ToolTip = 'Specifies the value of the Model ID field.';
                }
                field("Modified By"; Rec."Modified By")
                {
                    ToolTip = 'Specifies the value of the Modified By field.';
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ToolTip = 'Specifies the value of the Modified Date field.';
                }
                field("Module Repair"; Rec."Module Repair")
                {
                    ToolTip = 'Specifies the value of the Module Repair field.';
                }
                field("Negative Adjmt. (LCY)"; Rec."Negative Adjmt. (LCY)")
                {
                    ToolTip = 'Specifies the value of the Negative Adjmt. (LCY) field.';
                }
                field("Negative Adjmt. (Qty.)"; Rec."Negative Adjmt. (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Negative Adjmt. (Qty.) field.';
                }
                field("Net Change"; Rec."Net Change")
                {
                    ToolTip = 'Specifies the value of the Net Change field.';
                }
                field("Net Invoiced Qty."; Rec."Net Invoiced Qty.")
                {
                    ToolTip = 'Specifies how many units of the item in inventory have been invoiced.';
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ToolTip = 'Specifies the net weight of the item.';
                }
                field("Next Counting End Date"; Rec."Next Counting End Date")
                {
                    ToolTip = 'Specifies the ending date of the next counting period.';
                }
                field("Next Counting Start Date"; Rec."Next Counting Start Date")
                {
                    ToolTip = 'Specifies the starting date of the next counting period.';
                }
                field(NFR; Rec.NFR)
                {
                    ToolTip = 'Specifies the value of the Available for NFR field.';
                }
                field("No PLMS Update"; Rec."No PLMS Update")
                {
                    ToolTip = 'Specifies the value of the No PLMS Update from HQ field.';
                }
                field("No Tariff Code"; Rec."No Tariff Code")
                {
                    ToolTip = 'Specifies the value of the No Tariff No. field.';
                }
                field("No. of Substitutes"; Rec."No. of Substitutes")
                {
                    ToolTip = 'Specifies the number of substitutions that have been registered for the item.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Non ZyXEL License"; Rec."Non ZyXEL License")
                {
                    ToolTip = 'Specifies the value of the Non ZyXEL License field.';
                }
                field("Non ZyXEL License Vendor"; Rec."Non ZyXEL License Vendor")
                {
                    ToolTip = 'Specifies the value of the Non ZyXEL License Vendor field.';
                }
                field("Number per carton"; Rec."Number per carton")
                {
                    ToolTip = 'Specifies the value of the Box per Carton field.';
                }
                field("Number per parcel"; Rec."Number per parcel")
                {
                    ToolTip = 'Specifies the value of the Number per parcel field.';
                }
                field("Order Multiple"; Rec."Order Multiple")
                {
                    ToolTip = 'Specifies a parameter used by the planning system to modify the quantity of planned supply orders.';
                }
                field("Order Tracking Policy"; Rec."Order Tracking Policy")
                {
                    ToolTip = 'Specifies if and how order tracking entries are created and maintained between supply and its corresponding demand.';
                }
                field("Over-Receipt Code"; Rec."Over-Receipt Code")
                {
                    ToolTip = 'Specifies the policy that will be used for the item if more items than ordered are received.';
                }
                field("Overflow Level"; Rec."Overflow Level")
                {
                    ToolTip = 'Specifies a quantity you allow projected inventory to exceed the reorder point, before the system suggests to decrease supply orders.';
                }
                field(Overpack; Rec.Overpack)
                {
                    ToolTip = 'Specifies the value of the Overpack field.';
                }
                field("Pallet Height (cm)"; Rec."Pallet Height (cm)")
                {
                    ToolTip = 'Specifies the value of the Pallet Height (cm) field.';
                }
                field("Pallet Length (cm)"; Rec."Pallet Length (cm)")
                {
                    ToolTip = 'Specifies the value of the Pallet Length (cm) field.';
                }
                field("Pallet Width (cm)"; Rec."Pallet Width (cm)")
                {
                    ToolTip = 'Specifies the value of the Pallet Width (cm) field.';
                }
                field("Paper Weight"; Rec."Paper Weight")
                {
                    ToolTip = 'Specifies the value of the Paper Weight (kg) field.';
                }
                field("Part Number Type"; Rec."Part Number Type")
                {
                    ToolTip = 'Specifies the value of the Part Number Type field.';
                }
                field("PCB error repair"; Rec."PCB error repair")
                {
                    ToolTip = 'Specifies the value of the PCB error repair field.';
                }
                field(PFEInventory; Rec.PFEInventory)
                {
                    ToolTip = 'Specifies the value of the PFEInventory field.';
                }
                field("Phys Invt Counting Period Code"; Rec."Phys Invt Counting Period Code")
                {
                    ToolTip = 'Specifies the code of the counting period that indicates how often you want to count the item in a physical inventory.';
                }
                field("Physical Item"; Rec."Physical Item")
                {
                    ToolTip = 'Specifies the value of the Physical Item field.';
                }
                field(Picture; Rec.Picture)
                {
                    ToolTip = 'Specifies the picture that has been inserted for the item.';
                }
                field("Planned Order Receipt (Qty.)"; Rec."Planned Order Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Planned Order Receipt (Qty.) field.';
                }
                field("Planned Order Release (Qty.)"; Rec."Planned Order Release (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Planned Order Release (Qty.) field.';
                }
                field("Planning Issues (Qty.)"; Rec."Planning Issues (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Planning Issues (Qty.) field.';
                }
                field("Planning Receipt (Qty.)"; Rec."Planning Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Planning Receipt (Qty.) field.';
                }
                field("Planning Release (Qty.)"; Rec."Planning Release (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Planning Release (Qty.) field.';
                }
                field("Planning Transfer Ship. (Qty)."; Rec."Planning Transfer Ship. (Qty).")
                {
                    ToolTip = 'Specifies the value of the Planning Transfer Ship. (Qty). field.';
                }
                field("Planning Worksheet (Qty.)"; Rec."Planning Worksheet (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Planning Worksheet (Qty.) field.';
                }
                field("Plastic Weight"; Rec."Plastic Weight")
                {
                    ToolTip = 'Specifies the value of the Plastic Weight (kg) field.';
                }
                field("Positive Adjmt. (LCY)"; Rec."Positive Adjmt. (LCY)")
                {
                    ToolTip = 'Specifies the value of the Positive Adjmt. (LCY) field.';
                }
                field("Positive Adjmt. (Qty.)"; Rec."Positive Adjmt. (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Positive Adjmt. (Qty.) field.';
                }
                field("PP-Product CAT"; Rec."PP-Product CAT")
                {
                    ToolTip = 'Specifies the value of the Partner Program Product Category field.';
                }
                field("Prevent Empty Volume"; Rec."Prevent Empty Volume")
                {
                    ToolTip = 'Specifies the value of the Prevent Empty Volume field.';
                }
                field("Prevent Negative Inventory"; Rec."Prevent Negative Inventory")
                {
                    ToolTip = 'Specifies whether you can post a transaction that will bring the item''s inventory below zero. Negative inventory is always prevented for Consumption and Transfer type transactions.';
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without VAT.';
                }
                field("Prod. Forecast Quantity (Base)"; Rec."Prod. Forecast Quantity (Base)")
                {
                    ToolTip = 'Specifies the value of the Prod. Forecast Quantity (Base) field.';
                }
                field("Product Length (cm)"; Rec."Product Length (cm)")
                {
                    ToolTip = 'Specifies the value of the Product Length (cm) (WEEE) field.';
                }
                field("Product use Battery"; Rec."Product use Battery")
                {
                    ToolTip = 'Specifies the value of the Product or Accessory use Battery field.';
                }
                field("Purch. Req. Receipt (Qty.)"; Rec."Purch. Req. Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Purch. Req. Receipt (Qty.) field.';
                }
                field("Purch. Req. Release (Qty.)"; Rec."Purch. Req. Release (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Purch. Req. Release (Qty.) field.';
                }
                field("Purchases (LCY)"; Rec."Purchases (LCY)")
                {
                    ToolTip = 'Specifies the value of the Purchases (LCY) field.';
                }
                field("Purchases (Qty.)"; Rec."Purchases (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Purchases (Qty.) field.';
                }
                field("Purchasing Blocked"; Rec."Purchasing Blocked")
                {
                    ToolTip = 'Specifies that the item cannot be entered on purchase documents, except return orders and credit memos, and journals.';
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ToolTip = 'Specifies the code for a special procurement method, such as drop shipment.';
                }
                field("Put-away Template Code"; Rec."Put-away Template Code")
                {
                    ToolTip = 'Specifies the code of the put-away template by which the program determines the most appropriate zone and bin for storage of the item after receipt.';
                }
                field("Put-away Unit of Measure Code"; Rec."Put-away Unit of Measure Code")
                {
                    ToolTip = 'Specifies the code of the item unit of measure in which the program will put the item away.';
                }
                field("Qty Per Pallet"; Rec."Qty Per Pallet")
                {
                    ToolTip = 'Specifies the value of the Qty Per Pallet field.';
                }
                field("Qty. Assigned to ship"; Rec."Qty. Assigned to ship")
                {
                    ToolTip = 'Specifies the value of the Qty. Assigned to ship field.';
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ToolTip = 'Specifies the quantity of the items that are currently in transit.';
                }
                field("Qty. on Asm. Component"; Rec."Qty. on Asm. Component")
                {
                    ToolTip = 'Specifies how many units of the item are allocated as assembly components, which means how many are listed on outstanding assembly order lines.';
                }
                field("Qty. on Assembly Order"; Rec."Qty. on Assembly Order")
                {
                    ToolTip = 'Specifies how many units of the item are allocated to assembly orders, which is how many are listed on outstanding assembly order headers.';
                }
                field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
                {
                    ToolTip = 'Specifies how many units of the item are allocated as production order components, meaning listed under outstanding production order lines.';
                }
                field("Qty. on Delivery Document"; Rec."Qty. on Delivery Document")
                {
                    ToolTip = 'Specifies the value of the Qty. on Delivery Document field.';
                }
                field("Qty. on Job Order"; Rec."Qty. on Job Order")
                {
                    ToolTip = 'Specifies how many units of the item are allocated to jobs, meaning listed on outstanding job planning lines.';
                }
                field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
                {
                    ToolTip = 'Specifies how many units of the item are allocated to production orders, meaning listed on outstanding production order lines.';
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
                }
                field("Qty. on Purch. Return"; Rec."Qty. on Purch. Return")
                {
                    ToolTip = 'Specifies the value of the Qty. on Purch. Return field.';
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
                }
                field("Qty. on Sales Order Conf."; Rec."Qty. on Sales Order Conf.")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Order Confirmed (New) field.';
                }
                field("Qty. on Sales Order Conf.Total"; Rec."Qty. on Sales Order Conf.Total")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Order Confirmed field.';
                }
                field("Qty. on Sales Order Confirmed"; Rec."Qty. on Sales Order Confirmed")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Order Confirmed field.';
                }
                field("Qty. on Sales Order Total"; Rec."Qty. on Sales Order Total")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Order field.';
                }
                field("Qty. on Sales Order Unconf."; Rec."Qty. on Sales Order Unconf.")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Order Unconfirmed field.';
                }
                field("Qty. on Sales Return"; Rec."Qty. on Sales Return")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Return field.';
                }
                field("Qty. on Service Order"; Rec."Qty. on Service Order")
                {
                    ToolTip = 'Specifies how many units of the item are allocated to service orders, meaning listed on outstanding service order lines.';
                }
                field("Qty. on Ship. Detail Received"; Rec."Qty. on Ship. Detail Received")
                {
                    ToolTip = 'Specifies the value of the Quantity on Shipping Detail Received field.';
                }
                field("Qty. on Shipping Detail"; Rec."Qty. on Shipping Detail")
                {
                    ToolTip = 'Specifies the value of the Qty. on Shipping Detail field.';
                }
                field("Qty. Per Carton"; Rec."Qty. Per Carton")
                {
                    ToolTip = 'Specifies the value of the Qty. Per Carton field.';
                }
                field("Qty. per Color Box"; Rec."Qty. per Color Box")
                {
                    ToolTip = 'Specifies the value of the Qty. per Color Box field.';
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                    ToolTip = 'Specifies the value of the Qty. Picked field.';
                }
                field("Reac Bromine Wgt. PCB"; Rec."Reac Bromine Wgt. PCB")
                {
                    ToolTip = 'Specifies the value of the Reactive Bromine Weight PCB field.';
                }
                field("Reac Bromine Wgt. Plastic Part"; Rec."Reac Bromine Wgt. Plastic Part")
                {
                    ToolTip = 'Specifies the value of the Reactive Bromine Weight Plastic Part field.';
                }
                field("Reac Chlorine Wgt. PCB"; Rec."Reac Chlorine Wgt. PCB")
                {
                    ToolTip = 'Specifies the value of the Reactive Chlorine Weight PCB field.';
                }
                field("Reac Chlorine Wgt. Plas. Part"; Rec."Reac Chlorine Wgt. Plas. Part")
                {
                    ToolTip = 'Specifies the value of the Reactive Chlorine Weight Plastic Part field.';
                }
                field("Reac Phos. Wgt. PCB"; Rec."Reac Phos. Wgt. PCB")
                {
                    ToolTip = 'Specifies the value of the Reactive Phosphorus Weight PCB field.';
                }
                field("Reac Phos. Wgt. Plastic Part"; Rec."Reac Phos. Wgt. Plastic Part")
                {
                    ToolTip = 'Specifies the value of the Reactive Phosphorus Weight Plastic Part field.';
                }
                field("Refurbish Cost"; Rec."Refurbish Cost")
                {
                    ToolTip = 'Specifies the value of the Refurbish Cost field.';
                }
                field("Rel. Order Receipt (Qty.)"; Rec."Rel. Order Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Rel. Order Receipt (Qty.) field.';
                }
                field("Reorder Point"; Rec."Reorder Point")
                {
                    ToolTip = 'Specifies a stock quantity that sets the inventory below the level that you must replenish the item.';
                }
                field("Reorder Quantity"; Rec."Reorder Quantity")
                {
                    ToolTip = 'Specifies a standard lot size quantity to be used for all order proposals.';
                }
                field("Reordering Policy"; Rec."Reordering Policy")
                {
                    ToolTip = 'Specifies the reordering policy.';
                }
                field("Repair Cost"; Rec."Repair Cost")
                {
                    ToolTip = 'Specifies the value of the Repair Cost field.';
                }
                field("Res. Qty. on  Asm. Comp."; Rec."Res. Qty. on  Asm. Comp.")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on  Asm. Comp. field.';
                }
                field("Res. Qty. on Assembly Order"; Rec."Res. Qty. on Assembly Order")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Assembly Order field.';
                }
                field("Res. Qty. on Inbound Transfer"; Rec."Res. Qty. on Inbound Transfer")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Inbound Transfer field.';
                }
                field("Res. Qty. on Job Order"; Rec."Res. Qty. on Job Order")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Job Order field.';
                }
                field("Res. Qty. on Outbound Transfer"; Rec."Res. Qty. on Outbound Transfer")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Outbound Transfer field.';
                }
                field("Res. Qty. on Prod. Order Comp."; Rec."Res. Qty. on Prod. Order Comp.")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Prod. Order Comp. field.';
                }
                field("Res. Qty. on Purch. Returns"; Rec."Res. Qty. on Purch. Returns")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Purch. Returns field.';
                }
                field("Res. Qty. on Req. Line"; Rec."Res. Qty. on Req. Line")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Req. Line field.';
                }
                field("Res. Qty. on Sales Returns"; Rec."Res. Qty. on Sales Returns")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Sales Returns field.';
                }
                field("Res. Qty. on Service Orders"; Rec."Res. Qty. on Service Orders")
                {
                    ToolTip = 'Specifies the value of the Res. Qty. on Service Orders field.';
                }
                field("Rescheduling Period"; Rec."Rescheduling Period")
                {
                    ToolTip = 'Specifies a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.';
                }
                field(Reserve; Rec.Reserve)
                {
                    ToolTip = 'Specifies if and how the item will be reserved. Never: It is not possible to reserve the item. Optional: You can reserve the item manually. Always: The item is automatically reserved from demand, such as sales orders, against inventory, purchase orders, assembly orders, and production orders.';
                }
                field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. on Inventory field.';
                }
                field("Reserved Qty. on Prod. Order"; Rec."Reserved Qty. on Prod. Order")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. on Prod. Order field.';
                }
                field("Reserved Qty. on Purch. Orders"; Rec."Reserved Qty. on Purch. Orders")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. on Purch. Orders field.';
                }
                field("Reserved Qty. on Sales Orders"; Rec."Reserved Qty. on Sales Orders")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. on Sales Orders field.';
                }
                field("Rework BOM"; Rec."Rework BOM")
                {
                    ToolTip = 'Specifies the value of the Rework BOM field.';
                }
                field("RMA Category"; Rec."RMA Category")
                {
                    ToolTip = 'Specifies the value of the RMA Category field.';
                }
                field("RMA count"; Rec."RMA count")
                {
                    ToolTip = 'Specifies the value of the RMA count field.';
                }
                field("RMA Vendor Cost"; Rec."RMA Vendor Cost")
                {
                    ToolTip = 'Specifies the value of the RMA Vendor Cost field.';
                }
                field("Rolled-up Cap. Overhead Cost"; Rec."Rolled-up Cap. Overhead Cost")
                {
                    ToolTip = 'Specifies the value of the Rolled-up Cap. Overhead Cost field.';
                }
                field("Rolled-up Capacity Cost"; Rec."Rolled-up Capacity Cost")
                {
                    ToolTip = 'Specifies the value of the Rolled-up Capacity Cost field.';
                }
                field("Rolled-up Material Cost"; Rec."Rolled-up Material Cost")
                {
                    ToolTip = 'Specifies the value of the Rolled-up Material Cost field.';
                }
                field("Rolled-up Mfg. Ovhd Cost"; Rec."Rolled-up Mfg. Ovhd Cost")
                {
                    ToolTip = 'Specifies the value of the Rolled-up Mfg. Ovhd Cost field.';
                }
                field("Rolled-up Subcontracted Cost"; Rec."Rolled-up Subcontracted Cost")
                {
                    ToolTip = 'Specifies the value of the Rolled-up Subcontracted Cost field.';
                }
                field("Rounding Precision"; Rec."Rounding Precision")
                {
                    ToolTip = 'Specifies how calculated consumption quantities are rounded when entered on consumption journal lines.';
                }
                field("Safety Lead Time"; Rec."Safety Lead Time")
                {
                    ToolTip = 'Specifies a date formula to indicate a safety lead time that can be used as a buffer period for production and other delays.';
                }
                field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
                {
                    ToolTip = 'Specifies a quantity of stock to have in inventory to protect against supply-and-demand fluctuations during replenishment lead time.';
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ToolTip = 'Specifies the value of the Sales (LCY) field.';
                }
                field("Sales (Qty.)"; Rec."Sales (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Sales (Qty.) field.';
                }
                field("Sales Blocked"; Rec."Sales Blocked")
                {
                    ToolTip = 'Specifies that the item cannot be entered on sales documents, except return orders and credit memos, and journals.';
                }
                field(SBU; Rec.SBU)
                {
                    ToolTip = 'Specifies the value of the SBU field.';
                }
                field("SBU Company"; Rec."SBU Company")
                {
                    ToolTip = 'Specifies the value of the SBU Company field.';
                }
                field("Scheduled Receipt (Qty.)"; Rec."Scheduled Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Scheduled Receipt (Qty.) field.';
                }
                /*field("SCIP No."; Rec."SCIP No.")  // 18-04-24 ZY-LD 000
                {
                    ToolTip = 'SCIP is the database for information on Substances of Concern In articles as such or in complex objects (Products) established under the Waste Framework Directive (WFD).';
                }*/
                field(SCM; Rec.SCM)
                {
                    ToolTip = 'Specifies the value of the SCM field.';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                }
                field(Segment; Rec.Segment)
                {
                    ToolTip = 'Specifies the value of the Segment field.';
                }
                field("Serial Code"; Rec."Serial Code")
                {
                    ToolTip = 'Specifies the value of the Serial Code field.';
                }
                field("Serial Nos."; Rec."Serial Nos.")
                {
                    ToolTip = 'Specifies a number series code to assign consecutive serial numbers to items produced.';
                }
                field("Serial Number Required"; Rec."Serial Number Required")
                {
                    ToolTip = 'Specifies the value of the Serial Number Required field.';
                }
                field("Service Item Group"; Rec."Service Item Group")
                {
                    ToolTip = 'Specifies the code of the service item group that the item belongs to.';
                }
                field("Shipment (Qty.)"; Rec."Shipment (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Shipment (Qty.) field.';
                }
                field("Show In Web"; Rec."Show In Web")
                {
                    ToolTip = 'Specifies the value of the Show In Web field.';
                }
                field("Single-Level Cap. Ovhd Cost"; Rec."Single-Level Cap. Ovhd Cost")
                {
                    ToolTip = 'Specifies the value of the Single-Level Cap. Ovhd Cost field.';
                }
                field("Single-Level Capacity Cost"; Rec."Single-Level Capacity Cost")
                {
                    ToolTip = 'Specifies the value of the Single-Level Capacity Cost field.';
                }
                field("Single-Level Material Cost"; Rec."Single-Level Material Cost")
                {
                    ToolTip = 'Specifies the value of the Single-Level Material Cost field.';
                }
                field("Single-Level Mfg. Ovhd Cost"; Rec."Single-Level Mfg. Ovhd Cost")
                {
                    ToolTip = 'Specifies the value of the Single-Level Mfg. Ovhd Cost field.';
                }
                field("Single-Level Subcontrd. Cost"; Rec."Single-Level Subcontrd. Cost")
                {
                    ToolTip = 'Specifies the value of the Single-Level Subcontrd. Cost field.';
                }
                field("Special Equipment Code"; Rec."Special Equipment Code")
                {
                    ToolTip = 'Specifies the code of the equipment that warehouse employees must use when handling the item.';
                }
                field("Statistics Group"; Rec."Statistics Group")
                {
                    ToolTip = 'Specifies the value of the Statistics Group field.';
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ToolTip = 'Specifies the value of the Statistics Group Code field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Stockout Warning"; Rec."Stockout Warning")
                {
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory below zero.';
                }
                field("Supplementary Unit of Measure"; Rec."Supplementary Unit of Measure")
                {
                    ToolTip = 'Specifies the unit of measure code used in Intrastat report as supplementary unit.';
                }
                field("SVHC > 1000 ppm"; Rec."SVHC > 1000 ppm")
                {
                    ToolTip = 'Specifies the value of the SVHC > 1000 ppm field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Tax Group Id"; Rec."Tax Group Id")
                {
                    ToolTip = 'Specifies the ID of the tax group.';
                }
                field("Tax rate (SEK/kg)"; Rec."Tax rate (SEK/kg)")
                {
                    ToolTip = 'Specifies the value of the Tax rate (SEK/kg) field.';
                }
                field("Tax Reduction rate"; Rec."Tax Reduction rate")
                {
                    ToolTip = 'Specifies the value of the Tax Reduction Rate field.';
                }
                field("Tax Reduction Rate Active"; Rec."Tax Reduction Rate Active")
                {
                    ToolTip = 'Specifies the value of the Tax Reduction Rate Active field.';
                }
                field("Time Bucket"; Rec."Time Bucket")
                {
                    ToolTip = 'Specifies a time period that defines the recurring planning horizon used with Fixed Reorder Qty. or Maximum Qty. reordering policies.';
                }
                field("Total Chemical Tax"; Rec."Total Chemical Tax")
                {
                    ToolTip = 'Specifies the value of the Total Chemical Tax field.';
                }
                field("Total Inventory"; Rec."Total Inventory")
                {
                    ToolTip = 'Specifies the value of the Inventory field.';
                }
                field("Total Qty. per Carton"; Rec."Total Qty. per Carton")
                {
                    ToolTip = 'Specifies the value of the Total Qty. per Carton field.';
                }
                field("Tr. Or. Ship (Qty.) Confirmed"; Rec."Tr. Or. Ship (Qty.) Confirmed")
                {
                    ToolTip = 'Specifies the value of the Trans. Ord. Shipment (Qty.) Confirmed field.';
                }
                field("Trade In"; Rec."Trade In")
                {
                    ToolTip = 'Specifies the value of the Trade In field.';
                }
                field("Trans. Ord. Receipt (Qty.)"; Rec."Trans. Ord. Receipt (Qty.)")
                {
                    ToolTip = 'Specifies the quantity of the items that remains to be received but are not yet shipped as the difference between the Quantity and the Quantity Shipped fields.';
                }
                field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ToolTip = 'Specifies the quantity of the items that remains to be shipped as the difference between the Quantity and the Quantity Shipped fields.';
                }
                field("Transferred (LCY)"; Rec."Transferred (LCY)")
                {
                    ToolTip = 'Specifies the value of the Transferred (LCY) field.';
                }
                field("Transferred (Qty.)"; Rec."Transferred (Qty.)")
                {
                    ToolTip = 'Specifies the value of the Transferred (Qty.) field.';
                }
                field("UN Code"; Rec."UN Code")
                {
                    ToolTip = 'Specifies the value of the UN Code field.';
                }
                field("Unconfirmed Picking Date"; Rec."Unconfirmed Picking Date")
                {
                    ToolTip = 'Specifies the value of the Unconfirmed Picking Date field.';
                }
                field("Unit Group Exists"; Rec."Unit Group Exists")
                {
                    ToolTip = 'Specifies the value of the Unit Group Exists field.';
                }
                field("Unit List Price"; Rec."Unit List Price")
                {
                    ToolTip = 'Specifies the value of the Unit List Price field.';
                }
                field("Unit of Measure Id"; Rec."Unit of Measure Id")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Id field.';
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ToolTip = 'Specifies the volume of one unit of the item.';
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    ToolTip = 'Specifies the value of the Units per Parcel field.';
                }
                field("Update PLMS from Item No."; Rec."Update PLMS from Item No.")
                {
                    ToolTip = 'Specifies the value of the Update PLMS from Item No. field.';
                }
                field(UpdateAllIn; Rec.UpdateAllIn)
                {
                    ToolTip = 'Specifies the value of the UpdateAllIn field.';
                }
                field(UPSInventory; Rec.UPSInventory)
                {
                    ToolTip = 'Specifies the value of the UPSInventory field.';
                }
                field(UPSSOQty; Rec.UPSSOQty)
                {
                    ToolTip = 'Specifies the value of the UPSSOQty field.';
                }
                field("Use Cross-Docking"; Rec."Use Cross-Docking")
                {
                    ToolTip = 'Specifies if this item can be cross-docked.';
                }
                field("Variant Mandatory if Exists"; Rec."Variant Mandatory if Exists")
                {
                    ToolTip = 'Specifies whether a variant must be selected if variants exist for the item. ';
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ToolTip = 'Specifies the VAT business posting group for customers for whom you want the sales price including VAT to apply.';
                }
                field("Volume (cm3)"; Rec."Volume (cm3)")
                {
                    ToolTip = 'Specifies the value of the Volume (cm3) field.';
                }
                field("Volume (ctn)"; Rec."Volume (ctn)")
                {
                    ToolTip = 'Specifies the value of the Volume (ctn) field.';
                }
                field("Warehouse Class Code"; Rec."Warehouse Class Code")
                {
                    ToolTip = 'Specifies the warehouse class code for the item.';
                }
                field("Warehouse Inventory"; Rec."Warehouse Inventory")
                {
                    ToolTip = 'Specifies the value of the Warehouse Inventory field.';
                }
                field("Warranty Period"; Rec."Warranty Period")
                {
                    ToolTip = 'Specifies the value of the Warranty Period field.';
                }
                field("Web Description"; Rec."Web Description")
                {
                    ToolTip = 'Specifies the value of the Web Description field.';
                }
                field("WEEE Category"; Rec."WEEE Category")
                {
                    ToolTip = 'Specifies the value of the WEEE Category field.';
                }
                field("Weight p_Carton"; Rec."Weight p_Carton")
                {
                    ToolTip = 'Specifies the value of the Weight p_Carton field.';
                }
                field("Weight Per Unit"; Rec."Weight Per Unit")
                {
                    ToolTip = 'Specifies the value of the Weight Per Unit (kg) field.';
                }
                field("Width (cm)"; Rec."Width (cm)")
                {
                    ToolTip = 'Specifies the value of the Width (cm) field.';
                }
                field("Width (ctn)"; Rec."Width (ctn)")
                {
                    ToolTip = 'Specifies the value of the Width (ctn) field.';
                }



            }
        }
        area(factboxes)
        {
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Bin Filter" = FIELD("Bin Filter"),
                              "Variant Filter" = FIELD("Variant Filter"),
                              "Lot No. Filter" = FIELD("Lot No. Filter"),
                              "Serial No. Filter" = FIELD("Serial No. Filter");
            }
            part(Control1903326807; "Item Replenishment FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Bin Filter" = FIELD("Bin Filter"),
                              "Variant Filter" = FIELD("Variant Filter"),
                              "Lot No. Filter" = FIELD("Lot No. Filter"),
                              "Serial No. Filter" = FIELD("Serial No. Filter");
                Visible = false;
            }
            part(Control1906840407; "Item Planning FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Bin Filter" = FIELD("Bin Filter"),
                              "Variant Filter" = FIELD("Variant Filter"),
                              "Lot No. Filter" = FIELD("Lot No. Filter"),
                              "Serial No. Filter" = FIELD("Serial No. Filter");
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Bin Filter" = FIELD("Bin Filter"),
                              "Variant Filter" = FIELD("Variant Filter"),
                              "Lot No. Filter" = FIELD("Lot No. Filter"),
                              "Serial No. Filter" = FIELD("Serial No. Filter");
                Visible = false;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::Item), "No." = FIELD("No.");
            }
            part(ItemAttributesFactBox; "Item Attributes Factbox")
            {
                ApplicationArea = Basic, Suite;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Ledger E&ntries")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category5;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.")
                                      ORDER(Descending);
                        Scope = Repeater;
                        ShortCutKey = 'Ctrl+F7';
                        ToolTip = 'View the history of transactions that have been posted for the selected record.';
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        ApplicationArea = Warehouse;
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category5;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                        Scope = Repeater;
                        ToolTip = 'View how many units of the item you had in stock at the last physical count.';
                    }
                    action("Whse. Ledger Entries")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Whse. Ledger Entries';
                        Image = Warehouse;
                        RunObject = Page "Whse. Item Ledger Entry";
                        RunPageLink = "Item No." = field("No.");
                        ShortCutKey = 'Shift+F7';
                    }
                    action("Change Log")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Change Log';
                        Image = ChangeLog;
                        RunObject = Page "Change Log Entries";
                        RunPageLink = "Primary Key Field 1 Value" = field("No.");
                        RunPageView = sorting("Table No.", "Date and Time")
                                      order(descending)
                                      where("Table No." = const(27));
                    }

                    action("&Reservation Entries")
                    {
                        ApplicationArea = Reservation;
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = CONST(Reservation),
                                      "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.", "Variant Code", "Location Code", "Reservation Status");
                        ToolTip = 'View all reservations that are made for the item, either manually or automatically.';
                    }
                    action("&Value Entries")
                    {
                        ApplicationArea = Suite;
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                        ToolTip = 'View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.';
                    }
                    action("Item &Tracking Entries")
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;
                        ToolTip = 'View serial or lot numbers that are assigned to items.';

                        trigger OnAction()
                        var
                            ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            ItemTrackingDocMgt.ShowItemTrackingForEntity(3, '', Rec."No.", '', '');
                        end;
                    }
                    action("&Warehouse Entries")
                    {
                        ApplicationArea = Warehouse;
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated);
                        ToolTip = 'View the history of quantities that are registered for the item in warehouse activities. ';
                    }
                }
            }
            group(PricesandDiscounts)
            {
                Caption = 'Sales Prices & Discounts';
                action(SalesPriceLists)
                {
                    AccessByPermission = TableData "Sales Price Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices';
                    Image = Price;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'Set up sales prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Sale, AmountType::Price);
                    end;
                }
                action(SalesPriceListsDiscounts)
                {
                    AccessByPermission = TableData "Sales Discount Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Discounts';
                    Image = LineDiscount;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'Set up sales discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Sale, AmountType::Discount);
                    end;
                }
            }
            group(PurchPricesandDiscounts)
            {
                Caption = 'Purchase Prices & Discounts';
                action(PurchPriceLists)
                {
                    AccessByPermission = TableData "Purchase Price Access" = R;
                    ApplicationArea = Suite;
                    Caption = 'Purchase Prices';
                    Image = Price;
                    Visible = ExtendedPriceEnabled;
                    Scope = Repeater;
                    ToolTip = 'Set up purchase prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Purchase, AmountType::Price);
                    end;
                }
                action(PurchPriceListsDiscounts)
                {
                    AccessByPermission = TableData "Purchase Price Access" = R;
                    ApplicationArea = Suite;
                    Caption = 'Purchase Discounts';
                    Image = LineDiscount;
                    Visible = ExtendedPriceEnabled;
                    Scope = Repeater;
                    ToolTip = 'Set up purchase discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Purchase, AmountType::Discount);
                    end;
                }
            }
            group(PeriodicActivities)
            {
                Caption = 'Periodic Activities';
                action("Adjust Cost - Item Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Adjust Cost - Item Entries';
                    Image = AdjustEntries;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category8;
                    RunObject = Report "Adjust Cost - Item Entries";
                    ToolTip = 'Adjust inventory values in value entries so that you use the correct adjusted cost for updating the general ledger and so that sales and profit statistics are up to date.';
                }
                action("Post Inventory Cost to G/L")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Inventory Cost to G/L';
                    Image = PostInventoryToGL;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category8;
                    RunObject = Report "Post Inventory Cost to G/L";
                    ToolTip = 'Post the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.';
                }
                action("Physical Inventory Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Physical Inventory Journal';
                    Image = PhysicalInventory;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category8;
                    RunObject = Page "Phys. Inventory Journal";
                    ToolTip = 'Select how you want to maintain an up-to-date record of your inventory at different locations.';
                }
                action("Revaluation Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Revaluation Journal';
                    Image = Journal;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category8;
                    RunObject = Page "Revaluation Journal";
                    ToolTip = 'View or edit the inventory value of items, which you can change, such as after doing a physical inventory.';
                }
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = (NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckItemApprovalsWorkflowEnabled(Rec) then
                            ApprovalsMgmt.OnSendItemForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);
                        WorkflowWebhookManagement.FindAndCancel(Rec.RecordId);
                    end;
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CreateApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Approval Workflow';
                    Enabled = NOT EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for creating or changing items, by going through a few pages that will guide you.';

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Item Approval WF Setup Wizard");
                    end;
                }
                action(ManageApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Manage Approval Workflow';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for creating or changing items.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(DATABASE::Item, EventFilter);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Create Stockkeeping Unit")
                {
                    AccessByPermission = TableData "Stockkeeping Unit" = R;
                    ApplicationArea = Warehouse;
                    Caption = '&Create Stockkeeping Unit';
                    Image = CreateSKU;
                    ToolTip = 'Create an instance of the item at each location that is set up.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", Rec."No.");
                        REPORT.RunModal(REPORT::"Create Stockkeeping Unit", true, false, Item);
                    end;
                }
                action("C&alculate Counting Period")
                {
                    AccessByPermission = TableData "Phys. Invt. Item Selection" = R;
                    ApplicationArea = Warehouse;
                    Caption = 'C&alculate Counting Period';
                    Image = CalculateCalendar;
                    ToolTip = 'Prepare for a physical inventory by calculating which items or SKUs need to be counted in the current period.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        CurrPage.SetSelectionFilter(Item);
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Item);
                    end;
                }
                action(CopyItem)
                {
                    AccessByPermission = TableData Item = I;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Copy Item';
                    Image = Copy;
                    ToolTip = 'Create a copy of the current item.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Copy Item", Rec);
                    end;
                }
                action(AdjustInventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Adjust Inventory';
                    Enabled = IsInventoriable;
                    Image = InventoryCalculation;
                    Scope = Repeater;
                    ToolTip = 'Increase or decrease the item''s inventory quantity manually by entering a new quantity. Adjusting the inventory quantity manually may be relevant after a physical count or if you do not record purchased quantities.';
                    Visible = IsFoundationEnabled;

                    trigger OnAction()
                    var
                        AdjustInventory: Page "Adjust Inventory";
                    begin
                        Commit();
                        AdjustInventory.SetItem(Rec."No.");
                        AdjustInventory.RunModal();
                    end;
                }
            }
            action(FilterByAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Filter by Attributes';
                Image = EditFilter;
                ToolTip = 'Find items that match specific attributes. To make sure you include recent changes made by other users, clear the filter and then reset it.';

                trigger OnAction()
                var
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                begin
                    FilterPageID := PAGE::"Filter Items by Attribute";
                    if ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::Phone then
                        FilterPageID := PAGE::"Filter Items by Att. Phone";

                    CloseAction := PAGE.RunModal(FilterPageID, TempFilterItemAttributesBuffer);
                    if (ClientTypeManagement.GetCurrentClientType() <> CLIENTTYPE::Phone) and (CloseAction <> ACTION::LookupOK) then
                        exit;

                    if TempFilterItemAttributesBuffer.IsEmpty() then begin
                        ClearAttributesFilter();
                        exit;
                    end;
                    TempItemFilteredFromAttributes.Reset();
                    TempItemFilteredFromAttributes.DeleteAll();
                    ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
                    FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);

                    if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery() - 100 then begin
                        Rec.FilterGroup(0);
                        Rec.MarkedOnly(false);
                        Rec.SetFilter("No.", FilterText);
                    end else begin
                        RunOnTempRec := true;
                        Rec.ClearMarks();
                        Rec.Reset();
                    end;
                end;
            }
            action(ClearAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Clear Attributes Filter';
                Image = RemoveFilterLines;
                ToolTip = 'Remove the filter for specific item attributes.';

                trigger OnAction()
                begin
                    ClearAttributesFilter();
                    TempItemFilteredFromAttributes.Reset();
                    TempItemFilteredFromAttributes.DeleteAll();
                    RunOnTempRec := false;

                    RestoreTempItemFilteredFromAttributes();
                end;
            }
            action("Requisition Worksheet")
            {
                ApplicationArea = Planning;
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Worksheet";
                ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
            }
            action("Item Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Journal';
                Image = Journals;
                RunObject = Page "Item Journal";
                ToolTip = 'Open a list of journals where you can adjust the physical quantity of items on inventory.';
            }
            action("Item Reclassification Journal")
            {
                ApplicationArea = Warehouse;
                Caption = 'Item Reclassification Journal';
                Image = Journals;
                RunObject = Page "Item Reclass. Journal";
                ToolTip = 'Change information on item ledger entries, such as dimensions, location codes, bin codes, and serial or lot numbers.';
            }
            action("Item Tracing")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
                ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
            }
            action("Adjust Item Cost/Price")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Adjust Item Cost/Price';
                Image = AdjustItemCost;
                RunObject = Report "Adjust Item Costs/Prices";
                ToolTip = 'Adjusts the Last Direct Cost, Standard Cost, Unit Price, Profit %, or Indirect Cost % fields on selected item or stockkeeping unit cards and for selected filters. For example, you can change the last direct cost by 5% on all items from a specific vendor.';
            }
            action(ApplyTemplate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Apply Template';
                Image = ApplyTemplate;
                ToolTip = 'Apply a template to update one or more entities with your standard settings for a certain type of entity.';

                trigger OnAction()
                var
                    Item: Record Item;
                    ItemTemplMgt: Codeunit "Item Templ. Mgt.";
                begin
                    CurrPage.SetSelectionFilter(Item);
                    ItemTemplMgt.UpdateItemsFromTemplate(Item);
                end;
            }
        }
        area(reporting)
        {
            group(AssemblyProduction)
            {
                Caption = 'Assembly/Production';
                action("Assemble to Order - Sales")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Assemble to Order - Sales';
                    Image = "Report";
                    RunObject = Report "Assemble to Order - Sales";
                    ToolTip = 'View key sales figures for assembly components that may be sold either as part of assembly items in assemble-to-order sales or as separate items directly from inventory. Use this report to analyze the quantity, cost, sales, and profit figures of assembly components to support decisions, such as whether to price a kit differently or to stop or start using a particular item in assemblies.';
                }
                action("Where-Used (Top Level)")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Where-Used (Top Level)';
                    Image = "Report";
                    RunObject = Report "Where-Used (Top Level)";
                    ToolTip = 'View where and in what quantities the item is used in the product structure. The report only shows information for the top-level item. For example, if item "A" is used to produce item "B", and item "B" is used to produce item "C", the report will show item B if you run this report for item A. If you run this report for item B, then item C will be shown as where-used.';
                }
                action("Quantity Explosion of BOM")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Quantity Explosion of BOM';
                    Image = "Report";
                    RunObject = Report "Quantity Explosion of BOM";
                    ToolTip = 'View an indented BOM listing for the item or items that you specify in the filters. The production BOM is completely exploded for all levels.';
                }
                group(Costing)
                {
                    Caption = 'Costing';
                    Image = ItemCosts;
                    action("Inventory Valuation - WIP")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Valuation - WIP';
                        Image = "Report";
                        RunObject = Report "Inventory Valuation - WIP";
                        ToolTip = 'View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP. The printed report only shows invoiced amounts, that is, the cost of entries that have been posted as invoiced.';
                    }
                    action("Cost Shares Breakdown")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Shares Breakdown';
                        Image = "Report";
                        RunObject = Report "Cost Shares Breakdown";
                        ToolTip = 'View the item''s cost broken down in inventory, WIP, or COGS, according to purchase and material cost, capacity cost, capacity overhead cost, manufacturing overhead cost, subcontracted cost, variance, indirect cost, revaluation, and rounding. The report breaks down cost at a single BOM level and does not roll up the costs from lower BOM levels. The report does not calculate the cost share from items that use the Average costing method.';
                    }
                    action("Detailed Calculation")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Detailed Calculation';
                        Image = "Report";
                        RunObject = Report "Detailed Calculation";
                        ToolTip = 'View the list of all costs for the item taking into account any scrap during production.';
                    }
                    action("Rolled-up Cost Shares")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Rolled-up Cost Shares';
                        Image = "Report";
                        RunObject = Report "Rolled-up Cost Shares";
                        ToolTip = 'View the cost shares of all items in the parent item''s product structure, their quantity and their cost shares specified in material, capacity, overhead, and total cost. Material cost is calculated as the cost of all items in the parent item''s product structure. Capacity and subcontractor costs are calculated as the costs related to produce all of the items in the parent item''s product structure. Material cost is calculated as the cost of all items in the item''s product structure. Capacity and subcontractor costs are the cost related to the parent item only.';
                    }
                    action("Single-Level Cost Shares")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Single-Level Cost Shares';
                        Image = "Report";
                        RunObject = Report "Single-level Cost Shares";
                        ToolTip = 'View the cost shares of all items in the item''s product structure, their quantity and their cost shares specified in material, capacity, overhead, and total cost. Material cost is calculated as the cost of all items in the parent item''s product structure. Capacity and subcontractor costs are calculated as the costs related to produce all of the items in the parent item''s product structure.';
                    }
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Inventory - List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory - List';
                    Image = "Report";
                    RunObject = Report "Inventory - List";
                    ToolTip = 'View various information about the item, such as name, unit of measure, posting group, shelf number, vendor''s item number, lead time calculation, minimum inventory, and alternate item number. You can also see if the item is blocked.';
                }
                action("Inventory - Availability Plan")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory - Availability Plan';
                    Image = ItemAvailability;
                    RunObject = Report "Inventory - Availability Plan";
                    ToolTip = 'View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.';
                }
                action("Item/Vendor Catalog")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item/Vendor Catalog';
                    Image = "Report";
                    RunObject = Report "Item/Vendor Catalog";
                    ToolTip = 'View a list of the vendors for the selected items. For each combination of item and vendor, it shows direct unit cost, lead time calculation and the vendor''s item number.';
                }
                action("Phys. Inventory List")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Phys. Inventory List';
                    Image = "Report";
                    RunObject = Report "Phys. Inventory List";
                    ToolTip = 'View a list of the lines that you have calculated in the Phys. Inventory Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.';
                }
                action("Catalog Item Sales")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Catalog Item Sales';
                    Image = "Report";
                    RunObject = Report "Catalog Item Sales";
                    ToolTip = 'View a list of item sales for each catalog item during a selected time period. It can be used to review a company''s sale of catalog items.';
                }
                action("Item Substitutions")
                {
                    ApplicationArea = Suite;
                    Caption = 'Item Substitutions';
                    Image = "Report";
                    RunObject = Report "Item Substitutions";
                    ToolTip = 'View or edit any substitute items that are set up to be traded instead of the item in case it is not available.';
                }
                action("Item Price List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Price List';
                    Image = "Report";
                    Visible = ExtendedPriceEnabled;
                    RunObject = Report "Item Price List";
                    ToolTip = 'View, print, or save a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.';
                }
                action("Inventory Cost and Price List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory Cost and Price List';
                    Image = "Report";
                    RunObject = Report "Inventory Cost and Price List";
                    ToolTip = 'View, print, or save a list of your items and their price and cost information. The report specifies direct unit cost, last direct cost, unit price, profit percentage, and profit.';
                }
                action("Inventory Availability")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory Availability';
                    Image = "Report";
                    RunObject = Report "Inventory Availability";
                    ToolTip = 'View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.';
                }
                group("Item Register")
                {
                    Caption = 'Item Register';
                    Image = ItemRegisters;
                    action("Item Register - Quantity")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Register - Quantity';
                        Image = "Report";
                        RunObject = Report "Item Register - Quantity";
                        ToolTip = 'View one or more selected item registers showing quantity. The report can be used to document a register''s contents for internal or external audits.';
                    }
                    action("Item Register - Value")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Register - Value';
                        Image = "Report";
                        RunObject = Report "Item Register - Value";
                        ToolTip = 'View one or more selected item registers showing value. The report can be used to document the contents of a register for internal or external audits.';
                    }
                }
                group(Action130)
                {
                    Caption = 'Costing';
                    Image = ItemCosts;
                    action("Inventory - Cost Variance")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory - Cost Variance';
                        Image = ItemCosts;
                        RunObject = Report "Inventory - Cost Variance";
                        ToolTip = 'View information about selected items, unit of measure, standard cost, and costing method, as well as additional information about item entries: unit amount, direct unit cost, unit cost variance (the difference between the unit amount and unit cost), invoiced quantity, and total variance amount (quantity * unit cost variance). The report can be used primarily if you have chosen the Standard costing method on the item card.';
                    }
                    action("Invt. Valuation - Cost Spec.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invt. Valuation - Cost Spec.';
                        Image = "Report";
                        RunObject = Report "Invt. Valuation - Cost Spec.";
                        ToolTip = 'View an overview of the current inventory value of selected items and specifies the cost of these items as of the date specified in the Valuation Date field. The report includes all costs, both those posted as invoiced and those posted as expected. For each of the items that you specify when setting up the report, the printed report shows quantity on stock, the cost per unit and the total amount. For each of these columns, the report specifies the cost as the various value entry types.';
                    }
                    action("Compare List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Compare List';
                        Image = "Report";
                        RunObject = Report "Compare List";
                        ToolTip = 'View a comparison of components for two items. The printout compares the components, their unit cost, cost share and cost per component.';
                    }
                }
                group("Inventory Details")
                {
                    Caption = 'Inventory Details';
                    Image = "Report";
                    action("Inventory - Transaction Detail")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory - Transaction Detail';
                        Image = "Report";
                        RunObject = Report "Inventory - Transaction Detail";
                        ToolTip = 'View transaction details with entries for the selected items for a selected period. The report shows the inventory at the beginning of the period, all of the increase and decrease entries during the period with a running update of the inventory, and the inventory at the close of the period. The report can be used at the close of an accounting period, for example, or for an audit.';
                    }
                    action("Item Charges - Specification")
                    {
                        ApplicationArea = ItemCharges;
                        Caption = 'Item Charges - Specification';
                        Image = "Report";
                        RunObject = Report "Item Charges - Specification";
                        ToolTip = 'View a specification of the direct costs that your company has assigned and posted as item charges. The report shows the various value entries that have been posted as item charges. It includes all costs, both those posted as invoiced and those posted as expected.';
                    }
                    action("Item Age Composition - Quantity")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Age Composition - Quantity';
                        Image = "Report";
                        RunObject = Report "Item Age Composition - Qty.";
                        ToolTip = 'View, print, or save an overview of the current age composition of selected items in your inventory.';
                    }
                    action("Item Expiration - Quantity")
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Item Expiration - Quantity';
                        Image = "Report";
                        RunObject = Report "Item Expiration - Quantity";
                        ToolTip = 'View an overview of the quantities of selected items in your inventory whose expiration dates fall within a certain period. The list shows the number of units of the selected item that will expire in a given time period. For each of the items that you specify when setting up the report, the printed document shows the number of units that will expire during each of three periods of equal length and the total inventory quantity of the selected item.';
                    }
                }
                group(Reports)
                {
                    Caption = 'Inventory Statistics';
                    Image = "Report";
                    action("Inventory - Sales Statistics")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Inventory - Sales Statistics';
                        Image = "Report";
                        RunObject = Report "Inventory - Sales Statistics";
                        ToolTip = 'View, print, or save a summary of selected items'' sales per customer, for example, to analyze the profit on individual items or trends in revenues and profit. The report specifies direct unit cost, unit price, sales quantity, sales in LCY, profit percentage, and profit.';
                    }
                    action("Inventory - Customer Sales")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Inventory - Customer Sales';
                        Image = "Report";
                        RunObject = Report "Inventory - Customer Sales";
                        ToolTip = 'View, print, or save a list of customers that have purchased selected items within a selected period, for example, to analyze customers'' purchasing patterns. The report specifies quantity, amount, discount, profit percentage, and profit.';
                    }
                    action("Inventory - Top 10 List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory - Top 10 List';
                        Image = "Report";
                        RunObject = Report "Inventory - Top 10 List";
                        ToolTip = 'View information about the items with the highest or lowest sales within a selected period. You can also choose that items that are not on hand or have not been sold are not included in the report. The items are sorted by order size within the selected period. The list gives a quick overview of the items that have sold either best or worst, or the items that have the most or fewest units on inventory.';
                    }
                }
                group("Finance Reports")
                {
                    Caption = 'Finance Reports';
                    Image = "Report";
                    action("Inventory Valuation")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Valuation';
                        Image = "Report";
                        RunObject = Report "Inventory Valuation";
                        ToolTip = 'View, print, or save a list of the values of the on-hand quantity of each inventory item.';
                    }
                    action(StatusAction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Status';
                        Image = "Report";
                        RunObject = Report Status;
                        ToolTip = 'View, print, or save the status of partially filled or unfilled orders so you can determine what effect filling these orders may have on your inventory.';
                    }
                    action("Item Age Composition - Value")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Age Composition - Value';
                        Image = "Report";
                        RunObject = Report "Item Age Composition - Value";
                        ToolTip = 'View, print, or save an overview of the current age composition of selected items in your inventory.';
                    }
                }
            }
            group(Orders)
            {
                Caption = 'Orders';
                action("Inventory Order Details")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory Order Details';
                    Image = "Report";
                    RunObject = Report "Inventory Order Details";
                    ToolTip = 'View a list of the orders that have not yet been shipped or received and the items in the orders. It shows the order number, customer''s name, shipment date, order quantity, quantity on back order, outstanding quantity and unit price, as well as possible discount percentage and amount. The quantity on back order and outstanding quantity and amount are totaled for each item. The report can be used to find out whether there are currently shipment problems or any can be expected.';
                }
                action("Inventory Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory Purchase Orders';
                    Image = "Report";
                    RunObject = Report "Inventory Purchase Orders";
                    ToolTip = 'View a list of items on order from vendors. It also shows the expected receipt date and the quantity and amount on back orders. The report can be used, for example, to see when items should be received and whether a reminder of a back order should be issued.';
                }
                action("Inventory - Vendor Purchases")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory - Vendor Purchases';
                    Image = "Report";
                    RunObject = Report "Inventory - Vendor Purchases";
                    ToolTip = 'View a list of the vendors that your company has purchased items from within a selected period. It shows invoiced quantity, amount and discount. The report can be used to analyze a company''s item purchases.';
                }
                action("Inventory - Reorders")
                {
                    ApplicationArea = Planning;
                    Caption = 'Inventory - Reorders';
                    Image = "Report";
                    RunObject = Report "Inventory - Reorders";
                    ToolTip = 'View a list of items with negative inventory that is sorted by vendor. You can use this report to help decide which items have to be reordered. The report shows how many items are inbound on purchase orders or transfer orders and how many items are in inventory. Based on this information and any defined reorder quantity for the item, a suggested value is inserted in the Qty. to Order field.';
                }
                action("Inventory - Sales Back Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory - Sales Back Orders';
                    Image = "Report";
                    RunObject = Report "Inventory - Sales Back Orders";
                    ToolTip = 'Shows a list of order lines with shipment dates that are exceeded. The report also shows if there are other items for the customer on back order.';
                }
            }
        }
        area(navigation)
        {
            group(Action126)
            {
                Caption = 'Item';
                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action(Attributes)
                {
                    AccessByPermission = TableData "Item Attribute" = R;
                    ApplicationArea = Suite;
                    Caption = 'Attributes';
                    Image = Category;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Scope = Repeater;
                    ToolTip = 'View or edit the item''s attributes, such as color, size, or other characteristics that help to describe the item.';

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Item Attribute Value Editor", Rec);
                        CurrPage.SaveRecord();
                        CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData(Rec."No.");
                    end;
                }
                action("Va&riants")
                {
                    ApplicationArea = Planning;
                    Caption = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View how the inventory level of an item will develop over time according to the variant that you select.';
                }
                action("Category 1 Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 1 Codes';
                    Image = Category;
                    RunObject = Page "eCommerce Order Archive Card";
                    ToolTip = 'Maintain the list of item category 1 codes';
                    Visible = false;
                }
                action("Category 2 Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 2 Codes';
                    Image = Category;
                    RunObject = Page "eComm. Order Archive Subform";
                    ToolTip = 'Maintain the list of item category 2 codes';
                    Visible = false;
                }
                action("Category 3 Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 3 Codes';
                    Image = Category;
                    RunObject = Page "eCommerce Order Archive List";
                    ToolTip = 'Maintain the list of item category 3 codes';
                    Visible = false;
                }
                action("Category 4 Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 4 Codes';
                    Image = Category;
                    RunObject = Page "Freight Approval No.";
                    ToolTip = 'Maintain the list of item category 4 codes';
                    Visible = false;
                }
                action("Business Units")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Units';
                    Description = 'Maintain the list of business units codes';
                    Image = BusinessRelation;
                    RunObject = Page "Business Units";
                    ToolTip = 'Maintain the list of business units codes';
                    Visible = false;
                }
                action(Identifiers)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Identifiers';
                    Image = BarCode;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.", "Variant Code", "Unit of Measure Code");
                    ToolTip = 'View a unique identifier for each item that you want warehouse employees to keep track of within the warehouse when using handheld devices. The item identifier can include the item number, the variant code and the unit of measure.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(27),
                                      "No." = FIELD("No.");
                        Scope = Repeater;
                        ShortCutKey = 'Alt+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action(DimensionsMultiple)
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Item: Record Item;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Item);
                            DefaultDimMultiple.SetMultiRecord(Item, Rec.FieldNo("No."));
                            DefaultDimMultiple.RunModal();
                        end;
                    }
                }
                action("Item Refe&rences")
                {
                    AccessByPermission = TableData "Item Reference" = R;
                    ApplicationArea = Suite, ItemReferences;
                    Caption = 'Item References';
                    Image = Change;
                    RunObject = Page "Item Reference Entries";
                    RunPageLink = "Item No." = FIELD("No.");
                    Scope = Repeater;
                    ToolTip = 'Set up a customer''s or vendor''s own identification of the selected item. References to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
                }
                action("&Units of Measure")
                {
                    ApplicationArea = Suite;
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = FIELD("No.");
                    Scope = Repeater;
                    ToolTip = 'Set up the different units that the item can be traded in, such as piece, box, or hour.';
                }
                action("E&xtended Texts")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xtended Texts';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    Scope = Repeater;
                    ToolTip = 'Select or set up additional text for the description of the item. Extended text can be inserted under the Description field on document lines for the item.';
                }
                action(Translations)
                {
                    ApplicationArea = Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = FIELD("No."),
                                  "Variant Code" = CONST('');
                    Scope = Repeater;
                    ToolTip = 'Set up translated item descriptions for the selected item. Translated item descriptions are automatically inserted on documents according to the language code.';
                }
                action("Substituti&ons")
                {
                    ApplicationArea = Suite;
                    Caption = 'Substituti&ons';
                    Image = ItemSubstitution;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View substitute items that are set up to be sold instead of the item.';
                }
            }
            group(Availability)
            {
                Caption = 'Availability';
                Image = Item;
                action("Items b&y Location")
                {
                    AccessByPermission = TableData Location = R;
                    ApplicationArea = Location;
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;
                    ToolTip = 'Show a list of items grouped by location.';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Items by Location", Rec);
                    end;
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    Enabled = IsInventoriable;

                    action("<Action5>")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByEvent());
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';
                    }
                    action(Variant)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View the current and projected quantity of the item for each variant.';
                    }
                    action(Location)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Location';
                        Image = Warehouse;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View the actual and projected quantity of the item per location.';
                    }
                    action(Lot)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Lot';
                        Image = LotInfo;
                        RunObject = Page "Item Availability by Lot No.";
                        RunPageLink = "No." = field("No.");
                        ToolTip = 'View the current and projected quantity of the item for each lot.';
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Assembly;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByBOM());
                        end;
                    }
                    action("Unit of Measure")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Unit of Measure';
                        Image = UnitOfMeasure;
                        RunObject = Page "Item Availability by UOM";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View the item''s availability by a unit of measure.';
                    }
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics 365 Sales';
                Visible = CRMIntegrationEnabled;
                Enabled = (BlockedFilterApplied and (not Rec.Blocked)) or not BlockedFilterApplied;
                action(CRMGoToProduct)
                {
                    ApplicationArea = Suite;
                    Caption = 'Product';
                    Image = CoupledItem;
                    ToolTip = 'Open the coupled Dynamics 365 Sales product.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record" = IM;
                    ApplicationArea = Suite;
                    Caption = 'Synchronize';
                    Image = Refresh;
                    ToolTip = 'Send updated data to Dynamics 365 Sales.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        ItemRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(Item);
                        Item.Next();

                        if Item.Count = 1 then
                            CRMIntegrationManagement.UpdateOneNow(Item.RecordId)
                        else begin
                            ItemRecordRef.GetTable(Item);
                            CRMIntegrationManagement.UpdateMultipleNow(ItemRecordRef);
                        end
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Business Central record and a Dynamics 365 Sales record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Dynamics 365 Sales product.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(Rec.RecordId);
                        end;
                    }
                    action(MatchBasedCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Match-Based Coupling';
                        Image = CoupledItem;
                        ToolTip = 'Couple items to products in Dynamics 365 Sales based on criteria.';

                        trigger OnAction()
                        var
                            Item: Record Item;
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                            RecRef: RecordRef;
                        begin
                            CurrPage.SetSelectionFilter(Item);
                            RecRef.GetTable(Item);
                            CRMIntegrationManagement.MatchBasedCoupling(RecRef);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = D;
                        ApplicationArea = Suite;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Dynamics 365 Sales product.';

                        trigger OnAction()
                        var
                            Item: Record Item;
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                            RecRef: RecordRef;
                        begin
                            CurrPage.SetSelectionFilter(Item);
                            RecRef.GetTable(Item);
                            CRMCouplingManagement.RemoveCoupling(RecRef);
                        end;
                    }
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the item table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(Rec.RecordId);
                    end;
                }
            }
            group("Assembly/Production")
            {
                Caption = 'Assembly/Production';
                Image = Production;
                action(Structure)
                {
                    ApplicationArea = Assembly;
                    Caption = 'Structure';
                    Image = Hierarchy;
                    ToolTip = 'View which child items are used in an item''s assembly BOM or production BOM. Each item level can be collapsed or expanded to obtain an overview or detailed view.';

                    trigger OnAction()
                    var
                        BOMStructure: Page "BOM Structure";
                    begin
                        BOMStructure.InitItem(Rec);
                        BOMStructure.Run();
                    end;
                }
                action("Cost Shares")
                {
                    ApplicationArea = Suite;
                    Caption = 'Cost Shares';
                    Image = CostBudget;
                    ToolTip = 'View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.';

                    trigger OnAction()
                    var
                        BOMCostShares: Page "BOM Cost Shares";
                    begin
                        BOMCostShares.InitItem(Rec);
                        BOMCostShares.Run();
                    end;
                }
                group(Assembly)
                {
                    Caption = 'Assemb&ly';
                    Image = AssemblyBOM;
                    action("<Action32>")
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Assembly BOM';
                        Image = BOM;
                        RunObject = Page "Assembly BOM";
                        RunPageLink = "Parent Item No." = FIELD("No.");
                        ToolTip = 'View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.';
                    }
                    action("Where-Used")
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Where-Used';
                        Image = Track;
                        RunObject = Page "Where-Used List";
                        RunPageLink = Type = CONST(Item),
                                      "No." = FIELD("No.");
                        RunPageView = SORTING(Type, "No.");
                        ToolTip = 'View a list of assembly BOMs in which the item is used.';
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        ApplicationArea = Assembly;
                        Caption = 'Calc. Assembly Std. Cost';
                        Image = CalculateCost;
                        ToolTip = 'Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item''s assembly BOM. The unit cost of a parent item must equal the total of the unit costs of its components, subassemblies, and any resources.';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem(Rec."No.", true);
                        end;
                    }
                    action("Calc. Unit Price")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        ApplicationArea = Assembly;
                        Caption = 'Calc. Unit Price';
                        Image = SuggestItemPrice;
                        ToolTip = 'Calculate the unit price based on the unit cost and the profit percentage.';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcAssemblyItemPrice(Rec."No.");
                        end;
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    Image = Production;
                    action("Production BOM")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Production BOM';
                        Image = BOM;
                        RunObject = Page "Production BOM";
                        RunPageLink = "No." = FIELD("Production BOM No.");
                        ToolTip = 'Open the item''s production bill of material to view or edit its components.';
                    }
                    action(Action29)
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        ApplicationArea = Manufacturing;
                        Caption = 'Where-Used';
                        Image = "Where-Used";
                        ToolTip = 'View a list of production BOMs in which the item is used.';

                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WorkDate());
                            ProdBOMWhereUsed.RunModal();
                        end;
                    }
                    action(Action24)
                    {
                        AccessByPermission = TableData "Production BOM Header" = R;
                        ApplicationArea = Manufacturing;
                        Caption = 'Calc. Production Std. Cost';
                        Image = CalculateCost;
                        ToolTip = 'Calculate the unit cost of the item by rolling up the unit cost of each component and resource in the item''s production BOM. The unit cost of a parent item must equal the total of the unit costs of its components, subassemblies, and any resources.';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem(Rec."No.", false);
                        end;
                    }
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action16)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Statistics';
                        Image = Statistics;
                        ShortCutKey = 'F7';
                        ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RunModal();
                        end;
                    }
                    action("Entry Statistics")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Entry Statistics';
                        Image = EntryStatistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No." = FIELD("No."),
                                      "Date Filter" = FIELD("Date Filter"),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View statistics for item ledger entries.';
                    }
                    action("T&urnover")
                    {
                        ApplicationArea = Suite;
                        Caption = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
                    }
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
            group(Sales)
            {
                Caption = 'S&ales';
                Image = Sales;
                action("Prepa&yment Percentages")
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
                }
                action(Action37)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'View a list of ongoing sales orders for the item.';
                }
                action("Returns Orders")
                {
                    ApplicationArea = SalesReturnOrder;
                    Caption = 'Sales Returns Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'View ongoing sales return orders for the item.';
                }
            }
            group(Purchases)
            {
                Caption = '&Purchases';
                Image = Purchasing;
                action("Ven&dors")
                {
                    ApplicationArea = Planning;
                    Caption = 'Ven&dors';
                    Image = Vendor;
                    RunObject = Page "Item Vendor Catalog";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View the list of vendors who can supply the item, and at which lead time.';
                }
                action(Action125)
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
                }
                action(Action40)
                {
                    ApplicationArea = Suite;
                    Caption = 'Purchase Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'View a list of ongoing purchase orders for the item.';
                }
                action("Return Orders")
                {
                    ApplicationArea = PurchReturnOrder;
                    Caption = 'Purchase Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'Open the list of ongoing purchase return orders for the item.';
                }
                action("Ca&talog Items")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ca&talog Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                    ToolTip = 'View the list of items that you do not carry in inventory. ';
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("&Bin Contents")
                {
                    ApplicationArea = Warehouse;
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Content";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.';
                }
                action("Stockkeepin&g Units")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Stockkeepin&g Units';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'Open the item''s SKUs to view or edit instances of the item at different locations or with different variants. ';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Ser&vice Items")
                {
                    ApplicationArea = Service;
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View instances of the item as service items, such as machines that you maintain or repair for customers through service orders. ';
                }
                action(Troubleshooting)
                {
                    AccessByPermission = TableData "Service Header" = R;
                    ApplicationArea = Service;
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;
                    ToolTip = 'View or edit information about technical problems with a service item.';

                    trigger OnAction()
                    var
                        TroubleshootingHeader: Record "Troubleshooting Header";
                    begin
                        TroubleshootingHeader.ShowForItem(Rec);
                    end;
                }
                action("Troubleshooting Setup")
                {
                    ApplicationArea = Service;
                    Caption = 'Troubleshooting Setup';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or edit your settings for troubleshooting service items.';
                }
            }
            group(Resources)
            {
                Caption = 'Resources';
                Image = Resource;
                action("Resource &Skills")
                {
                    ApplicationArea = Service;
                    Caption = 'Resource &Skills';
                    Image = ResourceSkills;
                    RunObject = Page "Resource Skills";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
                }
                action("Skilled R&esources")
                {
                    AccessByPermission = TableData "Service Header" = R;
                    ApplicationArea = Service;
                    Caption = 'Skilled R&esources';
                    Image = ResourceSkills;
                    ToolTip = 'View a list of all registered resources with information about whether they have the skills required to service the particular service item group, item, or service item.';

                    trigger OnAction()
                    var
                        ResourceSkill: Record "Resource Skill";
                    begin
                        Clear(SkilledResourceList);
                        SkilledResourceList.Initialize(ResourceSkill.Type::Item, Rec."No.", Rec.Description);
                        SkilledResourceList.RunModal();
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(AdjustInventory_Promoted; AdjustInventory)
                {
                }
                actionref(CopyItem_Promoted; CopyItem)
                {
                }
                actionref(ChangeLog_Promoted; "Change Log")
                {

                }
            }
            group(Category_Category4)
            {
                Caption = 'Item', Comment = 'Generated from the PromotedActionCategories property index 3.';

                group(Category_Dimensions)
                {
                    Caption = 'Dimensions';
                    ShowAs = SplitButton;

                    actionref(DimensionsMultiple_Promoted; DimensionsMultiple)
                    {
                    }
                    actionref(DimensionsSingle_Promoted; DimensionsSingle)
                    {
                    }
                }
                actionref(ApprovalEntries_Promoted; ApprovalEntries)
                {
                }
                actionref(Action16_Promoted; Action16)
                {
                }
                actionref("Co&mments_Promoted"; "Co&mments")
                {
                }

                separator(Navigate_Separator)
                {
                }

                actionref("Items b&y Location_Promoted"; "Items b&y Location")
                {
                }
                group("Category_Item Availability by")
                {
                    Caption = 'Item Availability by';

                    actionref("<Action5>_Promoted"; "<Action5>")
                    {
                    }
                    actionref("BOM Level_Promoted"; "BOM Level")
                    {
                    }
                    actionref(Period_Promoted; Period)
                    {
                    }
                    actionref(Variant_Promoted; Variant)
                    {
                    }
                    actionref(Location_Promoted; Location)
                    {
                    }
                    actionref(Lot_Promoted; Lot)
                    {
                    }
                    actionref("Unit of Measure_Promoted"; "Unit of Measure")
                    {
                    }
                }
                actionref(Structure_Promoted; Structure)
                {
                }
                actionref("Cost Shares_Promoted"; "Cost Shares")
                {
                }
                actionref("Item Refe&rences_Promoted"; "Item Refe&rences")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'History', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Prices & Discounts', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref(SalesPriceLists_Promoted; SalesPriceLists)
                {
                }
                actionref(PurchPriceLists_Promoted; PurchPriceLists)
                {
                }
                actionref(SalesPriceListsDiscounts_Promoted; SalesPriceListsDiscounts)
                {
                }
                actionref(PurchPriceListsDiscounts_Promoted; PurchPriceListsDiscounts)
                {
                }
            }
            group(Category_Category8)
            {
                Caption = 'Periodic Activities', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Inventory', Comment = 'Generated from the PromotedActionCategories property index 8.';

            }
            group(Category_Category10)
            {
                Caption = 'Attributes', Comment = 'Generated from the PromotedActionCategories property index 9.';

                actionref(Attributes_Promoted; Attributes)
                {
                }
                actionref(FilterByAttributes_Promoted; FilterByAttributes)
                {
                }
                actionref(ClearAttributes_Promoted; ClearAttributes)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Item Price List_Promoted"; "Item Price List")
                {
                }
                actionref("Inventory - Reorders_Promoted"; "Inventory - Reorders")
                {
                }
                actionref("Inventory - Sales Back Orders_Promoted"; "Inventory - Sales Back Orders")
                {
                }
            }
            group(Category_Synchronize)
            {
                Caption = 'Synchronize';
                Visible = CRMIntegrationEnabled;

                group(Category_Coupling)
                {
                    Caption = 'Coupling';
                    ShowAs = SplitButton;

                    actionref(ManageCRMCoupling_Promoted; ManageCRMCoupling)
                    {
                    }
                    actionref(DeleteCRMCoupling_Promoted; DeleteCRMCoupling)
                    {
                    }
                    actionref(MatchBasedCoupling_Promoted; MatchBasedCoupling)
                    {
                    }
                }
                actionref(CRMSynchronizeNow_Promoted; CRMSynchronizeNow)
                {
                }
                actionref(CRMGoToProduct_Promoted; CRMGoToProduct)
                {
                }
                actionref(ShowLog_Promoted; ShowLog)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        if CRMIntegrationEnabled then
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);

        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData(Rec."No.");

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        SetWorkflowManagementEnabledState();

        CurrPage.PowerBIEmbeddedReportPart.PAGE.SetCurrentListSelection(Rec."No.");
    end;

    trigger OnAfterGetRecord()
    begin
        EnableControls();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        Found: Boolean;
    begin
        if RunOnTempRec then begin
            TempItemFilteredFromAttributes.Copy(Rec);
            Found := TempItemFilteredFromAttributes.Find(Which);
            if Found then
                Rec := TempItemFilteredFromAttributes;
            exit(Found);
        end;
        exit(Rec.Find(Which));
    end;

    trigger OnInit()
    begin
        CurrPage.PowerBIEmbeddedReportPart.PAGE.InitPageRatio(PowerBIServiceMgt.GetFactboxRatio());
        CurrPage.PowerBIEmbeddedReportPart.PAGE.SetPageContext(CurrPage.ObjectId(false));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        if RunOnTempRec then begin
            TempItemFilteredFromAttributes.Copy(Rec);
            ResultSteps := TempItemFilteredFromAttributes.Next(Steps);
            if ResultSteps <> 0 then
                Rec := TempItemFilteredFromAttributes;
            exit(ResultSteps);
        end;
        exit(Rec.Next(Steps));
    end;

    trigger OnOpenPage()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled();
        if CRMIntegrationEnabled then
            if IntegrationTableMapping.Get('ITEM-PRODUCT') then
                BlockedFilterApplied := IntegrationTableMapping.GetTableFilter().Contains('Field54=1(0)');
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
        IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled();
        SetWorkflowManagementEnabledState();
        IsOnPhone := ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::Phone;
        //15-51643 -
        IF ItemListFilter <> '' THEN BEGIN
            Rec.SETFILTER("No.", ItemListFilter);
            CurrPage.CAPTION := 'Item List [Filtered]';
        END;
        //15-51643 +
        Rec.SetLocationFilterOnMainWarehouse();  // 05-07-19 ZY-LD 008

    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(FALSE);  // 25-04-18 ZY-LD 007
    end;

    var
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        TempItemFilteredFromAttributes: Record Item temporary;
        TempItemFilteredFromPickItem: Record Item temporary;
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        PowerBIServiceMgt: Codeunit "Power BI Service Mgt.";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ClientTypeManagement: Codeunit "Client Type Management";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        SkilledResourceList: Page "Skilled Resource List";
        ItemListFilter: text;

    protected var
        IsFoundationEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        BlockedFilterApplied: Boolean;
        ExtendedPriceEnabled: Boolean;
        NewFromPictureVisible: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        IsOnPhone: Boolean;
        RunOnTempRec: Boolean;
        EventFilter: Text;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        RunOnPickItem: Boolean;
        [InDataSet]
        IsNonInventoriable: Boolean;
        [InDataSet]
        IsInventoriable: Boolean;

        SI: Codeunit "Single Instance";
        ZyWsMgt: Codeunit "Zyxel Web Service Management";
        Text001: Label 'Do you want to replicate %1 to subs?';
        VckXmlMgt: Codeunit "VCK Download and  Import Doc.";
        Text002: Label 'Do you want to resend %1 to VCK?';
        Text003: Label 'Do you want to send all active items to VCK?';
        Text004: Label 'Are you sure?';
        Text005: Label 'Item %1 was sent.';
        Text006: Label 'Item %1 was not sent.';
        AvailabilityprLocation: Page "Availability pr Location";
        SendAllItemsToVCKVisible: Boolean;

    procedure SelectActiveItems(): Text
    var
        Item: Record Item;
    begin
        exit(SelectInItemList(Item));
    end;

    procedure SelectActiveItemsForSale(): Text
    var
        Item: Record Item;
    begin
        Item.SetRange("Sales Blocked", false);
        exit(SelectInItemList(Item));
    end;

    procedure SelectActiveItemsForPurchase(): Text
    var
        Item: Record Item;
    begin
        Item.SetRange("Purchasing Blocked", false);
        exit(SelectInItemList(Item));
    end;

    procedure SelectActiveItemsForTransfer(): Text
    var
        SelectedItem: Record Item;
    begin
        SelectedItem.SetRange(Type, SelectedItem.Type::Inventory);
        OnSelectActiveItemsForTransferAfterSetFilters(SelectedItem);
        exit(SelectInItemList(SelectedItem));
    end;

    procedure SelectInItemList(var Item: Record Item): Text
    var
        ItemListPage: Page "Item List";
    begin
        Item.SetRange(Blocked, false);
        ItemListPage.SetTableView(Item);
        ItemListPage.LookupMode(true);
        if ItemListPage.RunModal() = ACTION::LookupOK then
            exit(ItemListPage.GetSelectionFilter());
    end;

    procedure GetSelectionFilter(): Text
    var
        Item: Record Item;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Item);
        exit(SelectionFilterManagement.GetSelectionFilterForItem(Item));
    end;

    procedure SetSelection(var Item: Record Item)
    begin
        CurrPage.SetSelectionFilter(Item);
    end;

    local procedure EnableControls()
    begin
        IsNonInventoriable := Rec.IsNonInventoriableType();
        IsInventoriable := Rec.IsInventoriableType();
    end;

    local procedure SetWorkflowManagementEnabledState()
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode() + '|' +
          WorkflowEventHandling.RunWorkflowOnItemChangedCode();

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item, EventFilter);
    end;

    local procedure ClearAttributesFilter()
    begin
        Rec.ClearMarks();
        Rec.MarkedOnly(false);
        TempFilterItemAttributesBuffer.Reset();
        TempFilterItemAttributesBuffer.DeleteAll();
        Rec.FilterGroup(0);
        Rec.SetRange("No.");
    end;

    procedure SetTempFilteredItemRec(var Item: Record Item)
    begin
        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();

        TempItemFilteredFromPickItem.Reset();
        TempItemFilteredFromPickItem.DeleteAll();

        RunOnTempRec := true;
        RunOnPickItem := true;

        if Item.FindSet() then
            repeat
                TempItemFilteredFromAttributes := Item;
                TempItemFilteredFromAttributes.Insert();
                TempItemFilteredFromPickItem := Item;
                TempItemFilteredFromPickItem.Insert();
            until Item.Next() = 0;
    end;

    local procedure RestoreTempItemFilteredFromAttributes()
    begin
        if not RunOnPickItem then
            exit;

        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();
        RunOnTempRec := true;

        if TempItemFilteredFromPickItem.FindSet() then
            repeat
                TempItemFilteredFromAttributes := TempItemFilteredFromPickItem;
                TempItemFilteredFromAttributes.Insert();
            until TempItemFilteredFromPickItem.Next() = 0;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnSelectActiveItemsForTransferAfterSetFilters(var Item: Record Item)
    begin
    end;

    PROCEDURE SetItemFilter(ItemFilter: Text[1024]);
    BEGIN
        //ItemListFilter := ItemFilter;
    END;

}
