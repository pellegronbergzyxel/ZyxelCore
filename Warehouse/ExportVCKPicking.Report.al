Report 62034 "Export VCK Picking"
{
    // 001. 20-08-19 ZY-LD 2019080810000104 - Picking Date is updated when we receive data from VCK, so it's not needed here.
    // 002. 18-05-22 ZY-LD 2022011110000088 - Filtering on Freight Cost Item.

    Caption = 'Export VCK Picking Information';
    Description = 'Export VCK Picking Information';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                    }
                    label(Control1000000005)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = Text19048602;
                        MultiLine = true;
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
    }

    trigger OnInitReport()
    begin
        StartDate := CalcDate('<-CM>', Today);
        EndDate := CalcDate('<+CM>', Today);
    end;

    trigger OnPreReport()
    var
        recItem: Record Item;
        recDeliveryLine: Record "VCK Delivery Document Line";
        RowNo: Integer;
        Qty: Integer;
        PerCarton: Integer;
        PerPallet: Integer;
        Direction: Text[1];
        Precision: Decimal;
        Title: Text[250];
        ait: Codeunit "ZyXEL VCK";
        recDeliveryHeader: Record "VCK Delivery Document Header";
        recSerial: Record "VCK Delivery Document SNos";
        HasSerial: Text[1];
    begin
        SI.UseOfReport(3, 62034, 3);  // 14-10-20 ZY-LD 000

        Direction := '>';
        Precision := 0.1;
        Title := Format(StartDate) + ' to ' + Format(EndDate);
        //ait.UpdatePickingDate;  // 20-08-19 ZY-LD 001
        RowNo := 1;
        ExcelBuf.DeleteAll;
        EnterCell(RowNo, 1, 'Document No.', true, false, '');
        EnterCell(RowNo, 2, 'Line No.', true, false, '');
        EnterCell(RowNo, 3, 'Picking Date', true, false, '');
        EnterCell(RowNo, 4, 'Item No.', true, false, '');
        EnterCell(RowNo, 5, 'Description', true, false, '');
        EnterCell(RowNo, 6, 'Quantity', true, false, '');
        EnterCell(RowNo, 7, 'Quantity Per Carton', true, false, '');
        EnterCell(RowNo, 8, 'Quantity Per Pallet', true, false, '');
        EnterCell(RowNo, 9, 'Cartons', true, false, '');
        EnterCell(RowNo, 10, 'Pallets', true, false, '');
        EnterCell(RowNo, 11, 'Ser. No.', true, false, '');
        recDeliveryHeader.SetRange(PickDate, StartDate, EndDate);
        recDeliveryHeader.SetFilter("Warehouse Status", '=4|=5|=6|=7|=8|=9');
        if recDeliveryHeader.FindFirst then begin
            window.Open('Calculating AIT Picking Information...\@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
            NoOfRecs := recDeliveryHeader.Count;
            CurrRec := 0;
            repeat
                CurrRec += 1;
                if NoOfRecs <= 100 then
                    window.Update(1, (CurrRec / NoOfRecs * 10000) DIV 1)
                else
                    if CurrRec MOD (NoOfRecs DIV 100) = 0 then
                        window.Update(1, (CurrRec / NoOfRecs * 10000) DIV 1);
                recDeliveryLine.SetFilter("Document No.", recDeliveryHeader."No.");
                recDeliveryLine.SetFilter("Warehouse Status", '=4|=5|=6|=7|=8|=9');
                recDeliveryLine.SetRange("Freight Cost Item", false);  // 18-05-22 ZY-LD 002
                if recDeliveryLine.FindFirst then begin
                    repeat
                        recItem.SetFilter("No.", recDeliveryLine."Item No.");
                        if recItem.FindFirst then begin
                            PerPallet := recItem."Cartons Per Pallet";
                            PerCarton := recItem."Number per carton";
                            Qty := recDeliveryLine.Quantity;
                            RowNo := RowNo + 1;
                            EnterCell(RowNo, 1, recDeliveryHeader."No.", false, false, '');
                            EnterCell(RowNo, 2, Format(recDeliveryLine."Line No."), false, false, '');
                            EnterCell(RowNo, 3, Format(recDeliveryLine.PickDate), false, false, '');
                            EnterCell(RowNo, 4, recItem."No.", false, false, '');
                            EnterCell(RowNo, 5, recItem.Description, false, false, '');
                            EnterCell(RowNo, 6, Format(Qty), false, false, '');
                            EnterCell(RowNo, 7, Format(PerCarton), false, false, '');
                            EnterCell(RowNo, 8, Format(PerPallet), false, false, '');
                            if PerCarton > 0 then
                                EnterCell(RowNo, 9, Format(ROUND(Qty / PerCarton, Precision, Direction)), false, false, '');
                            if PerCarton = 0 then
                                EnterCell(RowNo, 9, Format(0), false, false, '');
                            if PerPallet > 0 then begin
                                if PerCarton > 0 then
                                    EnterCell(RowNo, 10, Format(ROUND((Qty / PerCarton) / PerPallet, Precision, Direction)), false, false, '');
                                if PerCarton = 0 then
                                    EnterCell(RowNo, 10, Format(ROUND((Qty) / PerPallet, Precision, Direction)), false, false, '');
                            end;
                            if PerPallet = 0 then begin
                                EnterCell(RowNo, 10, Format(0), false, false, '');
                            end;
                            HasSerial := 'N';
                            recSerial.SetFilter("Delivery Document No.", recDeliveryLine."Document No.");
                            recSerial.SetFilter("Delivery Document Line No.", Format(recDeliveryLine."Line No."));
                            if recSerial.FindFirst then
                                HasSerial := 'Y';
                            EnterCell(RowNo, 11, HasSerial, false, false, '');
                        end;
                    until recDeliveryLine.Next() = 0;
                end;
            until recDeliveryHeader.Next() = 0;
            window.Close;
        end;
        ExcelBuf.CreateBook('', Title);
        ExcelBuf.WriteSheet(Title, CompanyName(), UserId());
        ExcelBuf.CloseBook;
        ExcelBuf.OpenExcel;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        ExcelBuf: Record "Excel Buffer" temporary;
        CurrRec: Integer;
        NoOfRecs: Integer;
        window: Dialog;
        Text19078747: label 'Export VCK Picking Information';
        Text19048602: label 'Please specify the from and to dates. The picking information is calculated on delivery lines that have a delivery date.';
        SI: Codeunit "Single Instance";

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30])
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf.Insert;
    end;
}
