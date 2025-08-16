codeunit 50077 "Zyxel HQ Web Service Mgt."
{

    var
        WebServiceLogEntry: Record "Web Service Log Entry";
        ServerEnvironment: Record "Server Environment";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";

    procedure CountryOfOrigin(var pItemTmp: Record Item temporary): Boolean
    var
        recItem: Record Item;
        lText001: Label 'COUNTRY OF ORIGIN';
    begin
        // Update Country of Origin into item table
        if pItemTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');
            recItem.LockTable();
            repeat
                if recItem.Get(pItemTmp."No.") then
                    if recItem."Country/Region of Origin Code" <> pItemTmp."Country/Region of Origin Code" then begin
                        recItem."Country/Region of Origin Code" := pItemTmp."Country/Region of Origin Code";
                        recItem.Modify(true);
                        WebServiceLogEntry."Quantity Inserted" += 1;
                    end;
            until pItemTmp.Next() = 0;

            CloseWebServiceLog();

            exit(true);
        end;
    end;


    procedure Category(var pItemTmp: Record Item temporary; var pHqDimTmp: Record SBU temporary): Boolean
    var
        recItem: Record Item;
        recHqDimension: Record SBU;
        lText001: Label 'Category';
    begin
        // Updates categories into item table
        if pItemTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');

            recItem.LockTable();
            repeat
                if recItem.Get(pItemTmp."No.") then
                    if (recItem."Category 1 Code" <> pItemTmp."Category 1 Code") or
                       (recItem."Category 2 Code" <> pItemTmp."Category 2 Code") or
                       (recItem."Category 3 Code" <> pItemTmp."Category 3 Code") or
                       (recItem."Business Center" <> pItemTmp."Business Center") or
                       (recItem.SBU <> pItemTmp.SBU) or
                       (recItem."SBU Company" <> pItemTmp."SBU Company")
                    then begin
                        recItem."Category 1 Code" := pItemTmp."Category 1 Code";
                        recItem."Category 2 Code" := pItemTmp."Category 2 Code";
                        recItem."Category 3 Code" := pItemTmp."Category 3 Code";
                        recItem."Business Center" := pItemTmp."Business Center";
                        recItem.SBU := pItemTmp.SBU;
                        recItem."SBU Company" := pItemTmp."SBU Company";
                        recItem.Modify(true);

                        WebServiceLogEntry."Quantity Modified" += 1;
                    end;
            until pItemTmp.Next() = 0;

            if pHqDimTmp.FindSet() then
                repeat
                    recHqDimension := pHqDimTmp;
                    if not recHqDimension.Modify() then
                        recHqDimension.Insert();
                until pHqDimTmp.Next() = 0;

            CloseWebServiceLog();

            exit(true);
        end;
    end;

    procedure Forecast(pBudgetName: Code[10]; pPeriodStartDate: Date; pPeriodEndDate: Date; pLastUpdate: Boolean; var pItemBudgetEntry: Record "Item Budget Entry" temporary): Boolean
    var
        recItemBudgetEntry: Record "Item Budget Entry";
        EntryNo: Integer;
        QtyImported: Integer;
        QtyDeleted: Integer;
        ImportForecast: Boolean;
        lText002: Label 'Budget Name: %1, Start Date: %2, End Date: %3.';
        lText003: Label 'FORECAST';
    begin
        // Import forecast entries into item budget entry
        if pItemBudgetEntry.FindSet() then begin
            CreateWebServiceLog(lText003, StrSubstNo(lText002, pBudgetName, Format(pPeriodStartDate, 0, 3), Format(pPeriodEndDate, 0, 3)));

            if pPeriodStartDate <> 0D then begin
                if (Date2dmy(pPeriodStartDate, 2) <> Date2dmy(Today, 2)) or
                    (Date2dmy(pPeriodStartDate, 3) <> Date2dmy(Today, 3))
                then
                    ImportForecast := true;
            end else
                ImportForecast := true;

            if ImportForecast then begin
                recItemBudgetEntry.LockTable();
                // Delete existing records
                if pPeriodStartDate <> 0D then begin
                    recItemBudgetEntry.SetCurrentkey("Budget Name", Date);
                    recItemBudgetEntry.SetRange("Budget Name", pBudgetName);
                    recItemBudgetEntry.SetRange(Date, pPeriodStartDate, pPeriodEndDate);
                    if recItemBudgetEntry.FindSet(true) then
                        repeat
                            recItemBudgetEntry.Delete();
                            QtyDeleted += 1;
                        until recItemBudgetEntry.Next() = 0;

                    WebServiceLogEntry."Quantity Deleted" += QtyDeleted;
                end;

                // Find last entry no.
                recItemBudgetEntry.SetCurrentkey("Entry No.");
                recItemBudgetEntry.SetRange("Budget Name");
                recItemBudgetEntry.SetRange(Date);
                if recItemBudgetEntry.FindLast() then
                    EntryNo := recItemBudgetEntry."Entry No.";

                repeat
                    EntryNo += 1;

                    recItemBudgetEntry := pItemBudgetEntry;
                    recItemBudgetEntry."Entry No." := EntryNo;
                    recItemBudgetEntry."Budget Name" := pBudgetName;
                    recItemBudgetEntry."Modification Date" := Today();
                    recItemBudgetEntry.Insert(true);
                    QtyImported += 1;
                until pItemBudgetEntry.Next() = 0;
                WebServiceLogEntry."Quantity Inserted" := QtyImported;
            end;

            CloseWebServiceLog();

            exit(true);
        end;

    end;

    procedure ContainerDetail(var TempContainerDetail: Record "VCK Shipping Detail" temporary): Boolean
    var
        PurchLine: Record "Purchase Line";
        ShipmentMethod: Record "Shipment Method";
        Item: Record Item;
        TransLine: Record "Transfer Line";
        ContainerDetailRec: Record "VCK Shipping Detail";
        SrvEnviron: Record "Server Environment";
        Vessel: Record Vessel;
        WhseInboundHeader: Record "Warehouse Inbound Header";
        ContainerDetailReport: Report "Container Details";
        FileMgt: Codeunit "File Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        BatchNo: Code[20];
        ServerFilename: Text;
        ReportFilter: Text;
        HqInvoiceNo: Text;
        ItemMissingText: Text;
        CDT: DateTime;
        PurchOrderLineNo: Integer;
        SendEmail: Boolean;
        SendFraightWarning: Boolean;
        SendContainerNoIsMissing: Boolean;
        ContainerNoIsExisting: Boolean;
        ExcelFileNameLbl: Label 'Zyxel Container Details, Batch No. %1.xlsx';
        ContainerDetailsLbl: Label 'CONTAINER DETAILS';
        BacthNoLbl: Label 'Batch No.: %1';
        ItemNotCreatedLbl: Label '"Item No." %1 is not created in our system "%2" %3, "%4" %5.<br>';
        ContainerNoMustOnlyNumbersErr: Label '"Container No." must only contain one number "%1".';
        LinesBothWithWithoutContainerNoErr: Label 'For the shipment "%1" we have received lines both with and without "Container No.".';

    begin
        // Update container details
        TempContainerDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Invoice No.");
        TempContainerDetail.Ascending(false);
        if TempContainerDetail.FindSet() then begin
            BatchNo := NoSeriesMgt.GetNextNo('CDTBATCH', Today(), true);
            CreateWebServiceLog(ContainerDetailsLbl, StrSubstNo(BacthNoLbl, BatchNo));

            CDT := CurrentDatetime();
            ContainerDetailRec.LockTable();

            // Container Details is always sent in batches by invoice no. If we receive an update, we archive the old lines before inserting the new lines.
            ContainerDetailRec.SetRange("Invoice No.", TempContainerDetail."Invoice No.");
            ContainerDetailRec.SetRange(Archive, false);
            if ContainerDetailRec.FindFirst() then begin
                WhseInboundHeader.SetRange("Invoice No.", TempContainerDetail."Invoice No.");
                if WhseInboundHeader.FindSet(true) then
                    repeat
                        WhseInboundHeader.Delete(true);
                    until WhseInboundHeader.Next() = 0;

                ContainerDetailRec.ModifyAll(Archive, true);
            end;

            repeat
                // Validate Container No.
                if (TempContainerDetail."Container No." <> '') and ((StrPos(TempContainerDetail."Container No.", ',') <> 0) or (StrPos(TempContainerDetail."Container No.", ';') <> 0)) then
                    Error(ContainerNoMustOnlyNumbersErr, TempContainerDetail."Container No.");

                // Locate correct Purchase Order Line No. if we receive zero
                PurchOrderLineNo := TempContainerDetail."Purchase Order Line No.";
                if (PurchOrderLineNo = 0) or
                   ((TempContainerDetail."Order Type" = TempContainerDetail."Order Type"::"Purchase Order") and
                   (not PurchLine.Get(PurchLine."document type"::Order, TempContainerDetail."Purchase Order No.", TempContainerDetail."Purchase Order Line No.")))
                then begin
                    PurchOrderLineNo := GetPurchaseOrderLineNo(TempContainerDetail."Purchase Order No.", TempContainerDetail."Item No.", TempContainerDetail.Quantity);
                    TempContainerDetail."P.O. Line No. Found by Us" := PurchOrderLineNo <> 0;
                end;

                if TempContainerDetail."Invoice No." <> '' then
                    if StrPos(HqInvoiceNo, TempContainerDetail."Invoice No.") = 0 then
                        if HqInvoiceNo = '' then
                            HqInvoiceNo := TempContainerDetail."Invoice No."
                        else
                            HqInvoiceNo := HqInvoiceNo + ', ' + TempContainerDetail."Invoice No.";

                ContainerDetailRec := TempContainerDetail;
                ContainerDetailRec."Entry No." := 0;
                ContainerDetailRec."Purchase Order Line No." := PurchOrderLineNo;
                ContainerDetailRec."Batch No." := BatchNo;
                if PurchLine.Get(PurchLine."Document Type"::Order, ContainerDetailRec."Purchase Order No.", ContainerDetailRec."Purchase Order Line No.") then begin
                    UpdatePurchaseOrderLine(PurchLine, TempContainerDetail);

                    ContainerDetailRec."Expected Receipt Date" := PurchLine."Expected Receipt Date";
                    if PurchLine.OriginalLocationCode <> '' then
                        ContainerDetailRec.Location := PurchLine.OriginalLocationCode
                    else
                        ContainerDetailRec.Location := PurchLine."Location Code";
                end;

                if ContainerDetailRec."Main Warehouse" then begin
                    ContainerDetailRec.Location := ItemLogisticEvent.GetMainWarehouseLocation();

                    if ContainerDetailRec."Shipping Method" = 'SEA' then
                        if ContainerDetailRec."Container No." = '' then
                            SendContainerNoIsMissing := true
                        else
                            ContainerNoIsExisting := true;

                    if ContainerNoIsExisting and SendContainerNoIsMissing then
                        Error(LinesBothWithWithoutContainerNoErr, TempContainerDetail."Invoice No.");
                end;

                ContainerDetailRec."Data Received Created" := CDT;
                ContainerDetailRec.Validate("Original ETA Date", ContainerDetailRec.ETA);
                ContainerDetailRec.Insert(true);

                WebServiceLogEntry."Quantity Inserted" += 1;

                if TempContainerDetail."Vessel Code" <> Vessel.Code then
                    if not Vessel.Get(TempContainerDetail."Vessel Code") then begin
                        Clear(Vessel);
                        Vessel.Init();
                        Vessel.Code := TempContainerDetail."Vessel Code";
                        Vessel.Description := TempContainerDetail."Vessel Code";
                        Vessel.Insert();
                    end;

                if ContainerDetailRec."Purchase Order Line No." = 0 then
                    SendEmail := true;

                if not SendFraightWarning then
                    if ShipmentMethod.Get(ContainerDetailRec."Shipping Method") and (Format(ShipmentMethod."Send Warning for Freight Time") <> '') then
                        if ContainerDetailRec.ETA - ContainerDetailRec.ETD < ShipmentMethod."Send Warning for Freight Time" then begin
                            SI.SetMergefield(102, Format(ShipmentMethod."Send Warning for Freight Time"));
                            SI.SetMergefield(103, Format(ContainerDetailRec.ETA));
                            SI.SetMergefield(104, Format(ContainerDetailRec.ETD));
                            SI.SetMergefield(105, Format(ContainerDetailRec.ETA - ContainerDetailRec.ETD));
                            SendFraightWarning := true;
                        end;

                if not Item.Get(TempContainerDetail."Item No.") then
                    ItemMissingText +=
                      StrSubstNo(ItemNotCreatedLbl,
                        TempContainerDetail."Item No.",
                        TempContainerDetail.FieldCaption("Purchase Order No."), TempContainerDetail."Purchase Order No.",
                        TempContainerDetail.FieldCaption("Purchase Order Line No."), TempContainerDetail."Purchase Order Line No.");

                if ContainerDetailRec."Expected Receipt Date" <> 0D then begin
                    TransLine.SetRange(PurchaseOrderNo, ContainerDetailRec."Purchase Order No.");
                    TransLine.SetRange(PurchaseOrderLineNo, ContainerDetailRec."Purchase Order Line No.");
                    if TransLine.FindSet() then
                        repeat
                            TransLine.ExpectedReceiptDate := ContainerDetailRec."Expected Receipt Date";
                            If not TransLine.Modify() then;
                        until TransLine.next() = 0;
                end;
            until TempContainerDetail.Next() = 0;

            CloseWebServiceLog();

            if SrvEnviron.ProductionEnvironment() then begin
                // Send an e-mail if purchase order line no. are blank.
                if SendEmail then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('HQCONTDETE', '', '');
                    EmailAddMgt.Send();
                end;

                // Send e-mail with attached document to VCK
                Commit();

                ServerFilename := FileMgt.ServerTempFileName('xlsx');
                ReportFilter := StrSubstNo('*%1*', BatchNo);
                ContainerDetailRec.Reset();
                ContainerDetailRec.SetFilter("Batch No.", ReportFilter);
                ContainerDetailRec.SetRange("Data Received Created", CDT);
                ContainerDetailReport.SetTableView(ContainerDetailRec);
                ContainerDetailReport.SaveAsExcel(ServerFilename);

                Clear(EmailAddMgt);
                SI.SetMergefield(100, BatchNo);
                SI.SetMergefield(101, HqInvoiceNo);
                EmailAddMgt.CreateEmailWithAttachment('HQCONTDET', '', '', ServerFilename, StrSubstNo(ExcelFileNameLbl, BatchNo), false);
                EmailAddMgt.Send();

                if SendFraightWarning then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('LOGFRAWARN', '', '');
                    EmailAddMgt.Send();
                end;

                if ItemMissingText <> '' then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateEmailWithBodytext2('LOGITEMMIS', '', ItemMissingText, '');
                    EmailAddMgt.Send();
                end;

                if SendContainerNoIsMissing then begin
                    Clear(EmailAddMgt);
                    SI.SetMergefield(100, TempContainerDetail."Invoice No.");
                    EmailAddMgt.CreateSimpleEmail('HQNOCONTNO', '', '');
                    EmailAddMgt.Send();
                end;
            end;

            exit(true);
        end;
    end;

    procedure ContainerDetail_OLD(var pContainerDetail: Record "VCK Shipping Detail" temporary): Boolean
    var
        recContainerDetail: Record "VCK Shipping Detail";
        recPurchLine: Record "Purchase Line";
        recServEnviron: Record "Server Environment";
        recShipMethod: Record "Shipment Method";
        recItem: Record Item;
        recVessel: Record Vessel;
        repContainerDetail: Report "Container Details";
        FileMgt: Codeunit "File Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        CDT: DateTime;
        SendEmail: Boolean;
        ServerFilename: Text;
        lText001: Label 'Zyxel Container Details, Batch No. %1.xlsx';
        lText002: Label 'CONTAINER DETAILS';
        BatchNo: Code[20];
        lText003: Label 'Batch No.: %1';
        ReportFilter: Text;
        HqInvoiceNo: Text;
        ItemMissingText: Text;
        PurchOrderLineNo: Integer;
        SaveBatchNo: Code[20];
        SaveDocumentNo: Code[20];
        SaveLineNo: Integer;
        SaveEntryNo: Integer;
        SendFraightWarning: Boolean;
        lText004: Label '"Item No." %1 is not created in our system "%2" %3, "%4" %5.<br>';
        lText006: Label '"Container No." must only contain one number "%1".';
        SendContainerNoIsMissing: Boolean;
    begin
        // Update container details
        pContainerDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Invoice No.");
        pContainerDetail.Ascending(false);
        if pContainerDetail.FindSet() then begin
            BatchNo := NoSeriesMgt.GetNextNo('CDTBATCH', Today, true);
            CreateWebServiceLog(lText002, StrSubstNo(lText003, BatchNo));

            CDT := CurrentDatetime();
            recContainerDetail.LockTable();
            repeat
                if (pContainerDetail."Container No." <> '') and
                   ((StrPos(pContainerDetail."Container No.", ',') <> 0) or
                    (StrPos(pContainerDetail."Container No.", ';') <> 0))
                then
                    Error(lText006, pContainerDetail."Container No.");

                PurchOrderLineNo := pContainerDetail."Purchase Order Line No.";
                if (PurchOrderLineNo = 0) or
                   ((pContainerDetail."Order Type" = pContainerDetail."order type"::"Purchase Order") and
                    (not recPurchLine.Get(recPurchLine."document type"::Order, pContainerDetail."Purchase Order No.", pContainerDetail."Purchase Order Line No.")))
                then begin
                    PurchOrderLineNo := GetPurchaseOrderLineNo(pContainerDetail."Purchase Order No.", pContainerDetail."Item No.", pContainerDetail.Quantity);
                    pContainerDetail."P.O. Line No. Found by Us" := PurchOrderLineNo <> 0;
                end;

                if pContainerDetail."Invoice No." <> '' then
                    if StrPos(HqInvoiceNo, pContainerDetail."Invoice No.") = 0 then
                        if HqInvoiceNo = '' then
                            HqInvoiceNo := pContainerDetail."Invoice No."
                        else
                            HqInvoiceNo := HqInvoiceNo + ', ' + pContainerDetail."Invoice No.";

                recContainerDetail.Reset();
                recContainerDetail.SetRange("Container No.", pContainerDetail."Container No.");
                recContainerDetail.SetRange("Invoice No.", pContainerDetail."Invoice No.");
                recContainerDetail.SetRange("Purchase Order No.", pContainerDetail."Purchase Order No.");
                recContainerDetail.SetRange("Purchase Order Line No.", PurchOrderLineNo);
                recContainerDetail.SetRange("Item No.", pContainerDetail."Item No.");
                recContainerDetail.SetRange("Pallet No.", pContainerDetail."Pallet No.");
                recContainerDetail.SetRange("Shipping Method", pContainerDetail."Shipping Method");
                recContainerDetail.SetRange("Order No.", pContainerDetail."Order No.");
                recContainerDetail.SetRange(Archive, false);
                if recContainerDetail.FindFirst() then begin

                    if BatchNo = recContainerDetail."Batch No." then begin
                        recContainerDetail.Quantity := recContainerDetail.Quantity + pContainerDetail.Quantity;
                        recContainerDetail.Modify();
                    end else begin
                        recContainerDetail.SetRange("Batch No.", BatchNo);
                        if recContainerDetail.FindFirst() then begin
                            recContainerDetail.Quantity := recContainerDetail.Quantity + pContainerDetail.Quantity;
                            recContainerDetail.Modify();
                        end else begin
                            SaveBatchNo := CopyStr(recContainerDetail."Batch No.", 1, 20);
                            SaveDocumentNo := recContainerDetail."Document No.";
                            SaveLineNo := recContainerDetail."Line No.";
                            SaveEntryNo := recContainerDetail."Entry No.";
                            recContainerDetail := pContainerDetail;
                            recContainerDetail."Document No." := SaveDocumentNo;
                            recContainerDetail."Line No." := SaveLineNo;
                            recContainerDetail."Entry No." := SaveEntryNo;
                            recContainerDetail."Purchase Order Line No." := PurchOrderLineNo;
                            recContainerDetail."Batch No." := BatchNo;
                            recContainerDetail."Previous Batch No." := copystr(DelChr(recContainerDetail."Previous Batch No." + '; ' + SaveBatchNo, '<', '; '), 1, 50);
                            if recPurchLine.Get(recPurchLine."document type"::Order, recContainerDetail."Purchase Order No.", recContainerDetail."Purchase Order Line No.") then begin
                                UpdatePurchaseOrderLine(recPurchLine, pContainerDetail);

                                recContainerDetail."Expected Receipt Date" := recPurchLine."Expected Receipt Date";
                                recContainerDetail.Location := recPurchLine."Location Code";
                            end;
                            if recContainerDetail."Main Warehouse" then
                                recContainerDetail.Location := ItemLogisticEvent.GetMainWarehouseLocation();
                            recContainerDetail."Data Received Updated" := CDT;
                            recContainerDetail.Modify();
                            WebServiceLogEntry."Quantity Modified" += 1;

                            if recContainerDetail."Purchase Order Line No." = 0 then
                                SendEmail := true;
                        end;
                        recContainerDetail.SetRange("Batch No.");
                    end;
                end else begin
                    recContainerDetail.SetRange(Archive, true);
                    if not recContainerDetail.FindFirst() then begin
                        recContainerDetail := pContainerDetail;
                        recContainerDetail."Entry No." := 0;
                        recContainerDetail."Purchase Order Line No." := PurchOrderLineNo;
                        recContainerDetail."Batch No." := BatchNo;
                        if recPurchLine.Get(recPurchLine."document type"::Order, recContainerDetail."Purchase Order No.", recContainerDetail."Purchase Order Line No.") then begin
                            UpdatePurchaseOrderLine(recPurchLine, pContainerDetail);

                            recContainerDetail."Expected Receipt Date" := recPurchLine."Expected Receipt Date";
                            recContainerDetail.Location := recPurchLine."Location Code";
                        end;

                        if recContainerDetail."Main Warehouse" then begin
                            recContainerDetail.Location := ItemLogisticEvent.GetMainWarehouseLocation();

                            if (recContainerDetail."Shipping Method" = 'SEA') and (recContainerDetail."Container No." = '') then  // Moved to this part of the code
                                SendContainerNoIsMissing := true;
                        end;

                        recContainerDetail."Data Received Created" := CDT;
                        recContainerDetail.Validate("Original ETA Date", recContainerDetail.ETA);
                        recContainerDetail.Insert(true);  //  TRUE is added.
                        WebServiceLogEntry."Quantity Inserted" += 1;

                        if pContainerDetail."Vessel Code" <> recVessel.Code then
                            if not recVessel.Get(pContainerDetail."Vessel Code") then begin
                                Clear(recVessel);
                                recVessel.Init();
                                recVessel.Code := pContainerDetail."Vessel Code";
                                recVessel.Description := pContainerDetail."Vessel Code";
                                recVessel.Insert();
                            end;

                        if recContainerDetail."Purchase Order Line No." = 0 then
                            SendEmail := true;

                        if not SendFraightWarning then
                            if recShipMethod.Get(recContainerDetail."Shipping Method") and (Format(recShipMethod."Send Warning for Freight Time") <> '') then
                                if recContainerDetail.ETA - recContainerDetail.ETD < recShipMethod."Send Warning for Freight Time" then begin
                                    SI.SetMergefield(102, Format(recShipMethod."Send Warning for Freight Time"));
                                    SI.SetMergefield(103, Format(recContainerDetail.ETA));
                                    SI.SetMergefield(104, Format(recContainerDetail.ETD));
                                    SI.SetMergefield(105, Format(recContainerDetail.ETA - recContainerDetail.ETD));
                                    SendFraightWarning := true;
                                end;
                    end;
                end;

                if not recItem.Get(pContainerDetail."Item No.") then
                    ItemMissingText +=
                      StrSubstNo(lText004,
                        pContainerDetail."Item No.",
                        pContainerDetail.FieldCaption("Purchase Order No."), pContainerDetail."Purchase Order No.",
                        pContainerDetail.FieldCaption("Purchase Order Line No."), pContainerDetail."Purchase Order Line No.");

            until pContainerDetail.Next() = 0;
            CloseWebServiceLog();

            if recServEnviron.ProductionEnvironment() then begin
                // Send an e-mail if purchase order line no. are blank.
                if SendEmail then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('HQCONTDETE', '', '');
                    EmailAddMgt.Send();
                end;

                // Send e-mail with attached document to VCK
                Commit();
                ServerFilename := FileMgt.ServerTempFileName('xlsx');
                ReportFilter := StrSubstNo('*%1*', BatchNo);
                recContainerDetail.Reset();
                recContainerDetail.SetFilter("Batch No.", ReportFilter);
                recContainerDetail.SetRange("Data Received Created", CDT);
                repContainerDetail.SetTableView(recContainerDetail);
                repContainerDetail.SaveAsExcel(ServerFilename);
                Clear(EmailAddMgt);
                SI.SetMergefield(100, BatchNo);
                SI.SetMergefield(101, HqInvoiceNo);
                EmailAddMgt.CreateEmailWithAttachment('HQCONTDET', '', '', ServerFilename, StrSubstNo(lText001, BatchNo), false);
                EmailAddMgt.Send();

                if SendFraightWarning then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('LOGFRAWARN', '', '');
                    EmailAddMgt.Send();
                end;

                if ItemMissingText <> '' then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateEmailWithBodytext2('LOGITEMMIS', '', ItemMissingText, '');
                    EmailAddMgt.Send();
                end;

                if SendContainerNoIsMissing then begin
                    Clear(EmailAddMgt);
                    SI.SetMergefield(100, BatchNo);
                    EmailAddMgt.CreateSimpleEmail('HQNOCONTNO', '', '');
                    EmailAddMgt.Send();
                end;
            end;

            exit(true);
        end;
    end;

    local procedure UpdatePurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; ContainerDetailRec: Record "VCK Shipping Detail")
    var
        ContainerDist: Record "Container Distances";
        PurchHeader: Record "Purchase Header";
        UnknownInCodeErr: Label '"%1" %2 is unknown in the code.';
    begin
        begin
            PurchaseLine."Qty. to Receive" := PurchaseLine."Qty. to Receive" + ContainerDetailRec.Quantity;
            if PurchaseLine."Qty. to Receive" + PurchaseLine."Quantity Received" <> PurchaseLine.Quantity then
                PurchaseLine."Vendor Status" := PurchaseLine."Vendor Status"::"Partialy Dispatched"
            else
                PurchaseLine."Vendor Status" := PurchaseLine."Vendor Status"::Dispatched;

            PurchaseLine."Actual shipment date" := ContainerDetailRec.ETD;
            PurchaseLine."Promised Receipt Date" := ContainerDetailRec.ETA;
            PurchaseLine."Planned Receipt Date" := ContainerDetailRec.ETA;
            PurchaseLine."Expected Receipt Date" := ContainerDetailRec.ETA;

            PurchHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            ContainerDist.SetFilter("Customer No.", '%1|%2', PurchHeader."Sell-to Customer No.", '');
            ContainerDist.SetFilter("Ship-to Code", '%1|%2', PurchHeader."Ship-to Code", '');
            ContainerDist.FindLast();
            case ContainerDetailRec."Shipping Method" of
                'AIR':
                    PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Air Days";
                'RAIL':
                    PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Rail Days";
                'SEA':
                    PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Sea Days";
                else
                    if ContainerDist."Other Days" > 0 then
                        PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Other Days"
                    else
                        Error(UnknownInCodeErr, ContainerDetailRec.FieldCaption("Shipping Method"), ContainerDetailRec."Shipping Method");
            end;

            PurchaseLine."Transport Method" := copystr(ContainerDetailRec."Shipping Method", 1, 10);
            PurchaseLine.Modify();
        end;
    end;

    procedure HQSalesDocument(var pHQSalesHead: Record "HQ Invoice Header" temporary; var pHQSalesLine: Record "HQ Invoice Line" temporary): Boolean
    var
        recHQSalesHead: Record "HQ Invoice Header";
        recHQSalesLine: Record "HQ Invoice Line";
        recPurchHead: Record "Purchase Header";
        BodyText: Text;
        lText001: Label 'HQ Sales Document';

    begin
        CreateWebServiceLog(lText001, '');
        if pHQSalesHead.FindSet() then
            repeat
                recHQSalesHead := pHQSalesHead;
                recHQSalesHead.Insert();

                pHQSalesLine.SetRange("Document Type", pHQSalesHead."Document Type");
                pHQSalesLine.SetRange("Document No.", pHQSalesHead."No.");
                if pHQSalesLine.FindSet() then begin
                    BodyText := '';
                    if recPurchHead.Get(recPurchHead."document type"::Order, pHQSalesLine."Purchase Order No.") then
                        if recPurchHead.IsEICard then begin
                            recHQSalesHead.Type := recHQSalesHead.Type::EiCard;
                            recHQSalesHead.Modify();
                        end;

                    repeat
                        recHQSalesLine := pHQSalesLine;
                        recHQSalesLine.Validate("Total Price");
                        if recHQSalesLine."Purchase Order Line No." = 0 then
                            recHQSalesLine."Purchase Order Line No." := GetPurchOrdLineNoEiCard(recHQSalesLine."Purchase Order No.", recHQSalesLine."No.", recHQSalesLine.Quantity);
                        recHQSalesLine.Insert();

                        if recHQSalesLine."Overhead Price" < 0 then
                            BodyText +=
                              StrSubstNo('Item No.: %1, %2: %3, %4: %5, %6: %7, %8: %9<br>',
                                recHQSalesLine."No.",
                                recHQSalesLine.FieldCaption("Document No."), recHQSalesLine."Document No.",
                                recHQSalesLine.FieldCaption("Unit Price"), recHQSalesLine."Unit Price",
                                recHQSalesLine.FieldCaption("Last Bill of Material Price"), recHQSalesLine."Last Bill of Material Price",
                                recHQSalesLine.FieldCaption("Overhead Price"), recHQSalesLine."Overhead Price");

                    until pHQSalesLine.Next() = 0;
                end;

                WebServiceLogEntry."Quantity Inserted" += 1;
            until pHQSalesHead.Next() = 0;

        CloseWebServiceLog();

        exit(true);
    end;

    procedure UpdateEMEAPurchaseOrder(var pPurchHead: Record "Purchase Header" temporary; var pPurchLine: Record "Purchase Line"): Boolean
    begin

    end;

    procedure UnshippedPurchaseOrder(var TempUnshipPurchOrder: Record "Unshipped Purchase Order"; VendorType: Enum VendorType): Boolean
    var
        recUnshipPurchder: Record "Unshipped Purchase Order";
        recPurchLine: Record "Purchase Line";
        recAutoSetup: Record "Automation Setup";
        recWhseSetup: Record "Warehouse Setup";
        lText001: Label 'Purchase Order No. must not be blank. "%1".';
        lText002: Label 'UNSHIPPEDQUANTITY';
        lText003: Label 'EMPTY';
    begin
        recAutoSetup.GET();
        recWhseSetup.GET();
        TempUnshipPurchOrder.SETCURRENTKEY("Purchase Order No.", "Purchase Order Line No.");
        TempUnshipPurchOrder.ASCENDING(FALSE);
        CreateWebServiceLog(lText002, '');
        recUnshipPurchder.SETRANGE("Vendor Type", VendorType);
        WebServiceLogEntry.Filter := CopyStr(recUnshipPurchder.GETFILTERS(), 1, 250);
        WebServiceLogEntry."Quantity Deleted" := recUnshipPurchder.COUNT();

        recUnshipPurchder.DELETEALL();


        IF TempUnshipPurchOrder.FINDSET() THEN BEGIN

            IF (TempUnshipPurchOrder."Purchase Order No." <> lText003) THEN
                REPEAT
                    IF TempUnshipPurchOrder."Purchase Order No." = '' THEN
                        ERROR(lText001, TempUnshipPurchOrder);

                    recUnshipPurchder := TempUnshipPurchOrder;
                    recUnshipPurchder."Sales Order Line ID" := StrSubstNo('%1_%2', recUnshipPurchder."Sales Order Line ID", VendorType);

                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN
                        recUnshipPurchder."Purchase Order Line No." := GetPurchaseOrderLineNo(recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Item No.", recUnshipPurchder.Quantity);

                    recUnshipPurchder."Vendor Type" := VendorType;
                    if recUnshipPurchder."ETA Date" = 0D then
                        recUnshipPurchder."ETA Date" := 20991231D;
                    recUnshipPurchder.INSERT();

                    IF FORMAT(recWhseSetup."Expected Shipment Period") <> '' THEN BEGIN
                        IF recUnshipPurchder."Shipping Order ETD Date" <> 0D THEN
                            recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."Shipping Order ETD Date")
                        ELSE
                            IF recUnshipPurchder."ETD Date" <> 0D THEN
                                recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."ETD Date")
                            ELSE
                                recUnshipPurchder."Expected receipt date" := 0D;
                        recUnshipPurchder.MODIFY(TRUE);
                    END;

                    IF recAutoSetup."Upd. Unit Price on Purch.Order" THEN
                        IF recUnshipPurchder."Unit Price" > 0 THEN
                            IF recPurchLine.GET(recPurchLine."Document Type"::Order, recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Purchase Order Line No.") THEN
                                IF (recPurchLine.Type = recPurchLine.Type::Item) AND (recPurchLine."Direct Unit Cost" <> recUnshipPurchder."Unit Price") THEN BEGIN
                                    recPurchLine.SuspendStatusCheck(TRUE);
                                    recPurchLine.VALIDATE("Direct Unit Cost", recUnshipPurchder."Unit Price");
                                    recPurchLine.MODIFY();
                                    recPurchLine.SuspendStatusCheck(FALSE);
                                END;

                    if (recUnshipPurchder."Purchase Order No." <> recPurchLine."Document No.") OR (recUnshipPurchder."Purchase Order Line No." <> recPurchLine."Line No.") then
                        IF recPurchLine.GET(recPurchLine."Document Type"::Order, recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Purchase Order Line No.") THEN begin
                            recUnshipPurchder."Location Code" := recPurchLine."Location Code";
                            recUnshipPurchder.Modify(true);
                        end;

                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN
                        IF ServerEnvironment.ProductionEnvironment() THEN BEGIN
                            Clear(EmailAddMgt);
                            Clear(SI);
                            SI.SetMergefield(100, TempUnshipPurchOrder."Purchase Order No.");
                            SI.SetMergefield(101, FORMAT(VendorType));
                            SI.SetMergefield(102, FORMAT(TempUnshipPurchOrder.Quantity));
                            SI.SetMergefield(103, TempUnshipPurchOrder."Item No.");
                            EmailAddMgt.CreateSimpleEmail('HQUNSHQTY', '', '');
                            EmailAddMgt.Send();
                        END;

                    WebServiceLogEntry."Quantity Inserted" += 1;
                UNTIL TempUnshipPurchOrder.NEXT() = 0;
            CloseWebServiceLog();

        END;
        EXIT(TRUE);
    end;

    procedure OLDUnshippedPurchaseOrder(var TempPurchaseLine: Record "Purchase Line" temporary; VendorType: Enum VendorType): Boolean
    var
        recUnshipPurchder: Record "Unshipped Purchase Order";
        recPurchLine: Record "Purchase Line";
        recAutoSetup: Record "Automation Setup";
        recWhseSetup: Record "Warehouse Setup";
        lText001: Label 'Purchase Order No. must not be blank. "%1".';
        lText002: Label 'UNSHIPPEDQUANTITY';
        lText003: Label 'EMPTY';

    begin
        recAutoSetup.GET();
        recWhseSetup.GET();
        TempPurchaseLine.SETCURRENTKEY("Document No.", "Line No.");
        TempPurchaseLine.ASCENDING(FALSE);
        IF TempPurchaseLine.FINDSET() THEN BEGIN
            CreateWebServiceLog(lText002, '');
            recUnshipPurchder.SETRANGE("Vendor Type", VendorType);
            WebServiceLogEntry.Filter := copystr(recUnshipPurchder.GETFILTERS(), 1, 250);
            WebServiceLogEntry."Quantity Deleted" := recUnshipPurchder.COUNT();

            recUnshipPurchder.DELETEALL();
            IF (TempPurchaseLine."Document No." <> lText003) THEN
                REPEAT
                    IF TempPurchaseLine."Document No." = '' THEN
                        ERROR(lText001, TempPurchaseLine);

                    //recUnshipPurchder := TempPurchaseLine;
                    recUnshipPurchder."Sales Order Line ID" := TempPurchaseLine."Sales Order Line ID";
                    recUnshipPurchder."Item No." := TempPurchaseLine."No.";
                    recUnshipPurchder."Purchase Order No." := TempPurchaseLine."Document No.";
                    recUnshipPurchder."Purchase Order Line No." := TempPurchaseLine."Line No.";
                    recUnshipPurchder."ETA Date" := TempPurchaseLine.ETA;
                    recUnshipPurchder."ETD Date" := TempPurchaseLine."ETD Date";
                    recUnshipPurchder."Shipping Order ETD Date" := TempPurchaseLine."Planned Receipt Date";
                    recUnshipPurchder."Expected Receipt Date" := TempPurchaseLine."Expected Receipt Date";
                    recUnshipPurchder.Quantity := TempPurchaseLine.Quantity;
                    recUnshipPurchder."Unit Price" := TempPurchaseLine."Direct Unit Cost";

                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN
                        recUnshipPurchder."Purchase Order Line No." := GetPurchaseOrderLineNo(recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Item No.", recUnshipPurchder.Quantity);

                    recUnshipPurchder."Vendor Type" := VendorType;
                    recUnshipPurchder.INSERT(true);

                    IF FORMAT(recWhseSetup."Expected Shipment Period") <> '' THEN BEGIN
                        IF recUnshipPurchder."Shipping Order ETD Date" <> 0D THEN
                            recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."Shipping Order ETD Date")
                        ELSE
                            IF recUnshipPurchder."ETD Date" <> 0D THEN
                                recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."ETD Date")
                            ELSE
                                recUnshipPurchder."Expected receipt date" := 0D;
                        recUnshipPurchder.MODIFY(TRUE);
                    END;

                    IF recAutoSetup."Upd. Unit Price on Purch.Order" THEN
                        IF recUnshipPurchder."Unit Price" > 0 THEN
                            IF recPurchLine.GET(recPurchLine."Document Type"::Order, recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Purchase Order Line No.") THEN
                                IF (recPurchLine.Type = recPurchLine.Type::Item) AND (recPurchLine."Direct Unit Cost" <> recUnshipPurchder."Unit Price") THEN BEGIN
                                    recPurchLine.SuspendStatusCheck(TRUE);
                                    recPurchLine.VALIDATE("Direct Unit Cost", recUnshipPurchder."Unit Price");
                                    recPurchLine.MODIFY();
                                    recPurchLine.SuspendStatusCheck(FALSE);
                                END;

                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN
                        IF ServerEnvironment.ProductionEnvironment() THEN BEGIN
                            Clear(EmailAddMgt);
                            Clear(SI);
                            SI.SetMergefield(100, TempPurchaseLine."Document No.");
                            SI.SetMergefield(101, FORMAT(VendorType));
                            SI.SetMergefield(102, FORMAT(TempPurchaseLine.Quantity));
                            SI.SetMergefield(103, TempPurchaseLine."No.");
                            EmailAddMgt.CreateSimpleEmail('HQUNSHQTY', '', '');
                            EmailAddMgt.Send();
                        END;

                    WebServiceLogEntry."Quantity Inserted" += 1;
                UNTIL TempPurchaseLine.NEXT() = 0;
            CloseWebServiceLog();

            EXIT(TRUE);
        END;
    end;

    procedure EiCardLinks(var recEicardQueueTmp: Record "EiCard Queue" temporary; var recEiCardLinkLineTmp: Record "EiCard Link Line" temporary): Boolean
    var
        recEiCardLinkLine: Record "EiCard Link Line";
        recEiCardLinkLine2: Record "EiCard Link Line";
        recPurchLine: Record "Purchase Line";
        recPurchLineTmp: Record "Purchase Line" temporary;
        recEiCardQueue: Record "EiCard Queue";
        LiNo: Integer;
        lText002: Label 'eCommerce';
        lText001: Label 'EiCard Links';
        LineNoInserted: Boolean;
    begin
        CreateWebServiceLog(lText001, '');
        //IF recEiCardLinkHeadTmp.FINDSET THEN BEGIN 
        if recEicardQueueTmp.FindSet() then begin
            recEiCardQueue.LockTable();
            recEiCardLinkLine.LockTable();
            recEiCardLinkLine.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Line No.");
            repeat
                recEiCardQueue.SetRange("Purchase Order No.", recEicardQueueTmp."Purchase Order No.");
                if recEiCardQueue.FindFirst() then begin
                    recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::"EiCard Order Accepted");
                    recEiCardQueue.Modify(true);
                end;

                recEiCardLinkLineTmp.SetRange("Purchase Order No.", recEicardQueueTmp."Purchase Order No.");
                if recEiCardLinkLineTmp.FindSet() then begin
                    recPurchLineTmp.DeleteAll();
                    repeat
                        recEiCardLinkLine := recEiCardLinkLineTmp;
                        recEiCardLinkLine.UID := 0;

                        recPurchLine.Reset();
                        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                        recPurchLine.SetRange("Document No.", recEiCardLinkLine."Purchase Order No.");
                        recPurchLine.SetRange("No.", recEiCardLinkLine."Item No.");
                        if recPurchLine.FindFirst() then begin

                            LineNoInserted := false;
                            repeat
                                if not recPurchLineTmp.Get(recPurchLine."Document Type", recPurchLine."Document No.", recPurchLine."Line No.") then begin
                                    recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";
                                    recPurchLineTmp := recPurchLine;
                                    if not recPurchLineTmp.Insert() then;
                                    LineNoInserted := true;
                                end;
                            until (recPurchLine.Next() = 0) or LineNoInserted;
                        end;

                        recEiCardLinkLine2.SetRange("Purchase Order No.", recEiCardLinkLine."Purchase Order No.");
                        recEiCardLinkLine2.SetRange("Purchase Order Line No.", recEiCardLinkLine."Purchase Order Line No.");
                        if recEiCardLinkLine2.FindLast() then
                            recEiCardLinkLine."Line No." := recEiCardLinkLine2."Line No." + 1
                        else
                            recEiCardLinkLine."Line No." := 1;
                        recEiCardLinkLine.Insert(true);

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    until recEiCardLinkLineTmp.Next() = 0;
                end else
                    if recEiCardQueue."Eicard Type" = recEiCardQueue."eicard type"::eCommerce then begin
                        recPurchLine.Reset();
                        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                        recPurchLine.SetRange("Document No.", recEiCardQueue."Purchase Order No.");
                        if recPurchLine.FindSet() then
                            repeat
                                LiNo += 1;

                                Clear(recEiCardLinkLine);
                                recEiCardLinkLine."Purchase Order No." := recPurchLine."Document No.";
                                recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";
                                recEiCardLinkLine."Item No." := recPurchLine."No.";
                                recEiCardLinkLine."Line No." := LiNo;
                                recEiCardLinkLine.Quantity := recPurchLine.Quantity;
                                recEiCardLinkLine.Link := lText002;
                                recEiCardLinkLine.Insert(true);
                            until recPurchLine.Next() = 0;

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    end;
            until recEicardQueueTmp.Next() = 0;
        end;

        CloseWebServiceLog();

        exit(true);
    end;

    procedure EiCardRejections(var recEiCardQueueTmp: Record "EiCard Queue" temporary; var recEiCardLinkLineTmp: Record "EiCard Link Line" temporary): Boolean
    var
        recEiCardLinkLine: Record "EiCard Link Line";
        recEiCardLinkLine2: Record "EiCard Link Line";
        recPurchLine: Record "Purchase Line";
        lText001: Label 'EiCard Links';

    begin
        CreateWebServiceLog(lText001, '');
        if recEiCardQueueTmp.FindSet() then begin
            recEiCardLinkLine.LockTable();
            recEiCardLinkLine.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Line No.");
            repeat
                recEiCardLinkLineTmp.SetRange("Purchase Order No.", recEiCardQueueTmp."Purchase Order No.");
                if recEiCardLinkLineTmp.FindSet() then
                    repeat
                        recEiCardLinkLine := recEiCardLinkLineTmp;
                        recEiCardLinkLine.UID := 0;

                        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                        recPurchLine.SetRange("Document No.", recEiCardLinkLine."Purchase Order No.");
                        recPurchLine.SetRange("No.", recEiCardLinkLine."Item No.");
                        if recPurchLine.FindFirst() then
                            recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";

                        recEiCardLinkLine2.SetRange("Purchase Order No.", recEiCardLinkLine."Purchase Order No.");
                        recEiCardLinkLine2.SetRange("Purchase Order Line No.", recEiCardLinkLine."Purchase Order Line No.");
                        if recEiCardLinkLine2.FindLast() then
                            recEiCardLinkLine."Line No." := recEiCardLinkLine2."Line No." + 1
                        else
                            recEiCardLinkLine."Line No." := 1;
                        recEiCardLinkLine.Insert(true);

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    until recEiCardLinkLineTmp.Next() = 0;
            until recEiCardQueueTmp.Next() = 0;
        end;
        CloseWebServiceLog();
        exit(true);
    end;

    procedure PurchasePrice(var recPurchPriceTmp: Record "Price List Line" temporary) rValue: Boolean
    var
        PriceListHeader: Record "Price List Header";
        recPurchPrice: Record "Price List Line";
        recVend: Record Vendor;
        recItem: Record Item;
        PriceListManagement: Codeunit "Price List Management";
        lText001: Label 'Purchase Price';
    begin
        CreateWebServiceLog(lText001, '');
        if recPurchPriceTmp.FindSet() then
            repeat
                if recVend.Get(recPurchPriceTmp."Source No.") and recItem.Get(recPurchPriceTmp."Asset No.") then begin
                    recPurchPrice.SetRange("Asset No.", recPurchPriceTmp."Asset No.");
                    recPurchPrice.SetRange("Source No.", recPurchPriceTmp."Source No.");
                    recPurchPrice.SetRange("Starting Date", recPurchPriceTmp."Starting Date");
                    recPurchPrice.SetRange("Currency Code", recPurchPriceTmp."Currency Code");
                    recPurchPrice.SetRange("Variant Code", recPurchPriceTmp."Variant Code");
                    recPurchPrice.SetRange("Unit of Measure Code", recPurchPriceTmp."Unit of Measure Code");
                    if recPurchPriceTmp."Minimum Quantity" in [0, 1] then
                        recPurchPrice.SetRange("Minimum Quantity", 0, 1)
                    else
                        recPurchPrice.SetRange("Minimum Quantity", recPurchPriceTmp."Minimum Quantity");
                    if recPurchPrice.FindLast() then begin
                        if recPurchPrice."Direct Unit Cost" <> recPurchPriceTmp."Direct Unit Cost" then begin
                            recPurchPrice.Validate("Direct Unit Cost", recPurchPriceTmp."Direct Unit Cost");
                            if (not recItem.IsEICard) and (not recItem."Non ZyXEL License") then
                                recPurchPrice."New Price" := true;

                            WebServiceLogEntry."Quantity Modified" += 1;
                            recPurchPrice.Modify(true);
                        end;
                    end else begin
                        recPurchPrice := recPurchPriceTmp;
                        recPurchPrice.SetNextLineNo();
                        if recItem.IsEICard or recItem."Non ZyXEL License" then
                            recPurchPrice."New Price" := false;
                        recPurchPrice.Insert(true);

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    end;

                    if PriceListHeader.Get(recPurchPrice."Price List Code") then
                        PriceListManagement.ActivateDraftLines(PriceListHeader);

                    rValue := true;
                end;
            until recPurchPriceTmp.Next() = 0;
        CloseWebServiceLog();
        exit(true);
    end;

    procedure PurchaseOrderLine(var recPurchLineTmp: Record "Purchase Line" temporary) rValue: Boolean
    var
        recPurchLine: Record "Purchase Line";
        lText001: Label 'Purchase Price Order';
    begin
        CreateWebServiceLog(lText001, '');
        if recPurchLineTmp.FindSet() then
            repeat
                if recPurchLine.Get(recPurchLine."document type"::Order, recPurchLineTmp."Document No.", recPurchLineTmp."Line No.") then
                    //06-08-2025 BK #From HQ John and Steven
                    //If NOT FindDNNumber(recPurchLine) then begin
                        recPurchLine.SuspendStatusCheck(true);
                recPurchLine.Validate("Direct Unit Cost", recPurchLineTmp."Direct Unit Cost");
                recPurchLine.Modify(true);
                recPurchLine.SuspendStatusCheck(false);

                WebServiceLogEntry."Quantity Inserted" += 1;
            //end;
            until recPurchLineTmp.Next() = 0;
        CloseWebServiceLog();
        rValue := true;
    end;

    procedure FindDNNumber(recPurchLine: Record "Purchase Line"): Boolean
    var
        UnshippedPurchOrder: Record "Unshipped Purchase Order";
    Begin
        UnshippedPurchOrder.SetRange("Purchase Order No.", recPurchLine."Document No.");
        UnshippedPurchOrder.SetRange("Purchase Order Line No.", recPurchLine."Line No.");
        if UnshippedPurchOrder.FindFirst() then
            IF UnshippedPurchOrder."DN Number" <> '' then
                exit(true);
        exit(false);
    End;

    procedure SalesPrice(var recSalesPriceTmp: Record "Price List Line" temporary) rValue: Boolean
    var
        PriceListHeader: Record "Price List Header";
        recSalesPrice: Record "Price List Line";
        recCust: Record Customer;
        recCustPriceGrp: Record "Customer Price Group";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        PriceListManagement: Codeunit "Price List Management";
    begin
        if recSalesPriceTmp.FindSet() then
            repeat
                if ((recSalesPriceTmp."Source Type" = recSalesPriceTmp."Source type"::Customer) and recCust.Get(recSalesPriceTmp."Source No.")) or
                   ((recSalesPriceTmp."Source Type" = recSalesPriceTmp."Source type"::"Customer Price Group") and recCustPriceGrp.Get(recSalesPriceTmp."Source No."))
                then begin
                    recSalesPrice.SetRange("Asset Type", recSalesPriceTmp."Asset Type");
                    recSalesPrice.SetRange("Asset No.", recSalesPriceTmp."Asset No.");
                    recSalesPrice.SetRange("Source Type", recSalesPriceTmp."Source Type");
                    recSalesPrice.SetRange("Source No.", recSalesPriceTmp."Source No.");
                    recSalesPrice.SetRange("Starting Date", recSalesPriceTmp."Starting Date");
                    recSalesPrice.SetRange("Currency Code", recSalesPriceTmp."Currency Code");
                    recSalesPrice.SetRange("Variant Code", recSalesPriceTmp."Variant Code");
                    recSalesPrice.SetRange("Unit of Measure Code", recSalesPriceTmp."Unit of Measure Code");
                    if recSalesPriceTmp."Minimum Quantity" in [0, 1] then
                        recSalesPrice.SetRange("Minimum Quantity", 0, 1)
                    else
                        recSalesPrice.SetRange("Minimum Quantity", recSalesPriceTmp."Minimum Quantity");
                    if recSalesPrice.FindLast() then begin
                        if recSalesPrice."Unit Price" <> recSalesPriceTmp."Unit Price" then begin
                            recSalesPrice.Validate("Unit Price", recSalesPriceTmp."Unit Price");
                            recSalesPrice.Modify(true);
                        end;
                        ItemLogisticEvent.UpdateSalesPriceEndDate(recSalesPrice);
                    end else begin
                        recSalesPrice := recSalesPriceTmp;
                        recSalesPrice.Insert(true);
                        ItemLogisticEvent.UpdateSalesPriceEndDate(recSalesPrice);
                    end;

                    if PriceListHeader.Get(recSalesPrice."Price List Code") then
                        PriceListManagement.ActivateDraftLines(PriceListHeader);

                    rValue := true;
                end;
            until recSalesPriceTmp.Next() = 0;
    end;

    procedure BatteryCertificate(var pBatCertTmp: Record "Battery Certificate" temporary): Boolean
    var
        recBatCert: Record "Battery Certificate";
        lText001: Label 'Battery Certificate';
    begin
        CreateWebServiceLog(lText001, '');
        if pBatCertTmp.FindSet() then
            repeat
                recBatCert := pBatCertTmp;
                recBatCert."Entry No." := 0;
                recBatCert.Insert(true);

                WebServiceLogEntry."Quantity Inserted" += 1;
            until pBatCertTmp.Next() = 0;

        CloseWebServiceLog();
        exit(true);
    end;

    procedure CurrencyExchangeRate(var pCurrExchRate: Record "Currency Exchange Rate" temporary): Boolean
    var
        recCurrExchRate: Record "Currency Exchange Rate";
        recCurrExchRate2: Record "Currency Exchange Rate";
        recCurrency: Record Currency;
        ReplicateExchangeRate: Codeunit "Replicate Exchange Rate";
        lText001: Label 'Exchange rate %1 is not setup to be updated via the web service.';

    begin
        if pCurrExchRate.FindSet() then
            repeat
                if recCurrency.Get(pCurrExchRate."Currency Code") and not recCurrency."Update via HQ Web Service" then
                    Error(lText001, pCurrExchRate."Currency Code");

                if format(recCurrency."Start Date Calculation HQ") <> '' then
                    pCurrExchRate."Starting Date" := CalcDate(recCurrency."Start Date Calculation HQ", pCurrExchRate."Starting Date");

                if recCurrExchRate.Get(pCurrExchRate."Currency Code", pCurrExchRate."Starting Date") then begin
                    recCurrExchRate.Validate("Exchange Rate Amount", pCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Validate("Adjustment Exch. Rate Amount", recCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Modify(true);
                end else begin
                    recCurrExchRate.Init();
                    recCurrExchRate.Validate("Currency Code", pCurrExchRate."Currency Code");
                    recCurrExchRate.Validate("Starting Date", pCurrExchRate."Starting Date");
                    recCurrExchRate.Validate("Exchange Rate Amount", pCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Validate("Adjustment Exch. Rate Amount", recCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Validate("Relational Exch. Rate Amount", 1);
                    recCurrExchRate.Validate("Relational Adjmt Exch Rate Amt", recCurrExchRate."Relational Exch. Rate Amount");
                    recCurrExchRate.Insert(true);
                end;

                recCurrExchRate2.SetRange("Currency Code", recCurrExchRate."Currency Code");
                recCurrExchRate2.SetRange("Starting Date", CalcDate('<1M>', recCurrExchRate."Starting Date"));
                if recCurrExchRate2.FindFirst() then
                    recCurrExchRate2.Delete(true);

                Commit();
                ReplicateExchangeRate.Run();

                // Due to Precision Point we need next month´s exchange rate
                if recCurrency."Copy Last Months Exch. Rate" then begin
                    recCurrExchRate.Validate("Starting Date", CalcDate('<1M>', recCurrExchRate."Starting Date"));
                    if not recCurrExchRate.Insert(true) then
                        recCurrExchRate.Modify(true);

                    Commit();
                    ReplicateExchangeRate.Run();
                end;
            until pCurrExchRate.Next() = 0;

        exit(true);
    end;

    procedure eCommerceOrder(var pAmzHeadTmp: Record "eCommerce Order Header" temporary; var pAmzLineTmp: Record "eCommerce Order Line" temporary): Boolean
    var
        recAmzHead: Record "eCommerce Order Header";
        recAmzLine: Record "eCommerce Order Line";
        recAmzMktPlace: Record "eCommerce Market Place";
        recWebSerLogEntry: Record "Web Service Log Entry";
        recAmzCountryMap: Record "eCommerce Country Mapping";
        NewLineNo: Integer;
        lText002: Label 'eCommerce Order';
    begin
        if pAmzHeadTmp.FindSet() then begin
            CreateWebServiceLog(lText002, '');

            repeat
                if recAmzMktPlace."Market Place Name" <> pAmzHeadTmp."Marketplace ID" then begin
                    recAmzMktPlace.SetRange("Market Place Name", pAmzHeadTmp."Marketplace ID");
                    recAmzMktPlace.FindFirst()
                end;
                recAmzMktPlace.TestField("VAT Prod. Posting Group");

                if not recAmzCountryMap.Get(recAmzMktPlace."Customer No.", pAmzHeadTmp."Ship To Country") then
                    recAmzCountryMap.InsertCountryMapping(copystr(recAmzMktPlace."Marketplace ID", 1, 10), pAmzHeadTmp."Ship To Country");

                Clear(recAmzHead);
                recAmzHead.Init();
                recAmzHead.SetVatProdPostingGroup(CopyStr(recAmzMktPlace."VAT Prod. Posting Group", 1, 10));
                recAmzHead.Validate("eCommerce Order Id", pAmzHeadTmp."eCommerce Order Id");
                recAmzHead.Validate("Invoice No.", pAmzHeadTmp."Invoice No.");
                recAmzHead.Validate("Marketplace ID", recAmzMktPlace."Marketplace ID");
                recAmzHead.Validate("Purchaser VAT No.", pAmzHeadTmp."Purchaser VAT No.");
                recAmzHead.Validate("Export Outside EU", pAmzHeadTmp."Export Outside EU");
                recAmzHead.Validate("Transaction Type", pAmzHeadTmp."Transaction Type");
                recAmzHead.Validate("Tax Type", pAmzHeadTmp."Tax Type");
                recAmzHead.Validate("Tax Calculation Reason Code", pAmzHeadTmp."Tax Calculation Reason Code");
                recAmzHead.Validate("Tax Address Role", pAmzHeadTmp."Tax Address Role");
                recAmzHead.Validate("Buyer Tax Reg. Country", pAmzHeadTmp."Buyer Tax Reg. Country");
                recAmzHead.Validate("Tax Rate", pAmzHeadTmp."Tax Rate");

                recAmzHead.Validate("Transaction ID", pAmzHeadTmp."Transaction ID");
                recAmzHead.Validate("Shipment ID", pAmzHeadTmp."Shipment ID");
                recAmzHead.Validate("Order Date", pAmzHeadTmp."Order Date");
                recAmzHead.Validate("Shipment Date", pAmzHeadTmp."Shipment Date");
                recAmzHead.Validate("Invoice No.", pAmzHeadTmp."Invoice No.");
                recAmzHead.Validate("Ship To City", pAmzHeadTmp."Ship To City");
                recAmzHead.Validate("Ship To State", pAmzHeadTmp."Ship To State");
                recAmzHead.Validate("Ship To Country", pAmzHeadTmp."Ship To Country");
                recAmzHead.Validate("Ship To Postal Code", pAmzHeadTmp."Ship To Postal Code");
                recAmzHead.Validate("Ship From City", pAmzHeadTmp."Ship From City");
                recAmzHead.Validate("Ship From State", pAmzHeadTmp."Ship From State");
                recAmzHead.Validate("Ship From Country", pAmzHeadTmp."Ship From Country");
                recAmzHead.Validate("Ship From Postal Code", pAmzHeadTmp."Ship From Postal Code");
                recAmzHead.Validate("Ship From Tax Location Code", pAmzHeadTmp."Ship From Tax Location Code");
                recAmzHead.Validate("VAT Registration No. Zyxel", pAmzHeadTmp."VAT Registration No. Zyxel");
                recAmzHead.Validate("Currency Code", pAmzHeadTmp."Currency Code");
                recAmzHead.Insert(true);

                NewLineNo := 0;
                pAmzLineTmp.SetRange("eCommerce Order Id", pAmzHeadTmp."eCommerce Order Id");
                pAmzLineTmp.SetRange("Invoice No.", pAmzHeadTmp."Invoice No.");
                if pAmzLineTmp.FindSet() then
                    repeat
                        NewLineNo += 10000;
                        Clear(recAmzLine);
                        recAmzLine.Init();

                        recAmzLine.Validate("Transaction Type", recAmzHead."Transaction Type");
                        recAmzLine.Validate("eCommerce Order Id", recAmzHead."eCommerce Order Id");
                        recAmzLine.Validate("Invoice No.", recAmzHead."Invoice No.");
                        recAmzLine.Validate("Line No.", NewLineNo);
                        recAmzLine.Validate("Item No.", pAmzLineTmp."Item No.");
                        recAmzLine.Validate(Quantity, pAmzLineTmp.Quantity);
                        recAmzLine.Validate("VAT Prod. Posting Group", recAmzMktPlace."VAT Prod. Posting Group");
                        recAmzLine.Validate("Item Price (Exc. Tax)", pAmzLineTmp."Item Price (Exc. Tax)");
                        recAmzLine.Validate("Item Price (Inc. Tax)", pAmzLineTmp."Item Price (Inc. Tax)");
                        recAmzLine.Validate("Total (Exc. Tax)", pAmzLineTmp."Total (Exc. Tax)");
                        recAmzLine.Validate("Total (Inc. Tax)", pAmzLineTmp."Total (Inc. Tax)");
                        recAmzLine.Validate("Total Tax Amount", pAmzLineTmp."Total Tax Amount");
                        recAmzLine.Validate("Line Discount Pct.", pAmzLineTmp."Line Discount Pct.");
                        recAmzLine.Validate("Line Discount Excl. Tax", pAmzLineTmp."Line Discount Excl. Tax");
                        recAmzLine.Validate("Line Discount Incl. Tax", pAmzLineTmp."Line Discount Incl. Tax");
                        recAmzLine.VALIDATE("Line Discount Tax Amount", pAmzLineTmp."Line Discount Tax Amount");
                        recAmzLine.Validate(Amount);
                        recAmzLine.Insert(true);
                    until pAmzLineTmp.Next() = 0;

                recAmzHead."Completely Imported" := true;
                recAmzHead.ValidateDocument();
                recAmzHead.Modify(true);
                recWebSerLogEntry."Quantity Inserted" += 1;
            until pAmzHeadTmp.Next() = 0;

            CloseWebServiceLog();
            exit(true);
        end;
    end;

    procedure eCommercePayment(var pAmzHeadTmp: Record "eCommerce Payment Header" temporary; var pAmzLineTmp: Record "eCommerce Payment" temporary): Boolean
    var
        recAmzHead: Record "eCommerce Payment Header";
        recAmzLine: Record "eCommerce Payment";
        recWebSerLogEntry: Record "Web Service Log Entry";
        NewLineNo: Integer;
        lText002: Label 'eCommerce Payment';
    begin
        if pAmzHeadTmp.FindSet() then begin
            CreateWebServiceLog(lText002, '');

            pAmzLineTmp.FindFirst();

            if recAmzLine.FindLast() then
                NewLineNo := recAmzLine.UID;

            repeat
                if pAmzLineTmp.FindSet() then
                    repeat
                        NewLineNo += 1;

                        recAmzHead.SetRange("Market Place ID", UPPERCASE(pAmzLineTmp."eCommerce Market Place"));
                        recAmzHead.SetRange(Date, CalcDate('<-CM>', TODAY), CalcDate('<CM>', TODAY));
                        recAmzHead.SetRange("Currency Code", pAmzLineTmp."Currency Code");
                        recAmzHead.SetRange(Open, true);
                        if not recAmzHead.FindFirst() then begin
                            recAmzHead.Init();
                            recAmzHead.Date := pAmzHeadTmp.Date;
                            recAmzHead."Market Place ID" := CopyStr(UPPERCASE(pAmzLineTmp."eCommerce Market Place"), 1, 20);
                            recAmzHead."Currency Code" := pAmzLineTmp."Currency Code";
                            recAmzHead."Transaction Summary" := StrSubstNo('%1: %2..', UPPERCASE(pAmzLineTmp."eCommerce Market Place"), TODAY);
                            recAmzHead.Period := copystr(recAmzHead."Transaction Summary", 1, 50);
                            recAmzHead.Insert(true);
                        end;

                        Clear(recAmzLine);
                        recAmzLine.Init();
                        recAmzLine.Validate(UID, NewLineNo);
                        recAmzLine.Validate("Journal Batch No.", recAmzHead."No.");
                        recAmzLine.Validate(Date, recAmzLine.Date);
                        recAmzLine.Validate("Order ID", pAmzLineTmp."Order ID");
                        recAmzLine.Validate("eCommerce Invoice No.", pAmzLineTmp."eCommerce Invoice No.");
                        recAmzLine.Validate("New Transaction Type", pAmzLineTmp."New Transaction Type");
                        recAmzLine.Validate("Amount Type", pAmzLineTmp."Amount Type");
                        recAmzLine.Validate("Amount Description", pAmzLineTmp."Amount Description");
                        recAmzLine.Validate("Currency Code", pAmzLineTmp."Currency Code");
                        recAmzLine.Validate(Amount, pAmzLineTmp.Amount);
                        recAmzLine.Insert(true);
                        recWebSerLogEntry."Quantity Inserted" += 1;
                    until pAmzLineTmp.Next() = 0;
            until pAmzHeadTmp.Next() = 0;

            CloseWebServiceLog();
            exit(true);
        end;
    end;

    procedure eRMADeliveryNote(pDelNoteHeadTmp: Record "Sales Shipment Header" temporary; pDelNoteLineTmp: Record "Sales Shipment Line" temporary): Boolean
    begin
        if pDelNoteHeadTmp.FindSet() then
            repeat
                // Insert Header here.

                pDelNoteLineTmp.SetRange("Document No.", pDelNoteHeadTmp."No.");
                if pDelNoteLineTmp.FindSet() then
                    repeat
                    // Insert Lines Here
                    until pDelNoteLineTmp.Next() = 0;
            until pDelNoteHeadTmp.Next() = 0;
        exit(true);
    end;

    procedure CreateSalesOrder(var recSalesHeadTmp: Record "Sales Header" temporary; var recSalesLineTmp: Record "Sales Line" temporary) rValue: Boolean
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesSetup: Record "Sales & Receivables Setup";
        recShipToAdd: Record "Ship-to Address";
        LiNo: Integer;
        lText001: Label 'Sales Order';
    begin
        if recSalesHeadTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');

            recSalesHead.LockTable();
            recSalesLine.LockTable();
            repeat
                Clear(recSalesHead);
                recSalesHead.Init();
                recSalesHead."Document Type" := recSalesHead."document type"::Order;
                recSalesSetup.Get();
                if recSalesHeadTmp."Location Code" = recSalesSetup."All-In Logistics Location" then
                    recSalesHead."Sales Order Type" := recSalesHead."sales order type"::Normal
                else
                    recSalesHead."Sales Order Type" := recSalesHead."sales order type"::EICard;
                recSalesHead.Insert(true);

                recSalesHead.Validate("Sell-to Customer No.", recSalesHeadTmp."Sell-to Customer No.");
                recSalesHead.Validate("Location Code", recSalesHeadTmp."Location Code");
                recSalesHead.Validate("External Document No.", recSalesHeadTmp."External Document No.");

                if (recSalesHeadTmp."Ship-to Name" <> '') and (recSalesHeadTmp."Ship-to Address" <> '') then begin
                    recShipToAdd.Reset();
                    recShipToAdd.SetRange("Customer No.", recSalesHead."Sell-to Customer No.");
                    recShipToAdd.SetRange(Address, recSalesHeadTmp."Ship-to Address");
                    recShipToAdd.SetRange("Post Code", recSalesHeadTmp."Ship-to Post Code");
                    recShipToAdd.SetRange("Country/Region Code", recSalesHeadTmp."Ship-to Country/Region Code");
                    if recShipToAdd.FindFirst() then
                        recSalesHead.Validate("Ship-to Code", recShipToAdd.Code)
                    else begin
                        recSalesHead."Ship-to Name" := recSalesHeadTmp."Ship-to Name";
                        recSalesHead."Ship-to Address" := recSalesHeadTmp."Ship-to Address";
                        recSalesHead."Ship-to Post Code" := recSalesHeadTmp."Ship-to Post Code";
                        recSalesHead."Ship-to City" := recSalesHeadTmp."Ship-to City";
                        recSalesHead."Ship-to Country/Region Code" := recSalesHeadTmp."Ship-to Country/Region Code";
                    end;
                end;
                recSalesHead.Modify(true);

                recSalesLineTmp.SetRange("Document Type", recSalesHeadTmp."Document Type");
                recSalesLineTmp.SetRange("Document No.", recSalesHeadTmp."No.");
                if recSalesLineTmp.FindSet() then
                    repeat
                        LiNo += 10000;
                        Clear(recSalesLine);
                        recSalesLine.Init();
                        recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                        recSalesLine.Validate("Document No.", recSalesHead."No.");
                        recSalesLine.Validate("Line No.", LiNo);
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        recSalesLine.Validate("No.", recSalesLineTmp."No.");
                        recSalesLine.Validate(Quantity, recSalesLineTmp.Quantity);
                        recSalesLine.Validate("Unit of Measure Code", recSalesLineTmp."Unit of Measure Code");
                        recSalesLine.Validate("Unit Price", recSalesLineTmp."Unit Price");
                        recSalesLine.Insert(true);
                    until recSalesLineTmp.Next() = 0;

                WebServiceLogEntry."Quantity Inserted" += 1;
            until recSalesHeadTmp.Next() = 0;

            rValue := true;
            CloseWebServiceLog();
        end;
    end;

    local procedure CreateWebServiceLog(FunctionName: Text; FilterText: Text)
    begin
        Clear(WebServiceLogEntry);
        WebServiceLogEntry.LockTable();
        WebServiceLogEntry."Web Service Name" := 'HQWEBSERVICE';
        WebServiceLogEntry."Web Service Function" := CopyStr(FunctionName, 1, MaxStrLen(WebServiceLogEntry."Web Service Function"));
        WebServiceLogEntry.filter := CopyStr(FilterText, 1, MaxStrLen(WebServiceLogEntry.filter));
        WebServiceLogEntry."Start Time" := CurrentDateTime();
        WebServiceLogEntry."User ID" := copystr(UserId(), 1, 100);
        WebServiceLogEntry.Insert();
    end;

    local procedure CloseWebServiceLog()
    begin
        WebServiceLogEntry."End Time" := CurrentDatetime();
        WebServiceLogEntry.Modify();
    end;

    local procedure GetPurchaseOrderLineNo(OrderNo: Code[20]; ItemNo: Code[20]; Quantity: Integer): Integer
    var
        PurchLine: Record "Purchase Line";
        ContDetail: Record "VCK Shipping Detail";

    begin
        PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
        PurchLine.SetRange("Document No.", OrderNo);
        PurchLine.SetRange("No.", ItemNo);
        if PurchLine.Count() = 1 then begin
            if PurchLine.FindFirst() then
                exit(PurchLine."Line No.");
        end else
            if PurchLine.FindSet() then
                repeat
                    ContDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.");
                    ContDetail.SetRange("Purchase Order No.", PurchLine."Document No.");
                    ContDetail.SetRange("Purchase Order Line No.", PurchLine."Line No.");
                    ContDetail.SetRange(Archive, false);
                    ContDetail.CalcSums(Quantity);

                    if Quantity <= PurchLine."Outstanding Quantity" - ContDetail.Quantity then
                        exit(PurchLine."Line No.");
                until PurchLine.Next() = 0;
    end;

    local procedure GetPurchOrdLineNoEiCard(pOrderNo: Code[20]; pItemNo: Code[20]; pQuantity: Integer): Integer
    var
        recPurchLine: Record "Purchase Line";
        recHQInvLine: Record "HQ Invoice Line";

    begin
        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
        recPurchLine.SetRange("Document No.", pOrderNo);
        recPurchLine.SetRange("No.", pItemNo);
        recPurchLine.SetRange(Quantity, pQuantity);
        if recPurchLine.Count = 1 then begin
            if recPurchLine.FindFirst() then
                exit(recPurchLine."Line No.");
        end else
            if recPurchLine.FindSet() then
                repeat
                    recHQInvLine.SetRange("Document Type", recHQInvLine."document type"::Invoice);
                    recHQInvLine.SetRange("Purchase Order No.", recPurchLine."Document No.");
                    recHQInvLine.SetRange("Purchase Order Line No.", recPurchLine."Line No.");
                    if not recHQInvLine.FindFirst() then
                        exit(recPurchLine."Line No.");
                until recPurchLine.Next() = 0;
    end;
}
