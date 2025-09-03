XmlPort 50069 "WS Container Detail"
{


    Caption = 'WS Container Detail';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/cd';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("VCK Shipping Detail"; "VCK Shipping Detail")
            {
                XmlName = 'ContainerDetail';
                UseTemporary = true;
                fieldelement(BillOfLadingNo; "VCK Shipping Detail"."Bill of Lading No.")
                {
                }
                fieldelement(ContainerNo; "VCK Shipping Detail"."Container No.")
                {
                }
                fieldelement(InvoiceNo; "VCK Shipping Detail"."Invoice No.")
                {
                }
                fieldelement(PurchaseOrderNo; "VCK Shipping Detail"."Purchase Order No.")
                {
                }
                fieldelement(PurchaseOrderLineNo; "VCK Shipping Detail"."Purchase Order Line No.")
                {
                }
                fieldelement(PalletNo; "VCK Shipping Detail"."Pallet No.")
                {
                }
                fieldelement(ItemNo; "VCK Shipping Detail"."Item No.")
                {
                }
                fieldelement(Quantity; "VCK Shipping Detail".Quantity)
                {
                }
                fieldelement(ETA; "VCK Shipping Detail".ETA)
                {
                }
                fieldelement(ETD; "VCK Shipping Detail".ETD)
                {
                }
                fieldelement(ShippingMethod; "VCK Shipping Detail"."Shipping Method")
                {
                }
                fieldelement(OrderNo; "VCK Shipping Detail"."Order No.")
                {
                }
                fieldelement(OrderType; "VCK Shipping Detail"."Order Type")
                {
                }
                fieldelement(LocationCode; "VCK Shipping Detail".Location)
                {
                }
                fieldelement(ExpectedReceiptDate; "VCK Shipping Detail"."Expected Receipt Date")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    EntryNo += 1;
                    "VCK Shipping Detail"."Entry No." := EntryNo;

                end;
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
        EntryNo: Integer;
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetData(pSalesInvNo: Code[20]): Boolean
    var
        recSaleInvLine: Record "Sales Invoice Line";
        recSaleShipLine: Record "Sales Shipment Line";
    begin
        recSaleInvLine.SetRange("Document No.", pSalesInvNo);
        recSaleInvLine.SetRange(Type, recSaleInvLine.Type::Item);
        if recSaleInvLine.FindSet then
            repeat
                if not recSaleShipLine.Get(recSaleInvLine."Shipment No.", recSaleInvLine."Shipment Line No.") then
                    Clear(recSaleShipLine);

                EntryNo += 1;
                "VCK Shipping Detail"."Entry No." := EntryNo;
                if ZGT.IsZNetCompany then
                    "VCK Shipping Detail"."Bill of Lading No." := 'ZNET-INTERNAL'
                else
                    "VCK Shipping Detail"."Bill of Lading No." := 'ZYXEL-INTERNAL';
                "VCK Shipping Detail"."Invoice No." := recSaleInvLine."Document No.";
                "VCK Shipping Detail"."Purchase Order No." := recSaleShipLine."Ext Vend Purch. Order No.";
                "VCK Shipping Detail"."Purchase Order Line No." := recSaleShipLine."Ext Vend Purch. Order Line No.";
                "VCK Shipping Detail"."Pallet No." := '1';
                "VCK Shipping Detail"."Item No." := recSaleInvLine."No.";
                "VCK Shipping Detail".Quantity := recSaleInvLine.Quantity;
                "VCK Shipping Detail".ETA := recSaleInvLine."Shipment Date";
                "VCK Shipping Detail".ETD := recSaleInvLine."Shipment Date";
                "VCK Shipping Detail"."Order No." := recSaleShipLine."Picking List No.";
                "VCK Shipping Detail"."Order Type" := "VCK Shipping Detail"."order type"::"Purchase Order";
                "VCK Shipping Detail"."Container No." := recSaleShipLine."Picking List No.";

                if not "VCK Shipping Detail".Insert then
                    repeat
                        "VCK Shipping Detail"."Pallet No." := IncStr("VCK Shipping Detail"."Pallet No.");
                    until "VCK Shipping Detail".Insert;

            until recSaleInvLine.Next() = 0;

        exit(true);
    end;


    procedure SetData_SalesReturn(pSalesReturnOrderNo: Code[20]): Boolean
    var
        recSalesLine: Record "Sales Line";
        recAutoSetup: Record "Automation Setup";
        Location: Record Location;
        CalculatedDate: Date;
        NoOfDays: Integer;
    begin
        recAutoSetup.Get;
        CalculatedDate := CalcDate(recAutoSetup."Release HQ Whse. Indb. DateF.", Today);
        NoOfDays := (Today - CalculatedDate) + 5;

        recSalesLine.SetRange("Document Type", recSalesLine."document type"::"Return Order");
        recSalesLine.SetRange("Document No.", pSalesReturnOrderNo);
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        if recSalesLine.FindSet then
            repeat
                EntryNo += 1;
                "VCK Shipping Detail"."Entry No." := EntryNo;
                "VCK Shipping Detail"."Container No." := recSalesLine."Document No.";
                "VCK Shipping Detail"."Bill of Lading No." := 'RETURN ORDER';
                "VCK Shipping Detail"."Invoice No." := recSalesLine."Document No.";
                "VCK Shipping Detail"."Purchase Order No." := recSalesLine."Document No.";
                "VCK Shipping Detail"."Purchase Order Line No." := recSalesLine."Line No.";
                "VCK Shipping Detail"."Pallet No." := '1';
                "VCK Shipping Detail"."Item No." := recSalesLine."No.";
                "VCK Shipping Detail".Quantity := recSalesLine.Quantity;
                "VCK Shipping Detail".ETA := Today + NoOfDays;
                "VCK Shipping Detail".ETD := Today;
                "VCK Shipping Detail"."Order No." := recSalesLine."Document No.";
                "VCK Shipping Detail"."Order Type" := "VCK Shipping Detail"."order type"::"Sales Return Order";
                "VCK Shipping Detail".Location := recSalesLine."Location Code";
                // 07-07-2025 BK #506753
                if "VCK Shipping Detail".Location <> '' then
                    if location.get("VCK Shipping Detail".Location) then
                        "VCK Shipping Detail"."Main Warehouse" := location."Main Warehouse";
                "VCK Shipping Detail"."Expected Receipt Date" := Today + NoOfDays;
                "VCK Shipping Detail"."Shipping Method" := 'DDP';
                "VCK Shipping Detail".Insert;
            until recSalesLine.Next() = 0;
        exit(true);

    end;


    procedure SetData_PurchaseOrder(pPurchOrderNo: Code[20]): Boolean
    var
        recSalesLine: Record "Sales Line";
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        Location: Record Location;
    begin
        //>> 02-04-20 ZY-LD 003
        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
        recPurchLine.SetRange("Document No.", pPurchOrderNo);
        recPurchLine.SetRange(Type, recPurchLine.Type::Item);
        if recPurchLine.FindSet then
            repeat
                recPurchLine.TestField("Expected Receipt Date");
                if recPurchLine.ETA = 0D then
                    recPurchLine.ETA := recPurchLine."Expected Receipt Date";

                EntryNo += 1;
                "VCK Shipping Detail"."Entry No." := EntryNo;
                "VCK Shipping Detail"."Container No." := recPurchLine."Document No.";
                "VCK Shipping Detail"."Bill of Lading No." := 'PURCHASE ORDER';
                "VCK Shipping Detail"."Invoice No." := recPurchLine."Document No.";
                "VCK Shipping Detail"."Purchase Order No." := recPurchLine."Document No.";
                "VCK Shipping Detail"."Purchase Order Line No." := recPurchLine."Line No.";
                "VCK Shipping Detail"."Pallet No." := '1';
                "VCK Shipping Detail"."Item No." := recPurchLine."No.";
                "VCK Shipping Detail".Quantity := recPurchLine.Quantity;
                "VCK Shipping Detail".ETA := recPurchLine.ETA;
                "VCK Shipping Detail".ETD := recPurchLine."ETD Date";
                if "VCK Shipping Detail".ETD = 0D then
                    "VCK Shipping Detail".ETD := "VCK Shipping Detail".ETA;
                "VCK Shipping Detail"."Order No." := recPurchLine."Document No.";
                "VCK Shipping Detail"."Order Type" := "VCK Shipping Detail"."order type"::"Purchase Order";
                "VCK Shipping Detail".Location := recPurchLine."Location Code";
                // 02-09-2025 BK #506753,  #526138
                if "VCK Shipping Detail".Location <> '' then
                    if location.get("VCK Shipping Detail".Location) then
                        "VCK Shipping Detail"."Main Warehouse" := location."Main Warehouse";
                "VCK Shipping Detail"."Expected Receipt Date" := recPurchLine."Expected Receipt Date";
                recPurchHead.Get(recPurchHead."document type"::Order, pPurchOrderNo);
                "VCK Shipping Detail"."Shipping Method" := recPurchHead."Shipment Method Code";
                "VCK Shipping Detail".Insert;
            until recPurchLine.Next() = 0;
        exit(true);
    end;


    procedure SetData_TransferOrder(pTransferOrderNo: Code[20]): Boolean
    var
        recTransHead: Record "Transfer Header";
        recTransLine: Record "Transfer Line";
        recAutoSetup: Record "Automation Setup";
        Location: Record Location;
        CalculatedDate: Date;
        NoOfDays: Integer;
    begin
        recTransHead.Get(pTransferOrderNo);
        if (recTransHead."Transfer-from Address" = recTransHead."Transfer-to Address") and
           (recTransHead."Transfer-from Post Code" = recTransHead."Transfer-to Post Code")
        then
            NoOfDays := 0
        else begin
            recAutoSetup.Get;
            CalculatedDate := CalcDate(recAutoSetup."Release HQ Whse. Indb. DateF.", Today);
            NoOfDays := (Today - CalculatedDate) + 3;
        end;
        recTransLine.SetRange("Document No.", pTransferOrderNo);
        recTransLine.SetRange("Derived From Line No.", 0);
        if recTransLine.FindSet then
            repeat
                EntryNo += 1;
                "VCK Shipping Detail"."Entry No." := EntryNo;
                "VCK Shipping Detail"."Container No." := recTransLine."Document No.";
                "VCK Shipping Detail"."Bill of Lading No." := 'TRANSFER ORDER';
                "VCK Shipping Detail"."Invoice No." := recTransLine."Document No.";
                "VCK Shipping Detail"."Purchase Order No." := recTransLine."Document No.";
                "VCK Shipping Detail"."Purchase Order Line No." := recTransLine."Line No.";
                "VCK Shipping Detail"."Pallet No." := '1';
                "VCK Shipping Detail"."Item No." := recTransLine."Item No.";
                "VCK Shipping Detail".Quantity := recTransLine.Quantity;
                "VCK Shipping Detail".ETA := Today + NoOfDays;
                "VCK Shipping Detail".ETD := Today;
                "VCK Shipping Detail"."Order No." := recTransLine."Document No.";
                "VCK Shipping Detail"."Order Type" := "VCK Shipping Detail"."order type"::"Transfer Order";
                "VCK Shipping Detail".Location := recTransLine."Transfer-to Code";
                // 02-09-2025 BK #506753,  #526138
                if "VCK Shipping Detail".Location <> '' then
                    if location.get("VCK Shipping Detail".Location) then
                        "VCK Shipping Detail"."Main Warehouse" := location."Main Warehouse";
                "VCK Shipping Detail"."Expected Receipt Date" := Today + NoOfDays;
                "VCK Shipping Detail"."Shipping Method" := 'DDP';
                "VCK Shipping Detail".Insert;
            until recTransLine.Next() = 0;
        exit(true);
    end;


    procedure GetData(var pContainerDetail: Record "VCK Shipping Detail" temporary)
    var
        recInvSetup: Record "Inventory Setup";
        lText001: label 'The "Item No." %1 is not an acceptable number.';
    begin
        if "VCK Shipping Detail".FindSet then begin
            recInvSetup.Get;
            repeat

                if "VCK Shipping Detail"."Item No." = 'MK0000' then
                    Error(lText001, "VCK Shipping Detail"."Item No.");

                pContainerDetail := "VCK Shipping Detail";

                if pContainerDetail.Location = '' then
                    pContainerDetail.Location := recInvSetup."AIT Location Code";

                pContainerDetail.Insert;
            until "VCK Shipping Detail".Next() = 0;
        end;
    end;
}
