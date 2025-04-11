page 50215 "Logistics Activities"
{
    // 001. 12-03-18 ZY-LD 2018030910000257 - New action.
    // 002. 05-06-18 ZY-LD 000 - Post VCK.
    // 003. 18-09-18 ZY-LD 000 - "Ship-to Code is missing".
    // 004. 12-11-18 ZY-LD 2018111310000028 - New functions.
    // 005. 15-11-18 ZY-LD 000 - New field.
    // 006. 21-12-18 PAB Addess EDI Cues
    // 007. 03-04-19 ZY-LD 2019032210000177 - Container Detals Over Due.
    // 008. 11-07-19 ZY-LD P0213 - Filter on Location Code.
    // 009. 07-11-19 ZY-LD 000 - Sales Invoice to be printed
    // 010. 04-05-20 ZY-LD P0420 - Show only intercompany on ZCom companies.
    // 011. 04-08-21 ZY-LD 2021080410000063 - Setup Picking Dates activity boxes.
    // 012. 06-12-21 ZY-LD 000 - After changing process around customs invoice, we need to see "Invoice Received" here.

    Caption = 'Activities';
    PageType = CardPart;
    Permissions = TableData "ZY Logistics Cue" = i;
    SourceTable = "ZY Logistics Cue";

    layout
    {
        area(content)
        {
            cuegroup("Sales- / Trailing Orders")
            {
                Caption = 'Sales- / Trailing Orders';
                Visible = SalesHeaderVisible;
                field("Sales Quotes"; Rec."Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text041;
                    Caption = ' ';
                    DrillDownPageID = "Sales Quotes";
                }
                field("My Sales Orders"; Rec."My Sales Orders")
                {
                    AccessByPermission = Page "Sales Order List" = X;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text001;
                    Caption = ' ';
                    DrillDownPageID = "Sales Order List";
                }
                field("Sales Orders - Open"; Rec."Sales Orders - Open")
                {
                    AccessByPermission = Page "Sales Order List" = X;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text002;
                    Caption = ' ';
                    DrillDownPageID = "Sales Order List";
                }
                field("Transfer Orders"; Rec."Transfer Orders")
                {
                    AccessByPermission = TableData "Transfer Header" = R;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text003;
                    Caption = ' ';
                    DrillDownPageID = "Transfer Orders";
                }
                field("Error on Ship-to Address"; Rec."Error on Ship-to Address")
                {
                    AccessByPermission = Page "Sales Order List" = X;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text005;
                    Caption = ' ';
                    ToolTip = 'Name, Address, Post Code or Country/Region Code is missing';

                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Sales Order List", SalesHeaderTmp);
                    end;
                }

                actions
                {
                    Action("New Sales Order")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Order';
                        RunObject = Page "Sales Order";
                        RunPageMode = Create;
                    }
                    Action("New Sales Invoice")
                    {
                        AccessByPermission = Page "Sales Order List" = X;
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Invoice';
                        RunObject = Page "Sales Invoice";
                        RunPageMode = Create;
                    }
                    Action(Action20)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = ' ';
                    }
                    Action("New Transfer Order")
                    {
                        AccessByPermission = Page "Transfer Order" = X;
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Transfer Order';
                        RunObject = Page "Transfer Order";
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup("Picking Dates")
            {
                Caption = 'Picking Dates';
                Visible = PickingDateVisible;
                field("Marked Picking Date"; Rec."Marked Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text042;
                    Caption = ' ';
                }
                field("Unconfirmed Picking Date"; Rec."Unconfirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text043;
                    Caption = ' ';
                }
                field("Confirmed Picking Date"; Rec."Confirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text044;
                    Caption = ' ';
                }
            }
            cuegroup(Automation)
            {
                Caption = 'Automation';
                Visible = AutomationVisible;
                field("Unposted EiCard Orders"; Rec."Unposted EiCard Orders")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text034;
                    Caption = ' ';
                    DrillDownPageID = "EiCard Queue";
                }
                field("Sales Invoices to be E-mailed"; Rec."Sales Invoices to be E-mailed")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text036;
                    Caption = ' ';
                    DrillDownPageID = "Sales Document E-mail Entries";
                }
                field("Sales Invoices to be Printed"; Rec."Sales Invoices to be Printed")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text035;
                    Caption = ' ';
                    DrillDownPageID = "Posted Sales Invoices";
                }

                actions
                {
                    Action("Post All EiCard Sales Orders")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post All EiCard Sales Orders';

                        trigger OnAction()
                        var
                            lText001: Label 'Do you want to post all EiCard orders?';
                        begin
                            //>> 07-11-19 ZY-LD 010
                            if Confirm(lText001, true) then
                                HqSaleDocMgt.PostEiCardSalesOrders('', false);
                            //<< 07-11-19 ZY-LD 010
                        end;
                    }
                }
            }
            cuegroup("Inter Company")
            {
                Caption = 'Inter Company';
                Visible = IntercompanyVisible;
                field("IC Inbox Transaction"; Rec."IC Inbox Transaction")
                {
                    AccessByPermission = Page "IC Inbox Transactions" = X;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text007;
                    Caption = ' ';
                    DrillDownPageID = "IC Inbox Transactions";
                }
                field("IC Outbox Transaction"; Rec."IC Outbox Transaction")
                {
                    AccessByPermission = Page "IC Outbox Transactions" = X;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text008;
                    Caption = ' ';
                    DrillDownPageID = "IC Outbox Transactions";
                }
                field("Purchase Invoices - Open"; Rec."Purchase Invoices - Open")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text009;
                    Caption = ' ';
                    DrillDownPageID = "Purchase Invoices";
                }
                field("Sales Invoices - Open"; Rec."Sales Invoices - Open")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text010;
                    Caption = ' ';
                    DrillDownPageID = "Sales Invoice List";
                }
                field("Purchase Credit Memos - Open"; Rec."Purchase Credit Memos - Open")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text011;
                    Caption = ' ';
                    DrillDownPageID = "Purchase Credit Memos";
                }
                field("Sales Credit Memos - Open"; Rec."Sales Credit Memos - Open")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text012;
                    Caption = ' ';
                    DrillDownPageID = "Sales Credit Memos";
                }
            }
            cuegroup("Delivery Document")
            {
                Caption = 'Delivery Document';
                field(New; Rec.New)
                {
                    AccessByPermission = Page "VCK Delivery Document List" = X;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text013;
                    Caption = ' ';
                    DrillDownPageID = "VCK Delivery Document List";
                }
                field("Ready to Release"; Rec."Ready to Release")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text026;
                    Caption = ' ';
                }
                field("Not Processed"; Rec."Not Processed")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text022;
                    Caption = ' ';
                }
                field("Released Waiting"; Rec."Released Waiting")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text016;
                    Caption = ' ';
                }
                field("Not Invoiced"; Rec."Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text037;
                    Caption = ' ';

                    trigger OnDrillDown()
                    begin
                        Rec.NotInvoiced(recDelDocHead);
                        Page.Run(Page::"Delivery Documents to Invoice", recDelDocHead);
                    end;
                }
                field("Send Invoice to Customer"; Rec."Send Invoice to Customer")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text038;
                    Caption = ' ';
                }
                field("Ship-to Code is missing"; Rec."Ship-to Code is missing")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text025;
                    Caption = ' ';
                }
                field("Transferred Not Posted"; Rec."Transferred Not Posted")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text045;
                    Caption = ' ';

                    trigger OnDrillDown()
                    var
                        recDelDocLine: Record "VCK Delivery Document Line";
                    begin
                        recDelDocLine.SetRange("Document Type", recDelDocLine."document type"::Sales);
                        recDelDocLine.SetRange(Posted, false);
                        recDelDocLine.SetFilter("Warehouse Status", '%1|%2', recDelDocLine."warehouse status"::"In Transit", recDelDocLine."warehouse status"::Delivered);
                        recDelDocLine.SetFilter("Creation Date", '%1..', 20220101D);
                        Page.Run(Page::"VCK Delivery Document Line", recDelDocLine);
                    end;
                }
            }
            cuegroup(VCK)
            {
                Caption = 'VCK';
                field("Items not Invoiced"; Rec."Items not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text019;
                    Caption = ' ';
                    DrillDownPageID = "Item Ledger Entries";
                }
                field("Whse. Purcase Resp. not Posted"; Rec."Whse. Purcase Resp. not Posted")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text032;
                    Caption = ' ';
                }
                field("Whse. Ship Resp. not Posted"; Rec."Whse. Ship Resp. not Posted")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text033;
                    Caption = ' ';
                }
                field("Order Lines Not Shipped"; Rec."Order Lines Not Shipped")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text023;
                    Caption = ' ';
                }
                field("Return Order Not Credited"; Rec."Return Order Not Credited")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text040;
                    Caption = ' ';
                    DrillDownPageID = "Stock Returns to Credit";
                }
                field("Item Can Not Replicate to VCK"; Rec."Item Can Not Replicate to VCK")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text024;
                    Caption = ' ';
                }
                field("Container Details Over Due"; Rec."Container Details Over Due")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text031;
                    Caption = ' ';
                }
                field("Warehouse Inventory Diff."; Rec."Warehouse Inventory Diff.")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text039;
                    Caption = ' ';

                    trigger OnDrillDown()
                    begin
                        ReadWarehouseInventory.ShowDifference(ItemTmp);
                    end;
                }

                actions
                {
                    Action("Process VCK")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Process VCK';
                        Enabled = WhseCommEnable;
                        RunObject = Codeunit "Zyxel VCK Post Management";
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Error on Ship-to Address" := ReadShipToAddress;
        Rec."Warehouse Inventory Diff." := ReadWarehouseInventory.CountDifference(ItemTmp, false);

        if recDelDocHead.ReadPermission then
            if recAutoSetup.Get() then begin
                Rec.NotInvoiced(recDelDocHead);
                Rec."Not Invoiced" := recDelDocHead.Count();
            end;
    end;

    trigger OnOpenPage()
    begin
        if ZYLogisticsCue.WritePermission then
            if ZYLogisticsCue.IsEmpty() then
                ZYLogisticsCue.Insert();

        if UserSetup.Get(UserId()) and (UserSetup."Salespers./Purch. Code" <> '') then
            Rec.SetRange(Rec."Sales Person Code Filter", UserSetup."Salespers./Purch. Code");

        Rec.SetRange(Rec."User ID Filter", UserId());
        Rec.SetRange(Rec."Release Date Filter", 20170101D, CalcDate('<-1D>', Today));

        SalesHeaderVisible := HQEICardInvoices.ReadPermission;

        Rec.SetFilter(Rec."Shipment Date Filter", '..%1', Today + 5);  // 18-09-18 ZY-LD 003
        //>> 15-11-18 ZY-LD 005
        if Date2dwy(Today, 1) >= 5 then
            Rec.SetFilter(Rec."Requested Delivery Date Filter", '..%1', CalcDate('<CW+1D>', Today))
        else
            Rec.SetFilter(Rec."Requested Delivery Date Filter", '..%1', Today + 1);
        //<< 15-11-18 ZY-LD 005

        Rec.SetFilter(Rec."Expected Receipt Date Filter", '..%1', Today - 1);  // 03-04-19 ZY-LD 007

        //>> 11-07-19 ZY-LD 008
        recInvSetup.Get();
        Rec.SetRange(Rec."Location Filter", recInvSetup."AIT Location Code");
        //<< 11-07-19 ZY-LD 008

        Rec.SetFilter(Rec."Send E-mail at Filter", '%1..', CurrentDatetime);  // 07-11-19 ZY-LD 009
        Rec.SetFilter(Rec."Send E-mail at Filter 2", '..%1|%2', CurrentDatetime, 0DT);  // 07-11-19 ZY-LD 009

        //>> 07-11-19 ZY-LD 009
        // Removed previously comment out of code /UF (VisionPeople)
        IF recDelDocHead.READPERMISSION THEN
          IF recAutoSetup.GET THEN
            Rec.SETFILTER("Warehouse Status Filter",'%1..%2|%3..',
              Rec."Warehouse Status Filter"::"Waiting for invoice",
              Rec."Warehouse Status Filter"::"Invoice Received",  // 06-12-21 ZY-LD 012
              recDelDocHead.GetWhseStatusToInvoiceOn(false));
        //<< 07-11-19 ZY-LD 009

        SetActions;
    end;

    var
        SalesHeaderTmp: Record "Sales Header" temporary;
        ItemTmp: Record Item temporary;
        ZYLogisticsCue: Record "ZY Logistics Cue";
        UserSetup: Record "User Setup";
        HQEICardInvoices: Record "HQ EICard Invoices";
        recInvSetup: Record "Inventory Setup";
        recAutoSetup: Record "Automation Setup";
        recDelDocHead: Record "VCK Delivery Document Header";
        SalesHeaderVisible: Boolean;
        Text001: Label 'My Sales Orders';
        Text002: Label 'All Sales Orders';
        Text003: Label 'Transfer Orders';
        Text004: Label 'Sales Orders Not Invoiced';
        Text005: Label 'Error on Ship-to Address';
        Text006: Label 'My EiCards';
        Text007: Label 'IC Inbox';
        Text008: Label 'IC Outbox';
        Text009: Label 'Purchase Invoices - Open';
        Text010: Label 'Sales Invoices - Open';
        Text011: Label 'Purchase Credit Memos - Open';
        Text012: Label 'Sales Credit Memos - Open';
        Text013: Label 'New';
        Text014: Label 'Released / New';
        Text015: Label 'Released / Ready';
        Text016: Label 'Released / Waiting';
        Text017: Label 'New Orders';
        Text018: Label 'Orders Under Treatment';
        Text019: Label 'Items not Invoiced';
        Text020: Label 'Errors on VCK Inbound';
        Text021: Label 'Posting Errors';
        Text022: Label 'Released / Not Received at Warehouse';
        Text023: Label 'Order Lines not Shipped';
        Text024: Label 'Items Can Not Replicate to VCK';
        Text025: Label 'Ship-to Code is missing';
        Text026: Label 'Ready to Release';
        Text027: Label 'EDI - Sales Orders';
        Text028: Label 'Warnings';
        Text029: Label 'Errors';
        Text030: Label 'Not Invoiced';
        Text031: Label 'Container Details Over Due';
        WhseCommEnable: Boolean;
        Text032: Label 'Whse. Purcase Response not Posted';
        Text033: Label 'Whse. Shipment Response not Posted';
        Text034: Label 'EiCard Orders to be posted';
        Text035: Label 'Sales Invoices to be Printed';
        IntercompanyVisible: Boolean;
        WarehouseInboundVisible: Boolean;
        HqSaleDocMgt: Codeunit "HQ Sales Document Management";
        Text036: Label 'Sales Invoices to be E-mailed';
        Text037: Label 'Ready to Invoice';
        Text038: Label 'Send Invoice to Customer';
        Text039: Label 'Warehouse Difference';
        ReadWarehouseInventory: Codeunit "Read Warehouse Inventory";
        ZGT: Codeunit "ZyXEL General Tools";
        Text040: Label 'Stock Return Not Posted';
        Text041: Label 'Sales Quotes';
        AutomationVisible: Boolean;
        PickingDateVisible: Boolean;
        Text042: Label 'New/Marked Picking Date';
        Text043: Label 'Unconfirmed Picking Date';
        Text044: Label 'Confirmed Picking Date';
        Text045: Label 'Transferred not Posted';

    local procedure ReadShipToAddress(): Integer
    var
        lSalesHeader: Record "Sales Header";
        lSalespersonPurchaser: Record "Salesperson/Purchaser";
        lUserSetup: Record "User Setup";
        ShiptoAddressSO: Query "Ship-to Address - SO";
    begin
        //SalesHeaderTmp.DELETEALL;  // This generates an error.
        ShiptoAddressSO.SetRange(Document_Type, ShiptoAddressSO.Document_type::Order);
        ShiptoAddressSO.SetFilter(Sales_Order_Type, '<>%1', lSalesHeader."sales order type"::EICard);
        ShiptoAddressSO.SetRange(Completely_Invoiced, false);
        if UserSetup.Get(UserId()) and (UserSetup."Salespers./Purch. Code" <> '') then
            ShiptoAddressSO.SetRange(Salesperson_Code, UserSetup."Salespers./Purch. Code");
        ShiptoAddressSO.Open;
        while ShiptoAddressSO.Read do begin
            if (ShiptoAddressSO.Ship_to_Name = '') or
               (ShiptoAddressSO.Ship_to_Address = '') or
               ((ShiptoAddressSO.Ship_to_City = '') or (ShiptoAddressSO.Ship_to_Post_Code = '')) or
               (ShiptoAddressSO.Ship_to_Country_Region_Code = '')
            then begin
                lSalesHeader.Get(ShiptoAddressSO.Document_Type, ShiptoAddressSO.No);
                SalesHeaderTmp := lSalesHeader;
                if not SalesHeaderTmp.Insert() then;
            end
        end;
        exit(SalesHeaderTmp.Count());
    end;

    local procedure SetActions()
    var
        recWhseSetup: Record "Warehouse Setup";
    begin
        recWhseSetup.Get();

        if recWhseSetup."Stop Whse. Communication" <> 0DT then
            WhseCommEnable := not (CurrentDatetime > recWhseSetup."Stop Whse. Communication")
        else
            WhseCommEnable := true;

        IntercompanyVisible := ZGT.IsZComCompany;  // 04-05-20 ZY-LD 010
        WarehouseInboundVisible := ZGT.IsZNetCompany;  // 04-05-20 ZY-LD 010
        AutomationVisible := ZGT.IsZNetCompany;  // 04-08-21 ZY-LD 011
        //PickingDateVisible := ZGT.IsZComCompany;  // 04-08-21 ZY-LD 011
        if UserSetup.Get(UserId()) then
            PickingDateVisible := UserSetup."Show Picking Date"
        else
            PickingDateVisible := false;
    end;
}
