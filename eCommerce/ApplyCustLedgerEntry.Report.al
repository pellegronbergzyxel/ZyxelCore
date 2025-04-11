report 50039 "Apply Cust. Ledger Entry"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Apply Cust. Ledger Entry';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.", "Posting Date", "Currency Code") where(Open = const(true), "Document Type" = FILTER('Payment|Refund'));
            RequestFilterFields = "Customer No.";
            CalcFields = Amount;

            trigger OnAfterGetRecord()
            var
                CustLedgEntry2: Record "Cust. Ledger Entry";
                CustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
                TotalAmount: Decimal;

            begin
                ZGT.UpdateProgressWindow(FORMAT("Entry No."), 0, TRUE);

                //CustLedgEntry.RESET;
                CustLedgEntry.SETRANGE("External Document No.", "External Document No.");
                CustLedgEntry.SETRANGE("Customer No.", "Customer No.");
                CustLedgEntry.SETRANGE(Open, TRUE);
                CustLedgEntry.SETRANGE("Currency Code", "Currency Code");
                IF "Document Type" = "Document Type"::Payment THEN
                    CustLedgEntry.SETRANGE("Document Type", "Document Type"::Invoice)
                ELSE
                    CustLedgEntry.SETRANGE("Document Type", "Document Type"::"Credit Memo");

                TotalAmount := CustLedgerEntry.Amount;
                CustLedgEntry.SETAUTOCALCFIELDS(Amount);
                IF CustLedgEntry.FINDSET THEN
                    REPEAT
                        TotalAmount += CustLedgEntry.Amount;
                    UNTIL CustLedgEntry.NEXT = 0;
                //                IF CustLedgEntry.FINDFIRST AND (CustLedgEntry.COUNT = 1) AND (ABS(Amount) = ABS(CustLedgEntry.Amount)) THEN BEGIN
                IF (CustLedgEntry.FINDFIRST AND (CustLedgEntry.COUNT = 1) AND (ABS(Amount) - ABS(CustLedgEntry.Amount) < 0.25)) OR
                   (TotalAmount = 0)
                THEN BEGIN
                    CustLedgEntry2.COPY(CustLedgerEntry);
                    CustLedgEntry2.SETRANGE("External Document No.", "External Document No.");
                    CustEntryApplyPostEntries.ApplyCustEntryFormEntry(CustLedgEntry2);
                END;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', COUNT);

                // Removing old applies-to ID before running.
                CustLedgEntry.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                CustLedgEntry.SetRange("Customer No.", CustLedgerEntry.GetFilter("Customer No."));
                CustLedgEntry.SetRange("Applies-to ID", UserId);
                CustLedgEntry.ModifyAll("Applies-to ID", '');

                CustLedgEntry.Reset();
                CustLedgEntry.SetCurrentKey("External Document No.");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ZGT: Codeunit "ZyXEL General Tools";

    trigger OnPreReport()
    var
        AutoSetup: Record "Automation Setup";
        lText001: Label 'ENU=%1 must be filled.';
        lText002: Label 'ENU=Posting is closed due to End of Month.';

    begin
        AutoSetup.GET;
        IF NOT AutoSetup.EndOfMonthAllowed THEN
            ERROR(lText002);

        IF CustLedgerEntry.GETFILTER("Customer No.") = '' THEN
            ERROR(lText001, CustLedgerEntry.FIELDCAPTION("Customer No."));
    End;
}
