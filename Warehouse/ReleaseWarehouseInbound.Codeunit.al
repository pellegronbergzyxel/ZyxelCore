Codeunit 50006 "Release Warehouse Inbound"
{
    // 001. 09-03-21 ZY-LD 2021030910000223 - We can move internal between locations.
    // 002. 14-10-21 ZY-LD 2021101210000089 - Document status can be "Error", and we have to handle that.

    TableNo = "Warehouse Inbound Header";

    trigger OnRun()
    var
        recLocation: Record Location;
        VCKComMgt: Codeunit "VCK Communication Management";
        SentToWarehouse: Boolean;
        ContainerDetailsSent: Boolean;
        lText001: label 'Inbound order %1 and container details has been sent.';
        lText002: label 'Inbound order %1 has been sent.';
        lText003: label 'Container details for %1 has been sent.';
    begin
        with Rec do begin
            //>> 09-03-21 ZY-LD 001
            //IF "Location Code" = ItemLogEvent.GetMainWarehouseLocation THEN BEGIN
            recLocation.Get("Location Code");
            if recLocation.Warehouse <> recLocation.Warehouse::" " then begin  //<< 09-03-21 ZY-LD 001
                if not "Sent To Warehouse" then
                    if VCKComMgt.SendInboundOrderRequest(Rec) then begin
                        Validate("Document Status", "document status"::Released);
                        "Sent To Warehouse" := true;
                        "Sent to Warehouse Date" := "Last Status Update Date";
                        Modify;
                        Commit;
                        SentToWarehouse := true;
                    end;

                if "Document Status" = "document status"::Released then  // 14-10-21 ZY-LD 002
                    if not "Container Details is Sent" then
                        ContainerDetailsSent := SendContainerDetails;

                //"Document Status" := "Document Status"::Released;  // We set the status above.
                //MODIFY(TRUE);

                if GuiAllowed then
                    if SentToWarehouse and ContainerDetailsSent then
                        Message(lText001, "No.")
                    else
                        if SentToWarehouse then
                            Message(lText002, "No.")
                        else
                            if ContainerDetailsSent then
                                Message(lText003, "No.")
                            else
                                //>> 14-10-21 ZY-LD 002
                                if "Document Status" = "document status"::Error then
                                    Message("Error Description");
                //<< 14-10-21 ZY-LD 002

                CreateResponse(Rec, false);
            end;
        end;
    end;

    var
        Text001: label 'Do you want to re-send inbound order to the warehouse?';


    procedure Reopen(var InboundHeader: Record "Warehouse Inbound Header")
    begin
        if InboundHeader."Warehouse Status" < InboundHeader."warehouse status"::"Goods Received" then begin
            InboundHeader."Document Status" := InboundHeader."document status"::Open;
            if Confirm(Text001) then begin
                InboundHeader."Sent To Warehouse" := false;
                InboundHeader."Container Details is Sent" := false;
            end;
            InboundHeader.Modify(true);
        end;
    end;


    procedure PerformManuelRelease(var InboundHeader: Record "Warehouse Inbound Header")
    var
        lText001: label 'Do you want to release %1?';
    begin
        //IF "Document Status" = "Document Status"::Open THEN  // 14-10-21 ZY-LD 002
        if InboundHeader."Document Status" in [InboundHeader."document status"::Open, InboundHeader."document status"::Error] then  // 14-10-21 ZY-LD 002
            if not Confirm(lText001, true, InboundHeader."No.") then
                exit;

        Codeunit.Run(Codeunit::"Release Warehouse Inbound", InboundHeader);
    end;


    procedure PerformManuelReopen(var InboundHeader: Record "Warehouse Inbound Header")
    var
        lText001: label 'Do you want to re-open %1?';
    begin
        if InboundHeader."Document Status" = InboundHeader."document status"::Released then
            if Confirm(lText001, true, InboundHeader."No.") then
                Reopen(InboundHeader);
    end;

    local procedure CreateResponse(var pWhseIndbHead: Record "Warehouse Inbound Header"; ManuelChangeOfWarehouseStatus: Boolean) rvalue: Code[20]
    var
        recServerEnviron: Record "Server Environment";
        recRcptRespHead: Record "Rcpt. Response Header";
        recRcptRespLine: Record "Rcpt. Response Line";
        recWhseIndbLine: Record "VCK Shipping Detail";
        WarehouseStatus: Option " ","Order Sent","Order Sent (2)","Goods Received","Putting Away","On Stock";
        i: Integer;
        StartLoop: Integer;
        EndLoop: Integer;
        LineNo: Integer;
        CreateResponse: Boolean;
        lText001: label 'Do you want to create warehouse responses\for test purpose?';
        RunCreateResponse: Boolean;
    begin
        if recServerEnviron.TestEnvironment then
            if Confirm(lText001, true) then begin
                RunCreateResponse := true;
                StartLoop := 1;
                EndLoop := 5;
            end;

        if ManuelChangeOfWarehouseStatus then begin
            RunCreateResponse := true;
            StartLoop := 5;
            EndLoop := 5;
        end;

        if RunCreateResponse then
            for i := StartLoop to EndLoop do begin
                case i of
                    1:
                        begin
                            WarehouseStatus := Warehousestatus::"Order Sent";
                            CreateResponse := true;
                        end;
                    2:
                        begin
                            WarehouseStatus := Warehousestatus::"Order Sent (2)";
                            CreateResponse := false;
                        end;
                    3:
                        begin
                            WarehouseStatus := Warehousestatus::"Goods Received";
                            CreateResponse := true;
                        end;
                    4:
                        begin
                            WarehouseStatus := Warehousestatus::"Putting Away";
                            CreateResponse := true;
                        end;
                    5:
                        begin
                            WarehouseStatus := Warehousestatus::"On Stock";
                            CreateResponse := true;
                        end;
                end;

                // Insert Response
                if CreateResponse then begin
                    Clear(recRcptRespHead);
                    recRcptRespHead.Init;
                    recRcptRespHead.Insert(true);
                    recRcptRespHead."Warehouse Status" := WarehouseStatus;
                    case pWhseIndbHead."Order Type" of
                        pWhseIndbHead."order type"::"Purchase Order":
                            recRcptRespHead."Order Type" := 'PO';
                        pWhseIndbHead."order type"::"Sales Return Order":
                            recRcptRespHead."Order Type" := 'SR';
                        pWhseIndbHead."order type"::"Transfer Order":
                            recRcptRespHead."Order Type" := 'TO';
                    end;
                    recRcptRespHead."Order Type Option" := pWhseIndbHead."Order Type";
                    recRcptRespHead."Shipper Reference" := pWhseIndbHead."Shipper Reference";
                    recRcptRespHead."Customer Reference" := pWhseIndbHead."No.";
                    recRcptRespHead."Customer Message No." := pWhseIndbHead."No.";
                    recRcptRespHead.Incoterm := pWhseIndbHead."Shipping Method";
                    recRcptRespHead.City := pWhseIndbHead."Sender City";
                    recRcptRespHead.Modify(true);
                    rvalue := recRcptRespHead."No.";

                    recWhseIndbLine.SetRange("Document No.", pWhseIndbHead."No.");
                    if recWhseIndbLine.FindSet then
                        repeat
                            LineNo += 10000;

                            Clear(recRcptRespLine);
                            recRcptRespLine.Init;
                            recRcptRespLine."Response No." := recRcptRespHead."No.";
                            recRcptRespLine."Response Line No." := LineNo;
                            recRcptRespLine."Product No." := recWhseIndbLine."Item No.";
                            recRcptRespLine."Item No." := recWhseIndbLine."Item No.";
                            recRcptRespLine.Warehouse := pWhseIndbHead."Location Code";
                            recRcptRespLine.Location := pWhseIndbHead."Location Code";
                            recRcptRespLine."Ordered Qty" := recWhseIndbLine.Quantity;
                            if recRcptRespHead."Warehouse Status" >= recRcptRespHead."warehouse status"::"Goods Received" then
                                recRcptRespLine.Quantity := recWhseIndbLine.Quantity;
                            recRcptRespLine."Customer Order No." := recWhseIndbLine."Document No.";
                            recRcptRespLine."Customer Order Line No." := recWhseIndbLine."Line No.";
                            recRcptRespLine."Source Order No." := recWhseIndbLine."Document No.";
                            recRcptRespLine."Source Order Line No." := recWhseIndbLine."Line No.";
                            //recRcptRespLine."Sales Order No." := recWhseIndbLine."Document No.";
                            //recRcptRespLine."Sales Order Line No." := recWhseIndbLine."Line No.";
                            recRcptRespLine.Insert(true);
                        until recWhseIndbLine.Next() = 0;
                end;
            end;
    end;
}
