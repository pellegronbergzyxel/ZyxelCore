Codeunit 50007 "Pick. Date Confirm Management"
{
    // 001. 30-12-20 ZY-LD P0499 - Created.
    // 002. 29-01-21 ZY-LD 2021012810000227 - Location Filter was missing.
    // 003. 11-04-24 ZY-LD #2386066 - ItemBudgMgt.GetSOForecast has been add an extra parameter.

    TableNo = "Picking Date Confirmed";

    trigger OnRun()
    var
        recPickdateConf: Record "Picking Date Confirmed";
        recSalesLine: Record "Sales Line";
        recTransLine: Record "Transfer Line";
        recItem: Record Item;
        ItemBudgetMgt: Codeunit "Item Budget Management Ext.";
        ZGT: Codeunit "ZyXEL General Tools";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        ForecastQty: Decimal;
        DateFormula: DateFormula;
        MonthFormula: Text[10];
        YearFormula: Text[10];
        CountryFilter: Text;
        ForecastTerritory: Code[20];
    begin
        if ZGT.IsRhq then begin
            recPickdateConf.SetCurrentkey("Picking Date", "Picking Date Confirmed");
            recPickdateConf.CopyFilters(Rec);
            recPickdateConf.SetRange("Picking Date", CalcDate('<-CM>', Today), CalcDate('<CM+3M>', Today));
            recPickdateConf.SetRange("Picking Date Confirmed", false);
            recPickdateConf.SetAutocalcFields("Sell-to Customer No.", "Transfer-to Code");
            if recPickdateConf.FindSet then begin
                ZGT.OpenProgressWindow('', recPickdateConf.Count);
                recSalesLine.LockTable;
                recTransLine.LockTable;
                repeat
                    ZGT.UpdateProgressWindow(StrSubstNo('%1 - %2', recPickdateConf."Item No.", recPickdateConf."Picking Date"), 0, true);

                    MonthFormula := Format(Date2dmy(recPickdateConf."Picking Date", 2) - Date2dmy(Today, 2)) + 'M';
                    YearFormula := Format(Date2dmy(recPickdateConf."Picking Date", 3) - Date2dmy(Today, 3)) + 'Y';
                    Evaluate(DateFormula, MonthFormula + '+' + YearFormula);

                    if recPickdateConf."Source Type" = recPickdateConf."source type"::"Transfer Order" then
                        ForecastTerritory := ItemLogisticEvent.GetForecastTerritory(recPickdateConf."Transfer-to Code", GetDivisionCode);

                    ForecastQty :=
                      ItemBudgetMgt.GetSOForecast(
                        recPickdateConf."Sell-to Customer No.",
                        ForecastTerritory,
                        recPickdateConf."Item No.",
                        GetDivisionCode,
                        DateFormula,
                        CountryFilter,
                        false,
                        false,
                        false,
                        false);

                    recItem.SetRange("Location Filter", recPickdateConf."Location Code");  // 29-01-21 ZY-LD 002
                    recItem.Get(recPickdateConf."Item No.");
                    if (recPickdateConf."Outstanding Quantity" <= recItem.CalcAvailableStock(false)) and
                       (recPickdateConf."Outstanding Quantity" <= ForecastQty)
                    then begin
                        case recPickdateConf."Source Type" of
                            recPickdateConf."source type"::"Sales Order":
                                if recSalesLine.Get(recSalesLine."document type"::Order, recPickdateConf."Source No.", recPickdateConf."Source Line No.") then begin
                                    recSalesLine.SuspendStatusCheck(true);
                                    recSalesLine.Validate("Shipment Date Confirmed", true);
                                    recSalesLine.Modify(true);
                                    recSalesLine.SuspendStatusCheck(false);
                                end;
                            recPickdateConf."source type"::"Transfer Order":
                                if recTransLine.Get(recPickdateConf."Source No.", recPickdateConf."Source Line No.") then begin
                                    recTransLine.Validate("Shipment Date Confirmed", true);
                                    recTransLine.Modify(true);
                                end;
                        end;
                    end;
                until recPickdateConf.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        end;
    end;

    local procedure RunConfirmation(pType: Option "Sales Order","Transfer Order",Rework; pNo: Code[20])
    var
        recPickdateConf: Record "Picking Date Confirmed";
    begin
        if pNo <> '' then begin
            recPickdateConf.SetRange("Source Type", pType);
            recPickdateConf.SetRange("Source No.", pNo);
            Codeunit.Run(Codeunit::"Pick. Date Confirm Management", recPickdateConf);
        end;
    end;


    procedure PerformManuelConfirm(pType: Option "Sales Order","Transfer Order",Rework; pNo: Code[20]) rValue: Boolean
    var
        lText001: label 'Do you want to run "Auto Confirm"?';
    begin
        if Confirm(lText001, true) then begin
            rValue := true;

            if pNo <> '' then begin
                if PerformManuelConfirm2(pType, pNo) then
                    RunConfirmation(pType, pNo);
            end else
                if PerformManuelConfirm2(pType, pNo) then
                    RunConfirmation(0, '');
        end;
    end;


    procedure PerformManuelConfirm2(pType: Option "Sales Order","Transfer Order",Rework; pNo: Code[20]) rValue: Boolean
    var
        lText001: label 'Do you want to update "%3" on\"%1" %2?';
        lText002: label 'Do you want to update "%1"?';
        recSalesLine: Record "Sales Line";
        SI: Codeunit "Single Instance";
    begin
        if pNo <> '' then
            rValue := Confirm(lText001, true, pType, pNo, recSalesLine.FieldCaption("Shipment Date"))
        else
            rValue := Confirm(lText002, true, recSalesLine.FieldCaption("Shipment Date"));
        SI.SetUpdateShipmentDate(rValue);
    end;

    local procedure GetDivisionCode(): Code[10]
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsZComCompany then
            exit('SP')
        else
            exit('CH');
    end;
}
