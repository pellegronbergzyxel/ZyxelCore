Codeunit 50005 "Release Delivery Document"
{
    // 001. 28-06-21 ZY-LD P0631 - Currency code must be filled.
    // 002. 26-10-21 ZY-LD 000 - E-mail customs invoice.
    // 003. 01-12-21 ZY-LD 2021113010000114 - Set "VAT Registration No. Zyxel" if missing.
    // 004. 03-03-22 ZY-LD 2022020410000063 - E-mail delivery note to customer at release.
    // 005. 18-05-22 ZY-LD 2022011110000088 - Don´t create response on freight cost.
    // 006. 07-07-22 ZY-LD 2022070710000058 - Freight cost can be posted in advance.
    // 007. 31-08-22 ZY-LD 000 - Credit Limit Approval.
    // 008. 03-10-22 ZY-LD 2022092010000047 - Email of Customs Invoice has been moved to CU 50089.
    // 009. 12-06-23 ZY-LD 000 - Customs Invoice must have a unit price.

    TableNo = "VCK Delivery Document Header";

    trigger OnRun()
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recDelDocLine2: Record "VCK Delivery Document Line";
        recCust: Record Customer;
        recItem: Record Item;
        recPickDateCountry: Record "Item Picking Date pr. Country";
        recSalesLine: Record "Sales Line";
        recSalesLine2: Record "Sales Line";
        recAddItem: Record "Additional Item";
        recVATRegNoMatrix: Record "VAT Reg. No. pr. Location";
        recCountry: Record "Country/Region";
        i: Integer;
        VckXmlMgt: Codeunit "VCK Communication Management";
        CEType: Option Confirm,Error;
        lText001: label 'Customer %1 is blocked (%2).';
        lText002: label 'Customer %1 has a prepayment on %2%.\Check with the accounting manager if it is\ok to release the delivery document.\\Do you want to continue?';
        lText003: label 'There are items with zero quantity. Please review the delivery document.';
        lText004: label '"%1" %2 is blocked.';
        lText005: label '%1: %2 has a picking date that is larger than %3. Please contact logistics.';
        lText006: label 'The field "%1" on "%2" %3 is blank. Please contact NAV Support.';
        lText007: label 'The Item No. %1 might be a part of delivery document %2 linked to %4.\Do you want to continue without "3" %1.';
        lText008: label 'The Item No. %1 should be a part of delivery document %2 linked to %3. Please contact the Logistics Department to solve the issue.';
        lText009: label 'The Item No. %1 should be a part of delivery document %2. Please check "%3" on %4 %5.';
        lText010: label 'Delivery Document %1, has a line with a different Quantity to Sales Order %2 Line %3 and therefore cannot be released.\Delivery Document Quantity: %4\Sales Order Quantity: %5';
        lText011: label 'Delivery Document %1 does not have any lines and therefore cannot be released.';
        lText012: label '"%1" is blank. Do you want to continue?';
    begin
        if MinimumOrderValue(Rec) and
           CreditLimitApproved(Rec)  // 31-08-22 ZY-LD 007
        then
            with Rec do begin
                // Before Release
                //>> 01-12-21 ZY-LD 003
                if "VAT Registration No. Zyxel" = '' then begin
                    "VAT Registration No. Zyxel" := recVATRegNoMatrix."GetZyxelVATReg/EoriNo"(0, "Ship-From Code", "Ship-to Country/Region Code", "Sell-to Country/Region Code", "Sell-to Customer No.");
                    Modify(true);
                end;
                //<< 01-12-21 ZY-LD 003

                case "Document Type" of
                    "document type"::Sales:
                        for i := 1 to 2 do begin
                            if i = 1 then
                                recCust.Get("Bill-to Customer No.")
                            else
                                recCust.Get("Sell-to Customer No.");

                            if (recCust.Blocked = recCust.Blocked::Ship) or (recCust.Blocked = recCust.Blocked::All) then
                                Error(lText001, recCust."No.", recCust.Blocked);

                            if recCust."Prepayment %" <> 0 then
                                if not Confirm(lText002, false, recCust."No.", recCust."Prepayment %") then
                                    Error('');

                            if recCust."No." = "Sell-to Customer No." then
                                i := 9;
                        end;
                end;

                TestField("Currency Code");  // 28-06-21 ZY-LD 001

                if "Delivery Terms Terms" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Delivery Terms Terms"));

                if "Sell-to Customer Name" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Sell-to Customer Name"));
                if "Sell-to Address" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Sell-to Address"));
                if "Sell-to Post Code" = '' then
                    "UserConfirm/Error"(Cetype::Confirm, FieldCaption("Sell-to Post Code"));
                if "Sell-to City" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Sell-to City"));
                if "Sell-to Country/Region Code" = '' then
                    "UserConfirm/Error"(Cetype::Confirm, FieldCaption("Sell-to Country/Region Code"));

                if "Bill-to Name" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Bill-to Name"));
                if "Bill-to Address" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Bill-to Address"));
                if "Bill-to Post Code" = '' then
                    "UserConfirm/Error"(Cetype::Confirm, FieldCaption("Bill-to Post Code"));
                if "Bill-to City" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Bill-to City"));
                if "Bill-to Country/Region Code" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Bill-to Country/Region Code"));

                if "Ship-to Name" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Ship-to Name"));
                if "Ship-to Address" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Ship-to Address"));
                if "Ship-to Post Code" = '' then
                    "UserConfirm/Error"(Cetype::Confirm, FieldCaption("Ship-to Post Code"));
                if "Ship-to City" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Ship-to City"));
                if "Ship-to Country/Region Code" = '' then
                    "UserConfirm/Error"(Cetype::Error, FieldCaption("Ship-to Country/Region Code"));

                recDelDocLine.SetAutocalcFields("Shipment Date", "Freight Cost Item");  // 07-07-22 ZY-LD 006
                recDelDocLine.SetRange("Document No.", "No.");
                if recDelDocLine.FindSet then begin
                    recCountry.Get("Ship-to Country/Region Code");

                    repeat
                        //>> 12-06-23 ZY-LD 009
                        if recCountry."E-mail Shipping Inv. to Whse." and (recDelDocLine."Unit Price" = 0) then
                            recDelDocLine.TestField("Unit Price");
                        //<< 12-06-23 ZY-LD 009

                        case "Document Type" of
                            "document type"::Sales:
                                begin
                                    if not recCust."Unblock Pick.Date Restriction" then
                                        if recPickDateCountry.Get(recDelDocLine."Item No.", "Ship-to Country/Region Code") then
                                            if recDelDocLine."Shipment Date" > recPickDateCountry."Picking Start Date" then
                                                Error(lText005, recDelDocLine.FieldCaption("Item No."), recDelDocLine."Item No.", recPickDateCountry."Picking Start Date");

                                    if recSalesLine.Get(recSalesLine."document type"::Order, recDelDocLine."Sales Order No.", recDelDocLine."Sales Order Line No.") then begin
                                        if recSalesLine."Delivery Document No." = '' then
                                            Error(lText006, recSalesLine.FieldCaption("Document No."), recSalesLine.TableCaption, recSalesLine."Line No.");

                                        if (recDelDocLine.Quantity <> recSalesLine."Outstanding Quantity") and
                                           (not recDelDocLine."Freight Cost Item")  // 07-07-22 ZY-LD 006
                                        then
                                            Error(lText010, "No.", recDelDocLine."Sales Order No.", recDelDocLine."Sales Order Line No.", recDelDocLine.Quantity, recSalesLine."Outstanding Quantity");
                                    end;

                                    recAddItem.SetRange("Item No.", recDelDocLine."Item No.");
                                    recCust.Get("Sell-to Customer No.");
                                    recCust.TestField("Forecast Territory");
                                    recAddItem.SetFilter("Ship-to Country/Region", '%1|%2', '', "Ship-to Country/Region Code");
                                    recAddItem.SetFilter("Forecast Territory", '%1|%2', '', recCust."Forecast Territory");
                                    if recCust."Additional Items" then
                                        recAddItem.SetRange("Customer No.", recCust."No.")
                                    else
                                        recAddItem.SetFilter("Customer No.", '%1', '');

                                    if recAddItem.FindFirst then
                                        repeat
                                            recSalesLine2.SetRange("Document Type", recSalesLine."Document Type");
                                            recSalesLine2.SetRange("Document No.", recSalesLine."Document No.");
                                            recSalesLine2.SetRange("Additional Item Line No.", recSalesLine."Line No.");
                                            recSalesLine2.SetRange("No.", recAddItem."Additional Item No.");
                                            if not recSalesLine2.FindFirst then begin
                                                recDelDocLine2.SetRange("Sales Order No.", recSalesLine."Document No.");
                                                recDelDocLine2.SetRange("Sales Order Line No.", recSalesLine."Line No.");
                                                recDelDocLine2.SetRange("Item No.", recAddItem."Additional Item No.");
                                                if not recDelDocLine2.FindFirst then
                                                    if recAddItem."Edit Additional Sales Line" then begin
                                                        if not Confirm(lText007, true, recAddItem."Additional Item No.", "No.", recAddItem.TableCaption, recSalesLine."No.") then
                                                            Error('');
                                                    end else
                                                        Error(lText008, recAddItem."Additional Item No.", "No.", recSalesLine."No.");
                                            end else
                                                if not recSalesLine2."Shipment Date Confirmed" then
                                                    Error(lText009, recAddItem."Additional Item No.", "No.", recSalesLine2.FieldCaption("Shipment Date Confirmed"), recSalesLine2."Document No.", recSalesLine2."Line No.");
                                        until recAddItem.Next() = 0;
                                end;
                        end;

                        if recDelDocLine.Quantity = 0 then
                            Error(lText003);

                        recItem.Get(recDelDocLine."Item No.");
                        if recItem.Blocked then
                            Error(lText004, recDelDocLine.FieldCaption("Item No."), recDelDocLine."Item No.");


                    until recDelDocLine.Next() = 0;
                end else
                    Error(lText011, "No.");

                // Release
                "Document Status" := "document status"::Released;
                if VckXmlMgt.SendWhseOutbOrderRequest(Rec) then begin
                    "Delivery Days" :=
                      //DeliveryZone.GetDeliveryDays("Delivery Zone","Ship-to Country/Region Code") +
                      "Delivery Days Adjustment";
                    if "Requested Ship Date" <> 0D then
                        "Expected Delivery Date" := CalcDate('+' + Format("Delivery Days") + 'D', "Requested Ship Date");
                    "Release Date" := Today;
                    "Release Time" := Time;
                    Modify;

                    //EmailCustomsInvoice(FALSE);  // 26-10-21 ZY-LD 002  // 03-10-22 ZY-LD 008
                    EmailDeliveryNote;  // 03-03-22 ZY-LD 004

                    CreateResponse(Rec, false);  // This is for test purpose only.
                end;
            end;
    end;


    procedure Reopen(var DeliveryHeader: Record "VCK Delivery Document Header")
    begin
        begin
            if (DeliveryHeader."Document Status" in [DeliveryHeader."document status"::Open, DeliveryHeader."document status"::Posted]) or
               (DeliveryHeader."Warehouse Status" > DeliveryHeader."warehouse status"::New)
            then
                exit;

            DeliveryHeader."Document Status" := DeliveryHeader."document status"::Open;
            DeliveryHeader.SentToAllIn := false;
            DeliveryHeader."Customs/Shipping Invoice Sent" := false;  // 26-10-21 ZY-LD 002

            DeliveryHeader.Modify(true);
        end;
    end;


    procedure PerformManualRelease(var DeliveryHeader: Record "VCK Delivery Document Header")
    var
        lText001: label 'The Delivery Document %1 has already been released.';
        recLocation: Record Location;
        lText003: label 'Are you sure that you want to releses this delivery order?\\Once released it will be sent to "%1" and cannot be changed.';
        recShipToCountry: Record "Country/Region";
        lText004: label 'Customs/Shipping Invoice %1 has been e-mailed to the warehouse.';
        recFinalDestCountry: Record "Country/Region";
    begin
        begin
            if DeliveryHeader."Document Status" = DeliveryHeader."document status"::Released then
                Error(lText001, DeliveryHeader."No.");

            recLocation.Get(DeliveryHeader."Ship-From Code");
            if not Confirm(lText003, false, recLocation.Name) then
                Error('');

            Codeunit.Run(Codeunit::"Release Delivery Document", DeliveryHeader);

            recShipToCountry.Get(DeliveryHeader."Ship-to Country/Region Code");
            if recShipToCountry."Del. Doc. Release Message" <> '' then begin
                DeliveryHeader.CalcFields(DeliveryHeader.Amount);
                if DeliveryHeader.Amount >= recShipToCountry."Del. Doc. Release Limit" then
                    Message(recShipToCountry."Del. Doc. Release Message", recShipToCountry."Del. Doc. Release Limit");
            end;

            //>> 26-10-21 ZY-LD 002
            if (recShipToCountry."E-mail Shipping Inv. to Whse.") or (recFinalDestCountry."E-mail Shipping Inv. to Whse.") then
                Message(lText004, DeliveryHeader."No.");
            //<< 26-10-21 ZY-LD 002
        end;
    end;


    procedure PerformManualReopen(var DeliveryHeader: Record "VCK Delivery Document Header")
    var
        lText001: label 'Delivery Document %1 has already been sent to the warehouse,\do you want to re-open?';
        lText002: label 'Do you want to re-open Delivery Document %1?';
        lText003: label 'Are you sure?';
        lText004: label 'The document is in process at the warehouse and can not be re-opened.';
    begin
        begin
            if (DeliveryHeader."Document Status" = DeliveryHeader."document status"::Released) and
               (DeliveryHeader."Warehouse Status" = DeliveryHeader."warehouse status"::New)
            then begin
                if DeliveryHeader.SentToAllIn then begin
                    if Confirm(lText001, false, DeliveryHeader."No.") then
                        if not Confirm(lText003) then
                            Error('');
                end else
                    if not Confirm(lText002, true, DeliveryHeader."No.") then
                        Error('');
            end else
                Message(lText004);

            Reopen(DeliveryHeader);
        end;
    end;

    local procedure MinimumOrderValue(var pDelDocHead: Record "VCK Delivery Document Header"): Boolean
    var
        recCust: Record Customer;
        lText001: label 'Delivery Document No. %1 for customer %2 %3 has an order value of %4 which is below the allowed order value of %5 for this customer.\\Do you still want to release this Delivery Document?';
    begin
        begin
            if pDelDocHead."Document Type" = pDelDocHead."document type"::Transfer then
                exit(true);

            recCust.Get(pDelDocHead."Sell-to Customer No.");
            if not recCust."Minimum Order Value Enabled" or (recCust."Minimum Order Value (LCY)" = 0) then
                exit(true);

            pDelDocHead.CalcFields(pDelDocHead.Amount);
            if pDelDocHead.Amount >= recCust."Minimum Order Value (LCY)" then
                exit(true)
            else
                exit(Confirm(lText001, false, pDelDocHead."No.", recCust."No.", recCust.Name, pDelDocHead.Amount, recCust."Minimum Order Value (LCY)"));
        end;
    end;

    local procedure CreditLimitApproved(var pDelDocHead: Record "VCK Delivery Document Header") rValue: Boolean
    var
        recCust: Record Customer;
        lText001: label 'Credit Limit %1 (%5) has been reached.\To release this delivery document you need a manager approval.\\Customer Balance (%5): %2\Released but not delivered (%5): %3\Current delivery document (%5): %4\Total: %6 (%5)\\Do you want to continue?';
        recDelDocHead: Record "VCK Delivery Document Header";
        recGenLedgSetup: Record "General Ledger Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        lText002: label 'Are you sure?';
        OutstandingOnDelDoc: Decimal;
    begin
        begin
            // 13-09-22 According to Ben, this release has been postponed. When Ben gets back, we will reopen it.
            exit(true);
            //>> 31-08-22 ZY-LD 007
            /*  IF ZGT.IsZNetCompany AND ("Document Type" = "Document Type"::Sales) THEN BEGIN
                CALCFIELDS("Outstanding Amount (LCY)");
                rValue := TRUE;

                recDelDocHead.SetCurrentKey("Document Type","Document Status","Warehouse Status","Send Invoice When Delivered");
                recDelDocHead.SETRANGE("Document Type",recDelDocHead."Document Type"::Sales);
                recDelDocHead.SETFILTER("Document Status",'<>%1',recDelDocHead."Document Status"::Posted);
                recDelDocHead.SETRANGE("Sell-to Customer No.","Sell-to Customer No.");
                recDelDocHead.SETFILTER("No.",'<>%1',"No.");
                recDelDocHead.SETAUTOCALCFIELDS("Outstanding Amount (LCY)");
                IF recDelDocHead.FINDSET THEN
                  REPEAT
                    OutstandingOnDelDoc += recDelDocHead."Outstanding Amount (LCY)";
                  UNTIL recDelDocHead.Next() = 0;

                recGenLedgSetup.GET;
                recCust.SETAUTOCALCFIELDS("Balance (LCY)");
                recCust.GET("Sell-to Customer No.");
                IF recCust."Balance (LCY)" + "Outstanding Amount (LCY)" + OutstandingOnDelDoc >= recCust."Credit Limit (LCY)" THEN BEGIN
                  IF NOT CONFIRM(lText001,FALSE,
                      recCust."Credit Limit (LCY)",recCust."Balance (LCY)",
                      ROUND(OutstandingOnDelDoc),"Outstanding Amount (LCY)",
                      recGenLedgSetup."LCY Code",recCust."Balance (LCY)" + "Outstanding Amount (LCY)" + OutstandingOnDelDoc)
                  THEN
                    rValue := FALSE
                  ELSE
                    IF NOT CONFIRM(lText002) THEN
                      rValue := FALSE;
                END;
              END ELSE
                rValue := TRUE;*/
            //<< 31-08-22 ZY-LD 007
        end;

    end;

    local procedure "UserConfirm/Error"(pType: Option Confirm,Error; pCaption: Text)
    var
        lText50000: label '"%1" must be filled.';
        lText50001: label '"%1" is not filled.\Do you wish to continue?';
        lText50002: label 'Release is cancled.';
    begin
        case pType of
            Ptype::Confirm:
                if not Confirm(lText50001, false, pCaption) then
                    Error(lText50002);
            Ptype::Error:
                Error(lText50000, pCaption);
        end;
    end;


    procedure CreateResponse(var pDelDocHead: Record "VCK Delivery Document Header"; ManuelChangeOfWarehouseStatus: Boolean) rvalue: Code[20]
    var
        recServerEnviron: Record "Server Environment";
        recShipRespHead: Record "Ship Response Header";
        recShipRespLine: Record "Ship Response Line";
        recDelDocLine: Record "VCK Delivery Document Line";
        WarehouseStatus: Option New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        i: Integer;
        StartLoop: Integer;
        EndLoop: Integer;
        LineNo: Integer;
        CreateResponse: Boolean;
        lText001: label 'Do you want to create warehouse responses\for test purpose?';
        RunCreateResponse: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        PostRespMgt: Codeunit "Post Ship Response Mgt.";
    begin
        if recServerEnviron.TestEnvironment then
            if Confirm(lText001, true) then begin
                RunCreateResponse := true;
                StartLoop := 1;
                EndLoop := 11;
            end;

        if ManuelChangeOfWarehouseStatus then begin
            RunCreateResponse := true;
            StartLoop := 10;
            EndLoop := 10;
        end;

        if RunCreateResponse then begin
            for i := StartLoop to EndLoop do begin
                case i of
                    1:
                        begin
                            WarehouseStatus := Warehousestatus::New;
                            CreateResponse := true;
                        end;
                    2:
                        begin
                            WarehouseStatus := Warehousestatus::Backorder;
                            CreateResponse := false;
                        end;
                    3:
                        begin
                            WarehouseStatus := Warehousestatus::"Ready to Pick";
                            CreateResponse := true;
                        end;
                    4:
                        begin
                            WarehouseStatus := Warehousestatus::Picking;
                            CreateResponse := true;
                        end;
                    5:
                        begin
                            WarehouseStatus := Warehousestatus::Packed;
                            CreateResponse := true;
                        end;
                    6:
                        begin
                            WarehouseStatus := Warehousestatus::"Waiting for invoice";
                            CreateResponse := false;
                        end;
                    7:
                        begin
                            WarehouseStatus := Warehousestatus::"Invoice Received";
                            CreateResponse := false;
                        end;
                    8:
                        begin
                            WarehouseStatus := Warehousestatus::Posted;
                            CreateResponse := false;
                        end;
                    9:
                        begin
                            WarehouseStatus := Warehousestatus::"In Transit";
                            CreateResponse := true;
                        end;
                    10:
                        begin
                            WarehouseStatus := Warehousestatus::Delivered;
                            CreateResponse := true;
                        end;
                    11:
                        begin
                            WarehouseStatus := Warehousestatus::Error;
                            CreateResponse := false;
                        end;
                end;

                // Insert Response
                if CreateResponse then begin
                    Clear(recShipRespHead);
                    recShipRespHead.Init;
                    recShipRespHead.Insert(true);
                    recShipRespHead."Warehouse Status" := WarehouseStatus;
                    case pDelDocHead."Document Type" of
                        pDelDocHead."document type"::Sales:
                            recShipRespHead."Order Type" := 'SO';
                        pDelDocHead."document type"::Transfer:
                            recShipRespHead."Order Type" := 'TO';
                    end;
                    recShipRespHead."Receiver Reference" := pDelDocHead."Shipper Reference";
                    recShipRespHead."Customer Reference" := pDelDocHead."No.";
                    recShipRespHead."Customer Message No." := pDelDocHead."No.";
                    recShipRespHead.Incoterm := pDelDocHead."Delivery Terms Terms";
                    recShipRespHead.City := pDelDocHead."Ship-to City";
                    recShipRespHead.Modify(true);
                    rvalue := recShipRespHead."No.";

                    recDelDocLine.SetRange("Document No.", pDelDocHead."No.");
                    recDelDocLine.SetRange("Freight Cost Item", false);  // 18-05-22 ZY-LD 005
                    if recDelDocLine.FindSet then
                        repeat
                            LineNo += 10000;

                            Clear(recShipRespLine);
                            recShipRespLine.Init;
                            recShipRespLine."Response No." := recShipRespHead."No.";
                            recShipRespLine."Response Line No." := LineNo;
                            recShipRespLine."Product No." := recDelDocLine."Item No.";
                            recShipRespLine."Item No." := recDelDocLine."Item No.";
                            recShipRespLine.Description := recDelDocLine.Description;
                            recShipRespLine.Warehouse := pDelDocHead."Ship-From Code";
                            recShipRespLine.Location := pDelDocHead."Ship-From Code";
                            recShipRespLine."Ordered Quantity" := recDelDocLine.Quantity;
                            if recShipRespHead."Warehouse Status" >= recShipRespHead."warehouse status"::Packed then
                                recShipRespLine.Quantity := recDelDocLine.Quantity;
                            recShipRespLine."Customer Order No." := recDelDocLine."Sales Order No.";
                            recShipRespLine."Customer Order Line No." := recDelDocLine."Sales Order Line No.";
                            recShipRespLine."Sales Order No." := recDelDocLine."Document No.";
                            recShipRespLine."Sales Order Line No." := recDelDocLine."Line No.";
                            recShipRespLine.Insert(true);
                        until recDelDocLine.Next() = 0;
                end;
            end;

            if not ZGT.UserIsDeveloper then begin
                PostRespMgt.PostShippingOrderResponse('');
                PostRespMgt.PostShippingOrderResponse('');
            end;
        end;
    end;
}
