pageextension 50119 ItemCardZX extends "Item Card"
{
    layout
    {
        #region Item
        addafter(Description)
        {
            field("Model Description"; Rec."Model Description")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'HQ Model Description';
                Importance = Additional;
            }

            field(Status; Rec.Status)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Successor Item No."; Rec."Successor Item No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("RMA Alternative Item No."; Rec."RMA Alternative Item No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = ZNetRHQVisible;
            }
        }
        modify("Service Item Group")
        {
            Visible = false;
        }
        addafter("Automatic Ext. Texts")
        {

            field("Enter Security for Eicard on"; Rec."Enter Security for Eicard on")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Enter Security for Eicard on field.';
            }
            field("Statistics Group Code"; Rec."Statistics Group Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Statistics Group Code field.';
                Importance = Additional;
            }
            group(BlockedGroup)
            {
                Caption = 'Blocked';
                field("Block Reason"; Rec."Block Reason")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Block Reason field.';
                }
                field("Block on Sales Order"; Rec."Block on Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Blocked on Sales Order field.';
                    Enabled = BlockonsalesorderEnable;
                }
                field("Block on Sales Order Reason"; Rec."Block on Sales Order Reason")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of Block Reason field.';
                    Enabled = BlockonsalesorderEnable;
                }
                field(Inactive; Rec.Inactive)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Inactive field.';
                    Editable = InactiveEnable;
                }
            }
            group(Licenses)
            {
                Caption = 'Licenses';
                field(IsEICard; Rec.IsEICard)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Is EICard field.';
                }
                field("Non ZyXEL License"; Rec."Non ZyXEL License")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Non ZyXEL License field.';
                    trigger OnValidate()
                    begin
                        NonZyxelLicVendEnable := Rec."Non ZyXEL License";
                    end;
                }
                field("Non ZyXEL License Vendor"; Rec."Non ZyXEL License Vendor")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Non ZyXEL License Vendor field.';
                    Enabled = NonZyxelLicVendEnable;
                }
            }
        }
        movebefore("Block Reason"; Blocked)
        modify(Blocked)
        {
            Editable = false;
        }
        moveafter(Licenses; "Last Date Modified")

        modify("Common Item No.")
        {
            Visible = false;
        }
        modify("Purchasing Code")
        {
            Visible = false;
        }
        modify(VariantMandatoryDefaultNo)
        {
            Visible = false;
        }
        modify(VariantMandatoryDefaultYes)
        {
            Visible = false;
        }
        #endregion

        #region Replenishment
        addafter(Item)
        {
            group(Ordering)
            {
                Caption = 'Ordering';
            }
        }
        movefirst(Ordering; "Minimum Order Quantity")
        moveafter("Minimum Order Quantity"; "Maximum Order Quantity")
        moveafter("Maximum Order Quantity"; "Order Multiple")
        #endregion

        addlast(Ordering)
        {
            field("Min. Carton Qty. Enabled"; Rec."Min. Carton Qty. Enabled")
            {
            }
            group(ReturnOrder)
            {
                Caption = 'Return Order';
                field("Not Returnable"; Rec."Not Returnable")
                {
                    Caption = 'Not Returable';
                    Visible = ZNetRHQVisible;
                    ToolTip = 'Specifies if the product can be returned via a sales return order.';
                }
            }
        }

        #region Cost & Posting
        moveafter("Costing Method"; "Cost is Adjusted")
        moveafter("Cost is Adjusted"; "Cost is Posted to G/L")
        moveafter("Unit Cost"; "Overhead Rate")
        addafter("Last Direct Cost")
        {
            field("Actual FOB Price"; Rec."Actual FOB Price")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Actual FOB Price field.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    //>> 19-02-20 ZY-LD 025
                    recPurchPrice.SetRange("Asset Type", recPurchPrice."Asset Type"::Item);
                    recPurchPrice.SetRange("Asset No.", Rec."No.");
                    Rec.COPYFILTER("Vendor No. Filter", recPurchPrice."Source No.");
                    Rec.COPYFILTER("Date Filter Act. FOB Pr. Start", recPurchPrice."Starting Date");
                    Page.RunModal(Page::"Price List Lines", recPurchPrice);
                    //<< 19-02-20 ZY-LD 025
                end;
            }
        }
        addafter("Unit Cost")
        {
            field("Allow Unit Cost is Zero"; Rec."Allow Unit Cost is Zero")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies that it´s allowed to post an item without unit cost value.';
            }
        }
        #endregion

        #region Prices & Sales
        addafter("Sales Blocked")
        {
            field("Freight Cost Item"; Rec."Freight Cost Item")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Freight Cost Item field.';
            }
        }
        movebefore("Freight Cost Item"; "Application Wksh. User ID")
        #endregion

        #region Warehouse
        addafter("Prices & Sales")
        {
            group(WarehouseZX)
            {
                Caption = 'Warehouse';
                field("No PLMS Update"; Rec."No PLMS Update")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the No PLMS Update from HQ field.';
                }
                field("Update PLMS from Item No."; Rec."Update PLMS from Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Update PLMS from Item No. field.';
                }
            }
        }
        moveafter("Update PLMS from Item No."; StockoutWarningDefaultYes)
        moveafter("Update PLMS from Item No."; StockoutWarningDefaultNo)
        moveafter(StockoutWarningDefaultNo; PreventNegInventoryDefaultYes)
        moveafter(PreventNegInventoryDefaultYes; PreventNegInventoryDefaultNo)
        addafter(PreventNegInventoryDefaultNo)
        {
            field(PreventEmptyVolumeDefaultYes; Rec."Prevent Empty Volume")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShowPreventEmptyVolumeDefaultYes;
                ToolTip = 'Specifies the value of the Prevent Empty Volume field.';
                OptionCaption = 'Default (Yes),No,Yes';
            }
            field(PreventEmptyVolumeDefaultNo; Rec."Prevent Empty Volume")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShowPreventEmptyVolumeDefaultNo;
                ToolTip = 'Specifies the value of the Prevent Empty Volume field.';
                OptionCaption = 'Default (No),No,Yes';
            }
        }
        moveafter(PreventEmptyVolumeDefaultNo; "Last Phys. Invt. Date")
        moveafter("Last Phys. Invt. Date"; "Identifier Code")
        moveafter("Identifier Code"; "Use Cross-Docking")
        addafter("Use Cross-Docking")
        {
            field("Serial Number Required"; Rec."Serial Number Required")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Serial Number Required field.';
            }
        }
        moveafter("Serial Number Required"; GTIN)
        modify(GTIN)
        {
            Editable = PLMSUpdateEditable;
        }
        addafter(GTIN)
        {
            field(Amaz_ASIN; Rec.Amaz_ASIN)
            {
                ApplicationArea = Basic, Suite;

            }
            field("UN Code"; Rec."UN Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the UN Code field.';
                Editable = PLMSUpdateEditable;
            }
            group(Pallet)
            {
                Caption = 'Pallet';
                field("Cartons Per Pallet"; Rec."Cartons Per Pallet")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Cartons Per Pallet field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Qty Per Pallet"; Rec."Qty Per Pallet")
                {
                    Editable = PLMSUpdateEditable;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty Per Pallet field.';
                }
                field("Pallet Length (cm)"; Rec."Pallet Length (cm)")
                {
                    Editable = PLMSUpdateEditable;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Pallet Length (cm) field.';
                }
                field("Pallet Width (cm)"; Rec."Pallet Width (cm)")
                {
                    Editable = PLMSUpdateEditable;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Pallet Width (cm) field.';
                }
                field("Pallet Height (cm)"; Rec."Pallet Height (cm)")
                {
                    Editable = PLMSUpdateEditable;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Pallet Height (cm) field.';
                }
            }
            group(WEEE)
            {
                Caption = 'WEEE';
                field("Battery weight"; Rec."Battery weight")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Battery weight field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Product Length (cm)"; Rec."Product Length (cm)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Product Length (cm) (WEEE) field.';
                    Editable = PLMSUpdateEditable;
                }

                field("Item Country Code"; Rec."Item Country Code") //15-05-2025 BK #499952
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Country only for country specific Items.';
                }
            }
            group(ColourBox)
            {
                Caption = 'Colour Box';
                field("Length (cm)"; Rec."Length (cm)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Length (cm) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Width (cm)"; Rec."Width (cm)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Width (cm) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Height (cm)"; Rec."Height (cm)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Height (cm) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Volume (cm3)"; Rec."Volume (cm3)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Volume (cm3) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Paper Weight"; Rec."Paper Weight")
                {
                    Caption = 'Paper Weight (kg)';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Paper Weight (kg) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Plastic Weight"; Rec."Plastic Weight")
                {
                    Caption = 'Plastic Weight (Kg)';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Plastic Weight (kg) field.';
                    Editable = PLMSUpdateEditable;
                }
            }
            group(Carton)
            {
                Caption = 'Carton';
                field("Length (ctn)"; Rec."Length (ctn)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Length (ctn) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Width (ctn)"; Rec."Width (ctn)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Width (ctn) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Height (ctn)"; Rec."Height (ctn)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Height (ctn) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Volume (ctn)"; Rec."Volume (ctn)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Volume (ctn) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Carton Weight"; Rec."Carton Weight")
                {
                    Caption = 'Carton Weight (kg)';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Carton Weight (kg) field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Total Qty. per Carton"; Rec."Total Qty. per Carton")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Total Qty. per Carton field.';
                    Editable = PLMSUpdateEditable;
                }
            }
            group(Carton2)
            {
                Caption = 'Carton';
                Visible = false;
                field("Dim Per Unit LxWxH"; Rec."Dim Per Unit LxWxH")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Dim Per Unit LxWxH field.';
                }
                field("Weight Per Unit"; Rec."Weight Per Unit")
                {
                    Caption = 'Weight Per Unit (kg)';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Weight Per Unit (kg) field.';
                }
                field("Dim Per Carton LxWxH"; Rec."Dim Per Carton LxWxH")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Dim Per Carton LxWxH field.';
                }
                field("Weight p_Carton"; Rec."Weight p_Carton")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Weight p_Carton field.';
                }
            }
        }
        moveafter("Plastic Weight"; "Net Weight")
        modify("Net Weight")
        {
            Caption = 'Net Weight (kg)';
        }
        moveafter("Net Weight"; "Gross Weight")
        modify("Gross Weight")
        {
            Caption = 'Gross Weight (kg)';
        }
        addafter("Gross Weight")
        {

            field("Qty. per Color Box"; Rec."Qty. per Color Box")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Qty. per Color Box field.';
            }
        }
        #endregion

        #region Replenishment
        addafter("Purch. Unit of Measure")
        {
            field("Manually OLAP"; Rec."Manually OLAP")
            {
                Caption = 'Manually OLAP PO FCST';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Manually OLAP PO Fcst. field.';
            }
            group(Responsible)
            {
                Caption = 'Responsible';
                field(MDM; Rec.MDM)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the MDM field.';
                }
                field(SCM; Rec.SCM)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the SCM field.';
                }
            }
            field("Last Buy Date"; Rec."Last Buy Date")
            {
                ApplicationArea = Basic, Suite;
                Editable = PLMSUpdateEditable;
            }
            field("Lifecycle Phase"; Rec."Lifecycle Phase")
            {
                ApplicationArea = Basic, Suite;
                Editable = PLMSUpdateEditable;
            }
        }
        modify(Replenishment_Production)
        {
            Visible = false;
        }
        #endregion

        #region Planning
        modify(LotForLotParameters)
        {
            Visible = false;
        }
        modify(ReorderPointParameters)
        {
            Visible = false;
        }
        #endregion

        #region Foreign Trade
        addafter(Planning)
        {
            field(GTIN_Foreign; Rec.GTIN)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the GTIN field.';
                Editable = PLMSUpdateEditable;
            }
            field("No Tariff Code"; Rec."No Tariff Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the No Tariff No. field.';
                trigger OnValidate()
                begin
                    SetActions();  // 09-04-18 ZY-LD 016
                end;
            }
        }
        moveafter(GTIN_Foreign; "Tariff No.")
        modify("Tariff No.")
        {
            Editable = TariffNoEditable;
        }
        #endregion

        #region Analysis / Warranty
        addafter(ItemTracking)
        {
            group(Analysis)
            {
                Caption = 'Analysis';
                field("Category 1 Code"; Rec."Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Category 1 Code field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Category 2 Code"; Rec."Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Category 2 Code field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Category 3 Code"; Rec."Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Category 3 Code field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Category 4 Code"; Rec."Category 4 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Category 4 Code field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Business Center"; Rec."Business Center")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Business Center field.';
                    Editable = PLMSUpdateEditable;
                }
                field(SBU; Rec.SBU)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the SBU field.';
                    Editable = PLMSUpdateEditable;
                }
                field("SBU Company"; Rec."SBU Company")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the SBU Company field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Business to"; Rec."Business to")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Business to field.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Business Unit field.';
                }
                field("EAC Ready"; Rec."EAC Ready")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the EAC Ready field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Part Number Type"; Rec."Part Number Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Part Number Type field.';
                }
                field("PP-Product CAT"; Rec."PP-Product CAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Partner Program Product Category field.';
                }
                field("HQ Model Phase"; Rec."HQ Model Phase")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the HQ Model Phase field.';
                    Editable = PLMSUpdateEditable;
                }
            }
            group(Warranty)
            {
                Caption = 'Warranty';
                field("Warranty Period"; Rec."Warranty Period")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Warranty Period field.';
                    trigger OnValidate()
                    begin
                        if Rec."Warranty Period" = Rec."Warranty Period"::"Limited Lifetime" then
                            Rec."Show In Web" := false;

                        if Rec."Warranty Period" = Rec."Warranty Period"::"N/A" then
                            Rec."Show In Web" := false;
                    end;
                }
                field("End of Life Date"; Rec."End of Life Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the End of Life Date field.';
                }
                field("Web Description"; Rec."Web Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Web Description field.';
                }
                field("Show In Web"; Rec."Show In Web")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Show In Web field.';

                    trigger OnValidate()
                    begin
                        if Rec."Warranty Period" = Rec."Warranty Period"::"Limited Lifetime" then
                            Rec."Show In Web" := false;

                        if Rec."Warranty Period" = Rec."Warranty Period"::"N/A" then
                            Rec."Show In Web" := false;
                    end;
                }
                field("End of Technical Support Date"; Rec."End of Technical Support Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the End of Technical Support Date field.';
                    Editable = PLMSUpdateEditable;
                }
                group(RMA_Grp)
                {
                    Caption = 'RMA';
                    field("RMA Category"; Rec."RMA Category")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the RMA Category field.';
                    }
                    field("RMA count"; Rec."RMA count")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the RMA count field.';
                    }
                    field("Defect service"; Rec."Defect service")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Defect service field.';
                    }
                    field("Module Repair"; Rec."Module Repair")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Module Repair field.';
                    }
                    field("PCB error repair"; Rec."PCB error repair")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the PCB error repair field.';
                    }
                    field("End of RMA Date"; Rec."End of RMA Date")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the End of RMA Date field.';
                        Editable = PLMSUpdateEditable;
                    }
                }
                group(Costs)
                {
                    Caption = 'Costs';
                    field("Refurbish Cost"; Rec."Refurbish Cost")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Refurbish Cost field.';
                    }
                    field("Repair Cost"; Rec."Repair Cost")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Repair Cost field.';
                    }
                    field("RMA Vendor Cost"; Rec."RMA Vendor Cost")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the RMA Vendor Cost field.';
                    }
                }
            }
            group(Chemical)
            {
                Caption = 'Chemical';
                field("Tax Reduction Rate Active"; Rec."Tax Reduction Rate Active")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Tax Reduction Rate Active field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Tax Reduction rate"; Rec."Tax Reduction rate")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Tax Reduction Rate field.';
                    Editable = PLMSUpdateEditable;
                }
                field("Tax rate (SEK/kg)"; Rec."Tax rate (SEK/kg)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Tax rate (SEK/kg) field.';
                }
                field("SVHC > 1000 ppm"; Rec."SVHC > 1000 ppm")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The obligation to submit a SCIP notification covers all articles placed on the EU market containing a substance of very high concern on the Candidate List in a concentration above 0.1 % w/w.';
                }
                field("SCIP No."; Rec.GetScipNo)  // 18-04-24 ZY-LD 000
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'SCIP is the database for information on Substances of Concern In articles as such or in complex objects (Products) established under the Waste Framework Directive (WFD).';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        ScipNumber: Record "SCIP Number";
                        ScipNumberPage: Page "SCIP Numbers";
                    begin
                        ScipNumber.SetRange("Item No.", Rec."No.");
                        Clear(ScipNumberPage);
                        ScipNumberPage.SetTableView(ScipNumber);
                        ScipNumberPage.RunModal();
                    end;
                }
                field("No of SCIP No."; Rec."No of SCIP No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'SCIP is the database for information on Substances of Concern In articles as such or in complex objects (Products) established under the Waste Framework Directive (WFD).';
                    Editable = false;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        ScipNumber: Record "SCIP Number";
                        ScipNumberPage: Page "SCIP Numbers";
                    begin
                        ScipNumber.SetRange("Item No.", Rec."No.");
                        Clear(ScipNumberPage);
                        ScipNumberPage.SetTableView(ScipNumber);
                        ScipNumberPage.RunModal();
                    end;
                }
                field("Product use Battery"; Rec."Product use Battery")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Product or Accessory use Battery field.';
                    Editable = PLMSUpdateEditable;
                }
                field("WEEE Category"; Rec."WEEE Category")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the WEEE Category field.';
                    Editable = PLMSUpdateEditable;
                }
            }
            group(Aging)
            {
                Caption = 'Aging';
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '""Aged Country Code"" is used for the ""Aged Stock Report"". If the field is filld on the item card, it will be used in the report.';
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '"Forecast Territory" is used for the "Aged Stock Report". If the field is filld on the item card, it will be used in the report.';
                }
            }
        }
        moveafter("SBU Company"; "Country/Region of Origin Code")
        #endregion

        #region FactBoxes
        addfirst(factboxes)
        {
            part(ItemWarehouseFactBox; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Bin Filter" = field("Bin Filter"),
                              "Variant Filter" = field("Variant Filter"),
                              "Lot No. Filter" = field("Lot No. Filter"),
                              "Serial No. Filter" = field("Serial No. Filter");
            }
            part(ItemCommentFactBox; "Item Comment FactBox")
            {
                ApplicationArea = All;
                Caption = 'Item Comment';
                Visible = false;
                SubPageLink = "Table Name" = const(Item),
                              "No." = field("No.");
            }

        }
        #endregion
    }

    actions
    {
        modify(Location)
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
        }
        modify(Assembly)
        {
            Caption = 'Assembly/Production/Rework';
        }
        addafter(Identifiers)
        {
            Action("Additional Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Additional Items';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Additional Item List";
                RunPageLink = "Item No." = field("No.");
            }
            Action("Block Customer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Block Customer';
                Image = Stop;
                RunObject = Page "Item/Customer Relation";
                RunPageLink = "Customer No." = field("No.");
            }
            Action("Chemical Tax Reduction Rate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chemical Tax Reduction Rate';
                Image = TaxPayment;
                RunObject = Page "Chemical Tax Rates";
            }
        }
        addafter(Coupling)
        {
            Action(Action23)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Additional Items';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Additional Item List";
                RunPageLink = "Item No." = field("No.");
            }
        }
        addafter("Ledger E&ntries")
        {
            Action("Whse. Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Whse. Ledger Entries';
                Image = Warehouse;
                RunObject = Page "Whse. Item Ledger Entry";
                RunPageLink = "Item No." = field("No.");
                ShortCutKey = 'Shift+F7';
            }
            Action("Item Forecast Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Forecast Entries';
                Image = Forecast;
                RunObject = Page "Item Budget Entries";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Analysis Area", "Budget Name", "Item No.", Date)
                              where("Budget Name" = const('MASTER'),
                                    Quantity = filter(<> 0));
            }
            Action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("No.");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(27));
            }
        }
        addafter("Application Worksheet")
        {
            Action("Serial No. Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Serial No. Entries';
                Image = SerialNo;
                RunObject = Page "VCK Delivery Document SNos";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Item No.", "Posting Date", "Serial No.")
                              order(descending);
            }
            Action(RMA)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'RMA';
                Image = Entries;
                RunObject = Page "RMA Entries";
                RunPageLink = "Item No." = field("No.");
            }
        }
        addafter(Action163)
        {
            Action("Start Picking Date pr. Country")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Start Picking Date pr. Country';
                Image = CalculateShipment;
                RunObject = Page "Item Picking Date pr. Country";
                RunPageLink = "Item No." = field("No.");
            }
        }
        addafter(Production)
        {
            group(Rework)
            {
                Caption = 'Rework';
                Image = BOM;
                Action(Action166)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rework BOM';
                    RunObject = Page "Rework BOM";
                    RunPageLink = "Parent Item No." = field("No.");
                }
            }
        }
        addfirst(Reporting)
        {
            action("Item - Chemical Tax Reduction Rate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item - Chemical Tax Reduction Rate';
                Image = "Report";
                RunObject = Report "Item - Chemical Tax Red. Rate";
            }
            action(ScipNo)  // 17-04-24 ZY-LD 000
            {
                ApplicationArea = Basic, Suite;
                Caption = 'SCIP No.';
                Image = NumberGroup;
                RunObject = page "SCIP Numbers";
                RunPageLink = "Item No." = field("No.");
                ToolTip = 'Specifies SCIP Number that is related to chemical tax in Sweden. The SCIP number is a random sequence of 36 hexadecimal characters that follows the Universally Unique Identifier (UUID) format. There is no relationship between the SCIP number for one supplier part and another part submitted by the same supplier.';
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 15-02-18 ZY-LD 014
        Rec.CalcFields("Actual FOB Price");  // 19-02-20 ZY-LD 025
    end;

    trigger OnClosePage()
    begin
        //>> 28-04-18 ZY-LD 017
        if ChangesHasBeenMade then
            ZyWebSrvMgt.ReplicateItems('', Rec."No.", false, false);  // 23-10-18 ZY-LD 019  // 07-01-19 ZY-LD
                                                                      //ReplicateItems.ReplicateItem(Rec);  // 23-10-18 ZY-LD 019
                                                                      //<< 28-04-18 ZY-LD 017
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 018
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangesHasBeenMade := true;  // 28-04-18 ZY-LD 017
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangesHasBeenMade := true;  // 28-04-18 ZY-LD 017
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangesHasBeenMade := true;  // 28-04-18 ZY-LD 017
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        InvtSetup: Record "Inventory Setup";
    begin
        Rec."Minimum Order Quantity" := 1; //moved from InitValue

        EnablePlanningControls;
        EnableCostingControls;
        //ZL111005A+
        InvtSetup.Get();
        if (InvtSetup."Default Item Disc. Group" <> '') then begin
            Rec."Item Disc. Group" := InvtSetup."Default Item Disc. Group";
        end;
        AdditionalItemEnable := Rec."Add Additional Item";
        NonZyxelLicVendEnable := Rec."Non ZyXEL License";
        //ZL111005A-
    end;

    trigger OnAfterGetCurrRecord()
    begin
        //>> 28-10-21 ZY-LD 017
        if ChangesHasBeenMade then begin
            ZyWebSrvMgt.ReplicateItems('', Rec."No.", false, false);
            ChangesHasBeenMade := false;
        end;
        //<< 28-10-21 ZY-LD 017
    end;

    trigger OnOpenPage()
    begin
        //15-51643 -
        AdditionalItemEnable := true;
        NonZyxelLicVendEnable := true;
        BlockonsalesorderEnable := true;
        InactiveEnable := true;
        //15-51643 +

        SetActions();  // 15-02-18 ZY-LD 014
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 018
        Rec.SetFilter("Tax Reduction Rate Date Filter", '..%1', WORKDATE);  // 02-03-22 ZY-LD 028

        //>> 19-02-20 ZY-LD 025
        if ZGT.IsRhq then begin
            recVendZCom.SetRange("SBU Company", recVendZCom."SBU Company"::"ZCom HQ");
            recVendZCom.FindFirst();
            recVendZNet.SetRange("SBU Company", recVendZNet."SBU Company"::"ZNet HQ");
            recVendZNet.FindFirst();
            Rec.SetFilter("Vendor No. Filter", '%1|%2', recVendZCom."No.", recVendZNet."No.");
            Rec.SetFilter("Date Filter Act. FOB Pr. Start", '..%1', TODAY);
            Rec.SetFilter("Date Filter Act. FOB Pr. End", '%1|%2..', 0D, TODAY);
            Rec.CalcFields("Actual FOB Price");
        end;
        //<< 19-02-20 ZY-LD 025
    end;

    var
        TxtInfo001: Label 'Additional Items are added to delivery documents free of charge and do not deplete stock.';
        [InDataSet]
        AdditionalItemEnable: Boolean;
        [InDataSet]
        NonZyxelLicVendEnable: Boolean;
        [InDataSet]
        BlockonsalesorderEnable: Boolean;
        InactiveEnable: Boolean;
        TxtInfo002: Label 'Additional Items are added to the sales order and deplete stock.';
        PLMSUpdateEditable: Boolean;
        TariffNoEditable: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        ChangesHasBeenMade: Boolean;
        SI: Codeunit "Single Instance";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        recVendZCom: Record Vendor;
        recVendZNet: Record Vendor;
        PurchasePricesPage: Page "Price List Lines";
        recPurchPrice: Record "Price List Line";
        MDMBufferEditable: Boolean;
        ShowPreventEmptyVolumeDefaultYes: Boolean;
        ShowPreventEmptyVolumeDefaultNo: Boolean;
        UpdatePlmsFromItemNoEditable: Boolean;
        ZNetRHQVisible: Boolean;

    local procedure SetActions()
    var
        recUserSetup: Record "User Setup";
        InventorySetup: Record "Inventory Setup";
    begin
        //15-51643 -
        AdditionalItemEnable := Rec."Add Additional Item";
        NonZyxelLicVendEnable := Rec."Non ZyXEL License";
        if not recUserSetup.Get(UserId()) then
            Clear(recUserSetup);
        BlockonsalesorderEnable := recUserSetup."Can Block Items";
        InactiveEnable := recUserSetup."Can Block Items";
        //15-51643 +

        if ZGT.IsRhq then begin
            //>> 24-03-23 ZY-LD 029
            if Rec."Update PLMS from Item No." <> '' then
                PLMSUpdateEditable := false
            else  //<< 24-03-23 ZY-LD 029
                PLMSUpdateEditable := Rec."No PLMS Update";

            //>> 24-03-23 ZY-LD 029
            UpdatePlmsFromItemNoEditable := PLMSUpdateEditable;
            if Rec."Update PLMS from Item No." <> '' then
                UpdatePlmsFromItemNoEditable := true;
            //<< 24-03-23 ZY-LD 029
        end else
            PLMSUpdateEditable := false;

        TariffNoEditable := not Rec."No Tariff Code";  // 09-04-18 ZY-LD 016

        MDMBufferEditable := (UserId() = Rec.MDM) or (UserId() = Rec.SCM) or recUserSetup.SCM;  // 25-11-21 ZY-LD 027

        InventorySetup.Get();
        ShowPreventEmptyVolumeDefaultYes := InventorySetup."Prevent Empty Volume";
        ShowPreventEmptyVolumeDefaultNo := not ShowPreventEmptyVolumeDefaultYes;

        ZNetRHQVisible := ZGT.IsRhq AND ZGT.IsZNetCompany;
    end;
}
