Codeunit 50006 "Release Warehouse Inbound"
{

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
        //UpgradeReady
        recLocation.Get(Rec."Location Code");
        if recLocation.Warehouse <> recLocation.Warehouse::" " then
            if CheckforCVKbutNoMainwarehause(rec) then begin
                // PGR: add extra check-> check if one line is Main warehause = true) and from PO
                if not Rec."Sent To Warehouse" then
                    if VCKComMgt.SendInboundOrderRequest(Rec) then begin
                        Rec.Validate("Document Status", Rec."document status"::Released);
                        Rec."Sent To Warehouse" := true;
                        Rec."Sent to Warehouse Date" := Rec."Last Status Update Date";
                        Rec.Modify();
                        Commit();
                        SentToWarehouse := true;
                    end;

                if Rec."Document Status" = Rec."document status"::Released then
                    if not Rec."Container Details is Sent" then
                        ContainerDetailsSent := Rec.SendContainerDetails();
                if GuiAllowed() then
                    if SentToWarehouse and ContainerDetailsSent then
                        Message(lText001, Rec."No.")
                    else
                        if SentToWarehouse then
                            Message(lText002, Rec."No.")
                        else
                            if ContainerDetailsSent then
                                Message(lText003, Rec."No.")
                            else
                                if Rec."Document Status" = Rec."document status"::Error then
                                    Message(Rec."Error Description");

                CreateResponse(Rec, false);
            end;
        //Upgrade Ready End
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
        if InboundHeader."Document Status" in [InboundHeader."document status"::Open, InboundHeader."document status"::Error] then
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
        CreateResponseYN: Boolean;
        lText001: label 'Do you want to create warehouse responses\for test purpose?';
        RunCreateResponse: Boolean;
    begin
        if recServerEnviron.TestEnvironment() then
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
                            CreateResponseYN := true;
                        end;
                    2:
                        begin
                            WarehouseStatus := Warehousestatus::"Order Sent (2)";
                            CreateResponseYN := false;
                        end;
                    3:
                        begin
                            WarehouseStatus := Warehousestatus::"Goods Received";
                            CreateResponseYN := true;
                        end;
                    4:
                        begin
                            WarehouseStatus := Warehousestatus::"Putting Away";
                            CreateResponseYN := true;
                        end;
                    5:
                        begin
                            WarehouseStatus := Warehousestatus::"On Stock";
                            CreateResponseYN := true;
                        end;
                end;

                // Insert Response
                if CreateResponseYN then begin
                    Clear(recRcptRespHead);
                    recRcptRespHead.Init();
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
                    recRcptRespHead."Shipper Reference" := COpystr(pWhseIndbHead."Shipper Reference", 1, 20);
                    recRcptRespHead."Customer Reference" := pWhseIndbHead."No.";
                    recRcptRespHead."Customer Message No." := pWhseIndbHead."No.";
                    recRcptRespHead.Incoterm := pWhseIndbHead."Shipping Method";
                    recRcptRespHead.City := pWhseIndbHead."Sender City";
                    recRcptRespHead.Modify(true);
                    rvalue := recRcptRespHead."No.";

                    recWhseIndbLine.SetRange("Document No.", pWhseIndbHead."No.");
                    if recWhseIndbLine.FindSet() then
                        repeat
                            LineNo += 10000;

                            Clear(recRcptRespLine);
                            recRcptRespLine.Init();
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
                            recRcptRespLine.Insert(true);
                        until recWhseIndbLine.Next() = 0;
                end;
            end;
    end;

    procedure CheckforCVKbutNoMainwarehause(WIH: record "Warehouse Inbound Header"): Boolean
    var
        AutoSetup: record "Automation Setup";
        recWhseIndbLine: Record "VCK Shipping Detail";
    begin
        if not AutoSetup.get() then
            exit(true);
        if not AutoSetup.SkipPOMainWareHouseZero then
            exit(true);

        if WIH."Order Type" <> WIH."Order Type"::"Purchase Order" then
            exit(true);

        recWhseIndbLine.SetRange("Document No.", WIH."No.");
        recWhseIndbLine.setrange("Main Warehouse", true);
        if not recWhseIndbLine.IsEmpty then
            exit(true);

        recWhseIndbLine.SetRange("Document No.", WIH."No.");
        recWhseIndbLine.setrange("Main Warehouse", false);
        if not recWhseIndbLine.IsEmpty then
            exit(false);


    end;
}
