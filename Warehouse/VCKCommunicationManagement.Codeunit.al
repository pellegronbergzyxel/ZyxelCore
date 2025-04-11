Codeunit 50062 "VCK Communication Management"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 24-06-19 ZY-LD P0213 - Send items before releasing DD.
    // 003. 12-02-20 ZY-LD 000 - We want to get the error right away.
    // 004. 18-02-20 ZY-LD 000 - Corrects wrong entered year.
    // 005. 14-10-21 ZY-LD 2021101210000089 - We see dummy item numbers that doesn´t exist in our system. We have to handle them before sending it to the warehouse.
    // 006. 05-04-22 ZY-LD 000 - Changed filter when sending all items.
    // 007. 07-04-22 ZY-LD 000 - We don´t want to send service items to the warehouse.
    // 008. 20-02-23 ZY-LD 000 - In ZNet the file get too large to be uploaded at VCK.


    trigger OnRun()
    begin
    end;

    var
        Err001: label 'The location code of the VCK warehouse has not been set in the Sales & Receivables Setup.';
        Text001: label 'OR';
        Text002: label 'CL';
        Err002: label 'VCK Message Number Series Not Set in Sales & Receivables Setup.';
        Err003: label 'VCK Location Code Not Set in Sales & Receivables Setup.';
        Err004: label 'Customer ID Not Set in Sales & Receivables Setup.';
        Err005: label 'Project Code Not Set in Sales & Receivables Setup.';
        Text004: label 'STATUS_OK';
        Text005: label 'STATUS_WAITING';
        Text006: label 'STATUS_ERROR';
        Err006: label 'VCK FTP Upload Not Set in Sales & Receivables Setup.';
        Err007: label 'VCK FTP Download Not Set in Sales & Receivables Setup.';
        Err008: label 'FTP No Local Folder Set for %1.';
        Text007: label 'ShippingOrderResponse';
        Text008: label 'InventoryRequestResponse';
        Text009: label 'PurchaseOrderResponse';
        Text010: label '<OrderType>SO</OrderType>';
        Text011: label '<OrderType>TO</OrderType>';
        Err009: label 'Unknown File Type Encountered. Filename: %1';
        Text012: label 'Stock Level Imported.';
        Text013: label 'Stock Level Analysis View Re-built.';
        Text014: label 'Purchase Order Responce Imported.';
        Text015: label 'Shipping Order Responce Imported.';
        Text016: label 'Delivery Documents Updated,';
        Text017: label 'Serial Numbers Updated.';
        Text018: label 'File NOT Uploaded.';
        Text003: label 'File Uploaded successfully.';
        recWarehouse: Record Location;
        ProjectCode: Code[20];
        CustomerID: Code[20];
        Warehouse: Code[20];

    local procedure CheckSettings()
    var
        recSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if recSalesReceivablesSetup.FindSet then begin
            if StrLen(recSalesReceivablesSetup."All-In Logistics Location") = 0 then
                Error(Err003);
            Warehouse := recSalesReceivablesSetup."All-In Logistics Location";
        end;
    end;

    local procedure GetNextMessageNo("Code": Code[20]): Code[20]
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recSalesReceivablesSetup: Record "Sales & Receivables Setup";
        NextNo: Code[20];
    begin
        exit(NoSeriesMgt.GetNextNo(Code, Today, true));
    end;


    procedure GetActionCodeDescription(ActionCode: Code[20]) Description: Text
    var
        recActionCodes: Record "Action Codes";
    begin
        recActionCodes.SetRange(Code, ActionCode);
        if recActionCodes.FindSet then
            Description := recActionCodes.Description;
    end;


    procedure ConvertTextToDateTime(Date: Text) retDateTime: DateTime
    var
        TimeDelimiter: Integer;
        TimeString: Text;
        DateString: Text;
        dt: Date;
        tm: Time;
        d: Integer;
        m: Integer;
        y: Integer;
        hr: Integer;
        mn: Integer;
        se: Integer;
    begin
        TimeDelimiter := StrPos(Date, 'T');
        if TimeDelimiter = 0 then
            exit;
        DateString := CopyStr(Date, 1, TimeDelimiter - 1);
        TimeString := CopyStr(Date, TimeDelimiter + 1, 8);
        Evaluate(d, CopyStr(DateString, 9, 2));
        Evaluate(m, CopyStr(DateString, 6, 2));
        Evaluate(y, CopyStr(DateString, 1, 4));
        //>> 18-02-20 ZY-LD 004
        if y < Date2dmy(Today, 3) then
            y := Date2dmy(Today, 3);
        //<< 18-02-20 ZY-LD 004
        dt := Dmy2date(d, m, y);
        Evaluate(tm, TimeString);
        retDateTime := CreateDatetime(dt, tm)
    end;


    procedure SendItem(ItemNoFilter: Text; SendAllItems: Boolean) rValue: Boolean
    var
        recItem: Record Item;
        recInvSetup: Record "Inventory Setup";
        varOutputStream: OutStream;
        varXmlFile: File;
        MessageNo: Code[20];
        XmlPortSendReq: XmlPort "Send Items to VCK";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        RemoteFilename: Text;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'It was not possible to upload the file %1%2 to the warehouse. (SendItem).';
        i: Integer;
        StartNo: Code[20];
        EndNo: Code[20];
    begin
        CheckSettings;
        if SendAllItems then begin
            //recItem.SETFILTER(Status,'%1|%2|%3|%4|%5',recItem.Status::Live,recItem.Status::"Phase Out",recItem.Status::Spares,recItem.Status::Marketing,recItem.Status::Other);  // 05-04-22 ZY-LD 006
            recItem.SetFilter(Status, '<>%1&<>%2&<>%3', recItem.Status::New, recItem.Status::Blocked, recItem.Status::Marketing);  // 05-04-22 ZY-LD 006
            recItem.SetRange(Inactive, false);
            recItem.SetRange(Blocked, false);
        end else
            recItem.SetFilter("No.", ItemNoFilter);
        recItem.SetFilter("Tariff No.", '<>%1', '');
        recItem.SetRange("No Tariff Code", false);
        recItem.SetRange(IsEICard, false);
        recItem.SetRange("Gen. Prod. Posting Group", 'ZYXEL');  // 07-04-22 ZY-LD 007

        //>> 20-02-23 ZY-LD 008
        if SendAllItems then begin
            if recItem.FindSet then begin
                repeat
                    i += 1;
                    if StartNo = '' then
                        StartNo := recItem."No.";
                    EndNo := recItem."No.";

                    if i >= 500 then begin
                        recItem.SetRange("No.", StartNo, EndNo);
                        UploadFile(recItem);
                        recItem.SetRange("No.");
                        StartNo := '';
                        i := 0;
                    end;
                until recItem.Next() = 0;
                recItem.SetRange("No.", StartNo, EndNo);
                UploadFile(recItem);
            end;
        end else
            rValue := UploadFile(recItem);

        /*IF recItem.FINDFIRST THEN BEGIN
          recInvSetup.GET;
          recInvSetup.TESTFIELD("AIT Location Code");
          GetWarehouse(recInvSetup."AIT Location Code");
        
          MessageNo := GetNextMessageNo(recWarehouse."Message Number Series");
          ServerFilename := FileMgt.ServerTempFileName('xml');
          RemoteFilename := MessageNo + '.xml';
        
          varXmlFile.CREATE(ServerFilename);
          varXmlFile.CREATEOUTSTREAM(varOutputStream);
          XmlPortSendReq.SETDESTINATION(varOutputStream);
          XmlPortSendReq.SETTABLEVIEW(recItem);
          XmlPortSendReq.SetParameters(recWarehouse."Customer ID",recWarehouse."Project ID",MessageNo);
          XmlPortSendReq.EXPORT;
          varXmlFile.CLOSE;
          IF NOT FtpMgt.UploadFile(recWarehouse."Warehouse Inbound FTP Code",ServerFilename,RemoteFilename) THEN
            ERROR(lText001,MessageNo,'.xml')  // 12-02-20 ZY-LD 003
          ELSE
            EXIT(TRUE);
        //    WriteLogMessage(0,1,0,MessageNo + '.xml',recItem."No.",Text003);
        //    EXIT(TRUE);
        //  END ELSE BEGIN
        //    WriteLogMessage(1,1,0,MessageNo + '.xml',recItem."No.",Text018);
        //    EXIT(FALSE);
        //  END;
        END;*/
        //<< 20-02-23 ZY-LD 008

    end;

    local procedure UploadFile(var pItem: Record Item): Boolean
    var
        recInvSetup: Record "Inventory Setup";
        varOutputStream: OutStream;
        varXmlFile: File;
        MessageNo: Code[20];
        XmlPortSendReq: XmlPort "Send Items to VCK";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        RemoteFilename: Text;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'It was not possible to upload the file %1%2 to the warehouse. (SendItem).';
    begin
        recInvSetup.Get;
        recInvSetup.TestField("AIT Location Code");
        GetWarehouse(recInvSetup."AIT Location Code");

        MessageNo := GetNextMessageNo(recWarehouse."Message Number Series");
        ServerFilename := FileMgt.ServerTempFileName('xml');
        RemoteFilename := MessageNo + '.xml';

        varXmlFile.Create(ServerFilename);
        varXmlFile.CreateOutstream(varOutputStream);
        XmlPortSendReq.SetDestination(varOutputStream);
        XmlPortSendReq.SetTableview(pItem);
        XmlPortSendReq.SetParameters(recWarehouse."Customer ID", recWarehouse."Project ID", MessageNo);
        XmlPortSendReq.Export;
        varXmlFile.Close;
        if not FtpMgt.UploadFile(recWarehouse."Warehouse Inbound FTP Code", ServerFilename, RemoteFilename) then
            Error(lText001, MessageNo, '.xml')  // 12-02-20 ZY-LD 003
        else
            exit(true);
    end;


    procedure SendStockLevelRequest(): Boolean
    var
        varOutputStream: OutStream;
        varXmlFile: File;
        MessageNo: Code[20];
        XmlPortSendReq: XmlPort "Send Stock Level Request";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        RemoteFilename: Text;
        FtpMgt: Codeunit "VisionFTP Management";
        recInvSetup: Record "Inventory Setup";
    begin
        recInvSetup.Get;
        recInvSetup.TestField("AIT Location Code");
        GetWarehouse(recInvSetup."AIT Location Code");

        MessageNo := GetNextMessageNo(recWarehouse."Message Number Series");
        ServerFilename := FileMgt.ServerTempFileName('xml');
        RemoteFilename := MessageNo + '.xml';

        varXmlFile.Create(ServerFilename);
        varXmlFile.CreateOutstream(varOutputStream);
        XmlPortSendReq.SetDestination(varOutputStream);
        XmlPortSendReq.SetParameters(recWarehouse."Customer ID", recWarehouse."Project ID", MessageNo);
        XmlPortSendReq.Export;
        varXmlFile.Close;
        if FtpMgt.UploadFile(recWarehouse."Warehouse Inbound FTP Code", ServerFilename, RemoteFilename) then
            exit(true)
        else
            exit(false);
    end;


    procedure SendWhseOutbOrderRequest(var pDelDocHead: Record "VCK Delivery Document Header") rValue: Boolean
    var
        recLocation: Record Location;
        recDDHeader: Record "VCK Delivery Document Header";
        recDelDocLine: Record "VCK Delivery Document Line";
        varOutputStream: OutStream;
        varXmlFile: File;
        MessageNo: Code[20];
        XmlPortSendReq: XmlPort "Send Delivery Document";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        RemoteFilename: Text;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'Document No. %1 has been uploaded to %2.';
        ItemNoFilter: Text;
    begin
        CheckSettings;
        if not pDelDocHead.SentToAllIn and (pDelDocHead."Document Status" = pDelDocHead."document status"::Released) then begin
            //>> 24-06-19 ZY-LD 002
            // Send the items to the warehouse
            recDelDocLine.SetRange("Document No.", pDelDocHead."No.");
            if recDelDocLine.FindSet then begin
                repeat
                    if ItemNoFilter = '' then
                        ItemNoFilter := recDelDocLine."Item No."
                    else
                        if StrPos(ItemNoFilter, recDelDocLine."Item No.") = 0 then
                            ItemNoFilter += '|' + recDelDocLine."Item No.";
                until recDelDocLine.Next() = 0;
                SendItem(ItemNoFilter, false);
            end;
            //<< 24-06-19 ZY-LD 002

            recLocation.Get(pDelDocHead."Ship-From Code");
            recLocation.TestField(Warehouse);
            recLocation.TestField("Warehouse Inbound FTP Code");
            recLocation.TestField("Customer ID");
            recLocation.TestField("Project ID");
            recLocation.TestField("Message Number Series");

            MessageNo := GetNextMessageNo(recLocation."Message Number Series");
            ServerFilename := FileMgt.ServerTempFileName('xml');
            RemoteFilename := MessageNo + '.xml';
            recDDHeader.SetRange("No.", pDelDocHead."No.");
            varXmlFile.Create(ServerFilename);
            varXmlFile.CreateOutstream(varOutputStream);
            XmlPortSendReq.SetDestination(varOutputStream);
            XmlPortSendReq.SetTableview(recDDHeader);
            XmlPortSendReq.SetParameters(recLocation."Customer ID", recLocation."Project ID", MessageNo);
            XmlPortSendReq.Export;
            varXmlFile.Close;

            if FtpMgt.UploadFile(recLocation."Warehouse Inbound FTP Code", ServerFilename, RemoteFilename) then begin
                pDelDocHead.SentToAllIn := true;
                pDelDocHead.Modify(true);
                Commit;
                rValue := true;

                if GuiAllowed then
                    Message(lText001, pDelDocHead."No.", recLocation.Name);
            end;
            FileMgt.DeleteServerFile(ServerFilename);
        end;
    end;


    procedure SendInboundOrderRequest(var pWhseInbHead: Record "Warehouse Inbound Header") rValue: Boolean
    var
        recWarehouse: Record Location;
        recWhseInbLine: Record "VCK Shipping Detail";
        recWhseInbHead: Record "Warehouse Inbound Header";
        recItem: Record Item;
        varOutputStream: OutStream;
        varXmlFile: File;
        XmlPortSendReq: XmlPort "Send Inbound Order Request";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        RemoteFilename: Text;
        FtpMgt: Codeunit "VisionFTP Management";
        ItemNoFilter: Text;
        lText001: label '"Item No." %1 is unknown. You have to create it as an item or you have to rename it to a known item no.';
    begin
        begin
            //IF "Document Status" = "Document Status"::Open THEN BEGIN  // 14-10-21 ZY-LD 005
            if pWhseInbHead."Document Status" in [pWhseInbHead."document status"::Open, pWhseInbHead."document status"::Error] then begin  // 14-10-21 ZY-LD 005
                                                                                                                                           // Check the document before sending to the warehouse
                                                                                                                                           //>> 14-10-21 ZY-LD 005
                pWhseInbHead."Document Status" := pWhseInbHead."document status"::Open;
                pWhseInbHead."Error Description" := '';

                recWhseInbLine.SetCurrentkey("Document No.", "Line No.");
                recWhseInbLine.SetRange("Document No.", pWhseInbHead."No.");
                if recWhseInbLine.FindSet then
                    repeat
                        if not recItem.Get(recWhseInbLine."Item No.") then begin
                            pWhseInbHead."Document Status" := pWhseInbHead."document status"::Error;
                            pWhseInbHead."Error Description" := StrSubstNo(lText001, recWhseInbLine."Item No.");
                            pWhseInbHead.Modify(true);
                        end;
                    until recWhseInbLine.Next() = 0;
                //<< 14-10-21 ZY-LD 005

                if pWhseInbHead."Document Status" = pWhseInbHead."document status"::Open then begin
                    // Update Items at the VCK
                    //recWhseInbLine.SetCurrentKey("Document No.","Line No.");  // 14-10-21 ZY-LD 005
                    //recWhseInbLine.SETRANGE("Document No.","No.");  // 14-10-21 ZY-LD 005
                    if recWhseInbLine.FindSet then begin
                        repeat
                            if ItemNoFilter = '' then
                                ItemNoFilter := recWhseInbLine."Item No."
                            else
                                if StrPos(ItemNoFilter, recWhseInbLine."Item No.") = 0 then
                                    ItemNoFilter += '|' + recWhseInbLine."Item No.";
                        until recWhseInbLine.Next() = 0;
                        SendItem(ItemNoFilter, false);
                    end;

                    recWarehouse.Get(pWhseInbHead."Location Code");
                    recWarehouse.TestField(Warehouse);
                    recWarehouse.TestField("Warehouse Inbound FTP Code");
                    recWarehouse.TestField("Message Number Series");

                    // Create XML file
                    pWhseInbHead."Message No." := GetNextMessageNo(recWarehouse."Message Number Series");
                    pWhseInbHead.Modify(true);
                    ServerFilename := FileMgt.ServerTempFileName('xml');
                    RemoteFilename := pWhseInbHead."Message No." + '.xml';

                    recWhseInbHead.SetRange("No.", pWhseInbHead."No.");
                    varXmlFile.Create(ServerFilename);
                    varXmlFile.CreateOutstream(varOutputStream);
                    XmlPortSendReq.SetDestination(varOutputStream);
                    XmlPortSendReq.SetTableview(recWhseInbHead);
                    XmlPortSendReq.Export;
                    varXmlFile.Close;

                    // Upload file
                    if FtpMgt.UploadFile(recWarehouse."Warehouse Inbound FTP Code", ServerFilename, RemoteFilename) then
                        rValue := true
                    else begin
                        pWhseInbHead."Message No." := '';
                        pWhseInbHead.Modify(true);
                    end;
                    FileMgt.DeleteServerFile(ServerFilename);
                end;
            end;
        end;
    end;

    local procedure GetWarehouse(pLocationCode: Code[10])
    begin
        recWarehouse.Get(pLocationCode);
        recWarehouse.TestField(Warehouse);
        recWarehouse.TestField("Warehouse Inbound FTP Code");
        recWarehouse.TestField("Customer ID");
        recWarehouse.TestField("Project ID");
        recWarehouse.TestField("Message Number Series");
    end;
}
