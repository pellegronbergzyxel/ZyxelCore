Report 50084 "Import Sales Line"
{
    Caption = 'Import Sales Line';
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
                    field(ItemNoColumn; ItemNoColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item No. Column';
                    }
                    field(QuantityColumn; QuantityColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Quantity Column';
                    }
                    field(VatPostGrpColumn; VatPostGrpColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'VAT Bus. Post Grp. Column';
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
        ItemNoColumn := 'A';
        QuantityColumn := 'B';
        VatPostGrpColumn := 'C';
        UnitCostColumn := 'D';
        ImportedRows := 0;
    end;

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50084, 3);  // 14-10-20 ZY-LD 000

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

                Clear(recPurchLine);
                recPurchLine.Init;
                recPurchLine.Validate("Document Type", DocumentType);
                recPurchLine.Validate("Document No.", DocumentNo);
                recPurchLine.Validate("Line No.", RecNo * 10000);
                recPurchLine.Validate(Type, recPurchLine.Type::Item);

                ExcelBuf.Get(Row, ZGT.GetColumnNumber(ItemNoColumn));
                recPurchLine.Validate("No.", ExcelBuf."Cell Value as Text");

                ExcelBuf.Get(Row, ZGT.GetColumnNumber(QuantityColumn));
                Evaluate(recPurchLine.Quantity, ExcelBuf."Cell Value as Text");
                recPurchLine.Validate(Quantity);

                if ExcelBuf.Get(Row, ZGT.GetColumnNumber(VatPostGrpColumn)) then
                    recPurchLine.Validate("VAT Bus. Posting Group", ExcelBuf."Cell Value as Text");

                ExcelBuf.Get(Row, ZGT.GetColumnNumber(UnitCostColumn));
                Evaluate(recPurchLine."Direct Unit Cost", ExcelBuf."Cell Value as Text");
                recPurchLine.Validate("Direct Unit Cost");
                recPurchLine.Insert(true);


                /*CLEAR(recSalesLine);
                recSalesLine.INIT;
                recSalesLine.VALIDATE("Document Type",DocumentType);
                recSalesLine.VALIDATE("Document No.",DocumentNo);
                recSalesLine.VALIDATE("Line No.",RecNo * 10000);
                recSalesLine.VALIDATE(Type,recSalesLine.Type::Item);

                ExcelBuf.GET(Row,ZGT.GetColumnNumber(ItemNoColumn));
                recSalesLine.VALIDATE("No.",ExcelBuf."Cell Value as Text");

                ExcelBuf.GET(Row,ZGT.GetColumnNumber(QuantityColumn));
                EVALUATE(recSalesLine.Quantity,ExcelBuf."Cell Value as Text");
                recSalesLine.VALIDATE(Quantity);

                IF ExcelBuf.GET(Row,ZGT.GetColumnNumber(VatPostGrpColumn)) THEN
                  recSalesLine.VALIDATE("VAT Bus. Posting Group",ExcelBuf."Cell Value as Text");

                recSalesLine.VALIDATE("Unit Price",ROUND(recSalesLine."Unit Cost"));
                recSalesLine.INSERT(TRUE);*/
            end;
        end;
        Window.Close;

    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recSalesLine: Record "Sales Line";
        recPurchLine: Record "Purchase Line";
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
        ItemNoColumn: Code[1];
        QuantityColumn: Code[1];
        VatPostGrpColumn: Code[1];
        UnitCostColumn: Code[1];
        DocumentType: Enum "Sales Line Type";
        DocumentNo: Code[20];


    procedure Init(NewDocumentType: Enum "Sales Line Type"; NewDocumentNo: Code[20])
    begin
        DocumentType := NewDocumentType;
        DocumentNo := NewDocumentNo;
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
