Codeunit 50062 "VCK Communication Management"
{
    trigger OnRun()
    begin
    end;

    var
        recWarehouse: Record Location;
        Warehouse: Code[20];
        Err003: label 'VCK Location Code Not Set in Sales & Receivables Setup.';

    local procedure CheckSettings()
    var
        recSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if recSalesReceivablesSetup.FindSet() then begin
            if StrLen(recSalesReceivablesSetup."All-In Logistics Location") = 0 then
                Error(Err003);
            Warehouse := recSalesReceivablesSetup."All-In Logistics Location";
        end;
    end;

    local procedure GetNextMessageNo("Code": Code[20]): Code[20]
    var
        NoSeriesMgt: Codeunit "No. Series"; //UpgradeReady
    begin
        exit(NoSeriesMgt.GetNextNo(Code, Today, true));
    end;


    procedure GetActionCodeDescription(ActionCode: Code[20]) Description: Text
    var
        recActionCodes: Record "Action Codes";
    begin
        recActionCodes.SetRange(Code, ActionCode);
        if recActionCodes.FindSet() then
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

    begin
        TimeDelimiter := StrPos(Date, 'T');
        if TimeDelimiter = 0 then
            exit;
        DateString := CopyStr(Date, 1, TimeDelimiter - 1);
        TimeString := CopyStr(Date, TimeDelimiter + 1, 8);
        Evaluate(d, CopyStr(DateString, 9, 2));
        Evaluate(m, CopyStr(DateString, 6, 2));
        Evaluate(y, CopyStr(DateString, 1, 4));
        if y < Date2dmy(Today, 3) then
            y := Date2dmy(Today, 3);
        dt := Dmy2date(d, m, y);
        Evaluate(tm, TimeString);
        retDateTime := CreateDatetime(dt, tm)
    end;


    procedure SendItem(ItemNoFilter: Text; SendAllItems: Boolean) rValue: Boolean
    var
        recItem: Record Item;
        i: Integer;
        StartNo: Code[20];
        EndNo: Code[20];
    begin
        CheckSettings();
        if SendAllItems then begin
            recItem.SetFilter(Status, '<>%1&<>%2&<>%3', recItem.Status::New, recItem.Status::Blocked, recItem.Status::Marketing);
            recItem.SetRange(Inactive, false);
            recItem.SetRange(Blocked, false);
        end else
            recItem.SetFilter("No.", ItemNoFilter);
        recItem.SetFilter("Tariff No.", '<>%1', '');
        recItem.SetRange("No Tariff Code", false);
        recItem.SetRange(IsEICard, false);
        recItem.SetRange("Gen. Prod. Posting Group", 'ZYXEL');

        if SendAllItems then begin
            if recItem.FindSet() then begin
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


    end;

    local procedure UploadFile(var pItem: Record Item): Boolean
    var
        recInvSetup: Record "Inventory Setup";
        FtpMgt: Codeunit "VisionFTP Management";
        tempblob: codeunit "Temp Blob";
        XmlPortSendReq: XmlPort "Send Items to VCK";
        varOutputStream: OutStream;
        MessageNo: Code[20];
        ServerFilename: Text;
        RemoteFilename: Text;
        lText001: label 'It was not possible to upload the file %1%2 to the warehouse. (SendItem).';
    begin
        // CLOUD READY NEW
        recInvSetup.Get();
        recInvSetup.TestField("AIT Location Code");
        GetWarehouse(recInvSetup."AIT Location Code");
        MessageNo := GetNextMessageNo(recWarehouse."Message Number Series");
        RemoteFilename := MessageNo + '.xml';
        tempblob.CreateOutstream(varOutputStream);
        XmlPortSendReq.SetTableview(pItem);
        XmlPortSendReq.SetParameters(recWarehouse."Customer ID", recWarehouse."Project ID", MessageNo);
        XmlPortSendReq.SetDestination(varOutputStream);
        XmlPortSendReq.Export();
        if not FtpMgt.UploadFilestream(recWarehouse."Warehouse Inbound FTP Code", tempblob, copystr(ServerFilename, 1, 250), RemoteFilename) then
            Error(lText001, MessageNo, '.xml')
        else
            exit(true);
    end;

    procedure SendStockLevelRequest(): Boolean
    var
        recInvSetup: Record "Inventory Setup";
        FtpMgt: Codeunit "VisionFTP Management";
        tempblob: codeunit "Temp Blob";
        XmlPortSendReq: XmlPort "Send Stock Level Request";
        varOutputStream: OutStream;
        MessageNo: Code[20];
        ServerFilename: Text;
        RemoteFilename: Text;

    begin
        // CLOUD ready new
        recInvSetup.Get();
        recInvSetup.TestField("AIT Location Code");
        GetWarehouse(recInvSetup."AIT Location Code");

        MessageNo := GetNextMessageNo(recWarehouse."Message Number Series");
        //ServerFilename := FileMgt.ServerTempFileName('xml');
        RemoteFilename := MessageNo + '.xml';
        tempblob.CreateOutstream(varOutputStream);
        XmlPortSendReq.SetDestination(varOutputStream);
        XmlPortSendReq.SetParameters(recWarehouse."Customer ID", recWarehouse."Project ID", MessageNo);
        XmlPortSendReq.Export();
        if FtpMgt.UploadFilestream(recWarehouse."Warehouse Inbound FTP Code", tempblob, copystr(ServerFilename, 1, 250), RemoteFilename) then
            exit(true)
        else
            exit(false);
    end;

    procedure SendWhseOutbOrderRequest(var pDelDocHead: Record "VCK Delivery Document Header") rValue: Boolean
    var
        recLocation: Record Location;
        recDDHeader: Record "VCK Delivery Document Header";
        recDelDocLine: Record "VCK Delivery Document Line";
        FtpMgt: Codeunit "VisionFTP Management";
        tempblob: codeunit "Temp Blob";
        XmlPortSendReq: XmlPort "Send Delivery Document";
        varOutputStream: OutStream;
        MessageNo: Code[20];
        ServerFilename: Text;
        RemoteFilename: Text;


        lText001: label 'Document No. %1 has been uploaded to %2.';
        ItemNoFilter: Text;
    begin
        // cloud ready new
        CheckSettings();
        if not pDelDocHead.SentToAllIn and (pDelDocHead."Document Status" = pDelDocHead."document status"::Released) then begin
            // Send the items to the warehouse
            recDelDocLine.SetRange("Document No.", pDelDocHead."No.");
            if recDelDocLine.FindSet() then begin
                repeat
                    if ItemNoFilter = '' then
                        ItemNoFilter := recDelDocLine."Item No."
                    else
                        if StrPos(ItemNoFilter, recDelDocLine."Item No.") = 0 then
                            ItemNoFilter += '|' + recDelDocLine."Item No.";
                until recDelDocLine.Next() = 0;
                SendItem(ItemNoFilter, false);
            end;

            recLocation.Get(pDelDocHead."Ship-From Code");
            recLocation.TestField(Warehouse);
            recLocation.TestField("Warehouse Inbound FTP Code");
            recLocation.TestField("Customer ID");
            recLocation.TestField("Project ID");
            recLocation.TestField("Message Number Series");

            MessageNo := GetNextMessageNo(recLocation."Message Number Series");
            RemoteFilename := MessageNo + '.xml';
            recDDHeader.SetRange("No.", pDelDocHead."No.");
            tempblob.CreateOutstream(varOutputStream);


            XmlPortSendReq.SetDestination(varOutputStream);
            XmlPortSendReq.SetTableview(recDDHeader);
            XmlPortSendReq.SetParameters(recLocation."Customer ID", recLocation."Project ID", MessageNo);
            XmlPortSendReq.Export();

            if FtpMgt.UploadFilestream(recLocation."Warehouse Inbound FTP Code", tempblob, copystr(ServerFilename, 1, 250), RemoteFilename) then begin
                pDelDocHead.SentToAllIn := true;
                pDelDocHead.Modify(true);
                Commit();
                rValue := true;

                if GuiAllowed() then
                    Message(lText001, pDelDocHead."No.", recLocation.Name);
            end;
        end;
    end;


    procedure SendInboundOrderRequest(var pWhseInbHead: Record "Warehouse Inbound Header") rValue: Boolean
    var
        recWarehouse: Record Location;
        recWhseInbLine: Record "VCK Shipping Detail";
        recWhseInbHead: Record "Warehouse Inbound Header";
        recItem: Record Item;
        FtpMgt: Codeunit "VisionFTP Management";
        tempblob: codeunit "Temp Blob";
        XmlPortSendReq: XmlPort "Send Inbound Order Request";
        varOutputStream: OutStream;
        ServerFilename: Text;
        RemoteFilename: Text;
        ItemNoFilter: Text;
        lText001: label '"Item No." %1 is unknown. You have to create it as an item or you have to rename it to a known item no.';
    begin
        if pWhseInbHead."Document Status" in [pWhseInbHead."document status"::Open, pWhseInbHead."document status"::Error] then begin

            pWhseInbHead."Document Status" := pWhseInbHead."document status"::Open;
            pWhseInbHead."Error Description" := '';

            recWhseInbLine.SetCurrentkey("Document No.", "Line No.");
            recWhseInbLine.SetRange("Document No.", pWhseInbHead."No.");
            if recWhseInbLine.FindSet() then
                repeat
                    if not recItem.Get(recWhseInbLine."Item No.") then begin
                        pWhseInbHead."Document Status" := pWhseInbHead."document status"::Error;
                        pWhseInbHead."Error Description" := StrSubstNo(lText001, recWhseInbLine."Item No.");
                        pWhseInbHead.Modify(true);
                    end;
                until recWhseInbLine.Next() = 0;

            if pWhseInbHead."Document Status" = pWhseInbHead."document status"::Open then begin
                if recWhseInbLine.FindSet() then begin
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
                pWhseInbHead."Message No." := copystr(GetNextMessageNo(recWarehouse."Message Number Series"), 1, 10);
                pWhseInbHead.Modify(true);
                RemoteFilename := pWhseInbHead."Message No." + '.xml';
                recWhseInbHead.SetRange("No.", pWhseInbHead."No.");
                tempblob.CreateOutstream(varOutputStream);

                XmlPortSendReq.SetDestination(varOutputStream);
                XmlPortSendReq.SetTableview(recWhseInbHead);
                XmlPortSendReq.Export();
                // Upload file
                if FtpMgt.UploadFileStream(recWarehouse."Warehouse Inbound FTP Code", tempblob, copystr(ServerFilename, 1, 250), RemoteFilename) then
                    rValue := true
                else begin
                    pWhseInbHead."Message No." := '';
                    pWhseInbHead.Modify(true);
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
