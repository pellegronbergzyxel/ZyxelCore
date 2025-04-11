codeunit 50033 SalesSubscribers
{
    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure ReturnReceiptLine_OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine(var ReturnReceiptLine: Record "Return Receipt Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var IsHandled: Boolean)
    var
        InvtSetup: Record "Inventory Setup";
        ReturnOrderNoLbl: Label 'Return Order No. %1: ';
    begin
        InvtSetup.Get();
        if ReturnReceiptLine."Location Code" = InvtSetup."AIT Location Code" then
            ReturnReceiptLine.Description := StrSubstNo(ReturnOrderNoLbl, ReturnReceiptLine."Return Order No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lines Instruction Mgt.", 'OnBeforeSalesCheckAllLinesHaveQuantityAssigned', '', false, false)]
    local procedure LinesInstructionMgt_OnBeforeSalesCheckAllLinesHaveQuantityAssigned(SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SalesLine: Record "Sales Line";
        SalesLineError: Text;
        NoReturnReasonCodeErr: Label 'The Credit Memo Cannot be Posted becasue line %1 has no Return Reason Code.';
    begin
        SalesLineError := 'NOERROR';
        SalesLine.SetFilter("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Credit Memo");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst() then begin
            repeat
                if SalesLine."Return Reason Code" = '' then SalesLineError := Format(SalesLine."Line No." / 10000);
            until SalesLine.Next() = 0;
        end;
        if SalesLineError <> 'NOERROR' then
            Error(NoReturnReasonCodeErr, SalesLineError);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure SalesShipmentLine_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    var
        recInvSetup: Record "Inventory Setup";
        recSalesShipLine: Record "Sales Shipment Line";
        recSellToCust: Record Customer;
        TranslationHelper: Codeunit "Translation Helper";
        Text000: Label 'Shipment No. %1:';
        zText001: Label 'Shipment No. %1, Order No. %2:';
    begin
        //RD 1.0
        //>> 19-08-19 ZY-LD 005
        //IF "Location Code" = 'EU2' THEN
        recInvSetup.Get();
        //>> 23-09-20 ZY-LD 008
        recSalesShipLine.SetRange("Document No.", SalesShptLine."Document No.");
        recSalesShipLine.SetRange(Type, recSalesShipLine.Type::Item);
        recSalesShipLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');
        if not recSalesShipLine.FindFirst() then;
        //<< 23-09-20 ZY-LD 008
        TranslationHelper.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
        if recSalesShipLine."Location Code" = recInvSetup."AIT Location Code" then begin  //<< 19-08-19 ZY-LD 005
            if recSellToCust.Get(recSalesShipLine."Sell-to Customer No.") and recSellToCust."Create Invoice pr. Order" and (recSalesShipLine."Order No." <> '') then  // 18-06-20 ZY-LD 006
                SalesLine.Description := StrSubstNo(zText001, recSalesShipLine."Picking List No.", recSalesShipLine."Order No.")  // 18-06-20 ZY-LD 006
            else
                SalesLine.Description := StrSubstNo(Text000, recSalesShipLine."Picking List No.");
        end else
            SalesLine.Description := StrSubstNo(Text000, SalesShptLine."Document No.");
        TranslationHelper.RestoreGlobalLanguage();
        //RD 1.0
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', false, false)]
    local procedure SalesShipmentLine_OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean; var TransferOldExtTextLines: Codeunit "Transfer Old Ext. Text Lines")
    begin
        //ZL100805A+
        SalesLine."Picking List No." := SalesShptLine."Picking List No.";
        SalesLine."Packing List No." := SalesShptLine."Packing List No.";
        SalesLine."External Document No." := SalesShptLine."External Document No.";
        SalesLine."Sales Order Type" := SalesShptLine."Sales Order Type"; //RD
        SalesLine."Ship-to Code" := SalesShptLine."Ship-to Code";  //RD
        //ZL100805A-
        SalesLine."Hide Line" := SalesShptLine."Hide Line";  // 18-09-20 ZY-LD 007
        SalesLine."External Document Position No." := SalesShptLine."External Document Position No.";  // 04-08-21 ZY-LD 010
    end;
}
