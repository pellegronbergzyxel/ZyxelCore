codeunit 50026 "Item Budget Management Ext."
{
    // 001. 11-04-24 ZY-LD #2386066 - Filter on Previous.

    procedure GetMasterForecastName() BudgetName: Code[20];
    var
        recItemBudgetName: Record "Item Budget Name";
    begin
        recItemBudgetName.SetRange(Master, true);
        if recItemBudgetName.FindSet() then
            BudgetName := recItemBudgetName.Name;
    end;

    procedure GetBudgetForecastName() BudgetName: Code[20];
    var
        recItemBudgetName: Record "Item Budget Name";
    begin
        recItemBudgetName.SetRange(Budget, true);
        if recItemBudgetName.FindSet() then
            BudgetName := recItemBudgetName.Name;
    end;

    procedure GetPOForecastAvailabilityNow(var PurchaseOrderLine: Record "Purchase Line") Available: Integer;
    var
        recItemBudget: Record "Item Budget Entry";
        TotalQty: Integer;
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        recPurchaseLine: Record "Purchase Line";
        OutQty: Integer;
        recCustomer: Record Customer;
        Country: Code[20];
    begin
        if PurchaseOrderLine."No." = '' then exit(0);
        recItemBudget.SetFilter("Budget Name", GetMasterForecastName);
        recItemBudget.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+0M>', Today());
        BeginDate := DMY2Date(1, Date2DMY(StartDate, 2), Date2DMY(StartDate, 3));
        recItemBudget.SetFilter(Date, Format(BeginDate));
        if recItemBudget.FindSet() then begin
            repeat
                TotalQty := TotalQty + recItemBudget.Quantity;
            until recItemBudget.Next() = 0;
        end;
        recPurchaseLine.SetRange("Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SetFilter("No.", PurchaseOrderLine."No.");
        recPurchaseLine.SetRange("Order Date", BeginDate, CalcDate('<CM>', Today()));
        if recPurchaseLine.FindSet() then begin
            repeat
                OutQty := OutQty + recPurchaseLine.Quantity;
            until recPurchaseLine.Next() = 0;
        end;
        Available := TotalQty - OutQty;
    end;

    procedure GetPOForecastAvailability1M(var PurchaseOrderLine: Record "Purchase Line") Available: Integer;
    var
        recItemBudget: Record "Item Budget Entry";
        TotalQty: Integer;
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        recPurchaseLine: Record "Purchase Line";
        OutQty: Integer;
        recCustomer: Record Customer;
        Country: Code[20];
    begin
        if PurchaseOrderLine."No." = '' then
            exit(0);

        if PurchaseOrderLine."No." = '' then
            exit(0);

        recItemBudget.SetFilter("Budget Name", GetMasterForecastName);
        recItemBudget.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+1M>', Today());
        BeginDate := DMY2Date(1, Date2DMY(StartDate, 2), Date2DMY(StartDate, 3));
        recItemBudget.SetFilter(Date, Format(BeginDate));
        if recItemBudget.FindSet() then begin
            repeat
                TotalQty := TotalQty + recItemBudget.Quantity;
            until recItemBudget.Next() = 0;
        end;
        recPurchaseLine.SetRange("Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SetFilter("No.", PurchaseOrderLine."No.");
        recPurchaseLine.SetRange("Order Date", BeginDate, CalcDate('<+1M+CM>', Today()));
        if recPurchaseLine.FindSet() then begin
            repeat
                OutQty := OutQty + recPurchaseLine.Quantity;
            until recPurchaseLine.Next() = 0;
        end;
        Available := TotalQty - OutQty;
    end;

    procedure GetPOForecastAvailability2M(var PurchaseOrderLine: Record "Purchase Line") Available: Integer;
    var
        recItemBudget: Record "Item Budget Entry";
        TotalQty: Integer;
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        recPurchaseLine: Record "Purchase Line";
        OutQty: Integer;
        recCustomer: Record Customer;
        Country: Code[20];
    begin
        if PurchaseOrderLine."No." = '' then exit(0);
        recItemBudget.SetFilter("Budget Name", GetMasterForecastName);
        recItemBudget.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+2M>', Today());
        BeginDate := DMY2Date(1, Date2DMY(StartDate, 2), Date2DMY(StartDate, 3));
        recItemBudget.SetFilter(Date, Format(BeginDate));
        if recItemBudget.FindSet() then begin
            repeat
                TotalQty := TotalQty + recItemBudget.Quantity;
            until recItemBudget.Next() = 0;
        end;
        recPurchaseLine.SetRange("Document Type", recPurchaseLine."Document Type"::Order);
        recPurchaseLine.SetFilter("No.", PurchaseOrderLine."No.");
        recPurchaseLine.SetRange("Order Date", BeginDate, CalcDate('<+2M+CM>', Today()));
        if recPurchaseLine.FindSet() then begin
            repeat
                OutQty := OutQty + recPurchaseLine.Quantity;
            until recPurchaseLine.Next() = 0;
        end;
        Available := TotalQty - OutQty;
    end;

    procedure GetSOForecast(pSellToCustNo: Code[20]; pForecastTerritory: Code[20]; pItemNo: Code[20]; pDim1Code: Code[20]; pDateFormula: DateFormula; var pCountryFilter: Text; ShowEntries: Boolean; ExcludeFromForecast: Boolean; ShowForecastOnly: Boolean; ShowPrevious: Boolean) Available: Integer;
    var
        recItemBudget: Record "Item Budget Entry";
        recItemBudgetTmp: Record "Item Budget Entry" temporary;
        recSalesLine: Record "Sales Line";
        recItemLedg: Record "Item Ledger Entry";
        recCustomer: Record Customer;
        recTerritoryCountries: Record "Forecast Territory Country";
        recForecastTerritory: Record "Forecast Territory";
        ZGT: Codeunit "ZyXEL General Tools";
        StartDate: Date;
        BeginDate: Date;
        EndDate: Date;
        TotalQty: Integer;
        OutQty: Integer;
        EntryNo: Integer;
        lText001: Label '"""%1"" on ""%2"" %3 must not be blank."';
    begin
        //>> 20-08-18 ZY-LD 002
        if ZGT.IsRhq then
            if pItemNo <> '' then begin
                if pForecastTerritory = '' then begin
                    if recCustomer.Get(pSellToCustNo) then
                        if recCustomer."Territory Code" <> '' then begin
                            if recTerritoryCountries.Get(recCustomer."Territory Code", GetSalesLineDivision(pDim1Code)) then
                                pForecastTerritory := recTerritoryCountries."Forecast Territory Code"
                            else
                                exit;
                        end else
                            Error(lText001, recCustomer.FieldCaption("Territory Code"), recCustomer.TableCaption(), recCustomer."No.");
                end;

                recForecastTerritory.Get(pForecastTerritory);

                pCountryFilter := '';
                recTerritoryCountries.SetRange("Forecast Territory Code", pForecastTerritory);
                if pDim1Code <> '' then
                    recTerritoryCountries.SetRange("Division Code", GetSalesLineDivision(pDim1Code));
                if recTerritoryCountries.FindSet() then begin
                    repeat
                        if pCountryFilter = '' then
                            pCountryFilter := recTerritoryCountries."Territory Code"
                        else
                            pCountryFilter := pCountryFilter + '|' + recTerritoryCountries."Territory Code";
                    until recTerritoryCountries.Next() = 0;
                end else
                    exit;

                //StartDate := CalcDate(pDateFormula,TODAY);  // 03-11-20 ZY-LD 003
                StartDate := CalcDate(pDateFormula, WORKDATE);  // 03-11-20 ZY-LD 003
                BeginDate := CalcDate('<-CM>', StartDate);
                EndDate := CalcDate('<CM>', StartDate);

                recItemBudget.SetCurrentKey("Analysis Area", "Budget Name", "Item No.", Date);  // 03-11-20 ZY-LD 003
                //>> 11-04-24 ZY-LD 001
                if ShowPrevious then
                    recItemBudget.Setfilter("Budget Name", '%1|%2', GetMasterForecastName, 'PREVIOUS')
                else  //<< 11-04-24 ZY-LD 001
                    recItemBudget.SetRange("Budget Name", GetMasterForecastName);
                recItemBudget.SetRange("Item No.", pItemNo);
                recItemBudget.SetFilter("Budget Dimension 1 Code", pCountryFilter);
                if pDim1Code <> '' then
                    recItemBudget.SetRange("Global Dimension 1 Code", GetSalesLineDivision(pDim1Code));
                recItemBudget.SetRange(Date, BeginDate);
                if (GetSalesLineDivision(pDim1Code) = 'SP') and (pSellToCustNo <> '') then begin
                    recItemBudget.SetRange("Source Type", recItemBudget."Source Type"::Customer);
                    recItemBudget.SetRange("Source No.", pSellToCustNo);
                end;
                if recItemBudget.FindSet() then
                    repeat
                        //>> 16-02-22 ZY-LD 004
                        if ExcludeFromForecast and
                           (recItemBudget."Source Type" = recItemBudget."Source Type"::Customer) and
                           (recItemBudget."Source No." <> '')
                        then begin
                            if recCustomer.Get(recItemBudget."Source No.") and (not recCustomer."Exclude from Forecast") then
                                TotalQty := TotalQty + recItemBudget.Quantity;
                        end else  //<< 16-02-22 ZY-LD 004
                            TotalQty := TotalQty + recItemBudget.Quantity;
                        if ShowEntries then begin
                            recItemBudgetTmp := recItemBudget;
                            recItemBudgetTmp.Insert();
                            EntryNo := recItemBudget."Entry No.";
                        end;
                    until recItemBudget.Next() = 0;

                if not ShowForecastOnly then begin  // 08-03-22 ZY-LD 005
                    recSalesLine.SetCurrentKey("Document Type", "No.", "Sell-to Customer No.", "Shipment Date", "Shipment Date Confirmed");  // 03-11-20 ZY-LD 003
                    recSalesLine.SetFilter("Sell-to Customer Country", pCountryFilter);
                    recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                    recSalesLine.SetRange("No.", pItemNo);
                    recSalesLine.SetFilter("Outstanding Quantity", '<>0');
                    if pDim1Code <> '' then
                        recSalesLine.SetRange("Shortcut Dimension 1 Code", pDim1Code);
                    recSalesLine.SetRange("Shipment Date", BeginDate, EndDate);
                    recSalesLine.SetRange("Shipment Date Confirmed", true);
                    if ((GetSalesLineDivision(pDim1Code) = 'SP') or (recForecastTerritory."Calc. CH Forecast on Cust. No.")) and
                       (pSellToCustNo <> '')
                    then
                        recSalesLine.SetRange("Sell-to Customer No.", pSellToCustNo);

                    if recSalesLine.FindSet() then
                        repeat
                            //>> 16-02-22 ZY-LD 004
                            if ExcludeFromForecast and (recSalesLine."Sell-to Customer No." <> '') then begin
                                if recCustomer.Get(recSalesLine."Sell-to Customer No.") and (not recCustomer."Exclude from Forecast") then
                                    OutQty := OutQty - recSalesLine.Quantity;
                            end else  //<< 16-02-22 ZY-LD 004
                                OutQty := OutQty - recSalesLine.Quantity;

                            if ShowEntries then begin
                                Clear(recItemBudgetTmp);
                                EntryNo += 1;
                                recItemBudgetTmp."Entry No." := EntryNo;
                                recItemBudgetTmp."Budget Name" := GetBudgetForecastName;
                                recItemBudgetTmp.Date := recSalesLine."Shipment Date";
                                recItemBudgetTmp."Item No." := recSalesLine."No.";
                                recItemBudgetTmp."Source Type" := recItemBudgetTmp."Source Type"::Customer;
                                recItemBudgetTmp."Source No." := recSalesLine."Sell-to Customer No.";
                                recItemBudgetTmp.Quantity := -recSalesLine."Outstanding Quantity";
                                recItemBudgetTmp."Global Dimension 1 Code" := recSalesLine."Shortcut Dimension 1 Code";
                                recItemBudgetTmp."SO Number" := recSalesLine."Document No.";
                                recItemBudgetTmp.Insert();
                            end;
                        until recSalesLine.Next() = 0;

                    recItemLedg.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");  // 03-11-20 ZY-LD 003
                    recItemLedg.SetRange("Entry Type", recItemLedg."Entry Type"::Sale);
                    recItemLedg.SetFilter("Sell-To Customer Territory", pCountryFilter);
                    recItemLedg.SetRange("Item No.", pItemNo);
                    if pDim1Code <> '' then
                        recItemLedg.SetRange("Global Dimension 1 Code", pDim1Code);
                    recItemLedg.SetRange("Posting Date", BeginDate, EndDate);
                    if ((GetSalesLineDivision(pDim1Code) = 'SP') or (recForecastTerritory."Calc. CH Forecast on Cust. No.")) and
                       (pSellToCustNo <> '')
                    then begin
                        recItemLedg.SetRange("Source Type", recItemLedg."Source Type"::Customer);
                        recItemLedg.SetRange("Source No.", pSellToCustNo);
                    end;
                    if recItemLedg.FindSet() then
                        repeat
                            //>> 16-02-22 ZY-LD 004
                            if ExcludeFromForecast and (recItemLedg."Source No." <> '')
                            then begin
                                if recCustomer.Get(recItemLedg."Source No.") and (not recCustomer."Exclude from Forecast") then
                                    OutQty := OutQty + recItemLedg.Quantity;
                            end else  //<< 16-02-22 ZY-LD 004
                                OutQty := OutQty + recItemLedg.Quantity;

                            if ShowEntries then begin
                                Clear(recItemBudgetTmp);
                                EntryNo += 1;
                                recItemBudgetTmp."Entry No." := EntryNo;
                                recItemBudgetTmp."Budget Name" := GetBudgetForecastName;
                                recItemBudgetTmp.Date := recItemLedg."Posting Date";
                                recItemBudgetTmp."Item No." := recItemLedg."Item No.";
                                recItemBudgetTmp."Source Type" := recItemBudgetTmp."Source Type"::Customer;
                                recItemBudgetTmp."Source No." := recItemLedg."Source No.";
                                recItemBudgetTmp.Quantity := recItemLedg.Quantity;
                                recItemBudgetTmp."Global Dimension 1 Code" := recItemLedg."Global Dimension 1 Code";
                                recItemBudgetTmp."SO Number" := recItemLedg."Document No.";
                                recItemBudgetTmp.Insert();
                            end;
                        until recItemLedg.Next() = 0;
                end;

                Available := TotalQty + OutQty;

                if ShowEntries then
                    Page.RunModal(Page::"Forecast Entries", recItemBudgetTmp);
            end;
        //<< 20-08-18 ZY-LD 002
    end;

    procedure GetSalesLineDivision(DivisionCode: Code[20]) Division: Code[20];
    begin
        Division := DivisionCode;
        if DivisionCode = 'CH-PARTNER' then
            Division := 'CH';
        if DivisionCode = 'SP-PARTNER' then
            Division := 'SP';
    end;
}
