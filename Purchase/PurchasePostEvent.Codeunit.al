codeunit 50090 "Purchase Post Event"
{
    // 001. 13-11-18 ZY-LD 2018111310000028 - Don't post if "On Hold" is set.
    // 002. 28-12-18 ZY-LD 000 - This code will maintain container details on direct shipment.
    // 003. 31-01-19 ZY-LD 2019013010000174 - "Vendor Invoice No." must not be blank.
    // 004. 28-02-19 ZY-LD 2019022010000075 - Handle consignment stock.
    // 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 005. 06-09-19 ZY-LD P0290 - Status on EiCard Queue is set to posted.
    // 006. 24-09-19 ZY-LD P0290 - Download document and update purchase order before posting.
    // 007. 24-10-19 ZY-LD 2019102410000071 - Post without electronic invoice.
    // 008. 23-03-20 ZY-LD P0388 - Filter on "Warehouse Inbound No.". There can be lines on same purchase order line from other inbounds.
    // 009. 26-03-20 ZY-LD P0412 - Revaluate entries.
    // 010. 03-11-20 ZY-LD 2020110310000088 - Receipt No. is storred, so if we reverse a receipt, we will be able to delete the "Shipping Detailed Receipt" lines.
    // 011. 04-12-20 ZY-LD 2020120310000102 - OnBeforeItemJnlPostLineRunWithCheck.  // 10-03-21 ZY-LD - It has been deleted again.
    // 012. 18-01-21 ZY-LD 000 - Location Code on header and lines must be identical.
    // 013. 11-02-22 ZY-LD P0747 - Handling "Charge (Item)".
    // 014. 30-05-22 ZY-LD 2022052510000091 - "Warehouse Inbound No." was not always keyed in correct, when handled manually. If not found, then we will try without.
    // 015. 06-11-23 ZY-LD 000 - In Italy NAV, we have seen that purch receipt line has been posted with a relation to a wrong item ledger entry, and without any G/L Entries.
    // 016. 19-03-24 ZY-LD #0139688 - We got an error in the Undo function, so we check if entry no is zero.
    // 017. 15-04-24 ZY-LD 000 - Set default return reason code on corrections.
    // 018. 29-05-24 ZY-LD 000 - On sample vendors must only sample item with original item be posted.

    Permissions = TableData "Freight Cost Value Entry" = i,
                  TableData "HQ Invoice Header" = rm;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        recServEnviron: Record "Server Environment";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        lPurchLine: Record "Purchase Line";
        lText001: Label 'On Item no.: %1 is\%2 = %3 and\%4 = %5.\Send a ticket to "EU NAV Support".';
        lText002: Label 'Posting is cancled.';
        recItem: Record Item;
        lText003: Label 'You are not allowed to post, because "%1" is "%2". Clear "%1" on the invoice tab to post the purchase document.';
        recPostGrpCtryLoc: Record "Post Grp. pr. Country / Loc.";
        lText004: Label 'Value is not valid in "%1". Expected value is %2.';
        recHqSaleDocHead: Record "HQ Invoice Header";
        recPurchSetup: Record "Purchases & Payables Setup";
        HqSalesDocMgt: Codeunit "HQ Sales Document Management";
        lText005: Label 'We have not received an electronic invoice from the vendor, so you can not post the order.\If you want to skip the electronic invoice you can do it by setting a tick in field "%1" on the invoice tab.';
        lText006: Label '"Location Code" on the purchase header and the purchase line must not be different.';
    begin
        // It happens that Quantity and Quantity (Base) are different. We don't want that.
        with PurchaseHeader do begin
            //>> 13-11-18 ZY-LD 001
            if "On Hold" <> '' then
                Error(lText003, FieldCaption("On Hold"), "On Hold");
            //<< 13-11-18 ZY-LD 001

            //>> 28-02-19 ZY-LD 004
            if not recPostGrpCtryLoc.Get("Ship-to Country/Region Code", "Location Code") then;
            lPurchLine.Reset();
            lPurchLine.SetRange("Document Type", "Document Type");
            lPurchLine.SetRange("Document No.", "No.");
            lPurchLine.SetRange(Type, lPurchLine.Type::Item);
            if lPurchLine.FindSet() then
                repeat
                    if lPurchLine."No." <> '' then begin
                        if recPostGrpCtryLoc."VAT Prod. Post. Group - Purch" <> '' then
                            if lPurchLine."VAT Prod. Posting Group" <> recPostGrpCtryLoc."VAT Prod. Post. Group - Purch" then
                                Error(lText004, lPurchLine.FieldCaption("VAT Prod. Posting Group"), recPostGrpCtryLoc."VAT Prod. Post. Group - Purch");
                        if recPostGrpCtryLoc."Line Discount %" <> 0 then
                            if lPurchLine."Line Discount %" <> recPostGrpCtryLoc."Line Discount %" then
                                Error(lText004, lPurchLine.FieldCaption("Line Discount %"), recPostGrpCtryLoc."Line Discount %");
                    end;

                    //if "Document Type" in ["document type"::Order, "document type"::Invoice] then
                    if ("Document Type" = "document type"::Invoice) OR
                       (("Document Type" = "document type"::Order) and PurchaseHeader.Invoice)
                    then
                        if lPurchLine.Quantity <> 0 then
                            if lPurchLine."Qty. to Receive" <> lPurchLine."Qty. to Receive (Base)" then
                                Error(lText001, lPurchLine."No.", lPurchLine.FieldCaption(lPurchLine."Qty. to Receive"), lPurchLine."Qty. to Receive", lPurchLine.FieldCaption("Qty. to Receive (Base)"), lPurchLine."Qty. to Receive (Base)");

                    if ("Document Type" = "Document Type"::"Credit Memo") and
                       (lPurchLine.type = lPurchLine.type::item) and
                       (lPurchLine."No." <> '')
                       then
                        lPurchLine.TestField("Return Reason Code");
                    //>> 18-01-21 ZY-LD 012
                    if "Location Code" <> lPurchLine."Location Code" then
                        Error(lText006);
                //<< 18-01-21 ZY-LD 012
                until lPurchLine.Next() = 0;
            //<< 28-02-19 ZY-LD 004

            //>> 24-09-19 ZY-LD 006
            if "Document Type" = "document type"::Order then
                if IsEICard and
                   not "Post Order Without HQ Document"  // 24-10-19 ZY-LD 007
                then begin
                    recPurchSetup.Get();
                    if (("Buy-from Vendor No." = recPurchSetup."EiCard Vendor No.") or   // 24-10-19 ZY-LD 007
                        ("Buy-from Vendor No." = recPurchSetup."EiCard Vendor No. CH"))  // 24-10-19 ZY-LD 007
                    then begin
                        recHqSaleDocHead.SetRange("Purchase Order No.", "No.");
                        if recHqSaleDocHead.FindFirst() then begin
                            recHqSaleDocHead.DownloadDocument(false);
                            recHqSaleDocHead.UpdatePurchaseOrder(PurchaseHeader);
                        end else
                            Error(lText005, FieldCaption("Post Order Without HQ Document"));
                    end;
                end;
            //<< 24-09-19 ZY-LD 006
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20])
    var
        recEiCardQueue: Record "EiCard Queue";
        recHqSaleDocHead: Record "HQ Invoice Header";
        recItemReg: Record "Item Register";
        NLtoDKPosting: Report "NL to DK Posting";  // 24-09-24 ZY-LD 018
    begin
        with PurchaseHeader do begin
            //>> 06-09-19 ZY-LD 005
            if (PurchInvHdrNo <> '') or (PurchCrMemoHdrNo <> '') then begin
                if PurchInvHdrNo <> '' then
                    recHqSaleDocHead.SetRange("Document Type", recHqSaleDocHead."document type"::Invoice)
                else
                    recHqSaleDocHead.SetRange("Document Type", recHqSaleDocHead."document type"::"Credit Memo");
                recHqSaleDocHead.SetRange("No.", "Vendor Invoice No.");
                recHqSaleDocHead.SetAutoCalcFields("Purchase Order No.");
                if recHqSaleDocHead.FindFirst() then begin
                    recHqSaleDocHead.Status := recHqSaleDocHead.Status::"Document is Posted";
                    recHqSaleDocHead.Modify();

                    if IsEICard then begin
                        recEiCardQueue.SetRange("Purchase Order No.", recHqSaleDocHead."Purchase Order No.");
                        if recEiCardQueue.FindFirst() then begin
                            recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::Posted);
                            recEiCardQueue.Modify(true);
                        end;
                    end;
                end;
            end;
            //<< 06-09-19 ZY-LD 005

            if PurchaseHeader."NL to DK Reverse Chg. Doc No." <> '' then  // 24-09-24 ZY-LD 018
                NLtoDKPosting.NLtoDKRevChargePosted(PurchaseHeader."NL to DK Reverse Chg. Doc No.", PurchaseHeader."Document Type");  // 24-09-24 ZY-LD 018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure OnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; ModifyHeader: Boolean)
    var
        lPurchRecepHead: Record "Purch. Rcpt. Header";
        lPurchRecepLine: Record "Purch. Rcpt. Line";
        lPurchLine: Record "Purchase Line";
        Vend: Record Vendor;
        ICSetup: Record "IC Setup";
        lText001: Label 'On Item no.: %1 is\%2 = %3 and\%4 = %5.\Send a ticket to "EU NAV Support".';
    begin
        // It happens that Quantity and Quantity (Base) are different. We don't want that.
        with PurchaseHeader do begin
            if PurchaseHeader.Receive then begin
                lPurchRecepHead.SetRange("Order No.", "No.");
                lPurchRecepHead.SetRange("Posting Date", "Posting Date");
                if lPurchRecepHead.FindLast() then begin
                    lPurchRecepLine.SetRange("Document No.", lPurchRecepHead."No.");
                    if lPurchRecepLine.FindSet() then
                        repeat
                            if lPurchRecepLine.Quantity <> lPurchRecepLine."Quantity (Base)" then
                                Error(lText001, lPurchRecepLine."No.", lPurchRecepLine.FieldCaption(Quantity), lPurchRecepLine.Quantity, lPurchRecepLine.FieldCaption("Quantity (Base)"), lPurchRecepLine."Quantity (Base)");
                        until lPurchRecepLine.Next() = 0;
                end;
            end;

            //>> 29-05-24 ZY-LD 018
            if Vend.get("Buy-from Vendor No.") and Vend."Sample Vendor" then begin
                ICSetup.get;
                ICSetup.TestField("Sample Item");
                lPurchLine.SetRange("Document Type", "Document Type");
                lPurchLine.SetRange("Document No.", "No.");
                lPurchLine.SetRange(Type, lPurchLine.Type::Item);
                if lPurchLine.FindSet() then
                    repeat
                        lPurchLine.TestField(lPurchLine."No.", ICSetup."Sample Item");
                        lPurchLine.TestField(lPurchLine."Original No.");
                    until lPurchLine.Next() = 0;
            end;
            //<< 29-05-24 ZY-LD 018
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure PurchPost_OnAfterFinalizePostingOnBeforeCommit(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; EverythingInvoiced: Boolean)
    var
        InvtSetup: Record "Inventory Setup";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        Location: Record Location;
        TransferOrderPostTransfer: Codeunit "TransferOrder-Post Transfer";
        TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransHeaderNoList: List of [Code[20]];
        TransHeaderNo: Code[20];
        CurrContainerNo: Code[20];
        CurrLocationCode: Code[10];
    begin
        if PurchRcptHeader."No." = '' then
            exit;

        InvtSetup.Get();
        if (InvtSetup.GoodsInTransitLocationCode = '') or (not Location.Get(InvtSetup.GoodsInTransitLocationCode)) or
            (InvtSetup.GoodsInTransitInTransitCode = '') or (not Location.Get(InvtSetup.GoodsInTransitInTransitCode))
        then
            exit;

        PurchRcptLine.SetCurrentKey(OriginalLocationCode);
        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("Location Code", InvtSetup.GoodsInTransitLocationCode);
        PurchRcptLine.SetFilter(OriginalLocationCode, '<>''''');
        if PurchRcptLine.FindSet() then begin
            repeat
                if (PurchRcptLine.OriginalLocationCode <> CurrLocationCode) or (PurchRcptLine."Container No." <> CurrContainerNo) then begin
                    TransHeader.Reset();
                    if InvtSetup."Direct Transfer Posting" = InvtSetup."Direct Transfer Posting"::"Direct Transfer" then
                        TransHeader.SetRange("Direct Transfer", true)
                    else
                        TransHeader.SetRange("Direct Transfer", false);
                    TransHeader.SetRange("Transfer-from Code", PurchRcptLine."Location Code");
                    TransHeader.SetRange("Transfer-to Code", PurchRcptLine.OriginalLocationCode);
                    TransHeader.SetRange("In-Transit Code", InvtSetup.GoodsInTransitInTransitCode);
                    TransHeader.SetRange("Container No.", PurchRcptLine."Container No.");
                    if TransHeader.FindFirst() then begin
                        TransHeaderNo := TransHeader."No.";
                        CurrLocationCode := PurchRcptLine.OriginalLocationCode;
                        CurrContainerNo := PurchRcptLine."Container No.";
                    end else begin
                        Clear(TransHeader);
                        TransHeader.Reset();
                        TransHeader.Init();
                        TransHeader.Insert(true);

                        if InvtSetup."Direct Transfer Posting" = InvtSetup."Direct Transfer Posting"::"Direct Transfer" then
                            TransHeader.Validate("Direct Transfer", true)
                        else
                            TransHeader.Validate("Direct Transfer", false);
                        TransHeader.Validate("Transfer-from Code", PurchRcptLine."Location Code");
                        TransHeader.Validate("Transfer-to Code", PurchRcptLine.OriginalLocationCode);
                        TransHeader.Validate("In-Transit Code", InvtSetup.GoodsInTransitInTransitCode);
                        TransHeader."Container No." := PurchRcptLine."Container No.";
                        TransHeader.Modify(true);

                        TransHeaderNo := TransHeader."No.";
                        CurrLocationCode := PurchRcptLine.OriginalLocationCode;
                        CurrContainerNo := PurchRcptLine."Container No.";
                    end;

                    if not TransHeaderNoList.Contains(TransHeaderNo) then
                        TransHeaderNoList.Add(TransHeaderNo);
                end;

                Clear(TransLine);
                TransLine."Document No." := TransHeaderNo;
                TransLine.Validate("Transfer-from Code", PurchRcptLine."Location Code");
                TransLine.Validate("Transfer-to Code", PurchRcptLine.OriginalLocationCode);
                TransLine.Validate("In-Transit Code", InvtSetup.GoodsInTransitInTransitCode);
                TransLine.Validate("Item No.", PurchRcptLine."No.");
                if PurchRcptLine."Variant Code" <> '' then
                    TransLine.Validate("Variant Code", PurchRcptLine."Variant Code");
                TransLine.Validate(Quantity, PurchRcptLine.Quantity);

                TransLine.ExpectedReceiptDate := PurchRcptLine."Expected Receipt Date";
                TransLine.PurchaseOrderNo := PurchRcptLine."Order No.";
                TransLine.PurchaseOrderLineNo := PurchRcptLine."Order Line No.";

                TransLine.Insert(true);
            until PurchRcptLine.Next() = 0;

            foreach TransHeaderNo in TransHeaderNoList do begin
                TransHeader.Get(TransHeaderNo);

                if InvtSetup."Direct Transfer Posting" = InvtSetup."Direct Transfer Posting"::"Direct Transfer" then
                    TransferOrderPostTransfer.Run(TransHeader)
                else begin
                    TransferOrderPostShipment.SetHideValidationDialog(true);
                    TransferOrderPostShipment.Run(TransHeader);
                    TransferOrderPostReceipt.SetHideValidationDialog(true);
                    TransferOrderPostReceipt.Run(TransHeader);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertPurchRcptLine(var Rec: Record "Purch. Rcpt. Line"; RunTrigger: Boolean)
    var
        recContDetail: Record "VCK Shipping Detail";
        recItemLedgEntry: Record "Item Ledger Entry";  // 06-11-23 ZY-LD 015
        QuantityReceipt: Decimal;
        CDT: DateTime;
        lText001: Label '"%1" must not be blank on "Purchase Order No." %2, "Purchase Order Line No." %3';
    begin
        // This code is inserted in production. Real solution will be depolyed later withs another project.
        with Rec do
            //>> 06-11-23 ZY-LD 015
            IF NOT ISTEMPORARY and (Rec.Type = Rec.Type::Item) and (Quantity <> 0) THEN BEGIN
                if "Item Rcpt. Entry No." <> 0 then begin  // 19-03-24 ZY-LD 016
                    recItemLedgEntry.GET("Item Rcpt. Entry No.");
                    IF recItemLedgEntry."Item No." <> "No." THEN
                        ERROR(lText001, recItemLedgEntry."Item No.", "No.", TABLECAPTION);
                end;
            END;  // 19-03-24 ZY-LD 016
        //<< 06-11-23 ZY-LD 015
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchRcptLine(var Rec: Record "Purch. Rcpt. Line"; RunTrigger: Boolean)
    var
        recPurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        // Update Container Details
        with Rec do
            //>> 23-03-20 ZY-LD 008
            if not IsTemporary then
                if not Correction then  // 03-11-20 ZY-LD 010
                    UpdateContainerDetails(
                      "Order No.",
                      "Order Line No.",
                      "Warehouse Inbound No.",
                      Quantity,
                      "Document No.", "Line No.")  // 03-11-20 ZY-LD 010
                else begin
                    //>> 03-11-20 ZY-LD 010
                    recPurchRcptLine.SetRange("Document No.", "Document No.");
                    recPurchRcptLine.SetRange("Item Rcpt. Entry No.", "Appl.-to Item Entry");
                    if recPurchRcptLine.FindFirst() then
                        DeleteShipDetailReceived(recPurchRcptLine."Document No.", recPurchRcptLine."Line No.");
                    //<< 03-11-20 ZY-LD 010
                end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterCopyFromPurchRcptLine', '', false, false)]
    local procedure OnAfterCopyFromPurchRcptLine(var PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line"; var TempPurchLine: Record "Purchase Line")
    begin
        PurchaseLine.Validate("Vendor Invoice No", TempPurchLine."Vendor Invoice No");  // 27-04-22 ZY-LD 005
    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertReturnRcptLine(var Rec: Record "Return Receipt Line"; RunTrigger: Boolean)
    var
        recReturnRcptLine: Record "Return Receipt Line";
    begin
        with Rec do
            //>> 23-03-20 ZY-LD 008
            if not IsTemporary then
                if not Correction then  // 03-11-20 ZY-LD 010
                    UpdateContainerDetails(
                      "Return Order No.",
                      "Return Order Line No.",
                      "Warehouse Inbound No.",
                      Quantity,
                      "Document No.", "Line No.")  // 03-11-20 ZY-LD 010
                else begin
                    //>> 03-11-20 ZY-LD 010
                    recReturnRcptLine.SetRange("Document No.", "Document No.");
                    recReturnRcptLine.SetRange("Item Rcpt. Entry No.", "Appl.-to Item Entry");
                    if recReturnRcptLine.FindFirst() then
                        DeleteShipDetailReceived(recReturnRcptLine."Document No.", recReturnRcptLine."Line No.");
                    //<< 03-11-20 ZY-LD 010
                end;
        //<< 23-03-20 ZY-LD 008
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertTransRcptLine(var Rec: Record "Transfer Receipt Line"; RunTrigger: Boolean)
    begin
        with Rec do
            //>> 23-03-20 ZY-LD 008
            if not IsTemporary then
                UpdateContainerDetails(
                  "Transfer Order No.",
                  "Line No.",
                  "Warehouse Inbound No.",
                  Quantity,
                  "Document No.", "Line No.")  // 03-11-20 ZY-LD 010
                                               //<< 23-03-20 ZY-LD 008
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Batch Processing Mgt.", 'OnVerifyRecord', '', false, false)]
    local procedure BatchProcessingMgt_OnVerifyRecord(var RecRef: RecordRef; var Result: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        recHqInvHead: Record "HQ Invoice Header";
    begin
        if RecRef.Number <> Database::"Purchase Header" then
            exit;

        RecRef.SetTable(PurchHeader);
        //>> 15-04-20 ZY-LD 002
        if (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) and PurchHeader.IsEICard then begin
            recHqInvHead.SetAutoCalcFields("Total Amount");
            recHqInvHead.SetRange("Purchase Order No.", PurchHeader."No.");
            PurchHeader.CalcFields(Amount);
            if recHqInvHead.FindFirst() then
                if Round(recHqInvHead."Total Amount") <> PurchHeader.Amount then  // 01-08-22 ZY-LD 003
                    Result := false;
        end;
        //<< 15-04-20 ZY-LD 002
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeItemJnlPostLine', '', false, false)]
    local procedure OnBeforeItemJnlPostLine_PurchPost(var ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line")
    begin
        ItemJournalLine."Original No." := PurchaseLine."Original No.";  // 02-05-24 - ZY-LD 000
    end;

    local procedure UpdateContainerDetails(pOrderNo: Code[20]; pOrderLineNo: Integer; pWhseIndboundNo: Code[20]; pQuantity: Decimal; pReceiptNo: Code[20]; pReceiptLineNo: Integer)
    var
        recContDetail: Record "VCK Shipping Detail";
        QuantityReceipt: Decimal;
        CDT: DateTime;
    begin
        // Update Container Details
        //>> 23-03-20 ZY-LD 008
        if pQuantity <> 0 then begin
            CDT := CurrentDatetime;

            QuantityReceipt := pQuantity;
            recContDetail.SetCurrentkey("Expected Receipt Date", "Purchase Order No.", "Purchase Order Line No.");
            recContDetail.SetAutoCalcFields("Quantity Received");
            recContDetail.SetRange("Purchase Order No.", pOrderNo);
            recContDetail.SetRange("Purchase Order Line No.", pOrderLineNo);
            if pWhseIndboundNo <> '' then  // 23-03-20 ZY-LD 008
                recContDetail.SetRange("Document No.", pWhseIndboundNo);  // 23-03-20 ZY-LD 008
            recContDetail.SetRange(Archive, false);
            //>> 30-05-22 ZY-LD 014
            if not recContDetail.FindFirst() then
                recContDetail.SetRange("Document No.");
            //<< 30-05-22 ZY-LD 014
            if recContDetail.FindSet(true) then
                repeat
                    if QuantityReceipt <> 0 then begin
                        if QuantityReceipt <= recContDetail.Quantity - recContDetail."Quantity Received" then begin
                            CreateShipDetailReceived(
                              recContDetail,
                              QuantityReceipt,
                              CDT,
                              pReceiptNo, pReceiptLineNo);  // 03-11-20 ZY-LD 010
                            QuantityReceipt := 0;
                        end else begin
                            CreateShipDetailReceived(
                              recContDetail,
                              recContDetail.Quantity - recContDetail."Quantity Received",
                              CDT,
                              pReceiptNo, pReceiptLineNo);  // 03-11-20 ZY-LD 010
                            QuantityReceipt := QuantityReceipt - (recContDetail.Quantity - recContDetail."Quantity Received");
                        end;

                        recContDetail.CalcFields("Quantity Received");
                        if recContDetail.Quantity = recContDetail."Quantity Received" then begin
                            recContDetail.Archive := true;
                            recContDetail.Modify();
                        end;
                    end;
                until (recContDetail.Next() = 0) or (QuantityReceipt = 0);
        end;
        //<< 23-03-20 ZY-LD 008
    end;

    // Cancling Invoice
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Purch. Invoice", 'OnAfterCreateCorrectivePurchCrMemo', '', false, false)]
    local procedure OnAfterCreateCorrectivePurchCrMemo(PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseHeader: Record "Purchase Header"; var CancellingOnly: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin
        //>> 15-04-24 ZY-LD 017
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        If PurchLine.FindSet() then
            repeat
                PurchLine.Validate("Return Reason Code", '11');
                PurchLine.Modify(true);
            until PurchLine.Next() = 0;
        //<< 15-04-24 ZY-LD 017
    end;

    procedure CreateShipDetailReceived(precShipDetail: Record "VCK Shipping Detail"; pQtyReceived: Decimal; pCDT: DateTime; pReceiptNo: Code[20]; pReceiptLineNo: Integer)
    var
        recShipDetailReceived: Record "VCK Shipping Detail Received";
    begin
        with recShipDetailReceived do begin
            TransferFields(precShipDetail);
            "Quantity Received" := pQtyReceived;
            "Date Posted" := pCDT;
            "Receipt No." := pReceiptNo;  // 03-11-20 ZY-LD 010
            "Receipt Line No." := pReceiptLineNo;  // 03-11-20 ZY-LD 010
            Insert(true);
        end;
    end;

    local procedure DeleteShipDetailReceived(pReceiptNo: Code[20]; pReceiptLineNo: Integer)
    var
        recShipDetailReceived: Record "VCK Shipping Detail Received";
    begin
        with recShipDetailReceived do begin
            //>> 03-11-20 ZY-LD 010
            SetRange("Receipt No.", pReceiptNo);
            SetRange("Receipt Line No.", pReceiptLineNo);
            if FindSet(true) then
                repeat
                    Delete(true);
                until Next = 0;
            //<< 03-11-20 ZY-LD 010
        end;
    end;
}
