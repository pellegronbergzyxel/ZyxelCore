Page 50307 "Forecast Overview"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - Created.
    // 002. 05-07-19 ZY-LD P0213 - EU2Inventory is replaced by Inventory.
    // 003. 16-02-22 ZY-LD 2022021410000035 - Exclude from forecast.
    // 004. 11-04-24 ZY-LD #2386066 - ItemBudgMgt.GetSOForecast has been add an extra parameter.

    Caption = 'Forecast Overview';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Forecast Territory";
    SourceTableView = where("Show on Forecast List" = const(true));

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                group(Control15)
                {
                    field(DivisionFilter; DivisionFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Division Filter';

                        trigger OnValidate()
                        begin
                            if DivisionFilter <> Divisionfilter::"Service Provider" then
                                CustomerFilter := '';
                            CalculateTotal;
                            CurrPage.Update;
                        end;
                    }
                    field(CustomerFilter; CustomerFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer No.';
                        TableRelation = Customer;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ShowCustomers;
                            UpdateCustomerFilter;
                        end;

                        trigger OnValidate()
                        begin
                            UpdateCustomerFilter;
                        end;
                    }
                }
                field(ShowForecastOnly; ShowForecastOnly)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Forecast Only';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(ShowMasterOnly; ShowPrevious)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Previous';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
            }
            repeater(ForecastSP)
            {
                Caption = 'Forecast';
                field(CodeSP; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(DescriptionSP; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ForecastNow[1]"; ForecastNow[1])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[1];
                    Caption = 'Forecast 0M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '0M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[2]"; ForecastNow[2])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[2];
                    Caption = 'Forecast 1M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '1M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[3]"; ForecastNow[3])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[3];
                    Caption = 'Forecast 2M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '2M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[4]"; ForecastNow[4])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[4];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '3M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[5]"; ForecastNow[5])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[5];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '4M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[6]"; ForecastNow[6])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[6];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '5M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[7]"; ForecastNow[7])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[7];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '6M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field("ForecastNow[8]"; ForecastNow[8])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[8];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Evaluate(DateFormula, '7M');
                        ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, DummyFilter, true, false, ShowForecastOnly, ShowPrevious);
                    end;
                }
                field(TotalNow; TotalNow)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Total';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(CountryFilter; CountryFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country Filter';
                    Visible = false;
                }
            }
            group(Total)
            {
                Caption = 'Total';
                field("TotalForecast[1]"; TotalForecast[1])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[1];
                    Caption = 'Forecast 0M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[2]"; TotalForecast[2])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[2];
                    Caption = 'Forecast 1M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[3]"; TotalForecast[3])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[3];
                    Caption = 'Forecast 2M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[4]"; TotalForecast[4])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[4];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[5]"; TotalForecast[5])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[5];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[6]"; TotalForecast[6])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[6];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[7]"; TotalForecast[7])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[7];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("TotalForecast[8]"; TotalForecast[8])
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    CaptionClass = CaptionClass[8];
                    Caption = 'Forecast 3M';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("Total Forecast"; Total)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Forecast';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
                field("recItem.Inventory"; recItem.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. On-Hand EU2';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recItem.SetLocationFilterOnMainWarehouse;  // 05-07-19 ZY-LD 010
        recItem.SetAutocalcFields(Inventory);
        //recItem.SETAUTOCALCFIELDS(EU2Inventory);  // 05-07-19 ZY-LD 010

        recItem.Get(ItemNo);

        TotalNow := 0;
        for i := 0 to ArrayLen(ForecastNow) - 1 do begin
            Clear(CountryFilter);
            Evaluate(DateFormula, Format(i) + 'M');
            ForecastNow[i + 1] := ItemBudgMgt.GetSOForecast(CustomerFilter, Rec.Code, ItemNo, GetDivisionCode, DateFormula, CountryFilter, false, false, ShowForecastOnly, ShowPrevious);
            TotalNow += ForecastNow[i + 1];
        end;
    end;

    trigger OnInit()
    begin
        ZGT.OpenProgressWindow(Text001, 1);
    end;

    trigger OnOpenPage()
    begin
        CalculateTotal();
        ZGT.CloseProgressWindow;

        SI.UseOfReport(8, 50307, 0);  // 16-02-22 ZY-LD 000
    end;

    var
        recItem: Record Item;
        ForecastNow: array[8] of Decimal;
        TotalNow: Decimal;
        TotalForecast: array[8] of Decimal;
        Total: Decimal;
        ItemBudgMgt: Codeunit "Item Budget Management Ext.";
        ItemNo: Code[20];
        DateFormula: DateFormula;
        i: Integer;
        CountryFilter: Text;
        DummyFilter: Text;
        DivisionFilter: Option Both,Channel,"Service Provider";
        xDivisionCode: Code[10];
        CaptionClass: array[8] of Text;
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: label 'Calculating Forecast';
        CustomerFilter: Code[20];
        SI: Codeunit "Single Instance";
        ShowForecastOnly: Boolean;
        ShowPrevious: Boolean;


    procedure Init(pItemNo: Code[20])
    begin
        ItemNo := pItemNo;
    end;

    local procedure CalculateTotal()
    var
        recForeTerri: Record "Forecast Territory";
        lCountryFilter: Text;
        ForecastQty: Decimal;
    begin
        recForeTerri.SetRange("Show on Forecast List", true);
        if recForeTerri.FindSet then
            repeat
                for i := 0 to ArrayLen(TotalForecast) - 1 do begin
                    Evaluate(DateFormula, Format(i) + 'M');
                    ForecastQty := ItemBudgMgt.GetSOForecast(CustomerFilter, recForeTerri.Code, ItemNo, GetDivisionCode, DateFormula, lCountryFilter, false, false, ShowForecastOnly, ShowPrevious);
                    TotalForecast[i + 1] += ForecastQty;
                    Total += ForecastQty;

                    if CaptionClass[i + 1] = '' then
                        CaptionClass[i + 1] := ZGT.GetMonthText(Date2dmy(CalcDate(DateFormula, Today), 2), false, false, false);
                end;
            until recForeTerri.Next() = 0;
    end;

    local procedure ShowCustomers()
    var
        recItemBudgetEntry: Record "Item Budget Entry";
        recCustTmp: Record Customer temporary;
        recCust: Record Customer;
    begin
        recItemBudgetEntry.SetRange("Budget Name", 'MASTER');
        recItemBudgetEntry.SetRange("Source Type", recItemBudgetEntry."source type"::Customer);
        recItemBudgetEntry.SetRange("Item No.", ItemNo);
        recItemBudgetEntry.SetRange(Date, CalcDate('<-CM>', Today), CalcDate('<CM+3M>', Today));
        recItemBudgetEntry.SetFilter("Global Dimension 1 Code", 'SP*');
        if recItemBudgetEntry.FindSet then
            repeat
                if recCust.Get(recItemBudgetEntry."Source No.") then begin
                    recCustTmp := recCust;
                    if not recCustTmp.Insert then;
                end;
            until recItemBudgetEntry.Next() = 0;

        if not recCustTmp.IsEmpty then
            if Page.RunModal(Page::"Customer List (Short)", recCustTmp) = Action::LookupOK then begin
                CustomerFilter := recCustTmp."No.";
                CurrPage.Update;
            end;
    end;

    local procedure GetDivisionCode(): Code[10]
    begin
        case DivisionFilter of
            0:
                exit;
            1:
                exit('CH');
            2:
                exit('SP');
        end;
    end;

    local procedure UpdateCustomerFilter()
    begin
        if CustomerFilter <> '' then
            DivisionFilter := Divisionfilter::"Service Provider"
        else
            DivisionFilter := Divisionfilter::Both;
        CalculateTotal;
        CurrPage.Update;
    end;
}
