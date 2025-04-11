Report 50013 "Import Price Protection"
{
    // 001. 14-02-19 ZY-LD 2019021410000087 - It has happend that a customer has claimed items that has never been bought.
    // 002. 20-05-19 ZY-LD 2019052010000079 - Allow import of negative quantities.
    // 003. 27-03-20 ZY-LD P0388 - Update sales header.
    // 004. 22-04-22 ZY-LD 2022042110000081 - If Reference was blank, it didn´t merge the lines.
    // 005. 03-05-24 ZY-LD #6772668 - Moved the update of posting groups to Codeunit 50067. Sometimes the credit memos is created manually.


    Caption = 'Import Price Protection and Rebate';
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
                        Visible = false;
                    }
                    field(LocatCode; LocatCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Location Code';
                        TableRelation = Location;
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

    trigger OnPreReport()
    begin
        if UploadedFileName = '' then
            Error(Text001);

        if SheetName = '' then
            Error(Text002);

        if LocatCode = '' then
            Error(Text009);

        ReadExcelSheet;
        ImportExcelSheet;

        SI.UseOfReport(3, 50013, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesLineTmp: Record "Sales Line" temporary;
        recPurchLine: Record "Purchase Line";
        recPurchLineTmp: Record "Purchase Line" temporary;
        recReturnReason: Record "Return Reason";
        recItemLedgEntry: Record "Item Ledger Entry";
        FileName: Text[1024];
        SheetName: Text[1024];
        ExcelBuf: Record "Excel Buffer" temporary;
        UploadedFileName: Text[1024];
        Text006: label 'Import Excel File';
        RecNo: Integer;
        Window: Dialog;
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'You must specify the sheet name to import first.';
        Text003: label 'Loading Credit Memo Lines...\\';
        TotalRecNo: Integer;
        SheetContainesHeaderRow: Boolean;
        Text004: label 'A Credit Memo Header does not exist for Credit Memo %1. This will be skipped.';
        Text005: label 'Amount to import: %1\Imported Amount: %2';
        Text007: label 'Item No. must not be blank at line %1.';
        Text008: label 'Amount is not correct.\"%1": %2\"Total from Excel": %3.';
        Text009: label 'Location Code must be filled.';
        Text010: label 'You are now allowed to import lines with quantitys less than one.';
        Text011: label 'The customer %1 has not bought the product %2 with in the last year. Please check with the sales team.';
        Text012: label 'You have negative quantities in the file.\Are you sure you want to import them?';
        Text19047774: label 'Worksheet Name';
        Text19051956: label 'Contains Headings';
        RowCount: Integer;
        Row: Integer;
        startrow: Integer;
        ProdPostGroup: Code[20];
        DocNo: Code[20];
        ZGT: Codeunit "ZyXEL General Tools";
        ExpectedTotalAmount: Decimal;
        TotalLineAmount: Decimal;
        DocType: Option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        SalesDocType: Integer;
        LocatCode: Code[10];
        EmailAddMgt: Codeunit "E-mail Address Management";
        ImportNegativeQty: Boolean;
        Text013: label 'STOCK RETURN';
        SI: Codeunit "Single Instance";
        ExternalDocumentNo: Text;


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

    local procedure ImportExcelSheet()
    var
        SkipFirstRow: Boolean;
        CurrentColumn: Integer;
        LineNo: Integer;
        ItemNo: Code[20];
        Qty: Integer;
        UnitValue: Decimal;
        xrecSalesHeader: Record "Sales Header";
        LastError: Code[20];
        HideLineCreated: Integer;
        Created: Integer;
        TotalValue: Decimal;
        Reference: Text[30];
    begin
        if ExcelBuf.FindLast then begin
            //>> 27-03-20 ZY-LD 003
            if DocType = Doctype::"Sales Return Receipt" then begin
                recSalesHead.Get(recSalesHead."document type"::"Return Order", DocNo);
                recSalesHead."External Document No." := Text013;
                recSalesHead.Modify;
            end;
            //<< 27-03-20 ZY-LD 003

            RowCount := ExcelBuf."Row No.";
            ZGT.OpenProgressWindow('', RowCount);
            startrow := 1;
            if SheetContainesHeaderRow then startrow := 3;

            for Row := startrow to RowCount do begin
                ZGT.UpdateProgressWindow(Text003, 0, true);

                LineNo += 10000;
                ItemNo := '';
                Qty := 0;
                UnitValue := 0;
                TotalValue := 0;

                if ExcelBuf.Get(Row, 1) then ItemNo := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(Row, 2) then recReturnReason.Get(ExcelBuf."Cell Value as Text");
                if ExcelBuf.Get(Row, 3) then Reference := CopyStr(ExcelBuf."Cell Value as Text", 1, MaxStrLen(recSalesLine."External Document No."));
                if ExcelBuf.Get(Row, 4) then Evaluate(Qty, ExcelBuf."Cell Value as Text");
                if ExcelBuf.Get(Row, 5) then Evaluate(UnitValue, ExcelBuf."Cell Value as Text");
                if ExcelBuf.Get(Row, 6) then Evaluate(TotalValue, ExcelBuf."Cell Value as Text");

                if ItemNo = '' then
                    Error(Text007, RecNo);

                if Qty < 1 then
                    //>> 20-05-19 ZY-LD 002
                    if not ImportNegativeQty then
                        if Confirm(Text012, false) then
                            ImportNegativeQty := true
                        else  //<< 20-05-19 ZY-LD 002
                            Error(Text010);

                case DocType of
                    Doctype::"Sales Credit Memo",
                    Doctype::"Sales Return Receipt":
                        begin
                            recSalesLine.SetRange("Document Type", SalesDocType);
                            recSalesLine.SetRange("Document No.", DocNo);
                            recSalesLine.SetRange("No.", ItemNo);
                            recSalesLine.SetRange("Return Reason Code", recReturnReason.Code);
                            //>> 22-04-22 ZY-LD 004
                            //recSalesLine.SETRANGE("External Document No.",Reference)
                            if Reference <> '' then
                                recSalesLine.SetRange("External Document No.", Reference)
                            else
                                recSalesLine.SetRange("External Document No.", ExternalDocumentNo);
                            //<< 22-04-22 ZY-LD 004
                            recSalesLine.SetRange("Unit Price", UnitValue);
                            if recSalesLine.FindFirst then begin
                                recSalesLine.Validate(Quantity, recSalesLine.Quantity + Qty);
                                recSalesLine.Validate("Unit Price", UnitValue);
                                recSalesLine.Modify;
                                TotalLineAmount := TotalLineAmount + (Qty * UnitValue);

                                recSalesLineTmp.Get(recSalesLine."Document Type", recSalesLine."Document No.", recSalesLine."Line No.");
                                recSalesLineTmp.Validate(Quantity, recSalesLineTmp.Quantity - Qty);
                                recSalesLineTmp.Validate("Unit Price", 0);
                                recSalesLineTmp.Validate("Line Discount %", 0);
                                recSalesLineTmp.Modify;
                            end else begin
                                Clear(recSalesLine);
                                recSalesLine.SetHideValidationDialog(true);
                                recSalesLine.Init;
                                recSalesLine.Validate("Document Type", SalesDocType);
                                recSalesLine.Validate("Document No.", DocNo);
                                recSalesLine.Validate(Type, recSalesLine.Type::Item);
                                recSalesLine.Validate("Line No.", LineNo);
                                recSalesLine.Validate("No.", ItemNo);
                                //>> 03-05-24 ZY-LD 005
                                // if recReturnReason."Gen. Bus. Posting Group" <> '' then
                                //     recSalesLine.Validate("Gen. Bus. Posting Group", recReturnReason."Gen. Bus. Posting Group");
                                // if recReturnReason."Gen. Prod. Posting Group" <> '' then
                                //     recSalesLine.Validate("Gen. Prod. Posting Group", recReturnReason."Gen. Prod. Posting Group");
                                //<< 03-05-24 ZY-LD 005
                                recSalesLine.Validate("Return Reason Code", recReturnReason.Code);
                                if recSalesLine."Location Code" = '' then
                                    recSalesLine.Validate("Location Code", LocatCode);
                                recSalesLineTmp := recSalesLine;
                                recSalesLine.Validate(Quantity, Qty);
                                recSalesLine.Validate("Unit Price", UnitValue);
                                if (DocType = Doctype::"Sales Credit Memo") and (Reference <> '') then
                                    recSalesLine."External Document No." := Reference;
                                recSalesLine.Insert;
                                TotalLineAmount := TotalLineAmount + recSalesLine."Line Amount" + recSalesLine."Line Discount Amount";

                                recSalesLineTmp.Validate(Quantity, -Qty);
                                recSalesLineTmp.Validate("Unit Price", 0);
                                recSalesLineTmp.Validate("Line Discount %", 0);
                                recSalesLineTmp."Hide Line" := true;
                                if recReturnReason."Reverse Quantity" then
                                    recSalesLineTmp.Insert;
                            end;

                            //>> 14-02-19 ZY-LD 001
                            recItemLedgEntry.SetCurrentkey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                            recItemLedgEntry.SetRange("Item No.", ItemNo);
                            recItemLedgEntry.SetRange("Entry Type", recItemLedgEntry."entry type"::Sale);
                            //recItemLedgEntry.SETRANGE("Location Code",LocatCode);  // Both items and EiCards are on the same cr. memo.
                            recItemLedgEntry.SetFilter("Posting Date", '%1..', CalcDate('<-1Y>', Today));
                            recItemLedgEntry.SetRange("Source Type", recItemLedgEntry."source type"::Customer);
                            recItemLedgEntry.SetRange("Source No.", recSalesLine."Sell-to Customer No.");
                            if not recItemLedgEntry.FindFirst then
                                EmailAddMgt.CreateEmailWithBodytext('LD', StrSubstNo(Text011, recSalesLine."Sell-to Customer No.", recSalesLine."No."), '');
                            //<< 14-02-19 ZY-LD 001

                            Created += 1;
                        end;
                    Doctype::"Purchase Credit Memo":
                        begin
                            Clear(recPurchLine);
                            recPurchLine.Init;
                            recPurchLine.Validate("Document Type", recPurchLine."document type"::"Credit Memo");
                            recPurchLine.Validate("Document No.", DocNo);
                            recPurchLine.Validate(Type, recPurchLine.Type::Item);
                            recPurchLine.Validate("Line No.", LineNo);
                            recPurchLine.Validate("No.", ItemNo);
                            if recReturnReason."Gen. Prod. Posting Group" <> '' then
                                recPurchLine.Validate("Gen. Prod. Posting Group", recReturnReason."Gen. Prod. Posting Group");
                            recPurchLine.Validate("Return Reason Code", recReturnReason.Code);
                            if recPurchLine."Location Code" = '' then
                                recPurchLine.Validate("Location Code", LocatCode);
                            recPurchLineTmp := recPurchLine;
                            recPurchLine.Validate(Quantity, Qty);
                            recPurchLine.Validate("Direct Unit Cost", UnitValue);
                            if Reference <> '' then
                                recPurchLine."External Document No." := Reference;
                            recPurchLine.Insert;
                            TotalLineAmount := TotalLineAmount + recPurchLine."Line Amount" + recPurchLine."Line Discount Amount";

                            recPurchLineTmp.Validate(Quantity, -Qty);
                            recPurchLineTmp.Validate("Direct Unit Cost", 0);
                            recPurchLineTmp.Validate("Line Discount %", 0);
                            recPurchLineTmp."Hide Line" := true;
                            if recReturnReason."Reverse Quantity" then
                                recPurchLineTmp.Insert;

                            Created += 1;
                        end;

                end;
            end;
        end;

        case DocType of
            Doctype::"Sales Credit Memo",
            Doctype::"Sales Return Receipt":
                begin
                    if recSalesLineTmp.FindSet then
                        repeat
                            LineNo += 10000;
                            recSalesLine := recSalesLineTmp;
                            recSalesLine.Validate("Line No.", LineNo);
                            recSalesLine.Insert;
                        until recSalesLineTmp.Next() = 0;

                    ExcelBuf.Get(1, 6);
                    Evaluate(ExpectedTotalAmount, ExcelBuf."Cell Value as Text");
                    if TotalLineAmount <> ExpectedTotalAmount then
                        Message(Text008, recSalesLine."Document Type", ROUND(TotalLineAmount), ROUND(ExpectedTotalAmount))
                    else
                        Message(Text005, ROUND(ExpectedTotalAmount), ROUND(TotalLineAmount));
                end;
            Doctype::"Purchase Credit Memo":
                if recPurchLineTmp.FindSet then begin
                    repeat
                        LineNo += 10000;
                        recPurchLine := recPurchLineTmp;
                        recPurchLine.Validate("Line No.", LineNo);
                        recPurchLine.Insert;
                        HideLineCreated += 1;
                    until recPurchLineTmp.Next() = 0;

                    ExcelBuf.Get(1, 6);
                    Evaluate(ExpectedTotalAmount, ExcelBuf."Cell Value as Text");
                    if TotalLineAmount <> ExpectedTotalAmount then
                        Message(Text008, recPurchLine."Document Type", TotalLineAmount, ExpectedTotalAmount)
                    else
                        Message(Text005, Format(ExpectedTotalAmount), Format(TotalLineAmount));
                end;
        end;

        ZGT.CloseProgressWindow;
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


    procedure ReportInit(pDocumentType: Option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly"; pDocumentNo: Code[20]; pLocation: Code[10]; pExternalDocumentNo: Text)
    begin
        DocType := pDocumentType;
        case pDocumentType of
            Pdocumenttype::"Sales Credit Memo":
                SalesDocType := 3;
            Pdocumenttype::"Sales Return Receipt":
                SalesDocType := 5;
        end;
        DocNo := pDocumentNo;
        LocatCode := pLocation;
        SheetContainesHeaderRow := true;
        ExternalDocumentNo := pExternalDocumentNo;  // 22-04-22 ZY-LD 004
    end;
}
