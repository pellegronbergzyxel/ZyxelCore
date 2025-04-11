Report 50031 "Stock- and Warehouse Report"
{
    // 001. 30-11-21 ZY-LD 2021113010000034 - We use calculationdate different now.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Stock- and Warehouse Report.rdlc';

    Caption = 'Stock- and Warehouse Report';
    ShowPrintStatus = false;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = Inventory, "Qty. on Sales Order", "Qty. on Sales Order Confirmed", "Trans. Ord. Shipment (Qty.)", "Tr. Or. Ship (Qty.) Confirmed", "Unconfirmed Picking Date";
            DataItemTableView = sorting("No.") where(Inactive = const(false));
            RequestFilterFields = "No.", "Location Filter";
            column(No; Item."No.")
            {
            }
            column(Description; Item.Description)
            {
            }
            column(Category1Code; Item."Category 1 Code")
            {
            }
            column(Inventory; Item.Inventory)
            {
            }
            column(QtyOnSalesOrder; Item."Qty. on Sales Order")
            {
            }
            column(QtyOnSalesOrderConfirmed; Item."Qty. on Sales Order Confirmed")
            {
            }
            column(QtyOnTransfOrder; Item."Trans. Ord. Shipment (Qty.)")
            {
            }
            column(QtyOnTransfOrderConfirmed; Item."Tr. Or. Ship (Qty.) Confirmed")
            {
            }
            column(QtyUnConfirmedPick; Item."Unconfirmed Picking Date")
            {
            }
            column(QuantityArray1; QuantityArray[1])
            {
            }
            column(QuantityArray2; QuantityArray[2])
            {
            }
            column(QuantityArray3; QuantityArray[3])
            {
            }
            column(QuantityArray4; QuantityArray[4])
            {
            }
            column(QuantityArray5; QuantityArray[5])
            {
            }
            column(QuantityArray6; QuantityArray[6])
            {
            }
            column(QuantityArray7; QuantityArray[7])
            {
            }
            column(QuantityArray8; QuantityArray[8])
            {
            }
            column(UnShipArray1; UnShipArray[1])
            {
            }
            column(UnShipArray2; UnShipArray[2])
            {
            }
            column(UnShipArray3; UnShipArray[3])
            {
            }
            column(UnShipArray4; UnShipArray[4])
            {
            }
            column(UnShipArray5; UnShipArray[5])
            {
            }
            column(UnShipArray6; UnShipArray[6])
            {
            }
            column(UnShipArray7; UnShipArray[7])
            {
            }
            column(UnShipArray8; UnShipArray[8])
            {
            }
            column(CaptionArray1; CaptionArray[1])
            {
            }
            column(CaptionArray2; CaptionArray[2])
            {
            }
            column(CaptionArray3; CaptionArray[3])
            {
            }
            column(CaptionArray4; CaptionArray[4])
            {
            }
            column(CaptionArray5; CaptionArray[5])
            {
            }
            column(CaptionArray6; CaptionArray[6])
            {
            }
            column(CaptionArray7; CaptionArray[7])
            {
            }
            column(CaptionArray8; CaptionArray[8])
            {
            }
            column(No_Caption; Item.FieldCaption(Item."No."))
            {
            }
            column(Description_Caption; Item.FieldCaption(Item.Description))
            {
            }
            column(Category_Caption; Item.FieldCaption(Item."Category 1 Code"))
            {
            }
            column(QtyOnSalesOrder_Caption; Item.FieldCaption(Item."Qty. on Sales Order"))
            {
            }
            column(QtyOnSalesOrderConfirm_Caption; Item.FieldCaption(Item."Qty. on Sales Order Confirmed"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Item."No.", 0, true);
                GetShippingData;
                if (Item.Inventory + Item."Qty. on Sales Order" + QuantityArrayTotal + UnShipArrayTotal) = 0 then
                    CurrReport.Skip;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            var
                i: Integer;
            begin
                ZGT.OpenProgressWindow('', Item.Count);

                for i := 1 to NumberOfMonths do begin
                    CalcStarAndtEndDate(i);
                    case i of
                        //>> 30-11-21 ZY-LD 001
                        //1 : CaptionArray[i] := STRSUBSTNO('..%1 %2',ZGT.GetMonthText(DATE2DMY(EndDate,2),FALSE,FALSE,TRUE),DATE2DMY(EndDate,3));
                        //2 : CaptionArray[i] := STRSUBSTNO('%1 %2',ZGT.GetMonthText(DATE2DMY(StartDate,2),FALSE,FALSE,TRUE),DATE2DMY(StartDate,3));
                        1:
                            begin
                                if EndDate <> CalcDate('<CM>', EndDate) then
                                    CaptionArray[i] := StrSubstNo('..%1', EndDate)
                                else
                                    CaptionArray[i] := StrSubstNo('..%1 %2', ZGT.GetMonthText(Date2dmy(EndDate, 2), false, false, true), Date2dmy(EndDate, 3));
                            end;
                        2, 3, 4, 5, 6:
                            begin
                                if (StartDate <> CalcDate('<-CM>', StartDate)) or
                                   (EndDate <> CalcDate('<CM>', EndDate))
                                then
                                    CaptionArray[i] := StrSubstNo('%1-%2', StartDate, EndDate)
                                else
                                    CaptionArray[i] := StrSubstNo('%1 %2', ZGT.GetMonthText(Date2dmy(StartDate, 2), false, false, true), Date2dmy(StartDate, 3));
                            end;
                        //<< 30-11-21 ZY-LD 001
                        7:
                            CaptionArray[i] := Text002;
                        8:
                            CaptionArray[i] := Text001;
                    end;
                end;
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
                    field(CalculationDate; CalculationDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calculation Date';
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
        Type1 = 'Goods in Transit';
        Type2 = 'Unshipped';
        QtyOnHand = 'Qty. On-Hand';
        lQtyOnSalesOrder = 'Qty. on Sales Order';
        lQtyOnSalesOrderConfirmed = 'Qty. on Sales Order Confirmed';
        lQtyOnTransOrder = 'Qty. on Transfer Order';
        lQtyOnTransOrderConfirmed = 'Qty. on Transfer Order Confirmed';
        lQtyUnconfirmed = 'Qty. Unconfirmed';
    }

    trigger OnPreReport()
    begin
        NumberOfMonths := 8;
    end;

    var
        CalculationDate: Date;
        StartDate: Date;
        EndDate: Date;
        DateFormula: DateFormula;
        QuantityArray: array[8] of Integer;
        QuantityArrayTotal: Integer;
        UnShipArray: array[8] of Integer;
        UnShipArrayTotal: Integer;
        CaptionArray: array[8] of Text;
        NumberOfMonths: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: label 'Unknown';
        Text002: label 'Later';

    local procedure GetShippingData()
    var
        recVCKShipDetail: Record "VCK Shipping Detail";
        recUnshipPurchO: Record "Unshipped Purchase Order";
        PurchLine: Record "Purchase Line";
        i: Integer;
    begin
        Clear(QuantityArray);
        QuantityArrayTotal := 0;
        Clear(UnShipArray);
        UnShipArrayTotal := 0;

        for i := 1 to NumberOfMonths do begin
            CalcStarAndtEndDate(i);

            recVCKShipDetail.SetCurrentkey("Container No.", "Invoice No.", "Purchase Order No.", "Purchase Order Line No.", "Pallet No.", "Item No.", "Shipping Method", "Order No.");
            recVCKShipDetail.SetRange("Order Type", recVCKShipDetail."order type"::"Purchase Order");
            recVCKShipDetail.SetRange(Archive, false);
            recVCKShipDetail.SetRange("Item No.", Item."No.");
            recVCKShipDetail.SetFilter(Location, Item."Location Filter");
            case i of
                1:
                    recVCKShipDetail.SetFilter("Expected Receipt Date", '%1..%2', 20000101D, EndDate);
                2, 3, 4, 5, 6:
                    recVCKShipDetail.SetRange("Expected Receipt Date", StartDate, EndDate);
                7:
                    recVCKShipDetail.SetFilter("Expected Receipt Date", '%1..', StartDate);
                8:
                    recVCKShipDetail.SetRange("Expected Receipt Date", 0D);
            end;
            if recVCKShipDetail.FindSet then
                repeat
                    QuantityArray[i] += recVCKShipDetail.Quantity;
                    QuantityArrayTotal += recVCKShipDetail.Quantity;
                until recVCKShipDetail.Next() = 0;

            recUnshipPurchO.SETCURRENTKEY("Item No.");
            recUnshipPurchO.SETRANGE("Item No.", Item."No.");
            recUnshipPurchO.SETFILTER("Location Code", Item."Location Filter");
            CASE i OF
                1:
                    recUnshipPurchO.SETFILTER("Expected receipt date", '%1..%2', 20000101D, EndDate);
                2, 3, 4, 5, 6:
                    recUnshipPurchO.SETRANGE("Expected receipt date", StartDate, EndDate);
                7:
                    recUnshipPurchO.SETFILTER("Expected receipt date", '%1..', StartDate);
                8:
                    recUnshipPurchO.SETRANGE("Expected receipt date", 0D);
            END;
            IF recUnshipPurchO.FINDSET THEN
                REPEAT
                    UnShipArray[i] += recUnshipPurchO.Quantity;
                    UnShipArrayTotal += recUnshipPurchO.Quantity;
                UNTIL recUnshipPurchO.NEXT = 0;

            /*PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
            PurchLine.SetRange(Type, PurchLine.Type::Item);
            PurchLine.SetRange("No.", Item."No.");
            PurchLine.SetFilter("Location Code", Item."Location Filter");
            PurchLine.SetFilter(OriginalLineNo, '<>0');

            case i of
                1:
                    PurchLine.SetFilter("Expected Receipt Date", '%1..%2', 20000101D, EndDate);
                2, 3, 4, 5, 6:
                    PurchLine.SetRange("Expected Receipt Date", StartDate, EndDate);
                7:
                    PurchLine.SetFilter("Expected Receipt Date", '%1..', StartDate);
                8:
                    PurchLine.SetRange("Expected Receipt Date", 0D);
            end;
            if PurchLine.FindSet() then
                repeat
                    UnShipArray[i] += PurchLine.Quantity;
                    UnShipArrayTotal += PurchLine.Quantity;
                until PurchLine.Next() = 0;*/
        end;
    end;

    local procedure CalcStarAndtEndDate(j: Integer)
    begin
        //>> 30-11-21 ZY-LD 001
        case j of
            1:
                EndDate := CalculationDate;
            2:
                begin
                    if CalculationDate <> CalcDate('<CM>', CalculationDate) then begin
                        StartDate := CalculationDate + 1;
                        Evaluate(DateFormula, StrSubstNo('<%1M+CM>', j - 1));
                        EndDate := CalcDate(DateFormula, CalculationDate);
                    end else begin
                        Evaluate(DateFormula, StrSubstNo('<%1M-CM>', j - 1));
                        StartDate := CalcDate(DateFormula, CalculationDate);
                        EndDate := CalcDate('<CM>', StartDate);
                    end;
                end;
            else begin
                Evaluate(DateFormula, StrSubstNo('<%1M-CM>', j - 1));
                StartDate := CalcDate(DateFormula, CalculationDate);
                EndDate := CalcDate('<CM>', StartDate);
            end;
        end;

        /*IF j = 1 THEN
          EndDate := CALCDATE('<CM>',CalculationDate)
        ELSE BEGIN
          EVALUATE(DateFormula,STRSUBSTNO('<%1M-CM>',j - 1));
          StartDate := CALCDATE(DateFormula,CalculationDate);
          EndDate := CALCDATE('<CM>',StartDate);
        END;*/
        //<< 30-11-21 ZY-LD 001

    end;
}
