Report 50032 "Import HR KPI/Bonus"
{
    Caption = 'Import HR KPI/Bonus';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Import Credit Memo Lines';

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
                    field(Year; Year)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Year';
                    }
                    field(Quarter; Quarter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Quarter';
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
        case Date2dmy(Today, 2) of
            1, 2, 3:
                Quarter := Quarter::"Quarter 4";
            4, 5, 6:
                Quarter := Quarter::"Quarter 1";
            7, 8, 9:
                Quarter := Quarter::"Quarter 2";
            10, 11, 12:
                Quarter := Quarter::"Quarter 3";
        end;
        Year := Date2dmy(Today, 3);
        if Date2dmy(Today, 2) <= 3 then
            Year := Year - 1;
    end;

    trigger OnPostReport()
    begin
        Message(Text004);
    end;

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50032, 3);  // 14-10-20 ZY-LD 000

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

                Clear(recHRZyxelKPIEntry);
                recHRZyxelKPIEntry.Init;
                recHRZyxelKPIEntry.Validate(Type, recHRZyxelKPIEntry.Type::KPI);
                if ExcelBuf.Get(Row, 1) then
                    recHRZyxelKPIEntry.Validate("Employee No.", DelChr(ExcelBuf."Cell Value as Text", '>', ' '));
                recHRZyxelKPIEntry.Validate(Year, Year);
                if not recHRZyxelKPIEntry.Get(recHRZyxelKPIEntry.Type, recHRZyxelKPIEntry."Employee No.", recHRZyxelKPIEntry.Year) then begin
                    recHRZyxelKPIEntry.Insert(true);
                    if ExcelBuf.Get(Row, 2) then
                        recHRZyxelKPIEntry.Validate("Currency Code", DelChr(ExcelBuf."Cell Value as Text", '>', ' '));
                end;

                if ExcelBuf.Get(Row, 3) then begin
                    ExcelBuf."Cell Value as Text" := ConvertStr(ExcelBuf."Cell Value as Text", ',', '.');
                    case Quarter of
                        1:
                            Evaluate(recHRZyxelKPIEntry."Quarter 1", DelChr(ExcelBuf."Cell Value as Text", '>', ' '), 9);
                        2:
                            Evaluate(recHRZyxelKPIEntry."Quarter 2", DelChr(ExcelBuf."Cell Value as Text", '>', ' '), 9);
                        3:
                            Evaluate(recHRZyxelKPIEntry."Quarter 3", DelChr(ExcelBuf."Cell Value as Text", '>', ' '), 9);
                        4:
                            Evaluate(recHRZyxelKPIEntry."Quarter 4", DelChr(ExcelBuf."Cell Value as Text", '>', ' '), 9);
                    end;
                    recHRZyxelKPIEntry.Modify(true);
                end;
            end;
        end;
        Window.Close;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recHRZyxelKPIEntry: Record "HR Zyxel KPI Entry";
        SI: Codeunit "Single Instance";
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
        Year: Integer;
        Quarter: Option " ","Quarter 1","Quarter 2","Quarter 3","Quarter 4";
        Text004: label 'The data has been imported.';

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
