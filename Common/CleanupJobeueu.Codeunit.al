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
            'DeleteOrders':
                DeleteOrderAndReturn();
        end;
    end;

    local procedure SendAndRemoveICoutbox()
    var
        ICOutboxTransaction: Record "IC Outbox Transaction";
        ICOutboxTransaction2: Record "IC Outbox Transaction";
        ICOutboxExport: Codeunit "IC Outbox Export";

    begin
        /// send invoice and credit memo
        ICOutboxTransaction.SETRANGE("Line Action", ICOutboxTransaction."Line Action"::"No Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
        ICOutboxTransaction.SETFILTER("Document Type", '%1|%2', ICOutboxTransaction."Document Type"::Invoice, ICOutboxTransaction."Document Type"::"Credit Memo");
        ICOutboxTransaction.setfilter("IC Partner Code", '<>%1', '');
        IF ICOutboxTransaction.FINDSET() THEN
            REPEAT
                ICOutboxTransaction2.GET(ICOutboxTransaction."Transaction No.", ICOutboxTransaction."IC Partner Code", ICOutboxTransaction."Transaction Source",
                                         ICOutboxTransaction."Document Type");
                ICOutboxTransaction2."Line Action" := ICOutboxTransaction2."Line Action"::"Send to IC Partner";
                ICOutboxTransaction2.MODIFY();
                CLEAR(ICOutboxExport);
                ICOutboxExport.RUN(ICOutboxTransaction2);
            UNTIL ICOutboxTransaction.NEXT() = 0;
    end;


    Procedure ImportandAlterICInbox()

    var
        ICInboxTransaction: Record "IC Inbox Transaction";
        ICInboxTransaction2: Record "IC Inbox Transaction";
        ICInboxPurchaseLine: Record "IC Inbox Purchase Line";
        CarryOutICInboxAction: Report "Complete IC Inbox Action";

    begin
        ICInboxTransaction.SETRANGE("Line Action", ICInboxTransaction."Line Action"::"No Action", ICInboxTransaction."Line Action"::Accept);
        ICInboxTransaction.SETFILTER("Document Type", '%1|%2', ICInboxTransaction."Document Type"::invoice, ICInboxTransaction."Document Type"::"Credit memo");
        IF ICInboxTransaction.FINDSET() THEN
            REPEAT
                // Check location >>
                betweenzNetzCom(ICInboxTransaction);
                // check locaton <<
                ICInboxTransaction2.GET(ICInboxTransaction."Transaction No.", ICInboxTransaction."IC Partner Code", ICInboxTransaction."Transaction Source",
                                         ICInboxTransaction."Document Type");
                ICInboxTransaction2."Line Action" := ICInboxTransaction2."Line Action"::Accept;
                ICInboxTransaction2.MODIFY();
                CLEAR(CarryOutICInboxAction);
                ICInboxTransaction2.SETRANGE("Transaction No.", ICInboxTransaction."Transaction No.");
                CarryOutICInboxAction.SETTABLEVIEW(ICInboxTransaction2);
                CarryOutICInboxAction.USEREQUESTPAGE(FALSE);
                CarryOutICInboxAction.RUNMODAL();
            UNTIL ICInboxTransaction.NEXT() = 0;
    end;


    procedure betweenzNetzCom(ICInboxTransaction: Record "IC Inbox Transaction")
    var
        icinboxheader: record "IC Inbox Purchase Header";
        IcinboxLine: record "IC Inbox Purchase Line";
        icpartner: Record "IC Partner";

        ZyxelGeneralTools: Codeunit "ZyXEL General Tools";
    begin
        if (ICInboxTransaction."Source Type" = ICInboxTransaction."Source Type"::"Purchase Document") then begin
            icpartner.get(ICInboxTransaction."IC Partner Code");
            // zNet -> zCOM || zCom -> zNET
            if ZyxelGeneralTools.IsZNetCompany() <> ZyxelGeneralTools.IsZNetCompanyv2(copystr(icpartner."Inbox Details", 1, 30)) then begin
                icinboxheader.setrange("IC Transaction No.", ICInboxTransaction."Transaction No.");
                icinboxheader.setrange("IC Partner Code", ICInboxTransaction."IC Partner Code");
                if icinboxheader.findset() then
                    if (icinboxheader."Document Type" = icinboxheader."Document Type"::Invoice) then begin
                        if translateLoction(icinboxheader."Location Code") then
                            icinboxheader.Modify(false);
                        IcinboxLine.setrange("IC Transaction No.", ICInboxTransaction."Transaction No.");
                        IcinboxLine.setrange("IC Partner Code", ICInboxTransaction."IC Partner Code");
                        if IcinboxLine.findset() then
                            repeat
                                if translateLoction(IcinboxLine."Location Code") then
                                    IcinboxLine.Modify(false);
                            until IcinboxLine.next() = 0;
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
        if Location.findfirst() then begin
            loc := Location.Code;
            exit(true);
        end;
        exit(false);
    end;

    procedure DeleteOrderAndReturn()
    var
        ICOutboxTransaction: Record "IC Outbox Transaction";
        ICOutboxTransaction2: Record "IC Outbox Transaction";
        ICOutboxExport: Codeunit "IC Outbox Export";
        HandledICOutboxTransaction: Record "Handled IC Outbox Trans.";

    Begin
        // Cancel order and return
        ICOutboxTransaction.SETRANGE("Line Action", ICOutboxTransaction."Line Action"::"No Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
        ICOutboxTransaction.SETFILTER("Document Type", '%1|%2', ICOutboxTransaction."Document Type"::Order, ICOutboxTransaction."Document Type"::"Return Order");
        ICOutboxTransaction.setfilter("IC Partner Code", '<>%1', '');
        IF ICOutboxTransaction.FINDSET() THEN
            REPEAT
                ICOutboxTransaction2.GET(ICOutboxTransaction."Transaction No.", ICOutboxTransaction."IC Partner Code", ICOutboxTransaction."Transaction Source",
                                         ICOutboxTransaction."Document Type");
                ICOutboxTransaction2."Line Action" := ICOutboxTransaction2."Line Action"::Cancel;
                ICOutboxTransaction2.MODIFY();
                CLEAR(ICOutboxExport);
                ICOutboxExport.RUN(ICOutboxTransaction2);

            UNTIL ICOutboxTransaction.NEXT() = 0;

        ICOutboxTransaction.SETRANGE("Line Action", ICOutboxTransaction."Line Action"::"No Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
        ICOutboxTransaction.SETFILTER("Document Type", '%1|%2', ICOutboxTransaction."Document Type"::Order, ICOutboxTransaction."Document Type"::"Return Order");
        ICOutboxTransaction.setfilter("IC Partner Code", '=%1', '');
        IF ICOutboxTransaction.FINDSET() THEN
            repeat
                ICOutboxTransaction.delete(true);
            UNTIL ICOutboxTransaction.NEXT() = 0;

        //26-11-2025 BK #541620
        HandledICOutboxTransaction.SETFILTER("Document Type", '%1|%2', HandledICOutboxTransaction."Document Type"::Order, HandledICOutboxTransaction."Document Type"::"Return Order");
        HandledICOutboxTransaction.setrange(Status, HandledICOutboxTransaction.Status::Cancelled);
        IF HandledICOutboxTransaction.FINDSET() THEN
            repeat
                HandledICOutboxTransaction.delete(true);
            UNTIL HandledICOutboxTransaction.NEXT() = 0;

    End;
}
