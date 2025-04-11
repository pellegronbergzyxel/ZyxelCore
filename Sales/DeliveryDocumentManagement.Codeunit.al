codeunit 50008 "Delivery Document Management"
{
    // 001. 23-04-18 ZY-LD 2018042010000117 - Sent to all in is set to FALSE.
    // 002. 06-09-18 ZY-LD 2018090610000046 - New function for calculation of "Shipment Date".
    // 003. 14-09-18 ZY-LD 2018091410000272 - Create delivery document handled by one function.
    // 004. 04-10-18 ZY-LD 2018100410000065 - DL Customer Order No. is only 30 characters.
    // 005. 29-10-18 ZY-LD 2018102810000029 - For the sake of VCK, we add one day after 12:00. It replaces the previous solution.
    // 006. 14-11-18 ZY-LD 2018111410000124 - Only channel customers has a calendar.
    // 007. 28-01-19 ZY-LD 2019012810000053 - Testfields inserted.
    // 008. 19-03-19 ZY-LD 2019031910000031 - Picking Start Date can be set pr. item.
    // 009. 30-04-19 ZY-LD P0225 - Code in ReleaseDocument is adjusted.
    // 010. 01-05-19 ZY-LD P0226 - Code in "CreateTransferDocument" is adjusted.
    // 011. 01-05-19 ZY-LD P0226 - Number series is setup for DD.
    // 012. 13-06-19 ZY-LD P0213 - Orders "On Hold" will not be created as delivery document.
    // 013. 10-07-19 ZY-LD P0213 - Changed the filter on "Delivery Document No." on the sales line.
    // 014. 05-08-19 ZY-LD 2019080510000146 - It happens that a DD Line is created twice. We will prevent that.
    // 015. 14-11-19 ZY-LD P0332 - Calc Prev weekday.
    // 016. 06-12-19 ZY-LD 000 - Due to end of quarter, there was a wrong calculation of picking date.
    // 017. 09-01-20 ZY-LD 000 - It happened sometimes, that the "Delivery Document No." on the sales line was not updated, and then it tried to add the same line to two DDs.
    // 018. 24-01-20 ZY-LD 000 - Creation of action codes is moved to release of delivery document, so we can prove which codes has been sent to the warehouse.
    // 019. 25-02-20 ZY-LD P0398 - Special Order.
    // 020. 09-07-20 ZY-LD P0455 - Create Delivery Document pr. "Shipment Method Code".
    // 021. 08-10-20 ZY-LD P0494 - Filter on sales line. Both the main line and the additional lines must be confirmed.
    // 022. 13-11-20 ZY-LD P0499 - The fields are "Source No." and "Source Line No.". The Transfer Order fields will be faced out.
    // 023. 18-11-20 ZY-LD 2020111710000043 - Filter on more than one location.
    // 024. 14-12-20 ZY-LD 2020121410000118 - It has been seen that scanned orders has got a wrong location code, so now we filter on "Sales Order Type".
    // 025. 19-04-21 ZY-LD 2021041910000042 - Shows why a line not will create as delivery document.
    // 026. 14-06-21 ZY-LD 000 - Create Delivery Document for a single order.
    // 027. 28-06-21 ZY-LD P0631 - Create DD per currency code, because of customs invoice.
    // 028. 20-09-21 ZY-LD 2021082510000103 - Calculate shipment date.
    // 029. 01-11-21 ZY-LD 2021110110000044 - Transfer "Ship-to TaxID".
    // 030. 01-11-21 ZY-LD 000 - Final Destination.
    // 031. 05-11-21 ZY-LD 2021110310000031 - Copy order comments.
    // 032. 01-12-21 ZY-LD 2021113010000114 - Set "VAT Registration No. Zyxel", so "Customs Invoice" will be printed correctly.
    // 033. 15-12-21 ZY-LD 2021120610000088 - On Customs/Shipment Invoice we have to show unit price.
    // 034. 29-12-21 ZY-LD 2021122810000153 - In Turkey some items demands a lot of extra documentation to get through customs. These must go to a separate delivery document, so it won´t delay other items in the same shipment.
    // 035. 17-02-22 ZY-LD 2022021710000039 - "Incoterms City" was not set correct.
    // 036. 10-03-22 ZY-LD P0767 - Filter action code on "End Date", and split e-mail addresses.
    // 037. 13-04-22 ZY-LD 2022041310000104 - We don´t want all items added to the delivery document. // 18-05-22 Now we need it on the DD, and handle it different.
    // 038. 02-05-22 ZY-LD 000 - On request from Peer, the fields has been blanked, and can only be updated manually.
    // 039. 20-05-22 ZY-LD 000 - Location Code has been added to the header, so we can separate delivery documents pr. location code.
    // 040. 30-06-22 ZY-LD 000 - "Transfer-to Address Code" is avaliable on the transfer line.
    // 041. 30-08-22 ZY-LD 000 - Create DD without confirmation.
    // 042. 02-06-23 ZY-LD 000 - Insert sales person code if possible.
    // 043. 14-08-23 ZY-LD 000 - If the price is different on the customs invoice, it might be rejected at the customs in some countries.
    // 044. 17-10-23 ZY-LD 000 - "Order Desk Responsible Code" is updated.
    // 045. 18-12-23 ZY-LD 000 - If it´s a sample the invoice will be zero and the DD with an amount, and the invoice will then not post automatic.
    // 046. 05-04-24 ZY-LD #7032991 - If currency code is blank, then we use LCY in general ledger setup.
    // 047. 19-05-24 ZY-LD 000 - Use rework ship-to address if the product has to be shipped to DK before it´s shipped to the customer.
    // 048. 05-07-24 ZY-LD 000 - Made it possible to make a "Rework Ship-to Address".

    trigger OnRun()
    var
        recAutoSetup: Record "Automation Setup";
    begin
        recAutoSetup.Get();
        if recAutoSetup.WhseCreateOutboundSales then
            CreateDeliveryDocument('');
        if recAutoSetup.WhseCreateOutboundTransfer then
            CreateDeliveryDocumentTransfer('');
    end;

    var
        nocreated: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
        ReworkLbl: Label 'REWORK';


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
        //>> 14-06-21 ZY-LD 026
        if Confirm(lText001, true, SalesOrderNo) then
            CreateDeliveryDocument(SalesOrderNo);
        //<< 14-06-21 ZY-LD 026
    end;


    procedure PerformCreationForSingleOrderWithoutConfirmation(SalesOrderNo: Code[20])
    var
        lText001: Label 'Do you want to create delivery document for sales order %1?';
    begin
        CreateDeliveryDocument(SalesOrderNo);  // 30-08-22 ZY-LD 041
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
        //>> 12-01-21 ZT-LD 022
        begin
            recSalesSetup.Get();  // 02-06-21 ZY-LD 026
            recSalesSetup.TestField("Del. Doc. Creation Calculation");  // 02-06-21 ZY-LD 026

            recTransLine.SetRange(recTransLine."Shipment Date Confirmed", true);
            //SETFILTER("Shipment Date",'..%1',today + 5);  // 02-06-21 ZY-LD 026
            recTransLine.SetFilter(recTransLine."Shipment Date", '..%1', CalcDate(recSalesSetup."Del. Doc. Creation Calculation", Today));  // 02-06-21 ZY-LD 026
            recTransLine.SetRange(recTransLine.Status, recTransLine.Status::Released);
            recTransLine.SetFilter(recTransLine."Delivery Document No.", '%1', '');
            recTransLine.SetFilter(recTransLine."Transfer-from Code", ItemLogisticEvents.GetRequireShipmentLocations);
            recTransLine.SetFilter(recTransLine."Outstanding Quantity", '>0');
            recTransLine.SetFilter(recTransLine."Transfer-to Code", '<>%1', '');
            if pNo <> '' then
                recTransLine.SetRange(recTransLine."Document No.", pNo);
            if recTransLine.FindSet(true) then
                repeat
                    recTransHead.Get(recTransLine."Document No.");

                    if (recTransLine."Transfer-to Address Code" <> '') or (recTransHead."Transfer-to Address Code" <> '') then begin  // 03-08-22 ZY-LD 040
                        recDelDocHead.SetRange("Document Type", recDelDocHead."document type"::Transfer);
                        //>> 30-06-22 ZY-LD 040
                        if recTransLine."Transfer-to Address Code" <> '' then
                            ShipToCode := recTransLine."Transfer-to Code" + '.' + recTransLine."Transfer-to Address Code"
                        else  //<< 30-06-22 ZY-LD 040
                            ShipToCode := recTransLine."Transfer-to Code" + '.' + recTransHead."Transfer-to Address Code";  // 03-08-22 ZY-LD 040
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
                          recTransHead."Ref./ PO",
                          recTransHead."Assigned User ID",
                          recDelDocHead."Currency Code");  // 28-06-21 ZY-LD 027
                    end;
                until recTransLine.Next() = 0;
        end;
        //<< 12-01-21 ZT-LD 022
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
        //>> 14-09-18 ZY-LD 003
        begin
            recSalesSetup.Get();
            recGenLedgSetup.Get();  // 28-06-21 ZY-LD 027
            recGenLedgSetup.TestField("LCY Code");  // 28-06-21 ZY-LD 027
            recWhseSetup.Get();
            recWhseSetup.TestField("Whse. Delivery Document Nos.");

            recDelDocHead.Init();
            recDelDocHead.Insert(true);

            //>> 02-06-23 ZY-LD 042
            //"Salesperson Code" := "Create User ID";
            if recUserSetup.Get(recDelDocHead."Create User ID") and (recUserSetup."Salespers./Purch. Code" <> '') then
                recDelDocHead."Salesperson Code" := recUserSetup."Salespers./Purch. Code"
            else
                recDelDocHead."Salesperson Code" := CopyStr(recDelDocHead."Create User ID", 1, MaxStrLen(recUserSetup."Salespers./Purch. Code"));
            //<< 02-06-23 ZY-LD 042
            recDelDocHead."Order Desk Resposible Code" := recDelDocHead."Salesperson Code";  // 17-10-23 ZY-LD 044
            recDelDocHead."Document Type" := recDelDocHead."document type"::Transfer;
            recDelDocHead."Source No." := pTransHead."No.";
            recDelDocHead."Document Status" := recDelDocHead."document status"::Open;
            recDelDocHead."Warehouse Status" := recDelDocHead."warehouse status"::New;

            //"Requested Delivery Date" := pTransHead."Shipment Date";  // 02-05-22 ZY-LD 038
            //"Requested Ship Date" := pTransHead."Shipment Date";  // 02-05-22 ZY-LD 038

            recDelDocHead."Mode Of Transport" := pTransHead."Transport Method";
            recDelDocHead."Shipment Agent Code" := GetDefaultShipmentAgentCode;
            recDelDocHead."Delivery Terms City" := pTransHead."Transfer-to City";
            //"Delivery Zone" := "Delivery Zone";
            //"Delivery Terms Terms" := pTransHead."Shipment Method Code";  // 17-02-22 ZY-LD 035
            recDelDocHead."Shipment Agent Service" := GetDefaultShipmentAgentSerCode(GetDefaultShipmentAgentCode);
            recDelDocHead."Shipment Agent Code" := GetDefaultShipmentAgentCode;
            recDelDocHead."Currency Code" := recGenLedgSetup."LCY Code";  // 28-06-21 ZY-LD 027

            recDelDocHead."Document Date" := WorkDate;
            recDelDocHead."Ship-to Code" := pShipToCode;


            //>> 30-06-22 ZY-LD 022
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
            end else begin  //<< 30-06-22 ZY-LD 022
                recDelDocHead."Ship-to Name" := pTransHead."Transfer-to Name";
                recDelDocHead."Ship-to Name 2" := pTransHead."Transfer-to Name 2";
                recDelDocHead."Ship-to Address" := pTransHead."Transfer-to Address";
                recDelDocHead."Ship-to Address 2" := pTransHead."Transfer-to Address 2";
                recDelDocHead."Ship-to City" := pTransHead."Transfer-to City";
                recDelDocHead."Ship-to Contact" := pTransHead."Transfer-to Contact";
                recDelDocHead."Ship-to Post Code" := pTransHead."Transfer-to Post Code";
                recDelDocHead."Ship-to County" := pTransHead."Transfer-to County";
                recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", pTransHead."Trsf.-to Country/Region Code");  // 01-12-21 ZY-LD 032}
            end;

            recDelDocHead."Sell-to Customer Name" := pTransHead."Transfer-to Name";
            recDelDocHead."Sell-to Customer Name 2" := pTransHead."Transfer-to Name 2";
            recDelDocHead."Sell-to Address" := pTransHead."Transfer-to Address";
            recDelDocHead."Sell-to Address 2" := pTransHead."Transfer-to Address 2";
            recDelDocHead."Sell-to City" := pTransHead."Transfer-to City";
            recDelDocHead."Sell-to Contact" := pTransHead."Transfer-to Contact";
            recDelDocHead."Sell-to Post Code" := pTransHead."Transfer-to Post Code";
            recDelDocHead."Sell-to County" := pTransHead."Transfer-to County";
            recDelDocHead.Validate(recDelDocHead."Sell-to Country/Region Code", pTransHead."Trsf.-to Country/Region Code");  // 01-12-21 ZY-LD 032

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

            recDelDocHead.Validate(recDelDocHead."Ship-From Code", pTransHead."Transfer-from Code");  // 01-12-21 ZY-LD 032
            recDelDocHead."Ship-From Name" := pTransHead."Transfer-from Name";
            recDelDocHead."Ship-From Name 2" := pTransHead."Transfer-from Name 2";
            recDelDocHead."Ship-From Address" := pTransHead."Transfer-from Address";
            recDelDocHead."Ship-From Address 2" := pTransHead."Transfer-from Address 2";
            recDelDocHead."Ship-From City" := pTransHead."Transfer-from City";
            recDelDocHead."Ship-From Contact" := pTransHead."Transfer-from Contact";
            recDelDocHead."Ship-From Post Code" := pTransHead."Transfer-from Post Code";
            recDelDocHead."Ship-From County" := pTransHead."Transfer-from County";
            recDelDocHead."Ship-From Country/Region Code" := pTransHead."Trsf.-from Country/Region Code";

            recDelDocHead.Validate(recDelDocHead."Delivery Terms Terms", pTransHead."Shipment Method Code");  // 17-02-22 ZY-LD 035

            if recLocation.Get(pTransHead."Transfer-to Code") then begin
                recDelDocHead."Notification Email" := recLocation."Notification Email";
                recDelDocHead."Confirmation Email" := recLocation."Confirmation Email";
            end;
            recDelDocHead.Modify(true);

            recDefAction.Reset();
            recDefAction.SetRange("Source Type", recDefAction."source type"::Location, recDefAction."source type"::"Transfer-to Address");
            recDefAction.SetFilter("Source Code", '%1|%2', pTransHead."Transfer-to Code", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode)));
            recDefAction.SetRange("Header / Line", recDefAction."header / line"::Header);
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate);  // 10-03-22 ZY-LD 036
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
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate);  // 10-03-22 ZY-LD 036
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
            if not recDelDocLine2.FindFirst() then begin
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
                recDelDocLine."Currency Code" := pCurrencyCode;  // 28-06-21 ZY-LD 027
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
        DeliveryOffset: Integer;
        recCountryShipmentDays: Record "VCK Country Shipment Days";
    begin
        DeliveryOffset := 0;
        if ShipDate <= Today then
            ShipDate := Today;

        recCountryShipmentDays.SetFilter("Country Code", Country);
        if recCountryShipmentDays.FindFirst() then DeliveryOffset := recCountryShipmentDays."Delivery Days";
        DeliveryDate := CalcDate(Format(DeliveryOffset) + 'D', ShipDate);
        if Date2dwy(DeliveryDate, 1) = 6 then DeliveryDate := CalcDate('2D', DeliveryDate);
        if Date2dwy(DeliveryDate, 1) = 7 then DeliveryDate := CalcDate('1D', DeliveryDate);
    end;


    procedure CalcShipmentDate(pSellToCust: Code[20]; pItemNo: Code[20]; pShipToCountry: Code[20]; pDivisionCode: Code[10]; pInitDate: Date; pChechShipmentTime: Boolean) NewShipmentDate: Date
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recCtryShipDay: Record "VCK Country Shipment Days";
        recCtryShipDaySub: Record "VCK Country Shipm. Day Sub";
        recServEnviron: Record "Server Environment";
        recItemPickDateCountry: Record "Item Picking Date pr. Country";
        recCust: Record Customer;
        LocalTODAY: Date;
        EmailAddMgt: Codeunit "E-mail Address Management";
    begin
        //>> 06-09-18 ZY-LD 002
        //>> 20-09-21 ZY-LD 028
        //IF NOT ZGT.IsRhq THEN
        //  EXIT;
        recSalesSetup.Get();
        if recSalesSetup."Calculate Shipment Date" then begin  //<< 20-09-21 ZY-LD 028
                                                               // We are working with "LocalTODAY" to make it easier to test the solution.
            if recServEnviron.ProductionEnvironment then
                LocalTODAY := Today
            else
                LocalTODAY := WorkDate;

            NewShipmentDate := pInitDate;
            //>> 29-10-18 ZY-LD 005
            // IF NewShipmentDate <= LocalTODAY THEN
            //  NewShipmentDate := LocalTODAY;
            if NewShipmentDate <= LocalTODAY then
                if Time <= 120000T then
                    NewShipmentDate := LocalTODAY + 1
                else
                    NewShipmentDate := LocalTODAY + 2;
            //<< 29-10-18 ZY-LD 005

            if Date2dwy(NewShipmentDate, 1) > 5 then
                NewShipmentDate := GetNextWeekday(1, NewShipmentDate);

            if recCtryShipDay.Get(pShipToCountry) and
               (StrPos(pDivisionCode, 'CH') <> 0)  // 14-11-18 ZY-LD 006  // Only Channes is doing this
            then begin
                // Send e-mail for updating EOQ Dates
                if recServEnviron.ProductionEnvironment then
                    if (Date2dmy(LocalTODAY, 2) mod 3 = 0) and (Date2dmy(recCtryShipDay."Eoq Start Date", 2) <> Date2dmy(LocalTODAY, 2)) then  // xx
                        if (LocalTODAY > recCtryShipDay."Eoq End Date") or (recCtryShipDay."Eoq End Date" = 0D) then begin
                            if not EmailAddMgt.EmailIsSendToday('UPDEOQDATE', true) then begin
                                EmailAddMgt.CreateSimpleEmail('UPDEOQDATE', '', '');
                                EmailAddMgt.Send;
                            end;
                        end;

                if (NewShipmentDate >= recCtryShipDay."Eoq Start Date") and
                   (NewShipmentDate <= recCtryShipDay."Eoq End Date")
                then begin
                    //>> 06-12-19 ZY-LD 016
                    recCtryShipDaySub.SetRange("Country Code", pShipToCountry);
                    recCtryShipDaySub.SetRange("Week Day", Date2dwy(NewShipmentDate, 1));
                    if not recCtryShipDaySub.FindFirst() then  //<< 06-12-19 ZY-LD 016
                        NewShipmentDate := CalcDate(recCtryShipDay."Eoq Date Formula", NewShipmentDate);
                    //>> 06-12-19 ZY-LD 016
                    if Date2dwy(NewShipmentDate, 1) > 5 then
                        NewShipmentDate := GetNextWeekday(1, NewShipmentDate);
                    //<< 06-12-19 ZY-LD 016
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
                            NewShipmentDate := CalcShipmentDate(pSellToCust, pItemNo, pShipToCountry, pDivisionCode, NewShipmentDate + 1, false)  // 14-11-18 ZY-LD 006
                        else
                            NewShipmentDate := CalcShipmentDate(pSellToCust, pItemNo, pShipToCountry, pDivisionCode, NewShipmentDate + 2, false);  // 14-11-18 ZY-LD 006
                                                                                                                                                   //<< 06-09-18 ZY-LD 002

                if not recCust.Get(pSellToCust) then;  // 21-08-19 ZY-LD 015
                if not recCust."Unblock Pick.Date Restriction" then  // 21-08-19 ZY-LD 015
                                                                     //>> 19-03-19 ZY-LD 008
                    if pItemNo <> '' then
                        if recItemPickDateCountry.Get(pItemNo, pShipToCountry) then
                            if NewShipmentDate < recItemPickDateCountry."Picking Start Date" then
                                NewShipmentDate := recItemPickDateCountry."Picking Start Date";
                //<< 19-03-19 ZY-LD 008
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
        //>> 14-11-19 ZY-LD 015
        ThisDay := 0;
        repeat
            CheckDate := CalcDate(Format(ThisDay) + 'D', Date);
            if Date2dwy(CheckDate, 1) = Weekday then begin
                ReturnDate := CheckDate;
                DateFound := true;
            end;
            ThisDay := ThisDay - 1;
        until DateFound = true;
        //<< 14-11-19 ZY-LD 015
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
        recSalesSetup.Get();  // 02-06-21 ZY-LD 026
        recSalesSetup.TestField("Del. Doc. Creation Calculation");  // 02-06-21 ZY-LD 026
        recGenLedgSetup.get;

        //>> 14-06-21 ZY-LD 026
        recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
        if SalesOrderNo <> '' then
            recSalesLine.SetRange("Document No.", SalesOrderNo);
        //<< 14-06-21 ZY-LD 026
        //>> 14-09-18 ZY-LD 003
        recSalesLine.SetRange("Shipment Date Confirmed", true);
        //recSalesLine.SETFILTER("Shipment Date",'..%1',TODAY + 5);  // 02-06-21 ZY-LD 026
        recSalesLine.SetFilter("Shipment Date", '..%1', CalcDate(recSalesSetup."Del. Doc. Creation Calculation", Today));  // 02-06-21 ZY-LD 026
        recSalesLine.SetRange(Status, recSalesLine.Status::Released);
        //recSalesLine.SETFILTER("Delivery Document No.",'<>' + recSalesSetup."Delivery Document Prefix" + '*');  // 10-07-19 ZY-LD 013
        recSalesLine.SetFilter("Delivery Document No.", '%1', '');  // 10-07-19 ZY-LD 013
        //recSalesLine.SETRANGE("Location Code",recSalesSetup."All-In Logistics Location");  // 18-11-20 ZY-LD 023
        recSalesLine.SetFilter("Location Code", ItemLogisticEvents.GetRequireShipmentLocations);  // 18-11-20 ZY-LD 023
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        recSalesLine.SetFilter("BOM Line No.", '<1');
        recSalesLine.SetFilter("Outstanding Quantity", '>0');
        recSalesLine.SetFilter("Ship-to Code", '<>%1', '');  // 18-09-18 ZY-LD - Without the ship-to code we are not able to set correct action code for VCK
        recSalesLine.SetRange("Unconfirmed Additional Line", 0);  // 08-10-20 ZY-LD 021
        recSalesLine.SetFilter("Sales Order Type", '%1|%2|%3', recSalesLine."sales order type"::Normal, recSalesLine."sales order type"::"Spec. Order", recSalesLine."sales order type"::Other);  // 14-12-20 ZY-LD 024
        //recSalesLine.SETFILTER("Gen. Prod. Post. Grp. Type",'%1..',recSalesLine."Gen. Prod. Post. Grp. Type"::Overshipment);  // 13-04-22 ZY-LD 037  // 18-05-22 ZY-LD
        recSalesLine.SetAutoCalcFields("Ship-to Code Cust/Item Relat.", "Create Delivery Doc. pr. Item");  // 29-12-21 ZY-LD 034
        if recSalesLine.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recSalesLine.Count());
            repeat
                ZGT.UpdateProgressWindow(recSalesLine."Document No.", 0, true);

                recSalesHead.SetAutoCalcFields("Create Delivery Doc. pr. Order");
                recSalesHead.Get(recSalesLine."Document Type", recSalesLine."Document No.");
                recSalesHead.TestField("Ship-to Code");

                if recSalesHead."On Hold" = '' then begin  // 13-06-19 ZY-LD 012
                                                           //>> 29-12-21 ZY-LD 034

                    //>> 03-07-24 ZY-LD 048                       
                    if ZGT.IsZNetCompany and (recSalesHead."Ship-to Code Del. Doc" <> '') then
                        recSalesHead."Ship-to Code Del. Doc" := '';  // We have seen data in this field in ZNet DK, but it should not be possible.
                    if recSalesHead."Ship-to Code Del. Doc" <> '' then begin
                        CustRework.SetRange("Search Name", ReworkLbl);
                        CustRework.FindFirst();
                        SellToCustNo := CustRework."No.";
                    end else
                        SellToCustNo := recSalesLine."Sell-to Customer No.";
                    //<< 03-07-24 ZY-LD 048

                    if recSalesLine."Create Delivery Doc. pr. Item" and
                       (recSalesLine."Ship-to Code Cust/Item Relat." <> '')
                    then
                        ShipToCode := SellToCustNo + '.' + recSalesLine."Ship-to Code Cust/Item Relat."
                    else  //<< 29-12-21 ZY-LD 034
                        ShipToCode := SellToCustNo + '.' + recSalesLine."Ship-to Code";
                    if recSalesHead."Ship-to Code Del. Doc" = '' then begin  // 03-07-24 ZY-LD 048
                        recDelDocHead.SetRange("Sell-to Customer No.", recSalesLine."Sell-to Customer No.");
                        recDelDocHead.SetRange("Delivery Terms Terms", recSalesHead."Shipment Method Code");  // 09-07-20 ZY-LD 020  // 03-07-24 ZY-LD 048
                    end else begin
                        //>> 03-07-24 ZY-LD 048
                        recDelDocHead.SetRange("Sell-to Customer No.", CustRework."No.");
                        ShipToAddRework.get(recSalesHead."Sell-to Customer No.", recSalesHead."Ship-to Code Del. Doc");
                        recDelDocHead.SetRange("Delivery Terms Terms", ShipToAddRework."Shipment Method Code");
                        //<< 03-07-24 ZY-LD 048
                    end;
                    recDelDocHead.SetRange("Ship-to Code", ShipToCode);
                    recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
                    //>> 25-02-20 ZY-LD 019
                    if (recSalesHead."Sales Order Type" = recSalesHead."sales order type"::"Spec. Order") or
                       recSalesHead."Create Delivery Doc. pr. Order" or  // 03-11-21 ZY-LD 030
                       recSalesLine."Create Delivery Doc. pr. Item"  // 29-12-21 ZY-LD 034
                    then begin
                        //>> 29-12-21 ZY-LD 034
                        if recSalesLine."Create Delivery Doc. pr. Item" then
                            recDelDocHead.SetRange("Spec. Order No.", recSalesLine."No.")
                        else  //<< 29-12-21 ZY-LD 034
                            recDelDocHead.SetRange("Spec. Order No.", recSalesHead."No.")
                    end else
                        recDelDocHead.SetFilter("Spec. Order No.", '%1', '');
                    //<< 25-02-20 ZY-LD 019
                    recDelDocHead.SetRange("Ship-From Code", recSalesLine."Location Code");  // 18-11-20 ZY-LD 023
                    //>> 05-04-24 ZY-LD 046
                    if recSalesLine."Currency Code" = '' then
                        recDelDocHead.SetRange("Currency Code", recGenLedgSetup."LCY Code")
                    else  //<< 05-04-24 ZY-LD 046
                        recDelDocHead.SetRange("Currency Code", recSalesLine."Currency Code");  // 28-06-21 ZY-LD 027
                    recDelDocHead.SetRange("Ship-From Code", recSalesLine."Location Code");  // 20-05-22 ZY-LD 039
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
                      recSalesHead."Ship-to Country/Region Code",
                      recSalesHead."Ship-to Code",
                      recSalesHead."Salesperson Code")
                    then begin
                        //>> 09-01-20 ZY-LD 017
                        recSalesLine."Delivery Document No." := recDelDocHead."No.";
                        recSalesLine.Modify();
                        //<< 09-01-20 ZY-LD 017

                        //>> 05-11-21 ZY-LD 031
                        if recSalesSetup."Copy Comments Order to Shpt." then
                            CopyCommentLines(recSalesHead."Document Type", "Sales Comment Document Type"::Value20, recSalesHead."No.", recDelDocHead."No.");
                        //<< 05-11-21 ZY-LD 031
                    end;
                end;
            until recSalesLine.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
        //<< 14-09-18 ZY-LD 003
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
        recGenLedgSetup: Record "General Ledger Setup";  // 05-04-24 ZY-LD 046
    begin
        //>> 14-09-18 ZY-LD 003
        begin
            recGenLedgSetup.get;  // 05-04-24 ZY-LD 046
            recDelDocHead.Init();
            recDelDocHead.Insert(true);  // 30-11-20 ZY-LD 022
                                         //>> 01-05-19 ZY-LD 011
                                         //"No." := GetLastNo;
                                         //recWhseSetup.GET;
                                         //recWhseSetup.TESTFIELD("Whse. Delivery Document Nos.");
                                         //"No." := NoSeriesMgt.GetNextNo(recWhseSetup."Whse. Delivery Document Nos.",TODAY,TRUE);
                                         //<< 01-05-19 ZY-LD 011
            recDelDocHead."Document Type" := recDelDocHead."document type"::Sales;
            recDelDocHead."Document Status" := recDelDocHead."document status"::Open;
            recDelDocHead."Requested Delivery Date" := pPlannedDeliveryDate;
            recDelDocHead."Requested Ship Date" := pSlShipmentDate;
            SetRequestedDates(pSlShipmentDate, pSalesHead."Ship-to Country/Region Code", pSalesHead."Shortcut Dimension 1 Code", recDelDocHead."Requested Ship Date", recDelDocHead."Requested Delivery Date", recDelDocHead."Expected Release Date");  // 14-11-18 ZY-LD 006  // 14-11-19 ZY-LD 015
            recDelDocHead."Requested Delivery Date" := 0D;  // 02-05-22 ZY-LD 038
            recDelDocHead."Requested Ship Date" := 0D;  // 02-05-22 ZY-LD 038
            recDelDocHead."Create User ID" := UserId();
            recDelDocHead."Create Date" := Today;
            recDelDocHead."Create Time" := Time;
            recDelDocHead."Warehouse Status" := recDelDocHead."warehouse status"::New;
            recDelDocHead."Mode Of Transport" := pTransportMethod;
            //>> 05-04-24 ZY-LD 046
            if pSalesHead."Currency Code" = '' then
                recDelDocHead."Currency Code" := recGenLedgSetup."LCY Code"
            else  //<< 05-04-24 ZY-LD 046
                recDelDocHead."Currency Code" := pSalesHead."Currency Code";

            recDelComment.SetFilter("Delivery Document No.", recDelDocHead."No.");
            if not recDelComment.FindFirst() then begin
                recDelComment.Init();
                recDelComment."Delivery Document No." := recDelDocHead."No.";
                recDelComment.Insert();
            end;

            recDelDocHead."Document Date" := WorkDate;

            recDelDocHead."Salesperson Code" := pSalesHead."Salesperson Code";
            recDelDocHead."Order Desk Resposible Code" := pSalesHead."Order Desk Resposible Code";  // 17-10-23 ZY-LD 044

            if pSalesHead."Ship-to Code Del. Doc" = '' then begin  // 03-07-24 ZY-LD 048
                recDelDocHead.Validate(recDelDocHead."Sell-to Customer No.", pSalesHead."Sell-to Customer No.");  // 01-12-21 ZY-LD 032
                recDelDocHead."Sell-to Customer Name" := pSalesHead."Sell-to Customer Name";
                recDelDocHead."Sell-to Customer Name 2" := pSalesHead."Sell-to Customer Name 2";
                recDelDocHead."Sell-to Address" := pSalesHead."Sell-to Address";
                recDelDocHead."Sell-to Address 2" := pSalesHead."Sell-to Address 2";
                recDelDocHead."Sell-to City" := pSalesHead."Sell-to City";
                recDelDocHead."Sell-to Contact" := pSalesHead."Sell-to Contact";
                recDelDocHead."Sell-to Post Code" := pSalesHead."Sell-to Post Code";
                recDelDocHead."Sell-to County" := pSalesHead."Sell-to County";
                recDelDocHead.Validate(recDelDocHead."Sell-to Country/Region Code", pSalesHead."Sell-to Country/Region Code");  // 01-12-21 ZY-LD 032

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
                recDelDocHead."Ship-to TaxID" := pSalesHead."Ship-to VAT";  // 01-11-21 ZY-LD
            end else begin
                //>> 03-07-24 ZY-LD 048
                CustRework.SetRange("Search Name", ReworkLbl);
                CustRework.FindFirst();

                recDelDocHead.Validate("Sell-to Customer No.", CustRework."No.");  // 01-12-21 ZY-LD 032
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
            //<< 03-07-24 ZY-LD 048

            // 18-09-18 CD-LD - Thise codes has not been used since 2014.
            //  IF recShipToCust.GET("Sell-to Customer No.") THEN BEGIN
            //    "Ship-to Email" := recShipToCust."E-Mail";
            //    "Ship-to Phone" := recShipToCust."Phone No.";
            //    "Ship-to TaxID" := recShipToCust."VAT Registration No.";
            //    "Notification Email" := recShipToCust."Notification E-Mail";
            //    "Confirmation Email" := recShipToCust."Confirmation E-Mail";
            //  END;

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

            //>> 19-05-24 ZY-LD 047
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
                //<< 19-05-24 ZY-LD 047
            end else begin
                if recCountryShipDay.Get(pSalesHead."Ship-to Country/Region Code") and (recCountryShipDay."Ship-To Code" <> '') then begin
                    recShiptoAdd.Get(recDelDocHead."Bill-to Customer No.", recCountryShipDay."Ship-To Code");
                    //>> 28-01-19 ZY-LD 007
                    recShiptoAdd.TestField(Name);
                    recShiptoAdd.TestField(Address);
                    recShiptoAdd.TestField("Post Code");
                    recShiptoAdd.TestField(City);
                    recShiptoAdd.TestField("Country/Region Code");
                    //<< 28-01-19 ZY-LD 007
                    //"Delivery Zone" := recShiptoAdd."Delivery Zone";
                    recDelDocHead."Ship-to Name" := recShiptoAdd.Name;
                    recDelDocHead."Ship-to Name 2" := recShiptoAdd."Name 2";
                    recDelDocHead."Ship-to Address" := recShiptoAdd.Address;
                    recDelDocHead."Ship-to Address 2" := recShiptoAdd."Address 2";
                    recDelDocHead."Ship-to City" := recShiptoAdd.City;
                    recDelDocHead."Ship-to Contact" := recShiptoAdd.Contact;
                    recDelDocHead."Ship-to Post Code" := recShiptoAdd."Post Code";
                    recDelDocHead."Ship-to County" := recShiptoAdd.County;
                    recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", recShiptoAdd."Country/Region Code");  // 01-12-21 ZY-LD 032
                end else begin
                    //"Delivery Zone" := pSalesHead."Delivery Zone";
                    recDelDocHead."Ship-to Name" := pSalesHead."Ship-to Name";
                    recDelDocHead."Ship-to Name 2" := pSalesHead."Ship-to Name 2";
                    recDelDocHead."Ship-to Address" := pSalesHead."Ship-to Address";
                    recDelDocHead."Ship-to Address 2" := pSalesHead."Ship-to Address 2";
                    recDelDocHead."Ship-to City" := pSalesHead."Ship-to City";
                    recDelDocHead."Ship-to Contact" := pSalesHead."Ship-to Contact";
                    recDelDocHead."Ship-to Post Code" := pSalesHead."Ship-to Post Code";
                    recDelDocHead."Ship-to County" := pSalesHead."Ship-to County";
                    recDelDocHead.Validate(recDelDocHead."Ship-to Country/Region Code", pSalesHead."Ship-to Country/Region Code");  // 01-12-21 ZY-LD 032
                end;
                recDelDocHead.Validate(recDelDocHead."Delivery Terms Terms", pSalesHead."Shipment Method Code");  // 17-02-22 ZY-LD 035
            end;

            recDelDocHead."Ship-to Code" := pShipToCode;
            recDelDocHead."Shipment Agent Code" := GetDefaultShipmentAgentCode;
            recDelDocHead."Delivery Terms City" := recDelDocHead."Ship-to City";
            //"Delivery Terms Terms" := SalesOrderTerms;  // 09-07-20 ZY-LD 020
            //"Delivery Terms Terms" := pSalesHead."Shipment Method Code";  // 09-07-20 ZY-LD 020  // 17-02-22 ZY-LD 035
            recDelDocHead."Shipment Agent Service" := GetDefaultShipmentAgentSerCode(GetDefaultShipmentAgentCode);

            //"Action Code" := GetDefaultAction("Sell-to Customer No.",pSalesHead."Ship-to Code",'CL*');  // 24-01-20 ZY-LD 018
            //>> 25-02-20 ZY-LD 019
            if (pSalesHead."Sales Order Type" = pSalesHead."sales order type"::"Spec. Order") or
               pSalesHead."Create Delivery Doc. pr. Order"  // 03-11-21 ZY-LD 030
            then
                recDelDocHead."Spec. Order No." := pSalesHead."No.";
            //<< 25-02-20 ZY-LD 019

            //INSERT;
            // #487744 >>
            if (recDelDocHead."Delivery Terms Terms" <> '') and
                (recDelDocHead."Ship-From Code" <> '') then
                recDelDocHead.Validate("Delivery Terms Terms");
            // #487744 <<
            recDelDocHead.Modify(true);  // 30-11-20 ZY-LD 022

            //>> 31-01-20 ZY-LD 018
            recDefAction.Reset();
            recDefAction.SetRange("Source Type", recDefAction."source type"::Customer, recDefAction."source type"::"Ship-to Address");
            recDefAction.SetFilter("Source Code", '%1|%2', recDelDocHead."Sell-to Customer No.", CopyStr(pShipToCode, StrPos(pShipToCode, '.') + 1, StrLen(pShipToCode)));
            recDefAction.SetRange("Customer No.", recDelDocHead."Sell-to Customer No.");
            recDefAction.SetRange("Header / Line", recDefAction."header / line"::Header);
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate);  // 10-03-22 ZY-LD 036
                                                                          //>> 25-02-20 ZY-LD 019
            if pSalesHead."Sales Order Type" <> pSalesHead."sales order type"::"Spec. Order" then
                recDefAction.SetFilter("Sales Order Type", '<>%1', pSalesHead."Sales Order Type");
            //<< 25-02-20 ZY-LD 019
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
            recDefAction.SetFilter("End Date", '%1|%2..', 0D, WorkDate);  // 10-03-22 ZY-LD 036
            if recDefAction.FindSet() then
                repeat
                    recDelDocAction.InitLine(recDefAction);
                    recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                    if not recDelDocAction.Insert(true) then;
                until recDefAction.Next() = 0;
            //<< 31-01-20 ZY-LD 018

            nocreated := nocreated + 1;
            rValue := recDelDocHead."No.";
        end;
        //<< 14-09-18 ZY-LD 003
    end;

    local procedure SetRequestedDates(pShipmentDate: Date; pShipToCountry: Code[20]; pDivisionCode: Code[10]; var ReqShipmentDate: Date; var ReqDeliveryDate: Date; var ExpReleaseDate: Date)
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recCtryShipDay: Record "VCK Country Shipment Days";
    begin
        //>> 14-09-18 ZY-LD 003
        recSalesSetup.Get();
        if pShipmentDate >= Today then begin  // Forward
            if pShipmentDate = 0D then
                ReqShipmentDate := Today;
            if ReqDeliveryDate = 0D then
                ReqDeliveryDate := Today;
        end else begin  // Backward
            if not recCtryShipDay.Get(pShipToCountry) then
                recCtryShipDay."Delivery Days" := recSalesSetup."Delivery Days to Add";

            ReqShipmentDate := CalcShipmentDate('', '', pShipToCountry, pDivisionCode, Today, false);  // 14-11-18 ZY-LD 006 // 21-08-19 ZY-LD 015

            ReqDeliveryDate := CalcDate(Format(recCtryShipDay."Delivery Days") + 'D', ReqShipmentDate);
            if Date2dwy(ReqDeliveryDate, 1) > 5 then
                GetNextWeekday(1, ReqDeliveryDate);

            //>> 14-11-19 ZY-LD 015
            ExpReleaseDate := ReqShipmentDate - 1;
            if Date2dwy(ExpReleaseDate, 1) > 5 then
                GetPrevWeekday(5, ExpReleaseDate);
            //<< 14-11-19 ZY-LD 015
        end;
        //<< 14-09-18 ZY-LD 003
    end;

    local procedure CreateDeliveryDocumentLine(pSalesLine: Record "Sales Line"; pDocumentNo: Code[20]; pShipToCountry: Code[20]; pShipToCode: Code[20]; pSalesPersonCode: Code[50]) rValue: Boolean
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recDelDocLine2: Record "VCK Delivery Document Line";
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        GenBusPostGrp: Record "Gen. Business Posting Group";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        LineWithPrice: Interface "Line With Price";
        PriceCalculation: Interface "Price Calculation";
        SalesLinePrice: Codeunit "Sales Line - Price";
        Line: Variant;
    begin
        //>> 14-09-18 ZY-LD 003
        begin
            //>> 05-08-19 ZY-LD 014
            recDelDocLine2.SetRange("Sales Order No.", pSalesLine."Document No.");
            recDelDocLine2.SetRange("Sales Order Line No.", pSalesLine."Line No.");
            recDelDocLine2.SetFilter("Document No.", '<>%1', pDocumentNo);
            recDelDocLine2.SetFilter(Quantity, '<>0');  // 09-01-20 ZY-LD 017 - It can happent that a line is created and set to 0 on the delivery document.
            if not recDelDocLine2.FindFirst() then begin  //<< 05-08-19 ZY-LD 014
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
                recDelDocLine."Customer Order No." := CopyStr(pSalesLine."External Document No.", 1, MaxStrLen(recDelDocLine."Customer Order No."));  // 04-10-18 ZY-LD 004
                recDelDocLine."Warehouse Status" := recDelDocLine."warehouse status"::New;
                recDelDocLine.Validate(recDelDocLine."Currency Code", pSalesLine."Currency Code");
                recDelDocLine.Quantity := pSalesLine."Outstanding Quantity";
                //>> 15-12-21 ZY-LD 033
                if pSalesLine."Unit Price" = 0 then begin
                    //>> 14-08-23 ZY-LD 043
                    recsalesline.SetRange("Document Type", pSalesLine."Document Type");
                    recSalesLine.SetRange("Document No.", pSalesLine."Document No.");
                    recSalesLine.SetFilter("Line No.", '<>%1', pSalesLine."Line No.");
                    recSalesLine.SetRange(Type, pSalesLine.Type);
                    recSalesLine.SetRange("No.", pSalesLine."No.");
                    recSalesLine.SetFilter("Unit Price", '<>0');
                    if recSalesLine.FindFirst() then
                        pSalesLine."Unit Price" := recSalesLine."Unit Price"
                    else begin  //>> 14-08-23 ZY-LD 043
                        recSalesHead.Get(pSalesLine."Document Type", pSalesLine."Document No.");

                        LineWithPrice := SalesLinePrice;
                        LineWithPrice.SetLine("Price Type"::Sale, pSalesLine);
                        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
                        PriceCalculation.ApplyDiscount();
                        PriceCalculation.ApplyPrice(0);
                        PriceCalculation.GetLine(Line);
                        pSalesLine := line;
                    end;  // 14-08-23 ZY-LD 043

                    if pSalesLine."Unit Price" = 0 then
                        pSalesLine."Unit Price" := pSalesLine."Unit Cost";
                end;
                //<< 15-12-21 ZY-LD 033
                recDelDocLine.Validate(recDelDocLine."Unit Price", pSalesLine."Unit Price");
                recDelDocLine.Validate(recDelDocLine."VAT %", pSalesLine."VAT %");
                recDelDocLine.Validate(recDelDocLine."Line Discount %", pSalesLine."Line Discount %");
                recDelDocLine.Validate(recDelDocLine.Amount);
                //>> 18-12-23 ZY-LD 045
                if GenBusPostGrp.get(pSalesLine."Gen. Bus. Posting Group") and
                  (GenBusPostGrp."Sample / Test Equipment" = GenBusPostGrp."Sample / Test Equipment"::"Sample (Unit Price = Zero)")
                then
                    recDelDocLine.Validate("Do not Calculate Amount", true);
                //<< 18-12-23 ZY-LD 045
                rValue := recDelDocLine.Insert(true);  // 09-01-20 ZY-LD 017 - rValue is added.
            end;
        end;
        //<< 14-09-18 ZY-LD 003
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
        //>> 19-04-21 ZY-LD 017
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
                                if StrPos(ItemLogisticEvents.GetRequireShipmentLocations, pSalesLine."Location Code") = 0 then
                                    Message('%1 <> "%2"', pSalesLine.FieldCaption(pSalesLine."Location Code"), ItemLogisticEvents.GetRequireShipmentLocations)
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
        //<< 19-04-21 ZY-LD 017
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
        //>> 05-11-21 ZY-LD 031
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
        //<< 05-11-21 ZY-LD 031
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
}
