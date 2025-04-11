report 50093 "Future Position Inventory"
{
    // 001. 18-06-18 ZY-LD 2018061510000034 - Create list on a previous date.
    // 002. 25-01-19 ZY-LD 2019012310000071 - Adjustments for reporting 2019.
    // 003. 23-01-20 ZY-LD 000 - Audit found errors in the aging when we transfered from one location to another. That is now fixed.
    // 004. 11-02-20 ZY-LD 000 - Create Inventory Movements is running in a job queue, and is updating every day.
    // 005. 07-04-20 ZY-LD 2020040710000076 - When a transfer comes from a journal it doesn´t have an Order No. We use Document No. instead when it comes from the journal.
    // 006. 15-04-20 ZY-LD 2020041410000035 - Jamie wants the inventory movements pr. aging code.
    // 007. 16-02-22 ZY-LD 2022021410000035 - Exclude from forecast.
    // 008. 01-06-22 ZY-LD 2022041110000108 - Aged value for current and previous year needs to be shown.
    // 009. 11-04-24 ZY-LD #2386066 - ItemBudgMgt.GetSOForecast has been add an extra parameter.

    Caption = 'Future Position Inventory';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Location; Location)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            dataitem(Item; Item)
            {
                CalcFields = "Net Change", "Cost Amount (Actual)", "Cost Amount (Expected)", "Cost Posted to G/L";
                DataItemTableView = sorting("Item Category Code", Description) order(descending) where(Type = const(Inventory));
                RequestFilterFields = "No.";
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    CalcFields = "Cost Amount (Expected)", "Cost Amount (Actual)", "Cost Posted to G/L";
                    DataItemLink = "Item No." = field("No."), "Posting Date" = field("Date Filter"), "Location Code" = field("Location Filter"), "Date Filter" = field("Date Filter");
                    DataItemTableView = sorting("Item No.", "Posting Date");

                    trigger OnAfterGetRecord()
                    var
                        TransferUnappQty: Decimal;
                        UnappQtyToCreate: Decimal;
                        RemainingQty: Decimal;
                    begin
                        TotalCostAmount += "Item Ledger Entry"."Cost Amount (Actual)" + "Item Ledger Entry"."Cost Amount (Expected)";

                        UnappliedQty := "Item Ledger Entry".CalculateRemQuantity("Item Ledger Entry"."Entry No.", BaseDate);

                        if (UnappliedQty <> 0) or (Round(AverageCostAmount * UnappliedQty) <> 0) or (Round(AverageCostAmountGL * UnappliedQty) <> 0) or ShowClosedDetailedEntries then begin
                            ItemQuantity += UnappliedQty;
                            PostingDate := "Item Ledger Entry"."Posting Date";
                            EntryPosted := false;

                            //>> 23-01-20 ZY-LD 003
                            if ("Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."entry type"::Transfer) and ("Item Ledger Entry"."Order No." <> '') or ("Item Ledger Entry"."Document No." <> '') then begin
                                if "Item Ledger Entry"."Order No." <> '' then begin  // 07-04-20 ZY-LD 005
                                    if "Item Ledger Entry"."Order No." <> recItemLedgEntry."Order No." then
                                        ItemAppEntryTmp2.DeleteAll();
                                end else //>> 07-04-20 ZY-LD 005
                                    if "Item Ledger Entry"."Document No." <> recItemLedgEntry."Document No." then
                                        ItemAppEntryTmp2.DeleteAll();
                                //<< 07-04-20 ZY-LD 005

                                recItemLedgEntry.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                                recItemLedgEntry.SetRange("Entry Type", "Item Ledger Entry"."Entry Type");
                                if "Item Ledger Entry"."Order No." <> '' then  // 07-04-20 ZY-LD 005
                                    recItemLedgEntry.SetRange("Order No.", "Item Ledger Entry"."Order No.")
                                else  // 07-04-20 ZY-LD 005
                                    recItemLedgEntry.SetRange("Document No.", "Item Ledger Entry"."Document No.");  // 07-04-20 ZY-LD 005
                                recItemLedgEntry.SetRange("Location Code", recInvSetup."AIT Location Code");
                                if recItemLedgEntry.FindFirst() then begin
                                    ItemAppEntryTmp.Reset();  // 01-06-22 ZY-LD 008
                                    ItemAppEntryTmp.DeleteAll();
                                    ShowAppEntries.FindAppliedEntries(recItemLedgEntry, ItemAppEntryTmp);
                                    TransferUnappQty := UnappliedQty;

                                    ItemAppEntryTmp.SetCurrentkey("Item No.", "Posting Date");
                                    ItemAppEntryTmp.SetFilter("Posting Date", '<%1', PostingDate);  // 01-06-22 ZY-LD 008
                                    ItemAppEntryTmp.Ascending(false);
                                    if ItemAppEntryTmp.FindSet() then
                                        if ItemAppEntryTmp.Count = 1 then
                                            PostingDate := ItemAppEntryTmp."Posting Date"
                                        else
                                            repeat
                                                if not ItemAppEntryTmp2.Get(ItemAppEntryTmp."Entry No.") then
                                                    Clear(ItemAppEntryTmp2);
                                                RemainingQty := ItemAppEntryTmp.Quantity - ItemAppEntryTmp2.Quantity;

                                                if (RemainingQty > 0) then begin
                                                    if RemainingQty < TransferUnappQty then
                                                        UnappQtyToCreate := RemainingQty
                                                    else
                                                        UnappQtyToCreate := TransferUnappQty;

                                                    LineCostAmount := AverageCostAmount * UnappQtyToCreate;
                                                    LineCostAmountGL := AverageCostAmountGL * UnappQtyToCreate;
                                                    CreateItemLedgerEntryTemp(
                                                      "Item Ledger Entry"."Item No.",
                                                      "Item Ledger Entry"."Location Code",
                                                      "Item Ledger Entry"."Global Dimension 1 Code",
                                                      ItemAppEntryTmp."Posting Date",
                                                      UnappQtyToCreate,
                                                      LineCostAmount);
                                                    ItemCostAmount += LineCostAmount;
                                                    ItemCostAmountGL += LineCostAmountGL;

                                                    if ItemAppEntryTmp2."Entry No." <> 0 then begin
                                                        ItemAppEntryTmp2.Quantity += UnappQtyToCreate;
                                                        ItemAppEntryTmp2.Modify();
                                                    end else begin
                                                        ItemAppEntryTmp2."Entry No." := ItemAppEntryTmp."Entry No.";
                                                        ItemAppEntryTmp2.Quantity := UnappQtyToCreate;
                                                        ItemAppEntryTmp2.Insert();
                                                    end;

                                                    TransferUnappQty -= UnappQtyToCreate;
                                                    EntryPosted := true;
                                                end;
                                            until (ItemAppEntryTmp.Next() = 0) or (TransferUnappQty <= 0);
                                end;
                            end;
                            //<< 23-01-20 ZY-LD 003

                            if not EntryPosted then begin
                                LineCostAmount := AverageCostAmount * UnappliedQty;  // 23-01-20 ZY-LD 003
                                LineCostAmountGL := AverageCostAmountGL * UnappliedQty;  // 23-01-20 ZY-LD 003
                                CreateItemLedgerEntryTemp(
                                  "Item Ledger Entry"."Item No.",
                                  "Item Ledger Entry"."Location Code",
                                  "Item Ledger Entry"."Global Dimension 1 Code",  // 25-01-19 ZY-LD 002
                                  PostingDate,
                                  UnappliedQty,
                                  LineCostAmount);
                                ItemCostAmount += LineCostAmount;  // 23-01-20 ZY-LD 003
                                ItemCostAmountGL += LineCostAmountGL;  // 23-01-20 ZY-LD 003
                            end;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if (ItemQuantity <> 0) or (Round(ItemCostAmount) <> 0) or (Round(ItemCostAmountGL) <> 0) then
                            if ItemQuantity <> Item."Net Change" then
                                CreateItemLedgerEntryTemp(
                                  Item."No.",
                                  Location.Code,
                                  "Item Ledger Entry"."Global Dimension 1 Code",  // 25-01-19 ZY-LD 002
                                  "Item Ledger Entry"."Posting Date",
                                  Item."Net Change" - ItemQuantity,
                                  (Item."Net Change" - ItemQuantity) * AverageCostAmount);
                    end;

                    trigger OnPreDataItem()
                    begin
                        TotalCostAmount := 0;
                        ItemCostAmount := 0;
                        ItemQuantity := 0;
                        ItemLedgEntryTmp.Reset();

                        "Item Ledger Entry".SetFilter("Item Ledger Entry"."Last Applying Date", '%1|%2..', 0D, CalcDate('<-CM-3M>', BaseDate));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if ZGT.TurkishServer then begin
                        ConvItem.Get(Item."No.");
                        Item."Cost Posted to G/L" := Item."Cost Posted to G/L" + ConvItem."Cost Amount (Actual)";
                    end;

                    if (Item."Net Change" = 0) and (Item."Cost Amount (Actual)" + Item."Cost Amount (Expected)" = 0) and (Item."Cost Posted to G/L" = 0) then
                        CurrReport.Skip();

                    if Item."Net Change" <> 0 then begin
                        AverageCostAmount := (Item."Cost Amount (Actual)" + Item."Cost Amount (Expected)") / Item."Net Change";
                        AverageCostAmountGL := Item."Cost Posted to G/L" / Item."Net Change";
                    end else begin
                        // It happens that the quantity is zero, but there is an amount.
                        CreateItemLedgerEntryTemp(
                          Item."No.",
                          Location.Code,
                          '',
                          Today,
                          Item."Net Change",
                          Item."Cost Amount (Actual)" + Item."Cost Amount (Expected)");
                        CurrReport.Skip();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    ItemAppEntry.SetCurrentkey("Item Ledger Entry No.", "Posting Date");

                    Item.SetRange(Item."Date Filter", 0D, BaseDate);
                    Item.SetRange(Item."Location Filter", Location.Code);
                    if ZGT.TurkishServer then begin
                        ConvItem.SetRange("Date Filter", 0D, 20180930D);
                        ConvItem.SetRange("Location Filter", Location.Code);
                        ConvItem.SetAutoCalcFields("Cost Amount (Actual)");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Location.Code, 0, true);
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', Location.Count());
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BaseDate; BaseDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                    }
                    field(ForecastDate; ForecastDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Forecast Date';
                    }
                    field(TrivialityLimit; TrivialityLimit)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Triviality Limit';
                        MinValue = 0;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            TrivialityLimit := 5000;
        end;
    }

    labels
    {
        text001 = 'ZYRHQ';
        text002 = 'Company Code';
        text003 = 'Item No.';
        text004 = 'CAT I';
        text005 = 'CAT II';
        text006 = 'Descripion';
        text007 = 'Total Quantity';
        text008 = 'Total Amount';
        text009 = '<=60(PCS)';
        text010 = '<=60(Value)';
        text011 = '61-90(PCS)';
        text012 = '61-90(Value)';
        text013 = '91-120(PCS)';
        text014 = '91-120(Value)';
        text015 = '121-150(PCS)';
        text016 = '121-150(Value)';
        text017 = '151-180(PCS)';
        text018 = '151-180(Value)';
        text019 = '181-240(PCS)';
        text020 = '181-240(Value)';
        text021 = '241-360(PCS)';
        text022 = '241-360(Value)';
        text023 = 'over 360(PCS)';
        text024 = 'over 360(Value)';
        text025 = 'Page';
        RptTitle = 'Inventory Report';
        text026 = 'Cost posted to G/L';
    }

    trigger OnInitReport()
    begin
        RMA := false;
        ALLRec := true;
    end;

    trigger OnPostReport()
    begin
        //>> 28-12-17 ZY-LD 007
        if QtyAndValueIsZero then
            Message(Text003);
        //<< 28-12-17 ZY-LD 007

        CreateExcelLines;
        if OutputType in [Outputtype::All, Outputtype::"Pr. Item Line"] then begin
            MakeExcelGrandFootColumn;
            CreateExcelbook;
        end;
    end;

    trigger OnPreReport()
    begin
        AgingCode := '0-180';  // 23-07-18 ZY-LD 001
        PrevYearDate := CalcDate('<-6M-1D>', ForecastDate);
        LastDatePrevYear := CalcDate('<-CY-1D-6M>', ForecastDate);
        if OutputType in [Outputtype::All, Outputtype::"Pr. Column"] then begin
            MakeExcelHeadColumn;
        end;
        recGenLedgSetup.Get();  // 25-01-19 ZY-LD 002
        recInvSetup.Get();  // 23-01-20 ZY-LD 003
        recItemLedgEntry.SetCurrentkey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");  // 23-01-20 ZY-LD 003

        SI.UseOfReport(3, 50099, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        recAgingCode: Record "Aging Code";
        ExcelBuf: Record "Excel Buffer" temporary;
        ItemAppEntry: Record "Item Application Entry";
        recItemLedgEntry: Record "Item Ledger Entry";
        ItemAppEntryTmp: Record "Item Ledger Entry" temporary;
        ItemAppEntryTmp2: Record "Item Ledger Entry" temporary;
        ItemLedgEntryTmp: Record "Item Ledger Entry" temporary;
        ConvItem: Record Item;
        recGenLedgSetup: Record "General Ledger Setup";
        recInvSetup: Record "Inventory Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ShowAppEntries: Codeunit "Show Applied Entries";
        AgingCode: Code[10];
        BaseDate: Date;
        ForecastDate: Date;
        PrevYearDate: Date;
        Col: Integer;
        RMA: Boolean;
        ALLRec: Boolean;
        OutputType: Option All,"Pr. Item Line","Pr. Column";
        ColumnNo: Integer;
        Text003: Label 'Entity_Name';
        RowNoCol: Integer;
        UnappliedQty: Decimal;
        LineCostAmount: Decimal;
        ItemCostAmount: Decimal;
        TotalCostAmount: Decimal;
        LineCostAmountGL: Decimal;
        ItemCostAmountGL: Decimal;
        QtyAndValueIsZero: Boolean;
        Text030: Label 'Grand Total:';
        ItemQuantity: Decimal;
        ShowClosedDetailedEntries: Boolean;
        AverageCostAmount: Decimal;
        AverageCostAmountGL: Decimal;
        EntryNo: Integer;
        PostingDate: Date;
        EntryPosted: Boolean;
        TrivialityLimit: Decimal;
        SI: Codeunit "Single Instance";
        ItemBudgMgt: Codeunit "Item Budget Management Ext.";
        ColumnNoUnitPrice: Integer;
        ColumnNoAgedQty: Integer;
        ColumnNoAgedQtyAfter: Integer;
        ColumnNoAgedValAfter: Integer;
        ColumnNoAgedVal: Integer;
        ColumnNoFcstFirst: Integer;
        ColumnNoFcstLast: Integer;
        ColumnNoSalesIn6Month: Integer;
        ColumnNoSalesInAvg6Month: Integer;
        ColumnNoSalesInAged6Month: Integer;
        ColumnNoSalesInVal6Month: Integer;
        ColumnNoSalesIn3Month: Integer;
        ColumnNoSalesInAvg3Month: Integer;
        ColumnNoSalesInAged3Month: Integer;
        ColumnNoSalesInVal3Month: Integer;
        ColumnNoAgedQtyYear: Integer;
        ColumnNoAgedQtyAfterYear: Integer;
        ColumnNoAgedQtyLastYear: Integer;
        ColumnNoAgedValLastYear: Integer;
        ColumnNoAgedQtyThisYear: Integer;
        ColumnNoAgedValThisYear: Integer;
        ColumnNoLastDatePrevYear: Integer;
        ColumnNoAgedQtyAfterMinPrevYear: Integer;
        LastDatePrevYear: Date;

    local procedure CreateItemLedgerEntryTemp(pItemNo: Code[20]; pLocationCode: Code[10]; pDivisionCode: Code[10]; pPostingDate: Date; pQuantity: Decimal; pLineCostAmount: Decimal)
    var
        repInvTempl: Report "MR Inventory Template";
        AgiCode: Code[10];
    begin
        AgiCode := recAgingCode.GetAgingCode(AgingCode, repInvTempl.CalcDueDate(BaseDate - pPostingDate));

        ItemLedgEntryTmp.SetRange("Item No.", pItemNo);
        ItemLedgEntryTmp.SetRange("Location Code", pLocationCode);
        ItemLedgEntryTmp.SetRange("Variant Code", AgiCode);
        ItemLedgEntryTmp.SetRange("Global Dimension 1 Code", pDivisionCode);  // 25-01-19 ZY-LD 002
        ItemLedgEntryTmp.SetRange("Posting Date", pPostingDate);  // 23-01-20 ZY-LD 003
        if not ItemLedgEntryTmp.FindFirst() then begin
            EntryNo += 1;
            ItemLedgEntryTmp."Entry No." := EntryNo;
            ItemLedgEntryTmp."Item No." := pItemNo;
            ItemLedgEntryTmp."Location Code" := pLocationCode;
            ItemLedgEntryTmp."Global Dimension 1 Code" := pDivisionCode;  // 25-01-19 ZY-LD 002
            ItemLedgEntryTmp."Variant Code" := AgiCode;
            ItemLedgEntryTmp."Posting Date" := pPostingDate;
            ItemLedgEntryTmp.Quantity := pQuantity;
            ItemLedgEntryTmp."Invoiced Quantity" := pLineCostAmount;
            ItemLedgEntryTmp.Insert();
        end else begin
            ItemLedgEntryTmp.Quantity := ItemLedgEntryTmp.Quantity + pQuantity;
            ItemLedgEntryTmp."Invoiced Quantity" := ItemLedgEntryTmp."Invoiced Quantity" + pLineCostAmount;
            ItemLedgEntryTmp.Modify();
        end;
    end;

    local procedure CreateExcelLines()
    var
        recItem: Record Item;
        recItem2: Record Item;
        recFcstTerr: Record "Forecast Territory";
        QuantityTemp: Decimal;
        CostTemp: Decimal;
        lText001: Label 'Creating Excel Lines';
        lText006: Label '=IF(%2%1%3<0,0,%2%1%3)';
        i: Integer;
        DateFormula: DateFormula;
        DateFormulaEnd: DateFormula;
        CountryFilter: Text;
        ForecastSum: Decimal;
        ForecastFormula: Text;
        lText007: Label '=IFERROR(%2%1*%3%1,"")';
        lText008: Label '=IF(%2%1-(%3%1*4)<0,0,%2%1-(%3%1*4))';
        lText009: Label '=%2%1/%3';
        lText010: Label '=IFERROR(AVERAGE(%2%1,%3%1,%4%1),"")';
        lText011: Label '=IF(%2%1-%3%1<=0," ",%2%1-%3%1)';
    begin
        ItemLedgEntryTmp.Reset();
        if not ItemLedgEntryTmp.IsEmpty() then begin
            // Excel Sheet pr. Column
            if OutputType in [Outputtype::All, Outputtype::"Pr. Column"] then begin
                // ALL
                recItem.CopyFilters(Item);
                recItem.SetRange("Location Filter");
                recItem.SetRange("Date Filter");
                recItem.SetAutoCalcFields("Qty. on Sales Order");
                if recItem.FindSet() then begin
                    ZGT.OpenProgressWindow('', recItem.Count());
                    repeat
                        ZGT.UpdateProgressWindow(lText001, 0, true);

                        ItemLedgEntryTmp.Reset();
                        ItemLedgEntryTmp.SetRange("Item No.", recItem."No.");
                        ItemLedgEntryTmp.SetRange("Variant Code", 'Over 181');
                        if not ItemLedgEntryTmp.IsEmpty() then begin
                            if ItemLedgEntryTmp.FindFirst() then begin
                                QuantityTemp := 0;
                                CostTemp := 0;
                                repeat
                                    QuantityTemp += ItemLedgEntryTmp.Quantity;
                                    CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                until ItemLedgEntryTmp.Next() = 0;
                                MakeExcelLineColumn(recItem, 1, QuantityTemp, CostTemp, true);
                            end else
                                MakeExcelLineColumn(recItem, 2, 0, 0, false);

                            for i := Date2dmy(ForecastDate, 2) to Date2dmy(BaseDate, 2) do begin
                                Evaluate(DateFormula, Format(i - Date2dmy(ForecastDate, 2)) + 'M');
                                WorkDate := ForecastDate;
                                recFcstTerr.SetRange("Show on Forecast List", true);
                                if recFcstTerr.FindSet() then begin
                                    ForecastSum := 0;
                                    repeat
                                        ForecastSum += ItemBudgMgt.GetSOForecast('', recFcstTerr.Code, recItem."No.", '', DateFormula, CountryFilter, false, true, true, false);  // 16-02-22 ZY-LD 007
                                    until recFcstTerr.Next() = 0;
                                    if ForecastSum > 0 then
                                        FormatExcelOutputColumn(0, ForecastSum)
                                    else
                                        FormatExcelOutputColumn(0, 0);
                                end;
                                WorkDate := Today;
                            end;

                            ForecastFormula := '';
                            for i := ColumnNoFcstFirst to ColumnNoFcstLast do
                                ForecastFormula += StrSubstNo('-%2%1', RowNoCol, ZGT.GetColumnLetter(i));
                            ExcelBuf.AddColumn(StrSubstNo(lText006, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQty), ForecastFormula), true, '', false, false, false, '##,###,###', ExcelBuf."cell type"::Number);
                            ExcelBuf.AddColumn(StrSubstNo(lText007, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyAfter), ZGT.GetColumnLetter(ColumnNoUnitPrice)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);

                            /*ExcelBuf.AddColumn('|',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                            recItem2.SETRANGE("Date Filter",CALCDATE('-1D-6M',ForecastDate),CALCDATE('-1D',ForecastDate));
                            recItem2.SETAUTOCALCFIELDS("Sales (Qty.)");
                            recItem2.GET(recItem."No.");
                            FormatExcelOutputColumn(0,recItem2."Sales (Qty.)");
                            ExcelBuf.AddColumn(STRSUBSTNO(lText009,RowNoCol,ZGT.GetColumnLetter(ColumnNoSalesIn6Month),6,(DATE2DMY(CALCDATE('<CQ>',ForecastDate),2) - DATE2DMY(ForecastDate,2) + 1)),TRUE,'',FALSE,FALSE,FALSE,'##,###,###',ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(STRSUBSTNO(lText008,RowNoCol,ZGT.GetColumnLetter(ColumnNoAgedQty),ZGT.GetColumnLetter(ColumnNoSalesInAvg6Month)),TRUE,'',FALSE,FALSE,FALSE,'##,###,###',ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(STRSUBSTNO(lText007,RowNoCol,ZGT.GetColumnLetter(ColumnNoSalesInAged6Month),ZGT.GetColumnLetter(ColumnNoUnitPrice)),TRUE,'',FALSE,FALSE,FALSE,'##,###,##0.00',ExcelBuf."Cell Type"::Number);

                            ExcelBuf.AddColumn('|',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                            recItem2.SETRANGE("Date Filter",CALCDATE('-1D-3M',ForecastDate),CALCDATE('-1D',ForecastDate));
                            recItem2.SETAUTOCALCFIELDS("Sales (Qty.)");
                            recItem2.GET(recItem."No.");
                            FormatExcelOutputColumn(0,recItem2."Sales (Qty.)");
                            ExcelBuf.AddColumn(STRSUBSTNO(lText009,RowNoCol,ZGT.GetColumnLetter(ColumnNoSalesIn3Month),3,(DATE2DMY(CALCDATE('<CQ>',ForecastDate),2) - DATE2DMY(ForecastDate,2) + 1)),TRUE,'',FALSE,FALSE,FALSE,'##,###,###',ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(STRSUBSTNO(lText008,RowNoCol,ZGT.GetColumnLetter(ColumnNoAgedQty),ZGT.GetColumnLetter(ColumnNoSalesInAvg3Month)),TRUE,'',FALSE,FALSE,FALSE,'##,###,###',ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(STRSUBSTNO(lText007,RowNoCol,ZGT.GetColumnLetter(ColumnNoSalesInAged3Month),ZGT.GetColumnLetter(ColumnNoUnitPrice)),TRUE,'',FALSE,FALSE,FALSE,'##,###,##0.00',ExcelBuf."Cell Type"::Number);

                            ExcelBuf.AddColumn('|',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(
                              STRSUBSTNO(lText010,RowNoCol,ZGT.GetColumnLetter(ColumnNoAgedQtyAfter),ZGT.GetColumnLetter(ColumnNoSalesInAvg6Month),ZGT.GetColumnLetter(ColumnNoSalesInAvg3Month)),
                              TRUE,'',FALSE,FALSE,FALSE,'##,###,###',ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(
                              STRSUBSTNO(lText010,RowNoCol,ZGT.GetColumnLetter(ColumnNoAgedValAfter),ZGT.GetColumnLetter(ColumnNoSalesInVal6Month),ZGT.GetColumnLetter(ColumnNoSalesInVal3Month)),
                              TRUE,'',FALSE,FALSE,FALSE,'##,###,##0.00',ExcelBuf."Cell Type"::Number);*/

                            // 01-06-22 ZY-LD 008
                            // Previous Year
                            ExcelBuf.AddColumn('|', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                            ItemLedgEntryTmp.SetFilter("Posting Date", '..%1', PrevYearDate);
                            if ItemLedgEntryTmp.FindFirst() then begin
                                QuantityTemp := 0;
                                CostTemp := 0;
                                repeat
                                    QuantityTemp += ItemLedgEntryTmp.Quantity;
                                    CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                until ItemLedgEntryTmp.Next() = 0;
                                FormatExcelOutputColumn(0, QuantityTemp);
                            end else
                                FormatExcelOutputColumn(0, 0);
                            ExcelBuf.AddColumn(StrSubstNo(lText007, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyLastYear), ZGT.GetColumnLetter(ColumnNoUnitPrice)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);


                            ExcelBuf.AddColumn('|', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                            for i := Date2dmy(ForecastDate, 2) to Date2dmy(BaseDate, 2) do begin
                                Evaluate(DateFormula, Format(i - Date2dmy(ForecastDate, 2)) + 'M-6M');
                                Evaluate(DateFormulaEnd, Format(i - Date2dmy(ForecastDate, 2)) + 'M-6M+CM');
                                WorkDate := ForecastDate;
                                ItemLedgEntryTmp.SetRange("Posting Date", CalcDate(DateFormula, ForecastDate), CalcDate(DateFormulaEnd, ForecastDate));
                                if ItemLedgEntryTmp.FindFirst() then begin
                                    QuantityTemp := 0;
                                    CostTemp := 0;
                                    repeat
                                        QuantityTemp += ItemLedgEntryTmp.Quantity;
                                        CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                    until ItemLedgEntryTmp.Next() = 0;
                                    FormatExcelOutputColumn(0, QuantityTemp);
                                end else
                                    FormatExcelOutputColumn(0, 0);
                                WorkDate := Today;
                            end;

                            // This Year
                            ItemLedgEntryTmp.SetFilter("Posting Date", '>%1', PrevYearDate);
                            if ItemLedgEntryTmp.FindFirst() then begin
                                QuantityTemp := 0;
                                CostTemp := 0;
                                repeat
                                    QuantityTemp += ItemLedgEntryTmp.Quantity;
                                    CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                until ItemLedgEntryTmp.Next() = 0;
                                FormatExcelOutputColumn(0, QuantityTemp);
                            end else
                                FormatExcelOutputColumn(0, 0);
                            ExcelBuf.AddColumn(StrSubstNo(lText007, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyThisYear), ZGT.GetColumnLetter(ColumnNoUnitPrice)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
                            //<< 01-06-22 ZY-LD 008

                            // Previous Year
                            ExcelBuf.AddColumn('|', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                            ItemLedgEntryTmp.SetFilter("Posting Date", '..%1', LastDatePrevYear);
                            if ItemLedgEntryTmp.FindFirst() then begin
                                QuantityTemp := 0;
                                CostTemp := 0;
                                repeat
                                    QuantityTemp += ItemLedgEntryTmp.Quantity;
                                    CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                until ItemLedgEntryTmp.Next() = 0;
                                FormatExcelOutputColumn(0, QuantityTemp);
                            end else
                                FormatExcelOutputColumn(0, 0);
                            ExcelBuf.AddColumn(StrSubstNo(lText011, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyAfter), ZGT.GetColumnLetter(ColumnNoLastDatePrevYear)), true, '', false, false, false, '##,###,###', ExcelBuf."cell type"::Number);
                            ExcelBuf.AddColumn(StrSubstNo(lText007, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyAfterMinPrevYear), ZGT.GetColumnLetter(ColumnNoUnitPrice)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);

                        end;
                    until recItem.Next() = 0;

                    ZGT.CloseProgressWindow;
                end;
            end;
        end;

    end;

    local procedure CreateExcelbook()
    var
        lText001: Label 'Aged Stock %1';
    begin
        ExcelBuf.CreateBook('', StrSubstNo(lText001, AgingCode));
        ExcelBuf.WriteSheet(StrSubstNo(lText001, AgingCode), CompanyName(), UserId());

        ExcelBuf.CloseBook;
        if GuiAllowed() then begin
            ExcelBuf.OpenExcel;
        end;
    end;

    local procedure MakeExcelHeadColumn()
    var
        i: Integer;
        lText001: Label 'Date Filter: ..%1';
        lText002: Label 'Run time: %1';
        lText003: Label 'User Id: %1';
        lText004: Label 'Triviality Limit: %1';
        VariantVar: Variant;
    begin
        ExcelBuf.AddColumn(StrSubstNo(lText001, BaseDate), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(StrSubstNo(lText002, CurrentDatetime), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(StrSubstNo(lText003, UserId()), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(StrSubstNo(lText004, TrivialityLimit), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;

        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Item_No', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Description', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Unit Price', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoUnitPrice := VariantVar;
        ExcelBuf.AddColumn('Product Category', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Product Group', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        //ExcelBuf.AddColumn('Forecast Territory',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country Code', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('SP/CH Code', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('Aged QTY %1', BaseDate), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQty := VariantVar;
        ExcelBuf.AddColumn(StrSubstNo('Aged VAL %1 (EUR)', BaseDate), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedVal := VariantVar;
        ExcelBuf.AddColumn('Triviality Limit', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoFcstFirst := VariantVar;
        ColumnNoFcstFirst += 1;
        for i := Date2dmy(ForecastDate, 2) to Date2dmy(BaseDate, 2) do
            ExcelBuf.AddColumn(StrSubstNo('%1 F/cst', ZGT.GetMonthText(i, false, false, true)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoFcstLast := VariantVar;

        ExcelBuf.AddColumn('Aged QTY After Forecast', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQtyAfter := VariantVar;
        ExcelBuf.AddColumn('Aged VAL After Forecast', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedValAfter := VariantVar;

        /*ExcelBuf.AddColumn('|',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales In Last 6 Months',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesIn6Month := VariantVar;
        ExcelBuf.AddColumn('Average Sales In 6 Months',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesInAvg6Month := VariantVar;
        ExcelBuf.AddColumn('Aged Qty after Av Sales In',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesInAged6Month := VariantVar;
        ExcelBuf.AddColumn('Aged Val after Av Sales In',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesInVal6Month := VariantVar;
        
        ExcelBuf.AddColumn('|',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales In Last 3 Months',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesIn3Month := VariantVar;
        ExcelBuf.AddColumn('Average Sales In 3 Months',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesInAvg3Month := VariantVar;
        ExcelBuf.AddColumn('Aged Qty after Av Sales In',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesInAged3Month := VariantVar;
        ExcelBuf.AddColumn('Aged Val after Av Sales In',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol',VariantVar);
        ColumnNoSalesInVal3Month := VariantVar;
        
        ExcelBuf.AddColumn('|',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Average Quantity',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Average Value',FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);*/

        //>> 01-06-22 ZY-LD 008
        ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('Aged ..%1', CalcDate('<6M+CM>', PrevYearDate)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQtyLastYear := VariantVar;
        ExcelBuf.AddColumn(StrSubstNo('Aged VAL ..%1', CalcDate('<6M+CM>', PrevYearDate)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        for i := Date2dmy(ForecastDate, 2) to Date2dmy(BaseDate, 2) do
            ExcelBuf.AddColumn(StrSubstNo('%1 Aged', ZGT.GetMonthText(i, false, false, true)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('Aged %1..', CalcDate('<6M>', PrevYearDate + 1)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQtyThisYear := VariantVar;
        ExcelBuf.AddColumn(StrSubstNo('Aged VAL %1..', CalcDate('<6M>', PrevYearDate + 1)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        //<< 01-06-22 ZY-LD 008

        ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('Aged ..%1', Date2dmy(LastDatePrevYear, 3)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoLastDatePrevYear := VariantVar;
        ExcelBuf.AddColumn('Aged QTY After Forecast Minus Prev. Year Aged Stock', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQtyAfterMinPrevYear := VariantVar;
        ExcelBuf.AddColumn('Aged VAL After Forecast Minus Prev. Year Aged Stock', false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        RowNoCol := 6;

    end;

    local procedure MakeExcelLineColumn(var pItem: Record Item; pType: Integer; pQuantity: Decimal; pAmount: Decimal; pNewRow: Boolean)
    var
        lText001: Label '=IF(%2%1/%3%1=0,"",%2%1/%3%1)';
        CountryFilter: Code[1024];
    begin
        if pNewRow then begin
            ExcelBuf.NewRow;
            RowNoCol += 1;
        end;

        case pType of
            1:
                begin
                    pItem.CalcFields("Actual FOB Price", "Qty. on Sales Order");
                    ExcelBuf.AddColumn(pItem."No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(pItem.Description, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(StrSubstNo(lText001, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedVal), ZGT.GetColumnLetter(ColumnNoAgedQty)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(pItem."Category 1 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(pItem."Category 2 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    CountryFilter := GetCountryCode(pItem);
                    //ExcelBuf.AddColumn(GetForecastTerritory(pItem,CountryFilter),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CountryFilter, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    FormatExcelOutputColumn(0, pQuantity);
                    FormatExcelOutputColumn(1, pAmount);
                    // Totals
                    if pAmount < TrivialityLimit then
                        ExcelBuf.AddColumn(StrSubstNo('< %1', TrivialityLimit), false, '', false, false, false, '', ExcelBuf."cell type"::Text)
                    else
                        ExcelBuf.AddColumn(StrSubstNo('>= %1', TrivialityLimit), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
                end;
            2:
                begin
                    FormatExcelOutputColumn(0, pQuantity);
                    FormatExcelOutputColumn(1, pAmount);
                end;
            3:
                begin
                    // Blank
                    ExcelBuf.AddColumn('|', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                end;
        end;
    end;

    local procedure MakeExcelGrandFootColumn()
    var
        lText001: Label '=SUM(%1%2:%1%3)';
        i: Integer;
    begin
        exit;

        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Text030, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        for i := 1 to 8 do
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo := 9;
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo += 1;
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
    end;

    local procedure FormatExcelOutputColumn(pType: Option Quantity,Amount; pAmount: Decimal)
    begin
        Col := 255;
        if pAmount <> 0 then begin
            case pType of
                Ptype::Quantity:
                    ExcelBuf.AddColumn(pAmount, false, '', false, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
                Ptype::Amount:
                    ExcelBuf.AddColumn(pAmount, false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            end;
        end else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
    end;

    local procedure GetForecastTerritory(var pItem: Record Item; pCountryFilter: Code[100]) rValue: Text
    var
        recForecastTerrCtry: Record "Forecast Territory Country";
        i: Integer;
    begin
        if pItem."Forecast Territory" <> '' then
            rValue := pItem."Forecast Territory"
        else begin
            // Find the forecast based on the country code on the item.
            for i := StrLen(pItem."No.") downto 1 do
                if pItem."No."[i] = '|' then begin
                    recForecastTerrCtry.SetFilter("Territory Code", CopyStr(pItem."No.", i + 1, 2));
                    if ZGT.IsZComCompany then
                        recForecastTerrCtry.SetRange("Division Code", 'SP')
                    else
                        recForecastTerrCtry.SetRange("Division Code", 'CH');
                    if recForecastTerrCtry.FindSet() then
                        repeat
                            if StrPos(rValue, recForecastTerrCtry."Forecast Territory Code") = 0 then
                                rValue += StrSubstNo('%1|', recForecastTerrCtry."Forecast Territory Code");
                        until recForecastTerrCtry.Next() = 0;
                    rValue := DelChr(rValue, '>', '|');

                    i := 0;
                end;

            if rValue = '' then begin
                if pCountryFilter <> '' then begin
                    recForecastTerrCtry.SetFilter("Territory Code", pCountryFilter);
                    if ZGT.IsZComCompany then
                        recForecastTerrCtry.SetRange("Division Code", 'SP')
                    else
                        recForecastTerrCtry.SetRange("Division Code", 'CH');
                    if recForecastTerrCtry.FindSet() then
                        repeat
                            if StrPos(rValue, recForecastTerrCtry."Forecast Territory Code") = 0 then
                                rValue += StrSubstNo('%1|', recForecastTerrCtry."Forecast Territory Code");
                        until recForecastTerrCtry.Next() = 0;
                    rValue := DelChr(rValue, '>', '|');
                end;
            end;
        end;
    end;

    local procedure GetCountryCode(var pItem: Record Item) rValue: Code[100]
    var
        recItemBudgEntry: Record "Item Budget Entry";
        ItemBudgetMgt: Codeunit "Item Budget Management Ext.";
    begin
        if pItem."Aged Country Code" <> '' then
            rValue := pItem."Aged Country Code"
        else begin
            recItemBudgEntry.SetRange("Budget Name", ItemBudgetMgt.GetMasterForecastName);
            recItemBudgEntry.SetRange("Item No.", pItem."No.");
            recItemBudgEntry.SetFilter(Date, '%1..', CalcDate('<-1Y>', Today), Today);
            if recItemBudgEntry.FindSet() then
                repeat
                    if StrPos(rValue, recItemBudgEntry."Budget Dimension 1 Code") = 0 then
                        rValue += StrSubstNo('%1|', recItemBudgEntry."Budget Dimension 1 Code");
                until recItemBudgEntry.Next() = 0;
            rValue := DelChr(rValue, '>', '|');
        end;
    end;
}
