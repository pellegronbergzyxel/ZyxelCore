Report 50123 "Posted Purchase Export LCY"
{ //24-04-2026 BK #568056 - Purchase version of Posted Sales Export LCY (Excel)
    Caption = 'Posted Purchase Export LCY (Excel)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PurchInvHdr; "Purch. Inv. Header")
        {
            RequestFilterFields = "Posting Date", "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Currency Code", "Due Date";

            trigger OnAfterGetRecord()
            begin
                AddPostedPurchaseRow(PurchInvHdr, DocType::Invoice);
            end;
        }

        dataitem(PurchCrMemoHdr; "Purch. Cr. Memo Hdr.")
        {
            RequestFilterFields = "Posting Date", "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Currency Code";
            // "Due Date" may not exist / not be relevant in some setups for credit memos

            trigger OnAfterGetRecord()
            begin
                AddPostedPurchaseRow(PurchCrMemoHdr, DocType::"Credit Memo");
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
        TempExcelBuf: Record "Excel Buffer" temporary;

        // Document type passed for invoice / credit memo
        DocType: Enum "Gen. Journal Document Type";
        VendLedgEntry: Record "Vendor Ledger Entry";

        // Labels / formats
        SheetNameLbl: Label 'Purchase';
        DateFmtTxt: Label 'dd-mm-yyyy';
        AmountFmtTxt: Label '#,##0.00';

    // ---------------- Excel init / header / finish ----------------

    local procedure InitExcel()
    var
        FileName: Text;
    begin
        TempExcelBuf.Reset();
        TempExcelBuf.DeleteAll();

        FileName := StrSubstNo('PurchaseReport_%1', Format(Today(), 0, 9)); // YYYY-MM-DD
        TempExcelBuf.CreateNewBook(FileName);
    end;

    local procedure AddExcelHeader()
    begin
        TempExcelBuf.NewRow();

        AddColText('Purchase Order Type', true);
        AddColText('Document Type', true);
        AddColText('Posting Date', true);
        AddColText('Document No.', true);
        AddColText('Vendor Invoice No.', true);
        AddColText('External Document No.', true);

        AddColText('Buy-from Vendor No.', true);
        AddColText('Buy-from Vendor Name', true);
        AddColText('Pay-to Vendor No.', true);
        AddColText('Currency Code', true);

        AddColText('Original Amount', true);
        AddColText('Original VAT Amount', true);
        AddColText('Original Amount Including VAT', true);

        AddColText('Original LCY Amount', true);
        AddColText('Original LCY VAT Amount', true);
        AddColText('Original LCY Amount Including VAT', true);

        AddColText('Adjusted LCY Amount', true);
        AddColText('Remaining Amount', true);
        AddColText('Due Date', true);
    end;

    local procedure FinishExcel()
    begin
        TempExcelBuf.WriteSheet(SheetNameLbl, CompanyName(), UserId());
        TempExcelBuf.CloseBook();
        TempExcelBuf.OpenExcel();
    end;

    // ---------------- Core row builder ----------------

    local procedure AddPostedPurchaseRow(AnyHeader: Variant; DocumentType: Enum "Gen. Journal Document Type")
    var
        RecRef: RecordRef;
        PostingDate: Date;
        DocNo: Code[20];

        BuyFromVendNo: Code[20];
        BuyFromVendName: Text[100];
        PayToVendNo: Code[20];

        CurrencyCode: Code[10];
        DueDate: Date;

        VendorInvoiceNoTxt: Text;
        ExternalDocNoTxt: Text;
        PurchOrderTypeTxt: Text;
        DocTypeTxt: Text;

        OrigAmount: Decimal;
        OrigAmountInclVAT: Decimal;
        OrigVAT: Decimal;

        LCYAmount: Decimal;
        LCYAmountInclVAT: Decimal;
        LCYVAT: Decimal;
        AdjustedLCYAmount: Decimal;
        RemainingAmount: Decimal;
    begin
        RecRef.GetTable(AnyHeader);

        PostingDate := GetDateField(RecRef, 'Posting Date');
        DocNo := GetCodeField(RecRef, 'No.');

        BuyFromVendNo := GetCodeField(RecRef, 'Buy-from Vendor No.');
        BuyFromVendName := GetTextField(RecRef, 'Buy-from Vendor Name');
        PayToVendNo := GetCodeField(RecRef, 'Pay-to Vendor No.');

        CurrencyCode := GetCodeField(RecRef, 'Currency Code');
        DueDate := GetDateField(RecRef, 'Due Date');

        // Optional/custom fields (robust)
        PurchOrderTypeTxt := GetAnyFieldAsText(RecRef, 'Purchase Order Type');
        VendorInvoiceNoTxt := GetAnyFieldAsText(RecRef, 'Vendor Invoice No.');
        ExternalDocNoTxt := GetAnyFieldAsText(RecRef, 'External Document No.');

        case DocumentType of
            DocumentType::Invoice:
                DocTypeTxt := 'Invoice';
            DocumentType::"Credit Memo":
                DocTypeTxt := 'Credit Memo';
            else
                DocTypeTxt := Format(DocumentType);
        end;

        // Amounts from posted purchase lines
        GetDocumentAmounts(DocumentType, DocNo, OrigAmount, OrigAmountInclVAT, OrigVAT);

        // LCY + Remaining + Adjusted from Vendor Ledger Entry (robust field access)
        GetLedgerAmounts(DocumentType, DocNo, PostingDate,
                         LCYAmount, LCYAmountInclVAT, LCYVAT,
                         RemainingAmount, AdjustedLCYAmount, DueDate);

        // Write to Excel
        TempExcelBuf.NewRow();

        AddColText(PurchOrderTypeTxt, false);
        AddColText(DocTypeTxt, false);
        AddColDate(PostingDate);
        AddColText(DocNo, false);
        AddColText(VendorInvoiceNoTxt, false);
        AddColText(ExternalDocNoTxt, false);

        AddColText(BuyFromVendNo, false);
        AddColText(BuyFromVendName, false);
        AddColText(PayToVendNo, false);
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

    // ---------------- Amount calc: lines ----------------

    local procedure GetDocumentAmounts(DocumentType: Enum "Gen. Journal Document Type"; DocNo: Code[20];
                                       var OrigAmount: Decimal; var OrigAmountInclVAT: Decimal; var OrigVAT: Decimal)
    var
        PostedPurchInvLine: Record "Purch. Inv. Line";
        PostedPurchCrLine: Record "Purch. Cr. Memo Line";
    begin
        Clear(OrigAmount);
        Clear(OrigAmountInclVAT);
        Clear(OrigVAT);

        if DocumentType = DocumentType::Invoice then begin
            PostedPurchInvLine.Reset();
            PostedPurchInvLine.SetRange("Document No.", DocNo);

            if PostedPurchInvLine.FindFirst() then
                repeat
                    OrigAmount += PostedPurchInvLine."Line Amount";
                    OrigAmountInclVAT += PostedPurchInvLine."Amount Including VAT";
                    OrigVAT += (OrigAmountInclVAT - OrigAmount);
                until PostedPurchInvLine.Next() = 0;

        end else
            if DocumentType = DocumentType::"Credit Memo" then begin
                PostedPurchCrLine.Reset();
                PostedPurchCrLine.SetRange("Document No.", DocNo);

                if PostedPurchCrLine.FindFirst() then
                    repeat
                        OrigAmount += PostedPurchCrLine."Line Amount";
                        OrigAmountInclVAT += PostedPurchCrLine."Amount Including VAT";
                        OrigVAT += (OrigAmountInclVAT - OrigAmount);
                    until PostedPurchCrLine.Next() = 0;

                if OrigVAT <> 0 then
                    OrigVAT := -1 * (OrigAmountInclVAT - OrigAmount);

                if OrigAmount <> 0 then
                    OrigAmount := -1 * OrigAmount;

                if OrigAmountInclVAT <> 0 then
                    OrigAmountInclVAT := -1 * OrigAmountInclVAT;
            end;




    end;

    // ---------------- Amount calc: Vendor Ledger Entry (LCY) ----------------

    local procedure GetLedgerAmounts(DocumentType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; PostingDate: Date;
                                     var LCYAmount: Decimal; var LCYAmountInclVAT: Decimal; var LCYVAT: Decimal;
                                     var RemainingAmount: Decimal; var AdjustedLCYAmount: Decimal; var DueDate: Date)
    var
        PurchaseLCYCandidate: Decimal;
    begin
        Clear(LCYAmount);
        Clear(LCYAmountInclVAT);
        Clear(LCYVAT);
        Clear(RemainingAmount);
        Clear(AdjustedLCYAmount);

        VendLedgEntry.Reset();
        VendLedgEntry.SetCurrentKey("Document Type", "Document No.");
        VendLedgEntry.SetRange("Document Type", DocumentType);
        VendLedgEntry.SetRange("Document No.", DocNo);
        VendLedgEntry.SetRange("Posting Date", PostingDate);

        if VendLedgEntry.FindFirst() then begin
            VendLedgEntry.CalcFields("Original Amt. (LCY)", "Amount (LCY)", "Remaining Amount");
            // These exist in standard BC:
            LCYAmountInclVAT := VendLedgEntry."Original Amt. (LCY)";
            RemainingAmount := VendLedgEntry."Remaining Amount";
            AdjustedLCYAmount := VendLedgEntry."Amount (LCY)";
            LCYAmount := PurchaseLCYCandidate;
            LCYVAT := LCYAmountInclVAT - LCYAmount;

            if DueDate = 0D then
                DueDate := VendLedgEntry."Due Date";
        end;
    end;

    // ---------------- Excel helpers ----------------

    local procedure AddColText(Value: Text; Bold: Boolean)
    begin
        TempExcelBuf.AddColumn(Value, false, '', Bold, false, false, '', TempExcelBuf."Cell Type"::Text);
    end;

    local procedure AddColDate(Value: Date)
    begin
        if Value = 0D then
            TempExcelBuf.AddColumn('', false, '', false, false, false, DateFmtTxt, TempExcelBuf."Cell Type"::Date)
        else
            TempExcelBuf.AddColumn(Value, false, '', false, false, false, DateFmtTxt, TempExcelBuf."Cell Type"::Date);
    end;

    local procedure AddColAmount(Value: Decimal)
    begin
        TempExcelBuf.AddColumn(Value, false, '', false, false, false, AmountFmtTxt, TempExcelBuf."Cell Type"::Number);
    end;

    // ---------------- RecordRef helpers (robust) ----------------

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

        if Evaluate(D, Txt) then
            exit(D);

        exit(0D);
    end;

    local procedure CalcFlowFieldDecimal(RecRef: RecordRef; FieldName: Text): Decimal
    var
        FRef: FieldRef;
        i: Integer;
        Txt: Text;
        Dec: Decimal;
    begin
        for i := 1 to RecRef.FieldCount() do begin
            FRef := RecRef.FieldIndex(i);
            if UpperCase(FRef.Name()) = UpperCase(FieldName) then begin
                // Works for FlowFields too
                FRef.CalcField();
                Txt := Format(FRef.Value());
                if Evaluate(Dec, Txt) then
                    exit(Dec);
                exit(0);
            end;
        end;
        exit(0);
    end;

    local procedure GetDecimalFieldFromAnyName(RecRef: RecordRef; FieldNamesPipeSeparated: Text): Decimal
    var
        Names: List of [Text];
        Name: Text;
        Value: Decimal;
    begin
        Names := FieldNamesPipeSeparated.Split('|');
        foreach Name in Names do begin
            Value := CalcFlowFieldDecimal(RecRef, Name);
            if Value <> 0 then
                exit(Value);
        end;
        exit(0);
    end;
}