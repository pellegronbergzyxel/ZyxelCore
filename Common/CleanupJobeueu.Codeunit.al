codeunit 50061 "Cleanup Jobeueu"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        CASE rec."Parameter String" OF
            'ICOutbox':
                SendAndRemoveICoutbox();
            'ICInbox':
                ImportandAlterICInbox();
        end;
    end;

    local procedure SendAndRemoveICoutbox()
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


    Procedure ImportandAlterICInbox()

    var
        ICInboxTransaction: Record "IC Inbox Transaction";
        ICInboxTransaction2: Record "IC Inbox Transaction";
        CarryOutICInboxAction: Report "Complete IC Inbox Action";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase line";
        ICInboxPurchaseLine: Record "IC Inbox Purchase Line";
        Item: Record "item";
        ReleasePurchDoc: Codeunit "Release Purchase Document";

        ExtInvoiceNo: Code[35];
        ExtCredNo: Code[35];
    begin


        ICInboxTransaction.SETRANGE("Line Action", ICInboxTransaction."Line Action"::"No Action", ICInboxTransaction."Line Action"::Accept);
        ICInboxTransaction.SETFILTER("Document Type", '%1|%2', ICInboxTransaction."Document Type"::invoice, ICInboxTransaction."Document Type"::"Credit memo");
        IF ICInboxTransaction.FINDSET THEN
            REPEAT
                // Check location >>
                betweenzNetzCom(ICInboxTransaction);
                // check locaton <<
                ICInboxTransaction2.GET(ICInboxTransaction."Transaction No.", ICInboxTransaction."IC Partner Code", ICInboxTransaction."Transaction Source",
                                         ICInboxTransaction."Document Type");
                ICInboxTransaction2."Line Action" := ICInboxTransaction2."Line Action"::Accept;
                ICInboxTransaction2.MODIFY;
                CLEAR(CarryOutICInboxAction);
                ICInboxTransaction2.SETRANGE("Transaction No.", ICInboxTransaction."Transaction No.");
                CarryOutICInboxAction.SETTABLEVIEW(ICInboxTransaction2);
                CarryOutICInboxAction.USEREQUESTPAGE(FALSE);
                CarryOutICInboxAction.RUNMODAL;
            UNTIL ICInboxTransaction.NEXT = 0;
    end;


    procedure betweenzNetzCom(ICInboxTransaction: Record "IC Inbox Transaction")
    var
        icinboxheader: record "IC Inbox Purchase Header";
        IcinboxLine: record "IC Inbox Purchase Line";
        icpartner: Record "IC Partner";
        vend: record vendor;

        ZyxelGeneralTools: Codeunit "ZyXEL General Tools";
    begin
        if (ICInboxTransaction."Source Type" = ICInboxTransaction."Source Type"::"Purchase Document") then begin
            icpartner.get(ICInboxTransaction."IC Partner Code");
            // zNet -> zCOM || zCom -> zNET
            if ZyxelGeneralTools.IsZNetCompany() <> ZyxelGeneralTools.IsZNetCompanyv2(icpartner."Inbox Details") then begin
                icinboxheader.setrange("IC Transaction No.", ICInboxTransaction."Transaction No.");
                icinboxheader.setrange("IC Partner Code", ICInboxTransaction."IC Partner Code");
                if icinboxheader.findset() then begin
                    if (icinboxheader."Document Type" = icinboxheader."Document Type"::Invoice) then begin
                        if translateLoction(icinboxheader."Location Code") then
                            icinboxheader.Modify(false);
                        IcinboxLine.setrange("IC Transaction No.", ICInboxTransaction."Transaction No.");
                        IcinboxLine.setrange("IC Partner Code", ICInboxTransaction."IC Partner Code");
                        if IcinboxLine.findset() then
                            repeat
                                if translateLoction(IcinboxLine."Location Code") then
                                    IcinboxLine.Modify(false);
                            until IcinboxLine.next = 0;
                    end
                end;
            end;
        end;
    end;

    procedure translateLoction(var loc: code[10]): Boolean
    var
        Location: record Location;
    begin
        if loc = '' then
            exit(false);
        if Location.get(loc) then
            exit(false);
        location.setrange(zNetZComcode, Loc);
        if Location.findset() then begin
            loc := Location.Code;
            exit(true);
        end;
        exit(false);
    end;




}
