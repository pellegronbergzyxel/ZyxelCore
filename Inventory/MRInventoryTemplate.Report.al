Report 50098 "MR Inventory Template"
{
    // 001. 18-06-18 ZY-LD 2018061510000034 - Create list on a previous date.
    // 002. 25-01-19 ZY-LD 2019012310000071 - Adjustments for reporting 2019.
    // 003. 23-01-20 ZY-LD 000 - Audit found errors in the aging when we transfered from one location to another. That is now fixed.
    // 004. 11-02-20 ZY-LD 000 - Create Inventory Movements is running in a job queue, and is updating every day.
    // 005. 07-04-20 ZY-LD 2020040710000076 - When a transfer comes from a journal it doesn´t have an Order No. We use Document No. instead when it comes from the journal.
    // 006. 15-04-20 ZY-LD 2020041410000035 - Jamie wants the inventory movements pr. aging code.
    // 007. 01-12-20 ZY-LD 2020113010000045 - E-mail the report.
    // 008. 06-04-21 ZY-LD 2021040610000076 - Changed for ZNet.
    // 009. 01-11-21 ZY-LD 2021102910000048 - We have two reports doing the same. It has now been merged into one with an option to select layout.
    // 010. 24-06-22 ZY-LD 2022041110000108 - It was possible to set the aging to a newer date than the posted one.
    // 011. 08-06-23 ZY-LD #6888660 - HQ has requested that aging days is calculated without calculating - 1 day. I don´t know why it was setup that way in the first place.
    // 012. 15-11-23 ZY-LD 000 - Filtering on Item Type = Inventory.
    // 013. 21-06-24 ZY-LD #439287 - Requested by Maria.

    Caption = 'MR Inventory Template - Detailed';
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
                DataItemTableView = sorting("Item Category Code", Description) order(descending) where(Type = const(Inventory));  // 15-11-23 ZY-LD 012
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
                                    ItemAppEntryTmp.Reset;  // 24-06-22 ZY-LD 010
                                    ItemAppEntryTmp.DeleteAll;
                                    ShowAppEntries.FindAppliedEntries(recItemLedgEntry, ItemAppEntryTmp);
                                    TransferUnappQty := UnappliedQty;

                                    ItemAppEntryTmp.SetCurrentkey("Item No.", "Posting Date");
                                    ItemAppEntryTmp.SetFilter("Posting Date", '<%1', PostingDate);  // 24-06-22 ZY-LD 010
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
                                                      LineCostAmountGL,
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
                                  PostingDate,
                                  UnappliedQty,
                                  LineCostAmount,
                                  LineCostAmountGL,
                                  "Item Ledger Entry"."Entry Type");  // 11-02-20 ZY-LD 004
                                ItemCostAmount += LineCostAmount;  // 23-01-20 ZY-LD 003
                                ItemCostAmountGL += LineCostAmountGL;  // 23-01-20 ZY-LD 003
                            end;
                        end;
                    end;

                    trigger OnPostDataItem()
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
                                  (Item."Net Change" - ItemQuantity) * AverageCostAmountGL,
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
                          Item."Cost Posted to G/L",
                          "Item Ledger Entry Type"::Value99);  // 11-02-20 ZY-LD 004
                        CurrReport.Skip;
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
                        ConvItem.SetAutocalcFields("Cost Amount (Actual)");
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
                        Caption = 'End Date:';
                    }
                    field(ShowQuantity; ShowQuantity)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Quantity';
                    }
                    field(ShowDifference; ShowDifference)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Difference';
                    }
                    field(ShowClosedDetailedEntries; ShowClosedDetailedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Closed Detailed Entries';
                    }
                    field(ShowSummedUpAs; ShowSummedUpAs)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show "Summed Up" per.';
                    }
                }
            }
        }

        actions
        {
        }
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

    trigger OnPostReport()
    begin
        //>> 28-12-17 ZY-LD 007
        if QtyAndValueIsZero then
            Message(Text003);
        //<< 28-12-17 ZY-LD 007

        if not BlockExcelInventory then begin
            CreateExcelLines;
            MakeExcelGrandFoot;
            MakeExcelGrandFootColumn;
            MakeExcelGrandFootRMA;
            if not skipcreate then 
            CreateExcelbook;
        end else begin
            //>> 11-02-20 ZY-LD 004
            if recInvMoveTmp.FindSet then
                repeat
                    if not recInvMovement.Get(recInvMoveTmp.Year, recInvMoveTmp.Month, recInvMoveTmp."Item No.", recInvMoveTmp."Max. Aging Code") then begin  // 15-04-20 ZY-LD 006
                        recInvMovement := recInvMoveTmp;
                        recInvMovement.Insert(true);
                    end else begin
                        if (recInvMoveTmp.Quantity <> recInvMovement.Quantity) or
                           (recInvMoveTmp.Amount <> recInvMovement.Amount)
                        //(recInvMoveTmp."Max. Aging Code" <> recInvMovement."Max. Aging Code")  // 15-04-20 ZY-LD 006
                        then begin
                            //recInvMovement."Max. Aging Code" := recInvMoveTmp."Max. Aging Code";  // 15-04-20 ZY-LD 006
                            recInvMovement.Quantity := recInvMoveTmp.Quantity;
                            recInvMovement.Amount := recInvMoveTmp.Amount;
                            recInvMovement.Modify(true);
                        end;
                    end;
                until recInvMoveTmp.Next() = 0;
            //<< 11-02-20 ZY-LD 004
        end;
    end;

    trigger OnPreReport()
    begin
        AgingCode := '0-180';  // 23-07-18 ZY-LD 001
        if not BlockExcelInventory then begin  // 11-02-20 ZY-LD 004
            MakeExcelHead;
            MakeExcelHeadColumn;
            MakeExcelHeadRMA;
        end;
        recGenLedgSetup.Get;  // 25-01-19 ZY-LD 002
        recInvSetup.Get;  // 23-01-20 ZY-LD 003
        recItemLedgEntry.SetCurrentkey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");  // 23-01-20 ZY-LD 003

        SI.UseOfReport(3, 50098, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        recAgingCode: Record "Aging Code";
        ExcelBuf: Record "Excel Buffer" temporary;
        ExcelBuf2: Record "Excel Buffer" temporary;
        ExcelBufRMA: Record "Excel Buffer" temporary;
        ItemAppEntry: Record "Item Application Entry";
        recItemLedgEntry: Record "Item Ledger Entry";
        ItemAppEntryTmp: Record "Item Ledger Entry" temporary;
        ItemAppEntryTmp2: Record "Item Ledger Entry" temporary;
        ItemLedgEntryTmp: Record "Item Ledger Entry" temporary;
        ConvItem: Record Item;
        recGenLedgSetup: Record "General Ledger Setup";
        recInvSetup: Record "Inventory Setup";
        recInvMoveTmp: Record "Inventory Movement Entry" temporary;
        recInvMovement: Record "Inventory Movement Entry";
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        ShowAppEntries: Codeunit "Show Applied Entries";
        AgingCode: Code[10];
        BaseDate: Date;
        Col: Integer;
        ShowQuantity: Boolean;
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
        RowNoCol: Integer;
        RowNoRMA: Integer;
        UnappliedQty: Decimal;
        LineCostAmount: Decimal;
        ItemCostAmount: Decimal;
        TotalCostAmount: Decimal;
        LineCostAmountGL: Decimal;
        ItemCostAmountGL: Decimal;
        Text029: label 'All including RMA';
        QtyAndValueIsZero: Boolean;
        Text030: label 'Grand Total:';
        ItemQuantity: Decimal;
        Text031: label 'Posted to G/L';
        ShowClosedDetailedEntries: Boolean;
        Text032: label 'Difference';
        AverageCostAmount: Decimal;
        AverageCostAmountGL: Decimal;
        EntryNo: Integer;
        Text033: label 'ZYRHQ';
        Text034: label 'Sub Account No.';
        Text035: label 'Sub Account Name';
        Text036: label 'Business Model';
        PostingDate: Date;
        EntryPosted: Boolean;
        BlockExcelInventory: Boolean;
        FilenameServer: Text;
        ShowSummedUpAs: Option Item,Location;
        skipcreate: boolean;

    local procedure CreateItemLedgerEntryTemp(pItemNo: Code[20]; pLocationCode: Code[10]; pDivisionCode: Code[10]; pPostingDate: Date; pQuantity: Decimal; pLineCostAmount: Decimal; pLineCostAmountGL: Decimal; pEntryType: Enum "Item Ledger Document Type")
    var
        AgiCode: Code[10];
    begin
        AgiCode := recAgingCode.GetAgingCode(AgingCode, CalcDueDate(BaseDate - pPostingDate));

        if not BlockExcelInventory then begin  // 11-02-20 ZY-LD 004
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
                ItemLedgEntryTmp."Remaining Quantity" := pLineCostAmountGL;
                ItemLedgEntryTmp.Insert;
            end else begin
                ItemLedgEntryTmp.Quantity := ItemLedgEntryTmp.Quantity + pQuantity;
                ItemLedgEntryTmp."Invoiced Quantity" := ItemLedgEntryTmp."Invoiced Quantity" + pLineCostAmount;
                ItemLedgEntryTmp."Remaining Quantity" := ItemLedgEntryTmp."Remaining Quantity" + pLineCostAmountGL;
                ItemLedgEntryTmp.Modify;
            end;
        end else begin
            //>> 11-02-20 ZY-LD 004
            if not recInvMoveTmp.Get(Date2dmy(BaseDate, 3), Date2dmy(BaseDate, 2), pItemNo, AgiCode) then begin  // 15-04-20 ZY-LD 006
                recInvMoveTmp."Period End Date" := BaseDate;
                recInvMoveTmp.Year := Date2dmy(BaseDate, 3);
                recInvMoveTmp.Month := Date2dmy(BaseDate, 2);
                recInvMoveTmp."Item No." := pItemNo;
                recInvMoveTmp."Max. Aging Code" := AgiCode;
                recInvMoveTmp.Quantity := pQuantity;
                recInvMoveTmp.Amount := pLineCostAmount;
                recInvMoveTmp.Insert;
            end else begin
                //recInvMoveTmp."Max. Aging Code" := recAgingCode.GetMaxAcingCode(AgingCode,recInvMoveTmp."Max. Aging Code",AgiCode);  // 15-04-20 ZY-LD 006
                recInvMoveTmp.Quantity += pQuantity;
                recInvMoveTmp.Amount += pLineCostAmount;
                recInvMoveTmp.Modify;
            end;
            //<< 11-02-20 ZY-LD 004
        end;
    end;

    local procedure CreateExcelLines()
    var
        recItem: Record Item;
        recLocation: Record Location;
        lText001: label 'Creating Excel Lines';
        QuantityTemp: Decimal;
        CostTemp: Decimal;
    begin
        ItemLedgEntryTmp.Reset;
        if not ItemLedgEntryTmp.IsEmpty then begin
            // Excel Sheet pr. Line
            ItemLedgEntryTmp.Reset;
            ItemLedgEntryTmp.SetCurrentkey("Item No.");
            if ItemLedgEntryTmp.FindSet then
                repeat
                    MakeExcelLine(ItemLedgEntryTmp);
                until ItemLedgEntryTmp.Next() = 0;

            // Excel Sheet pr. Column
            if recItem.FindSet then begin
                ZGT.OpenProgressWindow('', recItem.Count);
                repeat
                    ZGT.UpdateProgressWindow(lText001, 0, true);

                    ItemLedgEntryTmp.SetRange("Item No.", recItem."No.");
                    ItemLedgEntryTmp.SetRange("Variant Code");
                    ItemLedgEntryTmp.SetRange("Location Code");  //  xx
                    if not ItemLedgEntryTmp.IsEmpty then begin
                        //>> 01-11-21 ZY-LD 009
                        if ShowSummedUpAs = Showsummedupas::Location then begin
                            Location.Copyfilter(Code, recLocation.Code);
                            if recLocation.FindSet then
                                repeat
                                    ItemLedgEntryTmp.SetRange("Location Code", recLocation.Code);
                                    if ItemLedgEntryTmp.FindFirst then begin
                                        MakeExcelLineColumnSum(recItem, 1, true, recLocation.Code);
                                        QuantityTemp := 0;
                                        CostTemp := 0;
                                        repeat
                                            QuantityTemp += ItemLedgEntryTmp.Quantity;
                                            CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                        until ItemLedgEntryTmp.Next() = 0;
                                        MakeExcelLineColumn(recItem, 2, QuantityTemp, CostTemp, 0, false, recLocation.Code);
                                    end else
                                        MakeExcelLineColumn(recItem, 2, 0, 0, 0, false, recLocation.Code);
                                until recLocation.Next() = 0;
                        end else begin  //<< 01-11-21 ZY-LD 009
                            MakeExcelLineColumnSum(recItem, 1, true, recLocation.Code);
                            recAgingCode.SetRange(Code, AgingCode);
                            if recAgingCode.FindSet then begin
                                repeat
                                    ItemLedgEntryTmp.SetRange("Variant Code", recAgingCode."Aging Code");
                                    if ItemLedgEntryTmp.FindFirst then begin
                                        QuantityTemp := 0;
                                        CostTemp := 0;
                                        repeat
                                            QuantityTemp += ItemLedgEntryTmp.Quantity;
                                            CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                        until ItemLedgEntryTmp.Next() = 0;
                                        MakeExcelLineColumn(recItem, 2, QuantityTemp, CostTemp, 0, false, '');
                                    end else
                                        MakeExcelLineColumn(recItem, 2, 0, 0, 0, false, '');
                                until recAgingCode.Next() = 0;

                                // RMA Over 181
                                MakeExcelLineColumn(recItem, 3, 0, 0, 0, false, '');
                                ItemLedgEntryTmp.SetFilter("Location Code", '%1', 'RMA*');
                                if ItemLedgEntryTmp.FindFirst then begin
                                    QuantityTemp := 0;
                                    CostTemp := 0;
                                    repeat
                                        QuantityTemp += ItemLedgEntryTmp.Quantity;
                                        CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                    until ItemLedgEntryTmp.Next() = 0;
                                    MakeExcelLineColumn(recItem, 2, QuantityTemp, CostTemp, 0, false, '');
                                end else
                                    MakeExcelLineColumn(recItem, 2, 0, 0, 0, false, '');
                                ItemLedgEntryTmp.SetRange("Location Code");

                            end;
                        end;
                    end;
                until recItem.Next() = 0;

                ZGT.CloseProgressWindow;
            end;

            // RMA
            if recItem.FindSet then begin
                ZGT.OpenProgressWindow('', recItem.Count);
                ItemLedgEntryTmp.Reset;
                ItemLedgEntryTmp.SetFilter("Location Code", '%1', 'RMA*');
                repeat
                    ZGT.UpdateProgressWindow(lText001, 0, true);

                    ItemLedgEntryTmp.SetRange("Item No.", recItem."No.");
                    ItemLedgEntryTmp.SetRange("Variant Code");
                    if not ItemLedgEntryTmp.IsEmpty then begin
                        MakeExcelLineRMASum(recItem, 1, true);

                        recAgingCode.SetRange(Code, AgingCode);
                        if recAgingCode.FindSet then
                            repeat
                                ItemLedgEntryTmp.SetRange("Variant Code", recAgingCode."Aging Code");
                                if ItemLedgEntryTmp.FindFirst then begin
                                    QuantityTemp := 0;
                                    CostTemp := 0;
                                    repeat
                                        QuantityTemp += ItemLedgEntryTmp.Quantity;
                                        CostTemp += ItemLedgEntryTmp."Invoiced Quantity";
                                    until ItemLedgEntryTmp.Next() = 0;
                                    MakeExcelLineRMA(recItem, 2, QuantityTemp, CostTemp, 0, false);
                                end else
                                    MakeExcelLineRMA(recItem, 2, 0, 0, 0, false);
                            until recAgingCode.Next() = 0;
                    end;
                until recItem.Next() = 0;

                ZGT.CloseProgressWindow;
            end;
        end;
    end;

    local procedure MakeExcelHead()
    begin
        ExcelBuf.AddColumn(Text029, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo('%1 %2', Text19072657, BaseDate), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo(Text024, CurrentDatetime), false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Text001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text004, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text005, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text008, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text034, false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 25-01-19 ZY-LD 002
        ExcelBuf.AddColumn(Text035, false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 25-01-19 ZY-LD 002
        ExcelBuf.AddColumn(Text006, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text007, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text009, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text010, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text011, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text012, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text013, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text036, false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 25-01-19 ZY-LD 002
        ExcelBuf.AddColumn(Text014, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text015, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        if ShowDifference then begin
            ExcelBuf.AddColumn(Text031, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(Text032, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        end;
        ExcelBuf.AddColumn(Text016, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text017, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text018, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text019, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text020, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text021, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text022, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text005, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Text023, false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        // ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Location Code"),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn(Text025,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        RowNo := 2;
    end;

    local procedure MakeExcelLine(pItemLedgerEntry: Record "Item Ledger Entry")
    var
        recItem: Record Item;
        recInvPostSetup: Record "Inventory Posting Setup";
        recGlAcc: Record "G/L Account";
        lText001: label 'Channel';
        lText002: label 'Service Provider';
        lText003: label 'Unknown';
    begin
        recItem.Get(pItemLedgerEntry."Item No.");
        recItem.TestField("Inventory Posting Group");
        recInvPostSetup.Get(pItemLedgerEntry."Location Code", recItem."Inventory Posting Group");
        recGlAcc.Get(recInvPostSetup."Inventory Account");

        ExcelBuf.NewRow;
        //>> 21-06-24 ZY-LD 013
        //ExcelBuf.AddColumn(Date2dmy(pItemLedgerEntry."Posting Date", 3), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        //ExcelBuf.AddColumn(Date2dmy(pItemLedgerEntry."Posting Date", 2), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Date2dmy(today, 3), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Date2dmy(today, 2), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        //<< 21-06-24 ZY-LD 013
        //>> 06-04-21 ZY-LD 008
        if ZGT.IsZNetCompany then
            ExcelBuf.AddColumn('ZNet AS', false, '', false, false, false, '', ExcelBuf."cell type"::Number)
        else
            if ZGT.CompanyNameIs(11) then  // ZyND DE
                ExcelBuf.AddColumn('ZyDE', false, '', false, false, false, '', ExcelBuf."cell type"::Number)
            else  //<< 06-04-21 ZY-LD 008
                ExcelBuf.AddColumn('ZyAS', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(recGlAcc."No. 2", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recGlAcc."Name 2", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recGenLedgSetup."LCY Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recInvPostSetup."Inventory Account", false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 25-01-19 ZY-LD 002
        ExcelBuf.AddColumn(recGlAcc.Name, false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 25-01-19 ZY-LD 002
        ExcelBuf.AddColumn(pItemLedgerEntry."Location Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pItemLedgerEntry."Item No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pItemLedgerEntry."Item No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem."Category 2 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem."Category 1 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.Description, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        //>> 25-01-19 ZY-LD 002
        if StrPos(pItemLedgerEntry."Global Dimension 1 Code", 'CH') <> 0 then  // Channel
            ExcelBuf.AddColumn(lText001, false, '', false, false, false, '', ExcelBuf."cell type"::Text)
        else
            if StrPos(pItemLedgerEntry."Global Dimension 1 Code", 'SP') <> 0 then  // Service Provider
                ExcelBuf.AddColumn(lText002, false, '', false, false, false, '', ExcelBuf."cell type"::Text)
            else
                ExcelBuf.AddColumn(lText003, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        //<< 25-01-19 ZY-LD 002
        ExcelBuf.AddColumn(pItemLedgerEntry.Quantity, false, '', false, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(pItemLedgerEntry."Invoiced Quantity", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        if ShowDifference then begin
            ExcelBuf.AddColumn(pItemLedgerEntry."Remaining Quantity", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(pItemLedgerEntry."Invoiced Quantity" - pItemLedgerEntry."Remaining Quantity", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        end;
        ExcelBuf.AddColumn(pItemLedgerEntry."Posting Date", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(CalcDueDate(BaseDate - pItemLedgerEntry."Posting Date"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(recAgingCode.GetAgingCode(AgingCode, CalcDueDate(BaseDate - pItemLedgerEntry."Posting Date")), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 23-07-18 ZY-LD 001
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recGlAcc."Name 2", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        //ExcelBuf.AddColumn(pItemLedgerEntry."Entry No.",FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        RowNo += 1;
    end;

    local procedure FormatExcelOutput(pType: Option Quantity,Amount; pAmount: Decimal): Integer
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

    local procedure MakeExcelGrandFoot()
    var
        lText001: label '=SUM(%1%2:%1%3)';
        i: Integer;
    begin
        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Grand Total:', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ColumnNo := 16;
        for i := 1 to ColumnNo - 1 do
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNo), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNo), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        if ShowDifference then begin
            ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNo), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNo), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        end;
    end;

    local procedure CreateExcelbook()
    var
        lText001: label 'Detailed %1';
        lText002: label 'Summed Up %1';
        lText003: label 'RMA %1';
    begin
        ExcelBuf.CreateBook('', StrSubstNo(lText001, AgingCode));
        // Detailed
        ExcelBuf.WriteSheet(StrSubstNo(lText001, AgingCode), CompanyName(), UserId());

        // Summed Up
        if ExcelBuf2.FindFirst then begin
            ExcelBuf.DeleteAll;
            repeat
                ExcelBuf := ExcelBuf2;
                ExcelBuf.Insert;
            until ExcelBuf2.Next() = 0;
            ExcelBuf.AddNewSheet(StrSubstNo(lText002, AgingCode));
            ExcelBuf.WriteSheet(StrSubstNo(lText002, AgingCode), CompanyName(), UserId());
        end;

        // RMA
        if ExcelBufRMA.FindFirst then begin
            ExcelBuf.DeleteAll;
            repeat
                ExcelBuf := ExcelBufRMA;
                ExcelBuf.Insert;
            until ExcelBufRMA.Next() = 0;
            ExcelBuf.AddNewSheet(StrSubstNo(lText003, AgingCode));
            ExcelBuf.WriteSheet(StrSubstNo(lText003, AgingCode), CompanyName(), UserId());
        end;

        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
        end else
            FilenameServer := ExcelBuf.GetFileNameServer;  // 01-12-20 ZY-LD 007
    end;

    local procedure MakeExcelHeadColumn()
    var
        lText001: label 'Quantity %1';
        lText002: label 'Amount %1';
    begin
        ExcelBuf2.AddColumn(Text029, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf2.AddColumn(StrSubstNo('%1 %2', Text19072657, BaseDate), false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn(StrSubstNo(Text004, CurrentDatetime), false, '', true, false, false, '', ExcelBuf2."cell type"::Text);

        Col := 37;
        ExcelBuf2.NewRow;
        ExcelBuf2.AddColumn('Company_Code', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('Item_No', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('Description', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('CAT I', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('CAT II', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('Warehouse', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        if ShowQuantity then
            ExcelBuf2.AddColumn('Total Quantity', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('Total Amount', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('Posted to G/L', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        if ShowDifference then
            ExcelBuf2.AddColumn('Difference', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);

        recAgingCode.SetRange(Code, AgingCode);
        if recAgingCode.FindFirst then
            repeat
                if ShowQuantity then
                    ExcelBuf2.AddColumn(StrSubstNo(lText001, recAgingCode."Aging Code"), false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
                ExcelBuf2.AddColumn(StrSubstNo(lText002, recAgingCode."Aging Code"), false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
            until recAgingCode.Next() = 0;

        // RMA
        ExcelBuf2.AddColumn('', false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo('RMA ' + lText001, recAgingCode."Aging Code"), false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn(StrSubstNo('RMA ' + lText002, recAgingCode."Aging Code"), false, '', true, false, false, '', ExcelBuf2."cell type"::Text);

        RowNoCol := 2;
    end;

    local procedure MakeExcelLineColumn(pItem: Record Item; pType: Integer; pQuantity: Decimal; pAmount: Decimal; pCostPosted: Decimal; pNewRow: Boolean; pLocation: Code[20])
    begin
        if pNewRow then begin
            ExcelBuf2.NewRow;
            RowNoCol += 1;
        end;

        case pType of
            1:
                begin
                    ExcelBuf2.AddColumn(Format(Text033), false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                    ExcelBuf2.AddColumn(pItem."No.", false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                    ExcelBuf2.AddColumn(pItem.Description, false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                    ExcelBuf2.AddColumn(pItem."Category 1 Code", false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                    ExcelBuf2.AddColumn(pItem."Category 2 Code", false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                    ExcelBuf2.AddColumn(pLocation, false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                    // Totals
                    if ShowQuantity then
                        FormatExcelOutputColumn(0, pQuantity);
                    FormatExcelOutputColumn(1, pAmount);
                    FormatExcelOutputColumn(1, pCostPosted);
                    if ShowDifference then
                        FormatExcelOutputColumn(1, pAmount - pCostPosted);
                end;
            2:
                begin
                    if ShowQuantity then
                        FormatExcelOutputColumn(0, pQuantity);
                    FormatExcelOutputColumn(1, pAmount);
                end;
            3:
                begin
                    // Blank
                    ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
                end;
        end;
    end;

    local procedure MakeExcelLineColumnSum(pItem: Record Item; pType: Integer; pNewRow: Boolean; pLocation: Code[10])
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
            //>> 01-11-21 ZY-LD 009
            if ShowSummedUpAs = Showsummedupas::Location then
                MakeExcelLineColumn(pItem, pType, Qty, CostAmount, CostAmountGL, pNewRow, pLocation)
            else  //<< 01-11-21 ZY-LD 009
                MakeExcelLineColumn(pItem, pType, Qty, CostAmount, CostAmountGL, pNewRow, '');
        end;
    end;

    local procedure MakeExcelGrandFootColumn()
    var
        lText001: label '=SUM(%1%2:%1%3)';
    begin
        ExcelBuf2.NewRow;
        ExcelBuf2.NewRow;
        ExcelBuf2.AddColumn(Text030, false, '', true, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
        ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
        ColumnNo := 6;
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowDifference then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
        ZGT.GetExcelColumnHeader(ColumnNo);
        ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf2."cell type"::Text);
        if ShowQuantity then
            ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0', ExcelBuf2."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoCol), true, '', true, false, false, '##,###,##0.00', ExcelBuf2."cell type"::Number);
    end;

    local procedure CreateExcelbookColumn()
    begin
        ExcelBuf2.CreateBook('', 'MR Inventory Template');
        ExcelBuf2.WriteSheet('MR Inventory Template', CompanyName(), UserId());
        ExcelBuf2.CloseBook;
        if GuiAllowed then begin
            ExcelBuf2.OpenExcel;
        end;
    end;

    local procedure FormatExcelOutputColumn(pType: Option Quantity,Amount; pAmount: Decimal): Integer
    begin
        Col := 255;
        if pAmount <> 0 then begin
            case pType of
                Ptype::Quantity:
                    ExcelBuf2.AddColumn(pAmount, false, '', false, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
                Ptype::Amount:
                    ExcelBuf2.AddColumn(pAmount, false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            end;
        end else
            ExcelBuf2.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
    end;

    local procedure MakeExcelHeadRMA()
    var
        lText001: label 'Quantity %1';
        lText002: label 'Amount %1';
    begin
        ExcelBufRMA.AddColumn(Text029, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBufRMA.AddColumn(StrSubstNo('%1 %2', Text19072657, BaseDate), false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn(StrSubstNo(Text004, CurrentDatetime), false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);

        Col := 37;
        ExcelBufRMA.NewRow;
        ExcelBufRMA.AddColumn('Company_Code', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('Item_No', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('Item_No', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('CAT I', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('CAT II', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('Description', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        if ShowQuantity then
            ExcelBufRMA.AddColumn('Total Quantity', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('Total Amount', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('Posted to G/L', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        if ShowDifference then
            ExcelBufRMA.AddColumn('Difference', false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);

        recAgingCode.SetRange(Code, AgingCode);
        if recAgingCode.FindFirst then
            repeat
                if ShowQuantity then
                    ExcelBufRMA.AddColumn(StrSubstNo(lText001, recAgingCode."Aging Code"), false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
                ExcelBufRMA.AddColumn(StrSubstNo(lText002, recAgingCode."Aging Code"), false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
            until recAgingCode.Next() = 0;

        RowNoRMA := 2;
    end;

    local procedure MakeExcelLineRMA(pItem: Record Item; pType: Integer; pQuantity: Decimal; pAmount: Decimal; pCostPosted: Decimal; pNewRow: Boolean)
    begin
        if pNewRow then begin
            ExcelBufRMA.NewRow;
            RowNoRMA += 1;
        end;

        case pType of
            1:
                begin
                    ExcelBufRMA.AddColumn(Text033, false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
                    ExcelBufRMA.AddColumn(pItem."No.", false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
                    ExcelBufRMA.AddColumn(pItem."No.", false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
                    ExcelBufRMA.AddColumn(pItem."Category 1 Code", false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
                    ExcelBufRMA.AddColumn(pItem."Category 2 Code", false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
                    ExcelBufRMA.AddColumn(pItem.Description, false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
                    // Totals
                    if ShowQuantity then
                        FormatExcelOutputRMA(0, pQuantity);
                    FormatExcelOutputRMA(1, pAmount);
                    FormatExcelOutputRMA(1, pCostPosted);
                    if ShowDifference then
                        FormatExcelOutputRMA(1, pAmount - pCostPosted);
                end;
            2:
                begin
                    if ShowQuantity then
                        FormatExcelOutputRMA(0, pQuantity);
                    FormatExcelOutputRMA(1, pAmount);
                end;
        end;
    end;

    local procedure MakeExcelLineRMASum(pItem: Record Item; pType: Integer; pNewRow: Boolean)
    var
        Qty: Decimal;
        CostAmount: Decimal;
        CostAmountGL: Decimal;
    begin
        if ItemLedgEntryTmp.FindSet then begin
            repeat
                Qty += ItemLedgEntryTmp.Quantity;
                CostAmount += ItemLedgEntryTmp."Invoiced Quantity";
                CostAmountGL += ItemLedgEntryTmp."Remaining Quantity";
            until ItemLedgEntryTmp.Next() = 0;
            MakeExcelLineRMA(pItem, pType, Qty, CostAmount, CostAmountGL, pNewRow);
        end;
    end;

    local procedure MakeExcelGrandFootRMA()
    var
        lText001: label '=SUM(%1%2:%1%3)';
    begin
        ExcelBufRMA.NewRow;
        ExcelBufRMA.NewRow;
        ExcelBufRMA.AddColumn(Text030, false, '', true, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('', false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('', false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('', false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('', false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
        ExcelBufRMA.AddColumn('', false, '', false, false, false, '', ExcelBufRMA."cell type"::Text);
        ColumnNo := 6;
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowDifference then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        if ShowQuantity then
            ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0', ExcelBufRMA."cell type"::Number);
        ExcelBufRMA.AddColumn(StrSubstNo(lText001, ZGT.GetExcelColumnHeader(ColumnNo), 3, RowNoRMA), true, '', true, false, false, '##,###,##0.00', ExcelBufRMA."cell type"::Number);
        ZGT.GetExcelColumnHeader(ColumnNo);
    end;

    local procedure FormatExcelOutputRMA(pType: Option Quantity,Amount; pAmount: Decimal): Integer
    begin
        Col := 255;
        if pAmount <> 0 then begin
            case pType of
                Ptype::Quantity:
                    ExcelBufRMA.AddColumn(pAmount, false, '', false, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
                Ptype::Amount:
                    ExcelBufRMA.AddColumn(pAmount, false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            end;
        end else
            ExcelBufRMA.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
    end;

    procedure CalcDueDate(pDueDate: Integer): Integer
    begin
        if pDueDate < 0 then
            exit(0)
        else
            exit(pDueDate);  // 08-06-23 ZY-LD 011
                             //EXIT(pDueDate - 1);  // 08-06-23 ZY-LD 011
    end;

    local procedure PrevUnappQty()
    begin
    end;


    procedure InitReport(pBaseDate: Date; pShowQuantity: Boolean; pShowDifference: Boolean; pShowClosedDetailedEntries: Boolean; pBlockExcel: Boolean;pSkipcreate: Boolean)
    begin
        BaseDate := pBaseDate;
        ShowQuantity := pShowQuantity;  // 01-12-20 ZY-LD 007
        ShowDifference := pShowDifference;  // 01-12-20 ZY-LD 007
        ShowClosedDetailedEntries := pShowClosedDetailedEntries;  // 01-12-20 ZY-LD 007
        BlockExcelInventory := pBlockExcel;
        Skipcreate := pSkipcreate;
    end;


    procedure GetFilenameServer(): Text
    begin
        exit(FilenameServer);  // 01-12-20 ZY-LD 007
    end;

    // PG 18-07-2025
    procedure getExcelbuffer(var gExcelbuf: Record "Excel Buffer" temporary; type: Integer)
    begin
        // ExcelBuf: Record "Excel Buffer" temporary;
        // ExcelBuf2: Record "Excel Buffer" temporary;
        // ExcelBufRMA: Record "Excel Buffer" temporary;
        gExcelbuf.DeleteAll();
        case type of
            1:
                begin
  if ExcelBuf.FindFirst then begin
                        repeat
                            gExcelbuf := ExcelBuf;
                            gExcelbuf.Insert;
                        until ExcelBuf.Next() = 0;
                    end;
                end;

            2:
                begin
                    if ExcelBuf2.FindFirst then begin
                        repeat
                            gExcelbuf := ExcelBuf2;
                            gExcelbuf.Insert;
                        until ExcelBuf2.Next() = 0;
                    end;
                end;
            3:
                begin
                        if ExcelBufRMA.FindFirst then begin
                            repeat
                                gExcelbuf := ExcelBufRMA;
                                gExcelbuf.Insert;
                            until ExcelBufRMA.Next() = 0;
                        end;

                end;
                    end;
                end;
}
