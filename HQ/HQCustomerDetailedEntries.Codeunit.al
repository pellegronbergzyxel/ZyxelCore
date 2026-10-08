codeunit 50365 "HQCustomerDetailedEntries"
{
    /// <summary>
    /// Returns the customer payments whose records were created in BC between fromDate and
    /// toDate (by SystemCreatedAt, UTC), as a JSON array.
    /// Dates format yyyy-mm-dd.
    /// Version: Zyxel 1.0.0.1 - 2026/10/02 Add
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
        AppliedAmountLCY: Decimal;
        JReceipts: JsonArray;
        IsApplied: Boolean;
    begin
        CustLedgerEntry.SetRange(SystemCreatedAt, CreateDateTime(fromDate, 0T), CreateDateTime(toDate, 235959.999T));
        CustLedgerEntry.SetRange(Reversed, false);                                                          // excludes reversed entries
        CustLedgerEntry.SetFilter("Document Type", '<>%1', CustLedgerEntry."Document Type"::"Credit Memo"); // excludes credit memos
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                if CustLedgerEntry."Original Amt. (LCY)" < 0 then begin     //Only Get Payment(Amt < 0)
                    IsApplied := GetValidAppliedAmountLCY(CustLedgerEntry."Entry No.", AppliedAmountLCY);
                    AddCustomerPaymentToJson(CustLedgerEntry, AppliedAmountLCY, IsApplied, JReceipts);
                end;
            until CustLedgerEntry.Next() = 0;

        exit(JReceipts);
    end;


    /// <summary>
    /// Maps one Cust. Ledger Entry to a receipt JSON object and appends it to JReceipts.
    /// </summary>
    local procedure AddCustomerPaymentToJson(CustLedgerEntry: Record "Cust. Ledger Entry"; AppliedAmountLCY: Decimal; IsApplied: Boolean; JReceipts: JsonArray)
    var
        Customer: Record Customer;
        CurrencyCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        JReceipt: JsonObject;
    begin
        if not Customer.Get(CustLedgerEntry."Customer No.") then
            Clear(Customer);

        // Blank currency = local currency (LCY)
        CurrencyCode := CustLedgerEntry."Currency Code";
        if CurrencyCode = '' then begin
            GLSetup.Get();
            CurrencyCode := GLSetup."LCY Code";
        end;

        // Attributes
        JReceipt.Add('LEDGER', CompanyName());
        JReceipt.Add('ENTRY_NO', CustLedgerEntry."Entry No.");
        JReceipt.Add('DOCUMENT_NO', CustLedgerEntry."Document No.");
        JReceipt.Add('DOCUMENT_TYPE', Format(CustLedgerEntry."Document Type", 0, 9));
        JReceipt.Add('CURRENCY_CODE', CurrencyCode);
        JReceipt.Add('ORIGINAL_AMT_LCY', CustLedgerEntry."Original Amt. (LCY)");
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
    /// Sums the valid application entries of the given ledger entry into AppliedAmountLCY.
    /// </summary>
    /// <param name="CustLedgerEntryNo"></param>
    /// <param name="AppliedAmountLCY"></param>
    /// <returns>True=> Have apply entry, False=> Not have apply entry</returns>
    local procedure GetValidAppliedAmountLCY(CustLedgerEntryNo: Integer; var AppliedAmountLCY: Decimal): Boolean
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        AppliedAmountLCY := 0;
        DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntryNo);
        DtldCustLedgEntry.SetRange("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
        DtldCustLedgEntry.SetRange(Unapplied, false);   //excludes Unapplied entry
        DtldCustLedgEntry.SetRange("Unapplied by Entry No.", 0);
        if DtldCustLedgEntry.IsEmpty() then
            exit(false);

        DtldCustLedgEntry.CalcSums("Amount (LCY)");
        AppliedAmountLCY := DtldCustLedgEntry."Amount (LCY)";
        exit(true);
    end;
}