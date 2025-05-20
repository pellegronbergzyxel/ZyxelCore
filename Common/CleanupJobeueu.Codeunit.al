codeunit 50061 "Cleanup Jobeueu"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        CASE rec."Parameter String" OF
            'ICOutbox':
                RemoveICoutbox();

        end;
    end;

    local procedure RemoveICoutbox()
    var
        ICOutboxTransaction: Record "IC Outbox Transaction";
        ICOutboxTransaction2: Record "IC Outbox Transaction";
        ICOutboxExport: Codeunit "IC Outbox Export";
        SalesHeader: record "Sales Header";
    begin
        /// send invoice and credit memo
        ICOutboxTransaction.SETRANGE("Line Action", ICOutboxTransaction."Line Action"::"No Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
        ICOutboxTransaction.SETFILTER("Document Type", '%1|%2', ICOutboxTransaction."Document Type"::Invoice, ICOutboxTransaction."Document Type"::"Credit Memo");
        ICOutboxTransaction.setfilter("IC Partner Code", '<>%1', '');
        IF ICOutboxTransaction.FINDSET THEN
            REPEAT
                ICOutboxTransaction2.GET(ICOutboxTransaction."Transaction No.", ICOutboxTransaction."IC Partner Code", ICOutboxTransaction."Transaction Source",
                                         ICOutboxTransaction."Document Type");
                ICOutboxTransaction2."Line Action" := ICOutboxTransaction2."Line Action"::"Send to IC Partner";
                ICOutboxTransaction2.MODIFY;
                CLEAR(ICOutboxExport);
                ICOutboxExport.RUN(ICOutboxTransaction2);

            // if ICOutboxTransaction."Document Type"::Order = ICOutboxTransaction."Document Type" then
            //     IF SalesHeader.GET(SalesHeader."Document Type"::Order, ICOutboxTransaction."Document No.") THEN BEGIN
            //         SalesHeader.VALIDATE("IC Status", SalesHeader."IC Status"::New);
            //         SalesHeader.MODIFY;
            //     END;
            // if ICOutboxTransaction."Document Type"::"Return Order" = ICOutboxTransaction."Document Type" then
            //     IF SalesHeader.GET(SalesHeader."Document Type"::"Return Order", ICOutboxTransaction."Document No.") THEN BEGIN
            //         SalesHeader.VALIDATE("IC Status", SalesHeader."IC Status"::new);
            //         SalesHeader.MODIFY;
            //     END;

            UNTIL ICOutboxTransaction.NEXT = 0;

        // Cancel order and return
        ICOutboxTransaction.SETRANGE("Line Action", ICOutboxTransaction."Line Action"::"No Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
        ICOutboxTransaction.SETFILTER("Document Type", '%1|%2', ICOutboxTransaction."Document Type"::Order, ICOutboxTransaction."Document Type"::"Return Order");
        ICOutboxTransaction.setfilter("IC Partner Code", '<>%1', '');
        IF ICOutboxTransaction.FINDSET THEN
            REPEAT
                ICOutboxTransaction2.GET(ICOutboxTransaction."Transaction No.", ICOutboxTransaction."IC Partner Code", ICOutboxTransaction."Transaction Source",
                                         ICOutboxTransaction."Document Type");
                ICOutboxTransaction2."Line Action" := ICOutboxTransaction2."Line Action"::Cancel;
                ICOutboxTransaction2.MODIFY;
                CLEAR(ICOutboxExport);
                ICOutboxExport.RUN(ICOutboxTransaction2);

            UNTIL ICOutboxTransaction.NEXT = 0;

        ICOutboxTransaction.SETRANGE("Line Action", ICOutboxTransaction."Line Action"::"No Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
        ICOutboxTransaction.SETFILTER("Document Type", '%1|%2', ICOutboxTransaction."Document Type"::Order, ICOutboxTransaction."Document Type"::"Return Order");
        ICOutboxTransaction.setfilter("IC Partner Code", '=%1', '');
        IF ICOutboxTransaction.FINDSET THEN
            repeat
                ICOutboxTransaction.delete(true);
            UNTIL ICOutboxTransaction.NEXT = 0;

    end;






}
