codeunit 50090 "Purchase Post Event"
{
    Permissions = TableData "Freight Cost Value Entry" = i,
                  TableData "HQ Invoice Header" = rm;

    var


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        lPurchLine: Record "Purchase Line";
        recPostGrpCtryLoc: Record "Post Grp. pr. Country / Loc.";
        recHqSaleDocHead: Record "HQ Invoice Header";
        recPurchSetup: Record "Purchases & Payables Setup";
        lText001: Label 'On Item no.: %1 is\%2 = %3 and\%4 = %5.\Send a ticket to "EU NAV Support".';
        lText003: Label 'You are not allowed to post, because "%1" is "%2". Clear "%1" on the invoice tab to post the purchase document.';
        lText004: Label 'Value is not valid in "%1". Expected value is %2.';
        lText005: Label 'We have not received an electronic invoice from the vendor, so you can not post the order.\If you want to skip the electronic invoice you can do it by setting a tick in field "%1" on the invoice tab.';
        lText006: Label '"Location Code" on the purchase header and the purchase line must not be different.';
    begin
        // It happens that Quantity and Quantity (Base) are different. We don't want that.
        if PurchaseHeader."On Hold" <> '' then
            Error(lText003, PurchaseHeader.FieldCaption("On Hold"), PurchaseHeader."On Hold");

        if not recPostGrpCtryLoc.Get(PurchaseHeader."Ship-to Country/Region Code", PurchaseHeader."Location Code") then;
        lPurchLine.Reset();
        lPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        lPurchLine.SetRange("Document No.", PurchaseHeader."No.");
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

                if (PurchaseHeader."Document Type" = PurchaseHeader."document type"::Invoice) OR
                   ((PurchaseHeader."Document Type" = PurchaseHeader."document type"::Order) and PurchaseHeader.Invoice)
                then
                    if lPurchLine.Quantity <> 0 then
                        if lPurchLine."Qty. to Receive" <> lPurchLine."Qty. to Receive (Base)" then
                            Error(lText001, lPurchLine."No.", lPurchLine.FieldCaption(lPurchLine."Qty. to Receive"), lPurchLine."Qty. to Receive", lPurchLine.FieldCaption("Qty. to Receive (Base)"), lPurchLine."Qty. to Receive (Base)");

                if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") and
                   (lPurchLine.type = lPurchLine.type::item) and
                   (lPurchLine."No." <> '')
                   then
                    lPurchLine.TestField("Return Reason Code");
                if PurchaseHeader."Location Code" <> lPurchLine."Location Code" then
                    Error(lText006);
            until lPurchLine.Next() = 0;

        if PurchaseHeader."Document Type" = PurchaseHeader."document type"::Order then
            if PurchaseHeader.IsEICard and
               not PurchaseHeader."Post Order Without HQ Document"
            then begin
                recPurchSetup.Get();
                if ((PurchaseHeader."Buy-from Vendor No." = recPurchSetup."EiCard Vendor No.") or
                    (PurchaseHeader."Buy-from Vendor No." = recPurchSetup."EiCard Vendor No. CH"))
                then begin
                    recHqSaleDocHead.SetRange("Purchase Order No.", PurchaseHeader."No.");
                    if recHqSaleDocHead.FindFirst() then begin
                        recHqSaleDocHead.DownloadDocument(false);
                        recHqSaleDocHead.UpdatePurchaseOrder(PurchaseHeader);
                    end else
                        Error(lText005, PurchaseHeader.FieldCaption("Post Order Without HQ Document"));
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20])
    var
        recEiCardQueue: Record "EiCard Queue";
        recHqSaleDocHead: Record "HQ Invoice Header";
        NLtoDKPosting: Report "NL to DK Posting";
    begin
        if (PurchInvHdrNo <> '') or (PurchCrMemoHdrNo <> '') then begin
            if PurchInvHdrNo <> '' then
                recHqSaleDocHead.SetRange("Document Type", recHqSaleDocHead."document type"::Invoice)
            else
                recHqSaleDocHead.SetRange("Document Type", recHqSaleDocHead."document type"::"Credit Memo");
            recHqSaleDocHead.SetRange("No.", PurchaseHeader."Vendor Invoice No.");
            recHqSaleDocHead.SetAutoCalcFields("Purchase Order No.");
            if recHqSaleDocHead.FindFirst() then begin
                recHqSaleDocHead.Status := recHqSaleDocHead.Status::"Document is Posted";
                recHqSaleDocHead.Modify();

                if PurchaseHeader.IsEICard then begin
                    recEiCardQueue.SetRange("Purchase Order No.", recHqSaleDocHead."Purchase Order No.");
                    if recEiCardQueue.FindFirst() then begin
                        recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::Posted);
                        recEiCardQueue.Modify(true);
                    end;
                end;
            end;
        end;


        if PurchaseHeader."NL to DK Reverse Chg. Doc No." <> '' then
            NLtoDKPosting.NLtoDKRevChargePosted(PurchaseHeader."NL to DK Reverse Chg. Doc No.", PurchaseHeader."Document Type");
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
        //with PurchaseHeader do begin
        if PurchaseHeader.Receive then begin
            lPurchRecepHead.SetRange("Order No.", PurchaseHeader."No.");
            lPurchRecepHead.SetRange("Posting Date", PurchaseHeader."Posting Date");
            if lPurchRecepHead.FindLast() then begin
                lPurchRecepLine.SetRange("Document No.", lPurchRecepHead."No.");
                if lPurchRecepLine.FindSet() then
                    repeat
                        if lPurchRecepLine.Quantity <> lPurchRecepLine."Quantity (Base)" then
                            Error(lText001, lPurchRecepLine."No.", lPurchRecepLine.FieldCaption(Quantity), lPurchRecepLine.Quantity, lPurchRecepLine.FieldCaption("Quantity (Base)"), lPurchRecepLine."Quantity (Base)");
                    until lPurchRecepLine.Next() = 0;
            end;
        end;

        if Vend.get(PurchaseHeader."Buy-from Vendor No.") and Vend."Sample Vendor" then begin
            ICSetup.get();
            ICSetup.TestField("Sample Item");
            lPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
            lPurchLine.SetRange("Document No.", PurchaseHeader."No.");
            lPurchLine.SetRange(Type, lPurchLine.Type::Item);
            if lPurchLine.FindSet() then
                repeat
                    lPurchLine.TestField(lPurchLine."No.", ICSetup."Sample Item");
                    lPurchLine.TestField(lPurchLine."Original No.");
                until lPurchLine.Next() = 0;
        end;
        //end;
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
        recItemLedgEntry: Record "Item Ledger Entry";
        lText001: Label '"%1" must not be blank on "Purchase Order No." %2, "Purchase Order Line No." %3';
    begin
        // This code is inserted in production. Real solution will be depolyed later withs another project.
        IF NOT Rec.ISTEMPORARY and (Rec.Type = Rec.Type::Item) and (Rec.Quantity <> 0) THEN
            if Rec."Item Rcpt. Entry No." <> 0 then begin
                recItemLedgEntry.GET(Rec."Item Rcpt. Entry No.");
                IF recItemLedgEntry."Item No." <> Rec."No." THEN
                    ERROR(lText001, recItemLedgEntry."Item No.", Rec."No.", Rec.TABLECAPTION);
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchRcptLine(var Rec: Record "Purch. Rcpt. Line"; RunTrigger: Boolean)
    var
        recPurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if not Rec.IsTemporary then
            if not Rec.Correction then
                UpdateContainerDetails(
                  Rec."Order No.",
                  Rec."Order Line No.",
                  Rec."Warehouse Inbound No.",
                  Rec.Quantity,
                  Rec."Document No.", Rec."Line No.")
            else begin
                recPurchRcptLine.SetRange("Document No.", Rec."Document No.");
                recPurchRcptLine.SetRange("Item Rcpt. Entry No.", Rec."Appl.-to Item Entry");
                if recPurchRcptLine.FindFirst() then
                    DeleteShipDetailReceived(recPurchRcptLine."Document No.", recPurchRcptLine."Line No.");

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
        if not Rec.IsTemporary then
            if not Rec.Correction then
                UpdateContainerDetails(
                  Rec."Return Order No.",
                  Rec."Return Order Line No.",
                  Rec."Warehouse Inbound No.",
                  Rec.Quantity,
                  Rec."Document No.", Rec."Line No.")
            else begin

                recReturnRcptLine.SetRange("Document No.", Rec."Document No.");
                recReturnRcptLine.SetRange("Item Rcpt. Entry No.", Rec."Appl.-to Item Entry");
                if recReturnRcptLine.FindFirst() then
                    DeleteShipDetailReceived(recReturnRcptLine."Document No.", recReturnRcptLine."Line No.");

            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertTransRcptLine(var Rec: Record "Transfer Receipt Line"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary then
            UpdateContainerDetails(
              Rec."Transfer Order No.",
              Rec."Line No.",
              Rec."Warehouse Inbound No.",
              Rec.Quantity,
              Rec."Document No.",
              Rec."Line No.")

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
        if (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) and PurchHeader.IsEICard then begin
            recHqInvHead.SetAutoCalcFields("Total Amount");
            recHqInvHead.SetRange("Purchase Order No.", PurchHeader."No.");
            PurchHeader.CalcFields(Amount);
            if recHqInvHead.FindFirst() then
                if Round(recHqInvHead."Total Amount") <> PurchHeader.Amount then
                    Result := false;
        end;
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
        if pQuantity <> 0 then begin
            CDT := CurrentDatetime;

            QuantityReceipt := pQuantity;
            recContDetail.SetCurrentkey("Expected Receipt Date", "Purchase Order No.", "Purchase Order Line No.");
            recContDetail.SetAutoCalcFields("Quantity Received");
            recContDetail.SetRange("Purchase Order No.", pOrderNo);
            recContDetail.SetRange("Purchase Order Line No.", pOrderLineNo);
            if pWhseIndboundNo <> '' then
                recContDetail.SetRange("Document No.", pWhseIndboundNo);
            recContDetail.SetRange(Archive, false);
            if not recContDetail.FindFirst() then
                recContDetail.SetRange("Document No.");

            if recContDetail.FindSet(true) then
                repeat
                    if QuantityReceipt <> 0 then begin
                        if QuantityReceipt <= recContDetail.Quantity - recContDetail."Quantity Received" then begin
                            CreateShipDetailReceived(
                              recContDetail,
                              QuantityReceipt,
                              CDT,
                              pReceiptNo, pReceiptLineNo);
                            QuantityReceipt := 0;
                        end else begin
                            CreateShipDetailReceived(
                              recContDetail,
                              recContDetail.Quantity - recContDetail."Quantity Received",
                              CDT,
                              pReceiptNo, pReceiptLineNo);
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
    end;

    // Cancling Invoice
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Purch. Invoice", 'OnAfterCreateCorrectivePurchCrMemo', '', false, false)]
    local procedure OnAfterCreateCorrectivePurchCrMemo(PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseHeader: Record "Purchase Header"; var CancellingOnly: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        If PurchLine.FindSet() then
            repeat
                PurchLine.Validate("Return Reason Code", '11');
                PurchLine.Modify(true);
            until PurchLine.Next() = 0;
    end;

    procedure CreateShipDetailReceived(precShipDetail: Record "VCK Shipping Detail"; pQtyReceived: Decimal; pCDT: DateTime; pReceiptNo: Code[20]; pReceiptLineNo: Integer)
    var
        recShipDetailReceived: Record "VCK Shipping Detail Received";
    begin
        recShipDetailReceived.TransferFields(precShipDetail);
        recShipDetailReceived."Quantity Received" := pQtyReceived;
        recShipDetailReceived."Date Posted" := pCDT;
        recShipDetailReceived."Receipt No." := pReceiptNo;
        recShipDetailReceived."Receipt Line No." := pReceiptLineNo;
        recShipDetailReceived.Insert(true);
    end;

    local procedure DeleteShipDetailReceived(pReceiptNo: Code[20]; pReceiptLineNo: Integer)
    var
        recShipDetailReceived: Record "VCK Shipping Detail Received";
    begin
        recShipDetailReceived.SetRange("Receipt No.", pReceiptNo);
        recShipDetailReceived.SetRange("Receipt Line No.", pReceiptLineNo);
        if recShipDetailReceived.FindSet(true) then
            repeat
                recShipDetailReceived.Delete(true);
            until recShipDetailReceived.Next() = 0;
    end;
}
