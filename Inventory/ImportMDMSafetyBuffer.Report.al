Report 50046 "Import MDM Safety Buffer"
{
    Caption = 'Import MDM Safety Buffer (Safety Stock Quantity)';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Import Credit Memo Lines';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Import from")
                    {
                        Caption = 'Import from';
                    }
                    field(FileName; FileName)
                    {
                        ApplicationArea = Basic, Suite;
                        AssistEdit = true;
                        Caption = 'Workbook File Name';

                        trigger OnAssistEdit()
                        begin
                            UploadFile;
                        end;
                    }
                    field(SheetName; SheetName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Worksheet Name';

                        trigger OnAssistEdit()
                        begin
                            GetSheetName;
                        end;
                    }
                    field(SheetContainesHeaderRow; SheetContainesHeaderRow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contains Headings';
                    }
                    field(ItemNoColumnLetter; ItemNoColumnLetter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Excel Column for Item No.';
                        ValuesAllowed = 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z';
                    }
                    field(QtyColumnLetter; QtyColumnLetter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Excel Column for MDM Safety Buffer';
                        ValuesAllowed = 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z';
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
        SheetContainesHeaderRow := true;
        ItemNoColumnLetter := 'A';
        QtyColumnLetter := 'H';
    end;

    trigger OnPostReport()
    begin
        Message(Text004, RecordsUpdated);
    end;

    trigger OnPreReport()
    var
        i: Integer;
        MdmSafetyBufferValue: Decimal;
    begin
        SI.UseOfReport(3, 50046, 3);  // 14-10-20 ZY-LD 000

        if (ItemNoColumnLetter = '') or (QtyColumnLetter = '') then
            Error(Text005);

        for i := 1 to 26 do
            if ZGT.GetColumnLetter(i) = ItemNoColumnLetter then
                ItemNoColumnNo := i;
        for i := 1 to 26 do
            if ZGT.GetColumnLetter(i) = QtyColumnLetter then
                QtyColumnNo := i;

        if UploadedFileName = '' then
            Error(Text001);
        if SheetName = '' then
            Error(Text002);

        ReadExcelSheet;
        Window.Open(Text003 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        if ExcelBuf.FindLast then begin
            RowCount := ExcelBuf."Row No.";
            StartRow := 1;
            if SheetContainesHeaderRow then
                StartRow := 2;

            for Row := StartRow to RowCount do begin
                RecNo := RecNo + 1;
                Window.Update(1, ROUND(RecNo / RowCount * 10000, 1));

                if ExcelBuf.Get(Row, ItemNoColumnNo) then
                    if recItem.Get(ExcelBuf."Cell Value as Text") then
                        if ExcelBuf.Get(Row, QtyColumnNo) then begin
                            Evaluate(MdmSafetyBufferValue, ExcelBuf."Cell Value as Text");
                            if MdmSafetyBufferValue <> recItem."Safety Stock Quantity" then begin
                                recItem.Validate("Safety Stock Quantity", MdmSafetyBufferValue);
                                recItem.Modify(true);
                                RecordsUpdated += 1;
                            end;
                        end;
            end;
        end;
        Window.Close;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recItem: Record Item;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        FileName: Text[1024];
        SheetName: Text[1024];
        UploadedFileName: Text[1024];
        RecNo: Integer;
        Window: Dialog;
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'You must specify the sheet name to import first.';
        Text003: label 'Loading Additional Item Lines...\\';
        SheetContainesHeaderRow: Boolean;
        RowCount: Integer;
        Row: Integer;
        StartRow: Integer;
        Text004: label '%1 records has  been updated.';
        ItemNoColumnNo: Integer;
        ItemNoColumnLetter: Code[1];
        QtyColumnNo: Integer;
        QtyColumnLetter: Code[1];
        Text005: label 'Excel column for item and quantity must be entered.';
        RecordsUpdated: Integer;

    local procedure UploadFile()
    begin
        Upload('Upload', 'C:\', 'Excel file(*.xlsx)|*.xlsx', '', UploadedFileName);
        FileName := UploadedFileName;
        GetSheetName;
    end;

    local procedure GetSheetName()
    begin
        SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
    end;

    local procedure ReadExcelSheet()
    begin
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;

        ExcelBuf.OpenBook(FileName, SheetName);
        ExcelBuf.ReadSheet;
    end;
}
