page 50354 "Transfer Line FactBox"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - New function call on forecast.
    // 002. 08-04-19 ZY-LD 2019032610000053 - Sales Order Forecast now also calculates CM-1.
    // 003. 05-07-19 ZY-LD P0213 - Stock calculation is changed to new function.
    // 004. 11-11-20 ZY-LD P0499 - Run only if Main warehouse.
    // 005. 11-04-24 ZY-LD #2386066 - ItemBudgMgt.GetSOForecast has been add an extra parameter.

    Caption = 'Transfer Line Details';
    PageType = CardPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            field(ItemNo; Rec."Item No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item No.';
                Lookup = false;

                trigger OnDrillDown()
                begin
                    //SalesInfoPaneMgt.LookupItem(Rec);
                end;
            }
            field("Required Quantity"; Rec."Outstanding Quantity" - Rec."Reserved Quantity Outbnd.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Required Quantity';
                DecimalPlaces = 0 : 5;
            }
            field(ForecastTerritory; ForecastTerritory)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Forecase Territory';
            }
            group(Forecast)
            {
                Caption = 'Forecast';
                field("ForecastQty[1]"; ForecastQty[1])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = CaptionClass[1];
                    Caption = 'Forecast -1M';
                    StyleExpr = ForecastStyle0M;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '-1M');
                        ItemBudgetManagement.GetSOForecast('', GetForecastTerritory(Rec."Transfer-to Code"), Rec."Item No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                    end;
                }
                field("ForecastQty[2]"; ForecastQty[2])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = CaptionClass[2];
                    Caption = 'Forecast 0M';
                    StyleExpr = ForecastStyle1M;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '0M');
                        ItemBudgetManagement.GetSOForecast('', GetForecastTerritory(Rec."Transfer-to Code"), Rec."Item No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                    end;
                }
                field("ForecastQty[3]"; ForecastQty[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = CaptionClass[3];
                    Caption = 'Forecast 1M';
                    StyleExpr = ForecastStyle2M;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '1M');
                        ItemBudgetManagement.GetSOForecast('', GetForecastTerritory(Rec."Transfer-to Code"), Rec."Item No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                    end;
                }
                field("ForecastQty[4]"; ForecastQty[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = CaptionClass[4];
                    Caption = 'Forecast 2M';
                    StyleExpr = ForecastStyle3M;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '2M');
                        ItemBudgetManagement.GetSOForecast('', GetForecastTerritory(Rec."Transfer-to Code"), Rec."Item No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                    end;
                }
                field("ForecastQty[5]"; ForecastQty[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = CaptionClass[5];
                    Caption = 'Forecast 3M';
                    StyleExpr = ForecastStyle3M;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '3M');
                        ItemBudgetManagement.GetSOForecast('', GetForecastTerritory(Rec."Transfer-to Code"), Rec."Item No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                    end;
                }
            }
            group(Stock)
            {
                Caption = 'Stock';
                field("recItem.CalcAvailableStock(TRUE)"; recItem.CalcAvailableStock(true))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'For Sales';
                    DecimalPlaces = 0 : 0;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //CALCFIELDS("Reserved Quantity");
        recInvSetup.Get();  // 11-11-20 ZY-LD 004
        if Rec."Transfer-from Code" = recInvSetup."AIT Location Code" then  // 11-11-20 ZY-LD 004
            CalculateForecast;  // 20-08-18 ZY-LD 001

        //>> 05-07-19 ZY-LD 003
        if Rec."Item No." <> '' then begin
            TransferHeader.Get(Rec."Document No.");
            recItem.SetRange("Location Filter", TransferHeader."Transfer-from Code");
            recItem.Get(Rec."Item No.");
        end;
        //<< 05-07-19 ZY-LD 003

        ForecastTerritory := GetForecastTerritory(Rec."Transfer-to Code");
    end;

    var
        TransferHeader: Record "Transfer Header";
        recInvSetup: Record "Inventory Setup";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
        ZGT: Codeunit "ZyXEL General Tools";
        frmShow: Page "Forecast Entries";
        ForecastQty: array[5] of Integer;
        CaptionClass: array[5] of Text[10];
        CountryFilter: Text;
        DateFormula: DateFormula;
        "ForecastStyle-1M": Text[20];
        ForecastStyle0M: Text[20];
        ForecastStyle1M: Text[20];
        ForecastStyle2M: Text[20];
        ForecastStyle3M: Text[20];
        recItem: Record Item;
        ForecastTerritory: Code[10];

    local procedure CalculateForecast()
    var
        i: Integer;
    begin
        for i := -1 to 3 do begin
            CountryFilter := '';
            Evaluate(DateFormula, Format(i) + 'M');
            ForecastQty[i + 2] := ItemBudgetManagement.GetSOForecast('', GetForecastTerritory(Rec."Transfer-to Code"), Rec."Item No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, false, false, false, false);
            CaptionClass[i + 2] := ZGT.GetMonthText(Date2dmy(CalcDate(DateFormula, Today), 2), false, false, false);
            if ForecastQty[i + 2] < 0 then begin
                case i of
                    -1:
                        ForecastStyle0M := 'Unfavorable';
                    0:
                        ForecastStyle0M := 'Unfavorable';
                    1:
                        ForecastStyle1M := 'Unfavorable';
                    2:
                        ForecastStyle2M := 'Unfavorable';
                    3:
                        ForecastStyle3M := 'Unfavorable';
                end;
            end else
                case i of
                    -1:
                        ForecastStyle0M := 'StandardAccent';
                    0:
                        ForecastStyle0M := 'StandardAccent';
                    1:
                        ForecastStyle1M := 'StandardAccent';
                    2:
                        ForecastStyle2M := 'StandardAccent';
                    3:
                        ForecastStyle3M := 'StandardAccent';
                end;
        end;
    end;

    local procedure GetForecastTerritory(pLocationCode: Code[10]) rValue: Code[20]
    var
        recLocation: Record Location;
        recForeTerrCountry: Record "Forecast Territory Country";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        recLocation.Get(pLocationCode);
        if recLocation."Forecast Territory" <> '' then
            rValue := recLocation."Forecast Territory"
        else begin
            recForeTerrCountry.SetRange("Territory Code", recLocation."Country/Region Code");
            if ZGT.IsZComCompany then
                recForeTerrCountry.SetRange("Division Code", 'SP')
            else
                recForeTerrCountry.SetRange("Division Code", 'CH');
            if recForeTerrCountry.FindFirst() then
                rValue := recForeTerrCountry."Forecast Territory Code";
        end;
    end;
}
