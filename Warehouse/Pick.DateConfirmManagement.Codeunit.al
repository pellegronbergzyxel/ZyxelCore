Codeunit 50007 "Pick. Date Confirm Management"
{
    TableNo = "Picking Date Confirmed";

    trigger OnRun()
    var
        recPickdateConf: Record "Picking Date Confirmed";
        recSalesLine: Record "Sales Line";
        recTransLine: Record "Transfer Line";
        recItem: Record Item;
        SalesSetup: Record "Sales & Receivables Setup";
        ItemBudgetMgt: Codeunit "Item Budget Management Ext.";
        ZGT: Codeunit "ZyXEL General Tools";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        SalesHeaderLineEvents: codeunit "Sales Header/Line Events";
        ForecastQty: Decimal;
        NewQuantity: Decimal;
        DateFormula: DateFormula;
        MonthFormula: Text[10];
        YearFormula: Text[10];
        CountryFilter: Text;
        ForecastTerritory: Code[20];
        SkipWrongCarton: Boolean;
        lText002: Label 'Minimum Carton Ordering Policy is not complied.\\ Line No. %3, Item No. %4\\Quantity: %1\New Quantity: %2\\Do you want to proseed with the next lines?';
    begin
        if ZGT.IsRhq() then begin
            SalesSetup.Get(); ////08-01-2016 BK #533802
            SkipWrongCarton := false;
            recPickdateConf.SetCurrentkey("Picking Date", "Picking Date Confirmed");
            recPickdateConf.CopyFilters(Rec);
            recPickdateConf.SetRange("Picking Date", CalcDate('<-CM>', Today), CalcDate('<CM+3M>', Today));
            recPickdateConf.SetRange("Picking Date Confirmed", false);
            recPickdateConf.SetAutocalcFields("Sell-to Customer No.", "Transfer-to Code");
            if recPickdateConf.FindSet() then begin
                ZGT.OpenProgressWindow('', recPickdateConf.Count);
                recSalesLine.LockTable();
                recTransLine.LockTable();
                repeat
                    ZGT.UpdateProgressWindow(StrSubstNo('%1 - %2', recPickdateConf."Item No.", recPickdateConf."Picking Date"), 0, true);

                    MonthFormula := Format(Date2dmy(recPickdateConf."Picking Date", 2) - Date2dmy(Today, 2)) + 'M';
                    YearFormula := Format(Date2dmy(recPickdateConf."Picking Date", 3) - Date2dmy(Today, 3)) + 'Y';
                    Evaluate(DateFormula, MonthFormula + '+' + YearFormula);

                    if recPickdateConf."Source Type" = recPickdateConf."source type"::"Transfer Order" then
                        ForecastTerritory := ItemLogisticEvent.GetForecastTerritory(recPickdateConf."Transfer-to Code", GetDivisionCode());

                    //08-01-2016 BK #533802
                    if recSalesLine.Get(recSalesLine."document type"::Order, recPickdateConf."Source No.", recPickdateConf."Source Line No.") then begin
                        recItem.Get(recPickdateConf."Item No.");
                        NewQuantity := SalesHeaderLineEvents.CartonOrderingPolicySL(recSalesLine, SalesSetup, recItem);
                        if recSalesLine.Quantity <> NewQuantity then begin
                            if Confirm(lText002, true, recSalesLine.Quantity, NewQuantity, recSalesLine."Line No.", recSalesLine."No.") then
                                SkipWrongCarton := true;
                        end else
                            SkipWrongCarton := true;
                    end;

                    IF SkipWrongCarton then BEGIN
                        ForecastQty :=
                        ItemBudgetMgt.GetSOForecast(
                            recPickdateConf."Sell-to Customer No.",
                            ForecastTerritory,
                            recPickdateConf."Item No.",
                            GetDivisionCode(),
                            DateFormula,
                            CountryFilter,
                            false,
                            false,
                            false,
                            false);

                        recItem.SetRange("Location Filter", recPickdateConf."Location Code");
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
                        end; //modyfied sales/transline
                    end; //skipwrongcarton
                until recPickdateConf.Next() = 0;
                ZGT.CloseProgressWindow();
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
        recSalesLine: Record "Sales Line";
        SI: Codeunit "Single Instance";
        lText001: label 'Do you want to update "%3" on\"%1" %2?';
        lText002: label 'Do you want to update "%1"?';
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
        if ZGT.IsZComCompany() then
            exit('SP')
        else
            exit('CH');
    end;
}
