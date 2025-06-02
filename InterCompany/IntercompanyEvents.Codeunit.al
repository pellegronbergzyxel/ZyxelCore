codeunit 50048 "Intercompany Events"
{
    // 001. 02-05-24 - ZY-LD 000 - Events has been moved from General Ledger Envents.
    // 050. 29-05-24 ZY-LD 000 - Validating sample item no., because we have seen that the no. end up blank on the purchase invoice.

    #region ICSalesInvoice
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesInvTransOnBeforeOutboxTransactionInsert', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxSalesInvTransOnBeforeOutboxTransactionInsert(var OutboxTransaction: Record "IC Outbox Transaction")
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        if SalesInvHeader.Get(OutboxTransaction."Document No.") then
            OutboxTransaction.eCommerce := SalesInvHeader."eCommerce Order";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnAfterICOutBoxSalesHeaderTransferFields', '', false, false)]
    local procedure ICInboxOutboxMgt_OnAfterICOutBoxSalesHeaderTransferFields(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesHeader: Record "Sales Header")
    var
        lCust: Record Customer;
        BillToCustomer: Record Customer;
    begin
        // 001: >>
        lCust.Get(SalesHeader."Sell-to Customer No.");
        BillToCustomer.Get(SalesHeader."Bill-to Customer No.");
        if BillToCustomer."Sub company" and
           not lCust."Avoid Creation of SI in SUB"  // 09-11-17 ZY-LD 003  // 13-11-18 ZY-LD 012
        then
            ICOutBoxSalesHeader."End Customer" := SalesHeader."Sell-to Customer No.";
        // 001: <<

        //>> 07-11-17 ZY-LD 003
        // //RD CZ 1.0
        // IF ICLocation.GET(SalesHeader."Bill-to Country/Region Code") THEN
        //   IF ICLocation."Intern Customer" = SalesHeader."Sell-to Customer No." THEN
        //      ICOutBoxSalesHeader."End Customer" := '';
        // //RD CZ 1.0
        //<< 07-11-17 ZY-LD 003

        // 003: >>
        ICOutBoxSalesHeader."Sales Order Type" := SalesHeader."Sales Order Type";
        // 003: <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesInvTransOnAfterTransferFieldsFromSalesInvHeader', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxSalesInvTransOnAfterTransferFieldsFromSalesInvHeader(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesInvHdr: Record "Sales Invoice Header"; ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        lCust: Record Customer;
        BillToCustomer: Record Customer;
    begin
        // 001: >>
        lCust.Get(SalesInvHdr."Sell-to Customer No.");
        BillToCustomer.Get(SalesInvHdr."Bill-to Customer No.");
        if BillToCustomer."Sub company" and
           not lCust."Avoid Creation of SI in SUB"  // 09-11-17 ZY-LD 003
        then
            ICOutBoxSalesHeader."End Customer" := SalesInvHdr."Sell-to Customer No.";

        //>> 07-11-17 ZY-LD 003
        // //RD CZ 1.0
        // IF ICLocation.GET(SalesInvHdr."Bill-to Country/Region Code") THEN
        //   IF ICLocation."Intern Customer" = SalesInvHdr."Sell-to Customer No." THEN
        //      ICOutBoxSalesHeader."End Customer" := '';
        // //RD CZ 1.0
        // 001: <<
        //ICOutBoxSalesHeader."Location Code":=SalesInvHdr."Location Code";  //ZL111006B
        //ICOutBoxSalesHeader."Location Code":= GetLocationCode(SalesInvHdr."Bill-to Country/Region Code",SalesInvHdr."Location Code",SalesInvHdr."Sell-to Customer No.");  // 21-01-21 ZY-LD 021  
        ICOutBoxSalesHeader."Location Code" := GetLocationCode(SalesInvHdr."Ship-to Country/Region Code", SalesInvHdr."Location Code", SalesInvHdr."Sell-to Customer No.");  // 21-01-21 ZY-LD 021
                                                                                                                                                                             //<< 07-11-17 ZY-LD 003
                                                                                                                                                                             // 003: >>

        ICOutBoxSalesHeader."Sales Order Type" := SalesInvHdr."Sales Order Type";
        ICOutBoxSalesHeader."Ship-to Name 2" := SalesInvHdr."Ship-to Name 2";
        ICOutBoxSalesHeader."Ship-to Address 2" := SalesInvHdr."Ship-to Address 2";
        ICOutBoxSalesHeader."Ship-to Post Code" := SalesInvHdr."Ship-to Post Code";
        ICOutBoxSalesHeader."Ship-to Country/Region Code" := SalesInvHdr."Ship-to Country/Region Code";
        ICOutBoxSalesHeader."Ship-to Contact" := SalesInvHdr."Ship-to Contact";
        ICOutBoxSalesHeader."Ship-to County" := SalesInvHdr."Ship-to County";
        ICOutBoxSalesHeader."Ship-to E-Mail" := SalesInvHdr."Ship-to E-Mail";
        ICOutBoxSalesHeader."Ship-to VAT" := SalesInvHdr."Ship-to VAT";
        ICOutBoxSalesHeader."eCommerce Order" := SalesInvHdr."eCommerce Order";
        ICOutBoxSalesHeader."Your Reference 2" := SalesInvHdr."Reference 2";

        ICOutBoxSalesHeader."Salesperson Code" := SalesInvHdr."Salesperson Code";  // 20-03-18 ZY-LD 008
        ICOutBoxSalesHeader."Ship-to Code" := SalesInvHdr."Ship-to Code";  // 09-10-18 ZY-LD 011
        ICOutBoxSalesHeader."Order Date" := SalesInvHdr."Order Date";  // 18-12-18 ZY-LD 014
        ICOutBoxSalesHeader."E-Invoice Comment" := SalesInvHdr."E-Invoice Comment";  // 01-02-19 ZY-LD 015
        ICOutBoxSalesHeader."Currency Code Sales Doc SUB" := SalesInvHdr."Currency Code Sales Doc SUB";  // 09-12-19 ZY-LD 018
        ICOutBoxSalesHeader."Shipment Method Code" := SalesInvHdr."Shipment Method Code";  // 10-07-20 ZY-LD 019
        ICOutBoxSalesHeader."VAT Registration No." := SalesInvHdr."Company VAT Registration Code";  // 21-01-21 ZY-LD 021
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesInvTransOnBeforeICOutBoxSalesLineInsert', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxSalesInvTransOnBeforeICOutBoxSalesLineInsert(var ICOutboxSalesLine: Record "IC Outbox Sales Line"; SalesInvLine: Record "Sales Invoice Line")
    var
        SalesInvHdr: Record "Sales Invoice Header";
        recGLAcc: Record "G/L Account";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        Customer: Record Customer;
        ICPartner: Record "IC Partner";
        ICDocDim: Record "IC Document Dimension";
        Item: Record Item;
        ICOutboxSalesLine2: Record "IC Outbox Sales Line";
        ICOutBoxSalesHeader: Record "IC Outbox Sales Header";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        lText001: Label 'Problem with creation of "%1" on sales invoice "%2". Please raise a ticket to navsupport with the error.';
    begin
        //>> 07-11-17 ZY-LD 003
        //"Location Code":=SalesInvLine."Location Code";//ZL111006B+

        SalesInvHdr.Get(SalesInvLine."Document No.");
        if SalesInvLine."Location Code" <> '' then
            ICOutboxSalesLine."Location Code" := GetLocationCode(SalesInvHdr."Ship-to Country/Region Code", SalesInvHdr."Location Code", SalesInvHdr."Sell-to Customer No.");
        //<< 07-11-17 ZY-LD 003

        ICOutBoxSalesLine."Return Reason Code" := SalesInvLine."Return Reason Code"; //PAB 31/01/13

        //>> 04-02-21 ZY-LD 021
        Customer.Get(SalesInvHdr."Bill-to Customer No.");
        ICPartner.Get(Customer."IC Partner Code");

        if (SalesInvLine."Bill-to Customer No." <> SalesInvLine."Sell-to Customer No.") and
            (SalesInvLine.Type = SalesInvLine.Type::Item)
        then begin
            if ICPartner."Outbound Sales Item No. Type" = ICPartner."Outbound Sales Item No. Type"::"Internal No." then begin
                //>> 04-02-21 ZY-LD 021
                recGenBusPostGrp.Get(SalesInvLine."Gen. Bus. Posting Group");
                if (SalesInvHdr."Ship-to Country/Region Code" <> 'TR') and  // 14-02-23 ZY-LD 031
                   (recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."Sample / Test Equipment"::" ")
                then begin
                    //recGenBusPostGrp.TestField("Sample G/L Account No."); 
                    if recGenBusPostGrp."Sample G/L Account No." <> '' then begin
                        ICOutboxSalesLine."IC Partner Ref. Type" := ICOutboxSalesLine."IC Partner Ref. Type"::"G/L Account";
                        ICOutboxSalesLine."IC Partner Reference" := recGenBusPostGrp."Sample G/L Account No.";
                    end;
                end;
            end else begin
                Item.Get(SalesInvLine."No.");
                if SalesInvLine."VAT Prod. Posting Group" <> Item."VAT Prod. Posting Group" then
                    ICOutBoxSalesLine."VAT Prod. Posting Group" := SalesInvLine."VAT Prod. Posting Group";
                //<< 30-11-21 ZY-LD 028
            end;
        end else begin
            case SalesInvLine.Type of
                SalesInvLine.Type::Item:
                    begin
                        //>> 04-02-21 ZY-LD 021
                        recGenBusPostGrp.Get(SalesInvLine."Gen. Bus. Posting Group");
                        if (recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."Sample / Test Equipment"::" ") and
                           (recGenBusPostGrp."Sample G/L Account No." <> '')  // 12-06-24 ZY-LD 050
                        then begin
                            //recGenBusPostGrp.TestField("Sample G/L Account No.");  // 12-06-24 ZY-LD 050
                            ICOutBoxSalesLine."IC Partner Ref. Type" := ICOutBoxSalesLine."IC Partner Ref. Type"::"G/L Account";
                            ICOutBoxSalesLine."IC Partner Reference" := recGenBusPostGrp."Sample G/L Account No.";
                        end else begin  //<< 04-02-21 ZY-LD 021
                            ICOutBoxSalesLine."IC Partner Ref. Type" := ICOutBoxSalesLine."IC Partner Ref. Type"::Item;
                            ICOutBoxSalesLine."IC Partner Reference" := SalesInvLine."No.";
                            //>> 30-11-21 ZY-LD 028
                            Item.Get(SalesInvLine."No.");
                            if SalesInvLine."VAT Prod. Posting Group" <> Item."VAT Prod. Posting Group" then
                                ICOutBoxSalesLine."VAT Prod. Posting Group" := SalesInvLine."VAT Prod. Posting Group";
                            //<< 30-11-21 ZY-LD 028
                        end;
                    end;
                //>> 19-11-21 ZY-LD 027
                SalesInvLine.Type::"G/L Account":
                    begin
                        ICOutBoxSalesLine."IC Partner Ref. Type" := ICOutBoxSalesLine."IC Partner Ref. Type"::"G/L Account";
                        ICOutBoxSalesLine."IC Partner Reference" := SalesInvLine."No.";
                        //>> 30-11-21 ZY-LD 028
                        recGLAcc.Get(SalesInvLine."No.");
                        if SalesInvLine."VAT Prod. Posting Group" <> recGLAcc."VAT Prod. Posting Group" then
                            ICOutBoxSalesLine."VAT Prod. Posting Group" := SalesInvLine."VAT Prod. Posting Group";
                        //<< 30-11-21 ZY-LD 028
                    end;
            //<< 19-11-21 ZY-LD 027
            end;
            //<< 21-08-19 ZY-LD 017
        end;

        ICOutBoxSalesLine."Gen. Prod. Posting Group" := SalesInvLine."Gen. Prod. Posting Group";
        ICOutboxSalesLine."IC Payment Terms" := SalesInvLine."IC Payment Terms";  // 20-09-18 ZY-LD 010
        recGenBusPostGrp.Get(SalesInvHdr."Gen. Bus. Posting Group");  // 04-02-21 ZY-LD 021
        if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."Sample / Test Equipment"::" " then  // 04-02-21 ZY-LD 021
            //>> 09-08-19 ZY-LD 016
            if (SalesInvLine.Type = SalesInvLine.Type::Item) and
             (SalesInvLine.Type <> ICOutboxSalesLine."IC Partner Ref. Type")
          then
                Error(lText001, ICOutboxSalesLine.TableCaption(), SalesInvHdr."No.");
        //<< 09-08-19 ZY-LD 016

        ICOutBoxSalesLine."External Document Position No." := SalesInvLine."External Document Position No.";

        //>> 04-02-21 ZY-LD 021
        if (recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."Sample / Test Equipment"::"Test Equipment") and
           (ICOutBoxSalesLine."IC Partner Ref. Type" = ICOutboxSalesLine."IC Partner Ref. Type"::"G/L Account")  // 03-09-21 ZY-LD 021 - We don´t want to copy text lines.
        then
            if ICPartner."Outbound Sales Item No. Type" = ICPartner."Outbound Sales Item No. Type"::"Internal No." then begin
                ICOutBoxSalesLine2 := ICOutBoxSalesLine;
                ICOutBoxSalesLine2."Line No." += 1;
                ICOutBoxSalesLine2."IC Partner Ref. Type" := ICOutboxSalesLine."IC Partner Ref. Type"::Item;
                ICOutBoxSalesLine2."IC Partner Reference" := SalesInvLine."No.";
                ICOutBoxSalesLine2."Unit Price" := 0;
                ICOutBoxSalesLine2."Line Discount Amount" := 0;
                ICOutBoxSalesLine2."Amount Including VAT" := 0;
                ICOutBoxSalesLine2.Insert(true);

                ICDocDim."Transaction No." := ICOutBoxSalesHeader."IC Transaction No.";
                ICDocDim."IC Partner Code" := ICOutBoxSalesHeader."IC Partner Code";
                ICDocDim."Transaction Source" := ICOutBoxSalesHeader."Transaction Source";
                ICDocDim."Line No." := ICOutBoxSalesLine2."Line No.";

                ICInboxOutboxMgt.CreateICDocDimFromPostedDocDim(ICDocDim, SalesInvLine."Dimension Set ID", Database::"IC Outbox Sales Line");
            end;
        //<< 04-02-21 ZY-LD 021
    end;
    //     #endregion

    //     #region ICSalesCrMemo
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesCrMemoTransOnBeforeOutboxTransactionInsert', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxSalesCrMemoTransOnBeforeOutboxTransactionInsert(var OutboxTransaction: Record "IC Outbox Transaction")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if SalesCrMemoHeader.Get(OutboxTransaction."Document No.") then
            OutboxTransaction.eCommerce := SalesCrMemoHeader."eCommerce Order";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesCrMemoTransOnAfterTransferFieldsFromSalesCrMemoHeader', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxSalesCrMemoTransOnAfterTransferFieldsFromSalesCrMemoHeader(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesCrMemoHdr: Record "Sales Cr.Memo Header"; ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        lCust: Record Customer;
        BillToCustomer: Record Customer;
    begin
        // 001: >>
        lCust.Get(SalesCrMemoHdr."Sell-to Customer No.");
        BillToCustomer.Get(SalesCrMemoHdr."Bill-to Customer No.");
        if BillToCustomer."Sub company" and
           not lCust."Avoid Creation of SI in SUB"  // 09-11-17 ZY-LD 003
        then
            ICOutBoxSalesHeader."End Customer" := SalesCrMemoHdr."Sell-to Customer No.";

        //>> 07-11-17 ZY-LD 003
        // //RD CZ 1.0
        // IF ICLocation.GET(SalesCrMemoHdr."Bill-to Country/Region Code") THEN
        //   IF ICLocation."Intern Customer" = SalesCrMemoHdr."Sell-to Customer No." THEN
        //      ICOutBoxSalesHeader."End Customer" := '';
        // //RD CZ 1.0
        // 001: <<
        //ICOutBoxSalesHeader."Location Code":=SalesCrMemoHdr."Location Code";  //ZL111006B
        //ICOutBoxSalesHeader."Location Code":= GetLocationCode(SalesCrMemoHdr."Bill-to Country/Region Code",SalesCrMemoHdr."Location Code",SalesCrMemoHdr."Sell-to Customer No.");  // 21-01-21 ZY-LD 021  
        ICOutBoxSalesHeader."Location Code" := GetLocationCode(SalesCrMemoHdr."Ship-to Country/Region Code", SalesCrMemoHdr."Location Code", SalesCrMemoHdr."Sell-to Customer No.");  // 21-01-21 ZY-LD 021
                                                                                                                                                                                      //<< 07-11-17 ZY-LD 003
                                                                                                                                                                                      // 003: >>
        ICOutBoxSalesHeader."eCommerce Order" := SalesCrMemoHdr."eCommerce Order";  // 27-12-17 ZY-LD 004
        ICOutBoxSalesHeader."Your Reference 2" := SalesCrMemoHdr."Reference 2";  // 27-12-17 ZY-LD 004
        ICOutBoxSalesHeader."Salesperson Code" := SalesCrMemoHdr."Salesperson Code";  // 20-03-18 ZY-LD 008
        ICOutBoxSalesHeader."Ship-to Code" := SalesCrMemoHdr."Ship-to Code";  // 13-11-18 ZY-LD 013
        ICOutBoxSalesHeader."E-Invoice Comment" := SalesCrMemoHdr."E-Invoice Comment";  // 01-02-19 ZY-LD 015
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesCrMemoTransOnBeforeICOutBoxSalesLineInsert', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateOutboxSalesCrMemoTransOnBeforeICOutBoxSalesLineInsert(var ICOutboxSalesLine: Record "IC Outbox Sales Line"; SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        recGLAcc: Record "G/L Account";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        Customer: Record Customer;
        ICPartner: Record "IC Partner";
        ICDocDim: Record "IC Document Dimension";
        Item: Record Item;
        ICOutboxSalesLine2: Record "IC Outbox Sales Line";
        ICOutBoxSalesHeader: Record "IC Outbox Sales Header";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        lText001: Label 'Problem with creation of "%1" on sales CrMemooice "%2". Please raise a ticket to navsupport with the error.';
    begin
        //>> 21-08-18 ZY-LD 009
        if (SalesCrMemoLine."No." <> '') AND (ICOutBoxSalesLine."IC Partner Reference" = '') then begin
            ICOutBoxSalesLine."IC Partner Ref. Type" := SalesCrMemoLine.Type;
            ICOutBoxSalesLine."IC Partner Reference" := SalesCrMemoLine."No.";
        end;
        //<< 21-08-18 ZY-LD 009

        ICOutBoxSalesLine."Return Reason Code" := SalesCrMemoLine."Return Reason Code"; // PAB 31/01/13
        ICOutBoxSalesLine."Gen. Prod. Posting Group" := SalesCrMemoLine."Gen. Prod. Posting Group"; // RD 3.0

        //>> 07-11-17 ZY-LD 003
        //"Location Code":=SalesCrMemoLine."Location Code";//ZL111006B+

        SalesCrMemoHdr.Get(SalesCrMemoLine."Document No.");
        if SalesCrMemoLine."Location Code" <> '' then
            ICOutboxSalesLine."Location Code" := GetLocationCode(SalesCrMemoHdr."Ship-to Country/Region Code", SalesCrMemoHdr."Location Code", SalesCrMemoHdr."Sell-to Customer No.");
        //<< 07-11-17 ZY-LD 003

        //>> 04-02-21 ZY-LD 021
        Customer.Get(SalesCrMemoHdr."Bill-to Customer No.");
        ICPartner.Get(Customer."IC Partner Code");

        //>> 04-02-21 ZY-LD 021
        if ICOutBoxSalesLine."IC Partner Ref. Type" = ICOutBoxSalesLine."IC Partner Ref. Type"::Item then begin
            recGenBusPostGrp.Get(SalesCrMemoLine."Gen. Bus. Posting Group");
            if recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."Sample / Test Equipment"::" " then begin
                //recGenBusPostGrp.TestField("Sample G/L Account No.");
                if recGenBusPostGrp."Sample G/L Account No." <> '' then begin
                    ICOutBoxSalesLine."IC Partner Ref. Type" := ICOutBoxSalesLine."IC Partner Ref. Type"::"G/L Account";
                    ICOutBoxSalesLine."IC Partner Reference" := recGenBusPostGrp."Sample G/L Account No.";
                end;
            end;
        end;
        //<< 04-02-21 ZY-LD 021

        case SalesCrMemoLine.Type of
            SalesCrMemoLine.Type::"G/L Account":
                begin
                    //>> 30-11-21 ZY-LD 028
                    recGLAcc.Get(SalesCrMemoLine."No.");
                    if SalesCrMemoLine."VAT Prod. Posting Group" <> recGLAcc."VAT Prod. Posting Group" then
                        ICOutboxSalesLine."VAT Prod. Posting Group" := SalesCrMemoLine."VAT Prod. Posting Group";
                    //<< 30-11-21 ZY-LD 028
                end;
            SalesCrMemoLine.Type::Item:
                begin
                    Item.Get(SalesCrMemoLine."No.");
                    if SalesCrMemoLine."VAT Prod. Posting Group" <> Item."VAT Prod. Posting Group" then
                        ICOutboxSalesLine."VAT Prod. Posting Group" := SalesCrMemoLine."VAT Prod. Posting Group";
                end;
        end;

        //>> 04-02-21 ZY-LD 021
        if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."Sample / Test Equipment"::"Test Equipment" then begin
            ICOutBoxSalesLine2 := ICOutBoxSalesLine;
            ICOutBoxSalesLine2."Line No." += 1;
            ICOutBoxSalesLine2."IC Partner Ref. Type" := ICOutboxSalesLine."IC Partner Ref. Type"::Item;
            ICOutBoxSalesLine2."IC Partner Reference" := SalesCrMemoLine."No.";
            ICOutBoxSalesLine2."Unit Price" := 0;
            ICOutBoxSalesLine2."Line Discount Amount" := 0;
            ICOutBoxSalesLine2."Amount Including VAT" := 0;
            ICOutBoxSalesLine2.Insert(true);

            ICDocDim."Transaction No." := ICOutBoxSalesHeader."IC Transaction No.";
            ICDocDim."IC Partner Code" := ICOutBoxSalesHeader."IC Partner Code";
            ICDocDim."Transaction Source" := ICOutBoxSalesHeader."Transaction Source";
            ICDocDim."Line No." := ICOutBoxSalesLine2."Line No.";

            ICInboxOutboxMgt.CreateICDocDimFromPostedDocDim(ICDocDim, SalesCrMemoLine."Dimension Set ID", Database::"IC Outbox Sales Line");
        end;
        //<< 04-02-21 ZY-LD 021
    end;
    #endregion

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateSalesDocumentOnBeforeSalesHeaderModify', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreateSalesDocumentOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header"; ICInboxSalesHeader: Record "IC Inbox Sales Header")
    begin
        SalesHeader."Ship-to Code" := ICInboxSalesHeader."Ship-to Code";  // 13-11-18 ZY-LD 013
        SalesHeader."eCommerce Order" := ICInboxSalesHeader."eCommerce Order";
        SalesHeader."Reference 2" := ICInboxSalesHeader."Your Reference 2";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchDocumentOnBeforeSetICDocDimFilters', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreatePurchDocumentOnBeforeSalesHeaderModify(var PurchHeader: Record "Purchase Header"; var ICInboxPurchHeader: Record "IC Inbox Purchase Header")
    var
        ICpartner: Record "IC Partner";
    begin
        //PurchHeader."Ship-to Country/Region Code" := "Ship-to Country/Region Code";  // 19-02-21 ZY-LD 021
        PurchHeader.Validate("Ship-to Country/Region Code", ICInboxPurchHeader."Ship-to Country/Region Code");  // 19-02-21 ZY-LD 021

        PurchHeader."Ship-to Contact" := ICInboxPurchHeader."Ship-to Contact";
        PurchHeader."Ship-to County" := ICInboxPurchHeader."Ship-to County";
        PurchHeader."Ship-to E-Mail" := ICInboxPurchHeader."Ship-to E-Mail";
        PurchHeader."Ship-to VAT" := ICInboxPurchHeader."Ship-to VAT";
        PurchHeader."eCommerce Order" := ICInboxPurchHeader."eCommerce Order";
        PurchHeader."Reference 2" := ICInboxPurchHeader."Your Reference 2";

        // 001: >>
        // 
        // #490743 >>
        if ICpartner.get(ICInboxPurchHeader."IC Partner Code") then;
        if not ICpartner.Skip_sellCustomer then begin
            // #490743 <<
            PurchHeader."End Customer" := ICInboxPurchHeader."End Customer";
            PurchHeader.Validate("Sell-to Customer No.", ICInboxPurchHeader."End Customer");  // 19-02-21 ZY-LD 021
                                                                                              // #490743 >>
        end;
        // #490743 <<
        // 001: <<
        //ZL111006B+
        if (PurchHeader."Document Type" in [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"]) and
           (ICInboxPurchHeader."Location Code" <> '')
        then begin
            //PurchHeader."Location Code":=ICInboxPurchHeader."Location Code";  // 19-02-21 ZY-LD 021
            PurchHeader.Validate("Location Code", ICInboxPurchHeader."Location Code");  // 19-02-21 ZY-LD 021
        end;
        //ZL111006B_
        //RD CZ 1.0
        //>> 24-10-17 ZY-LD 002
        //  ICLocation.SETFILTER("IC Company Name",CompanyName());
        //  IF ICLocation.FINDFIRST THEN BEGIN

        //     ICCompanyName:= ICLocation."IC Company Name";
        //     ICVendor1 := ICLocation."IC Vendor 1";
        //     ICVendor2 := ICLocation."IC Vendor 2";
        //     ICVendor3 := ICLocation."IC Vendor 3";
        //     ICVendor4 := ICLocation."IC Vendor 4";
        //     ICVendor5 := ICLocation."IC Vendor 5";
        //     ICVendor6 := ICLocation."IC Vendor 6";
        //     ICLocation1 := ICLocation."IC Location 1";
        //     ICLocation2 := ICLocation."IC Location 2";
        //     ICLocation3 := ICLocation."IC Location 3";
        //     ICLocation4 := ICLocation."IC Location 4";
        //     ICLocation5 := ICLocation."IC Location 5";
        //     ICLocation6 := ICLocation."IC Location 6";
        // 
        //     IF CompanyName() = ICCompanyName THEN BEGIN
        //       PurchHeader.SetHideValidationDialog(TRUE);
        //       IF PurchHeader."Location Code" = ICLocation1 THEN BEGIN
        //          PurchHeader.VALIDATE("Buy-from Vendor No.",ICVendor1);
        //       END;
        //       IF PurchHeader."Location Code" = ICLocation2 THEN BEGIN
        //          PurchHeader.VALIDATE("Buy-from Vendor No.",ICVendor2);
        //       END;
        //       IF  PurchHeader."Location Code" = ICLocation3 THEN BEGIN
        //           PurchHeader.VALIDATE("Buy-from Vendor No.",ICVendor3);
        //       END;
        //       IF  PurchHeader."Location Code" = ICLocation4 THEN BEGIN
        //           PurchHeader.VALIDATE("Buy-from Vendor No.",ICVendor4);
        //       END;
        //       IF  PurchHeader."Location Code" = ICLocation5 THEN BEGIN
        //           PurchHeader.VALIDATE("Buy-from Vendor No.",ICVendor5);
        //       END;
        // //       IF  PurchHeader."Location Code" = ICLocation6 THEN BEGIN
        // //           PurchHeader.VALIDATE("Buy-from Vendor No.",ICVendor6);
        // //       END;
        // //       PurchHeader.VALIDATE("Currency Code","Currency Code");  // 08-09-17 ZY-LD
        // 
        //       PurchHeader."Your Reference" := "Your Reference";
        //      
        // 
        //       PurchHeader."Location Code":=ICInboxPurchHeader."Location Code";
        // 
        //      
        //       PurchHeader."Ship-to VAT" := "Ship-to VAT";
        //       //PAB
        //       PurchHeader."eCommerce Order" := "eCommerce Order";
        //       PurchHeader."Reference 2" := "Your Reference 2";
        //     END;
        //  END;  
        //<< 24-10-17 ZY-LD 002
        //RD CZ 1.0
        //RD 4.0
        //>> 24-10-17 ZY-LD 002
        PurchHeader."Your Reference" := ICInboxPurchHeader."Your Reference";
        PurchHeader."Location Code" := ICInboxPurchHeader."Location Code";
        PurchHeader."Ship-to VAT" := ICInboxPurchHeader."Ship-to VAT";
        PurchHeader."eCommerce Order" := ICInboxPurchHeader."eCommerce Order";
        PurchHeader."Reference 2" := ICInboxPurchHeader."Your Reference 2";
        //<< 24-10-17 ZY-LD 002
        //>> 13-11-18 ZY-LD 013
        PurchHeader."Purchaser Code" := ICInboxPurchHeader."Salesperson Code";
        //>> 21-01-21 ZY-LD 021
        // IF ICInboxPurchHeader."End Customer" = '' THEN
        //     PurchHeader."On Hold" := COPYSTR(ICInboxPurchHeader."Salesperson Code", 1, MAXSTRLEN(PurchHeader."On Hold"));
        //<< 21-01-21 ZY-LD 021
        //<< 13-11-18 ZY-LD 013
        PurchHeader."VAT Bus. Posting Group" := ZyxelProof(ICInboxPurchHeader, PurchHeader);
        //RD 4.0
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchDocumentOnBeforeSetICDocDimFilters', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreatePurchDocumentOnBeforePurchHeaderModify(var PurchHeader: Record "Purchase Header"; var ICInboxPurchHeader: Record "IC Inbox Purchase Header")
    var
        ICDocDim: Record "IC Document Dimension";
        DimMgt: Codeunit DimensionManagement;
        DimensionSetIDArr: array[10] of Integer;
        CountryDimCode: Code[10];
    begin
        DimMgt.SetICDocDimFilters(
          ICDocDim, Database::"IC Inbox Purchase Header", ICInboxPurchHeader."IC Transaction No.",
          ICInboxPurchHeader."IC Partner Code", ICInboxPurchHeader."Transaction Source", 0);

        DimensionSetIDArr[1] := PurchHeader."Dimension Set ID";
        DimensionSetIDArr[2] := DimMgt.CreateDimSetIDFromICDocDim(ICDocDim);
        PurchHeader."Dimension Set ID" :=
            DimMgt.GetCombinedDimensionSetID(
            DimensionSetIDArr, PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code");
        DimMgt.UpdateGlobalDimFromDimSetID(
            PurchHeader."Dimension Set ID", PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code");


        DimensionSetIDArr[1] := PurchHeader."Dimension Set ID";
        DimensionSetIDArr[2] := DimMgt.CreateDimSetIDFromICDocDim(ICDocDim);

        //assumes remaining 8 elements are initialised to zero...
        PurchHeader."Dimension Set ID" :=
            DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr, PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code");

        //>> 12-02-18 ZY-LD 006
        CountryDimCode := GetCountryDimension(PurchHeader."Buy-from Vendor No.", PurchHeader."Location Code", PurchHeader."Sell-to Customer No.");
        if CountryDimCode <> '' then
            PurchHeader.ValidateShortcutDimCode(3, CountryDimCode);
        //<< 12-02-18 ZY-LD 006

        PurchHeader."Shipment Method Code" := ICInboxPurchHeader."Shipment Method Code";  // 10-07-20 ZY-LD 019
        PurchHeader."VAT Registration No." := ICInboxPurchHeader."VAT Registration No.";  // 21-01-21 ZY-LD 021
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnAfterCreatePurchDocument', '', false, false)]
    local procedure ICInboxOutboxMgt_OnAfterCreatePurchDocument(var PurchaseHeader: Record "Purchase Header"; ICInboxPurchaseHeader: Record "IC Inbox Purchase Header"; HandledICInboxPurchHeader: Record "Handled IC Inbox Purch. Header")
    var
        Vend: Record Vendor;
        ICSetup: Record "IC Setup";
        PurchLine: Record "Purchase Line";
        autosetup: Record "Automation Setup";

    begin
        //>> 29-05-24 ZY-LD 050
        if Vend.get(PurchaseHeader."Buy-from Vendor No.") and Vend."Sample Vendor" then begin
            ICSetup.get;
            ICSetup.TestField("Sample Item");
            PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchLine.SetRange("Document No.", PurchaseHeader."No.");
            PurchLine.SetRange(Type, PurchLine.Type::Item);
            if PurchLine.FindSet() then
                repeat
                    PurchLine.TestField(PurchLine."No.", ICSetup."Sample Item");
                    PurchLine.TestField(PurchLine."Original No.");
                until PurchLine.Next() = 0;
        end;
        //<< 29-05-24 ZY-LD 050

        // 001: >>
        // 003: >>

        //fnSync.CreateSale(PurchHeader);

        PurchaseHeader."Ship-to Code" := ICInboxPurchaseHeader."Ship-to Code";  // 11-03-24 ZY-LD 013
        CreateSale(
          PurchaseHeader,
          ICInboxPurchaseHeader."Sales Order Type",
          ICInboxPurchaseHeader."Salesperson Code",  // 20-03-18 ZY-LD 008
          ICInboxPurchaseHeader."Currency Code Sales Doc SUB");  // 09-12-19 ZY-LD 018
                                                                 // 003: <<
                                                                 // 001: <<


        // CreateContainie, if vendor+automatis >>
        autosetup.get();
        if vend.CreateContanieInternal and autosetup.CreateContanieInternal and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) then begin
            PurchaseHeader.CreatecontainerfromPurchaseInv(PurchaseHeader);
        end;
        // CreateContainie, if vendor+automatis <<



    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeOutboxSalesHdrToInbox', '', false, false)]
    local procedure ICInboxOutboxMgt_OnBeforeOutboxSalesHdrToInbox(var ICInboxTrans: Record "IC Inbox Transaction"; var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; var ICInboxPurchHeader: Record "IC Inbox Purchase Header"; var ICPartner: Record "IC Partner"; var IsHandled: Boolean)
    var
        ICSetup: Record "IC Setup";
        Vendor: Record Vendor;
        ZyWsReq: Codeunit "Zyxel Web Service Request";
        VendorNoSub: Code[20];
        TypeErr: Label '"%1" must be "%2" or "%3".';
        ICPartnerErr: Label '%1 %2 does not exist as a %3 in %1 %4.';
        NotCreatedOrVendorMissingErr: Label '"%1" %2 is not created in %3, or "Vendor No." is missing.';
    begin
        ICSetup.Get();
        if ICOutboxSalesHeader."IC Partner Code" = ICSetup."IC Partner Code" then
            ICPartner.Get(ICInboxTrans."IC Partner Code")
        else begin
            ICPartner.Get(ICOutboxSalesHeader."IC Partner Code");
            //>> 19-06-18
            //ICPartner.TESTFIELD("Inbox Type",ICPartner."Inbox Type"::Database);
            if (ICPartner."Inbox Type" <> ICPartner."Inbox Type"::Database) and (ICPartner."Inbox Type" <> ICPartner."Inbox Type"::"Web Service") then
                Error(ICPartnerErr, ICPartner.FieldCaption("Inbox Type"), ICPartner."Inbox Type"::Database, ICPartner."Inbox Type"::"Web Service");
            //<< 19-06-18
            ICPartner.TestField("Inbox Details");
            if ICPartner."Inbox Type" = ICPartner."Inbox Type"::"Web Service" then begin
                VendorNoSub := ZyWsReq.ICPartnerExistsInSub(ICPartner."Inbox Details", ICInboxTrans."IC Partner Code");
                if VendorNoSub <> '' then
                    ICPartner."Vendor No." := VendorNoSub
                else
                    Error(NotCreatedOrVendorMissingErr, ICPartner.TableCaption(), ICInboxTrans."IC Partner Code", ICPartner."Inbox Details");
            end else begin
                ICPartner.ChangeCompany(ICPartner."Inbox Details");
                ICPartner.Get(ICInboxTrans."IC Partner Code");
            end;
        end;

        if ICPartner."Vendor No." = '' then
            Error(ICPartnerErr, ICPartner.TableCaption(), ICPartner.Code, Vendor.TableCaption(), ICOutboxSalesHeader."IC Partner Code");

        ICInboxPurchHeader."IC Transaction No." := ICInboxTrans."Transaction No.";
        ICInboxPurchHeader."IC Partner Code" := ICInboxTrans."IC Partner Code";
        ICInboxPurchHeader."Transaction Source" := ICInboxTrans."Transaction Source";
        ICInboxPurchHeader."Document Type" := ICOutboxSalesHeader."Document Type";
        ICInboxPurchHeader."No." := ICOutboxSalesHeader."No.";
        ICInboxPurchHeader."Ship-to Name" := ICOutboxSalesHeader."Ship-to Name";
        ICInboxPurchHeader."Ship-to Address" := ICOutboxSalesHeader."Ship-to Address";
        ICInboxPurchHeader."Ship-to Address 2" := ICOutboxSalesHeader."Ship-to Address 2";
        ICInboxPurchHeader."Ship-to City" := ICOutboxSalesHeader."Ship-to City";
        ICInboxPurchHeader."Ship-to Post Code" := ICOutboxSalesHeader."Ship-to Post Code";
        ICInboxPurchHeader."Ship-to County" := ICOutboxSalesHeader."Ship-to County";
        ICInboxPurchHeader."Ship-to Country/Region Code" := ICOutboxSalesHeader."Ship-to Country/Region Code";
        ICInboxPurchHeader."Posting Date" := ICOutboxSalesHeader."Posting Date";
        ICInboxPurchHeader."Due Date" := ICOutboxSalesHeader."Due Date";
        ICInboxPurchHeader."Payment Discount %" := ICOutboxSalesHeader."Payment Discount %";
        ICInboxPurchHeader."Pmt. Discount Date" := ICOutboxSalesHeader."Pmt. Discount Date";
        ICInboxPurchHeader."Currency Code" := ICOutboxSalesHeader."Currency Code";
        ICInboxPurchHeader."Document Date" := ICOutboxSalesHeader."Document Date";
        ICInboxPurchHeader."Buy-from Vendor No." := ICPartner."Vendor No.";
        ICInboxPurchHeader."Pay-to Vendor No." := ICPartner."Vendor No.";
        ICInboxPurchHeader."Vendor Invoice No." := ICOutboxSalesHeader."No.";
        ICInboxPurchHeader."Vendor Order No." := ICOutboxSalesHeader."Order No.";
        ICInboxPurchHeader."Vendor Cr. Memo No." := ICOutboxSalesHeader."No.";
        ICInboxPurchHeader."Your Reference" := ICOutboxSalesHeader."External Document No.";
        ICInboxPurchHeader."Sell-to Customer No." := ICOutboxSalesHeader."Sell-to Customer No.";
        ICInboxPurchHeader."Expected Receipt Date" := ICOutboxSalesHeader."Requested Delivery Date";
        ICInboxPurchHeader."Requested Receipt Date" := ICOutboxSalesHeader."Requested Delivery Date";
        ICInboxPurchHeader."Promised Receipt Date" := ICOutboxSalesHeader."Promised Delivery Date";
        ICInboxPurchHeader."Prices Including VAT" := ICOutboxSalesHeader."Prices Including VAT";
        // 001: >>
        ICInboxPurchHeader."End Customer" := ICOutboxSalesHeader."End Customer";
        // 001: <<
        // 004: >>
        ICInboxPurchHeader."Sales Order Type" := ICOutboxSalesHeader."Sales Order Type";
        // 004: <<
        //ZL111006B+
        if (ICOutboxSalesHeader."Document Type" in [ICOutboxSalesHeader."Document Type"::Invoice, ICOutboxSalesHeader."Document Type"::"Credit Memo"]) then
            ICInboxPurchHeader."Location Code" := ICOutboxSalesHeader."Location Code";
        //ZL111006B-
        ICInboxPurchHeader."Ship-to Name 2" := ICOutboxSalesHeader."Ship-to Name 2";
        ICInboxPurchHeader."Ship-to Address 2" := ICOutboxSalesHeader."Ship-to Address 2";
        ICInboxPurchHeader."Ship-to Post Code" := ICOutboxSalesHeader."Ship-to Post Code";
        ICInboxPurchHeader."Ship-to Country/Region Code" := ICOutboxSalesHeader."Ship-to Country/Region Code";
        ICInboxPurchHeader."Ship-to Contact" := ICOutboxSalesHeader."Ship-to Contact";
        ICInboxPurchHeader."Ship-to County" := ICOutboxSalesHeader."Ship-to County";
        ICInboxPurchHeader."Ship-to E-Mail" := ICOutboxSalesHeader."Ship-to E-Mail";
        ICInboxPurchHeader."Ship-to VAT" := ICOutboxSalesHeader."Ship-to VAT";
        ICInboxPurchHeader."eCommerce Order" := ICOutboxSalesHeader."eCommerce Order";
        ICInboxPurchHeader."Your Reference 2" := ICOutboxSalesHeader."Your Reference 2";
        ICInboxPurchHeader."Salesperson Code" := ICOutboxSalesHeader."Salesperson Code";
        // 20-03-18 ZY-LD 008
        ICInboxPurchHeader."Ship-to Code" := ICOutboxSalesHeader."Ship-to Code";
        // 09-10-18 ZY-LD 011 
        ICInboxPurchHeader."Order Date" := ICOutboxSalesHeader."Order Date";
        // 18-12-18 ZY-LD 014
        ICInboxPurchHeader."E-Invoice Comment" := ICOutboxSalesHeader."E-Invoice Comment";
        // 01-02-19 ZY-LD 015
        ICInboxPurchHeader."Currency Code Sales Doc SUB" := ICOutboxSalesHeader."Currency Code Sales Doc SUB";
        // 09-12-19 ZY-LD 
        ICInboxPurchHeader."Shipment Method Code" := ICOutboxSalesHeader."Shipment Method Code";
        // 10-07-20 ZY-LD 019
        ICInboxPurchHeader."VAT Registration No." := ICOutboxSalesHeader."VAT Registration No.";
        // 21-02-21 ZY-LD 021
        ICInboxPurchHeader.Insert();

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeICInboxPurchLineInsert', '', false, false)]
    local procedure ICInboxOutboxMgt_OnBeforeICInboxPurchLineInsert(var ICInboxPurchaseLine: Record "IC Inbox Purchase Line"; ICOutboxSalesLine: Record "IC Outbox Sales Line")
    var
        ICOutboxSalesHeader: Record "IC Outbox Sales Header";
        ICPartner: Record "IC Partner";
    begin
        //>> 18-06-18
        ICOutboxSalesHeader.Get(ICOutboxSalesLine."IC Transaction No.", ICOutboxSalesLine."IC Partner Code", ICOutboxSalesLine."Transaction Source");
        ICPartner.Get(ICOutboxSalesHeader."IC Partner Code");
        //<< 18-06-18

        // 002: >>
        ICInboxPurchaseLine."External Document No." := ICOutboxSalesLine."External Document No.";
        // 002: <<
        //Modified By Craig on 20110812+
        ICInboxPurchaseLine."Picking List No." := ICOutboxSalesLine."Picking List No.";
        ICInboxPurchaseLine."Packing List No." := ICOutboxSalesLine."Packing List No.";
        //Modified By Craig on 20110812-
        //ZL111005C+
        ICInboxPurchaseLine."Hide Line" := ICOutboxSalesLine."Hide Line";
        //ZL111005C-
        //ZL111006B+
        if (ICOutboxSalesLine."Document Type" in [ICOutboxSalesLine."Document Type"::Invoice, ICOutboxSalesLine."Document Type"::"Credit Memo"]) then begin
            ICInboxPurchaseLine."Location Code" := ICOutboxSalesLine."Location Code";
            //RD 31/01/13
            ICInboxPurchaseLine."Return Reason Code" := ICOutboxSalesLine."Return Reason Code";
            // RD 3.0
            ICInboxPurchaseLine."Gen. Prod. Posting Group" := ICOutboxSalesLine."Gen. Prod. Posting Group";
            // RD 3.0
        end;
        //ZL111006B-
        ICInboxPurchaseLine."IC Payment Terms" := ICOutboxSalesLine."IC Payment Terms";  // 20-09-18 ZY-LD 010
        ICInboxPurchaseLine."External Document Position No." := ICOutboxSalesLine."External Document Position No.";  // 04-08-21 ZY-LD 022
        ICInboxPurchaseLine."VAT Prod. Posting Group" := ICOutboxSalesLine."VAT Prod. Posting Group";  // 30-11-21 ZY-LD 028
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeICInboxSalesHeaderInsert', '', false, false)]
    local procedure OnBeforeICInboxSalesHeaderInsert(var ICInboxSalesHeader: Record "IC Inbox Sales Header"; ICOutboxPurchaseHeader: Record "IC Outbox Purchase Header")
    begin
        ICInboxSalesHeader."Ship-to Contact" := ICOutboxPurchaseHeader."Ship-to Contact";
        ICInboxSalesHeader."Ship-to County" := ICOutboxPurchaseHeader."Ship-to County";
        ICInboxSalesHeader."Ship-to E-Mail" := ICOutboxPurchaseHeader."Ship-to E-Mail";
        ICInboxSalesHeader."Ship-to VAT" := ICOutboxPurchaseHeader."Ship-to VAT";
        ICInboxSalesHeader."eCommerce Order" := ICOutboxPurchaseHeader."eCommerce Order";
        ICInboxSalesHeader."Your Reference 2" := ICOutboxPurchaseHeader."Your Reference 2";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchLinesOnAfterValidateNo', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreatePurchLinesOnAfterValidateNo(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; ICInboxPurchaseLine: Record "IC Inbox Purchase Line")
    var
        Vend: Record Vendor;
        ICSetup: Record "IC Setup";
        SaveItemNo: Code[20];
    begin
        if PurchaseLine.Type = PurchaseLine.Type::Item then begin
            Vend.get(PurchaseHeader."Buy-from Vendor No.");
            if Vend."Sample Vendor" then begin
                ICSetup.get;
                ICSetup.TestField("Sample Item");
                SaveItemNo := PurchaseLine."No.";
                PurchaseLine.Validate("No.", ICSetup."Sample Item");
                PurchaseLine."Original No." := SaveItemNo;
            end;
        end;

        //ZL111006B+
        if (PurchaseLine."Document Type" in [PurchaseLine."Document Type"::Invoice, PurchaseLine."Document Type"::"Credit Memo"]) then begin
            PurchaseLine.Validate("Location Code", ICInboxPurchaseLine."Location Code");
            //RD 31/01/13
            PurchaseLine."Return Reason Code" := ICInboxPurchaseLine."Return Reason Code";
            // RD 3.0
            PurchaseLine."Gen. Prod. Posting Group" := ICInboxPurchaseLine."Gen. Prod. Posting Group";
            // RD 3.0
            //>> 30-11-21 ZY-LD 028
            if ICInboxPurchaseLine."VAT Prod. Posting Group" <> '' then
                PurchaseLine.Validate("VAT Prod. Posting Group", ICInboxPurchaseLine."VAT Prod. Posting Group");
            //<< 30-11-21 ZY-LD 028
        end;
        //ZL111006B-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchLinesOnAfterAssignPurchLineFields', '', false, false)]
    local procedure ICInboxOutboxMgt_OnCreatePurchLinesOnAfterAssignPurchLineFields(var PurchaseLine: Record "Purchase Line"; ICInboxPurchLine: Record "IC Inbox Purchase Line"; var PurchHeader: Record "Purchase Header")
    begin
        // 002: >>
        PurchaseLine."External Document No." := ICInboxPurchLine."External Document No.";
        // 002: <<
        //Modified By Craig on 20110812+
        PurchaseLine."Picking List No." := ICInboxPurchLine."Picking List No.";
        PurchaseLine."Packing List No." := ICInboxPurchLine."Packing List No.";
        //Modified By Craig on 20110812-
        //ZL111005C+
        PurchaseLine."Hide Line" := ICInboxPurchLine."Hide Line";
        //ZL111005C-
        PurchaseLine.Description := ICInboxPurchLine.Description;  // 17-01-18 ZY-LD 005   
        PurchaseLine."External Document Position No." := ICInboxPurchLine."External Document Position No.";  // 04-08-21 ZY-LD 022
        if PurchaseLine.Insert(true) then;
    end;

    #region IC Helpers
    local procedure CreateSale(pPurch: Record "Purchase Header"; pOrderType: Option " ",Normal,EICard,"Drop Shipment",Other; pSalesPersonCode: Code[20]; pCurrencyCode: Code[10])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        CurrExchRates: Record "Currency Exchange Rate";
        ICLocation: Record "IC Vendors";
        recCust: Record Customer;
        DimMgt: Codeunit DimensionManagement;
        ICCompanyName: Text[30];
        ICVatBusinessCode1: Code[10];
        ShortcutDimCode: Array[8] of Code[20];
        eCommerceInvoiceNo: Text[50];
        SI: Codeunit "Single Instance";
        GlDimCode: Code[20];
    begin
        if (pPurch."End Customer" = '') or
           (not recCust.Get(pPurch."End Customer"))  // 10-12-20 ZY-LD 010
        then
            exit;

        SI.SetKeepLocationCode(true);
        SalesHeader.Init();
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader."Document Type" := pPurch."Document Type";
        //PAB
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            if SalesHeader."Currency Factor" = 0 then SalesHeader."Currency Factor" := 1;
        eCommerceInvoiceNo := pPurch."Your Reference";
        eCommerceInvoiceNo := ReplaceString(eCommerceInvoiceNo, 'INV-GB-', '');
        eCommerceInvoiceNo := ReplaceString(eCommerceInvoiceNo, 'INV-DE-', '');
        eCommerceInvoiceNo := ReplaceString(eCommerceInvoiceNo, 'INV-IT-', '');
        eCommerceInvoiceNo := ReplaceString(eCommerceInvoiceNo, 'CN-GB-', '');
        eCommerceInvoiceNo := ReplaceString(eCommerceInvoiceNo, 'CN-DE-', '');
        eCommerceInvoiceNo := ReplaceString(eCommerceInvoiceNo, 'CN-IT-', '');
        //>> 19-12-17 ZY-LD 002
        // {
        // IF pPurch."eCommerce Order" THEN
        //             SalesHeader."No." := eCommerceInvoiceNo;
        //         IF NOT pPurch."eCommerce Order" THEN
        //             SalesHeader."No." := '';
        // }
        //<< 19-12-17 ZY-LD 002
        SalesHeader."No." := '';
        if pPurch."eCommerce Order" then SalesHeader."Your Reference" := pPurch."Reference 2";
        SalesHeader."eCommerce Order" := pPurch."eCommerce Order";
        SalesHeader.SetRange("Sell-to Customer No.", pPurch."End Customer");
        SalesHeader.Insert(true);
        SalesHeader.Validate("Order Date", pPurch."Order Date");
        SalesHeader.Validate("Shipment Date", pPurch."Expected Receipt Date");
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::"Credit Memo"] then begin
            SalesHeader."External Document No." := pPurch."Vendor Cr. Memo No.";
            SalesHeader."Skip Posting Group Validation" := true;  // 11-01-21 ZY-LD 025
        end else
            SalesHeader."External Document No." := pPurch."Vendor Invoice No.";
        //RD 1.0

        // 006: >>
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] then
            SalesHeader.Validate("Sales Order Type", pOrderType);
        // 006: <<

        // 007: >>
        SalesHeader.Validate(SalesHeader."Location Code", pPurch."Location Code");
        // 007: <<

        //>> 09-04-24 ZY-LD 016
        /*SalesHeader."Ship-to Code" := pPurch."Ship-to Code";
        SalesHeader."Ship-to Name" := pPurch."Ship-to Name";
        SalesHeader."Ship-to Name 2" := pPurch."Ship-to Name 2";
        SalesHeader."Ship-to Address" := pPurch."Ship-to Address";
        SalesHeader."Ship-to Address 2" := pPurch."Ship-to Address 2";
        SalesHeader."Ship-to City" := pPurch."Ship-to City";
        SalesHeader."Ship-to Contact" := pPurch."Ship-to Contact";
        SalesHeader."Ship-to Post Code" := pPurch."Ship-to Post Code";
        SalesHeader."Ship-to County" := pPurch."Ship-to County";
        //SalesHeader."Ship-to Country/Region Code" := pPurch."Ship-to Country/Region Code";
        SalesHeader.Validate("Ship-to Country/Region Code", pPurch."Ship-to Country/Region Code");
        SalesHeader."Ship-to E-Mail" := pPurch."Ship-to E-Mail";
        //>> 18-08-21 ZY-LD 023
        //SalesHeader."Ship-to VAT" := pPurch."Ship-to VAT";
        if pPurch."Ship-to VAT" <> '' then
            SalesHeader.Validate("VAT Registration No.", pPurch."Ship-to VAT");
        //<< 18-08-21 ZY-LD 023
        SalesHeader."Ship-to Contact" := pPurch."Ship-to Contact";
        SalesHeader."Ship-to Code" := pPurch."Ship-to Code";  // 13-11-18 ZY-LD 005*/

        SalesHeader.Validate("Ship-to Code", pPurch."Ship-to Code");
        SalesHeader.Validate("Shipment Date", pPurch."Expected Receipt Date");
        if pPurch."Ship-to VAT" <> '' then
            SalesHeader.Validate("VAT Registration No.", pPurch."Ship-to VAT");
        //<< 09-04-24 ZY-LD 016

        SalesHeader."Shipment Method Code" := pPurch."Shipment Method Code";  // 10-07-20 ZY-LD 008
                                                                              //Modified By Craig on 20110819+
        SalesHeader."RHQ Invoice No" := pPurch."Vendor Invoice No.";
        //Modified By Craig on 20110819-
        SalesHeader."RHQ Credit Memo No" := pPurch."Vendor Cr. Memo No.";  // 006:
        SalesHeader."Your Reference" := pPurch."Your Reference";  // 15-09-21 ZY-LD 024

        //RD 4.0
        if (SalesHeader."Location Code" = 'EICARD') and (SalesHeader."Gen. Bus. Posting Group" = 'EU') then begin
            if ICLocation.FindFirst() then begin

                ICCompanyName := ICLocation."IC Company Name";
                ICVatBusinessCode1 := ICLocation."VAT Bus.Posting Group Rev";

                if ICLocation."Sub Yes/No" = true then begin
                    if CompanyName() = ICCompanyName then begin
                        SalesHeader.SetHideValidationDialog(true);
                        if (SalesHeader."VAT Bus. Posting Group" <> ICVatBusinessCode1)
                           and (ICVatBusinessCode1 <> '') then
                            SalesHeader.Validate(SalesHeader."VAT Bus. Posting Group", ICVatBusinessCode1);
                    end;
                end;
            end;
        end;

        //RD 4.0

        //SalesHeader.VALIDATE("Currency Code",pPurch."Currency Code");  // 12-09-17 ZY-LD 001  // 26-09-19 ZY-LD 006
        //>> 09-12-19 ZY-LD 
        if pCurrencyCode <> '' then
            SalesHeader.Validate("Currency Code", pCurrencyCode);
        SalesHeader."Salesperson Code" := pSalesPersonCode;  // 20-03-18 ZY-LD 004 
        SalesHeader.Modify();
        SI.SetKeepLocationCode(true);

        PurchLine.SetRange("Document Type", pPurch."Document Type");
        PurchLine.SetRange("Document No.", pPurch."No.");
        if PurchLine.FindSet(true) then
            repeat
                SalesLine.Init();
                SalesLine.SetHideValidationDialog(true);
                SalesLine.SuspendStatusCheck(true);
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." += 10000;
                SalesLine.Insert(true);
                SalesLine.Type := PurchLine.Type;
                if PurchLine.Type <> PurchLine.Type::" " then begin
                    SalesLine.Validate(SalesLine."No.", PurchLine."No.");
                    if PurchLine."Return Reason Code" <> '' then  // 02-09-20 ZY-LD 009
                        SalesLine.Validate("Gen. Prod. Posting Group", PurchLine."Gen. Prod. Posting Group");  // 02-09-20 ZY-LD 009
                    SalesLine.Validate(SalesLine.Quantity, PurchLine.Quantity);
                    SalesLine.Validate(SalesLine."Unit of Measure Code", PurchLine."Unit of Measure Code");
                    if SalesHeader."Order Date" = 0D then
                        SalesHeader."Order Date" := SalesHeader."Posting Date";
                    SalesLine.Validate(SalesLine."Unit Price", CurrExchRates.ExchangeAmtFCYToFCY(SalesHeader."Order Date",
                                                               PurchLine."Currency Code", SalesLine."Currency Code",
                                                               PurchLine."Direct Unit Cost"));
                    SalesLine.Description := PurchLine.Description;  // 17-01-18 ZY-LD 003
                end else begin
                    SalesLine.Description := PurchLine.Description;
                    SalesLine."Description 2" := PurchLine."Description 2";
                end;
                //ZL111006B+
                if (SalesLine."Document Type" in [SalesLine."Document Type"::Invoice,
                                                  SalesLine."Document Type"::"Credit Memo"]) then begin
                    SalesLine.Validate("Location Code", PurchLine."Location Code");

                    //RD 31.01.13

                    SalesLine."Return Reason Code" := PurchLine."Return Reason Code";
                    // RD 3.0
                    SalesLine."Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
                    // RD 3.0
                end;
                //ZL111006B-
                //RD 1.0
                if SalesLine.Type <> SalesLine.Type::"G/L Account" then begin

                    SalesLine."Special Order" := true;
                    SalesLine."Special Order Purchase No." := pPurch."No.";
                    SalesLine."Special Order Purch. Line No." := PurchLine."Line No.";
                    SalesLine."External Document No." := PurchLine."External Document No.";
                end else begin
                    //>> 13-01-21 ZY-LD 029
                    DimMgt.GetShortcutDimensions(PurchLine."Dimension Set ID", ShortcutDimCode);
                    //if ShortcutDimCode[5] <> '' then
                    //    SalesLine.ValidateShortcutDimCode(5, ShortcutDimCode[5]); //20-05-2025 BK #480077
                    //<< 13-01-21 ZY-LD 029

                    //>> 01-12-22 ZY-LD 031
                    if SalesHeader."eCommerce Order" then begin
                        GlDimCode := GetGlAccDimension(2, SalesLine."No.");
                        if GlDimCode <> '' then
                            SalesLine.ValidateShortcutDimCode(2, GlDimCode);
                    end;
                    //<< 01-12-22 ZY-LD 031

                    SalesLine."External Document No." := PurchLine."External Document No.";  // 04-10-22 ZY-LD 030
                end;
                //RD 1.0
                //Modified By Craig on 20110812+
                SalesLine."Picking List No." := PurchLine."Picking List No.";
                SalesLine."Packing List No." := PurchLine."Packing List No.";
                //Modified By Craig on 20110812-
                //ZL111005C+
                SalesLine."Hide Line" := PurchLine."Hide Line";
                //ZL111005C-
                SalesLine."External Document Position No." := PurchLine."External Document Position No.";  // 04-08-21 ZY-LD 022
                SalesLine."Skip Posting Group Validation" := SalesHeader."Skip Posting Group Validation";  // 11-01-21 ZY-LD 025
                SalesLine.Modify();

                PurchLine."Special Order" := true;
                PurchLine."Special Order Sales No." := SalesHeader."No.";
                PurchLine."Special Order Sales Line No." := SalesLine."Line No.";
                PurchLine.Modify();
            until PurchLine.Next() = 0;
    end;

    local procedure GetLocationCode(pCountryRegionCode: Code[10]; pLocationCode: Code[10]; pCustomerNo: Code[20]) rValue: Code[10]
    var
        recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        //>> 21-01-21 ZY-LD 021
        rValue := pLocationCode;
        //>> 29-10-21 ZY-LD 026
        // recCustPostGrpSetup.SETRANGE("Country/Region Code", pCountryRegionCode);
        //         recCustPostGrpSetup.SETRANGE("Location Code", pLocationCode);
        //         recCustPostGrpSetup.SETFILTER("Customer No.", '%1|%2', pCustomerNo, '');
        //         IF recCustPostGrpSetup.FINDLAST AND (recCustPostGrpSetup."Location Code in SUB" <> '') THEN
        //             rValue := recCustPostGrpSetup."Location Code in SUB";

        recCustPostGrpSetup.SetFilter("Country/Region Code", '%1|%2', pCountryRegionCode, '');
        recCustPostGrpSetup.SetRange("Location Code", pLocationCode);
        recCustPostGrpSetup.SetFilter("Customer No.", '%1|%2', pCustomerNo, '');
        recCustPostGrpSetup.SetFilter("Location Code in SUB", '<>%1', '');
        if recCustPostGrpSetup.FindLast() then
            rValue := recCustPostGrpSetup."Location Code in SUB";
        //<< 29-10-21 ZY-LD 026

        //>> 07-11-17 ZY-LD 002
        // lBilltoCustprLocation.SETRANGE("Bill-to Country/Region Code", pCountryRegionCode);
        // lBilltoCustprLocation.SETRANGE("Location Code", pLocationCode);
        // lBilltoCustprLocation.SETRANGE("Customer No.", pCustomerNo);
        // IF lBilltoCustprLocation.FINDFIRST AND (lBilltoCustprLocation."Location Code in SUB" <> '') THEN
        //     EXIT(lBilltoCustprLocation."Location Code in SUB")
        // ELSE
        //     EXIT(pLocationCode);
        //<< 07-11-17 ZY-LD 002
        //<< 21-01-21 ZY-LD 021
    end;

    local procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]) NewString: Text[250]
    begin
        while StrPos(String, FindWhat) > 0 do
            String := DELSTR(String, StrPos(String, FindWhat)) + ReplaceWith + CopyStr(String, StrPos(String, FindWhat) + StrLen(FindWhat));
        NewString := String;
    end;

    local procedure ZyxelProof(ICInboxPurchHeader: Record "IC Inbox Purchase Header"; var recPurchaseHeader: Record "Purchase Header") VATCode: Code[10]
    var
        ICVATGenBusCode: Code[10];
        ICVATCode3P: Code[10];
        ICVATCodeReverse: Code[10];
        ICLocation: Record "IC Vendors";
        ICCompanyName: Text[30];
        recCustomer: Record Customer;
    begin
        VATCode := recPurchaseHeader."VAT Bus. Posting Group";
        if recCustomer.Get(ICInboxPurchHeader."End Customer") then begin
            if (recPurchaseHeader."Location Code" = 'EU2') or (recPurchaseHeader."Location Code" = 'SELLDE') then begin
                if ICLocation.FindFirst() then begin
                    ICCompanyName := ICLocation."IC Company Name";
                    ICVATGenBusCode := ICLocation."Gen.Bus.Posting Group";
                    ICVATCode3P := ICLocation."VAT Bus.Posting Group 3P";
                    ICVATCodeReverse := ICLocation."VAT Bus.Posting Group Rev";

                    if ICLocation."Sub Yes/No" = true then begin
                        if CompanyName() = ICCompanyName then begin
                            recPurchaseHeader.SetHideValidationDialog(true);
                            if (recCustomer."Gen. Bus. Posting Group" = ICVATGenBusCode) and
                               (recPurchaseHeader."VAT Bus. Posting Group" <> ICVATCode3P) and
                               (ICVATCode3P <> '') then
                                VATCode := ICVATCode3P;
                            if (recCustomer."Gen. Bus. Posting Group" <> ICVATGenBusCode) and
                               (recPurchaseHeader."VAT Bus. Posting Group" <> ICVATCodeReverse) and
                               (ICVATCodeReverse <> '') then
                                VATCode := ICVATCodeReverse;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure GetCountryDimension(pByFromVendorNo: Code[20]; pLocationCode: Code[10]; pSellToCustNo: Code[20]): Code[10]
    var
        recLocation: Record Location;
    begin
        //>> 25-02-21 ZY-LD 021
        recLocation.Get(pLocationCode);
        exit(recLocation."Dimension Country Code");

        //>> 12-02-18 ZY-LD 006
        // recVendprLocSetup.SETRANGE("Ship-to Country/Region Code", pByFromVendorNo);
        // recVendprLocSetup.SETRANGE("Location Code", pLocationCode);
        // recVendprLocSetup.SETFILTER("Sell-to Customer No.", '%1|%2', pSellToCustNo, '');
        // IF recVendprLocSetup.FINDLAST AND (recVendprLocSetup."Country Code" <> '') THEN
        //     EXIT(recVendprLocSetup."Country Code");
        //<< 12-02-18 ZY-LD 006
        //<< 25-02-21 ZY-LD 021
    end;

    local procedure GetGlAccDimension(pDimCodeNo: Integer; pGlAcc: Code[20]) rValue: Code[20]
    var
        recDefDim: Record "Default Dimension";
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        recGenLedgSetup.Get();
        recDefDim.SetRange("Table ID", Database::"G/L Account");
        recDefDim.SetRange("No.", pGlAcc);
        case pDimCodeNo of
            2:
                recDefDim.SetRange("Dimension Code", recGenLedgSetup."Global Dimension 2 Code");
        end;
        recDefDim.SetRange("Value Posting", recDefDim."Value Posting"::"Same Code");
        if recDefDim.FindFirst() then
            rValue := recDefDim."Dimension Value Code";
    end;
    #endregion

    #region Intercompany
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IC Outbox Export", 'OnRunOutboxTransactionsOnBeforeSend', '', false, false)]
    local procedure ICOutboxExport_OnRunOutboxTransactionsOnBeforeSend(var ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        Company: Record Company;
        ICPartner: Record "IC Partner";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        MoveICTransToPartnerCompany: Report "Move IC Trans. to Pa. Comp ZX";
    begin
        if ICOutboxTransaction.Find('-') then
            repeat
                ICPartner.Get(ICOutboxTransaction."IC Partner Code");
                ICPartner.TestField(Blocked, false);
                if ICPartner."Inbox Type" = ICPartner."Inbox Type"::"Web Service" then begin
                    ICPartner.TestField("Inbox Details");
                    Company.Get(ICPartner."Inbox Details");
                    ICOutboxTransaction.SetRange("Transaction No.", ICOutboxTransaction."Transaction No.");
                    MoveICTransToPartnerCompany.SetTableView(ICOutboxTransaction);
                    MoveICTransToPartnerCompany.UseRequestPage := false;
                    MoveICTransToPartnerCompany.Run();
                    ICOutboxTransaction.SetRange("Transaction No.");
                    if ICOutboxTransaction."Line Action" = ICOutboxTransaction."Line Action"::"Send to IC Partner" then
                        ICInboxOutboxMgt.MoveOutboxTransToHandledOutbox(ICOutboxTransaction);
                end;
            until ICOutboxTransaction.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IC Outbox Export", 'OnBeforeSendToExternalPartner', '', false, false)]
    local procedure ICOutboxExport_OnBeforeSendToExternalPartner(var ICOutboxTransaction: Record "IC Outbox Transaction"; var IsHandled: Boolean)
    var
        ICSetup: Record "IC Setup";
        ICPartner: Record "IC Partner";
        EmailItem: Record "Email Item";
        MailHandler: Codeunit Mail;
        DocumentMailing: Codeunit "Document-Mailing";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        InStream: InStream;
        OFile: File;
        FileName: Text;
        ICPartnerFilter: Text[1024];
        i: Integer;
        ToName: Text[100];
        CcName: Text[100];
        OutFileName: Text;
        SourceTableIDs, SourceRelationTypes : List of [Integer];
        SourceIDs: List of [Guid];
        ICOutboxExport: Codeunit "IC Outbox Export";
        FolderPathMissingErr: Label 'Folder Path must have a value in IC Partner: Code=%1. It cannot be zero or empty.', Comment = '%1=Intercompany Code';
        EmailAddressMissingErr: Label 'Email Address must have a value in IC Partner: Code=%1. It cannot be zero or empty.', Comment = '%1=Intercompany Code';
        Text001: Label 'Intercompany transactions from %1.';
        Text002: Label 'Attached to this mail is an xml file containing one or more intercompany transactions from %1 (%2 %3).';
        FileMgt: Codeunit "File Management";
        CompanyInfo: Record "Company Information";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
    begin
        //Copy of SendToExternalPartner from Codeunit IC Outbox Export
        if GenJnlPostPreview.IsActive() then
            exit;

        //>> 19-06-18 ZY-LD 001
        //ICPartner.SETFILTER("Inbox Type",'<>%1',ICPartner."Inbox Type"::Database);  
        ICPartner.SetFilter("Inbox Type", '<>%1&<>%2', ICPartner."Inbox Type"::Database, ICPartner."Inbox Type"::"Web Service");
        //<< 19-06-18 ZY-LD 001

        ICPartnerFilter := ICOutboxTransaction.GetFilter("IC Partner Code");
        if ICPartnerFilter <> '' then
            ICPartner.SetFilter(Code, ICPartnerFilter);
        if ICPartner.Find('-') then
            repeat
                ICOutboxTransaction.SetRange("IC Partner Code", ICPartner.Code);
                if ICOutboxTransaction.Find('-') then begin
                    if (ICPartner."Inbox Type" = ICPartner."Inbox Type"::"File Location") and not IsWebClient() then begin
                        ICPartner.TestField(Blocked, false);
                        if ICPartner."Inbox Details" = '' then
                            Error(FolderPathMissingErr, ICPartner.Code);
                        i := 1;
                        while i <> 0 do begin
                            FileName :=
                              StrSubstNo('%1\%2_%3_%4.xml', ICPartner."Inbox Details", ICPartner.Code, ICOutboxTransaction."Transaction No.", i);
                            if Exists(FileName) then
                                i := i + 1
                            else
                                i := 0;
                        end;
                    end else begin
                        OFile.CreateTempFile();
                        FileName := StrSubstNo('%1.%2.xml', OFile.Name, ICPartner.Code);
                        OFile.Close();
                    end;

                    ExportOutboxTransaction(ICOutboxTransaction, FileName);

                    if IsWebClient() then begin
                        OutFileName := StrSubstNo('%1_%2.xml', ICPartner.Code, ICOutboxTransaction."Transaction No.");
                        if not AddBatchProcessingArtifact(FileName, CopyStr(OutFileName, 1, 1024)) then
                            Download(FileName, '', '', '', OutFileName)
                    end else
                        FileName := FileMgt.DownloadTempFile(FileName);

                    if ICPartner."Inbox Type" = ICPartner."Inbox Type"::Email then begin
                        ICPartner.TestField(Blocked, false);
                        if ICPartner."Inbox Details" = '' then
                            Error(EmailAddressMissingErr, ICPartner.Code);
                        ToName := ICPartner."Inbox Details";
                        if StrPos(ToName, ';') > 0 then begin
                            CcName := CopyStr(ToName, StrPos(ToName, ';') + 1);
                            ToName := CopyStr(ToName, 1, StrPos(ToName, ';') - 1);
                            if StrPos(CcName, ';') > 0 then
                                CcName := CopyStr(CcName, 1, StrPos(CcName, ';') - 1);
                        end;

                        if IsWebClient() then begin
                            EmailItem."Send to" := ICPartner."Inbox Details";
                            EmailItem.Subject := StrSubstNo('%1 %2', ICOutboxTransaction."Document Type", ICOutboxTransaction."Document No.");
                            Commit();

                            OFile.Open(FileName);
                            OFile.CreateInStream(InStream);

                            SourceTableIDs.Add(Database::"IC Outbox Transaction");
                            SourceIDs.Add(ICOutboxTransaction.SystemId);
                            SourceRelationTypes.Add(Enum::"Email Relation Type"::"Primary Source".AsInteger());

                            SourceTableIDs.Add(Database::"IC Partner");
                            SourceIDs.Add(ICPartner.SystemId);
                            SourceRelationTypes.Add(Enum::"Email Relation Type"::"Related Entity".AsInteger());

                            DocumentMailing.EmailFile(
                              InStream,
                              StrSubstNo('%1.xml', ICPartner.Code),
                              '',
                              ICOutboxTransaction."Document No.",
                              EmailItem."Send to",
                              EmailItem.Subject,
                              true,
                              5, // S.Test
                              SourceTableIDs,
                              SourceIDs,
                              SourceRelationTypes);
                        end else begin
                            ICSetup.Get();
                            CompanyInfo.Get();
                            MailHandler.NewMessage(
                              ToName, CcName, '',
                              StrSubstNo(Text001, CompanyInfo.Name),
                              StrSubstNo(
                                Text002, CompanyInfo.Name, ICSetup.FieldCaption("IC Partner Code"), ICSetup."IC Partner Code"),
                              FileName, false);
                        end;
                    end;
                    ICOutboxTransaction.Find('-');
                    repeat
                        ICInboxOutboxMgt.MoveOutboxTransToHandledOutbox(ICOutboxTransaction);
                    until ICOutboxTransaction.Next() = 0;
                end;
            until ICPartner.Next() = 0;
        ICOutboxTransaction.SetRange("IC Partner Code");
        if ICPartnerFilter <> '' then
            ICOutboxTransaction.SetFilter("IC Partner Code", ICPartnerFilter);

        // Code from start of SendToInternalPartner
        ICOWebServiceMgt(ICOutboxTransaction);

        IsHandled := true;
    end;

    local procedure ICOWebServiceMgt(var ICOutboxTrans: Record "IC Outbox Transaction")
    var
        recICPartner: Record "IC Partner";
        recICOutboxSalesHead: Record "IC Outbox Sales Header";
        recICOutboxSalesLine: Record "IC Outbox Sales Line";
        ZyWsMgt: Codeunit "Zyxel Web Service Management";
        ItemNoFilter: Text;
    begin
        //>> 31-08-18 ZY-LD 002
        if ICOutboxTrans.FindSet() then begin
            recICPartner.Get(ICOutboxTrans."IC Partner Code");
            repeat
                if recICOutboxSalesHead.Get(ICOutboxTrans."Transaction No.", ICOutboxTrans."IC Partner Code", ICOutboxTrans."Transaction Source") then
                    if recICOutboxSalesHead."End Customer" <> '' then
                        ZyWsMgt.ReplicateCustomers(recICPartner."Inbox Details", recICOutboxSalesHead."End Customer", false);

                recICOutboxSalesLine.SetRange("IC Transaction No.", recICOutboxSalesHead."IC Transaction No.");
                recICOutboxSalesLine.SetRange("IC Partner Code", recICOutboxSalesHead."IC Partner Code");
                recICOutboxSalesLine.SetRange("Transaction Source", recICOutboxSalesHead."Transaction Source");
                recICOutboxSalesLine.SetRange("IC Partner Ref. Type", recICOutboxSalesLine."IC Partner Ref. Type"::Item);
                if recICOutboxSalesLine.FindSet() then begin
                    ItemNoFilter := '';
                    repeat
                        if recICOutboxSalesLine."IC Partner Reference" <> '' then begin
                            if ItemNoFilter <> '' then
                                ItemNoFilter := ItemNoFilter + '|';
                            ItemNoFilter := ItemNoFilter + recICOutboxSalesLine."IC Partner Reference";
                        end;
                    until recICOutboxSalesLine.Next() = 0;

                    ZyWsMgt.ReplicateItems(recICPartner."Inbox Details", ItemNoFilter, false, true);  // 15-05-19 ZY-LD 003
                end;
            until ICOutboxTrans.Next() = 0;
        end;
        //<< 31-08-18 ZY-LD 002
    end;

    local procedure IsWebClient(): Boolean
    var
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        exit(ClientTypeManagement.GetCurrentClientType() in [CLIENTTYPE::Web, CLIENTTYPE::Phone, CLIENTTYPE::Tablet, CLIENTTYPE::Desktop]);
    end;

    local procedure ExportOutboxTransaction(var ICOutboxTransaction: Record "IC Outbox Transaction"; var FileName: Text)
    var
        ICOutboxImpExpXML: XmlPort "IC Outbox Imp/Exp";
        OFile: File;
        OStr: OutStream;
        IsHandled: Boolean;
    begin
        OFile.Create(FileName);
        OFile.CreateOutStream(OStr);

        ICOutboxImpExpXML.SetICOutboxTrans(ICOutboxTransaction);
        ICOutboxImpExpXML.SetDestination(OStr);
        ICOutboxImpExpXML.Export();

        OFile.Close();
        Clear(OStr);
        Clear(ICOutboxImpExpXML);
    end;

    local procedure AddBatchProcessingArtifact(FilePath: Text; ArtifactName: Text[1024]): Boolean
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        BatchProcessingArtifactType: Enum "Batch Processing Artifact Type";
    begin
        if not BatchProcessingMgt.IsActive() then
            exit(false);

        FileManagement.BLOBImportFromServerFile(TempBlob, FilePath);

        BatchProcessingMgt.AddArtifact(BatchProcessingArtifactType::"IC Output File", ArtifactName, TempBlob);

        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IC Outbox Export", 'OnBeforeRunOutboxTransactions', '', false, false)]
    local procedure ICOutboxExport_OnBeforeRunOutboxTransactions(var ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        recICPartner: Record "IC Partner";
        recICOutboxSalesHead: Record "IC Outbox Sales Header";
        recICOutboxSalesLine: Record "IC Outbox Sales Line";
        ZyWsMgt: Codeunit "Zyxel Web Service Management";
        ItemNoFilter: Text;
    begin
        //>> 31-08-18 ZY-LD 002
        if ICOutboxTransaction.FindSet() then begin
            recICPartner.Get(ICOutboxTransaction."IC Partner Code");
            repeat
                if recICOutboxSalesHead.Get(ICOutboxTransaction."Transaction No.", ICOutboxTransaction."IC Partner Code", ICOutboxTransaction."Transaction Source") then
                    if recICOutboxSalesHead."End Customer" <> '' then
                        ZyWsMgt.ReplicateCustomers(recICPartner."Inbox Details", recICOutboxSalesHead."End Customer", false);

                recICOutboxSalesLine.SetRange("IC Transaction No.", recICOutboxSalesHead."IC Transaction No.");
                recICOutboxSalesLine.SetRange("IC Partner Code", recICOutboxSalesHead."IC Partner Code");
                recICOutboxSalesLine.SetRange("Transaction Source", recICOutboxSalesHead."Transaction Source");
                recICOutboxSalesLine.SetRange("IC Partner Ref. Type", recICOutboxSalesLine."IC Partner Ref. Type"::Item);
                if recICOutboxSalesLine.FindSet() then begin
                    ItemNoFilter := '';
                    repeat
                        if recICOutboxSalesLine."IC Partner Reference" <> '' then begin
                            if ItemNoFilter <> '' then
                                ItemNoFilter := ItemNoFilter + '|';
                            ItemNoFilter := ItemNoFilter + recICOutboxSalesLine."IC Partner Reference";
                        end;
                    until recICOutboxSalesLine.Next() = 0;

                    ZyWsMgt.ReplicateItems(recICPartner."Inbox Details", ItemNoFilter, false, true);  // 15-05-19 ZY-LD 003
                end;
            until ICOutboxTransaction.Next() = 0;
        end;
    end;
    //<< 31-08-18 ZY-LD 002

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IC Outbox Export", 'OnBeforeExportOutboxTransaction', '', false, false)]
    local procedure ICOutboxExport_OnBeforeExportOutboxTransaction(var ICOutboxTransaction: Record "IC Outbox Transaction"; OutStr: OutStream; var IsHandled: Boolean)
    var
        ICOutboxImpExpXML: XmlPort "IC Outbox Imp/Exp ZX";
    begin
        ICOutboxImpExpXML.SetICOutboxTrans(ICOutboxTransaction);
        ICOutboxImpExpXML.SetDestination(OutStr);
        ICOutboxImpExpXML.Export();

        Clear(ICOutboxImpExpXML);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IC Inbox Import", 'OnBeforeImportInboxTransactionProcedure', '', false, false)]
    local procedure ICInboxImport_OnBeforeImportInboxTransactionProcedure(ICSetup: Record "IC Setup"; var IStream: InStream; var TempICOutboxTransaction: Record "IC Outbox Transaction" temporary; var TempICOutboxJnlLine: Record "IC Outbox Jnl. Line" temporary; var TempICInboxOutboxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim." temporary; var TempICOutboxSalesHeader: Record "IC Outbox Sales Header" temporary; var TempICOutboxSalesLine: Record "IC Outbox Sales Line" temporary; var TempICOutboxPurchaseHeader: Record "IC Outbox Purchase Header" temporary; var TempICOutboxPurchaseLine: Record "IC Outbox Purchase Line" temporary; var TempICDocDim: Record "IC Document Dimension" temporary; var FromICPartnerCode: Code[20]; var IsHandled: Boolean)
    var
        ICPartner: Record "IC Partner";
        ICOutboxImpExpXML: XmlPort "IC Outbox Imp/Exp ZX";
        ToICPartnerCode: Code[20];
        WrongCompanyErr: Label 'The selected xml file contains data sent to %1 %2. Current company''s %3 is %4.', Comment = 'The selected xml file contains data sent to IC Partner 001. Current company''s IC Partner Code is 002.';
    begin
        ICOutboxImpExpXML.SetSource(IStream);
        ICOutboxImpExpXML.Import();

        FromICPartnerCode := ICOutboxImpExpXML.GetFromICPartnerCode();
        ToICPartnerCode := ICOutboxImpExpXML.GetToICPartnerCode();
        if ToICPartnerCode <> ICSetup."IC Partner Code" then
            Error(
              WrongCompanyErr, ICPartner.TableCaption(), ToICPartnerCode,
              ICSetup.FieldCaption("IC Partner Code"), ICSetup."IC Partner Code");

        ICOutboxImpExpXML.GetICOutboxTrans(TempICOutboxTransaction);
        ICOutboxImpExpXML.GetICOutBoxJnlLine(TempICOutboxJnlLine);
        ICOutboxImpExpXML.GetICIOBoxJnlDim(TempICInboxOutboxJnlLineDim);
        ICOutboxImpExpXML.GetICOutBoxSalesHdr(TempICOutboxSalesHeader);
        ICOutboxImpExpXML.GetICOutBoxSalesLine(TempICOutboxSalesLine);
        ICOutboxImpExpXML.GetICOutBoxPurchHdr(TempICOutboxPurchaseHeader);
        ICOutboxImpExpXML.GetICOutBoxPurchLine(TempICOutboxPurchaseLine);
        ICOutboxImpExpXML.GetICSalesDocDim(TempICDocDim);
        ICOutboxImpExpXML.GetICSalesDocLineDim(TempICDocDim);
        ICOutboxImpExpXML.GetICPurchDocDim(TempICDocDim);
        ICOutboxImpExpXML.GetICPurchDocLineDim(TempICDocDim);
        FromICPartnerCode := ICOutboxImpExpXML.GetFromICPartnerCode();

        IsHandled := true;
    end;
    #endregion






}
