codeunit 50040 "Intrastat Events"
{
    // 001. 02-05-24 ZY-LD 000 - Events has been moved from General Ledger Events.
    // 002. 09-09-24 ZY-LD 000 - The sample item is made "Non-Inventoriable", so we need to find the value for sample items.


    #region Intrastat
    [EventSubscriber(ObjectType::Table, Database::"Intrastat Report Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertIntrastatReportLine(var Rec: Record "Intrastat Report Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        Item: Record Item;
        ICSetup: Record "IC Setup";
        ZGT: Codeunit "ZyXEL General Tools";

    begin
        ItemLedgEntry.get(Rec."Source Entry No.");
        if ((ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Purchase) and
            (ItemLedgEntry."Document Type" IN [ItemLedgEntry."Document Type"::"Purchase Invoice", ItemLedgEntry."Document Type"::"Purchase Credit Memo"]))
        then begin
            Rec."Country/Region Code" := GetIntrastatBaseCountryCode(ItemLedgEntry);
            case ItemLedgEntry."Document Type" of
                ItemLedgEntry."Document Type"::"Purchase Invoice":
                    begin
                        PurchInvHeader.get(ItemLedgEntry."Document No.");
                        Rec."Opposite Country/Region Code" := PurchInvHeader."Ship-to Country/Region Code";

                        // In Italy we have an addon, where don´t set in certin values.
                        if ZGT.ItalianServer then begin
                            ICSetup.get;
                            ICSetup.TestField("Sample Item");
                            if ItemLedgEntry."Item No." = ICSetup."Sample Item" then begin
                                Item.get(ItemLedgEntry."Original No.");
                                Rec."Country/Region of Origin Code" := Item."Country/Region of Origin Code";

                                PurchInvLine.get(ItemLedgEntry."Document No.", ItemLedgEntry."Document Line No.");
                                Rec.Validate(Quantity, PurchInvLine.Quantity);
                            end;
                        end;
                    end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Intrastat Report Line", 'OnBeforeValidateEvent', 'Item No.', false, false)]
    local procedure OnBeforeValidate_ItemNo(var Rec: Record "Intrastat Report Line"; var xRec: Record "Intrastat Report Line")
    var
        ICSetup: Record "IC Setup";
        ItemLedgEntry: Record "Item Ledger Entry";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        // For sample items the "Item No." will be exchanged with original item no.
        IF (Rec.Type = Rec.Type::Receipt) and (not ZGT.IsRhq) then begin
            ICSetup.get;
            ICSetup.TestField("Sample Item");
            if Rec."Item No." = ICSetup."Sample Item" then begin
                ItemLedgEntry.get(Rec."Source Entry No.");
                Rec."Item No." := ItemLedgEntry."Original No.";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Intrastat Report Get Lines", 'OnBeforeCalculateTotals', '', false, false)]
    local procedure OnBeforeCalculateTotals(var ItemLedgerEntry: Record "Item Ledger Entry"; IntrastatReportHeader: Record "Intrastat Report Header";
            var TotalAmt: Decimal; var TotalCostAmt: Decimal; var TotalAmtExpected: Decimal; var TotalCostAmtExpected: Decimal;
            var TotalIndirectCost: Decimal; var TotalIndirectCostAmt: Decimal; var TotalIndirectCostExpected: Decimal; var TotalIndirectCostAmtExpected: Decimal;
            StartDate: Date; EndDate: Date; SkipRecalcZeroAmounts: Boolean; var IsHandled: Boolean)
    var
        ICSetup: Record "IC Setup";
    begin
        if ItemLedgerEntry."Item No." = ICSetup."Sample Item" then begin
            // Calculate cost price for samples here. Copy the code from "Intrastat Report Get Lines"

            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Intrastat Report Get Lines", 'OnBeforeCalculateTotals', '', false, false)]
    local procedure IntrastatReportGetLines_OnBeforeCalculateTotals(var ItemLedgerEntry: Record "Item Ledger Entry"; IntrastatReportHeader: Record "Intrastat Report Header";
            var TotalAmt: Decimal; var TotalCostAmt: Decimal; var TotalAmtExpected: Decimal; var TotalCostAmtExpected: Decimal;
            var TotalIndirectCost: Decimal; var TotalIndirectCostAmt: Decimal; var TotalIndirectCostExpected: Decimal; var TotalIndirectCostAmtExpected: Decimal;
            StartDate: Date; EndDate: Date; SkipRecalcZeroAmounts: Boolean; var IsHandled: Boolean)
    var
        ValueEntry: Record "Value Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        ICSetup: Record "IC Setup";
    begin
        //>> 09-09-24 ZY-LD 002
        ICSetup.get;
        if ItemLedgerEntry."Item No." = ICSetup."Sample Item" then begin
            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
            if ValueEntry.FindSet() then
                repeat
                    if not ((ValueEntry."Item Charge No." <> '') and
                            ((ValueEntry."Posting Date" > EndDate) or (ValueEntry."Posting Date" < StartDate)))
                    then begin
                        if not IntrastatReportHeader."Amounts in Add. Currency" then begin
                            if ValueEntry."Item Charge No." = '' then
                                TotalCostAmt += ValueEntry."Cost Amount (Non-Invtbl.)"
                            else
                                TotalIndirectCostAmt += ValueEntry."Cost Amount (Non-Invtbl.)";
                        end else begin
                            if ValueEntry."Item Charge No." = '' then
                                TotalCostAmt += ValueEntry."Cost Amount (Non-Invtbl.)(ACY)"
                            else
                                TotalIndirectCostAmt += ValueEntry."Cost Amount (Non-Invtbl.)(ACY)";
                        end;
                    end;
                until ValueEntry.Next() = 0;
        end;
        //<< 09-09-24 ZY-LD 002
    end;

    [EventSubscriber(ObjectType::Report, Report::"Intrastat Report Get Lines", 'OnBeforeInsertItemLedgerLine', '', false, false)]
    local procedure IntrastatReportGetLines_OnBeforeInsertItemLedgerLine(var IntrastatReportLine: Record "Intrastat Report Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean)
    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsRhq() then
            SetCountryRegionCode(IntrastatReportLine, ItemLedgerEntry);  // 15-04-24 ZY-LD 017
        //>> 14-10-22 ZY-LD 001
        CompanyInfo.Get();
        IntrastatReportLine."Location Code" := ItemLedgerEntry."Location Code";
        Location.Get(ItemLedgerEntry."Location Code");
        if Location."eCommerce Location" then
            IntrastatReportLine."Opposite Country/Region Code" := GetShipFromLocation(ItemLedgerEntry."External Document No.")
        else
            IntrastatReportLine."Opposite Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";  // 14-10-22 ZY-LD 001
                                                                                                              //<< 14-10-22 ZY-LD 001
    end;

    local procedure SetCountryRegionCode(var IntrastatReportLine: Record "Intrastat Report Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        Location: Record Location;
        CompanyInfo: Record "Company Information";
        IntrastatReportMgt: Codeunit IntrastatReportManagement;
    begin
        CompanyInfo.get;
        IntrastatReportLine."Country/Region Code" := IntrastatReportMgt.GetIntrastatBaseCountryCode(ItemLedgerEntry);  // 15-04-24 ZY-LD 017 - Reset the "Country/Region Code" before it validated again.

        if (IntrastatReportLine."Country/Region Code" = '') or
           (IntrastatReportLine."Country/Region Code" = CompanyInfo."Ship-to Country/Region Code")  // 15-04-24 ZY-LD 017 - "CompanyInfo."Ship-to Country/Region Code" is different from Microsoft code.
        then
            if ItemLedgerEntry."Location Code" = '' then
                IntrastatReportLine."Country/Region Code" := CompanyInfo."Ship-to Country/Region Code"
            else begin
                Location.Get(ItemLedgerEntry."Location Code");
                IntrastatReportLine."Country/Region Code" := Location."Country/Region Code"
            end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Intrastat Report Get Lines", 'OnBeforeHasCrossedBorder', '', false, false)]
    local procedure IntrastatReportGetLines_OnBeforeHasCrossedBorder(ItemLedgerEntry: Record "Item Ledger Entry"; var Result: Boolean; var IsHandled: Boolean)
    var
        Location: Record Location;
        Country: Record "Country/Region";
        CompanyInfo: Record "Company Information";
        IntraRepSetup: Record "Intrastat Report Setup";
        ItemLedgEntry2: Record "Item Ledger Entry";
        IntrastatReportMgt: Codeunit IntrastatReportManagement;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        Location.Get(ItemLedgerEntry."Location Code");
        if Location."Exclude from Intrastat Report" then begin
            Result := false;
            IsHandled := true;
            Exit;
        end;

        if (Country.Get(IntrastatReportMgt.GetIntrastatBaseCountryCode(ItemLedgerEntry)) and (Country."Intrastat Code" <> '')) or (Country.Code = '') then
            case true of
                ItemLedgerEntry."Drop Shipment":
                    begin
                    end;
                ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Transfer:
                    begin
                        Result := true;
                        IsHandled := true;

                        CompanyInfo.get;
                        if ZGT.IsRhq then
                            CompanyInfo.TestField("Ship-to Country/Region Code");

                        if Country.Code in [CompanyInfo."Country/Region Code", ''] then
                            Result := false;
                        case true of
                            ((ItemLedgerEntry."Order Type" <> ItemLedgerEntry."Order Type"::Transfer) or (ItemLedgerEntry."Order No." = '')),
                            ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Direct Transfer":
                                begin
                                    Location.Get(ItemLedgerEntry."Location Code");
                                    if (Location."Country/Region Code" <> '') and (Location."Country/Region Code" <> CompanyInfo."Country/Region Code") then
                                        Result := false;
                                end;
                            ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Receipt":
                                begin
                                    ItemLedgEntry2.SetCurrentKey("Order Type", "Order No.");
                                    ItemLedgEntry2.SetRange("Order Type", ItemLedgerEntry."Order Type"::Transfer);
                                    ItemLedgEntry2.SetRange("Order No.", ItemLedgerEntry."Order No.");
                                    ItemLedgEntry2.SetRange("Document Type", ItemLedgEntry2."Document Type"::"Transfer Shipment");
                                    ItemLedgEntry2.SetFilter("Country/Region Code", '%1 | %2', '', CompanyInfo."Ship-to Country/Region Code");
                                    ItemLedgEntry2.SetRange(Positive, true);
                                    if ItemLedgEntry2.IsEmpty() then
                                        Result := false;
                                end;
                            ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Transfer Shipment":
                                begin
                                    if not ItemLedgerEntry.Positive then
                                        exit;
                                    ItemLedgEntry2.SetCurrentKey("Order Type", "Order No.");
                                    ItemLedgEntry2.SetRange("Order Type", ItemLedgerEntry."Order Type"::Transfer);
                                    ItemLedgEntry2.SetRange("Order No.", ItemLedgerEntry."Order No.");
                                    ItemLedgEntry2.SetRange("Document Type", ItemLedgEntry2."Document Type"::"Transfer Receipt");
                                    ItemLedgEntry2.SetFilter("Country/Region Code", '%1 | %2', '', CompanyInfo."Ship-to Country/Region Code");
                                    ItemLedgEntry2.SetRange(Positive, false);
                                    if ItemLedgEntry2.IsEmpty() then
                                        Result := false;
                                end;
                        end;
                    end;
                ItemLedgerEntry."Location Code" <> '':
                    begin
                        CompanyInfo.get;
                        if ZGT.IsRhq then
                            CompanyInfo.TestField("Ship-to Country/Region Code");
                        Location.Get(ItemLedgerEntry."Location Code");
                        if Location."eCommerce Location" then begin
                            Location."Country/Region Code" := GetShipFromLocation(ItemLedgerEntry."External Document No.");
                            CompanyInfo."Country/Region Code" := Location."Country/Region Code";
                        end else
                            if ZGT.IsRhq() then  // For RHQ we need to setup the right country for the warehouse. In the subsidaries the country code is within the subsidary country.
                                CompanyInfo."Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
                        if CountryOfOrigin(Location."Country/Region Code", ItemLedgerEntry, CompanyInfo) then begin
                            Result := true;
                            IsHandled := true;
                        end;
                    end;
            end;

        /*if ItemLedgEntry."Location Code" <> '' then begin
                    //>> 14-10-22 ZY-LD 001
                    Location.Get(ItemLedgEntry."Location Code");
                    if Location."eCommerce Location" then begin
                        Location."Country/Region Code" := GetShipFromLocation(ItemLedgEntry."External Document No.");
                        //TODO: LD Har den en betydning CompanyInfo."Country/Region Code" := Location."Country/Region Code";
                    end; // else
                         //TODO: LD Har den en betydning CompanyInfo."Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
                         //<< 14-10-22 ZY-LD 001
                end;
            end;*/
    end;

    local procedure CountryOfOrigin(CountryRegionCode: Code[20]; ItemLedgEntry: Record "Item Ledger Entry"; CompanyInfo: Record "Company Information"): Boolean
    var
        CountryRegion: Record "Country/Region";
        IntrastatReportMgt: Codeunit IntrastatReportManagement;
    begin
        if (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Sale) or
           ((ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Purchase) and
            (ItemLedgEntry."Document Type" IN [ItemLedgEntry."Document Type"::"Purchase Receipt", ItemLedgEntry."Document Type"::"Purchase Return Shipment"]))
         then begin
            if (IntrastatReportMgt.GetIntrastatBaseCountryCode(ItemLedgEntry) in [CompanyInfo."Country/Region Code", '']) =
               (CountryRegionCode in [CompanyInfo."Country/Region Code", ''])
            then
                exit(false);
        end else
            if (GetIntrastatBaseCountryCode(ItemLedgEntry) in [CompanyInfo."Country/Region Code", '']) =
               (CountryRegionCode in [CompanyInfo."Country/Region Code", ''])
            then
                exit(false);

        if CountryRegionCode <> '' then begin
            CountryRegion.Get(CountryRegionCode);
            if CountryRegion."Intrastat Code" = '' then
                exit(false);
        end;
        exit(true);
    end;

    procedure GetIntrastatBaseCountryCode(ItemLedgEntry: Record "Item Ledger Entry") CountryCode: Code[10]
    var
        IntrastatReportSetup: Record "Intrastat Report Setup";
        Location: Record Location;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ZGT: Codeunit "ZyXEL General Tools";

    begin
        IntrastatReportSetup.Get();
        Location.get(ItemLedgEntry."Location Code");
        if not ZGT.IsRhq() and not Location."Exclude from Intrastat Report" then
            Location.TestField("Ship-from Country/Region Code");

        CountryCode := ItemLedgEntry."Country/Region Code";

        case ItemLedgEntry."Document Type" of
            ItemLedgEntry."Document Type"::"Purchase Invoice":
                if PurchInvHeader.Get(ItemLedgEntry."Document No.") then
                    case IntrastatReportSetup."Shipments Based On" of
                        IntrastatReportSetup."Shipments Based On"::"Ship-to Country":
                            CountryCode := Location."Ship-from Country/Region Code";
                        IntrastatReportSetup."Shipments Based On"::"Sell-to Country":
                            CountryCode := PurchInvHeader."Buy-from Country/Region Code";
                        IntrastatReportSetup."Shipments Based On"::"Bill-to Country":
                            CountryCode := PurchInvHeader."Pay-to Country/Region Code";
                    end;
            ItemLedgEntry."Document Type"::"Purchase Credit Memo":
                if PurchCrMemoHeader.Get(ItemLedgEntry."Document No.") then
                    case IntrastatReportSetup."Shipments Based On" of
                        IntrastatReportSetup."Shipments Based On"::"Ship-to Country":
                            CountryCode := Location."Ship-from Country/Region Code";
                        IntrastatReportSetup."Shipments Based On"::"Sell-to Country":
                            CountryCode := PurchCrMemoHeader."Buy-from Country/Region Code";
                        IntrastatReportSetup."Shipments Based On"::"Bill-to Country":
                            CountryCode := PurchCrMemoHeader."Pay-to Country/Region Code";
                    end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Intrastat Report Line", 'OnAfterValidateEvent', 'Tariff No.', false, false)]
    local procedure IntrastatReportLine_OnAfterValidateEvent_TariffNo(var Rec: Record "Intrastat Report Line")
    begin
        if Rec."Item No." <> '' then
            Rec.TestField("Tariff No.");
    end;


    local procedure GetShipFromLocation(pExtDocNo: Code[35]): Code[10];
    var
        recAmzOrderArch: Record 50010;
    begin
        recAmzOrderArch.SetRange("eCommerce Order Id", pExtDocNo);
        If recAmzOrderArch.FindFirst() then
            exit(recAmzOrderArch."Ship-from Country");
    end;
    #endregion

}
