tableextension 50114 ItemZX extends Item
{
    // 001. 12-12-17 ZY-LD New field "EMS License".
    // 002. 08-03-18 ZY-LD 2018022810000231 - Category Code has moved into new fields. Caption has been changed to field name.
    // 003. 14-03-18 ZY-LD 2018031310000276 - "Is EiCard is added to dropdown.
    // 004. 09-04-18 ZY-LD 2018032210000151 - New field. 
    // 005. 15-06-18 ZY-LD 000 - Count entries pr. country.
    // 006. 17-08-18 ZY-LD 2018081710000054 - New field.
    // 007. 25-09-18 ZY-LD 2018092510000144 - New option on "Warranty Period" = SP RMA.
    // 008. 15-11-18 ZY-LD 000 - New field.
    // 009. 29-11-18 ZY-LD 000 - Filter changed on "Country/Region Exists".
    // 010. 13-12-18 ZY-LD 2018121310000115 - MDM and SCM is extended from 20 to 30 characters.
    // 011. 16-01-19 ZY-LD 2019011610000085 - An Item can't be both B2B and B2C.
    // 012. 11-02-19 ZY-LD 2019021110000136 - Caption added to "PP-Product CAT".
    // 013. 11-03-19 PAB 2019031110000161 - New Fields Added
    // 014. 27-05-19 ZY-LD 
    // 015. 05-07-19 ZY-LD P0213 Calculate available stock.
    // 016. 09-08-19 ZY-LD 2019080810000097 - New field.
    // 017. 13-09-19 ZY-LD 000 - Option "Blocked" is added to Status.
    // 018. 16-10-19 ZY-LD 000 - New field "SBU Company".
    // 019. 23-10-19 ZY-LD 2019102210000109 - Deduct "Trans. Ord. Shipment (Qty.)" from Avaliable Stock.
    // 020. 10-01-20 ZY-LD 2020011010000039 - "Qty. on Reciept Lines" has not been used for a long time. It had a filter, so it got active from 01-01-20. Field is deactivated.
    // 021. 14-01-19 ZY-LD 000 - New field - Battery Certificate, and Rework is added as a Status.
    // 022. 17-02-20 ZY-LD 000 - New fields.
    // 023. 19-02-20 ZY-LD 000 - New fields.
    // 024. 04-03-20 ZY-LD 000 - German language on table and selected fields.
    // 025. 22-04-20 ZY-LD 2020042210000038 - "Order Type" and location code is added as filter on "Qty. on Shipping Detail" and "HQ Unshipped Quantity".
    // 026. 06-08-20 ZY-LD 2020072910000047 - New option is added to Warrenty period.
    // 027. 21-09-20 ZY-LD P0476 - New fields.
    // 028. 06-10-20 ZY-LD 000 - New field used on the report Aged Stock.
    // 029. 07-10-20 ZY-LD 000 - New field. "Business to" is replacing B2B and B2C.
    // 030. 29-12-20 ZY-LD P0499 - New field.
    // 031. 05-01-20 ZY-LD 000 - New field. Substances of Concern In articles as such or in complex objects (Products).
    // 032. 24-02-21 ZY-LD 2021022310000136 - Customer Filter is added to "Sales (Qty)".
    // 033. 22-04-21 ZY-LD 2021020910000118 - New field.
    // 034. 05-07-21 ZY-LD 2021070210000247 - New field.
    // 035. 24-08-21 ZY-LD 2021082410000071 - New fields.
    // 036. 27-04-21 ZY-LD 2021042310000105 - "Identifier Code" is extended from 20 to 30 characters, so we can handle larger numbers from Amazon.
    // 037. 28-10-21 ZY-LD 000 - 
    // 038. 25-11-21 ZY-LD 2021112510000071 - New field.
    // 039. 02-03-22 ZY-LD 2022030210000038 - New field.
    // 040. 15-03-22 ZY-LD 000 - New field.
    // 041. 12-04-22 ZY-LD P0747 - New field to calculate cost amount without freight cost. The filter is added to "Cost Amount (Expected)", "Cost Amount (Actual)" and "Cost Posted to G/L".
    // 042. 18-05-22 ZY-LD 2022011110000088 - New field.
    // 043. 03-06-22 ZY-LD 2022060310000049 - Get the filter from function.
    // 044. 02-11-22 ZY-LD 000 - On request from Taiwan (John).
    // 045. 23-02-22 ZY-LD 000 - New field.
    // 046. 24-03-23 ZY-LD #4608164 - Only one rework item can be updated from PLMS. If there are more than one we can setup the update.
    // 047. 17-05-23 ZY-LD New fields.
    // 048. 25-10-23 ZY-LD 000 - New field.
    // 049. 18-04-24 ZY-LD 000 - SCIP No. has been moved to a subtable, because there can be more than one number.

    fields
    {
        modify("Gross Weight")
        {
            Caption = 'Gross Weight (kg)';
        }
        modify("Net Weight")
        {
            Caption = 'Net Weight (kg)';
        }
        field(50000; "Shipment (Qty.)"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry".Quantity where("Entry Type" = const(Sale),
                                                                   "Item No." = field("No."),
                                                                   "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                   "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                   "Location Code" = field("Location Filter"),
                                                                   "Drop Shipment" = field("Drop Shipment Filter"),
                                                                   "Posting Date" = field("Date Filter"),
                                                                   "Variant Code" = field("Variant Filter"),
                                                                   "Lot No." = field("Lot No. Filter"),
                                                                   "Serial No." = field("Serial No. Filter")));
            Caption = 'Shipment (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = '05-07-21 ZY-LD 034';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Statistics Group Code"; Code[10])
        {
            Caption = 'Statistics Group Code';
            Description = '28-10-21 ZY-LD 037';
            TableRelation = SBU.Code where(Type = const("Statistics Category"));
        }
        field(50003; "Not Returnable"; Boolean)  // 22-08-24 ZY-LD 000
        {
            Caption = 'Return Order - Not Returnable';
            InitValue = true;
        }
        field(50005; "EMS License"; Boolean)
        {
            Caption = 'EMS License';
            Description = '12-12-17 ZY-LD 001';
        }
        field(50006; "No Tariff Code"; Boolean)
        {
            Caption = 'No Tariff No.';
            Description = '09-04-18 ZY-LD 004';
        }
        field(50007; "HQ Model Phase"; Code[2])
        {
            Caption = 'HQ Model Phase';
            Description = '30-04-18 ZY-LD';
        }
        field(50008; "Country/Region Filter"; Code[20])
        {
            Caption = 'Country/Region Filter';
            Description = '15-06-18 ZY-LD 005';
            FieldClass = FlowFilter;
            TableRelation = "Country/Region";
        }
        field(50009; "Country/Region Exists"; Boolean)
        {
            CalcFormula = exist("Item Ledger Entry" where("Item No." = field("No."),
                                                          "Entry Type" = const(Sale),
                                                          "Posting Date" = field("Date Filter"),
                                                          "Country/Region Code" = field("Country/Region Filter")));
            Caption = 'Country/Region Exists';
            Description = '15-06-18 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Physical Item"; Boolean)
        {
            Caption = 'Physical Item';
            Description = 'Unused';
        }
        field(50011; "Total Inventory"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                 "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                 "Drop Shipment" = field("Drop Shipment Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Description = '05-07-19 ZY-LD 015';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Qty. on Sales Order Confirmed"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Shipment Date" = field("Date Filter"),
                                                                           "Outstanding Quantity" = filter(<> 0),
                                                                           "Shipment Date Confirmed" = const(true)));
            Caption = 'Qty. on Sales Order Confirmed';
            DecimalPlaces = 0 : 5;
            Description = '05-07-19 ZY-LD 015';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Buy-from Vendor No. Filter"; Code[20])
        {
            Caption = 'Buy-from Vendor No. Filter';
            Description = '05-07-19 ZY-LD 015';
            FieldClass = FlowFilter;
            TableRelation = Vendor;
        }
        field(50014; "Qty. on Sales Order Total"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Shipment Date" = field("Date Filter"),
                                                                           "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Description = '05-07-19 ZY-LD 015';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "EAC Ready"; Boolean)
        {
            Caption = 'EAC Ready';
            Description = '09-08-19 ZY-LD 016';
        }
        field(50016; "Last Buy Date"; Date)
        {
            Caption = 'Last Buy Date';
            Description = '17-02-20 ZY-LD 022';
            Editable = false;
        }
        field(50017; "Lifecycle Phase"; Option)
        {
            Caption = 'Lifecycle Phase';
            Description = '17-02-20 ZY-LD 022';
            Editable = false;
            OptionCaption = ' ,Released,Pre-Disable';
            OptionMembers = " ",Released,"Pre-Disable";
        }
        field(50018; Model; Text[200])
        {
            Caption = 'Model';
            Description = 'Unused';
        }
        field(50019; "Qty. per Color Box"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. per Color Box';
            DecimalPlaces = 0 : 2;
            Description = '11-08-20 ZY-LD 027';
        }
        field(50020; "Total Qty. per Carton"; Decimal)
        {
            BlankZero = true;
            Caption = 'Total Qty. per Carton';
            DecimalPlaces = 0 : 2;
            Description = '11-08-20 ZY-LD 027';
            Editable = false;
        }
        field(50021; "Warehouse Inventory"; Decimal)
        {
            CalcFormula = sum("Warehouse Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                           Date = field("Date Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Quanty Type" = field("Quanty Type Filter")));
            Caption = 'Warehouse Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; "Quanty Type Filter"; Option)
        {
            Caption = 'Quanty Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'On Hand,Blocked,Inspecting,Allocated';
            OptionMembers = "On Hand",Blocked,Inspecting,Allocated;
        }
        field(50023; "Battery Certificate"; Boolean)
        {
            CalcFormula = exist("Battery Certificate" where("Item No." = field("No.")));
            Caption = 'Battery Certificate';
            Description = '14-01-19 ZY-LD 021';
            FieldClass = FlowField;
        }
        field(50024; "Actual FOB Price"; Decimal)
        {
            CalcFormula = max("Price List Line"."Direct Unit Cost" where("Asset Type" = const("Price Asset Type"::Item),
                                                                         "Asset No." = field("No."),
                                                                         "Source No." = field("Vendor No. Filter"),
                                                                         "Starting Date" = field("Date Filter Act. FOB Pr. Start"),
                                                                         "Ending Date" = field("Date Filter Act. FOB Pr. End")));
            Caption = 'Actual FOB Price';
            Description = '19-02-20 ZY-LD 023';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Price List Line";
        }
        field(50025; "Vendor No. Filter"; Code[20])
        {
            Caption = 'Vendor No. Filter';
            Description = '19-02-20 ZY-LD 023';
            FieldClass = FlowFilter;
            TableRelation = Vendor;
        }
        field(50026; "Date Filter Act. FOB Pr. Start"; Date)
        {
            Caption = 'Date Filter Actual FOB Price Start Date';
            Description = '19-02-20 ZY-LD 023';
            FieldClass = FlowFilter;
        }
        field(50027; "Date Filter Act. FOB Pr. End"; Date)
        {
            Caption = 'Date Filter Actual FOB Price End Date';
            Description = '19-02-20 ZY-LD 023';
            FieldClass = FlowFilter;
        }
        field(50028; "Qty. on Sales Order Conf."; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Picking Date Confirmed"."Outstanding Quantity (Base)" where("Item No." = field("No."),
                                                                                           "Location Code" = field("Location Filter"),
                                                                                           "Picking Date" = field("Date Filter"),
                                                                                           "Picking Date Confirmed" = const(true)));
            Caption = 'Qty. on Sales Order Confirmed (New)';
            DecimalPlaces = 0 : 5;
            Description = '21-09-20 ZY-LD 027';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50029; "Qty. on Sales Order Unconf."; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Picking Date Confirmed"."Outstanding Quantity (Base)" where("Item No." = field("No."),
                                                                                           "Location Code" = field("Location Filter"),
                                                                                           "Picking Date" = field("Date Filter"),
                                                                                           "Picking Date Confirmed" = const(false)));
            Caption = 'Qty. on Sales Order Unconfirmed';
            DecimalPlaces = 0 : 5;
            Description = '21-09-20 ZY-LD 027';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50030; "Forecast Territory"; Code[10])
        {
            Caption = 'Forecast Territory';
            Description = '06-10-20 ZY-LD 028';
            TableRelation = "Forecast Territory";
        }
        field(50031; "Business to"; Option)
        {
            Caption = 'Business to';
            Description = '07-10-20 ZY-LD 029';
            OptionCaption = ' ,Business,Consumer';
            OptionMembers = " ",Business,Consumer;
        }
        field(50032; "Aged Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3), Blocked = const(false));
        }
        field(50033; "Tr. Or. Ship (Qty.) Confirmed"; Decimal)
        {
            CalcFormula = sum("Transfer Line"."Outstanding Qty. (Base)" where("Derived From Line No." = const(0),
                                                                              "Item No." = field("No."),
                                                                              "Transfer-from Code" = field("Location Filter"),
                                                                              "Variant Code" = field("Variant Filter"),
                                                                              "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Shipment Date" = field("Date Filter"),
                                                                              "Shipment Date Confirmed" = const(true)));
            Caption = 'Trans. Ord. Shipment (Qty.) Confirmed';
            DecimalPlaces = 0 : 5;
            Description = '29-12-20 ZY-LD 030';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50034; "SCIP No."; Text[50])
        {
            Caption = 'SCIP No. (Substances of Concern In Products)';
            Description = '05-01-20 ZY-LD 031';
            Editable = false;
        }
        field(50035; "Customer Filter"; Code[20])
        {
            Caption = 'Customer Filter';
            Description = '24-02-21 ZY-LD 032';
            FieldClass = FlowFilter;
        }
        field(50036; "Qty. on Delivery Document"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Shipment Date" = field("Date Filter"),
                                                                           "Outstanding Quantity" = filter(<> 0),
                                                                           "Shipment Date Confirmed" = const(true),
                                                                           "Delivery Document No." = filter(<> '')));
            Caption = 'Qty. on Delivery Document';
            DecimalPlaces = 0 : 5;
            Description = '22-04-21 ZY-LD 033';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50037; "Qty. on Sales Order Conf.Total"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Shipment Date" = field("Date Filter"),
                                                                           "Outstanding Quantity" = filter(<> 0),
                                                                           "Shipment Date Confirmed" = const(true)));
            Caption = 'Qty. on Sales Order Confirmed';
            DecimalPlaces = 0 : 5;
            Description = '05-07-19 ZY-LD 015';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50038; "Marked Picking Date"; Decimal)
        {
            CalcFormula = sum("Picking Date Confirmed"."Outstanding Quantity" where("Item No." = field("No."),
                                                                                    "Marked Entry" = const(true),
                                                                                    "Outstanding Quantity" = filter(<> 0),
                                                                                    "Location Code" = field("Location Filter")));
            Caption = 'New/Marked Picking Date';
            DecimalPlaces = 0 : 0;
            Description = '24-08-21 ZY-LD 035';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50039; "Unconfirmed Picking Date"; Decimal)
        {
            CalcFormula = sum("Picking Date Confirmed"."Outstanding Quantity" where("Item No." = field("No."),
                                                                                    "Picking Date Confirmed" = const(false),
                                                                                    "Outstanding Quantity" = filter(<> 0),
                                                                                    "Picking Date" = field("Picking Date Filter"),
                                                                                    "Location Code" = field("Location Filter")));
            Caption = 'Unconfirmed Picking Date';
            DecimalPlaces = 0 : 0;
            Description = '24-08-21 ZY-LD 035';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50040; "Confirmed Picking Date"; Decimal)
        {
            CalcFormula = sum("Picking Date Confirmed"."Outstanding Quantity" where("Item No." = field("No."),
                                                                                    "Picking Date Confirmed" = const(true),
                                                                                    "Outstanding Quantity" = filter(<> 0),
                                                                                    "Picking Date" = field("Picking Date Filter"),
                                                                                    "Location Code" = field("Location Filter")));
            Caption = 'Confirmed Picking Date';
            DecimalPlaces = 0 : 0;
            Description = '24-08-21 ZY-LD 035';
            FieldClass = FlowField;
        }
        field(50041; "Picking Date Filter"; Date)
        {
            Caption = 'Picking Date Filter';
            Description = '24-08-21 ZY-LD 035';
            FieldClass = FlowFilter;
        }
        field(50043; "Rework BOM"; Boolean)
        {
            CalcFormula = exist("Rework Component" where("Parent Item No." = field("No.")));
            Caption = 'Rework BOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "Tax Reduction Rate Active"; Boolean)
        {
            Caption = 'Tax Reduction Rate Active';
            Description = '02-03-22 ZY-LD 039';
            InitValue = true;
        }
        field(50045; "Tax Reduction Rate Date Filter"; Date)
        {
            Caption = 'Tax Reduction Rate Date Filter';
            Description = '02-03-22 ZY-LD 039';
            FieldClass = FlowFilter;
        }
        field(50046; "Prevent Empty Volume"; Option)
        {
            Caption = 'Prevent Empty Volume';
            Description = '15-03-22 ZY-LD 040';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(50047; "Item Charge No. Filter"; Code[20])
        {
            Caption = 'Item Charge No.';
            Description = '12-04-22 ZY-LD 041';
            FieldClass = FlowFilter;
            TableRelation = "Item Charge";
        }
        field(50048; "Freight Cost Item"; Boolean)
        {
            Caption = 'Freight Cost Item';
            Description = '18-05-22 ZY-LD 042';

            trigger OnValidate()
            begin
                "Allow Unit Cost is Zero" := "Freight Cost Item";
            end;
        }
        field(50049; "Enter Security for Eicard on"; Option)
        {
            Caption = 'Enter Security for Eicard on';
            Description = '23-02-22 ZY-LD 045';
            OptionMembers = " ","EMS License","GLC License";
        }
        field(50050; "Update PLMS from Item No."; Code[20])
        {
            Caption = 'Update PLMS from Item No.';
            Description = '24-03-23 ZY-LD 046';
            TableRelation = Item;
        }
        field(50051; "Product use Battery"; Option)
        {
            Caption = 'Product or Accessory use Battery';
            Description = '17-05-23 ZY-LD 047';
            InitValue = " ";
            OptionCaption = 'No,Yes, ';
            OptionMembers = No,Yes," ";
        }
        field(50052; "WEEE Category"; Code[50])
        {
            Caption = 'WEEE Category';
            Description = '17-05-23 ZY-LD 047';
            TableRelation = SBU.Code where(Type = const("HQ Dimension"::"WEEE Category'"));
        }
        field(50053; "Successor Item No."; Code[20])
        {
            CalcFormula = lookup("Item Substitution"."Substitute No." where("No." = field("No."), "Variant Code" = filter('')));
            Caption = 'Successor Item No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50054; "RMA Alternative Item No."; Code[20])
        {
            CalcFormula = lookup("Item Substitution"."Substitute No." where("No." = field("No."), "Variant Code" = filter('RMA')));
            Caption = 'RMA Alternative Item No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50055; "Block on Sales Order Reason"; Text[30])  // 18-03-24 ZY-LD 000
        {
            Caption = 'Block on Sales Order Reason';
        }
        field(50056; "Length (cm)"; Decimal)
        {
            Caption = 'Length (cm)';
            Description = 'PAB 1.0';
        }
        field(50057; "Width (cm)"; Decimal)
        {
            Caption = 'Width (cm)';
            Description = 'PAB 1.0';
        }
        field(50058; "Height (cm)"; Decimal)
        {
            Caption = 'Height (cm)';
            Description = 'PAB 1.0';
        }
        field(50059; "Volume (cm3)"; Decimal)
        {
            Caption = 'Volume (cm3)';
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(50060; "Product Length (cm)"; Decimal)
        {
            Caption = 'Product Length (cm) (WEEE)';
            Description = '17-08-18 ZY-LD 006';
        }
        field(50061; "SVHC > 1000 ppm"; Option)
        {
            Caption = 'SVHC > 1000 ppm';
            Description = '02-11-22 ZY-LD 044';
            OptionCaption = ' ,Waiting for ODM Data,No (No need to report to SCIP),Yes';
            OptionMembers = " ","Waiting for ODM Data","No (No need to report to SCIP)",Yes;
        }
        field(50062; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(50063; "Allow Unit Cost is Zero"; Boolean)
        {
            Caption = 'Allow Unit Cost is Zero';
        }
        field(50064; "No of SCIP No."; Integer)
        {
            Caption = 'SCIP No. (Substances of Concern In Products)';
            FieldClass = FlowField;
            CalcFormula = count("SCIP Number" where("Item No." = field("No.")));
            Editable = false;
        }
        field(50065; "Min. Carton Qty. Enabled"; Boolean)
        {
            Caption = 'Min. Carton Qty. Enabled';
        }
        field(50076; "Qty. on Reciept Lines"; Decimal)
        {
            CalcFormula = sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" where("Item No." = field("No."),
                                                                                       "Variant Code" = field("Variant Filter"),
                                                                                       "Location Code" = field("Location Filter"),
                                                                                       "Due Date" = field("Date Filter"),
                                                                                       "No." = filter(< '14-' | > '19-9999999')));
            Caption = 'Qty. on Reciept Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PAB 1.0';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(50077; "Qty. on Purch. Order ZX"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                               "Buy-from Vendor No." = FIELD("Buy-from Vendor No. Filter"),
                                                                               Type = CONST(Item),
                                                                               "No." = FIELD("No."),
                                                                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                               "Location Code" = FIELD("Location Filter"),
                                                                               "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                               "Variant Code" = FIELD("Variant Filter"),
                                                                               "Expected Receipt Date" = FIELD("Date Filter"),
                                                                               "Unit of Measure Code" = FIELD("Unit of Measure Filter")));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(50080; "Cost Amount (Actual)"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item No." = field("No."),
                                                                         "Posting Date" = field("Date Filter"),
                                                                         "Location Code" = field("Location Filter"),
                                                                         "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                         "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                         "Item Charge No." = field("Item Charge No. Filter")));
            Caption = 'Cost Amount (Actual)';
            Description = 'DT5.0';
            FieldClass = FlowField;
        }
        field(50081; "Cost Amount (Actual LCY)"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Amount (Actual) (ACY)" where("Item No." = field("No."),
                                                                               "Posting Date" = field("Date Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Item Charge No." = field("Item Charge No. Filter")));
            Caption = 'Cost Amount (Actual LCY)';
            Description = 'DT5.0';
            FieldClass = FlowField;
        }
        field(50082; "Cost Posted to G/L"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Posted to G/L" where("Item No." = field("No."),
                                                                       "Posting Date" = field("Date Filter"),
                                                                       "Location Code" = field("Location Filter"),
                                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                       "Item Charge No." = field("Item Charge No. Filter")));
            Caption = 'Cost Posted to G/L';
            Description = 'DT5.0';
            FieldClass = FlowField;
        }
        field(50083; "Cost Posted to G/L (LCY)"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Posted to G/L (ACY)" where("Item No." = field("No."),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Item Charge No." = field("Item Charge No. Filter")));
            Caption = 'Cost Posted to G/L (LCY)';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(50084; Status; Option)
        {
            Caption = 'Status';
            Description = 'PAB 1.0';
            OptionCaption = 'Live,End of Life,New,Phase Out,Spares,Marketing,Other,Blocked,Rework';
            OptionMembers = Live,"End of Life",New,"Phase Out",Spares,Marketing,Other,Blocked,Rework;
        }
        field(50085; "Warranty Period"; Option)
        {
            Caption = 'Warranty Period';
            Description = 'PAB 1.0';
            InitValue = "N/A";
            OptionCaption = '2 Years,3 Years,5 Years,Limited Lifetime,N/A,SP RMA,27 Months';
            OptionMembers = "2 Years","3 Years","5 Years","Limited Lifetime","N/A","SP RMA","27 Months";
        }
        field(50086; "End of Life Date"; Date)
        {
            Caption = 'End of Life Date';
            Description = 'PAB 1.0';
        }
        field(50088; "Category 4 Code"; Code[20])
        {
            Caption = 'Category 4 Code';
            Description = 'PAB 1.0';
            TableRelation = SBU.Code where(Type = const("Category 4"));
        }
        field(50090; "Model ID"; Code[20])
        {
            Caption = 'Model ID';
            Description = 'PAB 1.0';
        }
        field(50091; "Model Description"; Text[50])
        {
            Caption = 'Model Description';
            Description = 'PAB 1.0';
        }
        field(50092; "Pallet Length (cm)"; Decimal)
        {
            Caption = 'Pallet Length (cm)';
            Description = 'PAB 1.0';
        }
        field(50093; "Pallet Width (cm)"; Decimal)
        {
            Caption = 'Pallet Width (cm)';
            Description = 'PAB 1.0';
        }
        field(50094; "Pallet Height (cm)"; Decimal)
        {
            Caption = 'Pallet Height (cm)';
            Description = 'PAB 1.0';
        }
        field(50095; "End of Technical Support Date"; Date)
        {
            Caption = 'End of Technical Support Date';
            Description = 'PAB 1.0';
        }
        field(50096; "End of RMA Date"; Date)
        {
            Caption = 'End of RMA Date';
            Description = 'PAB 1.0';
        }
        field(50098; "Cost Amount (Expected)"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Amount (Expected)" where("Item No." = field("No."),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter")));
            Caption = 'Cost Amount (Expected)';
            Description = '28-08-18 ZY-LD 007';
            FieldClass = FlowField;
        }
        field(50099; "Expected Cost Posted to G/L"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Expected Cost Posted to G/L" where("Item No." = field("No."),
                                                                                "Posting Date" = field("Date Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter")));
            Caption = 'Expected Cost Posted to G/L';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(50100; "Serial Code"; Code[50])
        {
            Caption = 'Serial Code';
            Description = 'Unused';
        }
        field(50101; "Manually OLAP"; Boolean)
        {
            Caption = 'Manually OLAP PO Fcst.';
            Description = 'RD 2.0';
        }
        field(50105; "Business Unit"; Code[10])
        {
            Caption = 'Business Unit';
            Description = 'ZY2.1';
            TableRelation = "Business Unit";
        }
        field(50110; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            Description = 'Unused';
            TableRelation = "Country/Region";
        }
        field(50116; "Item Country Code"; Code[20])
        {
            Caption = 'Item Country Code';
            Description = 'Unused';
            TableRelation = "Country/Region".Code where("Item Country Code" = const(true));
        }
        field(50117; "Exclude from Forecast"; Boolean)
        {
            Caption = 'Exclude from Forecast';
            Description = 'Unused';
        }
        field(50118; "RMA Category"; Option)
        {
            Caption = 'RMA Category';
            Description = 'PAB 1.0';
            InitValue = Normal;
            OptionCaption = 'Basic,Professional,Unused Category,Normal,Standard,Standard+';
            OptionMembers = Basic,Professional,"Unused Category",Normal,Standard,"Standard+";
        }
        field(50119; "RMA count"; Integer)
        {
            Caption = 'RMA count';
            Description = 'PAB 1.0';
            Editable = true;
        }
        field(50200; "Defect service"; Option)
        {
            Caption = 'Defect service';
            Description = 'PAB 1.0';
            OptionCaption = 'S2C,SWN,SWNoR';
            OptionMembers = S2C,SWN,SWNoR;
        }
        field(50201; "Module Repair"; Boolean)
        {
            Caption = 'Module Repair';
            Description = 'PAB 1.0';
        }
        field(50202; "PCB error repair"; Boolean)
        {
            Caption = 'PCB error repair';
            Description = 'PAB 1.0';
        }
        field(50203; "Refurbish Cost"; Decimal)
        {
            Caption = 'Refurbish Cost';
            Description = 'PAB 1.0';
        }
        field(50204; "Repair Cost"; Decimal)
        {
            Caption = 'Repair Cost';
            Description = 'PAB 1.0';
        }
        field(50205; "RMA Vendor Cost"; Decimal)
        {
            Caption = 'RMA Vendor Cost';
            Description = 'PAB 1.0';
        }
        field(55001; "Number per parcel"; Integer)
        {
            Caption = 'Number per parcel';
            Description = 'PAB 1.0';
        }
        field(55002; Overpack; Decimal)
        {
            Caption = 'Overpack';
            DecimalPlaces = 3 : 3;
            Description = 'PAB 1.0';
        }
        field(55003; "Paper Weight"; Decimal)
        {
            Caption = 'Paper Weight (kg)';
            DecimalPlaces = 3 : 3;
            Description = 'PAB 1.0';
        }
        field(55004; "Plastic Weight"; Decimal)
        {
            Caption = 'Plastic Weight (kg)';
            DecimalPlaces = 3 : 3;
            Description = 'PAB 1.0';
        }
        field(55005; "Additional Content Weight"; Decimal)
        {
            Caption = 'Additional Content Weight (kg)';
            DecimalPlaces = 3 : 3;
            Description = 'PAB 1.0';
        }
        field(55006; "Web Description"; Text[30])
        {
            Caption = 'Web Description';
            Description = 'PAB 1.0';
        }
        field(55007; "Show In Web"; Boolean)
        {
            Caption = 'Show In Web';
            Description = 'PAB 1.0';
        }
        field(55008; UpdateAllIn; Boolean)
        {
            Caption = 'UpdateAllIn';
            Description = 'PAB 1.0';
            InitValue = true;
        }
        field(55009; "UN Code"; Code[10])
        {
            Caption = 'UN Code';
            Description = 'PAB 1.0';
            TableRelation = "Battery UN Codes".Code;
        }
        field(55010; MDM; Code[30])
        {
            Caption = 'MDM';
            Description = 'PAB 1.0';
            TableRelation = "User Setup" where(MDM = const(true));
        }
        field(55011; SCM; Code[30])
        {
            Caption = 'SCM';
            Description = 'PAB 1.0';
            TableRelation = "User Setup" where(SCM = const(true));
        }
        field(55012; "Forecast Category 2"; Code[20])
        {
            Caption = 'Forecast Category 2';
            Description = 'Unused';
        }
        field(55013; "Battery weight"; Decimal)
        {
            Caption = 'Battery Weight (kg)';
            DecimalPlaces = 20 : 20;
            Description = 'RD 1.0';
        }
        field(55014; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
            Description = 'Unused';
        }
        field(55015; "Created By"; Code[20])
        {
            Caption = 'Created By';
            Description = 'PAB 1.0';
        }
        field(55016; "Modified By"; Code[20])
        {
            Caption = 'Modified By';
            Description = 'Unused';
        }
        field(55017; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Description = 'PAB 1.0';
        }
        field(55018; "Carton Weight"; Text[30])
        {
            Caption = 'Carton Weight (kg)';
            Description = 'PAB 1.0';
        }
        field(55019; "Add Additional Item"; Boolean)
        {
            Caption = 'Add Additional Item';
            Description = 'PAB 1.0';
        }
        field(55021; "Part Number Type"; Code[20])
        {
            Caption = 'Part Number Type';
            Description = 'PAB 1.0';
            InitValue = 'HQ_PN';
            TableRelation = "VCK Part Number Types";
        }
        field(55022; "Block on Sales Order"; Boolean)
        {
            Caption = 'Block on Sales Order';
            Description = 'PAB 1.0';
        }
        field(55023; "PP-Product CAT"; Option)
        {
            Caption = 'Partner Program Product Category';
            Description = 'PAB 1.0';
            OptionCaption = 'None,Consumer,Run Rate,SMB,Cloud,Licenses';
            OptionMembers = "None",Consumer,"Run Rate",SMB,Cloud,Licenses;
        }
        field(55100; "Qty. on Shipping Detail"; Decimal)
        {
            CalcFormula = sum("VCK Shipping Detail".Quantity where("Item No." = field("No."),
                                                                    Archive = const(false),
                                                                    "Buy-from Vendor No." = field("Buy-from Vendor No. Filter"),
                                                                    "Order Type" = const("Purchase Order"),
                                                                    Location = field("Location Filter")));
            Caption = 'Qty. on Shipping Detail';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(55101; "Qty. on Ship. Detail Received"; Decimal)
        {
            CalcFormula = sum("VCK Shipping Detail Received"."Quantity Received" where("Item No." = field("No."),
                                                                                       Archive = const(false),
                                                                                       "Buy-from Vendor No." = field("Buy-from Vendor No. Filter"),
                                                                                       "Order Type" = const("Purchase Order"),
                                                                                       "Location Code" = field("Location Filter")));
            Caption = 'Quantity on Shipping Detail Received';
            Description = '15-11-18 ZY-LD 008';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55110; Inactive; Boolean)
        {
            Caption = 'Inactive';
            Description = 'PAB 1.0';
        }
        field(55111; "Non ZyXEL License"; Boolean)
        {
            Caption = 'Non ZyXEL License';
            Description = 'PAB 1.0';
        }
        field(55112; "Non ZyXEL License Vendor"; Code[20])
        {
            Caption = 'Non ZyXEL License Vendor';
            Description = 'PAB 1.0';
            TableRelation = Vendor."No.";
        }
        field(55113; Amaz_ASIN; Code[20])
        {
            Caption = 'Amazon ASIN';
            Description = 'Amazon';

        }
        field(62015; IsEICard; Boolean)
        {
            Caption = 'Is EICard';
            Description = 'PAB 1.0';
        }
        field(62017; "Qty. Per Carton"; Text[30])
        {
            Caption = 'Qty. Per Carton';
            Description = 'Unused';
        }
        field(62018; "Dim Per Unit LxWxH"; Text[100])
        {
            Caption = 'Dim Per Unit LxWxH';
            Description = 'for showing Dim Per Unit LxWxH from ZBO';
        }
        field(62019; "Weight Per Unit"; Text[100])
        {
            Caption = 'Weight Per Unit (kg)';
            Description = 'for showing Weight Per Unit from ZBO';
        }
        field(62020; "Dim Per Carton LxWxH"; Text[100])
        {
            Caption = 'Dim Per Carton LxWxH';
            Description = 'for showing Dim per Carton LxWxH from ZBO';
        }
        field(62021; "Weight p_Carton"; Text[100])
        {
            Caption = 'Weight p_Carton';
            Description = 'for showing weight per carton from ZBO';
        }
        field(62022; "Item Profile Code"; Code[20])  // Used by HQ in a SQL View.
        {
            Caption = 'Item Profile Code';
        }
        field(62024; "Forecast Expired Date"; Date)
        {
            Caption = 'Forecast Expired Date';
            Description = 'Unused';
        }
        field(62025; "Cartons Per Pallet"; Integer)
        {
            Caption = 'Cartons Per Pallet';
            Description = 'for logio';
        }
        field(62026; "Forecast Visibility excl. UK"; Boolean)
        {
            Caption = 'Forecast Visibility excl. UK';
            Description = 'Unused';
        }
        field(62027; "Is For ZyUK"; Boolean)
        {
            Caption = 'Is For ZyUK';
            Description = 'Unused';
        }
        field(62029; "Serial Number Required"; Boolean)
        {
            Caption = 'Serial Number Required';
            InitValue = true;
        }
        field(62030; "Length (ctn)"; Decimal)
        {
            Caption = 'Length (ctn)';
        }
        field(62031; "Width (ctn)"; Decimal)
        {
            Caption = 'Width (ctn)';
        }
        field(62032; "Height (ctn)"; Decimal)
        {
            Caption = 'Height (ctn)';
        }
        field(62033; "Volume (ctn)"; Decimal)
        {
            Caption = 'Volume (ctn)';
        }
        field(62034; "Number per carton"; Integer)
        {
            BlankZero = true;
            Caption = 'Box per Carton';
        }
        field(62035; "Last Order Date"; Date)
        {
            Caption = 'Last Order Date';
        }
        field(62036; "DSV Inv DM1"; Decimal)
        {
            Caption = 'DSV Inv DM1';
            Description = 'Unused';
            InitValue = 0;
        }
        field(62037; "DSV Inv DM2"; Decimal)
        {
            Caption = 'DSV Inv DM2';
            Description = 'Unused';
            InitValue = 0;
        }
        field(62038; "DSV Inv HO1"; Decimal)
        {
            Caption = 'DSV Inv HO1';
            Description = 'Unused';
            InitValue = 0;
        }
        field(62039; "DSV Inv OK1"; Decimal)
        {
            Caption = 'DSV Inv OK1';
            Description = 'Unused';
            InitValue = 0;
        }
        field(62040; "DSV Inv RW1"; Decimal)
        {
            Caption = 'DSV Inv RW1';
            Description = 'Unused';
            InitValue = 0;
        }
        field(62041; "DSV Inv TE1"; Decimal)
        {
            Caption = 'DSV Inv TE1';
            Description = 'Unused';
            InitValue = 0;
        }
        field(62042; EU2Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                 "Location Code" = const('EU2')));
            Caption = 'EU2Inventory';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62043; UPSInventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                 "Location Code" = const('UPS')));
            Caption = 'UPSInventory';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62044; EU2SOQty; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Location Code" = const('EU2'),
                                                                           "Shipment Date Confirmed" = filter(true)));
            Caption = 'EU2SOQty';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62045; UPSSOQty; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Location Code" = const('UPS')));
            Caption = 'UPSSOQty';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62046; Include_in_SnOP; Boolean)
        {
            Caption = 'Include_in_SnOP';
            Description = 'Unused';
            InitValue = true;
        }
        field(62047; "HQ Unshipped Purchase Order"; Decimal)
        {
            CalcFormula = sum("Unshipped Purchase Order".Quantity where("Item No." = field("No."),
                                                                        "Buy-from Vendor No." = field("Buy-from Vendor No. Filter"),
                                                                        "Location Code" = field("Location Filter")));
            /*CalcFormula = sum("Purchase Line".Quantity where("Document Type" = const(Order),
                                                             Type = const(Item),
                                                             "No." = field("No."),
                                                             OriginalLineNo = filter(<> 0),
                                                             "Buy-from Vendor No." = field("Buy-from Vendor No. Filter"),
                                                             "Location Code" = field("Location Filter")));*/
            Caption = 'HQ Unshipped Purchase Order';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62048; EU2SOQtyall; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Location Code" = const('EU2'),
                                                                           "Outstanding Quantity" = filter(<> 0)));
            Caption = 'EU2SOQtyall';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62049; "Automatic Purchase Visible Fee"; Boolean)
        {
            Caption = 'Automatic Purchase Visible Fee';
            Description = 'PAB 1.0';
        }
        field(62050; EU2SOQtyConfirmed; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field("No."),
                                                                           "Location Code" = const('EU2'),
                                                                           "Outstanding Quantity" = filter(<> 0),
                                                                           "Shipment Date Confirmed" = const(true)));
            Caption = 'EU2SOQtyConfirmed';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62051; "Qty Per Pallet"; Integer)
        {
            Caption = 'Qty Per Pallet';
            Description = 'PAB 1.0';
        }
        field(62052; PFEInventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                 "Location Code" = const('PFE EXPRES')));
            Caption = 'PFEInventory';
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(62502; B2B; Boolean)
        {
            Caption = 'Business to Business';
            Description = 'Unused';
        }
        field(62503; B2C; Boolean)
        {
            Caption = 'Business to Consumer';
            Description = 'Unused';
        }
        field(62504; "Add Bromine Wgt. PCB"; Decimal)
        {
            Caption = 'Additive Bromine Weight PCB';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62505; "Add Chlorine Wgt. PCB"; Decimal)
        {
            Caption = 'Additive Chlorine Weight PCB';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62506; "Add Phos. Wgt. PCB"; Decimal)
        {
            Caption = 'Additive  Phosphorus Weight PCB';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62507; "Add Bromine Wgt. Plastic Part"; Decimal)
        {
            Caption = 'Additive Bromine Weight Plastic Part';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62508; "Add Chlorine Wgt. Plastic Part"; Decimal)
        {
            Caption = 'Additive Chlorine Weight Plastic Part';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62509; "Add Phos. Wgt. Plastic Part"; Decimal)
        {
            Caption = 'Additive Phosphorus Weight Plastic Part';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62510; "Reac Bromine Wgt. PCB"; Decimal)
        {
            Caption = 'Reactive Bromine Weight PCB';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62511; "Reac Chlorine Wgt. PCB"; Decimal)
        {
            Caption = 'Reactive Chlorine Weight PCB';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62512; "Reac Phos. Wgt. PCB"; Decimal)
        {
            Caption = 'Reactive Phosphorus Weight PCB';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62513; "Reac Bromine Wgt. Plastic Part"; Decimal)
        {
            Caption = 'Reactive Bromine Weight Plastic Part';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62514; "Reac Chlorine Wgt. Plas. Part"; Decimal)
        {
            Caption = 'Reactive Chlorine Weight Plastic Part';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62515; "Reac Phos. Wgt. Plastic Part"; Decimal)
        {
            Caption = 'Reactive Phosphorus Weight Plastic Part';
            DecimalPlaces = 6 : 6;
            Description = 'Unused';
        }
        field(62516; "Tax rate (SEK/kg)"; Decimal)
        {
            CalcFormula = max("Chemical Tax Rate"."Tax Rate (SEK/kg)" where("Start Date" = field("Tax Reduction Rate Date Filter")));
            Caption = 'Tax rate (SEK/kg)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62517; "Total Chemical Tax"; Decimal)
        {
            Caption = 'Total Chemical Tax';
            DecimalPlaces = 2 : 2;
            Description = 'Unused';
        }
        field(62518; "Tax Reduction rate"; Decimal)
        {
            Caption = 'Tax Reduction Rate';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(62519; "Ignore Missing Data"; Boolean)
        {
            Caption = 'Ignore Missing Data';
            Description = 'Unused';
        }
        field(62520; "Category 1 Code"; Code[100])
        {
            Caption = 'Category 1 Code';
            Description = 'PAB 1.0';
            TableRelation = SBU.Code where(Type = const("Category 1"));
        }
        field(62521; "Category 2 Code"; Code[100])
        {
            Caption = 'Category 2 Code';
            Description = 'PAB 1.0';
            TableRelation = SBU.Code where(Type = const("Category 2"));
        }
        field(62522; "Category 3 Code"; Code[100])
        {
            Caption = 'Category 3 Code';
            Description = 'PAB 1.0';
            TableRelation = SBU.Code where(Type = const("Category 3"));
        }
        field(62523; "Business Center"; Code[20])
        {
            Caption = 'Business Center';
            Description = 'PAB 1.0';
            TableRelation = SBU.Code where(Type = const("Business Center"));
        }
        field(62524; SBU; Code[20])
        {
            Caption = 'SBU';
            Description = 'PAB 1.0';
            TableRelation = SBU.Code where(Type = const(SBU));
        }
        field(62525; "No PLMS Update"; Boolean)
        {
            Caption = 'No PLMS Update from HQ';
            Description = 'PAB 1.0';
        }
        field(62526; "Deal Reg"; Boolean)
        {
            Caption = 'Deal Reg.';
            Description = 'Unused';
        }
        field(62527; NFR; Boolean)
        {
            Caption = 'Available for NFR';
            Description = 'Unused';
        }
        field(62528; "Trade In"; Boolean)
        {
            Caption = 'Trade In';
            Description = 'Unused';
        }
        field(62529; Segment; Code[20])
        {
            Caption = 'Segment';
            Description = 'Unused';
            TableRelation = Segment.Code;
        }
        field(62530; "SBU Company"; Option)
        {
            Caption = 'SBU Company';
            Description = '16-10-19 ZY-LD 018';
            Editable = false;
            FieldClass = Normal;
            OptionCaption = ' ,ZCom HQ,ZNet HQ';
            OptionMembers = " ","ZCom HQ","ZNet HQ";
        }
    }

    keys
    {
        key(Key50000; "Item Category Code", Description)
        {
        }
    }

    procedure "-->> fnDT"()
    begin
    end;

    procedure CalcVolume(Length: Decimal; Width: Decimal; Height: Decimal) Volume: Decimal
    begin
        Volume := Length * Width * Height;
        exit(Volume);
    end;

    procedure CalcAvailableStock(Confirmed: Boolean): Decimal
    begin
        //>> 05-07-19 ZY-LD 015
        if Confirmed then begin
            Rec.CalcFields(
              Rec.Inventory,
              Rec."Qty. on Sales Order Confirmed",
              Rec."Tr. Or. Ship (Qty.) Confirmed");  // 23-10-19 ZY-LD 019  // 29-12-20 ZY-LD 030
            exit(Rec.Inventory - Rec."Qty. on Sales Order Confirmed" - Rec."Tr. Or. Ship (Qty.) Confirmed");  // 23-10-19 ZY-LD 019  // 29-12-20 ZY-LD 030
        end else begin
            Rec.CalcFields(
              Rec.Inventory,
              Rec."Qty. on Sales Order",
              Rec."Trans. Ord. Shipment (Qty.)");  // 23-10-19 ZY-LD 019
            exit(Rec.Inventory - Rec."Qty. on Sales Order" - Rec."Trans. Ord. Shipment (Qty.)");  // 23-10-19 ZY-LD 019
        end;
        //<< 05-07-19 ZY-LD 015
    end;

    procedure SetLocationFilterOnMainWarehouse()
    var
        recInvSetup: Record "Inventory Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
    begin
        //>> 05-07-19 ZY-LD 015
        //IF ZGT.IsRhq THEN BEGIN  // 12-08-22 ZY-LD 043 - We wil also set the filter in subs.
        //>> 03-06-22 ZY-LD 043
        /*recInvSetup.GET;
        recInvSetup.TESTFIELD("AIT Location Code");
        SETRANGE("Location Filter",recInvSetup."AIT Location Code");*/
        if Rec.GetFilter(Rec."Location Filter") = '' then
            Rec.SetRange(Rec."Location Filter", ItemLogisticEvent.GetMainWarehouseLocation);
        //<< 03-06-22 ZY-LD 043
        //END;
        //<< 05-07-19 ZY-LD 015

    end;

    procedure TransferPlmsFields()
    var
        recItem: Record Item;
    begin
        if Rec."No PLMS Update" then
            if recItem.Get(Rec."Update PLMS from Item No.") then begin
                Rec.Validate(Rec."Height (cm)", recItem."Height (cm)");
                Rec.Validate(Rec."Width (cm)", recItem."Width (cm)");
                Rec.Validate(Rec."Length (cm)", recItem."Length (cm)");
                Rec.Validate(Rec."Volume (cm3)", recItem."Volume (cm3)");
                Rec.Validate(Rec."Plastic Weight", recItem."Plastic Weight");
                Rec.Validate(Rec."Paper Weight", recItem."Paper Weight");
                Rec.Validate(Rec."Cartons Per Pallet", recItem."Cartons Per Pallet");
                Rec.Validate(Rec."Height (ctn)", recItem."Height (ctn)");
                Rec.Validate(Rec."Width (ctn)", recItem."Width (ctn)");
                Rec.Validate(Rec."Length (ctn)", recItem."Length (ctn)");
                Rec.Validate(Rec."Volume (ctn)", recItem."Volume (ctn)");
                Rec.Validate(Rec."Number per carton", recItem."Number per carton");
                Rec.Validate(Rec."Gross Weight", recItem."Gross Weight");
                Rec.Validate(Rec."Net Weight", recItem."Net Weight");
                Rec.Validate(Rec."Pallet Length (cm)", recItem."Pallet Length (cm)");
                Rec.Validate(Rec."Pallet Width (cm)", recItem."Pallet Width (cm)");
                Rec.Validate(Rec."Pallet Height (cm)", recItem."Pallet Height (cm)");
                Rec.Validate(Rec."UN Code", recItem."UN Code");
                Rec.Validate(Rec."Battery weight", recItem."Battery weight");
                Rec.Validate(Rec."Carton Weight", recItem."Carton Weight");
                Rec.Validate(Rec."Qty Per Pallet", recItem."Qty Per Pallet");
                Rec.Validate(Rec."End of Technical Support Date", recItem."End of Technical Support Date");
                Rec.Validate(Rec."End of RMA Date", recItem."End of RMA Date");
                Rec.Validate(Rec."Tax Reduction rate", recItem."Tax Reduction rate");
                Rec.Validate(Rec."Tax Reduction Rate Active", recItem."Tax Reduction Rate Active");
                Rec.Validate(Rec."Category 1 Code", recItem."Category 1 Code");
                Rec.Validate(Rec."Category 2 Code", recItem."Category 2 Code");
                Rec.Validate(Rec."Category 3 Code", recItem."Category 3 Code");
                Rec.Validate(Rec."Business Center", recItem."Business Center");
                Rec.Validate(Rec.SBU, recItem.SBU);
                Rec.Validate(Rec."HQ Model Phase", recItem."HQ Model Phase");
                Rec.Validate(Rec."Product Length (cm)", recItem."Product Length (cm)");
                Rec.Validate(Rec."Lifecycle Phase", recItem."Lifecycle Phase");
                Rec.Validate(Rec."Last Buy Date", recItem."Last Buy Date");
                Rec.Validate(Rec."Qty. per Color Box", recItem."Qty. per Color Box");
                Rec.Validate(Rec."SCIP No.", recItem."SCIP No.");
                Rec.Validate(Rec."SVHC > 1000 ppm", recItem."SVHC > 1000 ppm");
                Rec.Modify(true);
            end;
    end;

    procedure GetScipNo() rValue: Text
    var
        ScipNumber: Record "SCIP Number";
    Begin
        //>> 18-04-24 ZY-LD 049
        ScipNumber.SetRange("Item No.", "No.");
        if ScipNumber.FindSet() then
            repeat
                if rValue <> '' then
                    rValue += StrSubstNo(',%1', ScipNumber."SCIP No.")
                else
                    rValue := ScipNumber."SCIP No.";
            until ScipNumber.Next() = 0;
        //<< 18-04-24 ZY-LD 049            
    End;

    procedure getTotalQTYperCarton(itemno: code[20]): Decimal
    var
        item: record item;
    begin
        if itemno = '' then
            exit(0);

        if item.get(itemno) then begin
            exit(item."Total Qty. per Carton");
        end;

        exit(0);

    end;

    var
        HqDimension: Enum "HQ Dimension";
}
