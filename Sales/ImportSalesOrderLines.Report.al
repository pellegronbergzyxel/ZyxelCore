Report 62018 "Import Sales Order Lines"
{
    Caption = 'Import Sales Order Lines';
    Description = 'Import Sales Order Lines';
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
                    group("Import To")
                    {
                        Caption = 'Import To';
                        field(DocumentNo; DocumentNo)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Sales Order';
                            Editable = false;
                            Style = Strong;
                            StyleExpr = true;
                        }
                    }
                    group("Import from")
                    {
                        Caption = 'Import from';
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
                                SheetName := ExcelBuf.SelectSheetsName(UploadedFileName);
                            end;
                        }
                        field(SheetContainesHeaderRow; SheetContainesHeaderRow)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contains Headings';
                        }
                        group(option)
                        {
                            Caption = 'Option';
                            field(MergeRows; MergeRows)
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Merge Rows';
                            }
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
        MergeRows := true;
    end;

    trigger OnPreReport()
    var
        SkipFirstRow: Boolean;
        CurrentColumn: Integer;
        CreditMemoNo: Code[20];
        LineNo: Integer;
        ItemNo: Code[20];
        Quantity: Integer;
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
    begin
        SI.UseOfReport(3, 62018, 3);  // 14-10-20 ZY-LD 000

        if UploadedFileName = '' then
            Error(Text001);
        if SheetName = '' then
            Error(Text002);
        if DocumentNo = '' then
            Error(Text005);

        ReadExcelSheet;
        LineNo := GetLastLineNo(DocumentNo);
        if ExcelBuf.FindLast then begin
            ZGT.OpenProgressWindow('', ExcelBuf."Row No.");
            RowCount := ExcelBuf."Row No.";
            startrow := 1;
            if SheetContainesHeaderRow then
                startrow := 2;

            for Row := startrow to RowCount do begin
                ItemNo := '';
                Quantity := 0;
                if ExcelBuf.Get(Row, 1) then ItemNo := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(Row, 2) then Evaluate(Quantity, ExcelBuf."Cell Value as Text");
                ZGT.UpdateProgressWindow(ItemNo, 0, true);

                if (ItemNo <> '') and recitem.get(ItemNo) and (Quantity > 0) then begin
                    recSalesLine.SetRange("Document Type", recSalesLine."Document Type"::Order);
                    recSalesLine.SetRange("Document No.", DocumentNo);
                    recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                    recSalesLine.SetRange("No.", ItemNo);
                    if MergeRows and recSalesLine.FindFirst() then begin
                        recSalesLine.Validate(Quantity, recSalesLine.Quantity + Quantity);
                        recSalesLine.Modify(true);
                    end else begin
                        LineNo := LineNo + 10000;

                        Clear(recSalesLine);
                        recSalesLine.Init;
                        recSalesLine.Validate("Document Type", recSalesLine."document type"::Order);
                        recSalesLine.Validate("Document No.", DocumentNo);
                        recSalesLine.Validate("Line No.", LineNo);
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        recSalesLine.Validate("No.", ItemNo);
                        recSalesLine.Validate(Quantity, Quantity);
                        recSalesLine.Insert(true);
                    end;
                end;
            end;
        end;
        ZGT.CloseProgressWindow();
        Message(Text004);
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        MergeRows: Boolean;
        SheetContainesHeaderRow: Boolean;
        DocumentNo: Code[20];
        RowCount: Integer;
        Row: Integer;
        startrow: Integer;
        FileName: Text[1024];
        SheetName: Text[1024];
        UploadedFileName: Text[1024];
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'You must specify the sheet name to import first.';
        Text003: label 'Loading Sales Order Lines...\\';
        Text004: label 'Sales Order Lines Imported';
        Text005: label 'You must create an order header first.';


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
    begin

        Upload('Upload', 'C:\', 'Excel file(*.xlsx)|*.xlsx', '', UploadedFileName);
        FileName := UploadedFileName;
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

    local procedure GetLastLineNo(DocNo: Code[20]) LineNo: Integer
    var
        recSalesLine: Record "Sales Line";
    begin
        recSalesLine.SetFilter("Document No.", DocNo);
        if recSalesLine.FindLast then LineNo := recSalesLine."Line No." + 10000;
    end;

    procedure SetDocumentNo(No: Code[20])
    begin
        DocumentNo := No;
    end;
}
