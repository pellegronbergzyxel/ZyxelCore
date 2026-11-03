codeunit 50365 "HQCustomerDetailedEntries"
{
    /// <summary>
    /// Returns the customer payments whose records were created in BC between fromDate and
    /// toDate (by SystemCreatedAt, UTC), as a JSON array.
    /// Dates format yyyy-mm-dd.
    /// Version: Zyxel 1.0.0.1 - 2026/10/02 Aaron Lin Add
    /// Version: Zyxel 1.0.0.2 - 2026/10/21 Aaron Lin Add fields: CURRENCY_TXN, APPLIED_AMT_TXN, CURRENCY_LCY
    /// </summary>
    procedure GetCustomerPaymentList(fromDate: Text; toDate: Text) ReturnValue: Text;
    var
        JReceipts: JsonArray;
    begin
        JReceipts := CustomerPaymentToJson(ConvertTextToDate(fromDate), ConvertTextToDate(toDate));
        if JReceipts.Count > 0 then
            JReceipts.WriteTo(ReturnValue)
        else
            Error('No data found.');
    end;


    /// <summary>
    /// Parses a 'yyyy-mm-dd' text into a Date. Errors if the format is invalid.
    /// </summary>
    /// <param name="textDate">Dates format yyyy-mm-dd</param>
    /// <returns></returns>
    local procedure ConvertTextToDate(textDate: Text): Date;
    var
        textDateList: List of [Text];
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        if textDate.Contains('-') then begin
            textDateList := textDate.Split('-');

            if EVALUATE(Day, textDateList.Get(3)) and
            EVALUATE(Month, textDateList.Get(2)) and
            EVALUATE(Year, textDateList.Get(1)) then
                exit(DMY2DATE(Day, Month, Year))
            else
                Error('Could not convert specific Text to Date type.');
        end else
            Error('The date format should be yyyy-mm-dd. inputDate: %1', textDate);
    end;


    /// <summary>
    /// Builds the Customer Payment JSON array:
    /// Filters Cust. Ledger Entries by SystemCreatedAt and Original Amt. (LCY) less than 0.
    /// </summary>
    local procedure CustomerPaymentToJson(fromDate: Date; toDate: Date): JsonArray
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        AppliedAmountLCY: Decimal;
        AppliedAmountTXN: Decimal;
        JReceipts: JsonArray;
        IsApplied: Boolean;
    begin
        GLSetup.Get();
        CustLedgerEntry.SetRange(SystemCreatedAt, CreateDateTime(fromDate, 0T), CreateDateTime(toDate, 235959.999T));
        CustLedgerEntry.SetRange(Reversed, false);                                                          // excludes reversed entries
        CustLedgerEntry.SetFilter("Document Type", '<>%1', CustLedgerEntry."Document Type"::"Credit Memo"); // excludes credit memos
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                if CustLedgerEntry."Original Amt. (LCY)" < 0 then begin     //Only Get Payment(Amt < 0)
                    IsApplied := GetValidAppliedAmount(CustLedgerEntry."Entry No.", AppliedAmountLCY, AppliedAmountTXN);
                    AddCustomerPaymentToJson(CustLedgerEntry, AppliedAmountLCY, AppliedAmountTXN, IsApplied, GLSetup."LCY Code", JReceipts);
                end;
            until CustLedgerEntry.Next() = 0;

        exit(JReceipts);
    end;


    /// <summary>
    /// Maps one Cust. Ledger Entry to a receipt JSON object and appends it to JReceipts.
    /// </summary>
    local procedure AddCustomerPaymentToJson(CustLedgerEntry: Record "Cust. Ledger Entry"; AppliedAmountLCY: Decimal; AppliedAmountTXN: Decimal; IsApplied: Boolean; LCYCode: Code[10]; JReceipts: JsonArray)
    var
        Customer: Record Customer;
        CurrencyTXN: Code[10];
        JReceipt: JsonObject;
    begin
        if not Customer.Get(CustLedgerEntry."Customer No.") then
            Clear(Customer);

        // Blank currency = local currency (LCY)
        CurrencyTXN := CustLedgerEntry."Currency Code";
        if CurrencyTXN = '' then
            CurrencyTXN := LCYCode;

        // Attributes
        JReceipt.Add('LEDGER', CompanyName());
        JReceipt.Add('ENTRY_NO', CustLedgerEntry."Entry No.");
        JReceipt.Add('DOCUMENT_NO', CustLedgerEntry."Document No.");
        JReceipt.Add('DOCUMENT_TYPE', Format(CustLedgerEntry."Document Type", 0, 9));
        JReceipt.Add('CURRENCY_TXN', CurrencyTXN);
        JReceipt.Add('CURRENCY_LCY', LCYCode);
        JReceipt.Add('ORIGINAL_AMT_LCY', CustLedgerEntry."Original Amt. (LCY)");
        JReceipt.Add('APPLIED_AMT_TXN', AppliedAmountTXN);
        JReceipt.Add('APPLIED_AMT_LCY', AppliedAmountLCY);
        JReceipt.Add('REMAINING_AMT_LCY', CustLedgerEntry."Remaining Amt. (LCY)");
        if not IsApplied then
            JReceipt.Add('APPLY_STATUS', 'Not Applied')
        else
            if CustLedgerEntry.Open then
                JReceipt.Add('APPLY_STATUS', 'Partially Applied')
            else
                JReceipt.Add('APPLY_STATUS', 'Fully Applied');
        JReceipt.Add('CUSTOMER_NO', CustLedgerEntry."Customer No.");
        JReceipt.Add('CUSTOMER_NAME', Customer.Name);
        JReceipt.Add('DESCRIPTION', CustLedgerEntry.Description);
        JReceipt.Add('POSTING_DATE', CustLedgerEntry."Posting Date");
        JReceipt.Add('SYSTEM_CREATED_AT', CustLedgerEntry.SystemCreatedAt);

        JReceipts.Add(JReceipt);
    end;


    /// <summary>
    /// Sums the valid application entries of the given ledger entry, in LCY and in transaction currency.
    /// </summary>
    /// <param name="CustLedgerEntryNo">Cust. Ledger Entry "Entry No."</param>
    /// <param name="AppliedAmountLCY">Out: applied amount in LCY.</param>
    /// <param name="AppliedAmountTXN">Out: applied amount in transaction currency.</param>
    /// <returns>True=> Have apply entry, False=> Not have apply entry</returns>
    local procedure GetValidAppliedAmount(CustLedgerEntryNo: Integer; var AppliedAmountLCY: Decimal; var AppliedAmountTXN: Decimal): Boolean
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        AppliedAmountLCY := 0;
        AppliedAmountTXN := 0;
        DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntryNo);
        DtldCustLedgEntry.SetFilter("Entry Type", '<>%1&<>%2&<>%3',     //exclude initial and unrealized FX revaluation entry
            DtldCustLedgEntry."Entry Type"::"Initial Entry",
            DtldCustLedgEntry."Entry Type"::"Unrealized Loss",
            DtldCustLedgEntry."Entry Type"::"Unrealized Gain");
        DtldCustLedgEntry.SetRange(Unapplied, false);   //excludes Unapplied entry
        DtldCustLedgEntry.SetRange("Unapplied by Entry No.", 0);
        if DtldCustLedgEntry.IsEmpty() then   // settlement types only appear after an application
            exit(false);

        DtldCustLedgEntry.CalcSums(Amount, "Amount (LCY)");
        AppliedAmountLCY := DtldCustLedgEntry."Amount (LCY)";
        AppliedAmountTXN := DtldCustLedgEntry.Amount;
        exit(true);
    end;
}