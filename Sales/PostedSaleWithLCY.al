
report 50120 "Posted Sales Export LCY Excel"
{ //23-04-2026 BK #568056
    Caption = 'Posted Sales Export LCY (Excel)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesInvHdr; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date", "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Currency Code", "Due Date";
            // Tilføj flere standardfelter her hvis du vil have dem som "fri filter"

            trigger OnPreDataItem()
            begin
                // Intet – Excel init sker i OnPreReport()
            end;

            trigger OnAfterGetRecord()
            begin
                AddPostedSalesRow(SalesInvHdr, DocType::Invoice);
            end;
        }

        dataitem(SalesCrMemoHdr; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "Posting Date", "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Currency Code";
            // "Due Date" findes ikke altid på credit memo header i alle versioner – derfor ikke sat som default filter

            trigger OnAfterGetRecord()
            begin
                AddPostedSalesRow(SalesCrMemoHdr, DocType::"Credit Memo");
            end;
        }
    }

    trigger OnPreReport()
    begin
        InitExcel();
        AddExcelHeader();
    end;

    trigger OnPostReport()
    begin
        FinishExcel();
    end;

    var
        tempExcelBuf: Record "Excel Buffer" temporary;
        OpenAfterExport: Boolean;

        // Bruges til at sende dokumenttype ind (for både invoice og credit memo)
        DocType: Enum "Gen. Journal Document Type";
        CustLedgEntry: Record "Cust. Ledger Entry";

        // Labels / formats
        SheetNameLbl: Label 'Sales';
        DateFmtTxt: Label 'dd-mm-yyyy';
        AmountFmtTxt: Label '#,##0.00';

    local procedure InitExcel()
    var
        FileName: Text;
    begin
        tempExcelBuf.Reset();
        tempExcelBuf.DeleteAll();

        FileName := StrSubstNo('SalesReport_%1', Format(Today(), 0, 9)); // YYYY-MM-DD

        tempExcelBuf.CreateNewBook(FileName);
        // Vi skriver sheet i FinishExcel()
    end;

    local procedure AddExcelHeader()
    begin
        tempExcelBuf.NewRow();

        AddColText('Sales Order Type', true);
        AddColText('Document Type', true);
        AddColText('Posting Date', true);
        AddColText('Document No.', true);
        AddColText('eCommerce No.', true);
        AddColText('Customer No.', true);
        AddColText('Customer Name', true);
        AddColText('Currency Code', true);

        AddColText('Original Amount', true);
        AddColText('Original VAT Amount', true);
        AddColText('Original Amount Including VAT', true);

        AddColText('Orginal LCY Amount', true);
        AddColText('Orginal LCY VAT Amount', true);
        AddColText('Orginal LCY Amount Including VAT', true);


        AddColText('Adjusted LCY Amount', true);
        AddColText('Remaining Amount', true);
        AddColText('Due Date', true);
    end;

    local procedure AddPostedSalesRow(AnyHeader: Variant; DocumentType: Enum "Gen. Journal Document Type")
    var
        RecRef: RecordRef;
        PostingDate: Date;
        DocNo: Code[20];
        CustNo: Code[20];
        CustName: Text[100];
        CurrencyCode: Code[10];
        DueDate: Date;

        OrigAmount: Decimal;
        OrigAmountInclVAT: Decimal;
        OrigVAT: Decimal;

        LCYAmount: Decimal;
        LCYAmountInclVAT: Decimal;
        LCYVAT: Decimal;
        AdjustedLCYAmount: Decimal;
        RemainingAmount: Decimal;

        SalesOrderTypeTxt: Text;
        EComNoTxt: Text;
        DocTypeTxt: Text;
    begin
        RecRef.GetTable(AnyHeader);

        // Standardfelter – findes på både 112 og 114
        PostingDate := GetDateField(RecRef, 'Posting Date');
        DocNo := GetCodeField(RecRef, 'No.');
        CustNo := GetCodeField(RecRef, 'Sell-to Customer No.');
        CustName := GetTextField(RecRef, 'Sell-to Customer Name');
        CurrencyCode := GetCodeField(RecRef, 'Currency Code');

        // Due Date findes sikkert på invoice; på credit memo kan den mangle afhængigt af version/opsætning
        DueDate := GetDateField(RecRef, 'Due Date');

        // Custom / optional fields
        SalesOrderTypeTxt := GetAnyFieldAsText(RecRef, 'Sales Order Type');
        EComNoTxt := GetAnyFieldAsText(RecRef, 'eCommerce Order.');

        // Fallback hvis eCommerce No. ikke findes/er tomt
        if EComNoTxt = '' then
            EComNoTxt := GetAnyFieldAsText(RecRef, 'External Document No.');

        // Document type tekst
        case DocumentType of
            DocumentType::Invoice:
                DocTypeTxt := 'Invoice';
            DocumentType::"Credit Memo":
                DocTypeTxt := 'Credit Memo';
            else
                DocTypeTxt := Format(DocumentType);
        end;

        GetDocumentAmounts(DocumentType, DocNo, OrigAmount, OrigAmountInclVAT, OrigVAT);
        // LCY + Remaining via Detailed Cust. Ledg. Entry -> Cust. Ledger Entry
        GetLedgerAmounts(DocumentType, DocNo, PostingDate, LCYAmount, LCYAmountInclVAT, LCYVAT, RemainingAmount, AdjustedLCYAmount, DueDate);

        // Skriv række til Excel
        tempExcelBuf.NewRow();

        AddColText(SalesOrderTypeTxt, false);
        AddColText(DocTypeTxt, false);
        AddColDate(PostingDate);
        AddColText(DocNo, false);
        AddColText(EComNoTxt, false);
        AddColText(CustNo, false);
        AddColText(CustName, false);
        AddColText(CurrencyCode, false);

        AddColAmount(OrigAmount);
        AddColAmount(OrigVAT);
        AddColAmount(OrigAmountInclVAT);


        AddColAmount(LCYAmount);
        AddColAmount(LCYVAT);
        AddColAmount(LCYAmountInclVAT);

        AddColAmount(AdjustedLCYAmount);
        AddColAmount(RemainingAmount);
        AddColDate(DueDate);
    end;

    local procedure GetLedgerAmounts(DocumentType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; PostingDate: Date;
                                     var LCYAmount: Decimal; var LCYAmountInclVAT: Decimal; var LCYVAT: Decimal;
                                     var RemainingAmount: Decimal; var AdjustedLCYAmount: Decimal; var DueDate: Date)
    var
        Found: Boolean;
    begin
        Clear(LCYAmount);
        Clear(LCYAmountInclVAT);
        Clear(LCYVAT);
        Clear(RemainingAmount);
        Clear(AdjustedLCYAmount);

        CustLedgEntry.Reset();
        CustLedgEntry.SetCurrentKey("Document Type", "Document No.");
        CustLedgEntry.SetRange("Document Type", DocumentType);
        CustLedgEntry.SetRange("Document No.", DocNo);
        CustLedgEntry.SetRange("Posting Date", PostingDate);

        if CustLedgEntry.FindFirst() then begin
            CustLedgEntry.CalcFields("Original Amt. (LCY)", "Remaining Amount", "Amount (LCY)");
            LCYAmountInclVAT := CustLedgEntry."Original Amt. (LCY)";
            LCYAmount := CustLedgEntry."Sales (LCY)";
            LCYVAT := LCYAmountInclVAT - LCYAmount;
            RemainingAmount := CustLedgEntry."Remaining Amount";
            AdjustedLCYAmount := CustLedgEntry."Amount (LCY)";

            if DueDate = 0D then
                DueDate := CustLedgEntry."Due Date";
        end;
    end;

    local procedure GetDocumentAmounts(DocumentType: Enum "Gen. Journal Document Type"; DocNo: Code[20];
                                     var OrigAmount: Decimal; var OrigAmountInclVAT: Decimal; var OrigVAT: Decimal)
    var
        PostedSalesLine: Record "Sales Invoice Line";
        postedcreditmemoline: Record "Sales Cr.Memo Line";

    begin
        Clear(OrigAmount);
        Clear(OrigAmountInclVAT);
        Clear(OrigVAT);

        if DocumentType = DocumentType::Invoice then begin
            PostedSalesLine.Reset();
            PostedSalesLine.SetCurrentKey(postedSalesLine."Document No.");
            PostedSalesLine.SetRange(postedSalesLine."Document No.", DocNo);

            if PostedSalesLine.FindFirst() then
                repeat
                    OrigAmount += PostedSalesLine."Line Amount";
                    OrigAmountInclVAT += PostedSalesLine."Amount Including VAT";
                    OrigVAT += (OrigAmountInclVAT - OrigAmount);
                until PostedSalesLine.Next() = 0;

        end else if DocumentType = DocumentType::"Credit Memo" then begin
            postedcreditmemoline.Reset();
            postedcreditmemoline.SetCurrentKey(postedcreditmemoline."Document No.");
            postedcreditmemoline.SetRange(postedcreditmemoline."Document No.", DocNo);

            if postedcreditmemoline.FindFirst() then
                repeat
                    OrigAmount += postedcreditmemoline."Line Amount";
                    OrigAmountInclVAT += postedcreditmemoline."Amount Including VAT";
                    OrigVAT += OrigAmountInclVAT - OrigAmount;
                until postedcreditmemoline.Next() = 0;

            if OrigVAT <> 0 then
                OrigVAT := -1 * (OrigAmountInclVAT - OrigAmount);

            if OrigAmount <> 0 then
                OrigAmount := -1 * OrigAmount;

            if OrigAmountInclVAT <> 0 then
                OrigAmountInclVAT := -1 * OrigAmountInclVAT;
        end;


    end;

    local procedure FinishExcel()
    begin
        tempExcelBuf.WriteSheet(SheetNameLbl, CompanyName(), UserId());
        tempExcelBuf.CloseBook();
        tempExcelBuf.OpenExcel();
    end;

    // --- Excel helpers ---
    local procedure AddColText(Value: Text; Bold: Boolean)
    begin
        tempExcelBuf.AddColumn(Value, false, '', Bold, false, false, '', tempExcelBuf."Cell Type"::Text);
    end;

    local procedure AddColDate(Value: Date)
    begin
        if Value = 0D then
            tempExcelBuf.AddColumn('', false, '', false, false, false, DateFmtTxt, tempExcelBuf."Cell Type"::Date)
        else
            tempExcelBuf.AddColumn(Value, false, '', false, false, false, DateFmtTxt, tempExcelBuf."Cell Type"::Date);
    end;

    local procedure AddColAmount(Value: Decimal)
    begin
        tempExcelBuf.AddColumn(Value, false, '', false, false, false, AmountFmtTxt, tempExcelBuf."Cell Type"::Number);
    end;

    // --- RecordRef field readers (robust mod custom fields) ---
    local procedure GetAnyFieldAsText(RecRef: RecordRef; FieldName: Text): Text
    var
        FRef: FieldRef;
        i: Integer;
    begin
        for i := 1 to RecRef.FieldCount() do begin
            FRef := RecRef.FieldIndex(i);
            if UpperCase(FRef.Name()) = UpperCase(FieldName) then
                exit(Format(FRef.Value()));
        end;
        exit('');
    end;

    local procedure GetTextField(RecRef: RecordRef; FieldName: Text): Text[100]
    begin
        exit(CopyStr(GetAnyFieldAsText(RecRef, FieldName), 1, 100));
    end;

    local procedure GetCodeField(RecRef: RecordRef; FieldName: Text): Code[20]
    begin
        exit(CopyStr(GetAnyFieldAsText(RecRef, FieldName), 1, 20));
    end;

    local procedure GetDateField(RecRef: RecordRef; FieldName: Text): Date
    var
        Txt: Text;
        D: Date;
    begin
        Txt := GetAnyFieldAsText(RecRef, FieldName);
        if Txt = '' then
            exit(0D);

        // Format() kan være localespecifik; men i praksis kommer Value() som Date type.
        // Derfor forsøger vi direkte cast via Evaluate.
        if Evaluate(D, Txt) then
            exit(D);

        exit(0D);
    end;

    local procedure GetDecimalField(RecRef: RecordRef; FieldName: Text): Decimal
    var
        Txt: Text;
        Dec: Decimal;
    begin
        Txt := GetAnyFieldAsText(RecRef, FieldName);
        if Txt = '' then
            exit(0);

        if Evaluate(Dec, Txt) then
            exit(Dec);

        exit(0);
    end;
}