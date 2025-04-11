Codeunit 50073 "Transfer Event"
{
    // 001. 15-01-18 ZY-LD 2018011510000061 - Additional lines.
    // 002. 03-04-18 ZY-LD 2018040310000079 - No additional lines on RMA.
    // 003. 20-11-18 ZY-LD 2018111910000071 - Forecast Territory.
    // 004. 03-05-19 ZY-LD P0218 - Set Serial No Attached.
    // 005. 01-05-19 ZY-LD P0226 - Send request to VCK.
    // 006. 14-10-20 ZY-LD P0499 - Update Picking Date Table.
    // 007. 07-12-20 ZY-LD 2020112710000079 - Block for transfer if we don´t have a VAT Registration No. for the country.
    // 008. 24-08-22 ZY-LD 000 - Make receipt ready so HQ can collect the serial numbers.
    // 009. 08-09-23 ZY-LD 000 - It must be able to change in special cases.
    // 010. 19-10-23 ZY-LD 000 - If transfer order is in transit from HQ, Container Details must be created.

    Permissions = TableData "Picking Date Confirmed" = rimd;

    trigger OnRun()
    begin
    end;

    local procedure ">> Transfer Head"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterValidateEvent', 'Transfer-to Code', false, false)]
    local procedure OnAfterValidateTransferToCode(var Rec: Record "Transfer Header"; var xRec: Record "Transfer Header"; CurrFieldNo: Integer)
    var
        recLocation: Record Location;
    begin
        //>> 12-01-21 ZY-LD 006
        if recLocation.Get(Rec."Transfer-to Code") then
            Rec."Shipment Method Code" := recLocation."Shipment Method Code";
        //<< 12-01-21 ZY-LD 006
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterValidateEvent', 'Transfer-to Address Code', false, false)]
    local procedure OnAfterValidateTransferToAddressCode(var Rec: Record "Transfer Header"; var xRec: Record "Transfer Header"; CurrFieldNo: Integer)
    var
        recTranstoAddr: Record "Transfer-to Address";
    begin
        begin
            //>> 08-01-21 ZY-LD 006
            if Rec."Transfer-to Address Code" <> '' then begin
                recTranstoAddr.Get(Rec."Transfer-to Code", Rec."Transfer-to Address Code");
                Rec."Transfer-to Name" := recTranstoAddr.Name;
                Rec."Transfer-to Name 2" := recTranstoAddr."Name 2";
                Rec."Transfer-to Address" := recTranstoAddr.Address;
                Rec."Transfer-to Address 2" := recTranstoAddr."Address 2";
                Rec."Transfer-to City" := recTranstoAddr.City;
                Rec."Transfer-to Post Code" := recTranstoAddr."Post Code";
                Rec."Transfer-to County" := recTranstoAddr.County;
                Rec.Validate(Rec."Trsf.-to Country/Region Code", recTranstoAddr."Country/Region Code");
                Rec."Transfer-to Contact" := recTranstoAddr.Contact;
                Rec."Shipment Method Code" := recTranstoAddr."Shipment Method Code";
                Rec."Shipping Agent Code" := recTranstoAddr."Shipping Agent Code";
                Rec."Shipping Agent Service Code" := recTranstoAddr."Shipping Agent Service Code";
            end else
                Rec.Validate(Rec."Transfer-to Code");
            //<< 08-01-21 ZY-LD 006
        end;
    end;

    local procedure ">> Transfer Line"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModityTransferLine(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; RunTrigger: Boolean)
    begin
        UpdatePickingDateConfirmation(Rec, xRec);  // 14-10-20 ZY-LD 006
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteTransferLine(var Rec: Record "Transfer Line"; RunTrigger: Boolean)
    var
        recPickDateConf: Record "Picking Date Confirmed";
    begin
        //>> 14-10-20 ZY-LD 006
        if recPickDateConf.Get(recPickDateConf."source type"::"Transfer Order", Rec."Document No.", Rec."Line No.") then
            recPickDateConf.Delete(true);
        //<< 14-10-20 ZY-LD 006
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnBeforeValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnBeforeValidateShipmentDateConfirmed(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        PickDateConfMgt: Codeunit "Pick. Date Confirm Management";
        SI: Codeunit "Single Instance";
    begin
        begin
            //>> 14-10-20 ZY-LD 006
            if SI.GetValidateFromPage then begin
                Rec.TestStatusOpen;
                if Rec."Shipment Date Confirmed" then
                    if not PickDateConfMgt.PerformManuelConfirm2(1, '') then;
            end;
            //<< 14-10-20 ZY-LD 006

            //>> 12-01-21 ZY-LD 006
            if not Rec."Shipment Date Confirmed" then begin
                Rec.CalcFields(Rec."Warehouse Status");
                if Rec."Warehouse Status" = Rec."warehouse status"::New then begin
                    recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
                    recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
                    if recDelDocLine.FindFirst then begin
                        Rec."Delivery Document No." := '';
                        recDelDocLine.Delete;
                    end;
                end;
            end;
            //<< 12-01-21 ZY-LD 006
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnAfterValidateShipmentDateConfirmed(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    var
        recTransHead: Record "Transfer Header";
        DeliveryDocMgt: Codeunit "Delivery Document Management";
        SI: Codeunit "Single Instance";
    begin
        begin
            //>> 14-10-20 ZY-LD 006
            if Rec."Shipment Date Confirmed" and
               (Rec."Document No." <> '')
            then begin
                if SI.GetUpdateShipmentDate then begin
                    recTransHead.Get(Rec."Document No.");
                    Rec."Shipment Date" :=
                      DeliveryDocMgt.CalcShipmentDate(
                        '',
                        Rec."Item No.",
                        recTransHead."Trsf.-to Country/Region Code",
                        Rec."Shortcut Dimension 1 Code",
                        Rec."Shipment Date",
                        true);
                end;
            end else
                Rec."Shipment Date" := 0D;
            Rec.Modify(true);
            //<< 14-10-20 ZY-LD 006
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure OnAfterValidateItemNo(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        InsertAdditionalItem(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateQuantity(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: label 'Delivery Document %1 is released, so you are not able to change the quantity.';
        lText002: label 'The quantity on the delivery document %1 i updated.';
        lText003: Label 'ENU=\\Do you want to continue?';
    begin
        //>> 02-12-20 ZY-LD 006
        if Rec.Quantity <> xRec.Quantity then begin
            recDelDocLine.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
            recDelDocLine.SetRange("Document Type", recDelDocLine."document type"::Transfer);
            recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
            recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
            recDelDocLine.SetAutocalcFields("Document Status");
            if recDelDocLine.FindFirst then
                if recDelDocLine."Document Status" = recDelDocLine."document status"::New then begin
                    recDelDocLine.Validate(Quantity, Rec.Quantity);
                    recDelDocLine.Modify(true);
                    Message(lText002, recDelDocLine."Document No.");
                end else
                    //>> 08-09-23 ZY-LD 009
                    IF ZGT.UserIsDeveloper THEN BEGIN
                        IF NOT CONFIRM(lText001 + lText003, FALSE, recDelDocLine."Document No.") THEN
                            ERROR(lText001, recDelDocLine."Document No.");
                    END ELSE  //<< 08-09-23 ZY-LD 009
                        Error(lText001, recDelDocLine."Document No.");
        end;
        //<< 02-12-20 ZY-LD 006
    end;

    local procedure InsertAdditionalItem(var Rec: Record "Transfer Line"; xRec: Record "Transfer Line")
    var
        recAdditionalItems: Record "Additional Item";
        recTransHead: Record "Transfer Header";
        recTransLine: Record "Transfer Line";
        recTransLine2: Record "Transfer Line";
        recTransLine3: Record "Transfer Line";
        LoopNo: Integer;
    begin
        begin
            if Rec."Additional Item Line No." = 0 then begin
                if Rec."Line No." = 0 then begin
                    recTransLine2.SetRange("Document No.", Rec."Document No.");
                    if recTransLine2.IsEmpty then
                        Rec."Line No." := 10000;
                    Rec.Insert(true);
                end;

                if Rec."Item No." <> '' then begin
                    recTransHead.Get(Rec."Document No.");
                    //>> 20-11-18 ZY-LD 003
                    //recAdditionalItems.SETRANGE("Ship-to Country/Region",recTransHead."Trsf.-to Country/Region Code");
                    recAdditionalItems.SetFilter("Ship-to Country/Region", '%1|%2', '', recTransHead."Trsf.-to Country/Region Code");
                    recAdditionalItems.SetFilter("Forecast Territory", '%1|%2', '', recTransHead."Transfer-to Forecast Territory");
                    //<< 20-11-18 ZY-LD 003
                    recAdditionalItems.SetRange("Item No.", Rec."Item No.");
                    if recAdditionalItems.FindSet and
                       ((StrPos(recTransHead."Transfer-from Code", 'RMA') = 0) and (StrPos(recTransHead."Transfer-to Code", 'RMA') = 0))  // 03-04-18 ZY-LD 001
                    then
                        repeat
                            LoopNo += 1;

                            recTransLine2.Reset;
                            recTransLine2.SetRange("Document No.", Rec."Document No.");
                            recTransLine2.SetRange("Additional Item Line No.", Rec."Line No.");
                            recTransLine2.SetRange("Item No.", recAdditionalItems."Additional Item No.");
                            if not recTransLine2.FindFirst then begin
                                recTransLine.Validate("Document No.", Rec."Document No.");
                                recTransLine.Validate("Line No.", Rec."Line No." + LoopNo);
                                recTransLine.Validate("Item No.", recAdditionalItems."Additional Item No.");
                                recTransLine.Validate(Quantity, recAdditionalItems.Quantity);
                                recTransLine."Additional Item Line No." := Rec."Line No.";
                                if not recTransLine.Insert(true) then;
                            end;
                        until recAdditionalItems.Next() = 0;
                end;
            end;
        end;
    end;


    procedure OnAfterDeleteTransferLinesPage(var Rec: Record "Transfer Line")
    var
        recTransLine: Record "Transfer Line";
        lText001: label 'ItÍs not allowed to delete an additional line.';
        recDelDocLine: Record "VCK Delivery Document Line";
        lText002: label 'The transfer line is created on delivery document %1. You must delete the delivery document line before you delete the transfer line.';
    begin
        begin
            // Additional item line must not be deleted seperatly
            if Rec."Additional Item Line No." <> 0 then begin
                recTransLine.SetRange("Document No.", Rec."Document No.");
                recTransLine.SetRange("Line No.", Rec."Additional Item Line No.");
                if recTransLine.FindFirst then
                    Error(lText001);
            end;

            // Delete additional item lines
            if Rec."Line No." <> 0 then begin
                recTransLine.SetRange("Document No.", Rec."Document No.");
                recTransLine.SetRange("Additional Item Line No.", Rec."Line No.");
                if recTransLine.FindSet(true) then
                    repeat
                        recTransLine.Delete(true);
                    until recTransLine.Next() = 0;
            end;

            //>> 12-01-21 ZY-LD 072
            // A delivery document line must be deleted before the sales line.
            recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
            recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
            //recDelDocLine.SETAUTOCALCFIELDS("Warehouse Status");
            if recDelDocLine.FindFirst and (recDelDocLine.Quantity <> 0) then
                if Rec."Warehouse Status" = Rec."warehouse status"::New then
                    recDelDocLine.Delete(true)
                else
                    Error(lText002, recDelDocLine."Document No.");
            //<< 12-01-21 ZY-LD 072

        end;
    end;

    local procedure ">>Page"()
    begin
    end;

    [EventSubscriber(Objecttype::Page, 5740, 'OnAfterActionEvent', 'Reo&pen', false, false)]
    local procedure OnAfterActionEventReOpen_Page5740(var Rec: Record "Transfer Header")
    begin
        DeleteWarehouseShipment(Rec);  // 12-01-21 ZY-LD 006
    end;

    [EventSubscriber(Objecttype::Page, 5741, 'OnBeforeValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnBeforeValidateShipmentDateConfirmed_Page5741(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        PickDateConfMgt: Codeunit "Pick. Date Confirm Management";
    begin
        begin
            //>> 14-10-20 ZY-LD 006
            //  TestStatusOpen;
            //  IF "Shipment Date Confirmed" THEN
            //    IF NOT PickDateConfMgt.PerformManuelConfirm2(1,'') THEN;
            //<< 14-10-20 ZY-LD 006
        end;
    end;

    [EventSubscriber(Objecttype::Page, 5741, 'OnAfterValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnAfterValidateShipmentDateConfirmed_Page5741(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetUpdateShipmentDate(false);  // 14-10-20 ZY-LD 006
    end;

    [EventSubscriber(Objecttype::Page, 5740, 'OnAfterActionEvent', 'Reo&pen', false, false)]
    local procedure OnAfterActionEventReOpen_Page5741(var Rec: Record "Transfer Header")
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        DeleteWarehouseShipment(Rec);  // 12-01-21 ZY-LD 006
    end;

    local procedure ">>Release"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnBeforeReleaseTransferDoc', '', false, false)]
    local procedure OnBeforeReleaseTransferDoc(var TransferHeader: Record "Transfer Header")
    var
        recCountry: Record "Country/Region";
        lText001: label 'There are not registered a Zyxel "VAT Registration No." for country code "%1", and you many therefor not transfer items to this country due to VAT roules.';
        recLocation: Record Location;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsRhq then begin
            //>> 07-12-20 ZY-LD 007
            if ZGT.IsZComCompany then begin
                TransferHeader.TestField(TransferHeader."Trsf.-to Country/Region Code");
                recCountry.Get(TransferHeader."Trsf.-to Country/Region Code");
                if (recCountry."EU Country/Region Code" <> '') and (recCountry."VAT Registration No." = '') then
                    Error(lText001, TransferHeader."Trsf.-to Country/Region Code");
            end;
            //<< 07-12-20 ZY-LD 007

            //>> 12-01-21 ZY-LD 006
            if recLocation.RequireShipment(TransferHeader."Transfer-from Code") then
                TransferHeader.TestField(TransferHeader."Shipment Method Code");
            //<< 12-01-21 ZY-LD 006
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnAfterReleaseTransferDoc', '', false, false)]
    local procedure OnAfterReleaseTransferDoc(var TransferHeader: Record "Transfer Header")
    var
        recLocation: Record Location;
        recWhseInbHead: Record "Warehouse Inbound Header";
        recWhseInbLine: Record "VCK Shipping Detail";
        recInvSetup: Record "Inventory Setup";  // 19-10-23 ZY-LD 010
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        DelDocMgt: Codeunit "Delivery Document Management";
        lText001: label 'The document is awaiting "Picking Confirmation".\You will receive an e-mail when the delivery document is sent to the warehouse.';
        lText002: label 'The delivery document %1 has been sent to the warehouse.';
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        begin
            GetSourceDocOutbound.CreateFromOutbndTransferOrderHideDialog(TransferHeader);

            if recLocation.RequireShipment(TransferHeader."Transfer-from Code") then begin
                //>> 14-10-20 ZY-LD 006
                recLocation.Get(TransferHeader."Transfer-from Code");
                DelDocMgt.CreateDeliveryDocumentTransfer(TransferHeader."No.");
            end;

            if recLocation.RequireReceive(TransferHeader."Transfer-to Code") then begin
                recWhseInbLine.SetCurrentkey("Purchase Order No.");
                recWhseInbLine.SetRange("Order Type", recWhseInbLine."Order Type");
                recWhseInbLine.SetRange("Purchase Order No.", TransferHeader."No.");

                recInvSetup.get;  // 19-10-23 ZY-LD 010
                TransferHeader.CalcFields(TransferHeader."Completely Shipped");
                if (not recWhseInbLine.FindFirst and TransferHeader."Completely Shipped") OR
                   (recInvSetup.GoodsInTransitLocationCode = TransferHeader."Transfer-from Code")  // 19-10-23 ZY-LD 010
                 then begin
                    recLocation.Get(TransferHeader."Transfer-to Code");
                    recWhseInbHead.SetRange("Container No.", TransferHeader."No.");
                    if recWhseInbHead.IsEmpty then
                        case recLocation.Warehouse of
                            recLocation.Warehouse::VCK:
                                ZyWebServMgt.SendContainerDetails(CompanyName(), 3, TransferHeader."No.");
                        end;
                end;
            end;
        end;

    end;

    local procedure ">>Post"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', false, false)]
    local procedure OnBeforePostYesNoTransferDoc()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetPostedManually(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPostYesNoTransferDoc()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetPostedManually(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post + Print", 'OnBeforePost', '', false, false)]
    local procedure OnBeforePostPrintTransferDoc()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetPostedManually(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post + Print", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPostPrintTransferDoc()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetPostedManually(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeTransferOrderPostShipment', '', false, false)]
    local procedure OnBeforePostTransferShipment(var TransferHeader: Record "Transfer Header")
    var
        recLocation: Record Location;
        lText001: label 'The document will automatic be posted via EDI when "Warehouse Status" is "In Transit". If you need to post it manually, you have to do it via "Warehouse Shipment".';
        SI: Codeunit "Single Instance";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        begin
            if SI.GetPostedManually then
                if (ItemLogisticEvents.GetMainWarehouseLocation = TransferHeader."Transfer-from Code") or
                   (ItemLogisticEvents.GetMainWarehouseLocation = TransferHeader."Transfer-to Code")
                then
                    if recLocation.RequireShipment(TransferHeader."Transfer-from Code") then
                        Error(lText001);

            //>> 07-05-18 ZY-LD 002 - We always want a country/region Code.
            TransferHeader.TestField(TransferHeader."Trsf.-from Country/Region Code");
            TransferHeader.TestField(TransferHeader."Trsf.-to Country/Region Code");
            //<< 07-05-18 ZY-LD 002
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    local procedure OnAfterPostTransferShipment(var TransferHeader: Record "Transfer Header")
    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        begin
            GetSourceDocInbound.CreateFromInbndTransferOrderHideDialog(TransferHeader);

            //>> 30-11-20 ZY-LD 006
            recWhseInbHead.SetRange("Container No.", TransferHeader."No.");
            if recWhseInbHead.IsEmpty then
                ZyWebServMgt.SendContainerDetails(CompanyName(), 3, TransferHeader."No.");
            //<< 30-11-20 ZY-LD 006
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransferOrderPostReceipt', '', false, false)]
    local procedure OnBeforePostTransferReceipt(var TransferHeader: Record "Transfer Header")
    var
        recLocation: Record Location;
        recInvSetup: Record "Inventory Setup";
        SI: Codeunit "Single Instance";
        lText001: label 'The document will automatic be posted via EDI when "Warehouse Status" is "On Stock". If you need to post it manually, you have to do it via "Warehouse Receipts".';
        lText002: label 'The document will automatic be posted via EDI when "Warehouse Status" is "Delivered". If you need to post it manually, you have to do it via "Warehouse Shipment".';
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        lText003: label '\\Do you want to continue?';
    begin
        begin
            if SI.GetPostedManually then
                if (ItemLogisticEvents.GetMainWarehouseLocation = TransferHeader."Transfer-from Code") or
                   (ItemLogisticEvents.GetMainWarehouseLocation = TransferHeader."Transfer-to Code")
                then begin
                    if recLocation.RequireReceive(TransferHeader."Transfer-to Code") then
                        if not Confirm(lText001 + lText003) then
                            Error('');

                    if recLocation.RequireShipment(TransferHeader."Transfer-from Code") then
                        if not Confirm(lText002 + lText003) then
                            Error('');
                end;

            //>> 07-05-18 ZY-LD 002 - We always want a country/region Code.
            TransferHeader.TestField(TransferHeader."Trsf.-from Country/Region Code");
            TransferHeader.TestField(TransferHeader."Trsf.-to Country/Region Code");
            //<< 07-05-18 ZY-LD 002
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', false, false)]
    local procedure OnAfterPostTransferReceipt(var TransferHeader: Record "Transfer Header")
    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        recTransRcptHead: Record "Transfer Receipt Header";
    begin
        begin
            recWhseInbHead.SetRange("Shipment No.", TransferHeader."No.");
            if recWhseInbHead.FindFirst then begin
                recWhseInbHead.Validate("Document Status", recWhseInbHead."document status"::Posted);
                recWhseInbHead.Modify(true);
            end;

            //>> 24-08-22 ZY-LD 008
            recTransRcptHead.SetRange("Transfer Order No.", TransferHeader."No.");
            recTransRcptHead.SetAutocalcFields("Serial No. Attached");
            if recTransRcptHead.FindLast and recTransRcptHead."Serial No. Attached" then begin
                recTransRcptHead."Serial Numbers Status" := recTransRcptHead."serial numbers status"::Attached;
                recTransRcptHead.Modify;
            end;
            //<< 24-08-22 ZY-LD 008
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertTransferReceiptHead(var Rec: Record "Transfer Receipt Header"; RunTrigger: Boolean)
    begin
        //>> 03-05-19 ZY-LD 004
        begin
            if SerialNoAttached(Rec."No.") then
                Rec."Serial Numbers Status" := Rec."serial numbers status"::Attached;
        end;
        //<< 03-05-19 ZY-LD 004
    end;

    local procedure SerialNoAttached(pTransRcptNo: Code[20]): Boolean
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recSerialNo: Record "VCK Delivery Document SNos";
    begin
        //>> 03-05-19 ZY-LD 004
        recDelDocLine.SetCurrentkey("Transfer Order No.");
        recDelDocLine.SetRange("Transfer Order No.", pTransRcptNo);
        if recDelDocLine.FindSet then begin
            recSerialNo.SetCurrentkey("Delivery Document No.", "Delivery Document Line No.");
            repeat
                recSerialNo.SetRange("Delivery Document No.", recDelDocLine."Document No.");
                recSerialNo.SetRange("Delivery Document Line No.", recDelDocLine."Line No.");
                if recSerialNo.FindFirst then
                    exit(true);
            until recDelDocLine.Next() = 0;
        end;
        //<< 03-05-19 ZY-LD 004
    end;

    local procedure ">> Function"()
    begin
    end;

    local procedure UpdatePickingDateConfirmation(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        recPickDateConf: Record "Picking Date Confirmed";
        recLocation: Record Location;
        Modified: Boolean;
    begin
        begin
            //>> 14-10-20 ZY-LD 006
            if recLocation.Get(Rec."Transfer-from Code") and (recLocation.Warehouse = recLocation.Warehouse::VCK) then
                if (Rec."Item No." <> '') and (Rec."Additional Item Line No." = 0) then begin
                    if not recPickDateConf.Get(recPickDateConf."source type"::"Transfer Order", Rec."Document No.", Rec."Line No.") then begin
                        if Rec."Outstanding Quantity" > 0 then begin
                            recPickDateConf.Init;
                            recPickDateConf."Source Type" := recPickDateConf."source type"::"Transfer Order";
                            recPickDateConf."Source No." := Rec."Document No.";
                            recPickDateConf."Source Line No." := Rec."Line No.";
                            recPickDateConf."Item No." := Rec."Item No.";
                            recPickDateConf."Location Code" := Rec."Transfer-from Code";
                            recPickDateConf."Picking Date" := Rec."Shipment Date";
                            recPickDateConf."Picking Date Confirmed" := Rec."Shipment Date Confirmed";
                            recPickDateConf."Outstanding Quantity" := Rec."Outstanding Quantity";
                            recPickDateConf."Outstanding Quantity (Base)" := Rec."Outstanding Qty. (Base)";
                            recPickDateConf.Insert(true);
                        end;
                    end else begin
                        if recPickDateConf."Item No." <> Rec."Item No." then begin
                            recPickDateConf."Item No." := Rec."Item No.";
                            Modified := true;
                        end;
                        if recPickDateConf."Location Code" <> Rec."Transfer-from Code" then begin
                            recPickDateConf."Location Code" := Rec."Transfer-from Code";
                            Modified := true;
                        end;
                        if recPickDateConf."Picking Date" <> Rec."Shipment Date" then begin
                            recPickDateConf."Picking Date" := Rec."Shipment Date";
                            Modified := true;
                        end;
                        if recPickDateConf."Picking Date Confirmed" <> Rec."Shipment Date Confirmed" then begin
                            recPickDateConf."Picking Date Confirmed" := Rec."Shipment Date Confirmed";
                            recPickDateConf."Marked Entry" := false;
                            Modified := true;
                        end;
                        if recPickDateConf."Outstanding Quantity" <> Rec."Outstanding Quantity" then begin
                            recPickDateConf."Outstanding Quantity" := Rec."Outstanding Quantity";
                            Modified := true;
                        end;
                        if recPickDateConf."Outstanding Quantity (Base)" <> Rec."Outstanding Qty. (Base)" then begin
                            recPickDateConf."Outstanding Quantity (Base)" := Rec."Outstanding Qty. (Base)";
                            Modified := true;
                        end;

                        if Modified then
                            if (recPickDateConf."Outstanding Quantity" = 0) and (recPickDateConf."Outstanding Quantity (Base)" = 0) then
                                recPickDateConf.Delete(true)
                            else
                                recPickDateConf.Modify(true);
                    end;
                end else
                    if recPickDateConf.Get(recPickDateConf."source type"::"Transfer Order", Rec."Document No.", Rec."Line No.") then
                        recPickDateConf.Delete(true);
            //<< 14-10-20 ZY-LD 006
        end;
    end;

    local procedure DeleteWarehouseShipment(var Rec: Record "Transfer Header")
    var
        recWhseShipHead: Record "Warehouse Shipment Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
    begin
        begin
            recWhseShipLine.SetRange("Source Type", Database::"Transfer Line");
            recWhseShipLine.SetRange("Source No.", Rec."No.");
            if recWhseShipLine.FindFirst then
                if recWhseShipHead.Get(recWhseShipLine."No.") then
                    recWhseShipHead.Delete(true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnBeforeShowDialog', '', false, false)]
    local procedure GetSourceDocInbound_OnBeforeShowDialog(var IsHandled: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        IsHandled := SI.GetWarehouseManagement;// 11-04-19 ZY-LD 001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnInitSourceDocumentHeaderOnBeforePurchHeaderModify', '', false, false)]
    local procedure WhsePostReceipt_OnInitSourceDocumentHeaderOnBeforePurchHeaderModify(var PurchaseHeader: Record "Purchase Header"; var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        PurchaseHeader."Vendor Invoice No." := WarehouseReceiptHeader."Vendor Shipment No."; //001:>><<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterFindWhseRcptLineForPurchLine', '', false, false)]
    local procedure WhsePostReceipt_OnBeforePurchLineModify(var PurchaseLine: Record "Purchase Line"; WhseRcptLine: Record "Warehouse Receipt Line")
    begin
        if (PurchaseLine."Vendor Invoice No" <> WhseRcptLine."Vendor Invoice No.") OR  // 12-02-19 ZY-LD 002
            (PurchaseLine."Warehouse Inbound No." <> WhseRcptLine."Warehouse Inbound No.") then begin  // 24-03-20 ZY-LD 005
            PurchaseLine."Vendor Invoice No" := WhseRcptLine."Vendor Invoice No.";  // 12-02-19 ZY-LD 002
            PurchaseLine."Warehouse Inbound No." := WhseRcptLine."Warehouse Inbound No.";  // 24-03-20 ZY-LD 005
            PurchaseLine.Modify();
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeClearPurchLineQtyToShipReceive', '', false, false)]
    local procedure WhsePostReceipt_OnBeforeClearPurchLineQtyToShipReceive(var PurchLine: Record "Purchase Line"; WhseRcptLine: Record "Warehouse Receipt Line"; var ModifyLine: Boolean)
    begin
        if (PurchLine."Vendor Invoice No" <> '') OR  // 12-02-19 ZY-LD 002
            (PurchLine."Warehouse Inbound No." <> '') then begin  // 24-03-20 ZY-LD 005
            PurchLine."Vendor Invoice No" := '';  // 12-02-19 ZY-LD 002
            PurchLine."Warehouse Inbound No." := '';  // 24-03-20 ZY-LD 005
            ModifyLine := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterFindWhseRcptLineForSalesLine', '', false, false)]
    local procedure WhsePostReceipt_OnAfterFindWhseRcptLineForSalesLine(var SalesLine: Record "Sales Line"; WhseRcptLine: Record "Warehouse Receipt Line")
    begin
        if (SalesLine."Warehouse Inbound No." <> WhseRcptLine."Warehouse Inbound No.") then begin// 24-03-20 ZY-LD 005
            SalesLine."Warehouse Inbound No." := WhseRcptLine."Warehouse Inbound No.";
            SalesLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeClearSalesLineQtyToShipReceive', '', false, false)]
    local procedure WhsePostReceipt_OnBeforeSalesLineModify(var SalesLine: Record "Sales Line"; WhseRcptLine: Record "Warehouse Receipt Line"; var ModifyLine: Boolean)
    begin
        if (SalesLine."Warehouse Inbound No." <> '') then begin// 24-03-20 ZY-LD 005
            SalesLine."Warehouse Inbound No." := '';
            ModifyLine := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnInitSourceDocumentLinesOnAfterSourceTransLineFound', '', false, false)]
    local procedure WhsePostReceipt_OnBeforeTransLineModify(var TransferLine: Record "Transfer Line"; WhseRcptLine: Record "Warehouse Receipt Line"; var ModifyLine: Boolean)
    begin
        if (TransferLine."Warehouse Inbound No." <> WhseRcptLine."Warehouse Inbound No.") then begin  // 24-03-20 ZY-LD 005
            TransferLine."Warehouse Inbound No." := WhseRcptLine."Warehouse Inbound No.";  // 24-03-20 ZY-LD 005
            ModifyLine := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnInitSourceDocumentLinesOnAfterClearTransLineQtyToReceive', '', false, false)]
    local procedure WhsePostReceipt_OnInitSourceDocumentLinesOnAfterClearTransLineQtyToReceive(var TransferLine: Record "Transfer Line"; var WhseReceiptLine: Record "Warehouse Receipt Line"; var ModifyLine: Boolean)
    begin
        if (WhseReceiptLine."Warehouse Inbound No." <> '') then begin  // 24-03-20 ZY-LD 005
            WhseReceiptLine."Warehouse Inbound No." := '';  // 24-03-20 ZY-LD 005
            ModifyLine := true;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnPostUpdateWhseDocumentsOnBeforeWhseRcptLineModify', '', false, false)]
    local procedure WhsePostReceipt_OnPostUpdateWhseDocumentsOnBeforeWhseRcptLineModify(var WarehouseReceiptLine: Record "Warehouse Receipt Line");
    begin
        WarehouseReceiptLine.Validate("Qty. to Receive", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostUpdateWhseShptLineModify', '', false, false)]
    local procedure WhsePostShipment_OnBeforePostUpdateWhseShptLineModify(var WarehouseShipmentLine: Record "Warehouse Shipment Line");
    begin
        WarehouseShipmentLine.Validate("Qty. to Ship", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnHandleSalesLineOnSourceDocumentSalesOrderOnBeforeModifyLine', '', false, false)]
    local procedure WhsePostShipment_OnHandleSalesLineOnSourceDocumentSalesOrderOnBeforeModifyLine(var SalesLine: Record "Sales Line"; WhseShptLine: Record "Warehouse Shipment Line");
    begin
        if (SalesLine."Picking List No." <> SalesLine."Delivery Document No.") OR  // 13-03-19 ZY-LD 002
              (SalesLine."Posted By AIT" <> WhseShptLine."Posted By AIT") then begin  // 13-03-19 ZY-LD 002
            SalesLine.VALIDATE("Picking List No.", SalesLine."Delivery Document No.");  // 13-03-19 ZY-LD 002
            SalesLine.VALIDATE("Posted By AIT", WhseShptLine."Posted By AIT");  // 13-03-19 ZY-LD 002
            SalesLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnHandleSalesLineOnNonWhseLineOnAfterCalcModifyLine', '', false, false)]
    local procedure WhsePostShipment_OnHandleSalesLineOnNonWhseLineOnAfterCalcModifyLine(var SalesLine: Record "Sales Line"; WhseShptLine: Record "Warehouse Shipment Line"; var ModifyLine: Boolean)
    begin
        if (SalesLine."Picking List No." <> '') OR  // 13-03-19 ZY-LD 002
            (SalesLine."Posted By AIT") then begin  // 13-03-19 ZY-LD 002
            SalesLine.VALIDATE("Picking List No.", '');  // 13-03-19 ZY-LD 002
            SalesLine.VALIDATE("Posted By AIT", FALSE);  // 13-03-19 ZY-LD 002
            ModifyLine := true;
        end;
    end;
}
