Page 50123 "SCM Activities"
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

    Caption = 'Activities';
    PageType = CardPart;
    Permissions = TableData "ZY Logistics Cue" = i;
    SourceTable = "ZY Logistics Cue";

    layout
    {
        area(content)
        {
            cuegroup("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                Visible = SalesHeaderVisible;
                field("Purchase Orders - Active"; Rec."Purchase Orders - Active")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text045;
                    Caption = ' ';
                    DrillDownPageID = "Purchase Order List";
                }
                field("Purchase Orders - Open"; Rec."Purchase Orders - Open")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text046;
                    Caption = ' ';
                    DrillDownPageID = "Purchase Order List";
                }
                field("Purchase Orders - Not Sent"; Rec."Purchase Orders - Not Sent")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text047;
                    Caption = ' ';
                    DrillDownPageID = "Purchase Order List";
                }
            }
            cuegroup("Picking Dates")
            {
                Caption = 'Picking Dates';
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
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Error on Ship-to Address" := ReadShipToAddress;
        Rec."Warehouse Inventory Diff." := ReadWarehouseInventory.CountDifference(ItemTmp, false);
    end;

    trigger OnOpenPage()
    begin
        if ZYLogisticsCue.WritePermission then
            if ZYLogisticsCue.IsEmpty then
                ZYLogisticsCue.Insert;

        if UserSetup.Get(UserId()) and (UserSetup."Salespers./Purch. Code" <> '') then
            Rec.SetRange(Rec."Sales Person Code Filter", UserSetup."Salespers./Purch. Code");

        Rec.SetRange(Rec."User ID Filter", UserId());
        Rec.SetRange(Rec."Release Date Filter", 20170101D, CalcDate('-1D', Today));

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
        recInvSetup.Get;
        Rec.SetRange(Rec."Location Filter", recInvSetup."AIT Location Code");
        //<< 11-07-19 ZY-LD 008

        Rec.SetFilter(Rec."Send E-mail at Filter", '%1..', CurrentDatetime);  // 07-11-19 ZY-LD 009
        Rec.SetFilter(Rec."Send E-mail at Filter 2", '..%1|%2', CurrentDatetime, 0DT);  // 07-11-19 ZY-LD 009

        //>> 07-11-19 ZY-LD 009
        if recAutoSetup.Get then
            Rec.SetFilter(Rec."Warehouse Status Filter", '%1|%2..', Rec."warehouse status filter"::"Waiting for invoice", recDelDocHead.GetWhseStatusToInvoiceOn(false));
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
        Text001: label 'My Sales Orders';
        Text002: label 'All Sales Orders';
        Text003: label 'Transfer Orders';
        Text004: label 'Sales Orders Not Invoiced';
        Text005: label 'Error on Ship-to Address';
        Text006: label 'My EiCards';
        Text007: label 'IC Inbox';
        Text008: label 'IC Outbox';
        Text009: label 'Purchase Invoices - Open';
        Text010: label 'Sales Invoices - Open';
        Text011: label 'Purchase Credit Memos - Open';
        Text012: label 'Sales Credit Memos - Open';
        Text013: label 'New';
        Text014: label 'Released / New';
        Text015: label 'Released / Ready';
        Text016: label 'Released / Waiting';
        Text017: label 'New Orders';
        Text018: label 'Orders Under Treatment';
        Text019: label 'Items not Invoiced';
        Text020: label 'Errors on VCK Inbound';
        Text021: label 'Posting Errors';
        Text022: label 'Released / Not Received at Warehouse';
        Text023: label 'Order Lines not Shipped';
        Text024: label 'Items Can Not Replicate to VCK';
        Text025: label 'Ship-to Code is missing';
        Text026: label 'Ready to Release';
        Text027: label 'EDI - Sales Orders';
        Text028: label 'Warnings';
        Text029: label 'Errors';
        Text030: label 'Not Invoiced';
        Text031: label 'Container Details Over Due';
        WhseCommEnable: Boolean;
        Text032: label 'Whse. Purcase Response not Posted';
        Text033: label 'Whse. Shipment Response not Posted';
        Text034: label 'EiCard Orders to be posted';
        Text035: label 'Sales Invoices to be Printed';
        IntercompanyVisible: Boolean;
        WarehouseInboundVisible: Boolean;
        HqSaleDocMgt: Codeunit "HQ Sales Document Management";
        Text036: label 'Sales Invoices to be E-mailed';
        Text037: label 'Ready to Invoice';
        Text038: label 'Send Invoice to Customer';
        Text039: label 'Warehouse Difference';
        ReadWarehouseInventory: Codeunit "Read Warehouse Inventory";
        ZGT: Codeunit "ZyXEL General Tools";
        Text040: label 'Stock Return Not Posted';
        Text041: label 'Sales Quotes';
        Text042: label 'New/Marked Picking Date';
        Text043: label 'Unconfirmed Picking Date';
        Text044: label 'Confirmed Picking Date';
        Text045: label 'Purchase Orders - Active';
        Text046: label 'Purchase Orders - Open';
        Text047: label 'Purchase Orders - Not Sent';

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
                if not SalesHeaderTmp.Insert then;
            end
        end;
        exit(SalesHeaderTmp.Count);
    end;

    local procedure SetActions()
    var
        recWhseSetup: Record "Warehouse Setup";
    begin
        recWhseSetup.Get;

        if recWhseSetup."Stop Whse. Communication" <> 0DT then
            WhseCommEnable := not (CurrentDatetime > recWhseSetup."Stop Whse. Communication")
        else
            WhseCommEnable := true;

        IntercompanyVisible := ZGT.IsZComCompany;  // 04-05-20 ZY-LD 010
        WarehouseInboundVisible := ZGT.IsZNetCompany;  // 04-05-20 ZY-LD 010
    end;
}
