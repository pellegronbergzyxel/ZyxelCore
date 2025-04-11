Report 50099 "Aged Stock Report"
{
    // 001. 18-06-18 ZY-LD 2018061510000034 - Create list on a previous date.
    // 002. 25-01-19 ZY-LD 2019012310000071 - Adjustments for reporting 2019.
    // 003. 23-01-20 ZY-LD 000 - Audit found errors in the aging when we transfered from one location to another. That is now fixed.
    // 004. 11-02-20 ZY-LD 000 - Create Inventory Movements is running in a job queue, and is updating every day.
    // 005. 07-04-20 ZY-LD 2020040710000076 - When a transfer comes from a journal it doesn´t have an Order No. We use Document No. instead when it comes from the journal.
    // 006. 15-04-20 ZY-LD 2020041410000035 - Jamie wants the inventory movements pr. aging code.
    // 007. 07-01-21 ZY-LD 2022010710000069 - It made a wrong calculation with the entry from the applied entry.
    // 008. 24-06-22 ZY-LD 2022041110000108 - It was possible to set the aging to a newer date than the posted one.
    // 009. 03-10-22 ZY-LD 2022092210000034 - Show Without backorder.
    // 010. 03-05-24 ZY-LD #4321521 - Aged Stock Report did not match the numbers in MR Inventory Report - Detail, so posting date is changed back.

    Caption = 'Aged Stock Report';
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
                        //LineCostAmount := AverageCostAmount * UnappliedQty;  // 23-01-20 ZY-LD 003
                        //LineCostAmountGL := AverageCostAmountGL * UnappliedQty;  // 23-01-20 ZY-LD 003

                        if (UnappliedQty <> 0) or (ROUND(AverageCostAmount * UnappliedQty) <> 0) or (ROUND(AverageCostAmountGL * UnappliedQty) <> 0) or ShowClosedDetailedEntries then begin
                            //ItemCostAmount += LineCostAmount;  // 23-01-20 ZY-LD 003
                            //ItemCostAmountGL += LineCostAmountGL;  // 23-01-20 ZY-LD 003
                            ItemQuantity += UnappliedQty;
                            PostingDate := "Item Ledger Entry"."Posting Date";
                            EntryPosted := false;

                            //>> 23-01-20 ZY-LD 003
                            if ("Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."entry type"::Transfer) and ("Item Ledger Entry"."Order No." <> '') or ("Item Ledger Entry"."Document No." <> '') then begin
                                if "Item Ledger Entry"."Order No." <> '' then begin  // 07-04-20 ZY-LD 005
                                    if "Item Ledger Entry"."Order No." <> recItemLedgEntry."Order No." then
                                        ItemAppEntryTmp2.DeleteAll;
                                end else //>> 07-04-20 ZY-LD 005
                                    if "Item Ledger Entry"."Document No." <> recItemLedgEntry."Document No." then
                                        ItemAppEntryTmp2.DeleteAll;
                                //<< 07-04-20 ZY-LD 005

                                recItemLedgEntry.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                                recItemLedgEntry.SetRange("Entry Type", "Item Ledger Entry"."Entry Type");
                                if "Item Ledger Entry"."Order No." <> '' then  // 07-04-20 ZY-LD 005
                                    recItemLedgEntry.SetRange("Order No.", "Item Ledger Entry"."Order No.")
                                else  // 07-04-20 ZY-LD 005
                                    recItemLedgEntry.SetRange("Document No.", "Item Ledger Entry"."Document No.");  // 07-04-20 ZY-LD 005
                                recItemLedgEntry.SetRange("Location Code", recInvSetup."AIT Location Code");
                                if recItemLedgEntry.FindFirst then begin
                                    ItemAppEntryTmp.Reset;  // 24-06-22 ZY-LD 008
                                    ItemAppEntryTmp.DeleteAll;
                                    ShowAppEntries.FindAppliedEntries(recItemLedgEntry, ItemAppEntryTmp);
                                    TransferUnappQty := UnappliedQty;

                                    ItemAppEntryTmp.SetCurrentkey("Item No.", "Posting Date");
                                    ItemAppEntryTmp.SetFilter("Posting Date", '<%1', PostingDate);  // 24-06-22 ZY-LD 008
                                    ItemAppEntryTmp.Ascending(false);
                                    if ItemAppEntryTmp.FindSet then
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
                                                      LineCostAmount,
                                                      "Item Ledger Entry"."Entry Type");  // 11-02-20 ZY-LD 004
                                                    ItemCostAmount += LineCostAmount;
                                                    ItemCostAmountGL += LineCostAmountGL;

                                                    if ItemAppEntryTmp2."Entry No." <> 0 then begin
                                                        ItemAppEntryTmp2.Quantity += UnappQtyToCreate;
                                                        ItemAppEntryTmp2.Modify;
                                                    end else begin
                                                        ItemAppEntryTmp2."Entry No." := ItemAppEntryTmp."Entry No.";
                                                        ItemAppEntryTmp2.Quantity := UnappQtyToCreate;
                                                        ItemAppEntryTmp2.Insert;
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
                                  PostingDate, //"Item Ledger Entry"."Posting Date",  // 07-01-21 ZY-LD 007 - Previous "PostingDate"  // 03-05-24 ZY-LD 010 - Changed back to "PostingDate".
                                  UnappliedQty,
                                  LineCostAmount,
                                  "Item Ledger Entry"."Entry Type");  // 11-02-20 ZY-LD 004
                                ItemCostAmount += LineCostAmount;  // 23-01-20 ZY-LD 003
                                ItemCostAmountGL += LineCostAmountGL;  // 23-01-20 ZY-LD 003
                            end;
                        end;
                    end;

                    trigger OnPostDataItem()
                    var
                        QuantityTemp: Decimal;
                        CostTemp: Decimal;
                        recILE: Record "Item Ledger Entry";
                    begin
                        if (ItemQuantity <> 0) or (ROUND(ItemCostAmount) <> 0) or (ROUND(ItemCostAmountGL) <> 0) then
                            if ItemQuantity <> Item."Net Change" then
                                CreateItemLedgerEntryTemp(
                                  Item."No.",
                                  Location.Code,
                                  "Item Ledger Entry"."Global Dimension 1 Code",  // 25-01-19 ZY-LD 002
                                  "Item Ledger Entry"."Posting Date",
                                  Item."Net Change" - ItemQuantity,
                                  (Item."Net Change" - ItemQuantity) * AverageCostAmount,
                                  "Item Ledger Entry"."Entry Type");
                    end;

                    trigger OnPreDataItem()
                    begin
                        TotalCostAmount := 0;
                        ItemCostAmount := 0;
                        ItemQuantity := 0;
                        ItemLedgEntryTmp.Reset;

                        "Item Ledger Entry".SetFilter("Item Ledger Entry"."Last Applying Date", '%1|%2..', 0D, CalcDate('<-CM-3M>', BaseDate));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if QtyLocation = 1 then
                        ZGT.UpdateProgressWindow(Item."No.", 0, true);

                    if ZGT.TurkishServer then begin
                        ConvItem.Get(Item."No.");
                        Item."Cost Posted to G/L" := Item."Cost Posted to G/L" + ConvItem."Cost Amount (Actual)";
                    end;

                    if (Item."Net Change" = 0) and (Item."Cost Amount (Actual)" + Item."Cost Amount (Expected)" = 0) and (Item."Cost Posted to G/L" = 0) then
                        CurrReport.Skip;

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
                          Item."Cost Amount (Actual)" + Item."Cost Amount (Expected)",
                          "Item Ledger Entry Type"::Value99);  // 11-02-20 ZY-LD 004
                        CurrReport.Skip;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if QtyLocation > 1 then
                        ZGT.CloseProgressWindow;
                end;

                trigger OnPreDataItem()
                begin
                    ItemAppEntry.SetCurrentkey("Item Ledger Entry No.", "Posting Date");

                    Item.SetRange(Item."Date Filter", 0D, BaseDate);
                    Item.SetRange(Item."Location Filter", Location.Code);
                    if ZGT.TurkishServer then begin
                        ConvItem.SetRange("Date Filter", 0D, 20180930D);
                        ConvItem.SetRange("Location Filter", Location.Code);
                        ConvItem.SetAutocalcFields("Cost Amount (Actual)");
                    end;
                    // IF NOT ALLRec THEN
                    //  CASE LocationType OF
                    //    LocationType::RMA : SETFILTER("Location Filter",'RMA*');
                    //    LocationType::"<>RMA" : SETFILTER("Location Filter",'<>RMA*');
                    //    LocationType::"Location Filter" :
                    //      BEGIN
                    //        IF GETFILTER("Location Filter") = '' THEN
                    //          ERROR(Text026,FieldCaption("Location Filter"));
                    //      END;
                    //  END;

                    if QtyLocation = 1 then
                        ZGT.OpenProgressWindow('', Item.Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if QtyLocation > 1 then
                    ZGT.UpdateProgressWindow(Location.Code, 0, true);
            end;

            trigger OnPostDataItem()
            begin
                if QtyLocation > 1 then
                    ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                QtyLocation := Location.Count;
                if QtyLocation > 1 then
                    ZGT.OpenProgressWindow('', Location.Count);
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
                    field(TrivialityLimit; TrivialityLimit)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Triviality Limit';
                        MinValue = 0;
                    }
                    field(ShowWithBackorder; ShowWithBackorder)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show with Backorder';
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
        //PrevYearDate := CALCDATE('<-CY-1D>',BaseDate);
        PrevYearDate := CalcDate('<-CY-1D-6M>', BaseDate);
        if OutputType in [Outputtype::All, Outputtype::"Pr. Column"] then begin
            MakeExcelHeadColumn;
        end;
        recGenLedgSetup.Get;  // 25-01-19 ZY-LD 002
        recInvSetup.Get;  // 23-01-20 ZY-LD 003
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
        RMAItem: Record Item;
        ConvItem: Record Item;
        recGenLedgSetup: Record "General Ledger Setup";
        recInvSetup: Record "Inventory Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ShowAppEntries: Codeunit "Show Applied Entries";
        AgingCode: Code[10];
        BaseDate: Date;
        PrevYearDate: Date;
        Col: Integer;
        RMA: Boolean;
        ALLRec: Boolean;
        LocationType: Option " ",RMA,"<>RMA","Location Filter";
        OutputType: Option All,"Pr. Item Line","Pr. Column";
        ShowDifference: Boolean;
        ColumnNo: Integer;
        RowNo: Integer;
        Text001: label 'Year';
        Text002: label 'Month';
        Text003: label 'Entity_Name';
        Text004: label 'HQ Account No.';
        Text005: label 'HQ Account Name';
        Text006: label 'Warehouse';
        Text007: label 'Cargo';
        Text008: label 'Currency';
        Text009: label 'Sub part no.';
        Text010: label 'HQ part no.';
        Text011: label 'Product Line (Cat2)';
        Text012: label 'Product Group (Cat1)';
        Text013: label 'Description';
        Text014: label 'Total Qty.';
        Text015: label 'Total Amount';
        Text016: label 'Book Date';
        Text017: label 'Aging days';
        Text018: label 'Aging Code';
        Text019: label 'Allowance';
        Text020: label 'Reason for "No"';
        Text021: label 'Allowance of NRV(under 180Days)';
        Text022: label 'Allowance of Provision (Over181Days100%)';
        Text023: label 'Total Amount of provision';
        Text19072657: label 'End Date:';
        Text024: label 'Date: %1';
        Text025: label 'Inactive';
        RowNoCol: Integer;
        RowNoRMA: Integer;
        UnappliedQty: Decimal;
        LineCostAmount: Decimal;
        ItemCostAmount: Decimal;
        TotalCostAmount: Decimal;
        LineCostAmountGL: Decimal;
        ItemCostAmountGL: Decimal;
        TotalCostAmountGL: Decimal;
        LineAgingCode: Code[10];
        Text026: label '"%1" must be filled.';
        Text027: label 'Only RMA';
        Text028: label 'Wiithout RMA';
        Text029: label 'All including RMA';
        QtyAndValueIsZero: Boolean;
        ItemQuantity: Decimal;
        Text031: label 'Posted to G/L';
        ShowClosedDetailedEntries: Boolean;
        Text032: label 'Difference';
        ExpectedAppliedCostAmount: Decimal;
        TotalAppliedCostAmount: Decimal;
        "G/LAppliedCostAmount": Decimal;
        AppliedQuantity: Decimal;
        AverageCostAmount: Decimal;
        AverageCostAmountGL: Decimal;
        EntryNo: Integer;
        Text033: label 'ZYRHQ';
        Text034: label 'Sub Account No.';
        Text035: label 'Sub Account Name';
        Text036: label 'Business Model';
        PostingDate: Date;
        EntryPosted: Boolean;
        TrivialityLimit: Decimal;
        SI: Codeunit "Single Instance";
        ColumnNoUnitPrice: Integer;
        ColumnNoAgedQty: Integer;
        ColumnNoAgedVal: Integer;
        ColumnNoAgedQtyBackOrder: Integer;
        ColumnNoAgedQtyRMA: Integer;
        ColumnNoAgedQtyAfterRMA: Integer;
        ColumnNoAgedQtyYear: Integer;
        ColumnNoAgedQtyAfterYear: Integer;
        QtyLocation: Integer;
        ShowWithBackorder: Boolean;

    local procedure CreateItemLedgerEntryTemp(pItemNo: Code[20]; pLocationCode: Code[10]; pDivisionCode: Code[10]; pPostingDate: Date; pQuantity: Decimal; pLineCostAmount: Decimal; pEntryType: Enum "Item Ledger Entry Type")
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
        if not ItemLedgEntryTmp.FindFirst then begin
            EntryNo += 1;
            ItemLedgEntryTmp."Entry No." := EntryNo;
            ItemLedgEntryTmp."Item No." := pItemNo;
            ItemLedgEntryTmp."Location Code" := pLocationCode;
            ItemLedgEntryTmp."Global Dimension 1 Code" := pDivisionCode;  // 25-01-19 ZY-LD 002
            ItemLedgEntryTmp."Variant Code" := AgiCode;
            ItemLedgEntryTmp."Posting Date" := pPostingDate;
            ItemLedgEntryTmp.Quantity := pQuantity;
            ItemLedgEntryTmp."Invoiced Quantity" := pLineCostAmount;
            ItemLedgEntryTmp.Insert;
        end else begin
            ItemLedgEntryTmp.Quantity := ItemLedgEntryTmp.Quantity + pQuantity;
            ItemLedgEntryTmp."Invoiced Quantity" := ItemLedgEntryTmp."Invoiced Quantity" + pLineCostAmount;
            ItemLedgEntryTmp.Modify;
        end;
    end;

    local procedure CreateExcelLines()
    var
        recItem: Record Item;
        QuantityTemp: Decimal;
        CostTemp: Decimal;
        lText001: label 'Creating Excel Lines';
        lText002: label 'IF(%2%1-%3%1-%4%1<0,0,%2%1-%3%1-%4%1)';
        lText003: label '=IF(IFERROR(%2%1*%3%1,0)=0,"",IFERROR(%2%1*%3%1,0))';
        lText004: label 'IF(%2%1-%3%1<0,0,%2%1-%3%1)';
    begin
        ItemLedgEntryTmp.Reset;
        if not ItemLedgEntryTmp.IsEmpty then begin
            // Excel Sheet pr. Column
            if OutputType in [Outputtype::All, Outputtype::"Pr. Column"] then begin
                // ALL
                recItem.CopyFilters(Item);
                recItem.SetRange("Location Filter");
                recItem.SetRange("Date Filter");
                recItem.SetAutocalcFields("Qty. on Sales Order");
                if recItem.FindSet then begin
                    ZGT.OpenProgressWindow('', recItem.Count);
                    repeat
                        ZGT.UpdateProgressWindow(lText001, 0, true);

                        ItemLedgEntryTmp.Reset;
                        ItemLedgEntryTmp.SetRange("Item No.", recItem."No.");
                        ItemLedgEntryTmp.SetRange("Variant Code", 'Over 181');
                        if not ItemLedgEntryTmp.IsEmpty then begin
                            if ItemLedgEntryTmp.FindFirst then begin
                                QuantityTemp := 0;
                                CostTemp := 0;
                                repeat
                                    QuantityTemp += ItemLedgEntryTmp.Quantity;
                                    CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                until ItemLedgEntryTmp.Next() = 0;
                                MakeExcelLineColumn(recItem, 1, QuantityTemp, CostTemp, true);
                            end else
                                MakeExcelLineColumn(recItem, 2, 0, 0, false);

                            //MakeExcelLineColumn(recItem,3,0,0,FALSE);
                            if ShowWithBackorder then begin  // 03-10-22 ZY-LD 009
                                FormatExcelOutputColumn(0, recItem."Qty. on Sales Order");

                                // RMA Over 181
                                ItemLedgEntryTmp.SetFilter("Location Code", '%1', 'RMA*');
                                if ItemLedgEntryTmp.FindFirst then begin
                                    QuantityTemp := 0;
                                    CostTemp := 0;
                                    repeat
                                        QuantityTemp += ItemLedgEntryTmp.Quantity;
                                        CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                    until ItemLedgEntryTmp.Next() = 0;
                                    //MakeExcelLineColumn(recItem,2,QuantityTemp,CostTemp,FALSE);
                                    FormatExcelOutputColumn(0, QuantityTemp);
                                end else
                                    FormatExcelOutputColumn(0, 0);
                                //MakeExcelLineColumn(recItem,2,0,0,FALSE);
                                ItemLedgEntryTmp.SetRange("Location Code");

                                ExcelBuf.AddColumn(
                                  StrSubstNo(
                                    lText002,
                                    RowNoCol,
                                    ZGT.GetColumnLetter(ColumnNoAgedQty),
                                    ZGT.GetColumnLetter(ColumnNoAgedQtyBackOrder),
                                    ZGT.GetColumnLetter(ColumnNoAgedQtyRMA)),
                                    true, '', false, false, false, '##,###,###', ExcelBuf."cell type"::Number);
                                ExcelBuf.AddColumn(StrSubstNo(lText003, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyAfterRMA), ZGT.GetColumnLetter(ColumnNoUnitPrice)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
                                ExcelBuf.AddColumn('|', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                            end;

                            // Previous Year
                            ItemLedgEntryTmp.SetFilter("Posting Date", '..%1', PrevYearDate);
                            if ItemLedgEntryTmp.FindFirst then begin
                                QuantityTemp := 0;
                                CostTemp := 0;
                                repeat
                                    QuantityTemp += ItemLedgEntryTmp.Quantity;
                                    CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                until ItemLedgEntryTmp.Next() = 0;
                                FormatExcelOutputColumn(0, QuantityTemp);
                            end else
                                FormatExcelOutputColumn(0, 0);

                            if ShowWithBackorder then  // 03-10-22 ZY-LD 009
                                ExcelBuf.AddColumn(StrSubstNo(lText004, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyAfterRMA), ZGT.GetColumnLetter(ColumnNoAgedQtyYear)), true, '', false, false, false, '##,###,###', ExcelBuf."cell type"::Number)
                            else
                                ExcelBuf.AddColumn(StrSubstNo(lText004, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQty), ZGT.GetColumnLetter(ColumnNoAgedQtyYear)), true, '', false, false, false, '##,###,###', ExcelBuf."cell type"::Number);  // 03-10-22 ZY-LD 009
                            ExcelBuf.AddColumn(StrSubstNo(lText003, RowNoCol, ZGT.GetColumnLetter(ColumnNoAgedQtyAfterYear), ZGT.GetColumnLetter(ColumnNoUnitPrice)), true, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
                        end;
                    until recItem.Next() = 0;

                    ZGT.CloseProgressWindow;
                end;
            end;
        end;
    end;


    procedure CreateExcelbook()
    var
        lText001: label 'Aged Stock %1';
        lText002: label 'Column %1';
        lText003: label 'RMA %1';
    begin
        ExcelBuf.CreateBook('', StrSubstNo(lText001, AgingCode));
        ExcelBuf.WriteSheet(StrSubstNo(lText001, AgingCode), CompanyName(), UserId());

        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
        end;
    end;


    procedure MakeExcelHeadColumn()
    var
        i: Integer;
        lText001: label 'Date Filter: ..%1';
        lText002: label 'Run time: %1';
        lText003: label 'User Id: %1';
        lText004: label 'Triviality Limit: %1';
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
        ExcelBuf.AddColumn('Forecast Territory', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Country Code', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Aged QTY', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQty := VariantVar;
        ExcelBuf.AddColumn('Aged Value (EUR)', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedVal := VariantVar;
        ExcelBuf.AddColumn('Triviality Limit', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        // RMA
        if ShowWithBackorder then begin  // 03-10-22 ZY-LD 009
            ExcelBuf.AddColumn('Back Order', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
            ColumnNoAgedQtyBackOrder := VariantVar;
            ExcelBuf.AddColumn('Aged RMA', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
            ColumnNoAgedQtyRMA := VariantVar;
            ExcelBuf.AddColumn('Aged Qty AFTER Sales backorders/RMA Aged', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
            ColumnNoAgedQtyAfterRMA := VariantVar;
            ExcelBuf.AddColumn('Aged Val AFTER Sales backorders/RMA Aged (EUR)', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('|', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        end;

        ExcelBuf.AddColumn(StrSubstNo('Aged ..%1', Date2dmy(PrevYearDate, 3)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQtyYear := VariantVar;
        ExcelBuf.AddColumn(StrSubstNo('Aged Qty %1', Date2dmy(BaseDate, 3)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.UTgetGlobalValue('CurrentCol', VariantVar);
        ColumnNoAgedQtyAfterYear := VariantVar;
        ExcelBuf.AddColumn(StrSubstNo('Aged Val %1 (EUR)', Date2dmy(BaseDate, 3)), false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        RowNoCol := 6;
    end;


    procedure MakeExcelLineColumn(var pItem: Record Item; pType: Integer; pQuantity: Decimal; pAmount: Decimal; pNewRow: Boolean)
    var
        lText001: label '=IF(%2%1/%3%1=0,"",%2%1/%3%1)';
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
                    ExcelBuf.AddColumn(GetForecastTerritory(pItem, CountryFilter), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(CountryFilter, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    // Totals
                    FormatExcelOutputColumn(0, pQuantity);
                    FormatExcelOutputColumn(1, pAmount);
                    if pAmount < TrivialityLimit then
                        ExcelBuf.AddColumn(StrSubstNo('< %1', TrivialityLimit), false, '', false, false, false, '', ExcelBuf."cell type"::Text)
                    else
                        ExcelBuf.AddColumn(StrSubstNo('>= %1', TrivialityLimit), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn('|', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                end;
            2:
                begin
                    FormatExcelOutputColumn(0, pQuantity);
                    FormatExcelOutputColumn(1, pAmount);
                end;
            3:
                begin
                    // Blank
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                end;
        end;
    end;

    local procedure MakeExcelLineColumnSum(pItem: Record Item; pType: Integer; pNewRow: Boolean)
    var
        Qty: Decimal;
        CostAmount: Decimal;
        CostAmountGL: Decimal;
    begin
        //ItemLedgEntryTmp.RESET;
        if ItemLedgEntryTmp.FindSet then begin
            repeat
                Qty += ItemLedgEntryTmp.Quantity;
                CostAmount += ItemLedgEntryTmp."Invoiced Quantity";
                CostAmountGL += ItemLedgEntryTmp."Remaining Quantity";
            until ItemLedgEntryTmp.Next() = 0;
            MakeExcelLineColumn(pItem, pType, Qty, CostAmount, pNewRow);
        end;
    end;


    procedure MakeExcelGrandFootColumn()
    var
        lText001: label '=SUBTOTAL(109,%1%2:%1%3)';
        i: Integer;
        lText002: label '=SUM(%1%2:%1%3)';
        lText003: label 'Grand Total:';
        lText004: label 'Sub Total:';
    begin
        // Subtotal
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(lText004, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        for i := 1 to 7 do
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo := 8;
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo += 2;
        if ShowWithBackorder then begin  // 03-10-22 ZY-LD 009
            ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ColumnNo += 1;
        end;
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);

        // Total
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        for i := 1 to 7 do
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo := 8;
        ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo += 2;
        if ShowWithBackorder then begin  // 03-10-22 ZY-LD 009
            ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ColumnNo += 1;
        end;
        ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(StrSubstNo(lText002, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);

        //ZGT.GetExcelColumnHeader(ColumnNo);
    end;


    procedure CreateExcelbookColumn()
    begin
        ExcelBuf.CreateBook('', 'MR Inventory Template');
        ExcelBuf.WriteSheet('MR Inventory Template', CompanyName(), UserId());
        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
        end;
    end;

    local procedure FormatExcelOutputColumn(pType: Option Quantity,Amount; pAmount: Decimal): Integer
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

    local procedure PrevUnappQty()
    begin
    end;


    procedure InitReport(pBaseDate: Date; pBlockExcel: Boolean)
    begin
        BaseDate := pBaseDate;
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
                if pItem."No."[i] = '-' then begin
                    recForecastTerrCtry.SetFilter("Territory Code", CopyStr(pItem."No.", i + 1, 2));
                    if ZGT.IsZComCompany then
                        recForecastTerrCtry.SetRange("Division Code", 'SP')
                    else
                        recForecastTerrCtry.SetRange("Division Code", 'CH');
                    if recForecastTerrCtry.FindSet then
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
                    if recForecastTerrCtry.FindSet then
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
            if recItemBudgEntry.FindSet then
                repeat
                    if StrPos(rValue, recItemBudgEntry."Budget Dimension 1 Code") = 0 then
                        rValue += StrSubstNo('%1|', recItemBudgEntry."Budget Dimension 1 Code");
                until recItemBudgEntry.Next() = 0;
            rValue := DelChr(rValue, '>', '|');
        end;
    end;
}
