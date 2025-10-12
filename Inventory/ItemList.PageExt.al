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
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Manually OLAP"; Rec."Manually OLAP")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(IsEICard; Rec.IsEICard)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 0;
                Visible = false;
            }
            field("Transferred (Qty.)"; Rec."Transferred (Qty.)")
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 0;
                Visible = false;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Tariff No.")
        {
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(MDM; Rec.MDM)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = Basic, Suite;
            }
            field(SCM; Rec.SCM)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Number per carton"; Rec."Number per carton")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Carton Weight"; Rec."Carton Weight")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Number per parcel"; Rec."Number per parcel")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Tax Reduction rate"; Rec."Tax Reduction rate")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Category 1 Code"; Rec."Category 1 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Category 2 Code"; Rec."Category 2 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Category 3 Code"; Rec."Category 3 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Business Center"; Rec."Business Center")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Search Description")
        {
            field(SBU; Rec.SBU)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("SBU Company"; Rec."SBU Company")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("PP-Product CAT"; Rec."PP-Product CAT")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("UN Code"; Rec."UN Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Overhead Rate")
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Total Qty. per Carton"; Rec."Total Qty. per Carton")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        modify("Created From Nonstock Item")
        {
            Visible = false;
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Production BOM No.")
        {
            Visible = false;
        }
        modify("Routing No.")
        {
            Visible = false;
        }
        modify("Costing Method")
        {
            Visible = true;
        }
        modify("Last Direct Cost")
        {
            Visible = false;
        }
        modify("Price/Profit Calculation")
        {
            Visible = true;
        }
        modify("Profit %")
        {
            Visible = true;
        }
        modify("Inventory Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Item Disc. Group")
        {
            Visible = true;
        }
        modify("Vendor Item No.")
        {
            Visible = true;
        }
        modify("Indirect Cost %")
        {
            Visible = false;
        }
        modify("Item Category Code")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = false;
        }
        modify("Sales Unit of Measure")
        {
            Visible = false;
        }
        modify("Replenishment System")
        {
            Visible = false;
        }
        modify("Purch. Unit of Measure")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Manufacturing Policy")
        {
            Visible = false;
        }
        modify("Flushing Method")
        {
            Visible = false;
        }
        modify("Item Tracking Code")
        {
            Visible = false;
        }
        addlast(Control1)
        {

            field(Amaz_ASIN; Rec.Amaz_ASIN)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
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
                Caption = 'Forecast';
                Image = Forecast;

                trigger OnAction()
                begin
                    ShowForecast;
                end;
            }
        }
        addafter("Items b&y Location")
        {
            action("Item pr. Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item pr. Location';

                trigger OnAction()
                begin
                    Clear(AvailabilityprLocation);
                    AvailabilityprLocation.InitiatePage(Rec."No.");
                    AvailabilityprLocation.RunModal;
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
            }
            action("Block Customer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Block Customer';
                Image = Stop;
                RunObject = Page "Item/Customer Relation";
                RunPageLink = "Customer No." = field("No.");
            }
            action("Item List (All fields)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item List (All fields)';
                Image = ItemGroup;
                RunObject = Page "Item List (All fields)";
            }
            action("Chemical Tax Reduction Rate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chemical Tax Reduction Rate';
                Image = TaxPayment;
                RunObject = Page "Chemical Tax Rates";
            }
        }
        addafter(Production)
        {
            group(Rework)
            {
                Caption = 'Rework';
                Image = BOM;
                action("Rework BOM")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rework BOM';
                    Image = BOM;
                    RunObject = Page "Rework BOM";
                    RunPageLink = "Parent Item No." = field("No.");
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
            }
            action("Item Forecast Entries")
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
        }
        addafter("&Warehouse Entries")
        {
            action("eCommerce Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Entries';
                Image = InwardEntry;
                RunObject = Page "eCommerce Order Entries";
                RunPageLink = "Item No." = field("No.");
            }
            action("Serial No. Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Serial No. Entries';
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
                action("Battery Certificate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Battery Certificate';
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
                action("Replicate Item")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replicate Item';
                    Image = Web;

                    trigger OnAction()
                    begin
                        ReplicateItem(false, false);  // 07-01-19 ZY-LD 009
                    end;
                }
                action("Force Replication Item")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Force Replication Item';
                    Image = Web;

                    trigger OnAction()
                    begin
                        ReplicateItem(false, true);  // 07-01-19 ZY-LD 009
                    end;
                }
                action("Replicate Items (DMY/Dummy)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replicate Items (DMY/Dummy)';
                    Image = Web;

                    trigger OnAction()
                    begin
                        ReplicateItem(true, false);  // 07-01-19 ZY-LD 009
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
                        //<< 22-02-22 ZY-LD 011
                    end;
                }
            }
            action("Count")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Count';

                trigger OnAction()
                var
                    recItem: Record Item;
                    FilterNo: Code[50];
                begin
                    Message('%1 %2', StrLen(Rec."No."), Rec.Count());

                    // FilterNo := STRSUBSTNO('*@%1*','USG100-CC1-ZZ0101F');
                    // recItem.SETFILTER("No.",'%1',FilterNo);
                    // IF recItem.FINDSET THEN REPEAT
                    //  MESSAGE('%1 %2',recItem."No.",STRLEN(recItem."No."));
                    // UNTIL recItem.Next() = 0;
                end;
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

    trigger OnOpenPage()
    begin
        Rec.SetRange(Inactive, false);

        //15-51643 -
        if ItemListFilter <> '' then begin
            Rec.SetFilter("No.", ItemListFilter);
            CurrPage.CAPTION := 'Item List [Filtered]';
        end;
        //15-51643 +
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 007
        Rec.SetLocationFilterOnMainWarehouse();  // 05-07-19 ZY-LD 010
        SetActions;  // 22-02-22 ZY-LD 011
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 007
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SetLocationFilterOnMainWarehouse();  // 03-06-22 ZY-LD 012
        SetActions;  // 22-02-22 ZY-LD 011
    end;

    var
        ItemListFilter: Text[1024];
        SI: Codeunit "Single Instance";
        ZyWsMgt: Codeunit "Zyxel Web Service Management";
        Text001: Label 'Do you want to replicate %1 to subs?';
        VckXmlMgt: Codeunit "VCK Communication Management";
        Text002: Label 'Do you want to resend %1 to VCK?';
        Text003: Label 'Do you want to send all active items to VCK?';
        Text004: Label 'Are you sure?';
        Text005: Label 'Item %1 was sent.';
        Text006: Label 'Item %1 was not sent.';
        AvailabilityprLocation: Page "Availability pr Location";
        SendAllItemsToVCKVisible: Boolean;

    procedure SetItemFilter(ItemFilter: Text[1024])
    begin
        //ItemListFilter := ItemFilter;
    end;

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
        //>> 07-01-19 ZY-LD 009
        if Confirm(Text001, false, Rec."No.") then begin
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
        //<< 07-01-19 ZY-LD 009
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        SendAllItemsToVCKVisible := ZGT.UserIsDeveloper;
    end;
}
