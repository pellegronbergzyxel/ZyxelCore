Report 50083 "Import Serial No."
{
    Caption = 'Import Serial No.';
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
                    field(DeleteBeforeImport; DeleteBeforeImport)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Delete Existing Serial No.';
                    }
                    group("Sheet Column")
                    {
                        Caption = 'Sheet Column';
                        field(DelDocColumn; DelDocColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Delivery Document No.';
                        }
                        field(DelDocLineColumn; DelDocLineColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Delivery Document Line No.';
                        }
                        field(SalesOrderColumn; SalesOrderColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Sales Order No.';
                        }
                        field(SalesOrderLineColumn; SalesOrderLineColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Sales Order Line No.';
                        }
                        field(CustomerNoColumn; CustomerNoColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer No.';
                        }
                        field(CustomerOrderNoColumn; CustomerOrderNoColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer Order No.';
                        }
                        field(ItemNoColumn; ItemNoColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Item No.';
                        }
                        field(SerialNoColumn; SerialNoColumn)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Serial No.';
                        }
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
        DelDocColumn := 'A';
        DelDocLineColumn := 'B';
        SalesOrderColumn := 'C';
        SalesOrderLineColumn := 'D';
        CustomerNoColumn := 'E';
        CustomerOrderNoColumn := 'F';
        ItemNoColumn := 'G';
        SerialNoColumn := 'H';
        ImportedRows := 0;
    end;

    trigger OnPostReport()
    begin
        Message(Text004, ImportedRows, RowCount);
    end;

    trigger OnPreReport()
    var
        ImpLineNo: Integer;
    begin
        SI.UseOfReport(3, 50083, 3);  // 14-10-20 ZY-LD 000

        if UploadedFileName = '' then
            Error(Text001);
        if SheetName = '' then
            Error(Text002);

        ReadExcelSheet;
        Window.Open(Text003 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        if DeleteBeforeImport then begin
            if ExcelBuf.FindLast then begin
                RowCount := ExcelBuf."Row No.";
                StartRow := 1;
                if SheetContainesHeaderRow then
                    StartRow := 2;

                for Row := StartRow to RowCount do begin
                    RecNo := RecNo + 1;
                    Window.Update(1, ROUND(RecNo / RowCount * 10000, 1));

                    Clear(recDelDocSNo);
                    recDelDocSNo.Init;
                    ExcelBuf.Get(Row, ZGT.GetColumnNumber(DelDocColumn));
                    recDelDocSNo.SetRange("Delivery Document No.", ExcelBuf."Cell Value as Text");
                    ExcelBuf.Get(Row, ZGT.GetColumnNumber(DelDocLineColumn));
                    Evaluate(ImpLineNo, ExcelBuf."Cell Value as Text");
                    recDelDocSNo.SetRange("Delivery Document Line No.", ImpLineNo);
                    if recDelDocSNo.FindSet(true) then begin
                        if not Confirm(Text005, false, recDelDocSNo.Count, recDelDocSNo."Delivery Document No.", recDelDocSNo."Delivery Document Line No.") then
                            Error('');
                        if Confirm(Text006) then
                            recDelDocSNo.DeleteAll(true)
                        else
                            Error('');
                    end;
                end
            end;
        end;

        if ExcelBuf.FindLast then begin
            RowCount := ExcelBuf."Row No.";
            StartRow := 1;
            if SheetContainesHeaderRow then
                StartRow := 2;

            for Row := StartRow to RowCount do begin
                RecNo := RecNo + 1;
                Window.Update(1, ROUND(RecNo / RowCount * 10000, 1));

                Clear(recDelDocSNo);
                recDelDocSNo.Init;
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(DelDocColumn));
                recDelDocSNo.Validate("Delivery Document No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(DelDocLineColumn));
                Evaluate(recDelDocSNo."Delivery Document Line No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(SalesOrderColumn));
                recDelDocSNo.Validate("Sales Order No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(SalesOrderLineColumn));
                Evaluate(recDelDocSNo."Sales Order Line No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(CustomerNoColumn));
                recDelDocSNo.Validate("Customer No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(CustomerOrderNoColumn));
                recDelDocSNo.Validate("Customer Order No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(ItemNoColumn));
                recDelDocSNo.Validate("Item No.", ExcelBuf."Cell Value as Text");
                ExcelBuf.Get(Row, ZGT.GetColumnNumber(SerialNoColumn));
                recDelDocSNo.Validate("Serial No.", ExcelBuf."Cell Value as Text");
                recDelDocSNo.Insert(true);
                ImportedRows += 1;
            end
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
        Text004: label '%1 rows has been inserted into Serial No.';
        ImportedRows: Integer;
        DelDocColumn: Code[1];
        DelDocLineColumn: Code[1];
        SalesOrderColumn: Code[1];
        SalesOrderLineColumn: Code[1];
        CustomerNoColumn: Code[1];
        CustomerOrderNoColumn: Code[1];
        ItemNoColumn: Code[1];
        SerialNoColumn: Code[1];
        DelDocNo: Code[20];
        DeleteBeforeImport: Boolean;
        Text005: label 'Do you want to delete %1 serial no. from "%2" "%3"?';
        Text006: label 'Are you sure?';


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
