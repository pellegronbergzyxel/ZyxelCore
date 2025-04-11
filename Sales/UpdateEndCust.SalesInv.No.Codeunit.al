Codeunit 50097 "Update End Cust. Sales Inv. No"
{
    // 001. 11-04-19 ZY-LD P0217 - Created.


    trigger OnRun()
    begin
        //MESSAGE('%1',ZyWebServMgt.GetSalesInvoiceNo('ZyND UK','19-2002173'));
        SI.SetHideSalesDialog(true);
        UpdateSerialNoLines;
        //COMMIT;
        //UpdateSalesInvoiceHeader;
        SI.SetHideSalesDialog(false);
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        SI: Codeunit "Single Instance";

    local procedure UpdateSalesInvoiceHeader()
    var
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesInvHead2: Record "Sales Invoice Header";
        recBillToCust: Record Customer;
        recIcPartner: Record "IC Partner";
    begin
        begin
            recSalesInvHead.SetCurrentkey(recSalesInvHead."Serial Numbers Status", recSalesInvHead."Invoice No. for End Customer");
            recSalesInvHead.SetFilter(recSalesInvHead."Serial Numbers Status", '<>%1', recSalesInvHead."serial numbers status"::" ");
            recSalesInvHead.SetFilter(recSalesInvHead."Invoice No. for End Customer", '%1', '');
            if recSalesInvHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recSalesInvHead.Count);

                repeat
                    ZGT.UpdateProgressWindow(recSalesInvHead."No.", 0, true);

                    if recSalesInvHead."Sell-to Customer No." <> recSalesInvHead."Bill-to Customer No." then begin
                        if recBillToCust.Get(recSalesInvHead."Bill-to Customer No.") then
                            if recBillToCust."IC Partner Code" <> '' then
                                if recIcPartner.Get(recBillToCust."IC Partner Code") and
                                   (recIcPartner."Inbox Type" in [recIcPartner."inbox type"::Database, recIcPartner."inbox type"::"Web Service"]) then begin
                                    recSalesInvHead2 := recSalesInvHead;
                                    recSalesInvHead2."Invoice No. for End Customer" := ZyWebServMgt.GetSalesInvoiceNo(recIcPartner."Inbox Details", recSalesInvHead."No.");
                                    recSalesInvHead2.Modify;
                                end;
                    end else begin
                        recSalesInvHead2 := recSalesInvHead;
                        recSalesInvHead2."Invoice No. for End Customer" := recSalesInvHead."No.";
                        recSalesInvHead2.Modify;
                    end;
                until recSalesInvHead.Next() = 0;

                ZGT.CloseProgressWindow;
            end;
        end;
    end;

    local procedure UpdateSerialNoLines()
    var
        recSerialNo: Record "VCK Delivery Document SNos";
        recSerialNo2: Record "VCK Delivery Document SNos";
        recSalesShipLine: Record "Sales Shipment Line";
        recSalesInvLine: Record "Sales Invoice Line";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesInvHead2: Record "Sales Invoice Header";
        NoOfLines: Integer;
        SkipLoop: Boolean;
    begin
        recSalesInvHead.SetCurrentkey("Serial Numbers Status", "Invoice No. for End Customer");
        recSalesInvHead.SetRange("Serial Numbers Status", recSalesInvHead."serial numbers status"::Attached);
        //recSalesInvHead.SETFILTER("Invoice No. for End Customer",'<>%1','');
        recSalesInvHead2.LockTable;
        if recSalesInvHead.FindSet then begin
            ZGT.OpenProgressWindow('', recSalesInvHead.Count);

            recSerialNo.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
            repeat
                ZGT.UpdateProgressWindow(recSalesInvHead."No.", 0, true);

                recSalesInvLine.SetRange("Document No.", recSalesInvHead."No.");
                recSalesInvLine.SetRange(Type, recSalesInvLine.Type::Item);
                if recSalesInvLine.FindSet then
                    repeat
                        if recSalesShipLine.Get(recSalesInvLine."Shipment No.", recSalesInvLine."Shipment Line No.") then begin
                            recSerialNo.SetRange("Sales Order No.", recSalesShipLine."Order No.");
                            recSerialNo.SetRange("Sales Order Line No.", recSalesShipLine."Order Line No.");
                            if recSerialNo.FindFirst then begin
                                recSalesInvHead2 := recSalesInvHead;
                                recSalesInvHead2."Serial Numbers Status" := recSalesInvHead2."serial numbers status"::Attached;
                                repeat
                                    if recSerialNo."Grab By HQ" then begin
                                        recSalesInvHead2."Serial Numbers Status" := recSalesInvHead2."serial numbers status"::Accepted;
                                        SkipLoop := true;
                                    end;
                                until (recSerialNo.Next() = 0) or SkipLoop;
                                recSalesInvHead2.Modify;
                            end;
                        end;
                    until (recSalesInvLine.Next() = 0) or SkipLoop;

                SkipLoop := false;
            until recSalesInvHead.Next() = 0;

            ZGT.CloseProgressWindow;
        end;



        // recSerialNo.SetCurrentKey("Invoice No.","Grab By HQ");
        // recSerialNo.SETFILTER("Invoice No.",'%1','');
        // recSerialNo.SETRANGE("Grab By HQ",FALSE);
        // IF recSerialNo.FINDSET(TRUE) THEN BEGIN
        //  ZGT.OpenProgressWindow('',recSerialNo.COUNT);
        //  recSalesShipLine.SetCurrentKey("Order No.","Order Line No.");
        //  recSalesInvLine.SetCurrentKey("Shipment No.","Shipment Line No.");
        //  REPEAT
        //    ZGT.UpdateProgressWindow(recSerialNo."Serial No.",0,TRUE);
        //
        //    recSalesShipLine.SETRANGE("Order No.",recSerialNo."Sales Order No.");
        //    recSalesShipLine.SETRANGE("Order Line No.",recSerialNo."Sales Order Line No.");
        //    IF recSalesShipLine.FINDFIRST AND (recSalesShipLine.COUNT = 1) THEN BEGIN
        //      recSalesInvLine.SETRANGE("Shipment No.",recSalesShipLine."Document No.");
        //      recSalesInvLine.SETRANGE("Shipment Line No.",recSalesShipLine."Line No.");
        //      IF recSalesInvLine.FINDFIRST THEN BEGIN
        //        recSerialNo2 := recSerialNo;
        //        recSerialNo2."Invoice No." := recSalesInvLine."Document No.";
        //        recSerialNo2.MODIFY;
        //
        //        NoOfLines += 1;
        //        IF NoOfLines MOD 10000 = 0 THEN
        //          COMMIT;
        //      END;
        //    END;
        //  UNTIL recSerialNo.Next() = 0;
        //
        //  ZGT.CloseProgressWindow;
        // END;
    end;
}
