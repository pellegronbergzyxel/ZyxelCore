codeunit 50036 HQInvoiceJobQueue
{
    trigger OnRun()
    var
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        HQInvLine: Record "HQ Invoice Line";
        VCKShipDetail: Record "VCK Shipping Detail";
        TotalShippingQuantity: Decimal;
        PurchOrderNo: Code[20];
        PurchOrderNoList: List of [Code[20]];
    begin
        InvtSetup.Get();
        if (InvtSetup.GoodsInTransitLocationCode = '') or (not Location.Get(InvtSetup.GoodsInTransitLocationCode)) or
            (InvtSetup.GoodsInTransitInTransitCode = '') or (not Location.Get(InvtSetup.GoodsInTransitInTransitCode))
        then
            exit;

        HQInvLine.SetRange("Document Type", HQInvLine."Document Type"::Invoice);
        HQInvLine.SetFilter("Purchase Order No.", '<>''''');
        HQInvLine.SetFilter("Purchase Order Line No.", '>0');
        HQInvLine.SetRange("VCK Shipping Handled", false);
        if HQInvLine.FindSet() then begin
            VCKShipDetail.SetRange("Order Type", VCKShipDetail."Order Type"::"Purchase Order");
            repeat
                VCKShipDetail.SetRange("Invoice No.", HQInvLine."Document No.");
                VCKShipDetail.SetRange("Purchase Order No.", HQInvLine."Purchase Order No.");
                VCKShipDetail.SetRange("Purchase Order Line No.", HQInvLine."Purchase Order Line No.");
                if VCKShipDetail.FindFirst() then
                    if PurchLine.Get(PurchLine."Document Type"::Order, VCKShipDetail."Purchase Order No.", VCKShipDetail."Purchase Order Line No.") then begin
                        VCKShipDetail.CalcSums(Quantity);
                        TotalShippingQuantity := VCKShipDetail.Quantity;
                        if TotalShippingQuantity = PurchLine.Quantity then begin
                            if not PurchOrderNoList.Contains(PurchLine."Document No.") then
                                PurchOrderNoList.Add(PurchLine."Document No.");

                            if VCKShipDetail."Container No." <> '' then
                                PurchLine."Container No" := VCKShipDetail."Container No."
                            else
                                if VCKShipDetail."Bill of Lading No." <> '' then
                                    PurchLine."Container No" := VCKShipDetail."Bill of Lading No."
                                else
                                    PurchLine."Container No" := VCKShipDetail."Invoice No.";

                            if (PurchLine."Location Code" <> '') and (PurchLine."Location Code" <> InvtSetup.GoodsInTransitLocationCode) then begin
                                PurchLine.OriginalLocationCode := PurchLine."Location Code";
                                if InvtSetup.GoodsInTransitLocationCode <> '' then
                                    PurchLine.Validate("Location Code", InvtSetup.GoodsInTransitLocationCode);
                            end;

                            PurchLine.Modify();

                            HQInvLine.Mark(true);
                        end;
                    end;
            until HQInvLine.Next() = 0;

            foreach PurchOrderNo in PurchOrderNoList do begin
                PurchHeader.Get(PurchHeader."Document Type"::Order, PurchOrderNo);
                if not Codeunit.Run(Codeunit::"Purch.-Post", PurchHeader) then begin
                    HQInvLine.SetRange("Purchase Order No.", PurchHeader."No.");
                    HQInvLine.ClearMarks();
                end;
            end;

            HQInvLine.MarkedOnly(true);
            HQInvLine.ModifyAll("VCK Shipping Handled", true);
        end;
    end;
}
