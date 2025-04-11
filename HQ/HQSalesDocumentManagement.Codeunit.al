Codeunit 50060 "HQ Sales Document Management"
{
    // 001. 24-09-19 ZY-LD 000 - Post EiCard Purchase Orders
    // 002. 15-04-20 ZY-LD 000 - Update unit cost on the purchase order line.
    // 003. 06-04-21 ZY-LD 000 - We have seen, that the "Vendor Invoice No." not always are updated when "HQ Invoice" is inserted.


    trigger OnRun()
    begin
        recAutoSetup.Get;
        if recAutoSetup.PostPurchaseOrderEiCardAllowed then
            PostEiCardPurchaseOrders('', true);
        if recAutoSetup.PostSalesOrderEiCardAllowed then
            PostEiCardSalesOrders('', true);
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";


    procedure PostEiCardPurchaseOrders(pPurchOrderNo: Code[20]; pRejectEndMessage: Boolean): Boolean
    var
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recHqInvHead: Record "HQ Invoice Header";
        recHqInvLine: Record "HQ Invoice Line";
        recEiCardQueue: Record "EiCard Queue";
        PurchPost: Codeunit "Purch.-Post";
        BatchPostPurchaseOrders: Report "Batch Post Purchase Orders";
        PurchaseOrderStatusOption: Option Created,"EiCard Order Sent to HQ","EiCard Order Accepted","EiCard Order Rejected","Fully Matched","Partially Matched",Posted,"Posting Error";
        DataHasBeenModified: Boolean;
    begin
        recPurchHead.SetRange("Document Type", recPurchHead."document type"::Order);
        recPurchHead.SetRange(IsEICard, true);
        recPurchHead.SetRange("EiCard Ready to Post", true);
        if pPurchOrderNo <> '' then
            recPurchHead.SetRange("No.", pPurchOrderNo);

        //>> 15-04-20 ZY-LD 002
        if recPurchHead.FindSet then begin
            //>> 06-04-21 ZY-LD 003
            if recPurchHead."Vendor Invoice No." = '' then begin
                recHqInvHead.SetRange("Purchase Order No.", recPurchHead."No.");
                if recHqInvHead.FindFirst then begin
                    recPurchHead."Vendor Invoice No." := recHqInvHead."No.";
                    recPurchHead.Modify(true);
                    DataHasBeenModified := true;
                end;
            end;
            //<< 06-04-21 ZY-LD 003

            repeat
                recHqInvLine.SetRange("Purchase Order No.", recPurchHead."No.");
                if recHqInvLine.FindSet then
                    repeat
                        if recPurchLine.Get(recPurchHead."Document Type", recPurchHead."No.", recHqInvLine."Purchase Order Line No.") then
                            if (recPurchLine."Direct Unit Cost" <> recHqInvLine."Unit Price") OR (recPurchLine.Quantity <> recPurchLine."Qty. to Receive") then begin
                                recPurchLine.SuspendStatusCheck(true);
                                recPurchLine.Validate("Qty. to Receive", recPurchLine.Quantity);
                                recPurchLine.Validate("Direct Unit Cost", recHqInvLine."Unit Price");
                                recPurchLine.Modify(true);
                                recPurchLine.SuspendStatusCheck(false);
                                DataHasBeenModified := true;
                            end;
                    until recHqInvLine.Next() = 0;
            until recPurchHead.Next() = 0;
        end;

        if DataHasBeenModified then
            Commit;
        //<< 15-04-20 ZY-LD 002

        Clear(BatchPostPurchaseOrders);
        BatchPostPurchaseOrders.UseRequestPage(false);
        BatchPostPurchaseOrders.SetTableview(recPurchHead);
        BatchPostPurchaseOrders.InitializeRequest(true, true, Today, Today, true, false, true, false);  // 04-06-24 ZY-LD 000 - Replace VATDate = true;
        //TODO: BatchPostPurchaseOrders.InitMessage(pRejectEndMessage);
        BatchPostPurchaseOrders.RunModal;

        exit(true);
    end;


    procedure PostEiCardSalesOrders(pSalesOrderNo: Code[20]; pRejectEndMessage: Boolean) rValue: Boolean
    var
        recSalesHead: Record "Sales Header";
        recEiCardQueue: Record "EiCard Queue";
        PurchPost: Codeunit "Purch.-Post";
        BatchPostSalesOrders: Report "Batch Post Sales Orders";
        PostEiCardInvoiceAutomaticFilter: Option " ","Yes (when purchase invoice is posted)","Yes (when EiCard links is sent to the customer)";
    begin
        if PostEiCardSalesOrders2(Posteicardinvoiceautomaticfilter::"Yes (when purchase invoice is posted)", pSalesOrderNo, pRejectEndMessage) then
            rValue := true;
        if PostEiCardSalesOrders2(Posteicardinvoiceautomaticfilter::"Yes (when EiCard links is sent to the customer)", pSalesOrderNo, pRejectEndMessage) then
            rValue := true;
    end;


    procedure PostEiCardSalesOrders2(pPostEiCardInvoiceAutomaticFilter: Option " ","Yes (when purchase invoice is posted)","Yes (when EiCard links is sent to the customer)"; pSalesOrderNo: Code[20]; pRejectEndMessage: Boolean) rValue: Boolean
    var
        recSalesHead: Record "Sales Header";
        recEiCardQueue: Record "EiCard Queue";
        PurchPost: Codeunit "Purch.-Post";
        BatchPostSalesOrders: Report "Batch Post Sales Orders";
        IntercompanyInvoices: array[2] of Integer;
    begin
        recSalesHead.SetRange("Document Type", recSalesHead."document type"::Order);
        recSalesHead.SetRange("Sales Order Type", recSalesHead."sales order type"::EICard);
        recSalesHead.SetRange("Post EiCard Invoice Automatic", pPostEiCardInvoiceAutomaticFilter);
        if pPostEiCardInvoiceAutomaticFilter = Pposteicardinvoiceautomaticfilter::"Yes (when purchase invoice is posted)" then
            recSalesHead.SetRange("EiCard iPurch Order St. Filter", recSalesHead."eicard ipurch order st. filter"::Posted);
        recSalesHead.SetRange("EiCard Ready to Post", true);
        if pSalesOrderNo <> '' then
            recSalesHead.SetRange("No.", pSalesOrderNo);

        if recSalesHead.FindSet then
            repeat
                if recSalesHead."Sell-to Customer No." <> recSalesHead."Bill-to Customer No." then
                    IntercompanyInvoices[1] += 1;
            until recSalesHead.Next() = 0;

        if recSalesHead.FindFirst then begin  // Since this function is called twice, there is a check, so we don't get any false messages
            Clear(BatchPostSalesOrders);
            BatchPostSalesOrders.UseRequestPage(false);
            BatchPostSalesOrders.SetTableview(recSalesHead);
            BatchPostSalesOrders.InitializeRequest(true, true, Today, Today, true, false, true, false);  // 04-06-24 ZY-LD 000 - Replace VATDate = true;
            //TODO: BatchPostSalesOrders.InitMessage(pRejectEndMessage);
            BatchPostSalesOrders.RunModal;
            //TODO Error handling has been ghanged completely
            //if BatchPostSalesOrders.GetCounterOK > 0 then
            //    rValue := true;
        end;

        if recSalesHead.FindSet then
            repeat
                if recSalesHead."Sell-to Customer No." <> recSalesHead."Bill-to Customer No." then
                    IntercompanyInvoices[2] += 1;
            until recSalesHead.Next() = 0;

        if IntercompanyInvoices[1] <> IntercompanyInvoices[2] then begin
            EmailAddMgt.CreateSimpleEmail('LOGINTINV', '', '');
            EmailAddMgt.Send;
        end;
    end;
}
