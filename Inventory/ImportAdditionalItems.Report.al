Report 50058 "Import Additional Items"
{
    // 001. 29-09-17 ZY-LD 001 Item no. must not be blank.
    // 002. 20-11-18 ZY-LD 2018111910000071 - Forecast Territory.

    Caption = 'Import Additional Items';
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
                        var
                            ExcelBuf: Record "Excel Buffer";
                        begin
                            SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                        end;
                    }
                    field(SheetContainesHeaderRow; SheetContainesHeaderRow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contains Headings';
                    }
                    field("CountryCode.Code"; CountryCode.Code)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ship-to Country Code';
                        TableRelation = "Country/Region";
                    }
                    field("recForeTerr.Code"; recForeTerr.Code)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Forecast Territory';
                        TableRelation = "Forecast Territory";
                    }
                    field("recCust.""No."""; recCust."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer No.';
                        TableRelation = Customer;
                    }
                    field(DefaultQuantity; DefaultQuantity)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Quantity';
                        DecimalPlaces = 0 : 0;
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
        DefaultQuantity := 1;  // 20-11-18 ZY-LD 002
    end;

    trigger OnPostReport()
    begin
        if not ItemTmp.IsEmpty then begin
            Commit;
            Message(Text009);
            Page.RunModal(Page::"Item List", ItemTmp);
        end;
    end;

    trigger OnPreReport()
    var
        SkipFirstRow: Boolean;
        CurrentColumn: Integer;
        CreditMemoNo: Code[20];
        LineNo: Integer;
        Quantity: Integer;
        UnitValue: Decimal;
        recSalesHeader: Record "Sales Header";
        LastError: Code[20];
        recSalesLine: Record "Sales Line";
        Updated: Integer;
        Created: Integer;
        ReturnReason: Code[10];
        TotalValue: Decimal;
        Reference: Text[30];
        ItemNo: Code[20];
        AddItemNo: Code[20];
        AddItem: Record "Additional Item";
        ItemRec: Record Item;
    begin
        SI.UseOfReport(3, 50058, 3);  // 14-10-20 ZY-LD 000

        if UploadedFileName = '' then
            Error(Text001);
        if SheetName = '' then
            Error(Text002);
        if (CountryCode.Code = '') and (recForeTerr.Code = '') then
            Error(Text010);

        ExcelBuf.LockTable;
        ReadExcelSheet;
        Window.Open(Text003 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        if ExcelBuf.FindLast then begin
            RowCount := ExcelBuf."Row No.";
            startrow := 1;
            if SheetContainesHeaderRow then
                startrow := 2;

            for Row := startrow to RowCount do begin
                RecNo := RecNo + 1;
                Window.Update(1, ROUND(RecNo / RowCount * 10000, 1));

                ItemNo := '';
                AddItemNo := '';

                if ExcelBuf.Get(Row, 1) then ItemNo := DelChr(ExcelBuf."Cell Value as Text", '>', ' ');
                if ExcelBuf.Get(Row, 2) then AddItemNo := DelChr(ExcelBuf."Cell Value as Text", '>', ' ');

                if not AddItem.Get(ItemNo, CountryCode.Code, recForeTerr.Code, recCust."No.", AddItemNo) then
                    if ItemRec.Get(ItemNo) and (not ItemRec.IsEICard) and (not ItemRec."Non ZyXEL License") then begin
                        if not ItemRec.Get(AddItemNo) then
                            if Confirm(Text008, false, AddItemNo) then begin
                                Clear(ItemRec);
                                ItemRec."No." := AddItemNo;
                                ItemRec.Description := AddItemNo;
                                ItemRec.Insert(true);
                            end;

                        Clear(AddItem);
                        AddItem.Validate("Item No.", ItemNo);
                        AddItem."Ship-to Country/Region" := CountryCode.Code;
                        AddItem."Forecast Territory" := recForeTerr.Code;  // 20-11-18 ZY-LD 002
                        AddItem.Quantity := DefaultQuantity;  // 20-11-18 ZY-LD 002
                        AddItem."Customer No." := recCust."No.";  // 20-11-18 ZY-LD 002
                        AddItem."Additional Item No." := AddItemNo;
                        AddItem.Insert(true);
                        Created += 1;
                    end else begin
                        ItemTmp."No." := ItemNo;
                        ItemTmp.Insert;
                    end;
            end;
        end;
        Window.Close;
        ExcelBuf.DeleteAll;
        Message(Text005, Created, Updated);
    end;

    var
        FileName: Text[1024];
        SheetName: Text[1024];
        ExcelBuf: Record "Excel Buffer" temporary;
        UploadedFileName: Text[1024];
        Text006: label 'Import Excel File';
        RecNo: Integer;
        Window: Dialog;
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'You must specify the sheet name to import first.';
        Text003: label 'Loading Additional Item Lines...\\';
        TotalRecNo: Integer;
        SheetContainesHeaderRow: Boolean;
        Text004: label 'A Credit Memo Header does not exist for Credit Memo %1. This will be skipped.';
        Text005: label '%1 lines is created';
        Text007: label 'Item No. must not be blank at line %1.';
        Text008: label 'Do you want to create additional item no. "%1" as an item?';
        Text009: label 'The part numbers in the list is not created as an item.\Additional items is not imported.';
        Text010: label '"Ship-to Country Code" or "Forecast Territory" must be filled.';
        Text19047774: label 'Worksheet Name';
        Text19051956: label 'Contains Headings';
        RowCount: Integer;
        Row: Integer;
        startrow: Integer;
        ProdPostGroup: Code[20];
        CountryCode: Record "Country/Region";
        ItemTmp: Record Item temporary;
        recForeTerr: Record "Forecast Territory";
        DefaultQuantity: Decimal;
        recCust: Record Customer;
        SI: Codeunit "Single Instance";


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
    begin

        Upload('Upload', 'C:\', 'Excel file(*.xlsx)|*.xlsx', '', UploadedFileName);
        FileName := UploadedFileName;
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

    local procedure FormatData(TextToFormat: Text[250]): Text[250]
    var
        FormatInteger: Integer;
        FormatDecimal: Decimal;
        FormatDate: Date;
    begin
        case true of
            Evaluate(FormatInteger, TextToFormat):
                exit(Format(FormatInteger));
            Evaluate(FormatDecimal, TextToFormat):
                exit(Format(FormatDecimal));
            Evaluate(FormatDate, TextToFormat):
                exit(Format(FormatDate));
            else
                exit(TextToFormat);
        end;
    end;
}
