codeunit 62001 "Create Normal Purchase Invoice"
{

    trigger OnRun()
    begin
        recAutoSetup.Get();
        RunningAutomation := true;
        if recAutoSetup.CreatePurchaseInvoiceNormalAllowed then
            ProcessInvoice('', recAutoSetup."Post Purchase Invoice", false);
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        CreateInvOnWhseStatus: Integer;
        RunningAutomation: Boolean;


    procedure ProcessInvoice(pDelDocNo: Code[20]; pPostInvoice: Boolean; RunConfirm: Boolean)
    var
        recWhseIndbHead: Record "Warehouse Inbound Header";
        Process: Boolean;
        lText001: Label 'Do you want to create invoices?';
        lText002: Label 'Do you want to create and post invoice on delivery document %1?';
        lText003: Label 'Do you want to create invoice on delivery document %1?';
        lText004: Label 'The invoice %1 is succesfully added to the e-mail queue.';
    begin
        if RunConfirm then begin
            if pDelDocNo <> '' then begin
                if pPostInvoice then
                    Process := Confirm(lText002, true, pDelDocNo)
                else
                    Process := Confirm(lText003, true, pDelDocNo);
            end else
                Process := Confirm(lText001, true);
        end else
            Process := true;

        if Process then begin
            // This is a temporary solution, until the we can post the invoice.
            recWhseIndbHead.LockTable;
            recWhseIndbHead.SetRange("Order Type", recWhseIndbHead."order type"::"Purchase Order");
            recWhseIndbHead.SetRange("Completely Received", true);
            if recWhseIndbHead.FindSet(true) then
                repeat
                    recWhseIndbHead.Validate("Document Status", recWhseIndbHead."document status"::Posted);
                    recWhseIndbHead.Modify(true);
                until recWhseIndbHead.Next() = 0;

            //  // Handling normal invoices
            //  recDelDocHead.SETRANGE("Document Status",recDelDocHead."Document Status"::Released);
            //  recDelDocHead.SETRANGE("Sales Invoice is Created",FALSE);
            //  recDelDocHead.SETRANGE("Warehouse Status",recDelDocHead.GetWhseStatusToInvoiceOn,recDelDocHead."Warehouse Status"::Delivered);
            //  IF RunningAutomation THEN  // 28-08-20 ZY-LD 002
            //    recDelDocHead.SETRANGE("Automatic Invoice Handling",recDelDocHead."Automatic Invoice Handling"::"Create Invoice",recDelDocHead."Automatic Invoice Handling"::"Create and Post Invoice");
            //  IF pDelDocNo <> '' THEN
            //    recDelDocHead.SETRANGE("No.",pDelDocNo);
            //  recDelDocHead.SETAUTOCALCFIELDS("Automatic Invoice Handling");
            //  IF recDelDocHead.FINDSET THEN BEGIN
            //    ZGT.OpenProgressWindow('',recDelDocHead.COUNT);
            //    REPEAT
            //      ZGT.UpdateProgressWindow(recDelDocHead."No.",0,TRUE);
            //
            //      IF CreateInvoice(pPostInvoice,recDelDocHead) THEN;
            //    UNTIL recDelDocHead.Next() = 0;
            //    ZGT.CloseProgressWindow;
            //  END;
            //
            //  // Handling "Waiting for Invoice"
            //  recDelDocHead.RESET;
            //  recDelDocHead.SETRANGE("Document Status",recDelDocHead."Document Status"::Released);
            //  recDelDocHead.SETRANGE("Sales Invoice is Created",FALSE);
            //  recDelDocHead.SETRANGE("Warehouse Status",recDelDocHead."Warehouse Status"::"Waiting for invoice");
            //  IF RunningAutomation THEN  // 28-08-20 ZY-LD 002
            //    recDelDocHead.SETRANGE("Automatic Invoice Handling",recDelDocHead."Automatic Invoice Handling"::"Create Invoice",recDelDocHead."Automatic Invoice Handling"::"Create and Post Invoice");
            //  IF pDelDocNo <> '' THEN
            //    recDelDocHead.SETRANGE("No.",pDelDocNo);
            //  recDelDocHead.SETAUTOCALCFIELDS("Automatic Invoice Handling");
            //  IF recDelDocHead.FINDSET THEN BEGIN
            //    ZGT.OpenProgressWindow('',recDelDocHead.COUNT);
            //    REPEAT
            //      ZGT.UpdateProgressWindow(recDelDocHead."No.",0,TRUE);
            //
            //      IF CreateInvoice(pPostInvoice,recDelDocHead) THEN
            //        IF recDelDocHead."Automatic Invoice Handling" = recDelDocHead."Automatic Invoice Handling"::"Create and Post Invoice" THEN BEGIN
            //          recSalesHead.SETRANGE("Picking List No.",recDelDocHead."No.");
            //          IF recSalesHead.FINDFIRST AND recSalesHead."Send Mail" THEN BEGIN
            //            recDelDocHead.GET(recDelDocHead."No.");  // 06-02-20 ZY-LD 001
            //            recDelDocHead."Send Invoice When Delivered" := TRUE;
            //            recDelDocHead.MODIFY;
            //          END;
            //        END;
            //    UNTIL recDelDocHead.Next() = 0;
            //    ZGT.CloseProgressWindow;
            //  END;
            //
            //  // Handle previous "Waiting for Invoice" and send e-mail to the customer.
            //  recDelDocHead.RESET;
            //  recDelDocHead.SETRANGE("Document Status",recDelDocHead."Document Status"::Posted);
            //  recDelDocHead.SETFILTER("Warehouse Status",'%1|%2',recDelDocHead.GetWhseStatusToInvoiceOn,recDelDocHead."Warehouse Status"::Delivered);
            //  recDelDocHead.SETRANGE("Document Type",recDelDocHead."Document Type"::Sales);
            //  recDelDocHead.SETRANGE("Send Invoice When Delivered",TRUE);
            //  IF pDelDocNo <> '' THEN
            //    recDelDocHead.SETRANGE("No.",pDelDocNo);
            //  IF recDelDocHead.FINDSET THEN
            //    REPEAT
            //      // Create in e-mail queue here.
            //      recSalesInvHead.SETRANGE("Picking List No.",recDelDocHead."No.");
            //      recSalesInvHead.FINDFIRST;
            //      CLEAR(recSalesDocEmail);
            //      recSalesDocEmail.INIT;
            //      recSalesDocEmail.VALIDATE("Document Type",recSalesDocEmail."Document Type"::"Posted Sales Invoice");
            //      recSalesDocEmail.VALIDATE("Document No.",recSalesInvHead."No.");
            //      recSalesDocEmail.INSERT(TRUE);
            //
            //      recDelDocHead."Send Invoice When Delivered" := FALSE;
            //      recDelDocHead.MODIFY;
            //
            //      IF pDelDocNo <> '' THEN
            //        MESSAGE(lText004,recSalesInvHead."No.");
            //    UNTIL recDelDocHead.Next() = 0;
        end;
    end;

    local procedure CreateInvoice(pPostInvoice: Boolean; var pDelDocHead: Record "VCK Delivery Document Header"): Boolean
    var
        recSalesHead: Record "Sales Header";
        CombineShipmentsZX: Report "Combine Shipments ZX";
    begin
        if pDelDocHead."Automatic Invoice Handling" = pDelDocHead."automatic invoice handling"::"Create Invoice" then
            pPostInvoice := false;

        recSalesHead.SetRange("Completely Invoiced", false);
        recSalesHead.SetRange("Sell-to Customer No.", pDelDocHead."Sell-to Customer No.");
        recSalesHead.SetRange("Picking List No. Filter", pDelDocHead."No.");
        CombineShipmentsZX.SetTableView(recSalesHead);
        if ZGT.IsZNetCompany then  // 18-09-20 ZY-LD 003
            CombineShipmentsZX.InitializeRequest(Today, Today, false, pPostInvoice, false, false)
        else
            CombineShipmentsZX.InitializeRequest(Today, Today, false, pPostInvoice, false, not pPostInvoice or not RunningAutomation);  // 18-09-20 ZY-LD 003
        CombineShipmentsZX.SetHideDialog(true);
        CombineShipmentsZX.UseRequestPage(false);
        CombineShipmentsZX.RunModal();

        exit(true);
    end;

    local procedure UpdateDD()
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recDelDocLine: Record "VCK Delivery Document Line";
        recSalesLine: Record "Sales Line";
        AllPosted: Boolean;
    begin
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Released);
        recDelDocHead.SetRange("Warehouse Status", recDelDocHead."warehouse status"::Delivered);
        recDelDocHead.SetRange("Is Invoiced", true);
        recDelDocHead.SetRange("Document Type", recDelDocHead."document type"::Sales);
        if recDelDocHead.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recDelDocHead.Count());
            repeat
                ZGT.UpdateProgressWindow(recDelDocHead."No.", 0, true);

                recDelDocHead."Document Status" := recDelDocHead."document status"::Posted;
                recDelDocHead.Modify();
            until recDelDocHead.Next() = 0;
            ZGT.CloseProgressWindow;
            Commit();
        end;

        recDelDocHead.Reset();
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Released);
        recDelDocHead.SetRange("Warehouse Status", recDelDocHead."warehouse status"::Delivered);
        recDelDocHead.SetRange("Document Type", recDelDocHead."document type"::Sales);
        if recDelDocHead.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recDelDocHead.Count());
            repeat
                ZGT.UpdateProgressWindow(recDelDocHead."No.", 0, true);

                AllPosted := true;
                recDelDocLine.SetRange("Document No.", recDelDocHead."No.");
                if recDelDocLine.FindSet() then
                    repeat
                        recSalesLine.Get(recSalesLine."document type"::Order, recDelDocLine."Sales Order No.", recDelDocLine."Sales Order Line No.");
                        if recSalesLine."Quantity Invoiced" <> recSalesLine.Quantity then
                            AllPosted := false;
                    until recDelDocLine.Next() = 0;

                if AllPosted then begin
                    recDelDocHead."Document Status" := recDelDocHead."document status"::Posted;
                    recDelDocHead.Modify();
                end;
            until recDelDocHead.Next() = 0;
            ZGT.CloseProgressWindow;
            Commit();
        end;
    end;


    procedure ProcessCreditMemo(pWhseIndbNo: Code[20]; pPostCreditMemo: Boolean; RunConfirm: Boolean)
    var
        recWhseIndbHead: Record "Warehouse Inbound Header";
        Process: Boolean;
        lText001: Label 'Do you want to create credit memos?';
        lText002: Label 'Do you want to create and post credit memo on warehouse inbound %1?';
        lText003: Label 'Do you want to create credit memo on warehouse inbound %1?';
        lText004: Label 'The credit memo %1 is succesfully added to the e-mail queue.';
    begin
        if RunConfirm then begin
            if pWhseIndbNo <> '' then begin
                if pPostCreditMemo then
                    Process := Confirm(lText002, true, pWhseIndbNo)
                else
                    Process := Confirm(lText003, true, pWhseIndbNo);
            end else
                Process := Confirm(lText001, true);
        end else
            Process := true;

        if Process then begin
            recWhseIndbHead.SetRange("Document Status", recWhseIndbHead."document status"::Released);
            recWhseIndbHead.SetRange("Sales Credit Memo is Created", false);
            recWhseIndbHead.SetRange("Warehouse Status", recWhseIndbHead."warehouse status"::"On Stock");
            recWhseIndbHead.SetRange("Automatic Invoice Handling", recWhseIndbHead."automatic invoice handling"::"Create Invoice", recWhseIndbHead."automatic invoice handling"::"Create and Post Invoice");
            if pWhseIndbNo <> '' then
                recWhseIndbHead.SetRange("No.", pWhseIndbNo);
            recWhseIndbHead.SetAutoCalcFields("Automatic Invoice Handling");
            if recWhseIndbHead.FindSet() then begin
                ZGT.OpenProgressWindow('', recWhseIndbHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(recWhseIndbHead."No.", 0, true);

                    if CreateCreditMemo(pPostCreditMemo, recWhseIndbHead) then;
                until recWhseIndbHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        end;
    end;

    local procedure CreateCreditMemo(pPostCreditMemo: Boolean; var pWhseIndbHead: Record "Warehouse Inbound Header"): Boolean
    var
        recSalesHead: Record "Sales Header";
        CombineReturnReceipts: Report "Combine Return Receipts";
    begin
        if pWhseIndbHead."Automatic Invoice Handling" = pWhseIndbHead."automatic invoice handling"::"Create Invoice" then
            pPostCreditMemo := false;

        recSalesHead.SetRange("Completely Invoiced", false);
        recSalesHead.SetRange("Sell-to Customer No.", pWhseIndbHead."Sender No.");
        recSalesHead.SetRange("No.", pWhseIndbHead."Container No.");
        CombineReturnReceipts.SetTableView(recSalesHead);
        CombineReturnReceipts.InitializeRequestZX(Today, Today, false, pPostCreditMemo);
        CombineReturnReceipts.UseRequestPage(false);
        CombineReturnReceipts.RunModal;

        exit(true);
    end;

    local procedure UpdateWarehouseInbound()
    begin
    end;
}
