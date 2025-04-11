codeunit 50089 "Post Ship Response Mgt."
{
    // 001. 09-05-19 ZY-LD 000 - Testing on completly shipped.
    // 002. 14-06-19 ZY-LD 2019061410000025 - Clear XML before import to avoid use of the same number.
    // 003. 24-06-19 ZY-LD 2019062110000039 - Testing on completly invoiced.
    // 004. 30-09-19 ZY-LD P0311 - Adjustments for more correct shipment posting.
    // 005. 23-10-19 ZY-LD 000 - Don't import "On Hold".
    // 006. 15-11-19 ZY-LD P0340 - Loading Time.
    // 007. 08-01-20 ZY-LD P0361 - COMMIT is added, we the post-function can be called.
    // 008. 10-01-20 ZY-LD 000 - Send e-mail when error.
    // 009. 15-03-20 ZY-LD 000 - Test for blocked customer.
    // 010. 30-03-20 ZY-LD 2020032710000085 - Lock the table to avoid deadlocks.
    // 011. 22-04-20 ZY-LD 000 - We will always download and import, but not always post it.
    // 012. 18-09-21 ZY-LD 2021061810000102 - Update only if quantity is different from zero. Then we can see when it was set to zero.
    // 013. 26-01-21 ZY-LD 2021102610000035 - An item in NAV has been moved to another item no., but it has not been moved at the warehouse, so there is a mix in the item numbers.
    // 014. 21-12-21 ZY-LD 000 - On the old way, it send an e-mail every 5 min, and that was a problem in the weekend.
    // 015. 21-04-22 ZY-LD 2022042010000092 - Update only dates if fields are blank.
    // 016. 28-04-22 ZY-LD 000 - It had to loop throuth twice to get it correct updated.
    // 017. 28-04-22 ZY-LD 000 - We need to have more validations, so a separate function has been created.
    // 018. 06-05-22 ZY-LD 000 - We need the possibility to block single responses with error.
    // 019. 18-05-22 ZY-LD 2022011110000088 - We need to receipt post the freight costs, so it can be posted on the invoice.
    // 020. 09-06-22 ZY-LD 2022060910000038 - Previous we received the status "Ready to Pick" from VCK right away, and we use that status for some reports in PP. Now we update the status here, because it´s the easiest solution.
    // 021. 17-08-22 ZY-LD 2022081710000046 - Filter on line no., to get the right document no.
    // 022. 23-08-22 ZY-LD 000 - We wan´t to receipt post eCommerce, when it´s in transit.
    // 023. 21-09-22 ZY-LD 2022092010000074 - Dates was only updated the first time we saw them. That gave a wrong delivery date.
    // 024. 03-10-22 ZY-LD 2022092010000047 - Update Gross weight.
    // 025. 26-10-22 ZY-LD 2022102510000071 - We don´t need this on the header, only the lines.
    // 026. 23-01-23 ZY-LD 000 - Send e-mail, if no of serial numbers is missing.
    // 027. 10-03-23 ZY-LD 000 - Different solution made to receipt post eCommerce.
    // 028. 04-05-23 ZY-LD 000 - Set a proper errormessage.
    // 029. 24-10-23 ZY-LD 000 - The record needs to be reset before posting.
    // 030. 08-04-24 ZY-LD 000 - It happens that we delete a line from the delivery document, but the warehouse send it anyway. The order handler is informed about it.
    // 031. 08-07-24 ZY-LD 000 - If an error occurec, the warehuse status was updated on the DD, and in the next run was the posting skipped.

    trigger OnRun()
    begin
        DownloadVCK(0, true);
        PostShipOrderResp('');
    end;

    var
        VisionFTPMgt: Codeunit "VisionFTP Management";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";

    procedure DownloadAndPostShippingResponse(pRespNo: Code[20]; ForcePosting: Boolean)
    var
        recAutoSetup: Record "Automation Setup";
    begin
        DownloadVCK(2, true);
        //>> 22-04-20 ZY-LD 011
        recAutoSetup.Get();
        if recAutoSetup.WhseOutbPostingAllowed or
           (recAutoSetup."Post Outbound Response" and ForcePosting)
        then  //<< 22-04-20 ZY-LD 011
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
        recRespHead: Record "Ship Response Header";
        recRespHead2: Record "Ship Response Header";
        recRespHead3: Record "Ship Response Header";
        recRespLine: Record "Ship Response Line";
        recAutoSetup: Record "Automation Setup";
        ArchiveFile: File;
        NVInStream: InStream;
        xmlShipOrderResp: XmlPort "Read Shipping Order Response";
        lText001: Label 'Import VCK Response';
        lText002: Label 'Document could not open.';
        ImportErrorOccured: Boolean;
        repIdentifyIdenticalSerialNo: Report "Identify Identical Serial No.";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        lText003: Label 'There are error(s) on serial no.';
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText004: Label '%1 - %2.xlsx';
        LastErrorText: Text;
    begin
        //>> 30-03-20 ZY-LD 010
        //recRespHead.LockTable;
        //recRespLine.LockTable;
        //<< 30-03-20 ZY-LD 010
        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::"VCK Ship. Response");
        recZyFileMgt.SetRange(Open, true);
        recZyFileMgt.SetFilter("On Hold", '%1', '');  // 23-10-19 ZY-LD 005
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

                    Clear(xmlShipOrderResp);  // 14-06-19 ZY-LD 002
                    xmlShipOrderResp.Init(recZyFileMgt."Entry No.");
                    xmlShipOrderResp.SetSource(NVInStream);

                    LastErrorText := '';
                    ClearLastError();
                    if not xmlShipOrderResp.Import() then
                        LastErrorText := GetLastErrorText();

                    if LastErrorText = '' then begin
                        //>> 23-01-23 ZY-LD 026
                        if recRespHead2.FindLast() and (recRespHead2."Warehouse Status" = recRespHead2."Warehouse Status"::Packed) then begin
                            recRespHead2.SetRange("No.", recRespHead2."No.");

                            ServerFilename := FileMgt.ServerTempFileName('');
                            Clear(repIdentifyIdenticalSerialNo);
                            repIdentifyIdenticalSerialNo.SetTableView(recRespHead2);
                            repIdentifyIdenticalSerialNo.SaveAsExcel(ServerFilename);
                            if (recRespHead2."On Hold" = '') and repIdentifyIdenticalSerialNo.DifferenceLocated then begin
                                SI.SetMergefield(100, recRespHead2."Order No.");
                                SI.SetMergefield(101, Format(recRespHead2."Warehouse Status"));
                                SI.SetMergefield(102, recRespHead2."Customer Reference");

                                Clear(EmailAddMgt);
                                EmailAddMgt.CreateEmailWithAttachment('VCKSENOMIS', '', '', ServerFilename, StrSubstNo(lText004, recRespHead2."Order No.", recRespHead2."Customer Reference"), false);
                                EmailAddMgt.Send;
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
                                        recRespHead3.CloseResponse;
                                    until recRespHead3.Next() = 0;
                            end;
                        end;
                        //<< 23-01-23 ZY-LD 026

                        recZyFileMgt2.Open := false;
                        recZyFileMgt2."Error Text" := '';
                    end else
                        recZyFileMgt2."Error Text" := CopyStr(LastErrorText, 1, MaxStrLen(recZyFileMgt2."Error Text"));

                    recZyFileMgt2.Modify();
                    ArchiveFile.Close();
                end else begin
                    recZyFileMgt2."Error Text" := lText002;  // 14-06-19 ZY-LD 002
                    recZyFileMgt2.Modify();  // 14-06-19 ZY-LD 002
                end;

                //>> 21-12-21 ZY-LD 014
                //ImportErrorOccured := recZyFileMgt."Error Text" <> '';  // 10-01-20 ZY-LD 008
                if recZyFileMgt2."Error Text" <> '' then begin
                    recAutoSetup.Get();
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today) then begin
                        Clear(EmailAddMgt);
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send;

                        recAutoSetup."Warehouse Import Error Date" := Today;
                        recAutoSetup.Modify();

                    end;
                end;

                Commit();
            //<< 21-12-21 ZY-LD 014
            until recZyFileMgt.Next() = 0;

            ZGT.CloseProgressWindow;

            //>> 21-12-21 ZY-LD 014
            //>> 10-01-20 ZY-LD 008
            /*IF ImportErrorOccured THEN BEGIN
              EmailAddMgt.CreateSimpleEmail('VCKIMPDOC','','');
              EmailAddMgt.Send;
            END;*/
            //<< 10-01-20 ZY-LD 008
            //<< 21-12-21 ZY-LD 014
        end;
    end;

    local procedure PostShipOrderResp(pRespNo: Code[20])
    var
        recRespHead: Record "Ship Response Header";
        recRespHead2: Record "Ship Response Header";
        recRespHead3: Record "Ship Response Header";
        recRespLine: Record "Ship Response Line";
        recWhseSetup: Record "Warehouse Setup";
        recTransfLine: Record "Transfer Line";
        recLocation: Record Location;
        recAutoSetup: Record "Automation Setup";
        recDelDocHead: Record "VCK Delivery Document Header";
        TriedToPost: Boolean;  // 08-07-24 ZY-LD 000
        PostResult: Boolean;
        repCngWhseStatus: Report "Change Warehouse Status";
        lText001: Label 'Posting Shipment Response';
        lText002: Label '"%1" is not setup in "%2".';
        lText003: Label 'Error: %1.';
        lText004: Label 'Check "%1" on the response lines.';
    begin
        //>> 30-03-20 ZY-LD 010
        recRespHead.LockTable;
        recRespLine.LockTable;
        //<< 30-03-20 ZY-LD 010
        //>> 08-01-20 ZY-LD 007
        recRespHead2.SetCurrentkey("Customer Reference", "Warehouse Status", Open);
        recRespHead3.SetCurrentkey("Customer Reference", "Warehouse Status", Open);
        //<< 08-01-20 ZY-LD 007
        recRespHead.SetCurrentkey("Customer Reference", "Warehouse Status", Open);
        recRespHead.SetAutoCalcFields("Delivery Document Type");
        recRespHead.SetRange(Open, true);
        recRespHead.SetFilter("On Hold", '%1', '');  // 06-05-22 ZY-LD 018
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

                //>> 08-01-20 ZY-LD 007
                recRespHead3.SetRange("Customer Reference", recRespHead."Customer Reference");
                recRespHead3.SetFilter("Warehouse Status", '<%1', recRespHead."Warehouse Status");
                recRespHead3.SetRange(Open, true);
                if recRespHead3.IsEmpty() then begin  //<< 08-01-20 ZY-LD 007
                                                      // Ship Post
                    recRespHead2.Reset();  // 10-03-23 ZY-LD 027
                    recRespHead2.SetRange("Customer Reference", recRespHead."Customer Reference");
                    recRespHead2.SetFilter("No.", '<>%1', recRespHead."No.");
                    recRespHead2.SetRange("Ship Posted", true);

                    TriedToPost := false;  // 08-07-24 ZY-LD 000 031
                    PostResult := false;  // 08-07-24 ZY-LD 000 031
                    if (recRespHead."Warehouse Status" >= recWhseSetup."When Can We Post Resp. VCK") and
                       (not recRespHead2.FindFirst())  // Searching for previous posted responce.
                    then begin
                        recRespLine.SetCurrentkey("Response No.", "Customer Order No.", "Customer Order Line No.");
                        recRespLine.SetAutoCalcFields("Warehouse Status");
                        recRespLine.SetRange("Response No.", recRespHead."No.");
                        recRespLine.SetRange(Open, true);
                        if recRespLine.FindSet() then begin
                            recRespHead."After Post Description" := '';  // 30-09-19 ZY-LD 004
                            recRespHead."Ship Posted" := true;  // 30-09-19 ZY-LD 004
                            TriedToPost := true;  // 08-07-24 ZY-LD 000 031

                            repeat
                                recRespLine.SetRange("Customer Order No.", recRespLine."Customer Order No.");
                                //>> 01-12-20 ZY-LD 012
                                //IF NOT PostShipOrderRespDoc(recRespHead,recRespLine) THEN BEGIN
                                case recRespHead."Delivery Document Type" of
                                    recRespHead."delivery document type"::Sales:
                                        PostResult := PostShipOrderRespDoc(recRespHead, recRespLine);
                                    recRespHead."delivery document type"::Transfer:
                                        PostResult := PostTransOrderRespDoc(recRespHead, recRespLine);
                                end;
                                //<< 01-12-20 ZY-LD 012

                                if not PostResult then begin  // 01-12-20 ZY-LD 012
                                    recRespHead."Ship Posted" := false;  // 30-09-19 ZY-LD 004
                                    recRespHead.CalcFields("Lines With Error");
                                    if recRespHead."Lines With Error" and (recRespHead."After Post Description" = '') then
                                        recRespHead."After Post Description" := StrSubstNo(lText004, recRespLine.FieldCaption("Error Text"));
                                end else
                                    //>> 10-03-23 ZY-LD 027
                                    //>> 23-08-22 ZY-LD 022
                                    /*IF recRespHead."Delivery Document Type" = recRespHead."Delivery Document Type"::Transfer THEN
                                      IF recTransfLine.GET(recRespLine."Customer Order No.",recRespLine."Customer Order Line No.") THEN
                                        IF recLocation.GET(recTransfLine."Transfer-to Code") AND recLocation."Post Transf. Rcpt on Transit" THEN BEGIN
                                          COMMIT;
                                          CLEAR(repCngWhseStatus);
                                          repCngWhseStatus.InitReport(recRespHead."Customer Reference",9,2,FALSE);
                                          repCngWhseStatus.USEREQUESTPAGE(FALSE);
                                          repCngWhseStatus.RUNMODAL;
                                        END;*/
                                    //<< 23-08-22 ZY-LD 022
                                    //<< 10-03-23 ZY-LD 027

                                    if not recRespLine.FindLast() then;
                                recRespLine.SetRange("Customer Order No.");
                            until recRespLine.Next() = 0;
                        end;
                    end;

                    // Receipt Post
                    //>> 10-03-23 ZY-LD 027
                    /*IF (recRespHead."Delivery Document Type" = recRespHead."Delivery Document Type"::Transfer) AND
                       (recRespHead."Warehouse Status" = recRespHead."Warehouse Status"::Delivered)*/
                    recAutoSetup.Get();
                    if recDelDocHead.Get(recRespHead."Customer Reference") then begin
                        if not recLocation.Get(recDelDocHead."Bill-to Customer No.") then
                            Clear(recLocation);
                        if (recRespHead."Delivery Document Type" = recRespHead."delivery document type"::Transfer) and
                           ((recLocation."Post Transf. Rcpt on Transit" and (recRespHead."Warehouse Status" >= recAutoSetup."Rcpt. Post Transf Whse. Status")) or
                            (recRespHead."Warehouse Status" = recRespHead."warehouse status"::Delivered)) and
                           (Date2dmy(Today, 2) < 12)  //<< 10-03-23 ZY-LD 027
                        then begin
                            recRespHead2.Reset();  // 10-03-23 ZY-LD 027
                            recRespHead2.SetRange("Customer Reference", recRespHead."Customer Reference");
                            recRespHead2.SetFilter("No.", '<>%1', recRespHead."No.");
                            recRespHead2.SetRange("Receipt Posted", true);

                            //>> 10-03-23 ZY-LD 027
                            /*IF (recRespHead."Warehouse Status" = recRespHead."Warehouse Status"::Delivered) AND
                               (NOT recRespHead2.FINDFIRST)  // Searching for previous posted responce.*/
                            if not recRespHead2.FindFirst() then begin  // Searching for previous posted responce.  //<< 10-03-23 ZY-LD 027
                                recRespLine.Reset();
                                recRespLine.SetCurrentkey("Response No.", "Customer Order No.", "Customer Order Line No.");
                                recRespLine.SetAutoCalcFields("Warehouse Status");
                                recRespLine.SetRange("Response No.", recRespHead."No.");
                                recRespLine.SetRange("Open - Receipt", true);
                                if recRespLine.FindSet() then begin
                                    recRespHead."After Post Description" := '';  // 30-09-19 ZY-LD 004
                                    recRespHead."Receipt Posted" := true;  // 30-09-19 ZY-LD 004

                                    repeat
                                        recRespLine.SetRange("Customer Order No.", recRespLine."Customer Order No.");
                                        PostResult := PostTransOrderRespDoc_Receipt(recRespHead, recRespLine);

                                        if not PostResult then begin  // 01-12-20 ZY-LD 012
                                            recRespHead."Receipt Posted" := false;  // 30-09-19 ZY-LD 004
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
                    recRespHead.Modify();  // 30-09-19 ZY-LD 004
                    Commit();
                end;
            until recRespHead.Next() = 0;

            ZGT.CloseProgressWindow;
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
        ChangeLog: Record "Change Log Entry";  // 08-04-24 ZY-LD 030
        MailAddMgt: Codeunit "E-mail Address Management";  // 08-04-24 ZY-LD 030
        RespBodyInStream: InStream;
        ResponseXmlDoc: dotnet XmlDocument;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        SerialNodes: dotnet XmlNodeList;
        SerialNode: dotnet XmlNode;
        i: Integer;
        ArchiveFile: File;
        ErrorText: Text;
        XmlHeadStatus: Text[10];
        XmlHeadLocation: Text[10];
        XmlHeadOrderNo: Code[20];
        XmlPurchOrderNo: Code[20];
        XmlPurchOrderLineNo: Integer;
        XmlQuantity: Integer;
        XmlItemNo: Code[20];
        XmlVendInvNo: Code[20];
        GetSourceDocoutbound: Codeunit "Get Source Doc. Outbound";
        lText001: Label 'There are differences on Purchase Order No. in document "%1".';
        lText002: Label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        PostWhseShipment: Boolean;
        lText004: Label 'Warehouse Request was not found.';
        lText005: Label 'You cannot handle more than the outstanding %1 units.';
        WhseRequestFound: Boolean;
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
            recSalesHead.SetAutoCalcFields("Completely Shipped", "Completely Invoiced");  // 09-05-19 ZY-LD 001  // 24-06-19 ZY-LD 003
            if not recSalesHead.Get(recSalesHead."document type"::Order, precRespLine."Customer Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Customer Order No.");
                precRespHead.Modify();
            end else
                if (not recSalesHead."Completely Shipped") and (not recSalesHead."Completely Invoiced") then begin  // 09-05-19 ZY-LD 001  // 24-06-19 ZY-LD 003
                    if recCust.Get(recSalesHead."Sell-to Customer No.") and (recCust.Blocked = recCust.Blocked::" ") then begin  // 15-03-20 ZY-LD 009
                                                                                                                                 //>> 30-09-19 ZY-LD 004
                        if recSalesHead.Status = recSalesHead.Status::Open then
                            ReleaseSalesDocument.PerformManualRelease(recSalesHead);
                        //<< 30-09-19 ZY-LD 004
                        if GetSourceDocoutbound.CreateFromSalesOrderHideDialog(recSalesHead) then begin
                            recWhseShipHead.SetRange("Sales Order No.", recSalesHead."No.");
                            //WhseRequestFound := TRUE;
                            WhseRequestFound := recWhseShipHead.FindLast();
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify();
                            end;
                    end else begin
                        //>> 15-03-20 ZY-LD 009
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recCust."No.", recCust.Blocked);
                            precRespHead.Modify();
                        end;
                        //<< 15-03-20 ZY-LD 009
                    end;
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
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    //IF recRespLine."Warehouse Status" > recRespLine."Warehouse Status"::"Invoice Received" THEN BEGIN - Moved up
                    recWhseShipLine.SetRange("Source Type", Database::"Sales Line");
                    recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Sales Order");
                    recWhseShipLine.SetRange("Source No.", precRespLine."Customer Order No.");
                    recWhseShipLine.SetRange("Source Line No.", recRespLine."Customer Order Line No.");
                    if recWhseShipLine.FindFirst() then begin
                        //>> 26-01-21 ZY-LD 013
                        //IF recRespLine."Product No." = recWhseShipLine."Item No." THEN BEGIN
                        ProductNo := recRespLine."Product No.";
                        if ProductNo <> recWhseShipLine."Item No." then
                            if recItemIdentifier.Get(ProductNo) then begin
                                ProductNo := recItemIdentifier."Item No.";
                                recRespLine."Alt. Product No." := recItemIdentifier."Item No.";
                            end;

                        //IF ProductNo = recWhseShipLine."Item No." THEN BEGIN  //<< 26-01-21 ZY-LD 013
                        if ValidateShipOrderRespLine(recRespLine, recWhseShipLine, ProductNo, ErrorText) then begin  // 28-04-22 ZY-LD 017
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
                            //recRespLine."Error Text" := STRSUBSTNO(lText003,recWhseShipLine.FieldCaption("Item No."),recRespLine.TABLECAPTION,recWhseShipLine.TABLECAPTION,recRespLine."Line No.");  // 28-04-22 ZY-LD 017
                            recRespLine."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(recRespLine."Error Text"));  // 28-04-22 ZY-LD 017
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
                //END;
                until recRespLine.Next() = 0;

                //>> 18-05-22 ZY-LD 019
                recDelDocLine.Reset();
                recDelDocLine.SetRange("Document No.", precRespHead."Customer Reference");
                recDelDocLine.SetRange("Sales Order No.", precRespLine."Customer Order No.");  // 24-05-24 ZY-LD 000 - It must be the same sales order as the response lines.
                recDelDocLine.SetRange("Freight Cost Item", true);
                recDelDocLine.SetRange(Posted, false);
                if recDelDocLine.FindSet() then
                    repeat
                        recWhseShipLine.SetRange("Source Type", Database::"Sales Line");
                        recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Sales Order");
                        recWhseShipLine.SetRange("Source No.", recDelDocLine."Sales Order No.");
                        recWhseShipLine.SetRange("Source Line No.", recDelDocLine."Sales Order Line No.");
                        if recWhseShipLine.FindFirst() then begin
                            if (recWhseShipLine."Qty. to Ship" + recDelDocLine.Quantity) <= recWhseShipLine."Qty. Outstanding" then begin
                                recWhseShipLine.Validate("Qty. to Ship", recWhseShipLine."Qty. to Ship" + recDelDocLine.Quantity);
                                recWhseShipLine.Validate("Posted By AIT", true);
                                recWhseShipLine.Modify(true);

                                PostWhseShipment := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseShipLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end;
                    until recDelDocLine.Next() = 0;
                recWhseShipLine.SetRange("Source Line No.");
                //<< 18-05-22 ZY-LD 019

                // Post warehouse request
                if PostWhseShipment then begin
                    Commit();  // 08-01-20 ZY-LD 007
                    WhsePostShipment.SetPostingSettings(false);
                    WhsePostShipment.SetPrint(false);
                    if WhsePostShipment.Run(recWhseShipLine) then  // 08-01-20 ZY-LD 007 - If is added.
                        PostResultOK := WhsePostShipment.GetCounterSourceDocOK() = 1;  // 30-09-19 ZY-LD 004
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

                    //>> 30-09-19 ZY-LD 004
                    //        rValue := TRUE;
                    //      END ELSE
                    //        IF precRespHead."After Post Description" = '' THEN BEGIN
                    //          precRespHead."After Post Description" := COPYSTR(GETLASTERRORTEXT,1,MAXSTRLEN(precRespHead."After Post Description"));
                    //          precRespHead.MODIFY;
                    //        END;
                    //<< 30-09-19 ZY-LD 004

                    Clear(WhsePostShipment);
                end;
            end else
                PostResultOK := true;  // 30-09-19 ZY-LD 004
        end else begin
            //>> 30-09-19 ZY-LD 004
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
                        //>> 08-04-24 ZY-LD 030
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
                        //<< 08-04-24 ZY-LD 030

                        recRespLine."Error Text" := lText004;
                    End;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

            //  IF precRespHead."After Post Description" = '' THEN BEGIN
            //    precRespHead."After Post Description" := lText004;
            //    precRespHead.MODIFY;
            //  END;
            //<< 30-09-19 ZY-LD 004
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
                //>> 04-05-23 ZY-LD 028
                if pErrorText = '' then begin
                    recItem.SetRange("Location Filter", pRespLine.Location);
                    recItem.SetAutoCalcFields(Inventory);
                    recItem.Get(pProductNo);
                    if recItem.Inventory < pRespLine.Quantity then
                        pErrorText := StrSubstNo(lText005, recItem.Inventory);
                end;
                //<< 04-05-23 ZY-LD 028
            end;
        exit(pErrorText = '');
        //<< 28-04-22 ZY-LD 017
    end;

    local procedure PostTransOrderRespDoc(var precRespHead: Record "Ship Response Header"; precRespLine: Record "Ship Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Ship Response Line";
        recRespLineTmp: Record "Ship Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseShipHead: Record "Warehouse Shipment Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recLocation: Record Location;
        RespBodyInStream: InStream;
        ResponseXmlDoc: dotnet XmlDocument;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        SerialNodes: dotnet XmlNodeList;
        SerialNode: dotnet XmlNode;
        i: Integer;
        ArchiveFile: File;
        XmlHeadStatus: Text[10];
        XmlHeadLocation: Text[10];
        XmlHeadOrderNo: Code[20];
        XmlPurchOrderNo: Code[20];
        XmlPurchOrderLineNo: Integer;
        XmlQuantity: Integer;
        XmlItemNo: Code[20];
        XmlVendInvNo: Code[20];
        GetSourceDocoutbound: Codeunit "Get Source Doc. Outbound";
        lText001: Label 'There are differences on Purchase Order No. in document "%1".';
        lText002: Label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseShipment: Boolean;
        lText004: Label 'Warehouse Request was not found.';
        lText005: Label 'You cannot handle more than the outstanding %1 units.';
        WhseRequestFound: Boolean;
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
            recTransHead.SetAutoCalcFields("Completely Shipped", "Completely Received");  // 09-05-19 ZY-LD 001  // 24-06-19 ZY-LD 003
            if not recTransHead.Get(precRespLine."Customer Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Customer Order No.");
                precRespHead.Modify();
            end else
                if (not recTransHead."Completely Shipped") and (not recTransHead."Completely Received") then begin  // 09-05-19 ZY-LD 001  // 24-06-19 ZY-LD 003
                    if recLocation.Get(recTransHead."Transfer-from Code") and (recLocation."In Use") then begin  // 15-03-20 ZY-LD 009
                                                                                                                 //>> 30-09-19 ZY-LD 004
                        if recTransHead.Status = recTransHead.Status::Open then
                            ReleaseTransferDocument.Run(recTransHead);

                        //<< 30-09-19 ZY-LD 004
                        if GetSourceDocoutbound.CreateFromOutbndTransferOrderHideDialog(recTransHead) then begin
                            recWhseShipHead.SetRange("Sales Order No.", recTransHead."No.");
                            //WhseRequestFound := TRUE;
                            WhseRequestFound := recWhseShipHead.FindLast();
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify();
                            end;
                    end else begin
                        //>> 15-03-20 ZY-LD 009
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recTransHead."Transfer-from Code");
                            precRespHead.Modify();
                        end;
                        //<< 15-03-20 ZY-LD 009
                    end;
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
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    //IF recRespLine."Warehouse Status" > recRespLine."Warehouse Status"::"Invoice Received" THEN BEGIN - Moved up
                    recWhseShipLine.SetRange("Source Type", Database::"Transfer Line");
                    recWhseShipLine.SetRange("Source Document", recWhseShipLine."source document"::"Outbound Transfer");
                    recWhseShipLine.SetRange("Source No.", precRespLine."Customer Order No.");
                    recWhseShipLine.SetRange("Source Line No.", recRespLine."Customer Order Line No.");
                    if recWhseShipLine.FindFirst() then begin
                        //IF recRespLine."Product No." = recWhseShipLine."Item No." THEN BEGIN  // 04-05-23 ZY-LD 028
                        if ValidateTransOrderRespLine(precRespLine, recWhseShipLine, recRespLine."Product No.", ErrorText) then begin  // 04-05-23 ZY-LD 028
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
                            //recRespLine."Error Text" := STRSUBSTNO(lText003,recWhseShipLine.FieldCaption("Item No."),recRespLine.TABLECAPTION,recWhseShipLine.TABLECAPTION,recRespLine."Line No.");  // 04-05-23 ZY-LD 028
                            recRespLine."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(recRespLine."Error Text"));  // 04-05-23 ZY-LD 028
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
                //END;
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseShipment then begin
                    Commit();  // 08-01-20 ZY-LD 007
                    WhsePostShipment.SetPostingSettings(false);
                    WhsePostShipment.SetPrint(false);
                    if WhsePostShipment.Run(recWhseShipLine) then  // 08-01-20 ZY-LD 007 - If is added.
                        PostResultOK := WhsePostShipment.GetCounterSourceDocOK() = 1;  // 30-09-19 ZY-LD 004
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

                    //>> 30-09-19 ZY-LD 004
                    //        rValue := TRUE;
                    //      END ELSE
                    //        IF precRespHead."After Post Description" = '' THEN BEGIN
                    //          precRespHead."After Post Description" := COPYSTR(GETLASTERRORTEXT,1,MAXSTRLEN(precRespHead."After Post Description"));
                    //          precRespHead.MODIFY;
                    //        END;
                    //<< 30-09-19 ZY-LD 004

                    Clear(WhsePostShipment);
                end;
            end else
                PostResultOK := true;  // 30-09-19 ZY-LD 004
        end else begin
            //>> 30-09-19 ZY-LD 004
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
                        recRespLine.Open := false;  // 24-05-24 ZY-LD 000 - Transfer orders is deleted when posted.
                    end;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

            //  IF precRespHead."After Post Description" = '' THEN BEGIN
            //    precRespHead."After Post Description" := lText004;
            //    precRespHead.MODIFY;
            //  END;
            //<< 30-09-19 ZY-LD 004
        end;
    end;

    local procedure ValidateTransOrderRespLine(pRespLine: Record "Ship Response Line"; pWhseShipLine: Record "Warehouse Shipment Line"; pProductNo: Code[20]; var pErrorText: Text): Boolean
    var
        lText001: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText002: Label '"%1" must not be 0,00 on %4 sales order %2 line no. %3.';
        lText003: Label '"%1" must be 0,00 on %4 sales order %2 line no. %3.';
        lText004: Label '"%1" must be identical to "%5" on %4 sales order %2 line no. %3.';
        recItem: Record Item;
        lText005: Label 'Inventory "%1" is less that the quantity shipped "%2".';
    begin
        //>> 04-05-23 ZY-LD 028
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
        //<< 04-05-23 ZY-LD 028
    end;

    local procedure PostTransOrderRespDoc_Receipt(var precRespHead: Record "Ship Response Header"; precRespLine: Record "Ship Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Ship Response Line";
        recRespLineTmp: Record "Ship Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        recVend: Record Vendor;
        RespBodyInStream: InStream;
        ResponseXmlDoc: dotnet XmlDocument;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        SerialNodes: dotnet XmlNodeList;
        SerialNode: dotnet XmlNode;
        i: Integer;
        ArchiveFile: File;
        XmlHeadStatus: Text[10];
        XmlHeadLocation: Text[10];
        XmlHeadOrderNo: Code[20];
        XmlPurchOrderNo: Code[20];
        XmlPurchOrderLineNo: Integer;
        XmlQuantity: Integer;
        XmlItemNo: Code[20];
        XmlVendInvNo: Code[20];
        lText001: Label 'There are differences on Purchase Order No. in document "%1".';
        lText002: Label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: Label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseReceipt: Boolean;
        lText004: Label 'Warehouse Request was not found.';
        lText005: Label 'You cannot handle more than the outstanding %1 units.';
        WhseRequestFound: Boolean;
        lText006: Label 'Transfer Order "%1" was not found.';
    begin
        // Find Warehouse request
        recWhseRcptLine.SetRange("Source Type", Database::"Transfer Line");
        recWhseRcptLine.SetRange("Source Document", recWhseRcptLine."source document"::"Inbound Transfer");
        recWhseRcptLine.SetRange("Source No.", precRespLine."Customer Order No.");
        recWhseRcptLine.SetRange("Source Line No.", precRespLine."Customer Order Line No.");  // 17-08-22 ZY-LD 021
        //SetWhseRcptLineFilter(precRespHead."Order Type Option",precRespLine,recWhseRcptLine,FALSE);
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
        recWhseRcptLine.SetRange("Source Line No.");  // 17-08-22 ZY-LD 021

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
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
            //recRespLine.SETAUTOCALCFIELDS("Warehouse Status","Sales Order Qty. Shipped","Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Sales Order No.", precRespLine."Sales Order No.");
            recRespLine.SetRange("Customer Order No.", precRespLine."Customer Order No.");
            //recRespLine.SETRANGE("Delivery Document Line Posted",FALSE);
            recRespLine.SetRange("Open - Receipt", true);
            //recRespLine.SETAUTOCALCFIELDS("Real Source Order No.","Real Source Order Line No.","Invoice No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    //SetWhseRcptLineFilter(precRespHead."Order Type Option",recRespLine,recWhseRcptLine,TRUE);
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
                    recWhseRcptLine.RESET;  // 24-10-23 ZY-LD 029
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
        if GuiAllowed() or recWhseSetup.WhsePostingAllowed then begin
            ZGT.OpenProgressWindow(lText001, 1);
            ZGT.UpdateProgressWindow(lText001, 0, true);
            recWarehouse.SetRange(Warehouse, recWarehouse.Warehouse::VCK);
            recWarehouse.FindFirst();
            recWarehouse.TestField("Warehouse Outbound FTP Code");
            FtpMgt.DownloadFolder(recWarehouse."Warehouse Outbound FTP Code");
            ZGT.CloseProgressWindow;

            if Import then
                case Type of
                    Type::"VCK Ship. Response":
                        ShipOrderRespImport(0);
                    else begin
                        ShipOrderRespImport(0);
                    end;
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
        lText001: Label 'Warehouse Status on DD is %1, and therefore not updated.';
        recAutoSetup: Record "Automation Setup";
        recItem: Record Item;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        PrintReport: Boolean;
    begin
        if not recRespHead."Lines With Error" then  // 30-09-19 ZY-LD 004
            if recDelDocHead.Get(recRespHead."Customer Reference") and
               (recRespHead."Warehouse Status" > recDelDocHead."Warehouse Status") and
               (TriedToPost = PostResult)  // 08-07-24 ZY-LD 000 031
            then begin
                recAutoSetup.Get();  // 28-04-22 ZY-LD 016
                                     //IF NOT "Delivery Document is Updated" THEN BEGIN  // 26-10-22 ZY-LD 025
                                     //>> 09-06-22 ZY-LD 020
                if recRespHead."Warehouse Status" = recRespHead."warehouse status"::New then
                    recDelDocHead."Warehouse Status" := recRespHead."warehouse status"::"Ready to Pick"
                else  //<< 09-06-22 ZY-LD 020
                    recDelDocHead."Warehouse Status" := recRespHead."Warehouse Status";
                //>> 21-09-22 ZY-LD 023
                /*IF recDelDocHead."Picking Date Time" = '' THEN  // 21-04-22 ZY-LD
                  recDelDocHead."Picking Date Time" := FORMAT("Picking Date Time");
                IF recDelDocHead.PickDate = 0D THEN
                  recDelDocHead.PickDate := DT2DATE("Picking Date Time");  // 10-05-19 ZY-LD 002
                IF recDelDocHead."Loading Date Time" = '' THEN
                  recDelDocHead."Loading Date Time" := FORMAT("Loading Date Time");
                IF recDelDocHead."Loading Date" = 0DT THEN
                  recDelDocHead."Loading Date" := "Loading Date Time";  // 15-11-19 ZY-LD 006
                IF recDelDocHead."Delivery Date Time" = '' THEN
                  recDelDocHead."Delivery Date Time" := FORMAT("Delivery Date Time");*/
                if (recRespHead."Warehouse Status" = recRespHead."warehouse status"::Picking) and
                   (recRespHead."Picking Date Time" <> 0DT)
                then begin
                    recDelDocHead."Picking Date Time" := Format(recRespHead."Picking Date Time");
                    recDelDocHead.PickDate := Dt2Date(recRespHead."Picking Date Time");
                end;
                //>> 03-10-22 ZY-LD 024
                if recRespHead."Warehouse Status" = recRespHead."warehouse status"::Packed then
                    recDelDocHead.Weight := recRespHead.Weight;
                //<< 03-10-22 ZY-LD 024
                if (recRespHead."Warehouse Status" = recRespHead."warehouse status"::"In Transit") and
                   (recRespHead."Loading Date Time" <> 0DT)
                then begin
                    recDelDocHead."Loading Date Time" := Format(recRespHead."Loading Date Time");
                    recDelDocHead."Loading Date" := recRespHead."Loading Date Time";
                end;
                if recRespHead."Warehouse Status" = recRespHead."warehouse status"::Delivered then
                    recDelDocHead."Delivery Date Time" := Format(recRespHead."Delivery Date Time");
                //<< 21-09-22 ZY-LD 023
                recDelDocHead."Delivery Remark" := recRespHead."Delivery Remark";
                recDelDocHead."Delivery Status" := recRespHead."Delivery Status";
                recDelDocHead."Receiver Reference" := recRespHead."Receiver Reference";
                recDelDocHead."Shipper Reference" := recRespHead."Customer Reference";
                recDelDocHead."Signed By" := recRespHead."Signed By";
                recDelDocHead."Order Acknowledged" := true;
                recDelDocHead.Modify();
                //END;

                recRespLine.SetAutoCalcFields(recRespLine."Sales Order Qty. Shipped", recRespLine."Sales Order Qty. Invoiced");  // 30-09-19 ZY-LD 004
                recRespLine.SetRange("Response No.", recRespHead."No.");
                if recRespLine.FindSet(true) then
                    repeat
                        if not recRespHead."Delivery Document is Updated" then begin
                            recDelDocLine.SetRange("Document No.", recRespLine."Sales Order No.");
                            recDelDocLine.SetRange("Line No.", recRespLine."Sales Order Line No.");
                            if recDelDocLine.FindFirst() then begin
                                if recDelDocLine.Quantity > 0 then
                                    recDelDocLine.Validate("Warehouse Status", recDelDocHead."Warehouse Status");  // 09-06-22 ZY-LD 020
                                recDelDocLine."Picking Date Time" := Format(recRespHead."Picking Date Time");
                                recDelDocLine.PickDate := Dt2Date(recRespHead."Picking Date Time");  // 10-05-19 ZY-LD 002
                                recDelDocLine."Loading Date Time" := Format(recRespHead."Loading Date Time");
                                recDelDocLine."Delivery Date Time" := Format(recRespHead."Delivery Date Time");
                                recDelDocLine."Delivery Remark" := recRespHead."Delivery Remark";
                                recDelDocLine."Delivery Status" := recRespHead."Delivery Status";
                                recDelDocLine."Receiver Reference" := recRespHead."Receiver Reference";
                                recDelDocLine."Shipper Reference" := recRespHead."Customer Reference";
                                recDelDocLine."Signed By" := recRespHead."Signed By";
                                recDelDocLine.Modify();

                                recShipRespSerialNo.SetRange("Response No.", recRespHead."No.");
                                recShipRespSerialNo.SetRange("Response Line No.", recRespLine."Response Line No.");
                                if recShipRespSerialNo.FindSet() then begin
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
                            end;

                            //>> 30-09-19 ZY-LD 004
                            if (recRespLine.Quantity = recRespLine."Sales Order Qty. Shipped") or
                               (recRespLine.Quantity = recRespLine."Sales Order Qty. Invoiced") or
                               (recDelDocHead."Warehouse Status" < recAutoSetup."Create Invoice on Whse. Status")  // 28-04-22 ZY-LD 016
                            then begin  //<< 30-09-19 ZY-LD 004
                                recRespLine.Open := false;
                                recRespLine.Modify();
                            end;
                        end;
                    until recRespLine.Next() = 0;

                if recDelDocHead."Warehouse Status" = recDelDocHead."warehouse status"::Packed then
                    recDelDocHead.EmailCustomsInvoice(true);  // 03-10-22 ZY-LD 024
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
