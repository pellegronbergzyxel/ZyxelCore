Report 50042 "Import Pallet No."
{
    Caption = 'Import Pallet No.';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

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
                    field(SerialNoColumn; SerialNoColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Serial No. Column';
                    }
                    field(PalletNoColumn; PalletNoColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pallet No. Column';
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
        SheetContainesHeaderRow := false;
        SerialNoColumn := 'B';
        PalletNoColumn := 'C';
        ImportedRows := 0;
    end;

    trigger OnPostReport()
    begin
        Message(Text004, ImportedRows, RowCount);
    end;

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50042, 3);  // 14-10-20 ZY-LD 000

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

                if ExcelBuf.Get(Row, ZGT.GetColumnNumber(SerialNoColumn)) then begin
                    recDelDocSNo.SetRange("Delivery Document No.", DelDocNo);
                    recDelDocSNo.SetRange("Serial No.", ExcelBuf."Cell Value as Text");
                    if recDelDocSNo.FindFirst then
                        if ExcelBuf.Get(Row, ZGT.GetColumnNumber(PalletNoColumn)) then begin
                            recDelDocSNo.Validate("Pallet No.", ExcelBuf."Cell Value as Text");
                            recDelDocSNo.Modify(true);
                            ImportedRows += 1;

                            if recCust."No." <> recDelDocSNo."Customer No." then begin
                                recCust.Get(recDelDocSNo."Customer No.");
                                recCust."Attach Pallet No. to Serial No" := true;
                                recCust.Modify(true);
                            end;
                        end;
                end;
            end;
        end;
        Window.Close;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recDelDocSNo: Record "VCK Delivery Document SNos";
        recCust: Record Customer;
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
        Text004: label 'For %1 out of %2 rows has the Pallet No. been attached to a Serial No.';
        ImportedRows: Integer;
        SerialNoColumn: Code[1];
        PalletNoColumn: Code[1];
        DelDocNo: Code[20];


    procedure Init(pDeliveryDocumentNo: Code[20])
    begin
        DelDocNo := pDeliveryDocumentNo;
    end;

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
