Report 50013 "Import Price Protection"
{

    Caption = 'Import Price Protection and Rebate';
    ProcessingOnly = true;
    usagecategory = administration;

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
                    field(SheetContainesHeaderRow; SheetContainesHeaderRow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contains Headings';
                        Visible = false;
                        tooltip = 'contains headings in the first two rows of the worksheet';
                    }
                    field(LocatCode; LocatCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Location Code';
                        TableRelation = Location;
                        tooltip = 'Location Code is required if not specified on the sales line or purchase line.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var

            FileMgt: Codeunit "File Management";
            iStream: InStream;
            fromfile: text[250];
            UploadExcelMsg: Label 'Please Choose the Excel file';
            NofileMsg: Label 'Please select file';

        begin
            UploadIntoStream(UploadExcelMsg, '', '', fromfile, iStream);
            if fromfile <> '' then begin
                FileName := copystr(FileMgt.GetFileName(fromfile), 1, 1024);
                SheetName := ExcelBuf.SelectSheetsNameStream(iStream);

            end else
                message(NofileMsg);
            if SheetName <> '' then begin
                ExcelBuf.reset();
                ExcelBuf.DeleteAll();
                ExcelBuf.OpenBookStream(iStream, SheetName);
                ExcelBuf.ReadSheet();
            end;


        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if LocatCode = '' then
            Error(Text009);

        // ReadExcelSheet;
        ImportExcelSheet;

        SI.UseOfReport(3, 50013, 3);
    end;

    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesLineTmp: Record "Sales Line" temporary;
        recPurchLine: Record "Purchase Line";
        recPurchLineTmp: Record "Purchase Line" temporary;
        recReturnReason: Record "Return Reason";
        recItemLedgEntry: Record "Item Ledger Entry";
        ExcelBuf: Record "Excel Buffer" temporary;
        SI: Codeunit "Single Instance";
        EmailAddMgt: Codeunit "E-mail Address Management";
        ZGT: Codeunit "ZyXEL General Tools";
        FileName: Text[1024];
        SheetName: Text[1024];
        RecNo: Integer;
        SheetContainesHeaderRow: Boolean;
        RowCount: Integer;
        Row: Integer;
        startrow: Integer;
        DocNo: Code[20];
        ExpectedTotalAmount: Decimal;
        TotalLineAmount: Decimal;
        DocType: Option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        SalesDocType: Integer;
        LocatCode: Code[10];
        ImportNegativeQty: Boolean;
        Text013: label 'STOCK RETURN';
        ExternalDocumentNo: Text;
        Text003: label 'Loading Credit Memo Lines...\\';
        Text005: label 'Amount to import: %1\Imported Amount: %2';
        Text007: label 'Item No. must not be blank at line %1.';
        Text008: label 'Amount is not correct.\"%1": %2\"Total from Excel": %3.';
        Text009: label 'Location Code must be filled.';
        Text010: label 'You are now allowed to import lines with quantitys less than one.';
        Text011: label 'The customer %1 has not bought the product %2 with in the last year. Please check with the sales team.';
        Text012: label 'You have negative quantities in the file.\Are you sure you want to import them?';


    local procedure ImportExcelSheet()
    var
        SkipFirstRow: Boolean;
        CurrentColumn: Integer;
        LineNo: Integer;
        ItemNo: Code[20];
        Qty: Integer;
        UnitValue: Decimal;
        HideLineCreated: Integer;
        Created: Integer;
        TotalValue: Decimal;
        Reference: Text[30];
    begin
        if ExcelBuf.FindLast then begin
            if DocType = Doctype::"Sales Return Receipt" then begin
                recSalesHead.Get(recSalesHead."document type"::"Return Order", DocNo);
                recSalesHead."External Document No." := Text013;
                recSalesHead.Modify;
            end;

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
                    if not ImportNegativeQty then
                        if Confirm(Text012, false) then
                            ImportNegativeQty := true
                        else
                            Error(Text010);

                case DocType of
                    Doctype::"Sales Credit Memo",
                    Doctype::"Sales Return Receipt":
                        begin
                            recSalesLine.SetRange("Document Type", SalesDocType);
                            recSalesLine.SetRange("Document No.", DocNo);
                            recSalesLine.SetRange("No.", ItemNo);
                            recSalesLine.SetRange("Return Reason Code", recReturnReason.Code);
                            if Reference <> '' then
                                recSalesLine.SetRange("External Document No.", Reference)
                            else
                                recSalesLine.SetRange("External Document No.", ExternalDocumentNo);
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

                            recItemLedgEntry.SetCurrentkey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                            recItemLedgEntry.SetRange("Item No.", ItemNo);
                            recItemLedgEntry.SetRange("Entry Type", recItemLedgEntry."entry type"::Sale);
                            recItemLedgEntry.SetFilter("Posting Date", '%1..', CalcDate('<-1Y>', Today));
                            recItemLedgEntry.SetRange("Source Type", recItemLedgEntry."source type"::Customer);
                            recItemLedgEntry.SetRange("Source No.", recSalesLine."Sell-to Customer No.");
                            if not recItemLedgEntry.FindFirst then
                                EmailAddMgt.CreateEmailWithBodytext('LD', StrSubstNo(Text011, recSalesLine."Sell-to Customer No.", recSalesLine."No."), '');

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
        ExternalDocumentNo := pExternalDocumentNo;
    end;
}
