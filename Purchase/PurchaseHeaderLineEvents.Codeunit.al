codeunit 50079 "Purchase Header/Line Events"
{
    // 001. 04-12-18 ZY-LD 2018120310000072 - Warning is send, it a user choose to delete a line after it's send to HQ.
    // 002. 22-01-19 ZY-LD 000 - When an purchase order line is deleted, the corresponding lines is deleted in VCK Inbound and Container Details.
    // 003. 12-02-19 ZY-LD 000 - Set "Qty. to Receive" to zero.
    // 004. 15-02-19 ZY-LD 000 - Lookup items on CH and SP.
    // 005. 18-02-19 ZY-LD 000 - Code is moved from CU 415.
    // 006. 19-02-19 ZY-LD 000 - Changed from "Sent to HQ" to "eShop Order Sent".
    // 007. 25-02-19 ZY-LD 2019022010000075 - Handle consignment stock.
    // 008. 11-03-19 ZY-LD 000 - Don't run when temporary.
    // 009. 13-03-19 ZY-LD 2019031210000071 - We send only HQ purchase orders.
    // 010. 09-05-19 ZY-LD 000 - Maintain warehouse recipt headen at release and reopen.
    // 011. 15-05-19 ZY-LD 2019051510000098 - We can buy from another vendor, so it can't be alligned with HQ.
    // 012. 01-07-19 ZY-LD P0213 - We also want to sent to EMEA.
    // 013. 14-08-19 ZY-LD 2019081310000167 - Update location based on value on the header.
    // 014. 03-09-19 ZY-LD 000 - EiCard orders that has been sent to eShop can't be deleted.
    // 015. 05-11-19 ZY-LD P0334 - Validate "FTP Code".
    // 016. 11-11-19 ZY-LD 2019111110000173 - Lookup on the correct account.
    // 017. 03-12-19 ZY-LD P0334 - Check SBU Company.
    // 018. 27-12-19 ZY-LD 000 - Purchase Order Status set to Cancled on Eicard Queue.
    // 019. 12-02-20 ZY-LD 000 - We don't want to send IC Document.
    // 020. 24-03-20 ZY-LD P0394 - Test of item "End of Life".
    // 021. 02-04-20 ZY-LD P0388 - Inbound order has moved to Warehouse inbound order.
    // 022. 05-05-20 ZY-LD 2020050510000032 - Code for FTP upload to eShop had moved.
    // 023. 18-02-21 ZY-LD P0557 - Sample setup.
    // 024. 15-11-21 ZY-LD 2021111210000069 - If Type is filled, "No." must have a value.
    // 025. 20-01-22 ZY-LD 000 - Lookup on the rest of the fields.
    // 026. 06-12-23 ZY-LD 000 - Procedure is made global.
    // 027. 06-06-24 ZY-LD 000 - eCommerce eicards has already been sold, and should not be blocked.
    // 028. 10-09-24 ZY-LD 000 - Deferral must have identical text on the header and the lines.
    // 029. 25-09-24 ZY-LD 000 - NL to DK Reverse Charge.

    Permissions = TableData "Change Log Entry" = d;

    var
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: Label 'Process has been cancled.';
        LMSG000: Label 'Locked by reference sales document!';

    local procedure ">> Header"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PurchaseHeader_OnBeforeDelete(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    begin
        if not Rec.Invoice then
            Rec."NL to DK Reverse Chg. Doc No." := '';  // 25-09-24 ZY-LD 029
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidatePurchHeadLocation(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        recPurchLine: Record "Purchase Line";
        recPurchLine2: Record "Purchase Line";
        lText001: Label '"%1" is an %2, so %3 can not be changed.';
    begin
        //>> 14-08-19 ZY-LD 013 - Code is moved from table 39
        //004. Added By Craig on 20120222 for Setting EICard Order Default Location
        if Rec.IsEICard and (Rec."Location Code" <> 'EICARD') and (xRec."Location Code" <> '') then
            Error(lText001, Rec."No.", xRec."Location Code", Rec.FieldCaption(Rec."Location Code"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidatePurchHeadLocation(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        recPurchLine: Record "Purchase Line";
        recPurchLine2: Record "Purchase Line";
    begin
        //>> 14-08-19 ZY-LD 013
        recPurchLine.SetRange("Document Type", Rec."Document Type");
        recPurchLine.SetRange("Document No.", Rec."No.");
        recPurchLine.SetRange("Location Code", xRec."Location Code");
        if recPurchLine.FindSet(true) then
            repeat
                recPurchLine2 := recPurchLine;
                recPurchLine2.Validate("Location Code", Rec."Location Code");
                recPurchLine2.Modify(true);
            until recPurchLine.Next() = 0;
        //<< 14-08-19 ZY-LD 013
        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);  // 18-02-21 ZY-LD 023
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure OnAfterValidateBuyFromVendorNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        recPurchSetup: Record "Purchases & Payables Setup";
        lText001: Label 'eShop Vendor is not setup. Contact navsupport.';
        recVend: Record Vendor;
    begin
        //>> 13-03-19 ZY-LD 009
        if ZGT.IsRhq then
            if Rec."Document Type" = Rec."document type"::Order then begin
                recVend.Get(Rec."Buy-from Vendor No.");
                // 01-07-19 ZY-LD 012
                //>> 05-11-19 ZY-LD 015
                Rec."Sent to HQ" := recVend."SBU Company" = recVend."sbu company"::" ";
                //      IF recVend."IC Partner Code Zyxel" = '' THEN BEGIN   // 01-07-19 ZY-LD 012
                //        recPurchSetup.GET;
                //        IF (recPurchSetup."EShop Vendor No." <> '') AND (recPurchSetup."EShop Vendor No. CH" <> '') THEN
                //          "Sent to HQ" := ("Buy-from Vendor No." <> recPurchSetup."EShop Vendor No.") AND ("Buy-from Vendor No." <> recPurchSetup."EShop Vendor No. CH")
                //        ELSE
                //          IF (recPurchSetup."EShop Vendor No." <> '') AND (recPurchSetup."EShop Vendor No. CH" = '') THEN
                //            "Sent to HQ" := "Buy-from Vendor No." <> recPurchSetup."EShop Vendor No."
                //          ELSE
                //            IF (recPurchSetup."EShop Vendor No." = '') AND (recPurchSetup."EShop Vendor No. CH" <> '') THEN
                //              "Sent to HQ" := "Buy-from Vendor No." <> recPurchSetup."EShop Vendor No. CH"
                //            ELSE
                //              ERROR(lText001);
                //      END;  // 01-07-19 ZY-LD 012
                //<< 05-11-19 ZY-LD 015
            end;
        //<< 13-03-19 ZY-LD 009
        Rec.Validate(Rec."FTP Code");
        // 05-11-19 ZY-LD 015
        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);  // 18-02-21 ZY-LD 023
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Pay-to Vendor No.', false, false)]
    local procedure OnAfterValidatePayToVendorNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);  // 18-02-21 ZY-LD 023
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'FTP Code', false, false)]
    local procedure OnAfterValidateFTPCode(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        recVend: Record Vendor;
    begin
        //>> 05-11-19 ZY-LD 015
        if ZGT.IsRhq and (Rec."Document Type" = Rec."document type"::Order) then begin
            recVend.Get(Rec."Buy-from Vendor No.");
            if Rec.IsEICard then
                Rec."FTP Code" := recVend."FTP Code EiCard"
            else
                Rec."FTP Code" := recVend."FTP Code Normal";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'IsEICard', false, false)]
    local procedure OnAfterValidateIsEiCard(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        recInvSetup: Record "Inventory Setup";
        AllIn: Codeunit "ZyXEL VCK";
    begin
        //>> 05-11-19 ZY-LD 015
        Rec.TestField(Rec.Status, Rec.Status::Open);

        if Rec.IsEICard then begin
            Rec.Validate(Rec."Location Code", 'EICARD');
            Rec.Validate(Rec."Ship-to Name", 'EICARD');
        end else begin
            recInvSetup.Get();
            Rec.Validate(Rec."Location Code", recInvSetup."AIT Location Code");
            Rec.Validate(Rec."Ship-to Name", '');
        end;

        Rec."Transport Method" := AllIn.GetTransportMethod(Rec.IsEICard);

        Rec.Validate(Rec."FTP Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Ship-to Country/Region Code', false, false)]
    local procedure OnAfterValidateShipToCountryRegion(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);  // 18-02-21 ZY-LD 023
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCheckBuyFromVendor', '', false, false)]
    local procedure PurchaseHeader_OnAfterCheckBuyFromVendor(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    var
        AllIn: Codeunit "ZyXEL VCK";
    begin
        PurchaseHeader."Transport Method" := AllIn.GetTransportMethod(PurchaseHeader.IsEICard);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeMessageIfPurchLinesExist', '', false, false)]
    local procedure PurchaseHeader_OnBeforeMessageIfPurchLinesExist(var PurchaseHeader: Record "Purchase Header"; ChangedFieldName: Text[100]; var IsHandled: Boolean)
    begin
        if ChangedFieldName = PurchaseHeader.FieldCaption("Location Code") then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeConfirmKeepExistingDimensions', '', false, false)]
    local procedure PurchaseHeader_OnBeforeConfirmKeepExistingDimensions(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; FieldNo: Integer; OldDimSetID: Integer; var Confirmed: Boolean; var IsHandled: Boolean)
    begin
        Confirmed := true;
        IsHandled := true;
    end;

    local procedure SetAddPostGrpPrLocation(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        recAddPostGrpSetup: Record "Add. Vend. Posting Grp. Setup";
        recVend: Record Vendor;
        ZGT: Codeunit "ZyXEL General Tools";
        ModifyHeader: Boolean;
        UpdateFromVendor: Boolean;
    begin
        //>> 18-02-21 ZY-LD 023
        if not ZGT.IsRhq then begin
            if (Rec."Buy-from Vendor No." <> '') and (Rec."Location Code" <> '') then begin
                recAddPostGrpSetup.SetFilter("Vendor No.", '%1|%2', '', Rec."Buy-from Vendor No.");
                recAddPostGrpSetup.SetFilter("Location Code", '%1|%2', '', Rec."Location Code");
                recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', '', Rec."Sell-to Customer No.");
                if recAddPostGrpSetup.FindLast() then begin
                    Rec.SetHideValidationDialog(true);
                    if (recAddPostGrpSetup."Gen. Bus. Posting Group" <> '') and
                       (recAddPostGrpSetup."Gen. Bus. Posting Group" <> Rec."Gen. Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."Gen. Bus. Posting Group", recAddPostGrpSetup."Gen. Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recAddPostGrpSetup."VAT Bus. Posting Group" <> '') and
                       (recAddPostGrpSetup."VAT Bus. Posting Group" <> Rec."VAT Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."VAT Bus. Posting Group", recAddPostGrpSetup."VAT Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recAddPostGrpSetup."Vendor Posting Group" <> '') and
                       (recAddPostGrpSetup."Vendor Posting Group" <> Rec."Vendor Posting Group")
                    then begin
                        Rec.Validate(Rec."Vendor Posting Group", recAddPostGrpSetup."Vendor Posting Group");
                        ModifyHeader := true;
                    end;
                    //IF ModifyHeader THEN  // 30-05-22 ZY-LD 026 - Moved down
                    //  MODIFY(TRUE);       // 30-05-22 ZY-LD 026
                    Rec.SetHideValidationDialog(false);
                end else
                    UpdateFromVendor := true;
            end else
                UpdateFromVendor := true;
            //<< 18-02-21 ZY-LD 023
            //>> 30-05-22 ZY-LD 026
            if UpdateFromVendor then
                if (Rec."Buy-from Vendor No." <> '') and
                   ((Rec."Buy-from Vendor No." = Rec."Pay-to Vendor No.") or (Rec."Pay-to Vendor No." = ''))
                then begin
                    recVend.Get(Rec."Buy-from Vendor No.");

                    Rec.SetHideValidationDialog(true);
                    if (recVend."Gen. Bus. Posting Group" <> '') and
                        (recVend."Gen. Bus. Posting Group" <> Rec."Gen. Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."Gen. Bus. Posting Group", recVend."Gen. Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recVend."VAT Bus. Posting Group" <> '') and
                        (recVend."VAT Bus. Posting Group" <> Rec."VAT Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."VAT Bus. Posting Group", recVend."VAT Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recVend."Vendor Posting Group" <> '') and
                        (recVend."Vendor Posting Group" <> Rec."Vendor Posting Group")
                    then begin
                        Rec.Validate(Rec."Vendor Posting Group", recVend."Vendor Posting Group");
                        ModifyHeader := true;
                    end;

                    Rec.SetHideValidationDialog(false);
                end;
        end;

        if ModifyHeader then
            if not Rec.Modify(true) then;  // 15-08-22 ZY-LD 006 - "IF NOT" is added
    end;

    local procedure ">> Lines"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertPurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary then
            SetAddProdPostGrp(Rec);  // 18-02-21 ZY-LD 023
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeletePurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        recContDetail: Record "VCK Shipping Detail";
        lText001: Label 'Not all lines on "VCK Inbound" are registrered as posted on "%1" %2, "%3" %4.';
        lText002: Label 'Not all lines on "Container Details" are registrered as archived on "%1" %2, "%3" %4.';
        recCngLogEntry: Record "Change Log Entry";
    begin
        //>> 11-03-19 ZY-LD 008
        if Rec.IsTemporary then
            exit;
        //<< 11-03-19 ZY-LD 00
        //>> 22-01-19 ZY-LD 002
        if Rec."Document Type" = Rec."document type"::Order then begin
            // Delete Container Details
            // It has to be cleared with Jiri, before we delete this
            //    recContDetail.SetCurrentKey("Purchase Order No.","Purchase Order Line No.");
            //    recContDetail.SETRANGE("Purchase Order No.","Document No.");
            //    recContDetail.SETRANGE("Purchase Order Line No.","Line No.");
            //    IF recContDetail.FINDSET(TRUE) THEN
            //      REPEAT
            //        IF NOT recContDetail.Archive THEN
            //          ERROR(lText002,FieldCaption("Document No."),"Document No.",FieldCaption("Line No."),"Line No.");
            //        recContDetail.DELETE(TRUE);
            //      UNTIL recContDetail.Next() = 0;
            // Change Log
            recCngLogEntry.Reset();
            recCngLogEntry.SetCurrentkey("Table No.", "Date and Time", "Primary Key Field 1 Value", "Primary Key Field 2 Value", "Primary Key Field 3 Value");
            recCngLogEntry.SetRange("Table No.", Database::"Purchase Line");
            case Rec."Document Type" of
                Rec."document type"::Order:
                    recCngLogEntry.SetRange("Primary Key Field 1 Value", '1');
                // Order
                Rec."document type"::Invoice:
                    recCngLogEntry.SetRange("Primary Key Field 1 Value", '2');
                // Invoice
                Rec."document type"::"Credit Memo":
                    recCngLogEntry.SetRange("Primary Key Field 1 Value", '3');
            // Cr. Memo
            end;
            recCngLogEntry.SetRange("Primary Key Field 2 Value", Rec."Document No.");
            recCngLogEntry.DeleteAll();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidatePlNo(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        recVend: Record Vendor;
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        SalesHead: Record "Sales Header";
        lText001: Label 'Vendor %1 can only buy items with "%2" = %3.\Do you want to continue?';
        lText002: Label 'The item %1 can only be bought from vendor %2.\Do you want to continue?';
        lText003: Label 'The item %1 is registered as "End of Life". You can still order the product, if HQ have stock.\\"%2"=%3,\"%4"=%5.';
        lText004: Label 'The item %1 is "End of Life".\\"%2"=%3,\"%4"=%5.';
    begin
        //>> 03-12-19 ZY-LD 017
        if Rec.Type = Rec.Type::Item then begin
            recVend.Get(Rec."Buy-from Vendor No.");

            if (recVend."SBU Company" <> recVend."sbu company"::" ") and
               (Rec."No." <> '')
            then begin
                case recVend."SBU Company" of
                    recVend."sbu company"::"ZCom HQ",
                    recVend."sbu company"::"ZNet HQ":
                        begin
                            recItem.SetFilter("SBU Company", '%1|%2', recVend."SBU Company", recItem."sbu company"::" ");
                            recItem.SetRange("No.", Rec."No.");
                            if not recItem.FindFirst() then
                                if not Confirm(lText001, false, Rec."Buy-from Vendor No.", recItem.FieldCaption("SBU Company"), recVend."SBU Company") then
                                    Error(Text001);
                        end;
                end;
            end;

            SetAddProdPostGrp(Rec);
            // 18-02-21 ZY-LD 023
        end;
        //<< 03-12-19 ZY-LD 017
        //>> 24-03-20 ZY-LD 020
        if Rec."Document Type" = Rec."document type"::Order then
            if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                recItem.Reset();
                recItem.Get(Rec."No.");
                if (recItem."Lifecycle Phase" = recItem."lifecycle phase"::"Pre-Disable") or
                   ((recItem."Last Buy Date" < Today) and (recItem."Last Buy Date" <> 0D))
                then begin
                    recPurchHead.Get(Rec."Document Type", Rec."Document No.");
                    if recPurchHead.IsEICard then begin
                        SalesHead.Get(SalesHead."Document Type"::Order, recPurchHead."EiCard Sales Order");  // 06-06-24 ZY-LD 027
                        if (SalesHead."Eicard Type" <> SalesHead."Eicard Type"::eCommerce) then  // 06-06-24 ZY-LD 027
                            Error(lText004, Rec."No.", recItem.FieldCaption("Last Buy Date"), recItem."Last Buy Date", recItem.FieldCaption("Lifecycle Phase"), recItem."Lifecycle Phase")
                    end else
                        Message(lText003, Rec."No.", recItem.FieldCaption("Last Buy Date"), recItem."Last Buy Date", recItem.FieldCaption("Lifecycle Phase"), recItem."Lifecycle Phase");
                end;
            end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidatePlLocation(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        SetAddProdPostGrp(Rec);  // 18-02-21 ZY-LD 023
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateTypeOnBeforeInitRec', '', false, false)]
    local procedure OnValidateTypeOnBeforeInitRec(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer)
    var
        PurchHeader: Record "Purchase Header";
        AllIn: Codeunit "ZyXEL VCK";
    begin
        if PurchaseLine.Type = PurchaseLine.Type::Item then begin
            PurchHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            PurchaseLine."Transport Method" := AllIn.GetTransportMethod(PurchHeader.IsEICard);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateNo', '', false, false)]
    local procedure PurchaseLine_OnBeforeValidateNo(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        if (CurrentFieldNo = PurchaseLine.FieldNo("No.")) and (PurchaseLine."Lock by Ref Document") then
            Error(LMSG000);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateNoPurchaseLine', '', false, false)]
    procedure PurchaseLine_OnAfterValidateNoPurchaseLine(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary; PurchaseHeader: Record "Purchase Header")
    var
        PurchHeader: Record "Purchase Header";
    begin
        if PurchaseLine."Requested Date From Factory" = 0D then begin
            PurchHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            PurchaseLine.Validate("Requested Date From Factory", PurchHeader."Requested Date From Factory");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateQuantity', '', false, false)]
    local procedure PurchaseLine_OnBeforeValidateQuantity(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        if (CurrentFieldNo = PurchaseLine.FieldNo(Quantity)) and (PurchaseLine."Lock by Ref Document") then
            Error(LMSG000);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnDeleteOnAfterCalcShouldModifySalesOrderLine', '', false, false)]
    local procedure PurchaseLine_OnDeleteOnAfterCalcShouldModifySalesOrderLine(var PurchaseLine: Record "Purchase Line"; var ShouldModifySalesOrderLine: Boolean)
    var
        SOLine: Record "Sales Line";
    begin
        if PurchaseLine."Lock by Ref Document" then begin
            Clear(SOLine);
            SOLine.SetFilter("Document No.", '%1', PurchaseLine."Sales Order Number");
            SOLine.SetFilter("Line No.", '%1', PurchaseLine."Sales Line Number");
            if SOLine.FindSet() then begin
                repeat
                    SOLine."Lock by Ref Document" := false;
                    SOLine.Modify();
                until SOLine.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdateSpecialSalesOrderLineFromOnDelete', '', false, false)]
    local procedure OnBeforeUpdateSpecialSalesOrderLineFromOnDelete(var PurchaseLine: Record "Purchase Line"; var SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        if (PurchaseLine."Special Order Sales Line No." <> 0) and (PurchaseLine."Quantity Invoiced" = 0) then begin
            PurchaseLine.LockTable();
            SalesOrderLine.LockTable();
            if SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, PurchaseLine."Special Order Sales No.", PurchaseLine."Special Order Sales Line No.") then begin
                SalesOrderLine."Special Order Purchase No." := '';
                SalesOrderLine."Special Order Purch. Line No." := 0;
                SalesOrderLine.Modify();
            end else
                if (PurchaseLine."Document Type" in [PurchaseLine."Document Type"::Invoice, PurchaseLine."Document Type"::"Credit Memo"]) and
                    SalesOrderLine.Get(PurchaseLine."Document Type", PurchaseLine."Special Order Sales No.", PurchaseLine."Special Order Sales Line No.")
                then begin
                    SalesOrderLine."Special Order Purchase No." := '';
                    SalesOrderLine."Special Order Purch. Line No." := 0;
                    SalesOrderLine.Modify();
                end;
        end;

        IsHandled := true;
    end;

    [EventSubscriber(Objecttype::Page, 54, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeletePurchaseLine_Page54(var Rec: Record "Purchase Line"; var AllowDelete: Boolean)
    var
        recPurchHead: Record "Purchase Header";
        lText001: Label 'The purchase order has been send to HQ, and it will cause trouble with container details, if you delete the line.\\Do you want to continue?';
    begin
        if Rec."Document Type" = Rec."document type"::Order then begin
            recPurchHead.Get(Rec."Document Type", Rec."Document No.");
            if recPurchHead."EShop Order Sent" then
                // 19-02-19 ZY-LD 006
                if Confirm(lText001) then begin
                    SI.SetMergefield(100, Rec."Document No.");
                    SI.SetMergefield(101, Format(Rec."Line No."));
                    EmailAddMgt.CreateSimpleEmail('POLINEDEL', '', '');
                    EmailAddMgt.Send;
                end;
        end;
        //<< 04-12-18 ZY-LD 001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidatePurchaseLineNo(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        recPurchSetup: Record "Purchases & Payables Setup";
        recItem: Record Item;
        lText001: Label 'This is a Channel item.';
        lText002: Label 'This is a Service Provicer item.';
        recPurchHead: Record "Purchase Header";
        recPostGrpCtryLoc: Record "Post Grp. pr. Country / Loc.";
    begin
        //>> 15-02-19 ZY-LD 005
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            recPurchSetup.Get();
            recItem.SetRange(Inactive, false);
            recItem.SetRange("No.", Rec."No.");
            if (Rec."Buy-from Vendor No." = recPurchSetup."EShop Vendor No. CH") and (recPurchSetup."SBU Filter CH" <> '') then begin
                recItem.SetFilter(SBU, recPurchSetup."SBU Filter CH");
                if not recItem.FindFirst() then
                    Error(lText002);
            end;
            if (Rec."Buy-from Vendor No." = recPurchSetup."EShop Vendor No.") and (recPurchSetup."SBU Filter SP" <> '') then begin
                recItem.SetFilter(SBU, recPurchSetup."SBU Filter SP");
                if not recItem.FindFirst() then
                    Error(lText001);
            end;
            //>> 25-02-19 ZY-LD 007
            recPurchHead.Get(Rec."Document Type", Rec."Document No.");
            if recPostGrpCtryLoc.Get(recPurchHead."Ship-to Country/Region Code", recPurchHead."Location Code") then begin
                Rec.Validate(Rec."VAT Prod. Posting Group", recPostGrpCtryLoc."VAT Prod. Post. Group - Purch");
                if recPostGrpCtryLoc."Line Discount %" <> 0 then
                    Rec.Validate(Rec."Line Discount %", recPostGrpCtryLoc."Line Discount %");
            end;
            //<< 25-02-19 ZY-LD 007
        end;
        //<< 15-02-19 ZY-LD 005
    end;

    local procedure SetAddProdPostGrp(var Rec: Record "Purchase Line")
    var
        recAddPostGrpSetup: Record "Add. Vend. Posting Grp. Setup";
        recPurchHead: Record "Purchase Header";
    begin
        if (Rec.Type in [Rec.Type::Item, Rec.Type::"G/L Account"]) and (Rec."No." <> '') and (Rec."Location Code" <> '') then begin
            recPurchHead.Get(Rec."Document Type", Rec."Document No.");
            recAddPostGrpSetup.SetFilter("Vendor No.", '%1|%2', '', Rec."Buy-from Vendor No.");
            recAddPostGrpSetup.SetFilter("Location Code", '%1|%2', '', Rec."Location Code");
            recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', '', recPurchHead."Sell-to Customer No.");
            if recAddPostGrpSetup.FindLast() then begin
                //IF recAddPostGrpSetup."Gen. Prod. Posting Group" <> '' THEN
                //  VALIDATE("Gen. Prod. Posting Group",recAddPostGrpSetup."Gen. Prod. Posting Group");
                if recAddPostGrpSetup."VAT Prod. Posting Group" <> '' then
                    Rec.Validate(Rec."VAT Prod. Posting Group", recAddPostGrpSetup."VAT Prod. Posting Group");
            end;
        end;
        //<< 18-02-21 ZY-LD 023
    end;

    local procedure ">> Release"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        recPurchLine: Record "Purchase Line";
        AllIn: Codeunit "ZyXEL VCK";
        ConfirmAccepted: Boolean;
        lText001: Label 'This order cannot be released as not all lines have an expected from Factory date set.';
        lText002: Label 'This order cannot be released as a Transport Method has not been set.';
        lText003: Label '"%1" must have a value, or "%2" must be blank on "%3" %4.';

    begin
        //>> 18-02-19 ZY-LD 005
        //15-51643 -
        if not AllIn.CheckRequestedDate(PurchaseHeader."No.") then
            Error(lText001);
        //>> 26-03-24 ZY-LD 000            
        //if not AllIn.CheckTransportType(PurchaseHeader."No.") then
        //    Error(lText002);
        AllIn.CheckTransportType(PurchaseHeader);
        //<< 26-03-24 ZY-LD 000

        PurchaseHeader.TestField(PurchaseHeader."Buy-from Vendor No.");
        if not PurchaseHeader.IsEICard then begin
            PurchaseHeader.UpdateAllIn := true;
            PurchaseHeader."Send IC Document" := false;
            // 12-02-20 ZY-LD 019
            PurchaseHeader.Modify(true);
        end;
        //15-51643 +
        //>> 15-11-21 ZY-LD 024
        if GuiAllowed() then begin
            recPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
            recPurchLine.SetRange("Document No.", PurchaseHeader."No.");
            if recPurchLine.FindSet() then
                repeat
                    if (recPurchLine."No." = '') and (recPurchLine.Type.AsInteger() > recPurchLine.Type::" ".AsInteger()) then
                        Error(lText003, recPurchLine.FieldCaption("No."), recPurchLine.FieldCaption(Type), recPurchLine.FieldCaption("Line No."), recPurchLine."Line No.");
                until recPurchLine.Next() = 0;
        end;
        //<< 18-02-19 ZY-LD 005
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        recWarehouse: Record Location;
        recPurchSetup: Record "Purchases & Payables Setup";
        recVend: Record Vendor;
        recICPartner: Record "IC Partner";
        AllIn: Codeunit "ZyXEL VCK";
        EiCardMgt: Codeunit "ZyXEL EiCards";
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: Label 'Order %1 could not upload to eShop and the warehouse.';
        lText002: Label 'Order %1 could not upload to %2.';
        lText003: Label 'Order %1 is send to eShop.';
        VchXmlMgt: Codeunit "VCK Communication Management";
        lText004: Label 'The connection to the warehouse could not be established.';
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        SentToVendor: Boolean;
        lText005: Label 'Order %1 is send to %2.';
    begin
        //>> 18-02-19 ZY-LD 005
        recPurchSetup.Get();

        if (PurchaseHeader."Document Type" = PurchaseHeader."document type"::Order) and
           ZGT.IsRhq and
           GuiAllowed() and
           not PurchaseHeader.IsEICard
        then begin
            recWarehouse.Get(PurchaseHeader."Location Code");
            if not PurchaseHeader."EShop Order Sent" and not PurchaseHeader.SentToAllIn then begin
                if recWarehouse.Warehouse > recWarehouse.Warehouse::" " then begin
                    recWarehouse.TestField("Warehouse Inbound FTP Code");
                    if not FtpMgt.TestLogin(recWarehouse."Warehouse Inbound FTP Code") then
                        Error(lText004);
                end;
            end;

            if not PurchaseHeader."EShop Order Sent" and
               not PurchaseHeader."Sent to HQ"
            // Translation: "Don't send to HQ".  // 15-05-19 ZY-LD 011
            then begin
                //>> 05-11-19 ZY-LD 015
                //IF (("Buy-from Vendor No." = recPurchSetup."EShop Vendor No.") OR ("Buy-from Vendor No." = recPurchSetup."EShop Vendor No. CH")) THEN BEGIN  // 15-05-19 ZY-LD 011
                //>> 05-005-20 ZY-LD 022
                /*recVend.GET("Buy-from Vendor No.");
                IF ("FTP Code" <> '') AND
                   (recVend."SBU Company" <> recVend."SBU Company"::" ")
                THEN BEGIN  // 05-11-19 ZY-LD 015
                  IF AllIn.SendToHQ("No.",FALSE) THEN BEGIN
                    PurchaseHeader.GET(PurchaseHeader."Document Type",PurchaseHeader."No.");
                    SentToVendor := TRUE;
                    MESSAGE(lText003,"No.");
                  END ELSE
                    MESSAGE(lText001,"No.");
                END ELSE
                  SentToVendor := TRUE;*/
                //<< 05-005-20 ZY-LD 022
                if recVend.Get(PurchaseHeader."Buy-from Vendor No.") and (recVend."IC Partner Code Zyxel" <> '') then begin
                    recICPartner.Get(recVend."IC Partner Code Zyxel");
                    recICPartner.TestField("Purchase Order Comm. Type");
                    case recICPartner."Purchase Order Comm. Type" of
                        recICPartner."purchase order comm. type"::"E-Shop":
                            begin
                                //>> 05-005-20 ZY-LD 022
                                if recVend."SBU Company" in [recVend."sbu company"::"ZCom HQ", recVend."sbu company"::"ZNet HQ"] then begin
                                    PurchaseHeader.TestField(PurchaseHeader."FTP Code");
                                    if AllIn.SendToHQ(PurchaseHeader."No.", false) then
                                        Message(lText003, PurchaseHeader."No.")
                                    else
                                        Message(lText001, PurchaseHeader."No.");
                                end;
                                //<< 05-005-20 ZY-LD 022
                            end;
                        recICPartner."purchase order comm. type"::"Web Service":
                            begin
                                recICPartner.TestField("Customer No.");
                                if ZyWebServMgt.SendPurchasOrders(recICPartner."Inbox Details", PurchaseHeader."No.", recICPartner."Customer No.") then begin
                                    PurchaseHeader."EShop Order Sent" := true;
                                    PurchaseHeader.Modify();
                                    SentToVendor := true;
                                    Message(lText005, PurchaseHeader."No.", recVend.Name);
                                end;
                            end;
                    end;
                end;
            end else
                SentToVendor := PurchaseHeader."EShop Order Sent";
            // 08-07-19 ZY-LD 000
            //>> 02-04-20 ZY-LD 021
            recVend.Get(PurchaseHeader."Buy-from Vendor No.");
            //IF NOT SentToAllIn AND SentToVendor AND (recWarehouse.Warehouse > recWarehouse.Warehouse::" ") AND (recVend."SBU Company" <> recVend."SBU Company"::" ") THEN
            // Create container details on external vendors.
            if not PurchaseHeader.SentToAllIn and (recWarehouse.Warehouse > recWarehouse.Warehouse::" ") and (recVend."SBU Company" = recVend."sbu company"::" ") then begin
                Commit();
                if ZyWebServMgt.SendContainerDetails(CompanyName(), 2, PurchaseHeader."No.") then begin
                    PurchaseHeader.SentToAllIn := true;
                    PurchaseHeader.Modify();
                end;
            end;
            /*IF NOT SentToAllIn AND SentToVendor AND (recWarehouse.Warehouse > recWarehouse.Warehouse::" ") THEN BEGIN
              IF VchXmlMgt.SendPurchaseOrderRequest(PurchaseHeader) THEN
                MESSAGE(lText005,"No.",recWarehouse.Name)
              ELSE BEGIN
                Status := Status::Open;
                MODIFY;
                MESSAGE(lText002,"No.",recWarehouse.Name);
              END;
            END;*/
            //<< 02-04-20 ZY-LD 021
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckPurchaseApprovalPossible', '', false, false)]
    local procedure ApprovalsMgmt_OnBeforeCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        PurchLine: Record "Purchase Line";
        ConfirmAccepted: Boolean;
        xxx: Page "Purchase Credit Memo";
        lText001: Label 'To get correct description on all "G/L Entries" should the "%1.%2" be identical to "%3.%4".\\%1.%2: "%5".\%3.%4: "%6".\\Do you want to continue with different texts?';
    begin
        //>> 10-09-24 ZY-LD 028
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.SetFilter("Deferral Code", '<>%1', '');
        PurchLine.SetFilter(Description, '<>%1', PurchaseHeader."Posting Description");
        if PurchLine.FindFirst then begin
            Result := confirm(lText001, false,
                        PurchaseHeader.TableCaption, PurchaseHeader.FieldCaption("Posting Description"),
                        PurchLine.TableCaption, PurchLine.FieldCaption(Description),
                        PurchaseHeader."Posting Description", PurchLine.Description);
            IsHandled := true;
        end;
        //<< 10-09-24 ZY-LD 028
    end;

    local procedure ">> Page - Purchase Order"()
    begin
    end;

    [EventSubscriber(Objecttype::Page, 50, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecordEvent50(var Rec: Record "Purchase Header"; var AllowDelete: Boolean)
    var
        lText001: Label 'Deletion is cancled.';
        recEiCardQueue: Record "EiCard Queue";
        lText002: Label 'You can only delete EiCard Purchase Order %1, if it is also deleted in eShop.\Do you want to continue?';
        lText003: Label 'Is Purchase Order %1 confirmed deleted from eShop?';
        lText004: Label '"%1" on the EiCard is "%2".\Are you sure you want to delete the "%3"?';
    begin
        //>> 03-09-19 ZY-LD 014
        if ZGT.IsRhq then begin
            recEiCardQueue.SetRange("Purchase Order No.", Rec."No.");
            if recEiCardQueue.FindFirst() then begin
                if recEiCardQueue."Purchase Order Status" <> recEiCardQueue."purchase order status"::"EiCard Order Sent to HQ" then
                    //>> 02-12-21 ZY-LD 025
                    if not Confirm(lText004, false, recEiCardQueue.FieldCaption("Purchase Order Status"), recEiCardQueue."Purchase Order Status", Rec."Document Type") then
                        Error(lText001);
                //ERROR(lText004,recEiCardQueue."Purchase Order Status");
                //<< 02-12-21 ZY-LD 025
                if not Confirm(lText002, false, Rec."No.") then
                    Error(lText001);
                if not Confirm(lText003, false, Rec."No.") then
                    Error(lText001);

                recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::Cancled);
                // 27-12-19 ZY-LD 018
                recEiCardQueue."Purchase Order Deleted By" := UserId();
                recEiCardQueue.Modify(true);
            end;

        end;
    end;

    [EventSubscriber(Objecttype::Page, 50, 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure OnAfterActionEventReOpen50(var Rec: Record "Purchase Header")
    begin
        DeleteWarehouseReceipt(Rec);  // 09-05-19 ZY-LD 010
    end;

    [EventSubscriber(Objecttype::Page, 50, 'OnAfterActionEvent', 'Release', false, false)]
    local procedure OnAfterActionEventRelease50(var Rec: Record "Purchase Header")
    var
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
    begin
        GetSourceDocInbound.CreateFromPurchOrderHideDialog(Rec);  // 09-05-19 ZY-LD 010
    end;

    [EventSubscriber(Objecttype::Page, 9307, 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure OnAfterActionEventReOpen9307(var Rec: Record "Purchase Header")
    begin
        DeleteWarehouseReceipt(Rec);  // 09-05-19 ZY-LD 010
    end;

    [EventSubscriber(Objecttype::Page, 9307, 'OnAfterActionEvent', 'Release', false, false)]
    local procedure OnAfterActionEventRelease9307(var Rec: Record "Purchase Header")
    var
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
    begin
        GetSourceDocInbound.CreateFromPurchOrderHideDialog(Rec);  // 09-05-19 ZY-LD 010
    end;

    procedure DeleteWarehouseReceipt(var Rec: Record "Purchase Header")  // 06-12-23 ZY-LD 026
    var
        recWhseRcptHead: Record "Warehouse Receipt Header";
    begin
        //>> 09-05-19 ZY-LD 010
        if Rec."Document Type" = Rec."document type"::Order then begin
            recWhseRcptHead.SetRange("Purchase Order No.", Rec."No.");
            if recWhseRcptHead.FindFirst() then
                recWhseRcptHead.Delete(true);

        end;
        //<< 09-05-19 ZY-LD 010
    end;

    local procedure ">> Warehouse"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertWarehouseReceiptLine(var Rec: Record "Warehouse Receipt Line"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary then
            Rec.Validate(Rec."Qty. to Receive", 0);  // 12-02-19 ZY-LD 003
    end;

    local procedure "-->>"()
    begin
    end;

    procedure OnLookupPurchaseLineNo(var Rec: Record "Purchase Line")
    var
        recVend: Record Vendor;
        recPurchSetup: Record "Purchases & Payables Setup";
        recItem: Record Item;
        recGlAcc: Record "G/L Account";
        recPurchHead: Record "Purchase Header";
        recFixedAsset: Record "Fixed Asset";
        recItemCharge: Record "Item Charge";
    begin
        //>> 15-02-19 ZY-LD 004
        case Rec.Type of
            Rec.Type::Item:
                begin
                    recPurchSetup.Get();
                    recPurchHead.Get(Rec."Document Type", Rec."Document No.");
                    recItem.FilterGroup(2);
                    recVend.Get(recPurchHead."Buy-from Vendor No.");
                    if recVend."SBU Company" <> recVend."sbu company"::" " then
                        case recVend."SBU Company" of
                            recVend."sbu company"::"ZCom HQ",
                          recVend."sbu company"::"ZNet HQ":
                                recItem.SetFilter("SBU Company", '%1|%2', recVend."SBU Company", recVend."sbu company"::" ");
                        end;
                    if recPurchHead.IsEICard then
                        recItem.SetRange(IsEICard, recPurchHead.IsEICard);
                    recItem.SetRange(Inactive, false);
                    recItem.FilterGroup(0);

                    if not recItem.Get(Rec."No.") then;
                    if Page.RunModal(Page::"Item List", recItem) = Action::LookupOK then
                        Rec.Validate(Rec."No.", recItem."No.");
                end;
            Rec.Type::"G/L Account":
                begin
                    if not recGlAcc.Get(Rec."No.") then;
                    // 11-11-19 ZY-LD 016
                    if Page.RunModal(Page::"G/L Account List", recGlAcc) = Action::LookupOK then
                        Rec.Validate(Rec."No.", recGlAcc."No.");
                end;
            //>> 20-01-22 ZY-LD 025
            Rec.Type::"Fixed Asset":
                begin
                    if not recFixedAsset.Get(Rec."No.") then;
                    if Page.RunModal(Page::"Fixed Asset List", recFixedAsset) = Action::LookupOK then
                        Rec.Validate(Rec."No.", recFixedAsset."No.");
                end;
            Rec.Type::"Charge (Item)":
                begin
                    if not recItemCharge.Get(Rec."No.") then;
                    if Page.RunModal(Page::"Item Charges", recItemCharge) = Action::LookupOK then
                        Rec.Validate(Rec."No.", recItemCharge."No.");
                end;
        //<< 20-01-22 ZY-LD 025
        end;
        //<< 15-02-19 ZY-LD 004
    end;


    procedure HidePostButtons(pLocationCode: Code[20]): Boolean
    var
        recWarehouse: Record Location;
    begin
        recWarehouse.Get(pLocationCode);
        exit(recWarehouse.Warehouse = recWarehouse.Warehouse::" ");
    end;
}

