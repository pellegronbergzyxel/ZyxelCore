
codeunit 50091 "Item / Logistic Events"
{
    // 001. 13-08-18 ZY-LD 2018081010000478 - Check if Quantity is zero on delivery document line.
    // 002. 23-08-18 ZY-LD 000 - I have discovered that there can be a difference on "item No." between "Item Ledger Entry" and "Value Entry".
    // 003. 03-08-18 ZY-LD 2018080310000133 - Do not allow items to rename.
    // 004. 31-08-18 ZY-LD 000 - Replicate item.
    // 005. 19-11-18 ZY-LD 2018111310000028 - After inserting a sales- or purchase price, we set the ending date on the previous price lines.
    // 006. 07-01-19 ZY-LD 2019010710000039 - Changed from refering from "DD" To "SO".
    // 007. 28-01-19 ZY-LD 2019012410000079 - Insert default dimension to secure mandatory code.
    // 008. 13-02-19 ZY-LD 2019021310000061 - It's ok to rename DMY.
    // 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 009. 04-12-19 ZY-LD P0334 - Update "Vendor No." on the item.
    // 010. 02-01-20 ZY-LD P0363 - Additional EMEA Purchase Price.
    // 011. 17-01-20 ZY-LD P0376 - Cross Reference.
    // 012. 12-05-20 ZY-LD 2020051110000182 - Set "No PLMS Update" on DMY skus.
    // 013. 16-06-20 ZY-LD 2020061610000073 - Purchase price in sister company must also could be updated.
    // 014. 11-08-20 ZY-LD 000 - CalculateTotalQtyPerCarton.
    // 015. 24-08-20 ZY-LD 000 - Re-open older line.
    // 016. 09-09-20 ZY-LD 000 - Message on "No. PLMS Update".
    // 017. 09-10-20 ZY-LD P0496 - Clean up item.
    // 018. 19-10-20 ZY-LD 2020101610000225 - Fill "Business to:".
    // 019. 15-02-22 ZY-LD P0747 - "Unit Volume" is set to the volumen of the colorbox.
    // 020. 07-03-22 ZY-LD 000 - "Prevent Negative Inventory".
    // 021. 10-08-22 ZY-LD 000 - "Prevent Negative Inventory on Location".
    // 022. 23-02-23 ZY-LD 000 - Set the field "Enter Security for Eicard on".
    // 023. 02-03-23 ZY-LD 000 - Skip validation on eCommerce.
    // 024. 24-03-23 ZY-LD 000 - Reworked from Item No.
    // 025. 27-04-23 ZY-LD 000 - Test on "Require shipment" on transfer orders.
    // 026. 14-02-24 ZY-LD 000 - Source Description is added to the record.
    // 027. 24-05-24 ZY-LD 000 - We don´t use variants in ZNet DK, and don´t need the default verification.

    Permissions = TableData "Price List Line Replicated" = d;

    var
        Text001: Label 'Quantity can not be zero on "Sales Order" "%1" "%2".';
        DontAskAgain: Boolean;
        UpdateEndingDate: Boolean;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertItem(var Rec: Record Item; RunTrigger: Boolean)
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        begin
            if not Rec.IsTemporary then begin
                Rec."Creation Date" := Today;
                Rec."Created By" := UserId();

                Rec."Business to" := Rec."business to"::Consumer;  // 19-10-20 ZY-LD 018
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnBeforeRenameItem(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        lText001: Label 'You are not allowed to rename items.';
    begin
        if CopyStr(Rec."No.", 1, 3) <> 'DMY' then  // 13-02-19 ZY-LD 008
            Error(lText001);  // 03-08-18 ZY-LD 003
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeValidateEvent', 'No PLMS Update', false, false)]
    local procedure OnBeforeValidateNoPlmsUpdate(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        lText001: Label 'When setting the tick in "%1", data will no longer be updated by PLMS data from Headquarter.\If you want PLMS to update %2, you must remove the tick again.';
        lText002: Label 'The item is updated via the "%1" %2, and can therefore not be updated from PLMS. You must remove the value from "%1" before you can remove the tick.';
    begin
        begin
            //>> 24-03-23 ZY-LD 024
            if xRec."No PLMS Update" and (Rec."Update PLMS from Item No." <> '') then
                Error(lText002, Rec.FieldCaption(Rec."Update PLMS from Item No."), Rec."Update PLMS from Item No.");
            //<< 24-03-23 ZY-LD 024

            //>> 09-09-20 ZY-LD 016
            if Rec."No PLMS Update" then
                Message(lText001, Rec.FieldCaption(Rec."No PLMS Update"), Rec."No.")
            //<< 09-09-20 ZY-LD 016
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNo(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        //>> 12-05-20 ZY-LD 012
        if CopyStr(Rec."No.", 1, 3) = 'DMY' then
            Rec."No PLMS Update" := true;
        //<< 12-05-20 ZY-LD 012
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Qty. per Color Box', false, false)]
    local procedure OnAfterValidateQtyPerColorBox(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        CalculateTotalQtyPerCarton(Rec);  // 11-08-20 ZY-LD 014
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Number per carton', false, false)]
    local procedure OnAfterValidateNumberPerCarton(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        CalculateTotalQtyPerCarton(Rec);  // 11-08-20 ZY-LD 014
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Length (cm)', false, false)]
    local procedure "OnAfterValidateLength(cm)"(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        Rec.Validate(Rec."Volume (cm3)");  // 09-10-20 ZY-LD 017
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Width (cm)', false, false)]
    local procedure "OnAfterValidateWidth(cm)"(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        Rec.Validate(Rec."Volume (cm3)");  // 09-10-20 ZY-LD 017
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Height (cm)', false, false)]
    local procedure "OnAfterValidateHeight(cm)"(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        Rec.Validate(Rec."Volume (cm3)");  // 09-10-20 ZY-LD 017
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Category 1 Code', false, false)]
    local procedure OnAfterValidateCategoryCode1(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        OnAfterValidateBusinessTo(Rec, xRec, CurrFieldNo);  // 19-10-20 ZY-LD 018
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Category 2 Code', false, false)]
    local procedure OnAfterValidateCategoryCode2(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        OnAfterValidateBusinessTo(Rec, xRec, CurrFieldNo);  // 19-10-20 ZY-LD 018
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Category 3 Code', false, false)]
    local procedure OnAfterValidateCategoryCode3(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        OnAfterValidateBusinessTo(Rec, xRec, CurrFieldNo);  // 19-10-20 ZY-LD 018
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Category 4 Code', false, false)]
    local procedure OnAfterValidateCategoryCode4(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        OnAfterValidateBusinessTo(Rec, xRec, CurrFieldNo);  // 19-10-20 ZY-LD 018
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Business to', false, false)]
    local procedure OnAfterValidateBusinessTo(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        recHqDim: Record SBU;
    begin
        begin
            //>> 19-10-20 ZY-LD 018
            case CurrFieldNo of
                Rec.FieldNo(Rec."Category 1 Code"):
                    if not recHqDim.Get(recHqDim.Type::"Category 1", Rec."Category 1 Code") then;
                Rec.FieldNo(Rec."Category 2 Code"):
                    if not recHqDim.Get(recHqDim.Type::"Category 2", Rec."Category 2 Code") then;
                Rec.FieldNo(Rec."Category 3 Code"):
                    if not recHqDim.Get(recHqDim.Type::"Category 3", Rec."Category 3 Code") then;
                Rec.FieldNo(Rec."Category 4 Code"):
                    if not recHqDim.Get(recHqDim.Type::"Category 4", Rec."Category 4 Code") then;
            end;
            if (not recHqDim.IsEmpty()) and (recHqDim."Business to" <> recHqDim."business to"::" ") then begin
                Rec."Business to" := recHqDim."Business to";
                Rec.Modify(true);
            end;
            //<< 19-10-20 ZY-LD 018
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Volume (cm3)', false, false)]
    local procedure "OnAfterValidateVolume(cm3)"(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        begin
            Rec."Volume (cm3)" := Rec."Length (cm)" * Rec."Width (cm)" * Rec."Height (cm)";  // 09-10-20 ZY-LD 017
            Rec.Validate(Rec."Unit Volume", Rec."Volume (cm3)");  // 15-02-22 ZY-LD 019
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Unit Volume', false, false)]
    local procedure OnAfterValidateUnitVolume(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        recPurchLine: Record "Purchase Line";
    begin
        begin
            //>> 01-03-22 ZY-LD 019
            recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
            recPurchLine.SetRange(Type, recPurchLine.Type::Item);
            recPurchLine.SetRange("No.", Rec."No.");
            recPurchLine.SetFilter("Outstanding Quantity", '<>0');
            recPurchLine.SetRange("Unit Volume", 0);
            if recPurchLine.FindSet(true) then
                repeat
                    recPurchLine.SuspendStatusCheck(true);
                    recPurchLine."Unit Volume" := Rec."Unit Volume" * recPurchLine."Qty. per Unit of Measure";
                    recPurchLine.Modify();
                    recPurchLine.SuspendStatusCheck(false);
                until recPurchLine.Next() = 0;
            //<< 01-03-22 ZY-LD 019
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'IsEICard', false, false)]
    local procedure OnAfterValidateIsEicard(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        begin
            //>> 07-03-22 ZY-LD 020
            if Rec.IsEICard then
                Rec."Prevent Negative Inventory" := Rec."prevent negative inventory"::No
            else
                Rec."Prevent Negative Inventory" := Rec."prevent negative inventory"::Default;
            //<< 07-03-22 ZY-LD 020

            //>> 23-02-23 ZY-LD 022
            if Rec.IsEICard then begin
                if StrPos(Rec."No.", CopyStr(Format(Rec."enter security for eicard on"::"EMS License"), 1, 3)) <> 0 then
                    Rec."Enter Security for Eicard on" := Rec."enter security for eicard on"::"EMS License";
                if StrPos(Rec."No.", CopyStr(Format(Rec."enter security for eicard on"::"GLC License"), 1, 3)) <> 0 then
                    Rec."Enter Security for Eicard on" := Rec."enter security for eicard on"::"GLC License";
            end else
                Rec."Enter Security for Eicard on" := Rec."enter security for eicard on"::" ";
            //<< 23-02-23 ZY-LD 022
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Update PLMS from Item No.', false, false)]
    local procedure OnAfterValidateUpdatePlmsFromItemNo(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        lText001: Label 'The field "%1" must be ticked off.';
        lText002: Label '"%1" and "%2" must not be identical.';
    begin
        begin
            //>> 24-03-23 ZY-LD 024
            if (Rec."Update PLMS from Item No." <> '') and (not Rec."No PLMS Update") then
                Error(lText001, Rec.FieldCaption(Rec."Update PLMS from Item No."));
            if (Rec."Update PLMS from Item No." = Rec."No.") then
                Error(lText002, Rec.FieldCaption(Rec."No."), Rec.FieldCaption(Rec."Update PLMS from Item No."));
            Rec.TransferPlmsFields;
            //<< 24-03-23 ZY-LD 024
        end;
    end;

    [EventSubscriber(Objecttype::Page, 30, 'OnInsertRecordEvent', '', false, false)]
    local procedure "OnInsertRecordItemCard(30)"(var Rec: Record Item; BelowxRec: Boolean; var xRec: Record Item; var AllowInsert: Boolean)
    var
        recDefDim: Record "Default Dimension";
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        begin
            //>> 28-01-19 ZY-LD 007
            recGenLedgSetup.Get();
            recDefDim.Validate("Table ID", Database::Item);
            recDefDim."No." := Rec."No.";
            recDefDim."Dimension Code" := recGenLedgSetup."Global Dimension 1 Code";
            recDefDim."Value Posting" := recDefDim."value posting"::"Code Mandatory";
            if not recDefDim.Insert() then
                recDefDim.Modify();
            //<< 28-01-19 ZY-LD 007
        end;
    end;

    [EventSubscriber(Objecttype::Page, 30, 'OnClosePageEvent', '', false, false)]
    local procedure "OnAfterClosePageItemCard(30)"(var Rec: Record Item)
    var
        lText001: Label 'Division Code must be filled.';
    begin
        //>> 28-01-19 ZY-LD 007
        if Rec."Global Dimension 1 Code" = '' then
            Message(lText001);
        //<< 28-01-19 ZY-LD 007
    end;

    [EventSubscriber(ObjectType::Table, Database::"VCK Delivery Document Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertDeliveryDocumentLine(var Rec: Record "VCK Delivery Document Line"; RunTrigger: Boolean)
    begin
        //PAB
        //WITH Rec DO
        //  IF Quantity = 0 THEN
        //    ERROR(Text001,Rec."Sales Order No.",Rec."Sales Order Line No.");  // 07-01-19 ZY-LD 006
    end;

    [EventSubscriber(ObjectType::Table, Database::"VCK Delivery Document Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifytDeliveryDocumentLine(var Rec: Record "VCK Delivery Document Line"; var xRec: Record "VCK Delivery Document Line"; RunTrigger: Boolean)
    begin
        //PAB
        //WITH Rec DO
        //  IF Quantity = 0 THEN
        //    ERROR(Text001,Rec."Sales Order No.",Rec."Sales Order Line No.");  // 07-01-19 ZY-LD 006
    end;

    /* Removed again...
    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertValueEntry(var Rec: Record "Value Entry"; RunTrigger: Boolean)
    var
        recItemLedgerEntry: Record "Item Ledger Entry";
        lText001: Label 'Difference on "%1" has occured between "%2" and "%3". Please raise a ticket.';
    begin
        //>> 23-08-18 ZY-LD 002
        if recItemLedgerEntry.Get(Rec."Item Ledger Entry No.") then
            if recItemLedgerEntry."Item No." <> Rec."Item No." then
                Error(lText001, Rec.FieldCaption(Rec."Item No."), recItemLedgerEntry.TableCaption(), Rec.TableCaption());
        //<< 23-08-18 ZY-LD 002
    end;
    */

    local procedure ">> Sales Price"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Price List Management", 'OnAfterImplementNewPrice', '', false, false)]
    local procedure PriceListManagement_OnAfterImplementNewPrice(var PriceListLine: Record "Price List Line")
    begin
        // OnAfterInsertSalesPrice is called from Report 7053. There are a lot of updates in Sales Price, so we can't create a Evenc Subcriber.
        UpdateSalesPriceEndDate(PriceListLine);  // 19-11-18 ZY-LD 005
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterValidateEvent', 'Starting Date', false, false)]
    local procedure OnAfterValidateStartingDate(var Rec: Record "Price List Line"; var xRec: Record "Price List Line")
    begin
        UpdateSalesPriceEndDate(Rec);  // 19-11-18 ZY-LD 005
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnBeforeVerify', '', false, false)]
    local procedure PriceListLine_OnBeforeVerify(var PriceListLine: Record "Price List Line"; var IsHandled: Boolean)
    var
        MarginApp: Record "Margin Approval";
        SalesDocType: Enum "Sales Document Type";
    begin
        // If the margin is not approved, then we can´t validate the price book. 
        //30-10-2025 BK #MarginApproval
        IsHandled :=
            not MarginApp.MarginApproved(
                MarginApp."Source Type"::"Price Book",
                SalesDocType::Quote,  // Used for sales document.
                PriceListLine."Price List Code",
                PriceListLine."Line No.",
                PriceListLine."Assign-to No.",
                PriceListLine."Product No.",
                PriceListLine."Currency Code",
                PriceListLine."Unit Price",
                0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Price UX Management", 'OnBeforeShowPriceListLines', '', false, false)]
    local procedure PriceUxMgt_OnBeforeShowPriceListLines(PriceSource: Record "Price Source"; PriceAsset: Record "Price Asset"; PriceType: Enum "Price Type"; AmountType: Enum "Price Amount Type"; var IsHandled: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        if PriceAsset."Asset Type" = PriceAsset."Asset Type"::Item then
            SI.SetItemNo(PriceAsset."Asset No.");
    end;

    [EventSubscriber(Objecttype::Page, Page::"Price List Lines", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteSalesPrice_Page(var Rec: Record "Price List Line"; var AllowDelete: Boolean)
    var
        recSalesPrice: Record "Price List Line";
        lText001: Label 'Do you want to open the line with:\"%1" %2\"%3" %4?';
        SI: Codeunit "Single Instance";
    begin
        begin
            //>> 24-08-20 ZY-LD 015
            // We investigate if it´s the last record we try to delete.
            // After that there must not be any lines with a blank "Ending Date".
            // If the "Ending Date" is the day before "Starting Date" we may reopen.
            recSalesPrice.SetRange("Asset Type", Rec."Asset Type");
            recSalesPrice.SetRange("Asset No.", Rec."Asset No.");
            recSalesPrice.SetRange("Source Type", Rec."Source Type");
            recSalesPrice.SetRange("Source No.", Rec."Source No.");
            recSalesPrice.SetFilter("Starting Date", '>%1', Rec."Starting Date");
            recSalesPrice.SetRange("Currency Code", Rec."Currency Code");
            recSalesPrice.SetRange("Variant Code", Rec."Variant Code");
            recSalesPrice.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            if Rec."Minimum Quantity" in [0, 1] then
                recSalesPrice.SetRange("Minimum Quantity", 0, 1)
            else
                recSalesPrice.SetRange("Minimum Quantity", Rec."Minimum Quantity");
            if not recSalesPrice.FindFirst() then begin
                recSalesPrice.SetFilter("Starting Date", '<%1', Rec."Starting Date");
                recSalesPrice.SetFilter("Ending Date", '%1', 0D);
                if not recSalesPrice.FindLast() then begin
                    recSalesPrice.SetRange("Ending Date", Rec."Starting Date" - 1);
                    if (Rec."Source No." = 'EMEA') and (Rec."Starting Date" = 20200801D) then
                        recSalesPrice.SetRange("Ending Date", 20200531D);
                    if recSalesPrice.FindLast() then begin
                        if not SI.GetYesToAll(true) then
                            UpdateEndingDate := Confirm(lText001, true, Rec.FieldCaption(Rec."Starting Date"), recSalesPrice."Starting Date", Rec.FieldCaption(Rec."Ending Date"), recSalesPrice."Ending Date");

                        if UpdateEndingDate then
                            if SI.GetYesToAll(false) then begin
                                recSalesPrice.Validate("Ending Date", 0D);
                                recSalesPrice.Modify(true);
                            end;
                    end;
                end;
            end;
            //<< 24-08-20 ZY-LD 015
        end;
    end;

    [EventSubscriber(Objecttype::Page, Page::"Price List Lines", 'OnClosePageEvent', '', false, false)]
    local procedure OnClosepage(var Rec: Record "Price List Line")
    var
        SI: Codeunit "Single Instance";
    begin
        SI.ResetYesToAll;
    end;

    [EventSubscriber(Objecttype::Table, Database::"Transfer Header", 'OnAfterInitFromTransferToLocation', '', false, false)]
    local procedure TransferHeader_OnAfterInitFromTransferToLocation(var TransferHeader: Record "Transfer Header"; Location: Record Location)
    begin
        TransferHeader."Transfer-to County" := Location."Country/Region Code";
    end;

    [EventSubscriber(Objecttype::Table, Database::"Transfer Line", 'OnAfterUpdateWithWarehouseShipReceive', '', false, false)]
    local procedure TransferLine_OnAfterUpdateWithWarehouseShipReceive(var TransferLine: Record "Transfer Line"; CurrentFieldNo: Integer)
    begin
        TransferLine.Validate("Qty. to Ship", TransferLine."Outstanding Quantity");  // 16-05-19 ZY-LD 002
    end;

    [EventSubscriber(Objecttype::Table, Database::"Transfer Line", 'OnBeforeCheckWarehouse', '', false, false)]
    local procedure TransferLine_OnBeforeCheckWarehouse(TransferLine: Record "Transfer Line"; Location: Record Location; Receive: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    procedure UpdateSalesPriceEndDate(var Rec: Record "Price List Line")
    var
        recSalesPrice: Record "Price List Line";
        recSalesPriceRep: Record "Price List Line Replicated";
    begin
        //>> 19-11-18 ZY-LD 005
        begin
            if not recSalesPrice.IsTemporary then begin
                recSalesPrice.SetRange("Asset No.", Rec."Asset No.");
                recSalesPrice.SetRange("Asset Type", Rec."Asset Type");
                recSalesPrice.SetRange("Source Type", Rec."Source Type");
                recSalesPrice.SetRange("Source No.", Rec."Source No.");
                recSalesPrice.SetFilter("Starting Date", '<%1', Rec."Starting Date");
                recSalesPrice.SetRange("Currency Code", Rec."Currency Code");
                recSalesPrice.SetRange("Variant Code", Rec."Variant Code");
                recSalesPrice.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                if Rec."Minimum Quantity" in [0, 1] then
                    recSalesPrice.SetRange("Minimum Quantity", 0, 1)
                else
                    recSalesPrice.SetRange("Minimum Quantity", Rec."Minimum Quantity");
                recSalesPrice.SetFilter("Ending Date", '%1|%2', 0D, 20991231D);
                if recSalesPrice.FindSet(true) then
                    repeat
                        recSalesPrice."Ending Date" := Rec."Starting Date" - 1;
                        recSalesPrice.Modify(true);

                        // Sales Price Replicated must be deleted, so the line will be replicated to the sub.
                        recSalesPriceRep.SetRange("Price List Code", recSalesPrice."Price List Code");
                        recSalesPriceRep.DeleteAll(true);
                    until recSalesPrice.Next() = 0;
            end;
        end;
        //<< 19-11-18 ZY-LD 005
    end;

    local procedure ">> Purchase Price"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterInsertEvent', '', false, false)]

    procedure OnAfterInsertPurchasePrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        recPurchPrice: Record "Price List Line";
        recPurchPriceTmp: Record "Price List Line" temporary;
        recVend: Record Vendor;
        recItem: Record Item;
    begin
        begin
            if not Rec.IsTemporary then begin
                //>> 19-11-18 ZY-LD 005
                recPurchPrice.SetRange("Asset Type", Rec."Asset Type");
                recPurchPrice.SetRange("Asset No.", Rec."Asset No.");
                recPurchPrice.SetRange("Source Type", Rec."Source Type");
                recPurchPrice.SetRange("Source No.", Rec."Source No.");
                recPurchPrice.SetFilter("Starting Date", '<%1', Rec."Starting Date");
                recPurchPrice.SetRange("Currency Code", Rec."Currency Code");
                recPurchPrice.SetRange("Variant Code", Rec."Variant Code");
                recPurchPrice.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                if Rec."Minimum Quantity" in [0, 1] then
                    recPurchPrice.SetRange("Minimum Quantity", 0, 1)
                else
                    recPurchPrice.SetRange("Minimum Quantity", Rec."Minimum Quantity");
                recPurchPrice.SetRange("Ending Date", 0D);
                if recPurchPrice.FindSet(true) then
                    repeat
                        recPurchPrice."Ending Date" := Rec."Starting Date" - 1;
                        recPurchPrice."New Price" := false;
                        recPurchPrice.Modify(true);
                    until recPurchPrice.Next() = 0;
                //<< 19-11-18 ZY-LD 005

                //>> 04-12-19 ZY-LD 009
                if ZGT.IsRhq then begin
                    //      IF GUIALLOWED THEN
                    //        UpdateEmeaItemPrices(Rec)
                    //      ELSE begin
                    Rec."New Price" := true;
                    Rec.Modify();
                    //        END;
                end;
            end;
        end;
    end;

    local procedure ">> Cross Reference"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Reference", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure OnAfterValidateCRItemNo(var Rec: Record "Item Reference"; var xRec: Record "Item Reference"; CurrFieldNo: Integer)
    var
        recItem: Record Item;
    begin
        begin
            //>> 17-01-20 ZY-LD 011
            recItem.Get(Rec."Item No.");
            Rec.Validate(Rec."Unit of Measure", recItem."Base Unit of Measure");
            if not Rec.Modify(true) then;
            //<< 17-01-20 ZY-LD 011
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Reference", 'OnAfterValidateEvent', 'Add EAN Code to Delivery Note', false, false)]
    local procedure OnAfterValidateAddEanToDeliveryNote(var Rec: Record "Item Reference"; var xRec: Record "Item Reference"; CurrFieldNo: Integer)
    var
        recItem: Record Item;
    begin
        begin
            // 31-03-23 ZY-LD - Not used anymore.
            /*//>> 17-01-20 ZY-LD 011
            recItem.GET("Item No.");
            IF "Add EAN Code to Delivery Note" THEN BEGIN
              IF "Cross-Reference EAN Code" = '' THEN
                "Cross-Reference EAN Code" := recItem."EAN code";
            END ELSE
              IF "Cross-Reference EAN Code" = recItem."EAN code" THEN
                "Cross-Reference EAN Code" := '';
            //<< 17-01-20 ZY-LD 011*/
        end;

    end;

    local procedure ">> Location"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::Location, 'OnAfterValidateEvent', 'Main Warehouse', false, false)]
    local procedure OnAfterValidateMainWarehouse(var Rec: Record Location; var xRec: Record Location; CurrFieldNo: Integer)
    var
        recLocation: Record Location;
    begin
        //>> 18-11-20 ZY-LD 019
        if Rec."Main Warehouse" then begin
            recLocation.SetRange("Main Warehouse", true);
            recLocation.SetFilter(Code, '<>%1', Rec.Code);
            recLocation.ModifyAll("Main Warehouse", false);
        end;
        //<< 18-11-20 ZY-LD 019
    end;


    procedure PreventNegativeInventory(pItemNo: Code[20]; pLocationCode: Code[20]; pValidation: Boolean): Boolean
    var
        recLocation: Record Location;
        lText001: Label 'You have insufficient quantity of Item %1 on Location "%2".';
        recItem: Record Item;
        SI: Codeunit "Single Instance";
    begin
        //>> 10-08-22 ZY-LD 021
        if not SI.GetSkipVerifyOnInventory then  // 02-03-23 ZY-LD 023
            if pLocationCode <> '' then begin
                recLocation.Get(pLocationCode);
                if recLocation."Prevent Negative Inventory" then begin
                    recItem.Get(pItemNo);
                    if not recItem."Freight Cost Item" then
                        if pValidation then
                            exit(true)
                        else
                            Error(lText001, pItemNo, pLocationCode);
                end;
            end;
        //<< 10-08-22 ZY-LD 021
    end;

    local procedure ">> Item Ledger Entry"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnAfterVerifyOnInventory', '', false, false)]
    local procedure OnAfterVerifyOnInventory(ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //>> 10-08-22 ZY-LD 021
        case ItemLedgerEntry."Entry Type" of
            ItemLedgerEntry."entry type"::Consumption, ItemLedgerEntry."entry type"::"Assembly Consumption", ItemLedgerEntry."entry type"::Transfer:
                Error('');
            else
                PreventNegativeInventory(ItemLedgerEntry."Item No.", ItemLedgerEntry."Location Code", false);
        end;
        //<< 10-08-22 ZY-LD 021
    end;

    [EventSubscriber(ObjectType::Page, Page::"Items by Location", 'OnAfterSetTempMatrixLocationFilters', '', false, false)]
    local procedure ItemsByLocation_OnAfterSetTempMatrixLocationFilters(var TempMatrixLocation: Record Location temporary);
    begin
        TempMatrixLocation.SetRange("In Use", true);
    end;

    procedure UpdateEmeaItemPrices(var Rec: Record "Price List Line")
    var
        recPurchPrice: Record "Price List Line";
        recPurchPriceSister: Record "Price List Line";
        recPurchPriceTmp: Record "Price List Line" temporary;
        recVend: Record Vendor;
        recVendSister: Record Vendor;
        recItem: Record Item;
        recCust: Record Customer;
        recSalesSetup: Record "Sales & Receivables Setup";
        recSalesPriceTmp: Record "Price List Line" temporary;
        recCustPriceGrp: Record "Customer Price Group";
        NewSalesPrice: Decimal;
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        begin
            if not Rec.IsTemporary then begin
                // Set "Ending Date" on old entries
                //>> 19-11-18 ZY-LD 005
                recPurchPrice.SetRange("Asset Type", Rec."Asset Type");
                recPurchPrice.SetRange("Asset No.", Rec."Asset No.");
                recPurchPrice.SetRange("Source Type", Rec."Source Type");
                recPurchPrice.SetRange("Source No.", Rec."Source No.");
                recPurchPrice.SetFilter("Starting Date", '<%1', Rec."Starting Date");
                recPurchPrice.SetRange("Currency Code", Rec."Currency Code");
                recPurchPrice.SetRange("Variant Code", Rec."Variant Code");
                recPurchPrice.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
                if Rec."Minimum Quantity" in [0, 1] then
                    recPurchPrice.SetRange("Minimum Quantity", 0, 1)
                else
                    recPurchPrice.SetRange("Minimum Quantity", Rec."Minimum Quantity");
                recPurchPrice.SetRange("Ending Date", 0D);
                if recPurchPrice.FindSet(true) then
                    repeat
                        recPurchPrice."Ending Date" := Rec."Starting Date" - 1;
                        recPurchPrice.Modify(true);
                    until recPurchPrice.Next() = 0;
                //<< 19-11-18 ZY-LD 005

                // Copy price to sister company
                //>> 04-12-19 ZY-LD 009
                if ZGT.IsRhq then begin
                    recVend.Get(Rec."Source No.");
                    recItem.Get(Rec."Asset No.");

                    if (not recItem.IsEICard) and (recItem."SBU Company" <> recItem."sbu company"::" ") then begin
                        // If the vendor is the HQ vendor, then we need to replicate the price to EMEA customer and vendor.
                        if (ZGT.IsZNetCompany and (recVend."SBU Company" = recVend."sbu company"::"ZCom HQ")) or
                           (not ZGT.IsZNetCompany and (recVend."SBU Company" = recVend."sbu company"::"ZNet HQ"))
                        then begin
                            // Copy the purchase price to EMEA vendor
                            recVendSister.SetFilter("SBU Company", '%1|%2', recVendSister."sbu company"::"ZCom EMEA", recVendSister."sbu company"::"ZNet EMEA");
                            recVendSister.FindFirst();
                            recPurchPriceSister := Rec;
                            recPurchPriceSister."Source No." := recVendSister."No.";
                            //>> 02-01-20 ZY-LD 010
                            if recVendSister."Add. EMEA Purchace Price %" <> 0 then
                                recPurchPriceSister."Direct Unit Cost" := Round(Rec."Direct Unit Cost" * (1 + (recVendSister."Add. EMEA Purchace Price %" / 100)));
                            //<< 02-01-20 ZY-LD 010
                            //>> 16-06-20 ZY-LD 013
                            //recPurchPriceSister.INSERT(TRUE);
                            if not recPurchPriceSister.Insert(true) then
                                recPurchPriceSister.Modify(true);
                            //<< 16-06-20 ZY-LD 013
                            ItemLogisticEvents.UpdateEmeaItemPrices(recPurchPriceSister);  // This function is to set "Ending Date"

                            // Send price to corresponding EMEA customer in the sister company
                            recSalesPriceTmp."Asset Type" := recSalesPriceTmp."Asset Type"::Item;
                            recSalesPriceTmp."Asset No." := Rec."Asset No.";
                            recSalesPriceTmp."Source Type" := recSalesPriceTmp."Source Type"::"Customer Price Group";
                            recSalesPriceTmp."Source No." := 'EMEA';
                            recSalesPriceTmp."Starting Date" := Rec."Starting Date";
                            recSalesPriceTmp."Currency Code" := Rec."Currency Code";
                            recSalesPriceTmp."Variant Code" := Rec."Variant Code";
                            recSalesPriceTmp."Unit of Measure Code" := Rec."Unit of Measure Code";
                            recSalesPriceTmp."Minimum Quantity" := Rec."Minimum Quantity";
                            recSalesPriceTmp."Unit Price" := recPurchPriceSister."Direct Unit Cost";  // 02-01-20 ZY-LD 010
                            recSalesPriceTmp.Insert();
                            ZyWebSrvMgt.SendSalesPrice(ZGT.GetSistersCompanyName(1), recSalesPriceTmp);
                        end;

                        if Rec."New Price" then begin
                            Rec."New Price" := false;
                            Rec.Modify();
                        end;
                    end;
                end;
                //<< 04-12-19 ZY-LD 009
            end;
        end;
    end;

    local procedure CalculateTotalQtyPerCarton(var Rec: Record Item)
    begin
        Rec."Total Qty. per Carton" := Rec."Qty. per Color Box" * Rec."Number per carton";  // 11-08-20 ZY-LD 014
    end;


    procedure GetMainWarehouseLocation(): Code[10]
    var
        recLocation: Record Location;
    begin
        //>> 18-11-20 ZY-LD 019
        recLocation.SetRange("Main Warehouse", true);
        if recLocation.FindFirst() then
            exit(recLocation.Code)
        else
            exit('');
        //<< 18-11-20 ZY-LD 019
    end;


    procedure GetRequireShipmentLocations() rValue: Code[100]
    var
        recLocation: Record Location;
        lText001: Label 'The function "GetRequireShipmentLocation" must not be blank.';
    begin
        //>> 18-11-20 ZY-LD 019
        recLocation.SetRange("Require Shipment", true);
        if recLocation.FindSet() then
            repeat
                rValue += recLocation.Code + '|';
            until recLocation.Next() = 0;
        rValue := DelChr(rValue, '>', '|');
        if rValue = '' then
            Error(Text001);
        //<< 18-11-20 ZY-LD 019
    end;


    procedure MainWarehouseLocation(LocationCode: Code[10]): Boolean
    var
        lText001: Label 'Location Code must not be blank.';
        recLocation: Record Location;
    begin
        //>> 18-11-20 ZY-LD 019
        if LocationCode = '' then
            Error(lText001);

        recLocation.SetRange("Main Warehouse", true);
        recLocation.FindFirst();
        exit(LocationCode = recLocation.Code);
        //<< 18-11-20 ZY-LD 019
    end;


    procedure RequireShipmentLocation(LocationCode: Code[10]): Boolean
    var
        lText001: Label 'Location Code must not be blank.';
        recLocation: Record Location;
    begin
        //>> 27-04-23 ZY-LD 025
        recLocation.Get(LocationCode);
        exit(recLocation."Require Shipment");
        //<< 27-04-23 ZY-LD 025
    end;


    procedure GetForecastTerritory(pLocationCode: Code[10]; pDivisionCode: Code[10]) rValue: Code[20]
    var
        recLocation: Record Location;
        recForeTerrCountry: Record "Forecast Territory Country";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if pDivisionCode = '' then
            if ZGT.IsZComCompany then
                pDivisionCode := 'SP'
            else
                pDivisionCode := 'CH';

        recLocation.Get(pLocationCode);
        recLocation.TestField("Country/Region Code");
        recForeTerrCountry.SetRange("Territory Code", recLocation."Country/Region Code");
        recForeTerrCountry.SetRange("Division Code", pDivisionCode);
        if recForeTerrCountry.FindFirst() then
            rValue := recForeTerrCountry."Forecast Territory Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterPurchRcptLineSetFilters', '', false, false)]
    local procedure PurchGetReceipt_OnAfterPurchRcptLineSetFilters(var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchRcptLine.SetCurrentKey("Pay-to Vendor No.", "Buy-from Vendor No.", "Qty. Rcd. Not Invoiced");  // 12-02-19 ZY-LD 001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnBeforeInsertLines', '', false, false)]
    local procedure PurchGetReceipt_OnBeforeInsertLines(var PurchaseHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    begin
        PurchLine."Vendor Invoice No" := PurchaseHeader."Vendor Invoice No."; //15-51643
    end;

    #region Item Substitution
    [EventSubscriber(ObjectType::Table, Database::"Item Substitution", 'OnAfterValidateEvent', 'Substitute No.', false, false)]
    local procedure OnAfterValidateSubstitureNo(var Rec: Record "Item Substitution"; var xRec: Record "Item Substitution"; CurrFieldNo: Integer)
    var
        ItemVariant: Record "Item Variant";
        VariantValue: Label 'RMA';
    begin
        // Insert automatic the Variant Code when RMA is inserted.
        if Rec.GetFilter("Variant Code") = VariantValue then begin
            if not ItemVariant.get(Rec.GetFilter("No."), VariantValue) then begin
                ItemVariant.Init();
                ItemVariant.Validate("Item No.", Rec.GetFilter("No."));
                ItemVariant.Validate(Code, VariantValue);
                ItemVariant.Validate(Description, VariantValue);
                ItemVariant.Insert(true);
            end;
            Rec.Validate("Variant Code", ItemVariant.Code);
        end;
    end;
    #endregion

    #region Item Identifier
    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnBeforeValidateEvent', 'Code', false, false)]
    local procedure OnBeforeValidateCode(var Rec: Record "Item Identifier"; var xRec: Record "Item Identifier"; CurrFieldNo: Integer)
    var
        ItemIdent: Record "Item Identifier";
        lText001Err: Label '"%1" %2 does already exist on "%3" %4.';
    begin
        // If we don´t do this, it will try to rename the existing record.
        //>> 24-05-24 ZY-LD 027
        if ItemIdent.get(Rec.Code) then
            Error(lText001Err, ItemIdent.FieldCaption(code), ItemIdent.Code, ItemIdent.FieldCaption("Item No."), ItemIdent."Item No.");
        //<< 24-05-24 ZY-LD 027            
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnBeforeVerifyItem', '', false, false)]
    local procedure OnBeforeVerifyItem(ItemIdentifier: Record "Item Identifier"; var IsHandled: Boolean)
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        IsHandled := ZGT.IsRhq and ZGT.IsZNetCompany;  // 24-05-24 ZY-LD 027
    end;
    #endregion

    #region Item Journal and post
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure ItemJnlPost_OnBeforeCode(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        SalesSetup.get;
        if ((not GuiAllowed) or (ZGT.UserIsDeveloper)) and  // ZGT.UserIsDeveloper can be removed again after test.
           (ItemJournalLine."Journal Template Name" = SalesSetup."LMR Item Journal Template Name") and
           (ItemJournalLine."Journal Batch Name" = SalesSetup."LMR Item Journal Batch Name")
        then
            HideDialog := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        Cust: Record Customer;
        Vend: Record Vendor;
        Item: Record Item;
    begin
        //>> 14-02-24 ZY-LD 026
        CASE ItemLedgerEntry."Source Type" OF
            ItemLedgerEntry."Source Type"::Customer:
                IF Cust.GET(ItemLedgerEntry."Source No.") THEN
                    ItemLedgerEntry."Source Description" := CopyStr(Cust.Name, 1, MaxStrLen(ItemLedgerEntry."Source Description"));
            ItemLedgerEntry."Source Type"::Vendor:
                IF Vend.GET(ItemLedgerEntry."Source No.") THEN
                    ItemLedgerEntry."Source Description" := CopyStr(Vend.Name, 1, MaxStrLen(ItemLedgerEntry."Source Description"));
            ItemLedgerEntry."Source Type"::Item:
                IF Item.GET(ItemLedgerEntry."Source No.") THEN
                    ItemLedgerEntry."Source Description" := CopyStr(Item.Description, 1, MaxStrLen(ItemLedgerEntry."Source Description"));
        END;
        //<< 14-02-24 ZY-LD 026
        ItemLedgerEntry."Original No." := ItemJournalLine."Original No.";  // 02-05-24 - ZY-LD 000
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        if ItemLedgerEntry."Remaining Quantity" = 0 then
            ItemLedgerEntry."Last Applying Date" := Today;
    end;
    #endregion
}
