pageextension 50120 ItemListZX extends "Item List"
{
    layout
    {
        modify("No.")
        {
            Style = Strong;
            StyleExpr = true;
        }
        addafter(Description)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
        moveafter(Status; "Last Date Modified")
        modify("Last Date Modified")
        {
            Visible = false;
        }
        addafter("Last Date Modified")
        {
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Creation Date';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Creation By';
            }
            field("Manually OLAP"; Rec."Manually OLAP")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Manually OLAP';
            }
            field(IsEICard; Rec.IsEICard)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of IsEICard';
            }
            field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 0;
                Visible = false;
                ToolTip = 'Specifies the value of Trans. Ord. Shipment (Qty.)';
            }
            field("Transferred (Qty.)"; Rec."Transferred (Qty.)")
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 0;
                Visible = false;
                ToolTip = 'Specifies the value of Transferred (Qty.)';
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Global Dimension 1 Code';
            }
        }
        addafter("Tariff No.")
        {
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Country/Region of Origin Code';
            }
            field(MDM; Rec.MDM)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of MDM';
            }
            field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Safety Stock Quantity';
            }
            field(SCM; Rec.SCM)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of SCM';
            }
            field("Number per carton"; Rec."Number per carton")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Number per Carton';
            }
            field("Carton Weight"; Rec."Carton Weight")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Carton Weight';
            }
            field("Number per parcel"; Rec."Number per parcel")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Number per Parcel';
            }
            field("Tax Reduction rate"; Rec."Tax Reduction rate")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Tax Reduction Rate';
            }
            field("Category 1 Code"; Rec."Category 1 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Category 1 Code';
            }
            field("Category 2 Code"; Rec."Category 2 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Category 2 Code';
            }
            field("Category 3 Code"; Rec."Category 3 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Category 3 Code';
            }
            field("Business Center"; Rec."Business Center")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Business Center';
            }
        }
        addafter("Search Description")
        {
            field(SBU; Rec.SBU)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of SBU';
            }
            field("SBU Company"; Rec."SBU Company")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of SBU Company';
            }
            field("PP-Product CAT"; Rec."PP-Product CAT")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of PP-Product CAT';
            }
            field("UN Code"; Rec."UN Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of UN Code';
            }
        }
        addafter("Overhead Rate")
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Net Change';
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Total Qty. per Carton"; Rec."Total Qty. per Carton")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Total Qty. per Carton';
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Net Weight';
            }
        }
        addafter("Net Weight")
        {
            field("End of Life Date"; Rec."End of Life Date") //04-12-2025 BK #544101
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of End of Life Date';
            }
        }
        modify("Created From Nonstock Item")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Created From Nonstock Item';
        }
        modify("Substitutes Exist")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Substitutes Exist';
        }
        modify("Production BOM No.")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Production BOM No. ';
        }
        modify("Routing No.")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Routing No';
        }
        modify("Costing Method")
        {
            Visible = true;
            ToolTip = 'Specifies the value of Costing Method';
        }
        modify("Last Direct Cost")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Last Direct Cost';
        }
        modify("Price/Profit Calculation")
        {
            Visible = true;
            ToolTip = 'Specifies the value of Price/Profit Calculation';
        }
        modify("Profit %")
        {
            Visible = true;
            ToolTip = 'Specifies the value of Profit %';
        }
        modify("Inventory Posting Group")
        {
            Visible = true;
            ToolTip = 'Specifies the value of Inventory Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
            ToolTip = 'Specifies the value of VAT Prod. Posting Group';
        }
        modify("Item Disc. Group")
        {
            Visible = true;
            ToolTip = 'Specifies the value of Item Disc. Group';
        }
        modify("Vendor Item No.")
        {
            Visible = true;
            ToolTip = 'Specifies the value of Vendor Item No.';
        }
        modify("Indirect Cost %")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Indirect Cost %';
        }
        modify("Item Category Code")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Item Category Code';
        }
        modify(Blocked)
        {
            Visible = false;
            ToolTip = 'Specifies the value of Blocked';
        }
        modify("Sales Unit of Measure")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Sales Unit of Measure';
        }
        modify("Replenishment System")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Replenishment System';
        }
        modify("Purch. Unit of Measure")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Purch. Unit of Measure';
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Lead Time Calculation';
        }
        modify("Manufacturing Policy")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Manufacturing Policy';
        }
        modify("Flushing Method")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Flushing Method';
        }
        modify("Item Tracking Code")
        {
            Visible = false;
            ToolTip = 'Specifies the value of Item Tracking Code';
        }
        addlast(Control1)
        {

            field(Amaz_ASIN; Rec.Amaz_ASIN)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the value of Amaz_ASIN';
            }
        }
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
                Caption = 'Item Comment';
                Visible = false;
                SubPageLink = "Table Name" = const(Item),
                              "No." = field("No.");
            }
        }
    }

    actions
    {
        addlast(Category_Process)
        {
            actionref(AdditionalItems_Promoted; "Additional Items")
            {
            }
            actionref(CHangeLog_promoted; "Change Log")
            {
            }
            actionref(Forecast_Promoted; Forecast)
            {
            }
        }
        modify("Assembly/Production")
        {
            Caption = 'Assembly/Production/Rework';
        }
        addfirst(Availability)
        {
            action(Forecast)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Forecast';
                Caption = 'Forecast';
                Image = Forecast;

                trigger OnAction()
                begin
                    ShowForecast();
                end;
            }
        }
        addafter("Items b&y Location")
        {
            action("Item pr. Location")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Item Pr. Location';
                Caption = 'Item pr. Location';

                trigger OnAction()
                begin
                    Clear(AvailabilityprLocation);
                    AvailabilityprLocation.InitiatePage(Rec."No.");
                    AvailabilityprLocation.RunModal();
                end;
            }
        }
        addafter("Va&riants")
        {
            action("Business Units")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Business Units';
                Description = 'Maintain the list of business units codes';
                Image = BusinessRelation;
                RunObject = Page "Business Units";
                ToolTip = 'Maintain the list of business units codes';
            }
        }
        addafter(Identifiers)
        {
            action("Additional Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Additional Items';
                Image = Item;
                RunObject = Page "Additional Item List";
                RunPageLink = "Item No." = field("No.");
                ToolTip = 'Specifies the value of Additional Items';
            }
            action("Block Customer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Block Customer';
                Image = Stop;
                RunObject = Page "Item/Customer Relation";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'Specifies the value of Block Customers';
            }
            action("Item List (All fields)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item List (All fields)';
                Image = ItemGroup;
                RunObject = Page "Item List (All fields)";
                ToolTip = 'Specifies the value of Item List (All fields)';
            }
            action("Chemical Tax Reduction Rate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chemical Tax Reduction Rate';
                Image = TaxPayment;
                RunObject = Page "Chemical Tax Rates";
                ToolTip = 'Specifies the value of Chemical Tax Reduction Rate';
            }
        }
        addafter(Production)
        {
            group(Rework)
            {
                Caption = 'Rework';
                Image = BOM;
                ToolTip = 'Specifies the value of Rework';
                action("Rework BOM")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rework BOM';
                    Image = BOM;
                    RunObject = Page "Rework BOM";
                    RunPageLink = "Parent Item No." = field("No.");
                    ToolTip = 'Specifies the value of Rework BOM';
                }
            }
        }
        addafter("Ledger E&ntries")
        {
            action("Whse. Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Whse. Ledger Entries';
                Image = Warehouse;
                RunObject = Page "Whse. Item Ledger Entry";
                RunPageLink = "Item No." = field("No.");
                ShortCutKey = 'Shift+F7';
                ToolTip = 'Specifies the value of Whse. Ledger Entries';
            }
            action("Item Forecast Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Forecast Entries';
                ToolTip = 'Specifies the value of Item Forecast Entries';
                Image = Forecast;
                RunObject = Page "Item Budget Entries";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Analysis Area", "Budget Name", "Item No.", Date)
                              where("Budget Name" = const('MASTER'),
                                    Quantity = filter(<> 0));
            }
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                ToolTip = 'Specifies the value of Change Log';
                Image = ChangeLog;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("No.");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(27));
            }
        }
        addafter("&Warehouse Entries")
        {
            action("eCommerce Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Entries';
                ToolTip = 'Specifies the value of eCommerce Entries';
                Image = InwardEntry;
                RunObject = Page "eCommerce Order Entries";
                RunPageLink = "Item No." = field("No.");
            }
            action("Serial No. Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Serial No. Entries';
                ToolTip = 'Specifies the value of Serial No. Entries';
                Image = SerialNo;
                RunObject = Page "VCK Delivery Document SNos";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Item No.", "Posting Date", "Serial No.")
                              order(descending);
            }
            action(RMA)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'RMA';
                ToolTip = 'Specifies the value of RMA';
                Image = Entries;
                RunObject = Page "RMA Entries";
                RunPageLink = "Item No." = field("No.");
            }
        }
        addafter("Returns Orders")
        {
            action("Start Picking Date pr. Country")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Start Picking Date pr. Country';
                ToolTip = 'Specifies the value of Start Picking Date pr. Country';
                Image = CalculateShipment;
                RunObject = Page "Item Picking Date pr. Country";
                RunPageLink = "Item No." = field("No.");
            }
        }
        addafter(Resources)
        {
            group(Document)
            {
                Caption = 'Document';
                ToolTip = 'Specifies the value of Document';
                action("Battery Certificate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Battery Certificate';
                    ToolTip = 'Specifies the value of Battery Certificate';
                    Image = Certificate;
                    RunObject = Page "Battery Certificates";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = order(descending);
                }
            }
        }
        addafter("Adjust Cost - Item Entries")
        {
            group(Replicate)
            {
                Caption = 'Replicate';
                ToolTip = 'Specifies the value of Replicate';
                action("Replicate Item")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replicate Item';
                    ToolTip = 'Specifies the value of Replicate Item';
                    Image = Web;

                    trigger OnAction()
                    begin
                        ReplicateItem(false, false);
                    end;
                }
                action("Force Replication Item")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Force Replication Item';
                    ToolTip = 'Specifies the value of Force Replication Item';
                    Image = Web;

                    trigger OnAction()
                    begin
                        ReplicateItem(false, true);
                    end;
                }
                action("Replicate Items (DMY/Dummy)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replicate Items (DMY/Dummy)';
                    ToolTip = 'Specifies the value of Replicate Items (DMY/Dummy)';
                    Image = Web;

                    trigger OnAction()
                    begin
                        ReplicateItem(true, false);
                    end;
                }
            }
            group(ActionGroup120)
            {
                Caption = 'Warehouse';
                action("Resend Item to VCK")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resend Item to VCK';
                    ToolTip = 'Specifies the value of Resend Item to VCK';
                    Image = SendTo;

                    trigger OnAction()
                    begin
                        if Confirm(Text002, true, Rec."No.") then
                            if VckXmlMgt.SendItem(Rec."No.", false) then
                                Message(Text005, Rec."No.")
                            else
                                Message(Text006, Rec."No.");
                    end;
                }
                action("Send All Active Items to VCK")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send All Active Items to VCK';
                    ToolTip = 'Specifies the value of Send All Active Items to VCK';
                    Image = XMLFile;
                    Visible = SendAllItemsToVCKVisible;

                    trigger OnAction()
                    begin
                        //>> 22-02-22 ZY-LD 011
                        if Confirm(Text003) then
                            if Confirm(Text004) then
                                if VckXmlMgt.SendItem('', true) then
                                    Message(Text005, '"ALL"')
                                else
                                    Message(Text006, Rec."No.");
                    end;
                }
            }
            action("Count")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Count';
                ToolTip = 'Specifies the value of Count';

                trigger OnAction()
                begin
                    Message('%1 %2', StrLen(Rec."No."), Rec.Count());
                end;
            }
        }
        addfirst(Reporting)
        {
            action("Item - Chemical Tax Reduction Rate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item - Chemical Tax Reduction Rate';
                ToolTip = 'Specifies the value of Item - Chemical Tax Reduction Rate';
                Image = "Report";
                RunObject = Report "Item - Chemical Tax Red. Rate";
            }
            action(ScipNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'SCIP No.';
                Image = NumberGroup;
                RunObject = page "SCIP Numbers";
                RunPageLink = "Item No." = field("No.");
                ToolTip = 'Specifies SCIP Number that is related to chemical tax in Sweden. The SCIP number is a random sequence of 36 hexadecimal characters that follows the Universally Unique Identifier (UUID) format. There is no relationship between the SCIP number for one supplier part and another part submitted by the same supplier.';
            }
        }
        addafter(ScipNo)
        {
            group(WEEEReporting)
            { //23-10-2026 BK #569701
                Caption = 'WEEE Reporting';
                ToolTip = 'The WEEE Reporting with All or Marked';
                Image = Report;

                action(WEEEMarked)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'WEEE Report WEEE-Marked';
                    Image = PrintExcise;
                    ToolTip = 'Specification of WEEE Report ALL';

                    Trigger OnAction()
                    var
                        WEEEReport: Report "WEEE Excel Export";

                    begin
                        WEEEReport.SetItemSelection(1);
                        WEEEReport.Runmodal();
                    end;
                }
                action(WEEEAll)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'WEEE Report All';
                    ToolTip = 'WEEE Report with All Items';
                    Image = "Report";

                    Trigger OnAction()
                    var
                        WEEEReport: Report "WEEE Excel Export";

                    begin
                        WEEEReport.SetItemSelection(0);
                        WEEEReport.Runmodal();
                    end;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Inactive, false);
        if ItemListFilter <> '' then begin
            Rec.SetFilter("No.", ItemListFilter);
            CurrPage.CAPTION := 'Item List [Filtered]';
        end;
        SI.SetRejectChangeLog(false);
        Rec.SetLocationFilterOnMainWarehouse();
        SetActions();
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SetLocationFilterOnMainWarehouse();
        SetActions();
    end;

    var
        SI: Codeunit "Single Instance";
        ZyWsMgt: Codeunit "Zyxel Web Service Management";
        VckXmlMgt: Codeunit "VCK Communication Management";
        AvailabilityprLocation: Page "Availability pr Location";
        SendAllItemsToVCKVisible: Boolean;
        ItemListFilter: Text[1024];
        Text001: Label 'Do you want to replicate %1 to subs?';
        Text002: Label 'Do you want to resend %1 to VCK?';
        Text003: Label 'Do you want to send all active items to VCK?';
        Text004: Label 'Are you sure?';
        Text005: Label 'Item %1 was sent.';
        Text006: Label 'Item %1 was not sent.';


    local procedure ShowForecast()
    var
        ForecastOverviewPage: Page "Forecast Overview";
    begin
        ForecastOverviewPage.Init(Rec."No.");
        ForecastOverviewPage.RunModal;
    end;

    local procedure ReplicateItem(pDummy: Boolean; pForce: Boolean)
    var
        recRepComp: Record "Replication Company";
    begin
        if Confirm(Text001, false, Rec."No.") then
            if pForce then begin
                recRepComp.SetRange("Replicate Item", true);
                if Page.RunModal(Page::"Replicate Company Select", recRepComp) = Action::LookupOK then
                    ZyWsMgt.ReplicateItems(recRepComp."Company Name", Rec."No.", false, pForce);
            end else
                if pDummy then
                    ZyWsMgt.ReplicateItems('', '', true, false)
                else
                    ZyWsMgt.ReplicateItems('', '', false, false);
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        SendAllItemsToVCKVisible := ZGT.UserIsDeveloper();
    end;
}
