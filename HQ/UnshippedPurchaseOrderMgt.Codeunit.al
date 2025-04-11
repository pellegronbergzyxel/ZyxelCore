codeunit 50038 "Unshipped Purchase Order Mgt."
{
    trigger OnRun()
    begin
        SplitPurchaseOrderLine();
    end;

    local procedure SplitPurchaseOrderLine()
    var
        UnshipPurchOrder: Record "Unshipped Purchase Order";
        UnshipPurchOrderNext: Record "Unshipped Purchase Order";
        PurchHead: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        NewPurchLine: Record "Purchase Line";
        OrgPurchLine: Record "Purchase Line";
        InboundComp: Record "Inbound Comparition";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        PurchaseLineEvent: Codeunit "Purchase Header/Line Events";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        ZGT: Codeunit "ZyXEL General Tools";
        ReleaseAfterChange: Boolean;
        NextResult: Integer;
        lText001: Label 'Quantity is not matching on %1 %2 before splitting the order.';
        lText002: Label 'Quantity is not matching on %1 %2 after splitting the order.';
    begin
        InboundComp.UpdateTable();  // Update the comparition table before split.

        InboundComp.SetAutoCalcFields("Order Outstanding Quantity", "Order Outstanding Qty. Split", "Unshipped Quantity", "Unposted Goods in Transit", "Unrelated Order Outst. Qty.");
        UnshipPurchOrderNext.SetCurrentKey("Purchase Order No.", "Purchase Order Line No.", "ETA Date");
        UnshipPurchOrder.SetCurrentKey("Purchase Order No.", "Purchase Order Line No.", "ETA Date");
        //UnshipPurchOrder.SetRange("Vendor Type", UnshipPurchOrder."Vendor Type"::ZCom, UnshipPurchOrder."Vendor Type"::ZNet);
        if UnshipPurchOrder.FindSet() then begin
            ZGT.OpenProgressWindow('', UnshipPurchOrder.Count);
            repeat
                ZGT.UpdateProgressWindow(UnshipPurchOrder."Purchase Order No.", 0, true);

                if (InboundComp."Document No." <> UnshipPurchOrder."Purchase Order No.") OR (InboundComp."Original Line No." <> UnshipPurchOrder."Purchase Order Line No.") then begin
                    IF (InboundComp."Document No." <> UnshipPurchOrder."Purchase Order No.") then begin
                        if PurchHead.get(PurchHead."Document Type"::Order, UnshipPurchOrder."Purchase Order No.") and
                          (PurchHead.Status = PurchHead.Status::Released)
                        then begin
                            ReleasePurchaseDocument.PerformManualReopen(PurchHead);
                            PurchaseLineEvent.DeleteWarehouseReceipt(PurchHead);  // This function might be removed when we invoice from HQ Sales Invoice.
                            ReleaseAfterChange := true;
                        end;
                    end;

                    InboundComp.get(UnshipPurchOrder."Purchase Order No.", UnshipPurchOrder."Purchase Order Line No.");
                    if InboundComp."Order Outstanding Quantity" + InboundComp."Order Outstanding Qty. Split" <> InboundComp."Unshipped Quantity" + InboundComp."Unposted Goods in Transit" then
                        Error(lText001, UnshipPurchOrder."Purchase Order No.", UnshipPurchOrder."Purchase Order Line No.");
                end;

                // We move quantity related to GIT into it´s own purchase order line. Then it´s easier to update the quantity on the unshipped lines.
                if InboundComp."Unposted Goods in Transit" <> InboundComp."Unrelated Order Outst. Qty." then begin
                    OrgPurchLine.get(OrgPurchLine."Document Type"::Order, UnshipPurchOrder."Purchase Order No.", UnshipPurchOrder."Purchase Order Line No.");
                    PurchLine2 := OrgPurchLine;
                    PurchLine2.Validate("Line No.", GetNextLineNo(UnshipPurchOrder."Purchase Order No."));
                    PurchLine2.OriginalLineNo := UnshipPurchOrder."Purchase Order Line No.";
                    PurchLine2.Validate(Quantity, InboundComp."Unposted Goods in Transit" - InboundComp."Unrelated Order Outst. Qty.");
                    PurchLine2.Validate("ETD Date", UnshipPurchOrder."ETD Date");
                    if UnshipPurchOrder."ETA Date" = 20991231D then
                        PurchLine2.Validate(ETA, 0D)
                    else
                        PurchLine2.Validate(ETA, UnshipPurchOrder."ETA Date");
                    PurchLine2.Validate("Expected Receipt Date", UnshipPurchOrder."Expected Receipt Date");
                    PurchLine2.Validate("Direct Unit Cost", UnshipPurchOrder."Unit Price");
                    PurchLine2.insert(true);
                end;

                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange("Document No.", UnshipPurchOrder."Purchase Order No.");
                PurchLine.SetRange(OriginalLineNo, UnshipPurchOrder."Purchase Order Line No.");
                PurchLine.SetRange("Sales Order Line ID", UnshipPurchOrder."Sales Order Line ID");
                if not PurchLine.FindFirst() then begin
                    OrgPurchLine.get(OrgPurchLine."Document Type"::Order, UnshipPurchOrder."Purchase Order No.", UnshipPurchOrder."Purchase Order Line No.");
                    if OrgPurchLine.Quantity <> 0 then begin
                        // We know from the inbound comparition line that quantity is matching.
                        OrgPurchLine.Validate("Original Quantity", OrgPurchLine.Quantity);
                        OrgPurchLine.Validate(Quantity, 0);
                        OrgPurchLine.Modify(true);
                    end;

                    PurchLine := OrgPurchLine;
                    PurchLine.Validate("Line No.", GetNextLineNo(UnshipPurchOrder."Purchase Order No."));
                    PurchLine.OriginalLineNo := UnshipPurchOrder."Purchase Order Line No.";
                    PurchLine."Sales Order Line ID" := UnshipPurchOrder."Sales Order Line ID";
                    PurchLine.Insert(true);
                end;

                PurchLine.Validate(Quantity, UnshipPurchOrder.Quantity);
                PurchLine.Validate("ETD Date", UnshipPurchOrder."ETD Date");
                if UnshipPurchOrder."ETA Date" = 20991231D then
                    PurchLine.Validate(ETA, 0D)
                else
                    PurchLine.Validate(ETA, UnshipPurchOrder."ETA Date");
                PurchLine.Validate("Expected Receipt Date", UnshipPurchOrder."Expected Receipt Date");
                PurchLine.Validate("Direct Unit Cost", UnshipPurchOrder."Unit Price");
                PurchLine.Modify(true);

                UnshipPurchOrderNext := UnshipPurchOrder;
                if UnshipPurchOrderNext.Next() = 0 then
                    Clear(UnshipPurchOrderNext);
                if (UnshipPurchOrderNext."Purchase Order No." <> UnshipPurchOrder."Purchase Order No.") OR (UnshipPurchOrderNext."Purchase Order Line No." <> UnshipPurchOrder."Purchase Order Line No.") then begin
                    InboundComp.CalcFields("Order Outstanding Quantity", "Order Outstanding Qty. Split", "Unshipped Quantity", "Unposted Goods in Transit");
                    if InboundComp."Order Outstanding Quantity" + InboundComp."Order Outstanding Qty. Split" <> InboundComp."Unshipped Quantity" + InboundComp."Unposted Goods in Transit" then
                        Error(lText002, UnshipPurchOrder."Purchase Order No.", UnshipPurchOrder."Purchase Order Line No.");

                    if (UnshipPurchOrderNext."Purchase Order No." <> UnshipPurchOrder."Purchase Order No.") and ReleaseAfterChange then begin
                        ReleasePurchaseDocument.PerformManualRelease(PurchHead);
                        GetSourceDocInbound.CreateFromPurchOrderHideDialog(PurchHead);  // This function might be removed when we invoice from HQ Sales Invoice.
                        ReleaseAfterChange := false;
                    end;
                end;
            until UnshipPurchOrder.Next() = 0;
            ZGT.CloseProgressWindow();
        end;
    end;

    local procedure GetNextLineNo(pDocNo: Code[20]) rValue: Integer
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", pDocNo);
        if PurchLine.FindLast() then
            rValue := PurchLine."Line No." + 10000
        else
            rValue := 10000;
    end;
}
