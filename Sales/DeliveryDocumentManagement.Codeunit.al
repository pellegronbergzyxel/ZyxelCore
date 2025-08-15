codeunit 50008 "Delivery Document Management"
{

    trigger OnRun()
    var
        recAutoSetup: Record "Automation Setup";
    begin
        recAutoSetup.Get();
        if recAutoSetup.WhseCreateOutboundSales() then
            CreateDeliveryDocument('');
        if recAutoSetup.WhseCreateOutboundTransfer() then
            CreateDeliveryDocumentTransfer('');
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        ReworkLbl: Label 'REWORK';
        nocreated: Integer;


    procedure PerformManuelCreation()
    var
        lText001: Label 'Do you want to create delivery documents for all orders?';
        lText002: Label 'Are you sure?';
    begin
        if Confirm(lText001, true) then
            if Confirm(lText002, true) then
                CreateDeliveryDocument('');
    end;


    procedure PerformCreationForSingleOrder(SalesOrderNo: Code[20])
    var
        lText001: Label 'Do you want to create delivery document for sales order %1?';
    begin
        if Confirm(lText001, true, SalesOrderNo) then
            CreateDeliveryDocument(SalesOrderNo);
    end;


    procedure PerformCreationForSingleOrderWithoutConfirmation(SalesOrderNo: Code[20])
    var

    begin
        CreateDeliveryDocument(SalesOrderNo);
    end;


    procedure CreateDeliveryDocumentTransfer(pNo: Code[20])
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recTransHead: Record "Transfer Header";
        recTransLine: Record "Transfer Line";
        recDelDocHead: Record "VCK Delivery Document Header";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        ShipToCode: Code[50];
    begin

        begin
            recSalesSetup.Get();
            recSalesSetup.TestField("Del. Doc. Creation Calculation");

            recTransLine.SetRange(recTransLine."Shipment Date Confirmed", true);
            recTransLine.SetFilter(recTransLine."Shipment Date", '..%1', CalcDate(recSalesSetup."Del. Doc. Creation Calculation", Today));
            recTransLine.SetRange(recTransLine.Status, recTransLine.Status::Released);
            recTransLine.SetFilter(recTransLine."Delivery Document No.", '%1', '');
            recTransLine.SetFilter(recTransLine."Transfer-from Code", ItemLogisticEvents.GetRequireShipmentLocations());
            recTransLine.SetFilter(recTransLine."Outstanding Quantity", '>0');
            recTransLine.SetFilter(recTransLine."Transfer-to Code", '<>%1', '');
            if pNo <> '' then
                recTransLine.SetRange(recTransLine."Document No.", pNo);
            if recTransLine.FindSet(true) then
                repeat
                    recTransHead.Get(recTransLine."Document No.");

                    if (recTransLine."Transfer-to Address Code" <> '') or (recTransHead."Transfer-to Address Code" <> '') then begin
                        recDelDocHead.SetRange("Document Type", recDelDocHead."document type"::Transfer);
                        if recTransLine."Transfer-to Address Code" <> '' then
                            ShipToCode := recTransLine."Transfer-to Code" + '.' + recTransLine."Transfer-to Address Code"
                        else
                            ShipToCode := recTransLine."Transfer-to Code" + '.' + recTransHead."Transfer-to Address Code";
                        recDelDocHead.SetRange("Ship-to Code", ShipToCode);
                        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
                        recDelDocHead.SetRange("Delivery Terms Terms", recTransHead."Shipment Method Code");
                        recDelDocHead.SetRange("Ship-From Code", recTransLine."Transfer-from Code");
                        if not recDelDocHead.FindFirst() then
                            recDelDocHead."No." :=
                              CreateDeliveryDocumentHeadTransfer(recTransHead, ShipToCode);

                        CreateDeliveryDocumentLineTransfer(
                          recTransLine,
                          recDelDocHead."No.",
                          CopyStr(recTransHead."Ref./ PO", 1, 30),
                          recTransHead."Assigned User ID",
                          recDelDocHead."Currency Code");
                    end;
                until recTransLine.Next() = 0;
        end;
    end;

    local procedure CreateDeliveryDocumentHeadTransfer(pTransHead: Record "Transfer Header"; pShipToCode: Code[50]) rValue: Code[20]
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recWhseSetup: Record "Warehouse Setup";
        recLocation: Record Location;
        recDelDocHead: Record "VCK Delivery Document Header";
        recDefAction: Record "Default Action";
        recDelDocAction: Record "Delivery Document Action Code";
        recGenLedgSetup: Record "General Ledger Setup";
        recTransToAddr: Record "Transfer-to Address";
        recUserSetup: Record "User Setup";
        LineNo: Integer;
    begin

        begin
            recSalesSetup.Get();
            recGenLedgSetup.Get();
            recGenLedgSetup.TestField("LCY Code");
            recWhseSetup.Get();
            recWhseSetup.TestField("Whse. Delivery Document Nos.");

            recDelDocHead.Init();
            recDelDocHead.Insert(true);

            if recUserSetup.Get(recDelDocHead."Create User ID") and (recUserSetup."Salespers./Purch. Code" <> '') then
                recDelDocHead."Salesperson Code" := recUserSetup."Salespers./Purch. Code"
            else
                recDelDocHead."Salesperson Code" := CopyStr(recDelDocHead."Create User ID", 1, MaxStrLen(recUserSetup."Salespers./Purch. Code"));

            recDelDocHead."Order Desk Resposible Code" := copystr(recDelDocHead."Salesperson Code", 1, 20);
            recDelDocHead."Document Type" := recDelDocHead."document type"::Transfer;
            recDelDocHead."Source No." := pTransHead."No.";
            recDelDocHead."Document Status" := recDelDocHead."document status"::Open;
            recDelDocHead."Warehouse Status" := recDelDocHead."warehouse status"::New;

            recDelDocHead."Mode Of Transport" := pTransHead."Transport Method";
            recDelDocHead."Shipment Agent Code" := GetDefaultShipmentAgentCode();
            recDelDocHead."Delivery Terms City" := pTransHead."Transfer-to City";

            recDelDocHead."Shipment Agent Service" := GetDefaultShipmentAgentSerCode(GetDefaultShipmentAgentCode());
            recDelDocHead."Shipment Agent Code" := GetDefaultShipmentAgentCode();
            recDelDocHead."Currency Code" := recGenLedgSetup."LCY Code";

            recDelDocHead."Document Date" := WorkDate();
            recDelDocHead."Ship-to Code" := copystr(pShipToCode, 1, 20);

            if recTransToAddr.Get(pTransHead."Transfer-to Code", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode))) then begin
                recDelDocHead."Ship-to Name" := recTransToAddr.Name;
                recDelDocHead."Ship-to Name 2" := recTransToAddr."Name 2";
                recDelDocHead."Ship-to Address" := recTransToAddr.Address;
                recDelDocHead."Ship-to Address 2" := recTransToAddr."Address 2";
                recDelDocHead."Ship-to City" := recTransToAddr.City;
                recDelDocHead."Ship-to Contact" := recTransToAddr.Contact;
                recDelDocHead."Ship-to Post Code" := recTransToAddr."Post Code";
                recDelDocHead."Ship-to County" := recTransToAddr.County;
                recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", recTransToAddr."Country/Region Code");
            end else begin
                recDelDocHead."Ship-to Name" := pTransHead."Transfer-to Name";
                recDelDocHead."Ship-to Name 2" := pTransHead."Transfer-to Name 2";
                recDelDocHead."Ship-to Address" := pTransHead."Transfer-to Address";
                recDelDocHead."Ship-to Address 2" := pTransHead."Transfer-to Address 2";
                recDelDocHead."Ship-to City" := pTransHead."Transfer-to City";
                recDelDocHead."Ship-to Contact" := pTransHead."Transfer-to Contact";
                recDelDocHead."Ship-to Post Code" := pTransHead."Transfer-to Post Code";
                recDelDocHead."Ship-to County" := pTransHead."Transfer-to County";
                recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", pTransHead."Trsf.-to Country/Region Code");
            end;

            recDelDocHead."Sell-to Customer Name" := pTransHead."Transfer-to Name";
            recDelDocHead."Sell-to Customer Name 2" := pTransHead."Transfer-to Name 2";
            recDelDocHead."Sell-to Address" := pTransHead."Transfer-to Address";
            recDelDocHead."Sell-to Address 2" := pTransHead."Transfer-to Address 2";
            recDelDocHead."Sell-to City" := pTransHead."Transfer-to City";
            recDelDocHead."Sell-to Contact" := pTransHead."Transfer-to Contact";
            recDelDocHead."Sell-to Post Code" := pTransHead."Transfer-to Post Code";
            recDelDocHead."Sell-to County" := pTransHead."Transfer-to County";
            recDelDocHead.Validate(recDelDocHead."Sell-to Country/Region Code", pTransHead."Trsf.-to Country/Region Code");

            recDelDocHead."Bill-to Customer No." := pTransHead."Transfer-to Code";
            recDelDocHead."Bill-to Name" := pTransHead."Transfer-to Name";
            recDelDocHead."Bill-to Name 2" := pTransHead."Transfer-to Name 2";
            recDelDocHead."Bill-to Address" := pTransHead."Transfer-to Address";
            recDelDocHead."Bill-to Address 2" := pTransHead."Transfer-to Address 2";
            recDelDocHead."Bill-to City" := pTransHead."Transfer-to City";
            recDelDocHead."Bill-to Contact" := pTransHead."Transfer-to Contact";
            recDelDocHead."Bill-to County" := pTransHead."Transfer-to County";
            recDelDocHead."Bill-to Country/Region Code" := pTransHead."Trsf.-to Country/Region Code";
            recDelDocHead."Bill-to Post Code" := pTransHead."Transfer-to Post Code";

            recDelDocHead.Validate(recDelDocHead."Ship-From Code", pTransHead."Transfer-from Code");
            recDelDocHead."Ship-From Name" := pTransHead."Transfer-from Name";
            recDelDocHead."Ship-From Name 2" := pTransHead."Transfer-from Name 2";
            recDelDocHead."Ship-From Address" := pTransHead."Transfer-from Address";
            recDelDocHead."Ship-From Address 2" := pTransHead."Transfer-from Address 2";
            recDelDocHead."Ship-From City" := pTransHead."Transfer-from City";
            recDelDocHead."Ship-From Contact" := pTransHead."Transfer-from Contact";
            recDelDocHead."Ship-From Post Code" := pTransHead."Transfer-from Post Code";
            recDelDocHead."Ship-From County" := pTransHead."Transfer-from County";
            recDelDocHead."Ship-From Country/Region Code" := pTransHead."Trsf.-from Country/Region Code";

            recDelDocHead.Validate(recDelDocHead."Delivery Terms Terms", pTransHead."Shipment Method Code");

            if recLocation.Get(pTransHead."Transfer-to Code") then begin
                recDelDocHead."Notification Email" := CopyStr(recLocation."Notification Email", 1, 80);
                recDelDocHead."Confirmation Email" := copystr(recLocation."Confirmation Email", 1, 80);
            end;
            recDelDocHead.Modify(true);

            recDefAction.Reset();
            recDefAction.SetRange("Source Type", recDefAction."source type"::Location, recDefAction."source type"::"Transfer-to Address");
            recDefAction.SetFilter("Source Code", '%1|%2', pTransHead."Transfer-to Code", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode)));
            recDefAction.SetRange("Header / Line", recDefAction."header / line"::Header);
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate());
            if recDefAction.FindSet() then begin
                LineNo := 0;
                repeat
                    LineNo += 10000;
                    recDelDocAction.InitLine(recDefAction);
                    recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                    recDelDocAction."Line No." := LineNo;
                    if not recDelDocAction.Insert(true) then;
                until recDefAction.Next() = 0;
            end;

            recDefAction.Reset();
            recDefAction.SetRange("Source Type", recDefAction."source type"::"Transfer-to Address");
            recDefAction.SetRange("Source Code", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode)));
            recDefAction.SetRange("Header / Line", recDefAction."header / line"::Line);
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate());
            if recDefAction.FindSet() then begin
                LineNo := 0;
                repeat
                    LineNo += 10000;
                    recDelDocAction.InitLine(recDefAction);
                    recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                    recDelDocAction."Line No." := LineNo;
                    if not recDelDocAction.Insert(true) then;
                until recDefAction.Next() = 0;
            end;

            nocreated := nocreated + 1;
            rValue := recDelDocHead."No.";
        end;
    end;

    local procedure CreateDeliveryDocumentLineTransfer(pTransLine: Record "Transfer Line"; pDocumentNo: Code[20]; pCustOrderNo: Code[30]; pSalesPersonCode: Code[50]; pCurrencyCode: Code[10])
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recDelDocLine2: Record "VCK Delivery Document Line";
        recItem: Record Item;
    begin
        begin
            recDelDocLine2.SetRange("Sales Order No.", pTransLine."Document No.");
            recDelDocLine2.SetRange("Sales Order Line No.", pTransLine."Line No.");
            recDelDocLine2.SetFilter("Document No.", '<>%1', pDocumentNo);
            recDelDocLine2.SetFilter(Quantity, '<>0');
            if recDelDocLine2.IsEmpty() then begin
                recDelDocLine.Init();
                recDelDocLine."Document No." := pDocumentNo;
                recDelDocLine."Line No." := GetNextLineNo(pDocumentNo);
                recDelDocLine."Item No." := pTransLine."Item No.";
                recDelDocLine."Unit of Measure Code" := pTransLine."Unit of Measure Code";
                recDelDocLine.Description := pTransLine.Description;
                recDelDocLine."Transfer Order No." := pTransLine."Document No.";
                recDelDocLine."Transfer Order Line No." := pTransLine."Line No.";
                recDelDocLine."Sales Order No." := pTransLine."Document No.";
                recDelDocLine."Sales Order Line No." := pTransLine."Line No.";
                recDelDocLine."Warehouse Status" := recDelDocLine."warehouse status"::New;
                recDelDocLine.Location := pTransLine."Transfer-from Code";
                recDelDocLine."Customer Order No." := pCustOrderNo;
                recDelDocLine.Transferorder := true;
                recDelDocLine."Salesperson Code" := pSalesPersonCode;
                recDelDocLine."Currency Code" := pCurrencyCode;
                recDelDocLine.Quantity := pTransLine."Outstanding Quantity";
                recItem.Get(recDelDocLine."Item No.");
                recDelDocLine.Validate(recDelDocLine."Unit Price", recItem."Unit Cost");
                recDelDocLine.Validate(recDelDocLine.Amount);
                recDelDocLine.Insert();
            end;
        end;
    end;


    procedure CalcDeliveryDate(ShipDate: Date; Country: Code[20]) DeliveryDate: Date
    var
        recCountryShipmentDays: Record "VCK Country Shipment Days";
        DeliveryOffset: Integer;

    begin
        DeliveryOffset := 0;
        if ShipDate <= Today() then
            ShipDate := Today();

        recCountryShipmentDays.SetFilter("Country Code", Country);
        if recCountryShipmentDays.FindFirst() then DeliveryOffset := recCountryShipmentDays."Delivery Days";

        DeliveryDate := CalcDate('<' + Format(DeliveryOffset) + 'D>', ShipDate);
        if Date2dwy(DeliveryDate, 1) = 6 then DeliveryDate := CalcDate('<2D>', DeliveryDate);
        if Date2dwy(DeliveryDate, 1) = 7 then DeliveryDate := CalcDate('<1D>', DeliveryDate);
    end;


    procedure CalcShipmentDate(pSellToCust: Code[20]; pItemNo: Code[20]; pShipToCountry: Code[20]; pDivisionCode: Code[10]; pInitDate: Date; pChechShipmentTime: Boolean) NewShipmentDate: Date
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recCtryShipDay: Record "VCK Country Shipment Days";
        recCtryShipDaySub: Record "VCK Country Shipm. Day Sub";
        recServEnviron: Record "Server Environment";
        recItemPickDateCountry: Record "Item Picking Date pr. Country";
        recCust: Record Customer;
        EmailAddMgt: Codeunit "E-mail Address Management";
        LocalTODAY: Date;

    begin
        recSalesSetup.Get();
        if recSalesSetup."Calculate Shipment Date" then begin
            if recServEnviron.ProductionEnvironment() then
                LocalTODAY := Today()
            else
                LocalTODAY := WorkDate();

            NewShipmentDate := pInitDate;

            if NewShipmentDate <= LocalTODAY then
                if Time <= 120000T then
                    NewShipmentDate := LocalTODAY + 1
                else
                    NewShipmentDate := LocalTODAY + 2;

            if Date2dwy(NewShipmentDate, 1) > 5 then
                NewShipmentDate := GetNextWeekday(1, NewShipmentDate);

            if recCtryShipDay.Get(pShipToCountry) and
               (StrPos(pDivisionCode, 'CH') <> 0)   // Only Channes is doing this
            then begin
                // Send e-mail for updating EOQ Dates
                if recServEnviron.ProductionEnvironment() then
                    if (Date2dmy(LocalTODAY, 2) mod 3 = 0) and (Date2dmy(recCtryShipDay."Eoq Start Date", 2) <> Date2dmy(LocalTODAY, 2)) then
                        if (LocalTODAY > recCtryShipDay."Eoq End Date") or (recCtryShipDay."Eoq End Date" = 0D) then
                            if not EmailAddMgt.EmailIsSendToday('UPDEOQDATE', true) then begin
                                EmailAddMgt.CreateSimpleEmail('UPDEOQDATE', '', '');
                                EmailAddMgt.Send();
                            end;

                if (NewShipmentDate >= recCtryShipDay."Eoq Start Date") and
                   (NewShipmentDate <= recCtryShipDay."Eoq End Date")
                then begin
                    recCtryShipDaySub.SetRange("Country Code", pShipToCountry);
                    recCtryShipDaySub.SetRange("Week Day", Date2dwy(NewShipmentDate, 1));
                    if not recCtryShipDaySub.FindFirst() then
                        NewShipmentDate := CalcDate(recCtryShipDay."Eoq Date Formula", NewShipmentDate);

                    if Date2dwy(NewShipmentDate, 1) > 5 then
                        NewShipmentDate := GetNextWeekday(1, NewShipmentDate);

                end else begin
                    recCtryShipDaySub.SetRange("Country Code", pShipToCountry);
                    recCtryShipDaySub.SetFilter("Week Day", '%1..', Date2dwy(NewShipmentDate, 1));
                    if not recCtryShipDaySub.FindFirst() then
                        recCtryShipDaySub.SetRange("Week Day");

                    if recCtryShipDaySub.FindFirst() then
                        NewShipmentDate := GetNextWeekday(recCtryShipDaySub."Week Day", NewShipmentDate);
                end;

                if pChechShipmentTime then
                    if NewShipmentDate <= LocalTODAY then
                        if Time <= recCtryShipDay."Shipment Time" then
                            NewShipmentDate := CalcShipmentDate(pSellToCust, pItemNo, pShipToCountry, pDivisionCode, NewShipmentDate + 1, false)
                        else
                            NewShipmentDate := CalcShipmentDate(pSellToCust, pItemNo, pShipToCountry, pDivisionCode, NewShipmentDate + 2, false);


                if not recCust.Get(pSellToCust) then;
                if not recCust."Unblock Pick.Date Restriction" then
                    if pItemNo <> '' then
                        if recItemPickDateCountry.Get(pItemNo, pShipToCountry) then
                            if NewShipmentDate < recItemPickDateCountry."Picking Start Date" then
                                NewShipmentDate := recItemPickDateCountry."Picking Start Date";
            end;
        end;
    end;


    procedure GetNextWeekday(Weekday: Integer; Date: Date) ReturnDate: Date
    var
        CheckDate: Date;
        ThisDay: Integer;
        DateFound: Boolean;
    begin
        ThisDay := 0;
        repeat
            //CheckDate := CalcDate(Format(ThisDay) + 'D', Date);
            case ThisDay of
                0:
                    CheckDate := CalcDate('<0D>', Date);
                1:
                    CheckDate := CalcDate('<1D>', Date);
                2:
                    CheckDate := CalcDate('<2D>', Date);
                3:
                    CheckDate := CalcDate('<3D>', Date);
                4:
                    CheckDate := CalcDate('<4D>', Date);
                5:
                    CheckDate := CalcDate('<5D>', Date);
                6:
                    CheckDate := CalcDate('<6D>', Date);
                7:
                    CheckDate := CalcDate('<7D>', Date);
            end;

            if Date2dwy(CheckDate, 1) = Weekday then begin
                ReturnDate := CheckDate;
                DateFound := true;
            end;
            ThisDay := ThisDay + 1;
        until DateFound = true;
    end;


    procedure GetPrevWeekday(Weekday: Integer; Date: Date) ReturnDate: Date
    var
        CheckDate: Date;
        ThisDay: Integer;
        DateFound: Boolean;
    begin

        ThisDay := 0;
        repeat
            CheckDate := CalcDate(Format(ThisDay) + 'D', Date);
            if Date2dwy(CheckDate, 1) = Weekday then begin
                ReturnDate := CheckDate;
                DateFound := true;
            end;
            ThisDay := ThisDay - 1;
        until DateFound = true;

    end;

    local procedure CreateDeliveryDocument(SalesOrderNo: Code[20])
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recDelDocHead: Record "VCK Delivery Document Header";
        recGenLedgSetup: Record "General Ledger Setup";
        ShipToAddRework: Record "Ship-to Address";
        CustRework: Record Customer;
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        ShipToCode: Code[50];
        SellToCustNo: Code[20];
    begin
        recSalesSetup.Get();
        recSalesSetup.TestField("Del. Doc. Creation Calculation");
        recGenLedgSetup.get();

        recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
        if SalesOrderNo <> '' then
            recSalesLine.SetRange("Document No.", SalesOrderNo);

        recSalesLine.SetRange("Shipment Date Confirmed", true);
        recSalesLine.SetFilter("Shipment Date", '..%1', CalcDate(recSalesSetup."Del. Doc. Creation Calculation", Today));
        recSalesLine.SetRange(Status, recSalesLine.Status::Released);
        recSalesLine.SetFilter("Delivery Document No.", '%1', '');
        recSalesLine.SetFilter("Location Code", ItemLogisticEvents.GetRequireShipmentLocations());
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        recSalesLine.SetFilter("BOM Line No.", '<1');
        recSalesLine.SetFilter("Outstanding Quantity", '>0');
        recSalesLine.SetFilter("Ship-to Code", '<>%1', '');  // Without the ship-to code we are not able to set correct action code for VCK
        recSalesLine.SetRange("Unconfirmed Additional Line", 0);
        recSalesLine.SetFilter("Sales Order Type", '%1|%2|%3', recSalesLine."sales order type"::Normal, recSalesLine."sales order type"::"Spec. Order", recSalesLine."sales order type"::Other);
        recSalesLine.SetAutoCalcFields("Ship-to Code Cust/Item Relat.", "Create Delivery Doc. pr. Item");
        if recSalesLine.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recSalesLine.Count());
            repeat
                ZGT.UpdateProgressWindow(recSalesLine."Document No.", 0, true);

                recSalesHead.SetAutoCalcFields("Create Delivery Doc. pr. Order");
                recSalesHead.Get(recSalesLine."Document Type", recSalesLine."Document No.");
                recSalesHead.TestField("Ship-to Code");

                //11-08-2025 BK #518362
                if CheckShippingAdvise(recSalesHead, recSalesLine) then
                    if recSalesHead."On Hold" = '' then begin

                        if ZGT.IsZNetCompany() and (recSalesHead."Ship-to Code Del. Doc" <> '') then
                            recSalesHead."Ship-to Code Del. Doc" := '';  // We have seen data in this field in ZNet DK, but it should not be possible.
                        if recSalesHead."Ship-to Code Del. Doc" <> '' then begin
                            CustRework.SetRange("Search Name", ReworkLbl);
                            CustRework.FindFirst();
                            SellToCustNo := CustRework."No.";
                        end else
                            SellToCustNo := recSalesLine."Sell-to Customer No.";

                        if recSalesLine."Create Delivery Doc. pr. Item" and
                        (recSalesLine."Ship-to Code Cust/Item Relat." <> '')
                        then
                            ShipToCode := SellToCustNo + '.' + recSalesLine."Ship-to Code Cust/Item Relat."
                        else
                            ShipToCode := SellToCustNo + '.' + recSalesLine."Ship-to Code";
                        if recSalesHead."Ship-to Code Del. Doc" = '' then begin
                            recDelDocHead.SetRange("Sell-to Customer No.", recSalesLine."Sell-to Customer No.");
                            recDelDocHead.SetRange("Delivery Terms Terms", recSalesHead."Shipment Method Code");
                        end else begin
                            recDelDocHead.SetRange("Sell-to Customer No.", CustRework."No.");
                            ShipToAddRework.get(recSalesHead."Sell-to Customer No.", recSalesHead."Ship-to Code Del. Doc");
                            recDelDocHead.SetRange("Delivery Terms Terms", ShipToAddRework."Shipment Method Code");
                        end;
                        recDelDocHead.SetRange("Ship-to Code", ShipToCode);
                        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);

                        if (recSalesHead."Sales Order Type" = recSalesHead."sales order type"::"Spec. Order") or
                        recSalesHead."Create Delivery Doc. pr. Order" or
                        recSalesLine."Create Delivery Doc. pr. Item"
                        then begin
                            if recSalesLine."Create Delivery Doc. pr. Item" then
                                recDelDocHead.SetRange("Spec. Order No.", recSalesLine."No.")
                            else
                                recDelDocHead.SetRange("Spec. Order No.", recSalesHead."No.")
                        end else
                            recDelDocHead.SetFilter("Spec. Order No.", '%1', '');
                        recDelDocHead.SetRange("Ship-From Code", recSalesLine."Location Code");

                        if recSalesLine."Currency Code" = '' then
                            recDelDocHead.SetRange("Currency Code", recGenLedgSetup."LCY Code")
                        else
                            recDelDocHead.SetRange("Currency Code", recSalesLine."Currency Code");
                        recDelDocHead.SetRange("Ship-From Code", recSalesLine."Location Code");
                        if not recDelDocHead.FindFirst() then
                            recDelDocHead."No." :=
                            CreateDeliveryDocumentHeader(
                            recSalesHead,
                            recSalesLine."Planned Delivery Date",
                            recSalesLine."Shipment Date",
                            recSalesLine."Transport Method",
                            ShipToCode);

                        if CreateDeliveryDocumentLine(
                        recSalesLine,
                        recDelDocHead."No.",
                        recSalesHead."Salesperson Code")
                        then begin
                            recSalesLine."Delivery Document No." := recDelDocHead."No.";
                            recSalesLine.Modify();

                            if recSalesSetup."Copy Comments Order to Shpt." then
                                CopyCommentLines(recSalesHead."Document Type", "Sales Comment Document Type"::Value20, recSalesHead."No.", recDelDocHead."No.");
                        end;
                    end;
            until recSalesLine.Next() = 0;
            ZGT.CloseProgressWindow();
        end;
    end;

    local procedure CreateDeliveryDocumentHeader(pSalesHead: Record "Sales Header"; pPlannedDeliveryDate: Date; pSlShipmentDate: Date; pTransportMethod: Code[20]; pShipToCode: Code[50]) rValue: Code[20]
    var
        recDelComment: Record "VCK Delivery Note Comments";
        recBillToCust: Record Customer;
        CustRework: Record Customer;
        recLocation: Record Location;
        recDelDocHead: Record "VCK Delivery Document Header";
        recCountryShipDay: Record "VCK Country Shipment Days";
        recShiptoAdd: Record "Ship-to Address";
        recDefAction: Record "Default Action";
        recDelDocAction: Record "Delivery Document Action Code";
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        begin
            recGenLedgSetup.get();
            recDelDocHead.Init();
            recDelDocHead.Insert(true);
            recDelDocHead."Document Type" := recDelDocHead."document type"::Sales;
            recDelDocHead."Document Status" := recDelDocHead."document status"::Open;
            recDelDocHead."Requested Delivery Date" := pPlannedDeliveryDate;
            recDelDocHead."Requested Ship Date" := pSlShipmentDate;
            SetRequestedDates(pSlShipmentDate, pSalesHead."Ship-to Country/Region Code", COPYSTR(pSalesHead."Shortcut Dimension 1 Code", 1, 10), recDelDocHead."Requested Ship Date", recDelDocHead."Requested Delivery Date", recDelDocHead."Expected Release Date");  // 14-11-18 ZY-LD 006  // 14-11-19 ZY-LD 015
            recDelDocHead."Requested Delivery Date" := 0D;
            recDelDocHead."Requested Ship Date" := 0D;
            recDelDocHead."Create User ID" := copystr(UserId(), 1, 50);
            recDelDocHead."Create Date" := Today();
            recDelDocHead."Create Time" := Time();
            recDelDocHead."Warehouse Status" := recDelDocHead."warehouse status"::New;
            recDelDocHead."Mode Of Transport" := CopyStr(pTransportMethod, 1, 10);
            if pSalesHead."Currency Code" = '' then
                recDelDocHead."Currency Code" := recGenLedgSetup."LCY Code"
            else
                recDelDocHead."Currency Code" := pSalesHead."Currency Code";

            recDelComment.SetFilter("Delivery Document No.", recDelDocHead."No.");
            if not recDelComment.FindFirst() then begin
                recDelComment.Init();
                recDelComment."Delivery Document No." := recDelDocHead."No.";
                recDelComment.Insert();
            end;

            recDelDocHead."Document Date" := WorkDate();

            recDelDocHead."Salesperson Code" := pSalesHead."Salesperson Code";
            recDelDocHead."Order Desk Resposible Code" := pSalesHead."Order Desk Resposible Code";

            if pSalesHead."Ship-to Code Del. Doc" = '' then begin
                recDelDocHead.Validate(recDelDocHead."Sell-to Customer No.", pSalesHead."Sell-to Customer No.");
                recDelDocHead."Sell-to Customer Name" := pSalesHead."Sell-to Customer Name";
                recDelDocHead."Sell-to Customer Name 2" := pSalesHead."Sell-to Customer Name 2";
                recDelDocHead."Sell-to Address" := pSalesHead."Sell-to Address";
                recDelDocHead."Sell-to Address 2" := pSalesHead."Sell-to Address 2";
                recDelDocHead."Sell-to City" := pSalesHead."Sell-to City";
                recDelDocHead."Sell-to Contact" := pSalesHead."Sell-to Contact";
                recDelDocHead."Sell-to Post Code" := pSalesHead."Sell-to Post Code";
                recDelDocHead."Sell-to County" := pSalesHead."Sell-to County";
                recDelDocHead.Validate(recDelDocHead."Sell-to Country/Region Code", pSalesHead."Sell-to Country/Region Code");

                recDelDocHead."Bill-to Customer No." := pSalesHead."Bill-to Customer No.";
                recDelDocHead."Bill-to Name" := pSalesHead."Bill-to Name";
                recDelDocHead."Bill-to Name 2" := pSalesHead."Bill-to Name 2";
                recDelDocHead."Bill-to Address" := pSalesHead."Bill-to Address";
                recDelDocHead."Bill-to Address 2" := pSalesHead."Bill-to Address 2";
                recDelDocHead."Bill-to City" := pSalesHead."Bill-to City";
                recDelDocHead."Bill-to Contact" := pSalesHead."Bill-to Contact";
                recDelDocHead."Bill-to County" := pSalesHead."Bill-to County";
                recDelDocHead."Bill-to Post Code" := pSalesHead."Bill-to Post Code";
                recDelDocHead."Bill-to Country/Region Code" := pSalesHead."Bill-to Country/Region Code";

                if recBillToCust.Get(pSalesHead."Bill-to Customer No.") then begin
                    recDelDocHead."Bill-to Email" := recBillToCust."E-Mail";
                    recDelDocHead."Bill-to Phone" := recBillToCust."Phone No.";
                    recDelDocHead."Bill-to TaxID" := recBillToCust."VAT Registration No.";
                end;
                recDelDocHead."Ship-to TaxID" := pSalesHead."Ship-to VAT";
            end else begin
                CustRework.SetRange("Search Name", ReworkLbl);
                CustRework.FindFirst();

                recDelDocHead.Validate("Sell-to Customer No.", CustRework."No.");
                recDelDocHead."Sell-to Customer Name" := CustRework.Name;
                recDelDocHead."Sell-to Customer Name 2" := CustRework."Name 2";
                recDelDocHead."Sell-to Address" := CustRework.Address;
                recDelDocHead."Sell-to Address 2" := CustRework."Address 2";
                recDelDocHead."Sell-to City" := CustRework.City;
                recDelDocHead."Sell-to Contact" := CustRework.Contact;
                recDelDocHead."Sell-to Post Code" := CustRework."Post Code";
                recDelDocHead."Sell-to County" := CustRework.County;
                recDelDocHead.Validate("Sell-to Country/Region Code", CustRework."Country/Region Code");
                recDelDocHead."Ship-to TaxID" := CustRework."VAT Registration No.";

                recDelDocHead."Bill-to Customer No." := CustRework."No.";
                recDelDocHead."Bill-to Name" := CustRework."Name";
                recDelDocHead."Bill-to Name 2" := CustRework."Name 2";
                recDelDocHead."Bill-to Address" := CustRework."Address";
                recDelDocHead."Bill-to Address 2" := CustRework."Address 2";
                recDelDocHead."Bill-to City" := CustRework."City";
                recDelDocHead."Bill-to Contact" := CustRework."Contact";
                recDelDocHead."Bill-to County" := CustRework."County";
                recDelDocHead."Bill-to Post Code" := CustRework."Post Code";
                recDelDocHead."Bill-to Country/Region Code" := CustRework."Country/Region Code";
                recDelDocHead."Bill-to Email" := CustRework."E-Mail";
                recDelDocHead."Bill-to Phone" := CustRework."Phone No.";
                recDelDocHead."Bill-to TaxID" := CustRework."VAT Registration No.";
            end;

            if recLocation.Get(pSalesHead."Location Code") then begin
                recDelDocHead.Validate(recDelDocHead."Ship-From Code", recLocation.Code);
                recDelDocHead."Ship-From Name" := recLocation.Name;
                recDelDocHead."Ship-From Name 2" := recLocation."Name 2";
                recDelDocHead."Ship-From Address" := recLocation.Address;
                recDelDocHead."Ship-From Address 2" := recLocation."Address 2";
                recDelDocHead."Ship-From City" := recLocation.City;
                recDelDocHead."Ship-From Contact" := recLocation.Contact;
                recDelDocHead."Ship-From Post Code" := recLocation."Post Code";
                recDelDocHead."Ship-From County" := recLocation.County;
                recDelDocHead."Ship-From Country/Region Code" := recLocation."Country/Region Code";
                recDelDocHead."Ship-From Phone" := recLocation."Phone No.";
                recDelDocHead."Ship-From TaxID" := recLocation."VAT Registration No";
                recDelDocHead."Ship-From Email" := recLocation."E-Mail";
            end;

            if (pSalesHead."Ship-to Code Del. Doc" <> '') and (recShiptoAdd.Get(recDelDocHead."Sell-to Customer No.", pSalesHead."Ship-to Code Del. Doc")) then begin
                recShiptoAdd.TestField(Name);
                recShiptoAdd.TestField(Address);
                recShiptoAdd.TestField("Post Code");
                recShiptoAdd.TestField(City);
                recShiptoAdd.TestField("Country/Region Code");
                recDelDocHead."Ship-to Name" := recShiptoAdd.Name;
                recDelDocHead."Ship-to Name 2" := recShiptoAdd."Name 2";
                recDelDocHead."Ship-to Address" := recShiptoAdd.Address;
                recDelDocHead."Ship-to Address 2" := recShiptoAdd."Address 2";
                recDelDocHead."Ship-to City" := recShiptoAdd.City;
                recDelDocHead."Ship-to Contact" := recShiptoAdd.Contact;
                recDelDocHead."Ship-to Post Code" := recShiptoAdd."Post Code";
                recDelDocHead."Ship-to County" := recShiptoAdd.County;
                recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", recShiptoAdd."Country/Region Code");
                recDelDocHead.validate("Delivery Terms Terms", recShiptoAdd."Shipment Method Code");
            end else begin
                if recCountryShipDay.Get(pSalesHead."Ship-to Country/Region Code") and (recCountryShipDay."Ship-To Code" <> '') then begin
                    recShiptoAdd.Get(recDelDocHead."Bill-to Customer No.", recCountryShipDay."Ship-To Code");
                    recShiptoAdd.TestField(Name);
                    recShiptoAdd.TestField(Address);
                    recShiptoAdd.TestField("Post Code");
                    recShiptoAdd.TestField(City);
                    recShiptoAdd.TestField("Country/Region Code");
                    recDelDocHead."Ship-to Name" := recShiptoAdd.Name;
                    recDelDocHead."Ship-to Name 2" := recShiptoAdd."Name 2";
                    recDelDocHead."Ship-to Address" := recShiptoAdd.Address;
                    recDelDocHead."Ship-to Address 2" := recShiptoAdd."Address 2";
                    recDelDocHead."Ship-to City" := recShiptoAdd.City;
                    recDelDocHead."Ship-to Contact" := recShiptoAdd.Contact;
                    recDelDocHead."Ship-to Post Code" := recShiptoAdd."Post Code";
                    recDelDocHead."Ship-to County" := recShiptoAdd.County;
                    recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", recShiptoAdd."Country/Region Code");
                end else begin
                    recDelDocHead."Ship-to Name" := pSalesHead."Ship-to Name";
                    recDelDocHead."Ship-to Name 2" := pSalesHead."Ship-to Name 2";
                    recDelDocHead."Ship-to Address" := pSalesHead."Ship-to Address";
                    recDelDocHead."Ship-to Address 2" := pSalesHead."Ship-to Address 2";
                    recDelDocHead."Ship-to City" := pSalesHead."Ship-to City";
                    recDelDocHead."Ship-to Contact" := pSalesHead."Ship-to Contact";
                    recDelDocHead."Ship-to Post Code" := pSalesHead."Ship-to Post Code";
                    recDelDocHead."Ship-to County" := pSalesHead."Ship-to County";
                    recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", pSalesHead."Ship-to Country/Region Code");
                end;
                recDelDocHead.Validate(recDelDocHead."Delivery Terms Terms", pSalesHead."Shipment Method Code");
            end;

            recDelDocHead."Ship-to Code" := copystr(pShipToCode, 1, 20);
            recDelDocHead."Shipment Agent Code" := GetDefaultShipmentAgentCode();
            recDelDocHead."Delivery Terms City" := recDelDocHead."Ship-to City";
            recDelDocHead."Shipment Agent Service" := GetDefaultShipmentAgentSerCode(GetDefaultShipmentAgentCode());

            if (pSalesHead."Sales Order Type" = pSalesHead."sales order type"::"Spec. Order") or
               pSalesHead."Create Delivery Doc. pr. Order"
            then
                recDelDocHead."Spec. Order No." := pSalesHead."No.";

            //INSERT;
            // #487744 >>
            if (recDelDocHead."Delivery Terms Terms" <> '') and
                (recDelDocHead."Ship-From Code" <> '') then
                recDelDocHead.Validate("Delivery Terms Terms");
            // #487744 <<
            recDelDocHead.Modify(true);

            recDefAction.Reset();
            recDefAction.SetRange("Source Type", recDefAction."source type"::Customer, recDefAction."source type"::"Ship-to Address");
            recDefAction.SetFilter("Source Code", '%1|%2', recDelDocHead."Sell-to Customer No.", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode)));
            recDefAction.SetRange("Customer No.", recDelDocHead."Sell-to Customer No.");
            recDefAction.SetRange("Header / Line", recDefAction."header / line"::Header);
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate());

            if pSalesHead."Sales Order Type" <> pSalesHead."sales order type"::"Spec. Order" then
                recDefAction.SetFilter("Sales Order Type", '<>%1', pSalesHead."Sales Order Type");

            if recDefAction.FindSet() then
                repeat
                    recDelDocAction.InitLine(recDefAction);
                    recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                    if not recDelDocAction.Insert(true) then;
                until recDefAction.Next() = 0;

            recDefAction.Reset();
            recDefAction.SetRange("Source Type", recDefAction."source type"::"Ship-to Address");
            recDefAction.SetRange("Source Code", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode)));
            recDefAction.SetRange("Customer No.", recDelDocHead."Sell-to Customer No.");
            recDefAction.SetRange("Header / Line", recDefAction."header / line"::Line);
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate());
            if recDefAction.FindSet() then
                repeat
                    recDelDocAction.InitLine(recDefAction);
                    recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                    if not recDelDocAction.Insert(true) then;
                until recDefAction.Next() = 0;

            nocreated := nocreated + 1;
            rValue := recDelDocHead."No.";
        end;
    end;

    local procedure SetRequestedDates(pShipmentDate: Date; pShipToCountry: Code[20]; pDivisionCode: Code[10]; var ReqShipmentDate: Date; var ReqDeliveryDate: Date; var ExpReleaseDate: Date)
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recCtryShipDay: Record "VCK Country Shipment Days";
    begin
        recSalesSetup.Get();
        if pShipmentDate >= Today() then begin  // Forward
            if pShipmentDate = 0D then
                ReqShipmentDate := Today();
            if ReqDeliveryDate = 0D then
                ReqDeliveryDate := Today();
        end else begin  // Backward
            if not recCtryShipDay.Get(pShipToCountry) then
                recCtryShipDay."Delivery Days" := recSalesSetup."Delivery Days to Add";

            ReqShipmentDate := CalcShipmentDate('', '', pShipToCountry, pDivisionCode, Today(), false);

            ReqDeliveryDate := CalcDate(Format(recCtryShipDay."Delivery Days") + 'D', ReqShipmentDate);
            if Date2dwy(ReqDeliveryDate, 1) > 5 then
                GetNextWeekday(1, ReqDeliveryDate);

            ExpReleaseDate := ReqShipmentDate - 1;
            if Date2dwy(ExpReleaseDate, 1) > 5 then
                GetPrevWeekday(5, ExpReleaseDate);
        end;
    end;

    local procedure CreateDeliveryDocumentLine(pSalesLine: Record "Sales Line"; pDocumentNo: Code[20]; pSalesPersonCode: Code[50]) rValue: Boolean
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recDelDocLine2: Record "VCK Delivery Document Line";
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        GenBusPostGrp: Record "Gen. Business Posting Group";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        SalesLinePrice: Codeunit "Sales Line - Price";
        LineWithPrice: Interface "Line With Price";
        PriceCalculation: Interface "Price Calculation";

        Line: Variant;
    begin
        begin
            recDelDocLine2.SetRange("Sales Order No.", pSalesLine."Document No.");
            recDelDocLine2.SetRange("Sales Order Line No.", pSalesLine."Line No.");
            recDelDocLine2.SetFilter("Document No.", '<>%1', pDocumentNo);
            recDelDocLine2.SetFilter(Quantity, '<>0');  //It can happent that a line is created and set to 0 on the delivery document.
            if recDelDocLine2.IsEmpty() then begin
                recDelDocLine.Init();
                recDelDocLine."Salesperson Code" := pSalesPersonCode;
                recDelDocLine."Document No." := pDocumentNo;
                recDelDocLine."Line No." := GetNextLineNo(pDocumentNo);
                recDelDocLine."Item No." := pSalesLine."No.";
                recDelDocLine."Unit of Measure Code" := pSalesLine."Unit of Measure Code";
                recDelDocLine.Description := pSalesLine.Description;
                recDelDocLine.Location := pSalesLine."Location Code";
                recDelDocLine."Sales Order No." := pSalesLine."Document No.";
                recDelDocLine."Sales Order Line No." := pSalesLine."Line No.";
                recDelDocLine."Customer Order No." := CopyStr(pSalesLine."External Document No.", 1, MaxStrLen(recDelDocLine."Customer Order No."));
                recDelDocLine."Customer Order Position No." := pSalesLine."External Document Position No."; //23-05-2025 BK #508124
                recDelDocLine."Warehouse Status" := recDelDocLine."warehouse status"::New;
                recDelDocLine.Validate(recDelDocLine."Currency Code", pSalesLine."Currency Code");
                recDelDocLine.Quantity := pSalesLine."Outstanding Quantity";

                if pSalesLine."Unit Price" = 0 then begin
                    recsalesline.SetRange("Document Type", pSalesLine."Document Type");
                    recSalesLine.SetRange("Document No.", pSalesLine."Document No.");
                    recSalesLine.SetFilter("Line No.", '<>%1', pSalesLine."Line No.");
                    recSalesLine.SetRange(Type, pSalesLine.Type);
                    recSalesLine.SetRange("No.", pSalesLine."No.");
                    recSalesLine.SetFilter("Unit Price", '<>0');
                    if recSalesLine.FindFirst() then
                        pSalesLine."Unit Price" := recSalesLine."Unit Price"
                    else begin
                        recSalesHead.Get(pSalesLine."Document Type", pSalesLine."Document No.");

                        LineWithPrice := SalesLinePrice;
                        LineWithPrice.SetLine("Price Type"::Sale, pSalesLine);
                        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
                        PriceCalculation.ApplyDiscount();
                        PriceCalculation.ApplyPrice(0);
                        PriceCalculation.GetLine(Line);
                        pSalesLine := line;
                    end;

                    if pSalesLine."Unit Price" = 0 then
                        pSalesLine."Unit Price" := pSalesLine."Unit Cost";
                end;
                recDelDocLine.Validate(recDelDocLine."Unit Price", pSalesLine."Unit Price");
                recDelDocLine.Validate(recDelDocLine."VAT %", pSalesLine."VAT %");
                recDelDocLine.Validate(recDelDocLine."Line Discount %", pSalesLine."Line Discount %");
                recDelDocLine.Validate(recDelDocLine.Amount);
                if GenBusPostGrp.get(pSalesLine."Gen. Bus. Posting Group") and
                  (GenBusPostGrp."Sample / Test Equipment" = GenBusPostGrp."Sample / Test Equipment"::"Sample (Unit Price = Zero)")
                then
                    recDelDocLine.Validate("Do not Calculate Amount", true);
                rValue := recDelDocLine.Insert(true);
            end;
        end;
    end;


    procedure EnterActionCode(pSourceCode: Code[20]; pCustNo: Code[20]; pSourceType: Option " ",Customer,"Ship-to Code",,Location)
    var
        recDefActionTmp: Record "Default Action" temporary;
    begin
        recDefActionTmp."Source Type" := pSourceType;
        recDefActionTmp."Source Code" := pSourceCode;
        recDefActionTmp."Customer No." := pCustNo;
        if recDefActionTmp.Insert() then;

        Page.RunModal(Page::"Def. Action Code", recDefActionTmp);
    end;


    procedure EnterDelDocActionCode(pDelDocNo: Code[20])
    var
        recDelDocActionTmp: Record "Delivery Document Action Code" temporary;
    begin
        recDelDocActionTmp."Delivery Document No." := pDelDocNo;
        recDelDocActionTmp.Insert();

        Page.RunModal(Page::"Del. Doc Action Code", recDelDocActionTmp);
    end;


    procedure WhyCanDelDocNotRelase(var pSalesLine: Record "Sales Line")
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        lText001: Label 'Delete the line, and create it again.';
        lText002: Label 'Correct value is "0".';
        lText003: Label 'The line has been posted.';
    begin
        begin
            recSalesSetup.Get();
            recSalesSetup.TestField("Del. Doc. Creation Calculation");

            if (pSalesLine."Sales Order Type" <> pSalesLine."sales order type"::Normal) and
               (pSalesLine."Sales Order Type" <> pSalesLine."sales order type"::"Spec. Order") and
               (pSalesLine."Sales Order Type" <> pSalesLine."sales order type"::Other)
            then
                Message('%1 = "%2"', pSalesLine.FieldCaption(pSalesLine."Sales Order Type"), pSalesLine."Sales Order Type")
            else
                if pSalesLine.Status = pSalesLine.Status::Open then
                    Message('%1 = "%2"', pSalesLine.FieldCaption(pSalesLine.Status), Format(pSalesLine.Status))
                else
                    if pSalesLine.Type <> pSalesLine.Type::Item then
                        Message('%1 = "%2"', pSalesLine.FieldCaption(pSalesLine.Type), Format(pSalesLine.Type))
                    else
                        if not pSalesLine."Shipment Date Confirmed" then
                            Message('%1 = "%2"', pSalesLine.FieldCaption(pSalesLine."Shipment Date Confirmed"), pSalesLine."Shipment Date Confirmed")
                        else
                            if pSalesLine."Shipment Date" > CalcDate(recSalesSetup."Del. Doc. Creation Calculation", Today) then
                                Message('%1 > "%2"', pSalesLine.FieldCaption(pSalesLine."Shipment Date"), CalcDate(recSalesSetup."Del. Doc. Creation Calculation", Today))
                            else
                                if StrPos(ItemLogisticEvents.GetRequireShipmentLocations(), pSalesLine."Location Code") = 0 then
                                    Message('%1 <> "%2"', pSalesLine.FieldCaption(pSalesLine."Location Code"), ItemLogisticEvents.GetRequireShipmentLocations())
                                else
                                    if pSalesLine."Ship-to Code" = '' then
                                        Message('%1 = "%2"', pSalesLine.FieldCaption(pSalesLine."Ship-to Code"), pSalesLine."Ship-to Code")
                                    else
                                        if pSalesLine."Outstanding Quantity" = 0 then begin
                                            if pSalesLine."Quantity Shipped" <> 0 then
                                                Message(lText003)
                                            else
                                                Message('%1 = "%2".', pSalesLine.FieldCaption(pSalesLine."Outstanding Quantity"), pSalesLine."Outstanding Quantity")
                                        end else
                                            if pSalesLine."Delivery Document No." <> '' then
                                                Message('%1 = "%2"', pSalesLine.FieldCaption(pSalesLine."Delivery Document No."), pSalesLine."Delivery Document No.")
                                            else
                                                if pSalesLine."BOM Line No." <> 0 then
                                                    Message('%1 = "%2". %3\\Proposted Solution: %4', pSalesLine.FieldCaption(pSalesLine."BOM Line No."), pSalesLine."BOM Line No.", lText002, lText001)
                                                else
                                                    if pSalesLine."Unconfirmed Additional Line" <> 0 then
                                                        Message('%1 = "%2". %3', pSalesLine.FieldCaption(pSalesLine."Unconfirmed Additional Line"), pSalesLine."Unconfirmed Additional Line", lText002);
        end;

    end;

    local procedure CopyCommentLines(FromDocumentType: Enum "Sales Line Type"; ToDocumentType: Enum "Sales Comment Document Type";
                                                           FromNumber: Code[20];
                                                           ToNumber: Code[20])
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine2: Record "Sales Comment Line";
        SalesCommentLine3: Record "Sales Comment Line";
        lText001: Label 'Copy from %1';
        NextLineNo: Integer;
    begin
        SalesCommentLine3.SetRange("Document Type", ToDocumentType);
        SalesCommentLine3.SetRange("No.", ToNumber);
        SalesCommentLine3.SetRange("Document Line No.", 0);
        SalesCommentLine3.SetRange("From Document No.", FromNumber);
        if SalesCommentLine3.IsEmpty() then begin
            SalesCommentLine3.SetRange("From Document No.");
            if SalesCommentLine3.FindLast() then
                NextLineNo := SalesCommentLine3."Line No.";

            SalesCommentLine.SetRange("Document Type", FromDocumentType);
            SalesCommentLine.SetRange("No.", FromNumber);
            SalesCommentLine.SetRange("Document Line No.", 0);
            SalesCommentLine.SetFilter(Code, '<>%1', 'QUOTE');
            if SalesCommentLine.FindSet() then begin
                NextLineNo += 10000;
                SalesCommentLine2.Init();
                SalesCommentLine2."Document Type" := ToDocumentType;
                SalesCommentLine2."No." := ToNumber;
                SalesCommentLine2."Line No." := NextLineNo;
                SalesCommentLine2.Comment := StrSubstNo(lText001, FromNumber);
                SalesCommentLine2.Insert();
                repeat
                    NextLineNo += 10000;
                    SalesCommentLine2 := SalesCommentLine;
                    SalesCommentLine2."Document Type" := ToDocumentType;
                    SalesCommentLine2."No." := ToNumber;
                    SalesCommentLine2."Line No." := NextLineNo;
                    SalesCommentLine2."From Document No." := FromNumber;
                    SalesCommentLine2.Insert();
                until SalesCommentLine.Next() = 0;
            end;
        end;
    end;

    local procedure GetNextLineNo(pNo: Code[20]): Integer
    var
        recDelDocLine: Record "VCK Delivery Document Line";
    begin
        recDelDocLine.SetRange("Document No.", pNo);
        if recDelDocLine.FindLast() then
            exit(recDelDocLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetDefaultShipmentAgentCode(): Code[10]
    var
        recShipAgent: Record "VCK Shipment Agent Code";
    begin
        recShipAgent.SetRange(Default, true);
        if recShipAgent.FindFirst() then
            exit(recShipAgent.Code);
    end;

    local procedure GetDefaultShipmentAgentSerCode(ShippingAgentCode: Code[10]): Code[10]
    var
        recShipAgentServ: Record "VCK Shipment Agent Service";
    begin
        recShipAgentServ.SetRange(Default, true);
        recShipAgentServ.SetRange("Shipment Agent Code", ShippingAgentCode);
        if recShipAgentServ.FindFirst() then
            exit(recShipAgentServ.Code);
    end;

    //11-08-2025 BK #518362
    local procedure CheckShippingAdvise(LocSalesHeader: Record "Sales Header"; LocSalesLine: Record "Sales Line"): Boolean
    var
        FullyConfirmed: Boolean;
    begin
        FullyConfirmed := true;
        If LocSalesHeader."Shipping Advice" = LocSalesHeader."Shipping Advice"::Complete then begin
            LocSalesLine.SetRange("Document Type", LocSalesLine."Document Type"::Order);
            LocSalesLine.SetRange("Document No.", LocSalesHeader."No.");
            if LocSalesLine.FindSet() then
                repeat
                    If NOT LocSalesLine."Shipment Date Confirmed" then
                        FullyConfirmed := false;
                until (LocSalesLine.Next() = 0) OR (Not FullyConfirmed);
        end;
        exit(FullyConfirmed);
    end;
}
