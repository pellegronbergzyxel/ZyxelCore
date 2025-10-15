codeunit 50089 "Post Ship Response Mgt."
{
    //04-0-2025 BK #526633 - Copystr to avoid error of long error texts
    trigger OnRun()
    begin
        DownloadVCK(0, true);
        PostShipOrderResp('');
    end;

    var
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";

    procedure DownloadAndPostShippingResponse(pRespNo: Code[20]; ForcePosting: Boolean)
    var
        recAutoSetup: Record "Automation Setup";
    begin
        DownloadVCK(2, true);
        recAutoSetup.Get();
        if recAutoSetup.WhseOutbPostingAllowed() or
           (recAutoSetup."Post Outbound Response" and ForcePosting)
        then
            PostShippingOrderResponse(pRespNo);
    end;

    procedure PostShippingOrderResponse(pRespNo: Code[20])
    begin
        PostShipOrderResp(pRespNo);
    end;

    procedure ShipOrderRespImport(pEntryNo: Integer)
    var
        recZyFileMgt: Record "Zyxel File Management";
        recZyFileMgt2: Record "Zyxel File Management";
        recRespHead2: Record "Ship Response Header";
        recRespHead3: Record "Ship Response Header";
        recAutoSetup: Record "Automation Setup";
        repIdentifyIdenticalSerialNo: Report "Identify Identical Serial No.";
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        xmlShipOrderResp: XmlPort "Read Shipping Order Response";
        ArchiveFile: File;
        NVInStream: InStream;
        lText001: Label 'Import VCK Response';
        lText002: Label 'Document could not open.';
        ServerFilename: Text;
        lText003: Label 'There are error(s) on serial no.';
        lText004: Label '%1 - %2.xlsx';
        LastErrorText: Text;
    begin
        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::"VCK Ship. Response");
        recZyFileMgt.SetRange(Open, true);
        recZyFileMgt.SetFilter("On Hold", '%1', '');
        if pEntryNo <> 0 then
            recZyFileMgt.SetRange("Entry No.", pEntryNo);
        if recZyFileMgt.FindSet() then begin
            ZGT.OpenProgressWindow(lText001, recZyFileMgt.Count());

            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);
                recZyFileMgt2.Get(recZyFileMgt."Entry No.");

                Clear(ArchiveFile);
                if ArchiveFile.Open(recZyFileMgt.Filename, TextEncoding::UTF8) then begin
                    ArchiveFile.CreateInstream(NVInStream);

                    Clear(xmlShipOrderResp);
                    xmlShipOrderResp.Init(recZyFileMgt."Entry No.");
                    xmlShipOrderResp.SetSource(NVInStream);

                    LastErrorText := '';
                    ClearLastError();
                    if not xmlShipOrderResp.Import() then
                        LastErrorText := GetLastErrorText();

                    if LastErrorText = '' then begin
                        if recRespHead2.FindLast() and (recRespHead2."Warehouse Status" = recRespHead2."Warehouse Status"::Packed) then begin
                            recRespHead2.SetRange("No.", recRespHead2."No.");

                            ServerFilename := FileMgt.ServerTempFileName('');
                            Clear(repIdentifyIdenticalSerialNo);
                            repIdentifyIdenticalSerialNo.SetTableView(recRespHead2);
                            repIdentifyIdenticalSerialNo.SaveAsExcel(ServerFilename);
                            if (recRespHead2."On Hold" = '') and repIdentifyIdenticalSerialNo.DifferenceLocated() then begin
                                SI.SetMergefield(100, recRespHead2."Order No.");
                                SI.SetMergefield(101, Format(recRespHead2."Warehouse Status"));
                                SI.SetMergefield(102, recRespHead2."Customer Reference");

                                Clear(EmailAddMgt);
                                EmailAddMgt.CreateEmailWithAttachment('VCKSENOMIS', '', '', ServerFilename, StrSubstNo(lText004, recRespHead2."Order No.", recRespHead2."Customer Reference"), false);
                                EmailAddMgt.Send();
                                FileMgt.DeleteServerFile(ServerFilename);

                                recRespHead2."On Hold" := 'ERR';
                                recRespHead2."After Post Description" := lText003;
                                recRespHead2.Modify(true);
                            end else begin
                                recRespHead3.SetRange("Customer Reference", recRespHead2."Customer Reference");
                                recRespHead3.SetRange("Warehouse Status", recRespHead3."warehouse status"::Packed);
                                recRespHead3.SetRange("On Hold", 'ERR');
                                if recRespHead3.FindSet(true) then
                                    repeat
                                        recRespHead3.CloseResponse();
                                    until recRespHead3.Next() = 0;
                            end;
                        end;

                        recZyFileMgt2.Open := false;
                        recZyFileMgt2."Error Text" := '';
                    end else
                        recZyFileMgt2."Error Text" := CopyStr(LastErrorText, 1, MaxStrLen(recZyFileMgt2."Error Text"));

                    recZyFileMgt2.Modify();
                    ArchiveFile.Close();
                end else begin
                    recZyFileMgt2."Error Text" := lText002;
                    recZyFileMgt2.Modify();
                end;

                if recZyFileMgt2."Error Text" <> '' then begin
                    recAutoSetup.Get();
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today()) then begin
                        Clear(EmailAddMgt);
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send();

                        recAutoSetup."Warehouse Import Error Date" := Today();
                        recAutoSetup.Modify();

                    end;
                end;

                Commit();
            until recZyFileMgt.Next() = 0;

            ZGT.CloseProgressWindow();
        end;
    end;

    local procedure PostShipOrderResp(pRespNo: Code[20])
    var
        recRespHead: Record "Ship Response Header";
        recRespHead2: Record "Ship Response Header";
        recRespHead3: Record "Ship Response Header";
        recRespLine: Record "Ship Response Line";
        recWhseSetup: Record "Warehouse Setup";
        recLocation: Record Location;
        recAutoSetup: Record "Automation Setup";
        recDelDocHead: Record "VCK Delivery Document Header";
        TriedToPost: Boolean;
        PostResult: Boolean;
        lText001: Label 'Posting Shipment Response';
        lText002: Label '"%1" is not setup in "%2".';
        lText004: Label 'Check "%1" on the response lines.';
    begin
        recRespHead.LockTable();
        recRespLine.LockTable();
        recRespHead2.SetCurrentkey("Customer Reference", "Warehouse Status", Open);
        recRespHead3.SetCurrentkey("Customer Reference", "Warehouse Status", Open);
        recRespHead.SetCurrentkey("Customer Reference", "Warehouse Status", Open);
        recRespHead.SetAutoCalcFields("Delivery Document Type");
        recRespHead.SetRange(Open, true);
        recRespHead.SetFilter("On Hold", '%1', '');
        if pRespNo <> '' then
            recRespHead.SetRange("No.", pRespNo);
        if recRespHead.FindSet(true) then begin
            SI.SetWarehouseManagement(true);
            SI.SetHideSalesDialog(true);
            ZGT.OpenProgressWindow(lText001, recRespHead.Count());
            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);

                recWhseSetup.Get();
                if recWhseSetup."When Can We Post Resp. VCK" = recWhseSetup."when can we post resp. vck"::"New or Larger" then
                    Error(lText002, recWhseSetup.FieldCaption("When Can We Post Resp. VCK"), recWhseSetup.TableCaption());

                recRespHead3.SetRange("Customer Reference", recRespHead."Customer Reference");
                recRespHead3.SetFilter("Warehouse Status", '<%1', recRespHead."Warehouse Status");
                recRespHead3.SetRange(Open, true);
                if recRespHead3.IsEmpty() then begin
                    // Ship Post
                    recRespHead2.Reset();
                    recRespHead2.SetRange("Customer Reference", recRespHead."Customer Reference");
                    recRespHead2.SetFilter("No.", '<>%1', recRespHead."No.");
                    recRespHead2.SetRange("Ship Posted", true);

                    TriedToPost := false;
                    PostResult := false;
                    if (recRespHead."Warehouse Status" >= recWhseSetup."When Can We Post Resp. VCK") and
                       (not recRespHead2.FindFirst())  // Searching for previous posted responce.
                    then begin
                        recRespLine.SetCurrentkey("Response No.", "Customer Order No.", "Customer Order Line No.");
                        recRespLine.SetAutoCalcFields("Warehouse Status");
                        recRespLine.SetRange("Response No.", recRespHead."No.");
                        recRespLine.SetRange(Open, true);
                        if recRespLine.FindSet() then begin
                            recRespHead."After Post Description" := '';
                            recRespHead."Ship Posted" := true;
                            TriedToPost := true;

                            repeat
                                recRespLine.SetRange("Customer Order No.", recRespLine."Customer Order No.");
                                case recRespHead."Delivery Document Type" of
                                    recRespHead."delivery document type"::Sales:
                                        PostResult := PostShipOrderRespDoc(recRespHead, recRespLine);
                                    recRespHead."delivery document type"::Transfer:
                                        PostResult := PostTransOrderRespDoc(recRespHead, recRespLine);
                                end;

                                if not PostResult then begin
                                    recRespHead."Ship Posted" := false;
                                    recRespHead.CalcFields("Lines With Error");
                                    if recRespHead."Lines With Error" and (recRespHead."After Post Description" = '') then
                                        recRespHead."After Post Description" := StrSubstNo(lText004, recRespLine.FieldCaption("Error Text"));
                                end else
                                    if not recRespLine.FindLast() then;
                                recRespLine.SetRange("Customer Order No.");
                            until recRespLine.Next() = 0;
                        end;
                    end;

                    // Receipt Post
                    recAutoSetup.Get();
                    if recDelDocHead.Get(recRespHead."Customer Reference") then begin
                        if not recLocation.Get(recDelDocHead."Bill-to Customer No.") then
                            Clear(recLocation);
                        if (recRespHead."Delivery Document Type" = recRespHead."delivery document type"::Transfer) and
                           ((recLocation."Post Transf. Rcpt on Transit" and (recRespHead."Warehouse Status" >= recAutoSetup."Rcpt. Post Transf Whse. Status")) or
                            (recRespHead."Warehouse Status" = recRespHead."warehouse status"::Delivered)) and
                           (Date2dmy(Today, 2) < 12)
                        then begin
                            recRespHead2.Reset();
                            recRespHead2.SetRange("Customer Reference", recRespHead."Customer Reference");
                            recRespHead2.SetFilter("No.", '<>%1', recRespHead."No.");
                            recRespHead2.SetRange("Receipt Posted", true);

                            if not recRespHead2.FindFirst() then begin
                                recRespLine.Reset();
                                recRespLine.SetCurrentkey("Response No.", "Customer Order No.", "Customer Order Line No.");
                                recRespLine.SetAutoCalcFields("Warehouse Status");
                                recRespLine.SetRange("Response No.", recRespHead."No.");
                                recRespLine.SetRange("Open - Receipt", true);
                                if recRespLine.FindSet() then begin
                                    recRespHead."After Post Description" := '';
                                    recRespHead."Receipt Posted" := true;

                                    repeat
                                        recRespLine.SetRange("Customer Order No.", recRespLine."Customer Order No.");
                                        PostResult := PostTransOrderRespDoc_Receipt(recRespHead, recRespLine);

                                        if not PostResult then begin
                                            recRespHead."Receipt Posted" := false;
                                            recRespHead.CalcFields("Lines With Error");
                                            if recRespHead."Lines With Error" and (recRespHead."After Post Description" = '') then
                                                recRespHead."After Post Description" := StrSubstNo(lText004, recRespLine.FieldCaption("Error Text"));
                                        end;

                                        if not recRespLine.FindLast() then;
                                        recRespLine.SetRange("Customer Order No.");
                                    until recRespLine.Next() = 0;
                                end;
                            end;
                        end;
                    end;

                    UpdateDeliveryDocument(recRespHead, TriedToPost, PostResult);
                    recRespHead.Modify();
                    Commit();
                end;
            until recRespHead.Next() = 0;

            ZGT.CloseProgressWindow();
            SI.SetHideSalesDialog(false);
            SI.SetWarehouseManagement(false);
        end;
    end;

    local procedure PostShipOrderRespDoc(var precRespHead: Record "Ship Response Header"; precRespLine: Record "Ship Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Ship Response Line";
        recRespLineTmp: Record "Ship Response Line" temporary;
        recSalesHead: Record "Sales Header";
        recWhseShipHead: Record "Warehouse Shipment Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recCust: Record Customer;
        recItemIdentifier: Record "Item Identifier";
        recDelDocLine: Record "VCK Delivery Document Line";
        ChangeLog: Record "Change Log Entry";
        MailAddMgt: Codeunit "E-mail Address Management";
        GetSourceDocoutbound: Codeunit "Get Source Doc. Outbound";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ErrorText: Text;
        PostWhseShipment: Boolean;
        WhseRequestFound: Boolean;
        lText002: Label '"%1" was not found. "%2": %3; "%4": %5.';
        lText004: Label 'Warehouse Request was not found.';
        lText005: Label 'You cannot handle more than the outstanding %1 units.';
        lText006: Label 'Sales Order "%1" was not found.';
        lText007: Label 'Customer No. %1 is blocked with "%2".';
        ProductNo: Code[20];
    begin
        // Find Warehouse request
        recWhseShipLine.SetRange("Source Type", Database::"Sales Line");
        recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Sales Order");
        recWhseShipLine.SetRange("Source No.", precRespLine."Customer Order No.");
        if recWhseShipLine.FindFirst() then begin
            recWhseShipHead.Get(recWhseShipLine."No.");
            WhseRequestFound := true;
        end else begin
            recSalesHead.SetAutoCalcFields("Completely Shipped", "Completely Invoiced");
            if not recSalesHead.Get(recSalesHead."document type"::Order, precRespLine."Customer Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Customer Order No.");
                precRespHead.Modify();
            end else
                if (not recSalesHead."Completely Shipped") and (not recSalesHead."Completely Invoiced") then
                    if recCust.Get(recSalesHead."Sell-to Customer No.") and (recCust.Blocked = recCust.Blocked::" ") then begin

                        if recSalesHead.Status = recSalesHead.Status::Open then
                            ReleaseSalesDocument.PerformManualRelease(recSalesHead);

                        if GetSourceDocoutbound.CreateFromSalesOrderHideDialog(recSalesHead) then begin
                            recWhseShipHead.SetRange("Sales Order No.", recSalesHead."No.");
                            WhseRequestFound := recWhseShipHead.FindLast();
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify();
                            end;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recCust."No.", recCust.Blocked);
                            precRespHead.Modify();
                        end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseShipHead."Posting Date" := Today;
            recWhseShipHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseShipLine.SetRange("No.", recWhseShipHead."No.");
            if recWhseShipLine.FindSet(true) then
                repeat
                    recWhseShipLine.Validate("Qty. to Ship", 0);
                    recWhseShipLine.Modify(true);
                until recWhseShipLine.Next() = 0;

            // Update and post values
            recWhseShipLine.Reset();
            recRespLine.SetAutoCalcFields("Warehouse Status", "Sales Order Qty. Shipped", "Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Customer Order No.", precRespLine."Customer Order No.");
            recRespLine.SetRange("Delivery Document Line Posted", false);
            recRespLine.SetRange(Open, true);
            recRespLine.ModifyAll("Error Text", ''); //15-10-25 BK #Upgrade 26 Issue
            if recRespLine.FindSet(true) then begin
                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    recWhseShipLine.SetRange("Source Type", Database::"Sales Line");
                    recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Sales Order");
                    recWhseShipLine.SetRange("Source No.", precRespLine."Customer Order No.");
                    recWhseShipLine.SetRange("Source Line No.", recRespLine."Customer Order Line No.");
                    if recWhseShipLine.FindFirst() then begin
                        ProductNo := recRespLine."Product No.";
                        if ProductNo <> recWhseShipLine."Item No." then
                            if recItemIdentifier.Get(ProductNo) then begin
                                ProductNo := recItemIdentifier."Item No.";
                                recRespLine."Alt. Product No." := recItemIdentifier."Item No.";
                            end;

                        if ValidateShipOrderRespLine(recRespLine, recWhseShipLine, ProductNo, ErrorText) then begin
                            if (recWhseShipLine."Qty. to Ship" + recRespLine.Quantity) <= recWhseShipLine."Qty. Outstanding" then begin
                                recWhseShipLine.Validate("Qty. to Ship", recWhseShipLine."Qty. to Ship" + recRespLine.Quantity);
                                recWhseShipLine.Validate("Posted By AIT", true);
                                recWhseShipLine.Modify(true);

                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert();

                                PostWhseShipment := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseShipLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(recRespLine."Error Text"));
                            recRespLine.Modify();
                        end;
                    end else
                        if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                           (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced")
                        then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine.Open := false;
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseShipLine.TableCaption(),
                                recWhseShipLine.FieldCaption("Source No."), precRespLine."Customer Order No.",
                                recWhseShipLine.FieldCaption("Source Line No."), recRespLine."Customer Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                recDelDocLine.Reset();
                recDelDocLine.SetRange("Document No.", precRespHead."Customer Reference");
                recDelDocLine.SetRange("Sales Order No.", precRespLine."Customer Order No.");  // It must be the same sales order as the response lines.
                recDelDocLine.SetRange("Freight Cost Item", true);
                recDelDocLine.SetRange(Posted, false);
                if recDelDocLine.FindSet() then
                    repeat
                        recWhseShipLine.SetRange("Source Type", Database::"Sales Line");
                        recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Sales Order");
                        recWhseShipLine.SetRange("Source No.", recDelDocLine."Sales Order No.");
                        recWhseShipLine.SetRange("Source Line No.", recDelDocLine."Sales Order Line No.");
                        if recWhseShipLine.FindFirst() then
                            if (recWhseShipLine."Qty. to Ship" + recDelDocLine.Quantity) <= recWhseShipLine."Qty. Outstanding" then begin
                                recWhseShipLine.Validate("Qty. to Ship", recWhseShipLine."Qty. to Ship" + recDelDocLine.Quantity);
                                recWhseShipLine.Validate("Posted By AIT", true);
                                recWhseShipLine.Modify(true);
                                PostWhseShipment := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseShipLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                    until recDelDocLine.Next() = 0;
                recWhseShipLine.SetRange("Source Line No.");

                // Post warehouse request
                if PostWhseShipment then begin
                    Commit();
                    WhsePostShipment.SetPostingSettings(false);
                    WhsePostShipment.SetPrint(false);
                    if WhsePostShipment.Run(recWhseShipLine) then
                        PostResultOK := WhsePostShipment.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                    Clear(WhsePostShipment);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutoCalcFields("Warehouse Status", "Sales Order Qty. Shipped", "Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Customer Order No.", precRespLine."Customer Order No.");
            recRespLine.SetRange(Open, true);
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                        (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced")
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else begin
                        if not recRespLine."Mail Missing Del. Doc. Sent" then begin
                            ChangeLog.SetCurrentKey("Table No.", "Type of Change", "Primary Key Field 1 Value", "Field No.");
                            ChangeLog.SetRange("Table No.", Database::"VCK Delivery Document Line");
                            ChangeLog.SetRange("Type of Change", ChangeLog."Type of Change"::Deletion);
                            ChangeLog.SetRange("Primary Key Field 1 Value", recRespLine."Sales Order No.");
                            ChangeLog.SetRange("Primary Key Field 2 Value", Format(recRespLine."Sales Order Line No."));
                            if ChangeLog.FindFirst() then begin
                                SI.SetMergefield(100, recRespLine."Sales Order No.");
                                SI.SetMergefield(101, Format(recRespLine."Sales Order Line No."));
                                SI.SetMergefield(102, ChangeLog."User ID");
                                MailAddMgt.CreateSimpleEmail('VCKDELLINE', '', '');
                                MailAddMgt.Send();
                                recRespLine."Mail Missing Del. Doc. Sent" := true;
                            end;
                        end;

                        recRespLine."Error Text" := lText004;
                    End;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;
    end;

    local procedure ValidateShipOrderRespLine(pRespLine: Record "Ship Response Line"; pWhseShipLine: Record "Warehouse Shipment Line"; pProductNo: Code[20]; var pErrorText: Text): Boolean
    var
        recItem: Record Item;
        recSalesLine: Record "Sales Line";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        lText001: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText002: Label '"%1" must not be 0,00 on %4 sales order %2 line no. %3.';
        lText003: Label '"%1" must be 0,00 on %4 sales order %2 line no. %3.';
        lText004: Label '"%1" must be identical to "%5" on %4 sales order %2 line no. %3.';
        lText005: Label 'Insufficient inventory. Present inventory is %1.';
    begin
        //>> 28-04-22 ZY-LD 017
        pErrorText := '';
        if pProductNo <> pWhseShipLine."Item No." then
            pErrorText := StrSubstNo(lText001, pWhseShipLine.FieldCaption("Item No."), pRespLine.TableCaption(), pWhseShipLine.TableCaption(), pRespLine."Line No.");

        if pErrorText = '' then
            if recSalesLine.Get(pWhseShipLine."Source Document", pWhseShipLine."Source No.", pWhseShipLine."Source Line No.") then begin
                recGenBusPostGrp.Get(recSalesLine."Gen. Bus. Posting Group");
                if recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."sample / test equipment"::" " then begin
                    if (recSalesLine.Type = recSalesLine.Type::Item) and (recSalesLine."No." <> '') and (recSalesLine.Quantity <> 0) then
                        if recSalesLine."Unit Cost" = 0 then begin
                            recItem.Get(recSalesLine."No.");
                            if recItem."Unit Cost" <> 0 then
                                pErrorText := StrSubstNo(lText002, recSalesLine.FieldCaption("Unit Cost"), recSalesLine."No.", recSalesLine."Line No.", LowerCase(recSalesLine."Gen. Bus. Posting Group"));
                        end;

                    if pErrorText = '' then
                        case recGenBusPostGrp."Sample / Test Equipment" OF
                            recGenBusPostGrp."Sample / Test Equipment"::"Sample (Unit Price = Zero)":
                                IF recSalesLine."Unit Price" <> 0 THEN
                                    pErrorText := STRSUBSTNO(lText003, recSalesLine.FIELDCAPTION("Unit Price"), recSalesLine."No.", recSalesLine."Line No.", LOWERCASE(recSalesLine."Gen. Bus. Posting Group"));
                            recGenBusPostGrp."Sample / Test Equipment"::"Sample (Unit Price = Unit Cost)":
                                IF recSalesLine."Unit Price" <> recSalesLine."Unit Cost" THEN
                                    pErrorText := STRSUBSTNO(lText004, recSalesLine.FIELDCAPTION("Unit Price"), recSalesLine."No.", recSalesLine."Line No.", LOWERCASE(recSalesLine."Gen. Bus. Posting Group"), recSalesLine.FIELDCAPTION("Unit Cost"));
                        END;
                end;
                if pErrorText = '' then begin
                    recItem.SetRange("Location Filter", pRespLine.Location);
                    recItem.SetAutoCalcFields(Inventory);
                    recItem.Get(pProductNo);
                    if recItem.Inventory < pRespLine.Quantity then
                        pErrorText := StrSubstNo(lText005, recItem.Inventory);
                end;
            end;
        exit(pErrorText = '');
    end;

    local procedure PostTransOrderRespDoc(var precRespHead: Record "Ship Response Header"; precRespLine: Record "Ship Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Ship Response Line";
        recRespLineTmp: Record "Ship Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseShipHead: Record "Warehouse Shipment Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recLocation: Record Location;
        GetSourceDocoutbound: Codeunit "Get Source Doc. Outbound";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseShipment: Boolean;
        WhseRequestFound: Boolean;
        lText002: Label '"%1" was not found. "%2": %3; "%4": %5.';
        lText004: Label 'Warehouse Request was not found.';
        lText005: Label 'You cannot handle more than the outstanding %1 units.';
        lText006: Label 'Sales Order "%1" was not found.';
        lText007: Label 'Location Code %1 is not in use.';
        ErrorText: Text;
    begin
        // Find Warehouse request
        recWhseShipLine.SetRange("Source Type", Database::"Transfer Line");
        recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Outbound Transfer");
        recWhseShipLine.SetRange("Source No.", precRespLine."Customer Order No.");
        if recWhseShipLine.FindFirst() then begin
            recWhseShipHead.Get(recWhseShipLine."No.");
            WhseRequestFound := true;
        end else begin
            recTransHead.SetAutoCalcFields("Completely Shipped", "Completely Received");
            if not recTransHead.Get(precRespLine."Customer Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Customer Order No.");
                precRespHead.Modify();
            end else
                if (not recTransHead."Completely Shipped") and (not recTransHead."Completely Received") then
                    if recLocation.Get(recTransHead."Transfer-from Code") and (recLocation."In Use") then begin

                        if recTransHead.Status = recTransHead.Status::Open then
                            ReleaseTransferDocument.Run(recTransHead);

                        if GetSourceDocoutbound.CreateFromOutbndTransferOrderHideDialog(recTransHead) then begin
                            recWhseShipHead.SetRange("Sales Order No.", recTransHead."No.");
                            WhseRequestFound := recWhseShipHead.FindLast();
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify();
                            end;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recTransHead."Transfer-from Code");
                            precRespHead.Modify();
                        end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseShipHead."Posting Date" := Today;
            recWhseShipHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseShipLine.SetRange("No.", recWhseShipHead."No.");
            if recWhseShipLine.FindSet(true) then
                repeat
                    recWhseShipLine.Validate("Qty. to Ship", 0);
                    recWhseShipLine.Modify(true);
                until recWhseShipLine.Next() = 0;

            // Update and post values
            recWhseShipLine.Reset();
            recRespLine.SetAutoCalcFields("Warehouse Status", "Transfer Order Qty. Shipped");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Customer Order No.", precRespLine."Customer Order No.");
            recRespLine.SetRange("Delivery Document Line Posted", false);
            recRespLine.SetRange(Open, true);
            recRespLine.ModifyAll("Error Text", ''); //15-10-25 BK #Upgrade 26 Issue
            if recRespLine.FindSet(true) then begin
                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    recWhseShipLine.SetRange("Source Type", Database::"Transfer Line");
                    recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Outbound Transfer");
                    recWhseShipLine.SetRange("Source No.", precRespLine."Customer Order No.");
                    recWhseShipLine.SetRange("Source Line No.", recRespLine."Customer Order Line No.");
                    if recWhseShipLine.FindFirst() then begin
                        if ValidateTransOrderRespLine(precRespLine, recWhseShipLine, recRespLine."Product No.", ErrorText) then begin
                            if (recWhseShipLine."Qty. to Ship" + recRespLine.Quantity) <= recWhseShipLine."Qty. Outstanding" then begin
                                recWhseShipLine.Validate("Qty. to Ship", recWhseShipLine."Qty. to Ship" + recRespLine.Quantity);
                                recWhseShipLine.Validate("Posted By AIT", true);
                                recWhseShipLine.Modify(true);

                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert();

                                PostWhseShipment := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseShipLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(recRespLine."Error Text"));
                            recRespLine.Modify();
                        end;
                    end else
                        if recRespLine.Quantity = recRespLine."Transfer Order Qty. Shipped" then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine.Open := false;
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseShipLine.TableCaption(),
                                recWhseShipLine.FieldCaption("Source No."), precRespLine."Customer Order No.",
                                recWhseShipLine.FieldCaption("Source Line No."), recRespLine."Customer Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseShipment then begin
                    Commit();
                    WhsePostShipment.SetPostingSettings(false);
                    WhsePostShipment.SetPrint(false);
                    if WhsePostShipment.Run(recWhseShipLine) then
                        PostResultOK := WhsePostShipment.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                    Clear(WhsePostShipment);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutoCalcFields("Warehouse Status", "Sales Order Qty. Shipped", "Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Customer Order No.", precRespLine."Customer Order No.");
            recRespLine.SetRange(Open, true);
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                        (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced")
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else begin
                        recRespLine."Error Text" := lText004;
                        recRespLine.Open := false;
                    end;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;
    end;

    local procedure ValidateTransOrderRespLine(pRespLine: Record "Ship Response Line"; pWhseShipLine: Record "Warehouse Shipment Line"; pProductNo: Code[20]; var pErrorText: Text): Boolean
    var
        recItem: Record Item;
        lText001: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText005: Label 'Inventory "%1" is less that the quantity shipped "%2".';
    begin
        pErrorText := '';
        if pProductNo <> pWhseShipLine."Item No." then
            pErrorText := StrSubstNo(lText001, pWhseShipLine.FieldCaption("Item No."), pRespLine.TableCaption(), pWhseShipLine.TableCaption(), pRespLine."Line No.");

        if pErrorText = '' then begin
            recItem.SetRange("Location Filter", pRespLine.Location);
            recItem.SetAutoCalcFields(Inventory);
            recItem.Get(pProductNo);
            if recItem.Inventory < pRespLine.Quantity then
                pErrorText := StrSubstNo(lText005, recItem.Inventory, pRespLine.Quantity);
        end;
        exit(pErrorText = '');
    end;

    local procedure PostTransOrderRespDoc_Receipt(var precRespHead: Record "Ship Response Header"; precRespLine: Record "Ship Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Ship Response Line";
        recRespLineTmp: Record "Ship Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseReceipt: Boolean;
        WhseRequestFound: Boolean;
        lText002: Label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText004: Label 'Warehouse Request was not found.';
        lText005: Label 'You cannot handle more than the outstanding %1 units.';
        lText006: Label 'Transfer Order "%1" was not found.';
    begin
        // Find Warehouse request
        recWhseRcptLine.SetRange("Source Type", Database::"Transfer Line");
        recWhseRcptLine.SetRange("Source Document", recWhseRcptLine."source document"::"Inbound Transfer");
        recWhseRcptLine.SetRange("Source No.", precRespLine."Customer Order No.");
        recWhseRcptLine.SetRange("Source Line No.", precRespLine."Customer Order Line No.");
        if recWhseRcptLine.FindFirst() then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recTransHead.SetAutoCalcFields("Completely Received");
            if not recTransHead.Get(precRespLine."Customer Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Customer Order No.");
                precRespHead.Modify();
            end else
                if not recTransHead."Completely Received" then begin
                    if recTransHead.Status = recTransHead.Status::Open then
                        ReleaseTransferDocument.Run(recTransHead);
                    if GetSourceDocInbound.CreateFromInbndTransferOrderHideDialog(recTransHead) then begin
                        recWhseRcptHead.SetRange("Transfer Order No.", recTransHead."No.");
                        WhseRequestFound := recWhseRcptHead.FindLast();
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                            precRespHead.Modify();
                        end;
                end;
        end;
        recWhseRcptLine.SetRange("Source Line No.");

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today();
            recWhseRcptHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset();
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Sales Order No.", precRespLine."Sales Order No.");
            recRespLine.SetRange("Customer Order No.", precRespLine."Customer Order No.");
            recRespLine.SetRange("Open - Receipt", true);
            recRespLine.ModifyAll("Error Text", ''); //15-10-25 BK #Upgrade 26 Issue
            if recRespLine.FindSet(true) then begin
                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    recWhseRcptLine.SetRange("Source Type", Database::"Transfer Line");
                    recWhseRcptLine.SetRange("Source Document", recWhseRcptLine."source document"::"Inbound Transfer");
                    recWhseRcptLine.SetRange("Source No.", precRespLine."Customer Order No.");
                    recWhseRcptLine.SetRange("Source Line No.", recRespLine."Customer Order Line No.");
                    if recWhseRcptLine.FindFirst() then begin
                        if recRespLine."Product No." = recWhseRcptLine."Item No." then begin
                            if (recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity) <= recWhseRcptLine."Qty. Outstanding" then begin
                                recWhseRcptLine.Validate("Qty. to Receive", recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity);
                                recWhseRcptLine.Validate("Warehouse Inbound No.", precRespHead."Customer Reference");
                                recWhseRcptLine.Modify(true);

                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert();

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption(), recWhseRcptLine.TableCaption(), recRespLine."Line No.");
                            recRespLine.Modify();
                        end;
                    end else
                        if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                           (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced")
                        then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine."Open - Receipt" := false;
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseRcptLine.TableCaption(),
                                recWhseRcptLine.FieldCaption("Source No."), precRespLine."Sales Order No.",
                                recWhseRcptLine.FieldCaption("Source Line No."), recRespLine."Sales Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit();
                    recWhseRcptLine.RESET();
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                    Clear(WhsePostReceipt);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutoCalcFields("Warehouse Status", "Sales Order Qty. Shipped", "Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Sales Order No.", precRespLine."Sales Order No.");
            recRespLine.SetRange(Open, true);
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                        (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced")
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;
    end;

    procedure DownloadVCK(Type: Option " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR; Import: Boolean)
    var
        recWhseSetup: Record "Warehouse Setup";
        recWarehouse: Record Location;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: Label 'Downloading from VCK';
    begin
        if GuiAllowed() or recWhseSetup.WhsePostingAllowed() then begin
            ZGT.OpenProgressWindow(lText001, 1);
            ZGT.UpdateProgressWindow(lText001, 0, true);
            recWarehouse.SetRange(Warehouse, recWarehouse.Warehouse::VCK);
            recWarehouse.FindFirst();
            recWarehouse.TestField("Warehouse Outbound FTP Code");
            FtpMgt.DownloadFolder(recWarehouse."Warehouse Outbound FTP Code");
            ZGT.CloseProgressWindow();

            if Import then
                case Type of
                    Type::"VCK Ship. Response":
                        ShipOrderRespImport(0);
                    else
                        ShipOrderRespImport(0);
                end;
        end;
    end;

    procedure UpdateDeliveryDocument(var recRespHead: Record "Ship Response Header"; TriedToPost: Boolean; PostResult: Boolean) rValue: Boolean
    var
        recRespLine: Record "Ship Response Line";
        recShipRespSerialNo: Record "Ship Responce Serial Nos.";
        recDelDocHead: Record "VCK Delivery Document Header";
        recDelDocLine: Record "VCK Delivery Document Line";
        recDelDocSerialNo: Record "VCK Delivery Document SNos";
        recAutoSetup: Record "Automation Setup";
        lText001: Label 'Warehouse Status on DD is %1, and therefore not updated.';

    begin
        if not recRespHead."Lines With Error" then
            if recDelDocHead.Get(recRespHead."Customer Reference") and
               (recRespHead."Warehouse Status" > recDelDocHead."Warehouse Status") and
               (TriedToPost = PostResult)
            then begin
                recAutoSetup.Get();
                if recRespHead."Warehouse Status" = recRespHead."warehouse status"::New then
                    recDelDocHead."Warehouse Status" := recRespHead."warehouse status"::"Ready to Pick"
                else
                    recDelDocHead."Warehouse Status" := recRespHead."Warehouse Status";
                if (recRespHead."Warehouse Status" = recRespHead."warehouse status"::Picking) and
                   (recRespHead."Picking Date Time" <> 0DT)
                then begin
                    recDelDocHead."Picking Date Time" := Format(recRespHead."Picking Date Time");
                    recDelDocHead.PickDate := Dt2Date(recRespHead."Picking Date Time");
                end;
                if recRespHead."Warehouse Status" = recRespHead."warehouse status"::Packed then
                    recDelDocHead.Weight := recRespHead.Weight;
                if (recRespHead."Warehouse Status" = recRespHead."warehouse status"::"In Transit") and
                   (recRespHead."Loading Date Time" <> 0DT)
                then begin
                    recDelDocHead."Loading Date Time" := Format(recRespHead."Loading Date Time");
                    recDelDocHead."Loading Date" := recRespHead."Loading Date Time";
                end;
                if recRespHead."Warehouse Status" = recRespHead."warehouse status"::Delivered then
                    recDelDocHead."Delivery Date Time" := Format(recRespHead."Delivery Date Time");
                recDelDocHead."Delivery Remark" := copystr(recRespHead."Delivery Remark", 1, 50);
                recDelDocHead."Delivery Status" := recRespHead."Delivery Status";
                recDelDocHead."Receiver Reference" := recRespHead."Receiver Reference";
                recDelDocHead."Shipper Reference" := recRespHead."Customer Reference";
                recDelDocHead."Signed By" := copystr(recRespHead."Signed By", 1, 50);
                recDelDocHead."Order Acknowledged" := true;
                recDelDocHead.Modify();

                recRespLine.SetAutoCalcFields(recRespLine."Sales Order Qty. Shipped", recRespLine."Sales Order Qty. Invoiced");
                recRespLine.SetRange("Response No.", recRespHead."No.");
                if recRespLine.FindSet(true) then
                    repeat
                        if not recRespHead."Delivery Document is Updated" then begin
                            recDelDocLine.SetRange("Document No.", recRespLine."Sales Order No.");
                            recDelDocLine.SetRange("Line No.", recRespLine."Sales Order Line No.");
                            if recDelDocLine.FindFirst() then begin
                                if recDelDocLine.Quantity > 0 then
                                    recDelDocLine.Validate("Warehouse Status", recDelDocHead."Warehouse Status");
                                recDelDocLine."Picking Date Time" := Format(recRespHead."Picking Date Time");
                                recDelDocLine.PickDate := Dt2Date(recRespHead."Picking Date Time");
                                recDelDocLine."Loading Date Time" := Format(recRespHead."Loading Date Time");
                                recDelDocLine."Delivery Date Time" := Format(recRespHead."Delivery Date Time");
                                recDelDocLine."Delivery Remark" := copystr(recRespHead."Delivery Remark", 1, 50);
                                recDelDocLine."Delivery Status" := recRespHead."Delivery Status";
                                recDelDocLine."Receiver Reference" := recRespHead."Receiver Reference";
                                recDelDocLine."Shipper Reference" := recRespHead."Customer Reference";
                                recDelDocLine."Signed By" := copystr(recRespHead."Signed By", 1, 50);
                                recDelDocLine.Modify();

                                recShipRespSerialNo.SetRange("Response No.", recRespHead."No.");
                                recShipRespSerialNo.SetRange("Response Line No.", recRespLine."Response Line No.");
                                if recShipRespSerialNo.FindSet() then
                                    repeat
                                        recDelDocSerialNo.Init();
                                        recDelDocSerialNo."Serial No." := recShipRespSerialNo."Serial No.";
                                        recDelDocSerialNo."Delivery Document No." := recShipRespSerialNo."Sales Order No.";
                                        recDelDocSerialNo."Delivery Document Line No." := recShipRespSerialNo."Sales Order Line No.";
                                        recDelDocSerialNo."Posting Date" := Today;
                                        recDelDocSerialNo."Item No." := recDelDocLine."Item No.";
                                        recDelDocSerialNo."Sales Order No." := recDelDocLine."Sales Order No.";
                                        recDelDocSerialNo."Sales Order Line No." := recDelDocLine."Sales Order Line No.";
                                        recDelDocSerialNo."Customer Order No." := recDelDocLine."Customer Order No.";
                                        recDelDocSerialNo."Customer No." := recDelDocHead."Bill-to Customer No.";
                                        if not recDelDocSerialNo.Insert() then;
                                    until recShipRespSerialNo.Next() = 0;
                            end;

                            if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                               (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced") or
                               (recDelDocHead."Warehouse Status" < recAutoSetup."Create Invoice on Whse. Status")
                            then begin
                                recRespLine.Open := false;
                                recRespLine.Modify();
                            end;
                        end;
                    until recRespLine.Next() = 0;

                if recDelDocHead."Warehouse Status" = recDelDocHead."warehouse status"::Packed then
                    recDelDocHead.EmailCustomsInvoice(true);
                recRespHead."Delivery Document is Updated" := true;
                rValue := true;
            end else begin
                recRespHead."After Post Description" := StrSubstNo(lText001, recDelDocHead."Warehouse Status");

                recRespLine.SetRange("Response No.", recRespHead."No.");
                if recRespLine.FindSet(true) then
                    repeat
                        recRespLine.Open := false;
                        recRespLine.Modify();
                    until recRespLine.Next() = 0;
            end;
    end;
}
