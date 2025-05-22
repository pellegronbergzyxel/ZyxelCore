codeunit 50055 AmazonHelper
{
    trigger OnRun()
    begin
        MainProcessOrders('', true, '');
        commit;
        UpdateMainAmazonstatus();
        Commit;
        RemoveOpenClosedRejectedAmazon();
    end;

    procedure MainProcessOrders(Amazcode: code[10]; Full: Boolean; amazdocno: code[20])
    var
        jsonPayload: text;
        jsonarrayMain: JsonArray;
        jsonObjectMain: JsonObject;
        jsonTokenMain: JsonToken;
        jsonTokenorders: JsonToken;
        TokenOrder: JsonToken;
        TokenOrderObject: JsonObject;
        TokenValue: JsonToken;
        TokenValue2: JsonToken;
        TokenValue3: JsonToken;
        tokenarray: JsonArray;
        token: JsonToken;
        jsonObjectorders: Jsontoken;
        AmazonOrder: code[35];
        buyingParty: Code[10];
        sellingParty: Code[10];
        custno: code[20];
        orderDetails: Jsontoken;
        temptoken: JsonToken;
        Salesheader: record "Sales Header";
        Salesline: record "Sales line";
        orderdate: date;
        deliveryWindow: text;
        lineno: integer;
        itemno: code[20];
        shipno: code[10];
        purchaseOrderState: text;
        Amazonsetup: record "Amazon Setup";
        shiptoadd: record "Ship-to Address";
        item: record Item;
        DD: integer;
        MM: integer;
        YYYY: integer;
        Shipdate: Date;
        amt: Decimal;
        itemblocked: Boolean;
        itemSalesblocked: Boolean;
    begin
        Amazonsetup.setrange(ActiveClient, true);
        if Amazcode <> '' then
            Amazonsetup.setrange(code, Amazcode);
        if Amazonsetup.findset then
            repeat
                if GETAmazonOrder(jsonPayload, Amazonsetup.ZyxelPartyid, amazdocno) THEN BEGIN
                    if Amazcode <> '' then begin
                        IF jsonObjectMain.ReadFrom(jsonPayload) then begin
                            if jsonObjectMain.SelectToken('payload', TokenOrder) then begin

                                Clear(buyingParty);
                                Clear(AmazonOrder);
                                if TokenOrder.SelectToken('purchaseOrderNumber', TokenValue) then
                                    EVALUATE(AmazonORder, TokenValue.AsValue().AsText());
                                if TokenOrder.SelectToken('purchaseOrderState', TokenValue) then
                                    EVALUATE(purchaseOrderState, TokenValue.AsValue().AsText());
                                TokenOrderObject := TokenOrder.AsObject();
                                if TokenOrder.SelectToken('orderDetails', orderDetails) then
                                    if orderDetails.SelectToken('buyingParty', temptoken) then
                                        if temptoken.SelectToken('partyId', TokenValue) then
                                            EVALUATE(buyingParty, TokenValue.AsValue().AsText());

                                if TokenOrder.SelectToken('orderDetails', orderDetails) then
                                    if orderDetails.SelectToken('sellingParty', temptoken) then
                                        if temptoken.SelectToken('partyId', TokenValue) then
                                            EVALUATE(sellingParty, TokenValue.AsValue().AsText());


                                custno := AmazonID2CustNo(buyingParty, sellingParty);

                                if (custno <> '') and (AmazonORder <> '') then begin
                                    if createorClearAmazonorder(custno, AmazonORder, Salesheader, sellingParty) then begin
                                        lineno := 1000;
                                        Salesheader.AmazonpurchaseOrderState := purchaseOrderState;
                                        if orderDetails.SelectToken('purchaseOrderDate', TokenValue) then begin
                                            orderdate := XMLdate2Date(format(TokenValue.AsValue().asText()));
                                            Salesheader.validate("Document Date", orderdate);
                                            Salesheader.validate("Order Date", orderdate);

                                            Salesheader.modify(true);

                                        end;
                                        shipno := AmazonID2CustNoShipto(buyingParty, sellingParty);
                                        if shiptoadd.get(shipno) then
                                            salesheader.SetShipToCustomerAddressFieldsFromShipToAddr(shiptoadd);
                                        Salesheader.Validate("Ship-to Code", shipno);
                                        Salesheader.modify(true);
                                        // 
                                        saleslineinit(Salesline, Salesheader, lineno);
                                        Salesline.Type := Salesline.Type::" ";
                                        Salesline."Description" := CopyStr(AmazonORder, 1, 100);
                                        Salesline.Modify(true);

                                        // deliveryWindow
                                        if orderDetails.SelectToken('deliveryWindow', TokenValue) then begin
                                            deliveryWindow := TokenValue.AsValue().asText();
                                            saleslineinit(Salesline, Salesheader, lineno);
                                            Salesline.Type := Salesline.Type::" ";
                                            Salesline."Description" := CopyStr('deliveryWindow:', 1, 100);
                                            Salesline.Modify(true);
                                            saleslineinit(Salesline, Salesheader, lineno);
                                            Salesline.Type := Salesline.Type::" ";
                                            Salesline."Description" := CopyStr(deliveryWindow, 1, 100);
                                            Salesline.Modify(true);
                                            // 2027-07-27
                                            // 123456789
                                            Clear(DD);
                                            Clear(MM);
                                            Clear(YYYY);
                                            clear(Shipdate);
                                            if Evaluate(YYYY, CopyStr(deliveryWindow, 1, 4)) then
                                                if Evaluate(MM, CopyStr(deliveryWindow, 6, 2)) then
                                                    if Evaluate(DD, CopyStr(deliveryWindow, 9, 2)) then
                                                        if (DD <> 0) and (mm <> 0) and (yyyy <> 0) then
                                                            shipdate := DMY2Date(DD, MM, YYYY);

                                            if Shipdate <> 0D then begin
                                                Salesheader.Validate("Shipment Date", Shipdate);
                                                salesheader.Validate("Requested Delivery Date", Shipdate);
                                                Salesheader."Order Date" := Shipdate;
                                                //Salesheader."Order Receipt Date" := Today;
                                                Salesheader."VAT Reporting Date" := Shipdate;
                                                Salesheader."Posting Date" := Shipdate;
                                                Salesheader."Document Date" := Shipdate;
                                                salesheader."Requested Delivery Date" := Shipdate;
                                                salesheader."Shipment Date" := Shipdate;

                                                Salesheader.Modify(true);
                                            end;
                                        end;


                                        // items (arrays)
                                        if orderDetails.SelectToken('items', TokenValue) then begin
                                            tokenarray := TokenValue.AsArray();
                                            foreach TokenValue in tokenarray do begin
                                                TokenValue.SelectToken('amazonProductIdentifier', TokenValue2);
                                                itemno := AmazASIN2ItemNo(TokenValue2.AsValue().asText());
                                                if itemno = '' then begin
                                                    TokenValue.SelectToken('vendorProductIdentifier', TokenValue2);
                                                    itemno := GLN2ItemNo(TokenValue2.AsValue().asText());
                                                end;
                                                if itemno <> '' then begin
                                                    saleslineinit(Salesline, Salesheader, lineno);
                                                    Salesline.Type := Salesline.Type::"item";
                                                    Salesline.Validate("No.", itemno);
                                                    Salesline.Modify(true);
                                                    if TokenValue.SelectToken('amazonProductIdentifier', TokenValue2) then begin
                                                        Salesline."Item Reference No." := TokenValue2.AsValue().AsText();
                                                        Salesline."Item Reference Type" := Salesline."Item Reference Type"::Customer;
                                                        Salesline."Item Reference Type No." := Salesheader."Sell-to Customer No.";
                                                        Salesline.Modify(true);

                                                    end;
                                                    //TokenValue.SelectToken('vendorProductIdentifier', TokenValue2);
                                                    //netCost  > amount 
                                                    if TokenValue.SelectToken('netCost', TokenValue2) then
                                                        if TokenValue2.SelectToken('amount', TokenValue3) then begin
                                                            EVALUATE(Salesline."Unit Price", format(TokenValue3.AsValue().AsDecimal()));
                                                            EVALUATE(Salesline.AmazconUnitprice, format(TokenValue3.AsValue().AsDecimal()));
                                                            Salesline.validate("Unit Price");
                                                            Salesline.Modify(true);
                                                        end;
                                                    //orderedQuantity > amount
                                                    if TokenValue.SelectToken('orderedQuantity', TokenValue2) then
                                                        if TokenValue2.SelectToken('amount', TokenValue3) then begin
                                                            EVALUATE(Salesline.Quantity, TokenValue3.AsValue().AsText());
                                                            Salesline.validate(Quantity);
                                                            Salesline.Modify(true);
                                                        end;
                                                    if Shipdate <> 0D then begin
                                                        Salesline.Validate("Shipment Date", Shipdate);
                                                        Salesline.Validate("Requested Delivery Date", Shipdate);
                                                        Salesline.Modify(true);
                                                    end;


                                                end;
                                            end;
                                        end
                                    end;
                                end;
                            end;
                        end;
                    end else begin
                        IF jsonTokenMain.ReadFrom(jsonPayload) then begin
                            if jsonTokenMain.SelectToken('payload.orders', jsonTokenorders) then begin
                                jsonarrayMain := jsonTokenorders.AsArray();

                                foreach TokenOrder in jsonarrayMain do begin
                                    Clear(buyingParty);
                                    Clear(AmazonOrder);
                                    if TokenOrder.SelectToken('purchaseOrderNumber', TokenValue) then
                                        EVALUATE(AmazonORder, TokenValue.AsValue().AsText());
                                    if TokenOrder.SelectToken('purchaseOrderState', TokenValue) then
                                        EVALUATE(purchaseOrderState, TokenValue.AsValue().AsText());
                                    TokenOrderObject := TokenOrder.AsObject();
                                    if TokenOrder.SelectToken('orderDetails', orderDetails) then
                                        if orderDetails.SelectToken('buyingParty', temptoken) then
                                            if temptoken.SelectToken('partyId', TokenValue) then
                                                EVALUATE(buyingParty, TokenValue.AsValue().AsText());

                                    if TokenOrder.SelectToken('orderDetails', orderDetails) then
                                        if orderDetails.SelectToken('sellingParty', temptoken) then
                                            if temptoken.SelectToken('partyId', TokenValue) then
                                                EVALUATE(sellingParty, TokenValue.AsValue().AsText());


                                    custno := AmazonID2CustNo(buyingParty, sellingParty);

                                    if (custno <> '') and (AmazonORder <> '') then begin
                                        if createorClearAmazonorder(custno, AmazonORder, Salesheader, sellingParty) then begin
                                            lineno := 1000;
                                            Salesheader.AmazonpurchaseOrderState := purchaseOrderState;
                                            if orderDetails.SelectToken('purchaseOrderDate', TokenValue) then begin
                                                orderdate := XMLdate2Date(format(TokenValue.AsValue().asText()));
                                                Salesheader.validate("Document Date", orderdate);
                                                Salesheader.validate("Order Date", orderdate);
                                                Salesheader.modify(true);

                                            end;

                                            shipno := AmazonID2CustNoShipto(buyingParty, sellingParty);
                                            if shiptoadd.get(shipno) then
                                                salesheader.SetShipToCustomerAddressFieldsFromShipToAddr(shiptoadd);
                                            Salesheader.Validate("Ship-to Code", shipno);
                                            Salesheader.modify(true);
                                            // 
                                            saleslineinit(Salesline, Salesheader, lineno);
                                            Salesline.Type := Salesline.Type::" ";
                                            Salesline."Description" := CopyStr(AmazonORder, 1, 100);
                                            Salesline.Modify(true);

                                            // deliveryWindow
                                            if orderDetails.SelectToken('deliveryWindow', TokenValue) then begin
                                                deliveryWindow := TokenValue.AsValue().asText();
                                                saleslineinit(Salesline, Salesheader, lineno);
                                                Salesline.Type := Salesline.Type::" ";
                                                Salesline."Description" := CopyStr('deliveryWindow:', 1, 100);
                                                Salesline.Modify(true);
                                                saleslineinit(Salesline, Salesheader, lineno);
                                                Salesline.Type := Salesline.Type::" ";
                                                Salesline."Description" := CopyStr(deliveryWindow, 1, 100);
                                                Salesline.Modify(true);
                                                // 2027-07-27
                                                // 123456789
                                                Clear(DD);
                                                Clear(MM);
                                                Clear(YYYY);
                                                clear(Shipdate);
                                                if Evaluate(YYYY, CopyStr(deliveryWindow, 1, 4)) then
                                                    if Evaluate(MM, CopyStr(deliveryWindow, 6, 2)) then
                                                        if Evaluate(DD, CopyStr(deliveryWindow, 9, 2)) then
                                                            if (DD <> 0) and (mm <> 0) and (yyyy <> 0) then
                                                                shipdate := DMY2Date(DD, MM, YYYY);
                                                if Shipdate <> 0D then begin
                                                    Salesheader.Validate("Shipment Date", Shipdate);
                                                    salesheader.Validate("Requested Delivery Date", Shipdate);
                                                    Salesheader."Order Date" := Shipdate;
                                                    // Salesheader."Order Receipt Date" := Today;
                                                    Salesheader."VAT Reporting Date" := Shipdate;
                                                    Salesheader."Posting Date" := Shipdate;
                                                    Salesheader."Document Date" := Shipdate;
                                                    salesheader."Requested Delivery Date" := Shipdate;
                                                    salesheader."Shipment Date" := Shipdate;
                                                    Salesheader.Modify(true);
                                                end;
                                            end;

                                            // items (arrays)
                                            if orderDetails.SelectToken('items', TokenValue) then begin
                                                tokenarray := TokenValue.AsArray();
                                                foreach TokenValue in tokenarray do begin
                                                    TokenValue.SelectToken('amazonProductIdentifier', TokenValue2);
                                                    itemno := AmazASIN2ItemNo(TokenValue2.AsValue().asText());
                                                    if itemno = '' then begin
                                                        TokenValue.SelectToken('vendorProductIdentifier', TokenValue2);
                                                        itemno := GLN2ItemNo(TokenValue2.AsValue().asText());
                                                    end;
                                                    itemblocked := false;
                                                    itemSalesblocked := false;

                                                    if itemno <> '' then begin
                                                        saleslineinit(Salesline, Salesheader, lineno);
                                                        item.get(itemno);
                                                        if item."Block on Sales Order" then begin
                                                            itemsalesblocked := true;
                                                            item."Block on Sales Order" := false;
                                                            item.modify(false);
                                                        end;

                                                        if item.blocked then begin
                                                            itemblocked := true;
                                                            item.blocked := false;
                                                            item.modify(false);
                                                        end;
                                                        Salesline.SetHideValidationDialog(false);
                                                        Salesline.Type := Salesline.Type::"item";
                                                        Salesline.Validate("No.", itemno);
                                                        Salesline.Modify(true);
                                                        if TokenValue.SelectToken('amazonProductIdentifier', TokenValue2) then begin
                                                            Salesline."Item Reference No." := TokenValue2.AsValue().AsText();
                                                            Salesline."Item Reference Type" := Salesline."Item Reference Type"::Customer;
                                                            Salesline."Item Reference Type No." := Salesheader."Sell-to Customer No.";
                                                            Salesline.Modify(true);
                                                        end;
                                                        amt := 0;
                                                        if TokenValue.SelectToken('netCost', TokenValue2) then
                                                            if TokenValue2.SelectToken('amount', TokenValue3) then begin
                                                                EVALUATE(Amt, format(TokenValue3.AsValue().AsDecimal()));

                                                            end;
                                                        //orderedQuantity > amount
                                                        if TokenValue.SelectToken('orderedQuantity', TokenValue2) then
                                                            if TokenValue2.SelectToken('amount', TokenValue3) then begin
                                                                EVALUATE(Salesline.Quantity, TokenValue3.AsValue().AsText());
                                                                Salesline.validate(Quantity);
                                                                salesline.AmazconUnitprice := amt;
                                                                Salesline.validate("Unit Price", amt);

                                                                Salesline.Modify(true);
                                                            end;
                                                        if Shipdate <> 0D then begin
                                                            Salesline.Validate("Shipment Date", Shipdate);
                                                            Salesline.Validate("Requested Delivery Date", Shipdate);
                                                            Salesline.Modify(true);
                                                        end;

                                                        if itemblocked then begin
                                                            Salesline."Description 2" := 'Item blocked';
                                                            if (item."End of Life Date" <> 0D) and (item."End of Life Date" < Salesheader."Document Date") then
                                                                Salesline."Description 2" := Salesline."Description 2" + ', EOL';
                                                            Salesline.Modify(true);
                                                            item.get(itemno);
                                                            item.blocked := true;
                                                            item.modify(false);
                                                        end;
                                                        if itemsalesblocked then begin
                                                            Salesline."Description 2" := 'Item sales blocked';
                                                            if (item."End of Life Date" <> 0D) and (item."End of Life Date" < Salesheader."Document Date") then
                                                                Salesline."Description 2" := Salesline."Description 2" + ', EOL';
                                                            Salesline.Modify(true);
                                                            item.get(itemno);
                                                            item."Block on Sales Order" := true;
                                                            item.modify(false);
                                                        end;
                                                    end else begin
                                                        // amazonitem missing
                                                        saleslineinit(Salesline, Salesheader, lineno);
                                                        salesline.Description := TokenValue2.AsValue().asText();
                                                        if TokenValue.SelectToken('netCost', TokenValue2) then
                                                            if TokenValue2.SelectToken('amount', TokenValue3) then begin
                                                                EVALUATE(Amt, format(TokenValue3.AsValue().AsDecimal()));



                                                            end;
                                                        //orderedQuantity > amount
                                                        if TokenValue.SelectToken('orderedQuantity', TokenValue2) then
                                                            if TokenValue2.SelectToken('amount', TokenValue3) then begin
                                                                EVALUATE(Salesline.Quantity, TokenValue3.AsValue().AsText());
                                                                Salesline."Description 2" := 'Price:' + format(amt);
                                                                salesline.AmazconUnitprice := amt;
                                                                Salesline.Modify(true);
                                                                Salesline."Description 2" := Salesline."Description 2" + ',qty:' + format(Salesline.Quantity);
                                                                Salesline.Modify(true);
                                                            end;
                                                    end;
                                                end
                                            end;
                                        end;

                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            until Amazonsetup.next = 0;
    end;

    procedure RemoveOpenClosedRejectedAmazon()
    var
        salesheader: Record "Sales Header";
    begin
        salesheader.setrange("Document Type", salesheader."Document Type"::Order);
        salesheader.setrange(status, salesheader.Status::Open);
        salesheader.setfilter(AmazonePoNo, '<>%1', '');
        if salesheader.FindSet() then
            repeat
                if (salesheader.AmazconfirmationStatus = 'REJECTED') and (salesheader.AmazonpurchaseOrderState = 'CLOSED') then
                    salesheader.Delete(true);
            until salesheader.next = 0;


    end;



    procedure UpdateMainAmazonstatus()
    var
        Salesheader: record "Sales Header";
    begin
        Salesheader.setrange("Document Type", Salesheader."Document Type"::Order);
        Salesheader.setrange(Status, Salesheader.Status::Open);
        Salesheader.setfilter(AmazonSellpartyid, '<>%1', '');
        salesheader.setfilter(AmazonePoNo, '<>%1', '');
        if Salesheader.findset Then
            repeat
                UpdateAmazonstatus(Salesheader);
            until Salesheader.Next = 0


    end;

    procedure UpdateAmazonstatus(Salesheader: record "Sales Header")
    var
        ResponseString: text;
        jsonTokenMain: JsonToken;
        jsonTokenorders: JsonToken;
        jsonarrayMain: JsonArray;
        TokenOrder: JsonToken;
        purchaseOrderStatus: text[30];
        AmazonORder: text[35];
        TokenValue: JsonToken;
        TokenValue2: JsonToken;
        TokenValue3: JsonToken;
        tokenarray: JsonArray;
        orderDetails: Jsontoken;
        confirmationStatus: text[30];
    begin
        if Salesheader.AmazonePoNo <> '' then
            if GETAmazonOrderStatus(ResponseString, Salesheader.AmazonSellpartyid, Salesheader) then begin

                IF jsonTokenMain.ReadFrom(ResponseString) then begin
                    if jsonTokenMain.SelectToken('payload.ordersStatus', jsonTokenorders) then begin
                        jsonarrayMain := jsonTokenorders.AsArray();

                        foreach TokenOrder in jsonarrayMain do begin
                            //    Clear(buyingParty);
                            Clear(AmazonOrder);
                            if TokenOrder.SelectToken('purchaseOrderNumber', TokenValue) then
                                EVALUATE(AmazonORder, TokenValue.AsValue().AsText());
                            if TokenOrder.SelectToken('purchaseOrderStatus', TokenValue) then
                                EVALUATE(purchaseOrderStatus, TokenValue.AsValue().AsText());

                            if Salesheader.AmazonePoNo = AmazonORder then begin
                                Salesheader.AmazonpurchaseOrderState := purchaseOrderStatus;
                                Salesheader.modify(false);
                                if TokenOrder.SelectToken('itemStatus', TokenValue) then begin
                                    tokenarray := TokenValue.AsArray();
                                    foreach TokenValue in tokenarray do begin
                                        if TokenValue.SelectToken('acknowledgementStatus', TokenValue2) then begin
                                            if TokenValue2.SelectToken('confirmationStatus', TokenValue3) then begin
                                                confirmationStatus := TokenValue3.AsValue().asText();
                                                Salesheader.AmazconfirmationStatus := confirmationStatus;
                                                Salesheader.modify(false);
                                            end;
                                        end
                                    end;
                                end
                            end;
                        end;

                    end;
                end;
            end;
    end;



    procedure saleslineinit(var Salesline: Record "Sales Line"; salesheader: record "Sales Header"; var lastline: Integer)
    begin
        lastline := lastline + 10000;
        Salesline.Init;
        Salesline.Validate("Document Type", salesheader."Document Type");
        Salesline.validate("Document No.", salesheader."No.");
        Salesline."Line No." := lastline;
        Salesline.INSERT(TRUE);
    end;

    procedure GLN2ItemNo(GLN: text): code[20]
    var
        item: record item;
    begin
        item.setrange(GTIN, copystr(GLN, 1, 14));
        if item.findset then
            exit(item."No.");
        exit('');
    end;


    procedure AmazASIN2ItemNo(AmazASIN: code[20]): code[20]
    var
        item: record item;
    begin
        item.setrange(Amaz_ASIN, AmazASIN);
        if item.findset then
            exit(item."No.");
        exit('');
    end;

    procedure XMLdate2Date(datetext: text): date
    var
        year: integer;
        mm: integer;
        dd: integer;
        datetotest: date;
    begin
        EVALUATE(Year, COPYSTR(datetext, 1, 4));
        EVALUATE(mm, COPYSTR(datetext, 6, 2));
        EVALUATE(dd, COPYSTR(datetext, 9, 2));
        if EVALUATE(datetotest, FORMAT(DMY2DATE(dd, mm, Year))) then
            exit(datetotest);
        exit(today);
    end;

    procedure createorClearAmazonorder(customerno: code[20]; Amazonorder: code[35]; var SalesRecord: record "Sales Header"; Partyid: code[10]): Boolean
    var
        salesline: record "Sales Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        salesSetup: Record "Sales & Receivables Setup";
    begin
        SalesRecord.setrange("Document Type", SalesRecord."Document Type"::Order);
        SalesRecord.setrange(AmazonePoNo, Amazonorder);
        SalesRecord.setrange(AmazonSellpartyid, Partyid);
        SalesRecord.setrange("Sell-to Customer No.", customerno);
        if SalesRecord.findset then begin
            if SalesRecord.status = SalesRecord.status::Released Then begin
                exit(false); // NOT UPDATES
            end else begin
                salesline.setrange("Document Type", SalesRecord."Document Type");
                salesline.setrange("Document No.", SalesRecord."No.");
                salesline.DeleteAll(true);

                exit(true);
            end;

        end else begin
            salesSetup.get();
            SalesRecord.init;
            SalesRecord."Document Type" := SalesRecord."Document Type"::Order;
            SalesRecord."No." := NoSeriesMgt.GetNextNo(salesSetup."Order Nos.", today, true);
            SalesRecord.validate(AmazonePoNo, Amazonorder);
            SalesRecord.validate("External Document No.", Amazonorder);
            SalesRecord.insert(false);
            // Flyt til setup >>
            SalesRecord."VAT Registration No. Zyxel" := vatBilltocustomer(customerno);
            salesrecord."Sales Order Type" := salesrecord."Sales Order Type"::Normal;
            SalesRecord."Location Code" := 'VCK ZNET';
            // Flyt til setup <<
            //SalesRecord."eCommerce Order" := true;


            SalesRecord.validate("Sell-to Customer No.", customerno);
            SalesRecord."VAT Registration No. Zyxel" := vatBilltocustomer(customerno);
            SalesRecord.Validate(AmazonSellpartyid, Partyid);


            SalesRecord.Validate("Your Reference", Amazonorder);
            SalesRecord."Posting Date" := Today;


            SalesRecord.validate("Requested delivery Date", Today);

            SalesRecord.Modify(true);
            exit(true);
        end;

    end;


    procedure vatBilltocustomer(CustNo: code[20]): Code[20]
    var

        Cust: record customer;
    begin
        Cust.get(custno);
        //Cust.get(cust."SeBill-to Customer No.");
        exit(cust."VAT Registration No.")

    end;

    procedure CustNo2AmazonID(CustNo: code[20]): Code[10]
    var

        Cust: record customer;
    begin
        Cust.get(custno);
        if cust.AMAZONID <> '' Then
            exit(cust.AMAZONID)
        else
            error('Amazon ID missing for customer', CustNo);
    end;

    procedure AmazonID2CustNo(Amazonid: Code[10]; partyid: Code[10]): code[20]
    var
        customer: record customer;
        customerCreate: record customer;
        Amazonsetup: Record "Amazon Setup";

    begin
        Amazonsetup.get(partyid);
        customer.setrange(AMAZONID, Amazonsetup.ZyxelPartyid);
        if customer.findset then begin
            exit(customer."No.")
        end else begin
            error('%1 is missing', Amazonid);
        end;

    end;

    procedure AmazonID2CustNoShipto(Amazonid: Code[10]; partyid: Code[10]): code[20]
    var
        customer: record customer;
        customerCreate: record customer;
        ShiptoAddress: Record "Ship-to Address";
        Amazonsetup: Record "Amazon Setup";

    begin
        Amazonsetup.get(partyid);
        customer.setrange(AMAZONID, Amazonsetup.ZyxelPartyid);
        if customer.findset then begin

            ShiptoAddress.setrange("Customer No.", customer."No.");
            ShiptoAddress.setrange(Code, Amazonid);
            IF ShiptoAddress.findset then
                exit(ShiptoAddress.code);
            if Amazonsetup.testmode then begin
                ShiptoAddress.init;
                ShiptoAddress."Customer No." := customer."No.";
                ShiptoAddress.code := Amazonid;
                ShiptoAddress.insert;
                exit(ShiptoAddress.code);
            end;
        end;
        error('%1 is missing, ship %2', Amazonsetup.ZyxelPartyid, Amazonid);
    end;





    procedure GETAmazonOrder(var ResponseString: text; NordiskPartyid: code[10]; amazdocno: code[20]): Boolean
    var

        Amazsetup: record "amazon Setup";
        Httpcontent: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        client: HttpClient;
        content: Text;
        url: Text;
        token: JsonToken;
        token2: JsonToken;
        JSonArray: JsonArray;
        tiPartNumber: text;
        quantity: Decimal;
        newtoken: text;
        // test
        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        filename: text;

    begin
        Amazsetup.get(NordiskPartyid);

        IF GetnewToken(newtoken, NordiskPartyid) then begin
            httpcontent.GetHeaders(contentHeaders);
            contentHeaders.Clear();
            request.GetHeaders(contentHeaders);
            contentHeaders.Add('x-amz-access-token', newtoken);
            contentHeaders.Add('Accept', 'application/json');
            if amazdocno = '' then
                request.SetRequestUri(StrSubstNo(Amazsetup.URL_PO_GET, Amazsetup.URL_PO_GET_status));
            if amazdocno <> '' then
                request.SetRequestUri(StrSubstNo(Amazsetup.URL_PO_GET_order, amazdocno));
            request.Method := 'GET';

            if not (client.send(request, responseMessage)) then begin
                error('Url virker ikke: ' + url);
                exit(false);
            end;

            if not (responseMessage.IsSuccessStatusCode()) then begin
                Message('Status code: %1\Description: %2, (%3)', responseMessage.HttpStatusCode(), responseMessage.ReasonPhrase(), NordiskPartyid);
                exit(false);
            end;

            responseMessage.Content().ReadAs(content);

            // Save the data of the InStream as a file.
            if (userid in ['PGR 1', 'ZYEU\PELLE.GRONBERG']) and GuiAllowed then begin
                TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);
                outStr.WriteText(content);
                TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
                fileName := StrSubstNo('Amazon__%1_.txt', format(responseMessage.HttpStatusCode()));
                File.DownloadFromStream(inStr, 'Export', '', '', fileName);
            end;
            ResponseString := content;
            exit(true);

        end;


    end;



    procedure GETAmazonOrderStatus(var ResponseString: text; NordiskPartyid: code[10]; salesheader: record "Sales Header"): Boolean
    var

        Amazsetup: record "amazon Setup";
        Httpcontent: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        client: HttpClient;
        content: Text;
        url: Text;
        token: JsonToken;
        token2: JsonToken;
        JSonArray: JsonArray;
        tiPartNumber: text;
        quantity: Decimal;
        newtoken: text;
        // test
        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        filename: text;

    begin
        Amazsetup.get(NordiskPartyid);

        IF GetnewToken(newtoken, NordiskPartyid) then begin
            httpcontent.GetHeaders(contentHeaders);
            contentHeaders.Clear();
            request.GetHeaders(contentHeaders);
            contentHeaders.Add('x-amz-access-token', newtoken);
            contentHeaders.Add('Accept', 'application/json');

            request.SetRequestUri(StrSubstNo(Amazsetup.URL_GET_status_Purchase, salesheader.AmazonePoNo));
            request.Method := 'GET';

            if not (client.send(request, responseMessage)) then begin
                error('Url virker ikke: ' + url);
                exit(false);
            end;

            if not (responseMessage.IsSuccessStatusCode()) then begin
                Message('Status code: %1\Description: %2, (%3)', responseMessage.HttpStatusCode(), responseMessage.ReasonPhrase());
                exit(false);
            end;

            responseMessage.Content().ReadAs(content);

            // Save the data of the InStream as a file.
            if (userid in ['PGR 1', 'PGR']) and GuiAllowed then begin
                TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);
                outStr.WriteText(content);
                TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
                fileName := StrSubstNo('Amazon__%1_.txt', format(responseMessage.HttpStatusCode()));
                File.DownloadFromStream(inStr, 'Export', '', '', fileName);
            end;
            ResponseString := content;
            exit(true);

        end;


    end;

    procedure SentAllAmazonInvoice(sInvNo: code[20])
    var
        sInvhead: record "Sales Invoice Header";
        sInvhead2: record "Sales Invoice Header";
    begin
        if sInvNo <> '' then
            sInvhead.Setrange("No.", sInvNo);
        sInvhead.Setfilter(AmazonInvSent, '<>%1', 0DT);
        sInvhead.setfilter(AmazonePoNo, '<>%1', '');
        if sInvhead.findset then
            repeat
                if SentAmazonInvoice(sInvhead) then begin
                    sInvhead2.get(sInvhead."No.");
                    sInvhead2.AmazonInvSent := CurrentDateTime;
                    sInvhead2.Modify(false);
                end;
                Commit;
            until sInvhead.Next = 0;
    end;



    procedure SentAmazonInvoice(Sinv: record "Sales Invoice Header"): Boolean
    var

        Amazsetup: record "amazon Setup";
        Httpcontent: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        httpResponse: HttpResponseMessage;
        client: HttpClient;
        content: Text;
        url: Text;
        token: JsonToken;
        token2: JsonToken;
        JSonArray: JsonArray;
        tiPartNumber: text;
        quantity: Decimal;
        newtoken: text;
        // test
        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        filename: text;
        temptext: text;
    begin
        if not ((userid in ['PGR', 'PGR', 'PGR_NAVKONSULENT.DK#EXT#']) and GuiAllowed) then
            if Sinv.AmazonInvSent <> 0DT then
                exit;

        Amazsetup.get(Sinv.AmazonSellpartyid);
        temptext := makeJsonPayloadInvoice(Sinv, Sinv.AmazonSellpartyid);

        if temptext <> '' then
            IF GetnewToken(newtoken, Sinv.AmazonSellpartyid) then begin
                httpcontent.writefrom(temptext);
                httpcontent.GetHeaders(contentHeaders);
                // contentHeaders.Add('Accept', 'application/json');
                // contentHeaders.Clear();
                // request.GetHeaders(contentHeaders);
                //  request.SetRequestUri(StrSubstNo(Amazsetup.URL_PO_GET, Amazsetup.URL_PO_GET_status));
                // request.Method := 'GET';
                HttpContent.GetHeaders(contentHeaders);
                contentHeaders.Add('x-amz-access-token', newtoken);
                contentHeaders.Remove('Content-Type');
                contentHeaders.Add('Content-Type', 'application/json');
                // contentHeaders.Add('Content-Length', format(StrLen(temptext)));

                if not (client.post(Amazsetup.URL_Post_Invoice, HttpContent, httpResponse)) then begin
                    Message('Url virker ikke : %1 %2 %3', Amazsetup.URL_Post_Invoice, httpResponse.HttpStatusCode(), httpResponse.ReasonPhrase());
                    exit(false);
                end;
                if not (httpResponse.IsSuccessStatusCode()) then begin
                    httpResponse.Content().ReadAs(content);
                    Message('Status code: %1\Description: %2, (%3)', httpResponse.HttpStatusCode(), httpResponse.ReasonPhrase(), copystr(content, 1, 512));
                    exit(false);
                end;

                // TEMP TEST >>
                httpResponse.Content().ReadAs(content);

                // Save the data of the InStream as a file.
                if (userid in ['PGR 1', 'PGR', 'PGR_NAVKONSULENT.DK#EXT#']) and GuiAllowed then begin
                    message('ok: %1', copystr(content, 1, 512));
                    TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);
                    outStr.WriteText(content + ' ' + temptext);
                    TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
                    fileName := StrSubstNo('Amazon_inv_%1_.txt', format(responseMessage.HttpStatusCode()));
                    File.DownloadFromStream(inStr, 'Export', '', '', fileName);
                end;

                // TEMP TEST >>
                exit(true);

            end;


    end;



    procedure SetAmazonOrderRejected(SO: record "Sales Header"; NordiskPartyid: code[10]): Boolean
    var

        Amazsetup: record "amazon Setup";
        Httpcontent: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        httpResponse: HttpResponseMessage;
        client: HttpClient;
        content: Text;
        url: Text;
        token: JsonToken;
        token2: JsonToken;
        JSonArray: JsonArray;
        tiPartNumber: text;
        quantity: Decimal;
        newtoken: text;
        // test
        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        filename: text;
        temptext: text;

    begin
        if SO.Status = SO.Status::Released then
            exit;
        Amazsetup.get(NordiskPartyid);
        temptext := makeJsonPayloadAcknowledgement(SO, NordiskPartyid);
        IF GetnewToken(newtoken, NordiskPartyid) then begin
            httpcontent.writefrom(temptext);
            httpcontent.GetHeaders(contentHeaders);
            contentHeaders.Clear();
            request.GetHeaders(contentHeaders);
            contentHeaders.Add('x-amz-access-token', newtoken);
            contentHeaders.Add('Accept', 'application/json');

            //  request.SetRequestUri(StrSubstNo(Amazsetup.URL_PO_GET, Amazsetup.URL_PO_GET_status));
            // request.Method := 'GET';
            HttpContent.GetHeaders(contentHeaders);
            contentHeaders.Remove('Content-Type');
            contentHeaders.Add('Content-Type', 'application/json');
            contentHeaders.Add('Content-Length', format(StrLen(temptext)));


            if not (client.post(Amazsetup.URL_Set_AKN, HttpContent, httpResponse)) then begin
                Message('Url virker ikke : ' + Amazsetup.URL_Set_AKN);
                //  exit(false);
            end;




            if not (responseMessage.IsSuccessStatusCode()) then begin
                Message('Status code: %1\Description: %2, (%3)', responseMessage.HttpStatusCode(), responseMessage.ReasonPhrase());
                exit(false);
            end;

            responseMessage.Content().ReadAs(content);

            // Save the data of the InStream as a file.
            if (userid in ['PGR 1', 'PGR']) and GuiAllowed then begin
                TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);
                outStr.WriteText(content);
                TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
                fileName := StrSubstNo('Amazon__%1_.txt', format(responseMessage.HttpStatusCode()));
                File.DownloadFromStream(inStr, 'Export', '', '', fileName);
            end;
            // ResponseString := content;
            exit(true);

        end;


    end;



    procedure GetnewToken(var token: text; NordiskPartyid: code[10]): Boolean
    var
        client: HttpClient;
        responseMessage: HttpResponseMessage;
        Httpcontent: HttpContent;
        contentHeaders: HttpHeaders;
        HttpHeadersContent: HttpHeaders;
        request: HttpRequestMessage;
        content: Text;
        url: Text;
        Amazsetup: record "Amazon Setup";
        Messagetxt: Text;
        Statustext: Text;
        temptext: text;
        Jsontoken: JsonToken;
        jsonobject: JsonObject;
        tmpString: text;
        resfreshtoken: text;
        TypeHelper: Codeunit "Type Helper";
    begin
        Amazsetup.get(NordiskPartyid);
        client.SetBaseAddress(Amazsetup."Token endpoint");
        //Messagetxt := makeJSONRefreshtoken();
        tmpString := 'client_id=' + TypeHelper.UrlEncode(Amazsetup.client_id) +
                    '&client_secret=' + TypeHelper.UrlEncode(Amazsetup.Client_Secret) +
                    '&refresh_token=' + TypeHelper.UrlEncode(Amazsetup.Refresh_token) +
                    '&grant_type=' + TypeHelper.UrlEncode(Amazsetup.grant_type);

        // https://forum.mibuso.com/discussion/76035/using-a-x-www-form-urlencoded-rest-api-with-business-central-to-get-token

        Httpcontent.WriteFrom(tmpString);
        Httpcontent.ReadAs(tmpString);
        contentHeaders := client.DefaultRequestHeaders();
        //contentHeaders.Add('accept', '*/*');

        //contentHeaders.Add('Host', 'app.iex.dk');
        HttpContent.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Add('charset', 'UTF-8');
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'application/x-www-form-urlencoded');

        if not (client.post(Amazsetup."Token endpoint", HttpContent, responseMessage)) then begin

            Message('Url virker ikke : ' + Amazsetup."Token endpoint");
            exit(false);
        end;

        if not (responseMessage.IsSuccessStatusCode()) then begin
            if Amazsetup.testmode then begin
                error('http error:\' +
                               'Status code: %1\' +
                             'Description: %2 (%4) %3',
                             responseMessage.HttpStatusCode(),
                             responseMessage.ReasonPhrase(), url, NordiskPartyid);
            end else
                Message('http error:\' +
                      'Status code: %1\' +
                    'Description: %2 (%4) %3',
                    responseMessage.HttpStatusCode(),
                    responseMessage.ReasonPhrase(), url, NordiskPartyid);
            exit(false);
        end else begin
            if responseMessage.HttpStatusCode() = 200 Then begin
                Httpcontent := responseMessage.Content();
                Httpcontent.ReadAs(temptext);
                Jsontoken.ReadFrom(temptext);
                jsonobject := Jsontoken.AsObject();
                jsonobject.Get('refresh_token', Jsontoken);
                resfreshtoken := Jsontoken.AsValue().AsText();
                Amazsetup.Refresh_token := resfreshtoken;
                Amazsetup.modify();


                jsonobject.Get('access_token', Jsontoken);
                token := Jsontoken.AsValue().AsText();
                EXIT(TRUE);
            end;
        end;

        EXIT(FALSE);

    end;

    Procedure makeJsonPayloadAcknowledgement(SO: record "Sales header"; NordiskPartyid: code[10]): text
    var
        Amazsetup: Record "Amazon Setup";
        Payload: JsonObject;
        OrderAcknowledgementArray: JsonArray;
        OrderAcknowledgement: JsonObject;
        item: JsonObject;
        salesline: record "Sales Line";
        itemarray: JsonArray;
        TempBlob: Codeunit "Temp Blob";
        sellingParty: JsonObject;
        order: JsonObject;
        partyId: JsonObject;
        itemAcknowledgements: JsonObject;
        itemAcknowledgementsarray: JsonArray;
        ItemQuantity: JsonObject;
        outStr: OutStream;
        inStr: InStream;
        TempFile: File;
        fileName: Text;
        totextvar: text;
        itemrec: record item;
    begin

        Amazsetup.get(NordiskPartyid);

        OrderAcknowledgement.add('purchaseOrderNumber', so.AmazonePoNo);
        partyId.Add('partyId', Amazsetup.ZyxelPartyid);
        OrderAcknowledgement.add('sellingParty', partyId);
        OrderAcknowledgement.add('acknowledgementDate', format(CurrentDateTime, 0, 9));

        // MANGLER RESTEN
        salesline.setrange("Document No.", so."No.");

        salesline.SetRange(type, salesline.type::Item);
        if salesline.findset Then
            repeat
                itemrec.get(salesline."No.");
                item.add('amazonProductIdentifier', Salesline."Item Reference No.");
                item.add('vendorProductIdentifier', itemrec.GTIN);
                item.add('orderedQuantity', format(salesline.Quantity));
                itemAcknowledgements.add('acknowledgementCode', 'REJECTED');
                ItemQuantity.add('amount', 0);
                itemAcknowledgements.add('acknowledgedQuantity', ItemQuantity);
                itemAcknowledgementsarray.add(itemAcknowledgements);
                item.add('itemAcknowledgements', itemAcknowledgementsarray);
                itemarray.Add(item);
                clear(item);
                clear(ItemQuantity);
                clear(itemAcknowledgements);
            until salesline.Next() = 0;

        OrderAcknowledgement.Add('items', itemarray);
        OrderAcknowledgementArray.Add(OrderAcknowledgement);
        order.add('orders', OrderAcknowledgementArray);
        order.WriteTo(totextvar);

        // Create an outStream from the Blob, notice the encoding.
        TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);


        // From the same Blob, that now contains the XML document, create an inStr
        order.WriteTo(outStr);
        TempBlob.CreateInStream(inStr, TextEncoding::UTF8);

        // Save the data of the InStream as a file.
        if (userid in ['PGR 1', 'PGR']) and GuiAllowed then begin
            fileName := 'Amaz_Acknowledge_message.txt';
            File.DownloadFromStream(inStr, 'Export', '', '', fileName);
        end;


        exit(totextvar);

    end;

    procedure makeJsonPayloadInvoice(Sinv: record "Sales Invoice Header"; NordiskPartyid: code[10]): text
    var
        Amazsetup: Record "Amazon Setup";
        compinfo: record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Custbillto: record customer;
        Payload: JsonObject;
        InvoiceArray: JsonArray;
        Invoice: JsonObject;
        invoiceTotal: JsonObject;
        amounttotal: JsonObject;
        item: JsonObject;
        salesline: record "Sales Invoice Line";
        itemarray: JsonArray;
        taxdetail: JsonObject;
        taxdetailarray: JsonArray;
        x: Integer;

        TempBlob: Codeunit "Temp Blob";
        sellingParty: JsonObject;
        FinalInvoice: JsonObject;
        partyId: JsonObject;
        itemAcknowledgements: JsonObject;
        itemAcknowledgementsarray: JsonArray;
        ItemQuantity: JsonObject;
        outStr: OutStream;
        inStr: InStream;
        TempFile: File;
        fileName: Text;
        totextvar: text;
        itemrec: record item;
        SalesInvoiceLine: record "Sales Invoice line";
        VATAmountLine2: Record "VAT Amount Line" temporary;
        CustAddressLine: Array[6] of text[100];
        CompAddressLine: Array[6] of text[100];
        tempdec: Decimal;
        tempint: integer;
    begin

        Amazsetup.get(NordiskPartyid);
        compinfo.get();
        CompAddressLine[1] := compinfo.Name;
        CompAddressLine[2] := compinfo.Address;
        CompAddressLine[3] := compinfo."Address 2";
        CompAddressLine[4] := compinfo."Post Code";
        CompAddressLine[5] := compinfo.City;
        CompAddressLine[6] := compinfo."Country/Region Code";


        GLSetup.get();
        Custbillto.get(Sinv."bill-to Customer No.");

        CustAddressLine[1] := Custbillto.Name;
        CustAddressLine[2] := Custbillto.Address;
        CustAddressLine[3] := Custbillto."Address 2";
        CustAddressLine[4] := Custbillto."Post Code";
        CustAddressLine[5] := Custbillto.City;
        CustAddressLine[6] := Custbillto."Country/Region Code";

        Invoice.add('invoiceType', 'Invoice');
        Invoice.add('id', Sinv."No.");
        Invoice.add('date', format(CreateDateTime(Sinv."Document Date", 120000T), 0, 9));
        Invoice.Add('remitToParty', MakePartyJsonObject(Amazsetup.ZyxelPartyid, compinfo."VAT Registration No.", CompAddressLine));
        Invoice.add('shipToParty', MakePartyJsonObject(CustNo2AmazonID(Sinv."Sell-to Customer No."), Custbillto."VAT Registration No.", CustAddressLine));
        Invoice.add('shipFromParty', MakePartyJsonObject(Amazsetup.ZyxelPartyid, compinfo."VAT Registration No.", CompAddressLine));
        Invoice.add('billToParty', MakePartyJsonObject(CustNo2AmazonID(Sinv."Sell-to Customer No."), Custbillto."VAT Registration No.", CustAddressLine));
        if Sinv."Currency Code" = '' then
            Sinv."Currency Code" := GLSetup."LCY Code";
        if Sinv."Currency Code" = '' then
            invoiceTotal.add('currencyCode', GLSetup."LCY Code")
        else
            invoiceTotal.add('currencyCode', Sinv."Currency Code");
        sinv.Calcfields("Amount Including VAT");
        invoiceTotal.add('amount', format(Sinv."Amount Including VAT", 0, 9));
        Invoice.add('invoiceTotal', invoiceTotal);

        //TaxDetails
        SalesInvoiceLine.setrange("Document No.", Sinv."No.");
        if SalesInvoiceLine.findset then
            repeat
                InsertVATAmountLine(VATAmountLine2, SalesInvoiceLine);
            until SalesInvoiceLine.next = 0;
        if VATAmountLine2.findset then begin
            repeat
                taxdetail.add('taxType', 'VAT');
                taxdetail.add('taxRate', format(VATAmountLine2."VAT %", 0, 9));
                clear(amounttotal);
                amounttotal.add('currencyCode', sinv."Currency Code");
                amounttotal.add('amount', format(VATAmountLine2."VAT Amount", 0, 9));
                taxdetail.add('taxAmount', amounttotal);
                clear(amounttotal);
                amounttotal.add('currencyCode', sinv."Currency Code");
                amounttotal.add('amount', format(VATAmountLine2."VAT Base", 0, 9));
                taxdetail.add('taxableAmount', amounttotal);
                taxdetailarray.Add(taxdetail);
                clear(taxdetail);

            until VATAmountLine2.next = 0;
            Invoice.Add('taxDetails', taxdetailarray);
        end;

        // MANGLER RESTEN
        Clear(taxdetailarray);
        clear(taxdetail);

        salesline.setrange("Document No.", sinv."No.");
        salesline.SetRange(type, salesline.type::Item);
        salesline.Setfilter(Amount, '<>0');
        if salesline.findset Then
            repeat
                x := x + 1;
                itemrec.get(salesline."No.");
                item.add('itemSequenceNumber', x);
                item.add('amazonProductIdentifier', Salesline."Item Reference No.");
                item.add('vendorProductIdentifier', itemrec.GTIN);
                evaluate(tempint, format(salesline.Quantity, 0, '<Integer>'));
                ItemQuantity.add('amount', tempint);

                ItemQuantity.add('unitOfMeasure', 'Eaches');
                item.add('invoicedQuantity', ItemQuantity);
                clear(amounttotal);
                amounttotal.add('currencyCode', sinv."Currency Code");
                amounttotal.add('amount', format(round(salesline.Amount / salesline.Quantity), 0, 9));


                item.add('netCost', amounttotal);
                item.add('purchaseOrderNumber', sinv.AmazonePoNo);

                // make taxdetails >>
                taxdetail.add('taxType', 'VAT');
                taxdetail.add('taxRate', format(salesline."VAT %", 0, 9));
                clear(amounttotal);
                amounttotal.add('currencyCode', sinv."Currency Code");
                amounttotal.add('amount', format(salesline."Amount Including VAT" - salesline.Amount, 0, 9));
                taxdetail.add('taxAmount', amounttotal);
                clear(amounttotal);
                amounttotal.add('currencyCode', sinv."Currency Code");
                amounttotal.add('amount', format(salesline."VAT Base Amount", 0, 9));
                taxdetail.add('taxableAmount', amounttotal);
                taxdetailarray.Add(taxdetail);
                clear(taxdetail);
                item.Add('taxDetails', taxdetailarray);
                Clear(taxdetailarray);


                // // 
                // item.add('orderedQuantity', format(salesline.Quantity));
                // itemAcknowledgements.add('acknowledgementCode', 'REJECTED');
                // ItemQuantity.add('amount', 0);
                // itemAcknowledgements.add('acknowledgedQuantity', ItemQuantity);
                // itemAcknowledgementsarray.add(itemAcknowledgements);
                // item.add('itemAcknowledgements', itemAcknowledgementsarray);

                itemarray.Add(item);
                clear(item);
                clear(ItemQuantity);
                clear(itemAcknowledgements);
            until salesline.Next() = 0;

        Invoice.Add('items', itemarray);
        InvoiceArray.Add(Invoice);
        FinalInvoice.add('invoices', InvoiceArray);
        FinalInvoice.WriteTo(totextvar);

        // Create an outStream from the Blob, notice the encoding.

        // Save the data of the InStream as a file.
        // if (userid in ['PGR 1', 'PGR', 'PGR_NAVKONSULENT.DK#EXT#']) and GuiAllowed then begin
        if GuiAllowed then begin
            TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);
            FinalInvoice.WriteTo(outStr);
            TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
            fileName := 'Amaz_Invoice_message.txt';
            File.DownloadFromStream(inStr, 'Export', '', '', fileName);
        end;


        exit(totextvar);

    end;

    procedure MakePartyJsonObject(Partyid: code[10]; VatID: Code[100]; AddressLine: Array[6] of text[100]): JsonObject
    var
        Partytoken: JsonObject;
        taxRegistrationDetails: JsonObject;
        address: JsonObject;
        taxRegistrationDetailsArray: JsonArray;
    begin
        Partytoken.Add('partyId', Partyid);
        if AddressLine[1] <> '' then begin
            address.add('name', AddressLine[1]);
            address.add('addressLine1', AddressLine[2]);
            if AddressLine[3] <> '' then
                address.add('addressLine2', AddressLine[3]);
            address.add('city', AddressLine[5]);
            address.add('postalOrZipCode', AddressLine[4]);
            address.add('countryCode', AddressLine[6]);
            Partytoken.Add('address', address);
        end;
        if VatID <> '' then begin
            taxRegistrationDetails.add('taxRegistrationType', 'VAT');
            taxRegistrationDetails.add('taxRegistrationNumber', VatID);
            taxRegistrationDetailsArray.Add(taxRegistrationDetails);
            Partytoken.Add('taxRegistrationDetails', taxRegistrationDetailsArray);
        end;
        exit(Partytoken);
    end;

    // procedure makeJSONpayloadtoken(): text
    // var
    //     eixsetup: record "EIX Setup";
    //     JObject: JsonObject;
    //     Messagestring: text;
    // begin
    //     eixsetup.get();
    //     // {
    //     // "grant_type":"authorization_code"
    //     // "client_id":"92802577-bd3a-4121-9482-9409429276d6"
    //     // "client_secret":"<client_secret>"
    //     // "redirect_uri":"https://businesscentral.dynamics.com/OAuthLanding.htm"
    //     // "code":"<authorization_code>"
    //     // }

    //     JObject.add('grant_type', eixsetup.Grant_type);
    //     JObject.add('client_id', eixsetup.client_id);
    //     JObject.add('client_secret', eixsetup.client_secret);
    //     JObject.add('redirect_uri', eixsetup.redirect_uri);
    //     JObject.add('code', eixsetup."Authorization Code");



    //     JObject.WriteTo(Messagestring);
    //     EXIT(Messagestring);
    // end;

    // procedure makeJSONRefreshtoken(): text
    // var
    //     eixsetup: record "EIX Setup";
    //     JObject: JsonObject;
    //     Messagestring: text;
    // begin
    //     eixsetup.get();
    //     // {
    //     // "grant_type":"authorization_code"
    //     // "client_id":"92802577-bd3a-4121-9482-9409429276d6"
    //     // "client_secret":"<client_secret>"
    //     // "redirect_uri":"https://businesscentral.dynamics.com/OAuthLanding.htm"
    //     // "code":"<authorization_code>"
    //     // }

    //     JObject.add('grant_type', 'refresh_token');
    //     JObject.add('client_id', eixsetup.client_id);
    //     JObject.add('client_secret', eixsetup.client_secret);
    //     JObject.add('refresh_token', eixsetup.refresh_token);




    //     JObject.WriteTo(Messagestring);
    //     EXIT(Messagestring);
    // end;



    // local procedure MakeMessageeixStock(): text
    // var

    //     Sku: JsonObject;
    //     skuarray: JsonArray;
    //     Stock: JsonObject;

    //     TempBlob: Codeunit "Temp Blob";

    //     outStr: OutStream;
    //     inStr: InStream;
    //     TempFile: File;
    //     fileName: Text;
    //     totextvar: text;
    //     Item: record item;
    //     SCBInformationEntry: record "SCB Information Entry";

    //     Navkfunction: codeunit "NAVK-function";
    // begin


    //   "stock": [
    //     {
    //       "sku": "string",
    //       "parent_sku": "string",
    //       "stock_remaining": "float",
    //       "stock_change": "float",
    //       "ean": "string",
    //       "cost_price": "float"
    //       }
    //          ]
    //       }



    // SCBInformationEntry.setrange(Table, 27);
    // SCBInformationEntry.setrange("Information Code", 'EIX ITEM');
    // SCBInformationEntry.setrange("Information Value", 'YES');
    // if SCBInformationEntry.findset Then
    //     repeat
    //         if item.get(SCBInformationEntry."No.") then begin
    //             sku.add('sku', item."No.");
    //             sku.add('parent_sku', item."No.");
    //             //sku.add('stock_remaining', TBsync.GetAvailable(item, false, false, false));
    //             sku.add('stock_remaining', Navkfunction.NordicStocklevelUpdateMain('AMAZ', Item."No.", false));
    //             sku.add('stock_change', 0);
    //             sku.add('ean', item.GTIN);
    //             sku.add('cost_price', Item."Unit Cost");
    //             skuarray.Add(sku);
    //             clear(sku);
    //         end;
    //     until SCBInformationEntry.next = 0;
    // Stock.add('stock', skuarray.AsToken());
    // Stock.WriteTo(totextvar);

    // // Create an outStream from the Blob, notice the encoding.
    // TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);


    // // From the same Blob, that now contains the XML document, create an inStr
    // Stock.WriteTo(outStr);
    // TempBlob.CreateInStream(inStr, TextEncoding::UTF8);

    // // Save the data of the InStream as a file.
    // if userid = 'PGR 1' then begin
    //     fileName := 'EIX_stock_mmessage.txt';
    //     File.DownloadFromStream(inStr, 'Export', '', '', fileName);
    // end;


    // exit(totextvar);




    // end;

    procedure Refresh_LWA_Token(Partyid: code[10]): Text

    var
        client: HttpClient;
        cont: HttpContent;
        header: HttpHeaders;
        response: HttpResponseMessage;
        Jobject: JsonObject;
        tmpString: Text;
        TypeHelper: Codeunit "Type Helper";


        Client_ID: Text;
        Client_Secret: Text;
        grant_type: Text;
        refresh_token: Text[10000];
        ResponseText: Text;

        Amazsetup: record "Amazon Setup";
    begin
        Amazsetup.get(Partyid);


        Client_ID := Amazsetup.client_id;
        Client_Secret := Amazsetup.client_secret;
        grant_type := 'refresh_token';
        refresh_token := Amazsetup.Refresh_token;


        tmpString := 'client_id=' + TypeHelper.UrlEncode(Client_ID) +
        '&client_secret=' + TypeHelper.UrlEncode(Client_Secret) +
        '&refresh_token=' + TypeHelper.UrlEncode(refresh_token) +
        '&grant_type=' + TypeHelper.UrlEncode(grant_type);



        cont.WriteFrom(tmpString);
        cont.ReadAs(tmpString);

        cont.GetHeaders(header);
        header.Add('charset', 'UTF-8');
        header.Remove('Content-Type');
        header.Add('Content-Type', 'application/x-www-form-urlencoded');

        client.Post('https://api.amazon.com/auth/o2/token', cont, response);
        response.Content.ReadAs(ResponseText);
        if (response.IsSuccessStatusCode) then begin
            Message(ResponseText);
        end
        else
            Message(ResponseText);


    end;

    local procedure InsertVATAmountLine(var VATAmountLine2: Record "VAT Amount Line"; SalesInvoiceLine: Record "Sales Invoice Line")
    var

    begin

        VATAmountLine2.Init();
        VATAmountLine2."VAT Identifier" := SalesInvoiceLine."VAT Identifier";
        VATAmountLine2."VAT Calculation Type" := SalesInvoiceLine."VAT Calculation Type";
        VATAmountLine2."Tax Group Code" := SalesInvoiceLine."Tax Group Code";
        VATAmountLine2."VAT %" := SalesInvoiceLine."VAT %";
        VATAmountLine2."VAT Base" := SalesInvoiceLine.Amount;
        VATAmountLine2."Amount Including VAT" := SalesInvoiceLine."Amount Including VAT";
        VATAmountLine2."Line Amount" := SalesInvoiceLine."Line Amount";
        if SalesInvoiceLine."Allow Invoice Disc." then
            VATAmountLine2."Inv. Disc. Base Amount" := SalesInvoiceLine."Line Amount";
        VATAmountLine2."Invoice Discount Amount" := SalesInvoiceLine."Inv. Discount Amount";
        VATAmountLine2."VAT Clause Code" := SalesInvoiceLine."VAT Clause Code";
        VATAmountLine2.InsertLine();
    end;


    procedure OnetimeUpdateshipping()
    var
        Salesheader: record "Sales Header";
        Salesline: record "Sales Line";
    begin
        Salesheader.setrange("Document Type", Salesheader."Document Type"::Order);
        Salesheader.setrange(Status, Salesheader.Status::Open);
        Salesheader.setfilter(AmazonePoNo, '<>%1', '');
        if Salesheader.findset then
            repeat
                Salesheader."Order Date" := Salesheader."Shipment Date";

                Salesheader."VAT Reporting Date" := Salesheader."Shipment Date";
                Salesheader."Posting Date" := Salesheader."Shipment Date";
                Salesheader."Document Date" := Salesheader."Shipment Date";
                Salesheader."Requested Delivery Date" := Salesheader."Shipment Date";
                Salesheader.modify(false);
                salesline.setrange("Document Type", Salesheader."Document Type");
                salesline.setrange("Document No.", Salesheader."No.");
                Salesline.setfilter(Quantity, '<>0');
                if Salesline.FindSet() then
                    repeat
                        Salesline.Validate("Shipment Date", Salesheader."Shipment Date");
                        Salesline.Validate("Requested Delivery Date", Salesheader."Shipment Date");
                        Salesline.Modify(true);
                    until Salesline.Next() = 0;

            until Salesheader.Next() = 0;
    end;



    procedure GETAmazonOrderpackingSlips(var ResponseString: text; Partyid: code[10]; salesheader: record "Sales Header"): Boolean
    var

        Amazsetup: record "amazon Setup";
        Httpcontent: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        client: HttpClient;
        content: Text;
        url: Text;
        token: JsonToken;
        token2: JsonToken;
        JSonArray: JsonArray;
        tiPartNumber: text;
        quantity: Decimal;
        newtoken: text;
        // test
        TempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        filename: text;

    begin
        Amazsetup.get(Partyid);

        IF GetnewToken(newtoken, Partyid) then begin
            httpcontent.GetHeaders(contentHeaders);
            contentHeaders.Clear();
            request.GetHeaders(contentHeaders);
            contentHeaders.Add('x-amz-access-token', newtoken);
            contentHeaders.Add('Accept', 'application/json');
            request.SetRequestUri(StrSubstNo(Amazsetup.URL_packingSlips_order, salesheader.AmazonePoNo));
            request.Method := 'GET';

            if not (client.send(request, responseMessage)) then begin
                error('Url virker ikke: ' + url);
                exit(false);
            end;

            if not (responseMessage.IsSuccessStatusCode()) then begin
                Message('Status code: %1\Description: %2, (%3)', responseMessage.HttpStatusCode(), responseMessage.ReasonPhrase());
                exit(false);
            end;

            responseMessage.Content().ReadAs(content);

            // Save the data of the InStream as a file.
            if (userid in ['PGR 1', 'ZYXEL\PELLE.GRONBERG']) and GuiAllowed then begin
                TempBlob.CreateOutStream(outStr, TextEncoding::UTF8);
                outStr.WriteText(content);
                TempBlob.CreateInStream(inStr, TextEncoding::UTF8);
                fileName := StrSubstNo('Amazon__%1_.txt', format(responseMessage.HttpStatusCode()));
                File.DownloadFromStream(inStr, 'Export', '', '', fileName);
            end;
            ResponseString := content;
            exit(true);

        end;


    end;

}
