pageextension 50292 SalesLineFactBoxZX extends "Sales Line FactBox"
{
    // 001. 11-04-24 ZY-LD #2386066 - ItemBudgMgt.GetSOForecast has been add an extra parameter.
    layout
    {
        addafter(Item)
        {
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
                        //>> 20-08-18 ZY-LD 001
                        Evaluate(DateFormula, '-1M');
                        ItemBudgetManagement.GetSOForecast(Rec."Sell-to Customer No.", '', Rec."No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                        //<< 20-08-18 ZY-LD 001
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
                        //>> 20-08-18 ZY-LD 001
                        Evaluate(DateFormula, '0M');
                        ItemBudgetManagement.GetSOForecast(Rec."Sell-to Customer No.", '', Rec."No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                        //<< 20-08-18 ZY-LD 001
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
                        //>> 20-08-18 ZY-LD 001
                        Evaluate(DateFormula, '1M');
                        ItemBudgetManagement.GetSOForecast(Rec."Sell-to Customer No.", '', Rec."No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                        //<< 20-08-18 ZY-LD 001
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
                        //>> 20-08-18 ZY-LD 001
                        Evaluate(DateFormula, '2M');
                        ItemBudgetManagement.GetSOForecast(Rec."Sell-to Customer No.", '', Rec."No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                        //<< 20-08-18 ZY-LD 001
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
                        //>> 20-08-18 ZY-LD 001
                        Evaluate(DateFormula, '3M');
                        ItemBudgetManagement.GetSOForecast(Rec."Sell-to Customer No.", '', Rec."No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, true, false, false, false);
                        //<< 20-08-18 ZY-LD 001
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
        addfirst(processing)
        {
            action("Forecast 0M")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Forecast 0M';
                Image = Forecast;
                ToolTip = 'Show Forecase entries for now';
            }
            action("Forecast 1M")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Forecast 1M';
                Image = Forecast;
                ToolTip = 'Show Forecase entries for now plus 1 month';
            }
            action("Forecast 2M")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Forecast 2M';
                Image = Forecast;
                ToolTip = 'Show Forecase entries for now plus 2 months';
            }
            action("Forecast 3M")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Forecast 3M';
                Image = Forecast;
                ToolTip = 'Show Forecase entries for now plus 3 months';
            }
            separator(Action32)
            {
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        CalculateForecast();  // 20-08-18 ZY-LD 001

        //>> 05-07-19 ZY-LD 003
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
            recItem.SetRange("Location Filter", SalesHeader."Location Code");
            recItem.Get(Rec."No.");
        end;
        //<< 05-07-19 ZY-LD 003
    end;

    var
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

    local procedure CalculateForecast()
    var
        i: Integer;
    begin
        //>> 20-08-18 ZY-LD 001
        for i := -1 to 3 do begin  // 08-04-19 ZY-LD 002 - i is changed from 0 to -1.
            CountryFilter := '';
            Evaluate(DateFormula, Format(i) + 'M');
            ForecastQty[i + 2] := ItemBudgetManagement.GetSOForecast(Rec."Sell-to Customer No.", '', Rec."No.", Rec."Shortcut Dimension 1 Code", DateFormula, CountryFilter, false, false, false, false);
            CaptionClass[i + 2] := ZGT.GetMonthText(Date2dmy(CalcDate(DateFormula, Today), 2), false, false, false);
            if ForecastQty[i + 2] < 0 then begin
                case i of
                    -1:
                        ForecastStyle0M := 'Unfavorable';  // 08-04-19 ZY-LD 002
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
                        ForecastStyle0M := 'StandardAccent';  // 08-04-19 ZY-LD 002
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
        //<< 20-08-18 ZY-LD 001
    end;
}
