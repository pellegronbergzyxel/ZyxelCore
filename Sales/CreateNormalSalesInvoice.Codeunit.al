codeunit 62003 "Create Normal Sales Invoice"
{
    // 001. 06-02-20 ZY-LD 2020020510000092 - DD is readen and mofified in CU 50080, therefore we need to read it again here.
    // 002. 28-08-20 ZY-LD 000 - It should be possible to create an invoice manually, without any information on the customer.
    // 003. 18-09-20 ZY-LD 003 - We want the the text lines from the sales order to be copied to the invoice if it´s a manual process.
    // 004. 15-09-21 ZY-LD 2021091010000059 - The test of e-mail is moved from 50067.
    // 005. 29-11-21 ZY-LD 2021112910000037 - We give order desk a warning to e-mail the shipping invoice to the warehouse or to set it up to be done automatic.
    // 006. 23-05-22 ZY-LD 2022052310000111 - Send only the reminder if it´s a country outside EU.
    // 007. 26-07-24 ZY-LD 000 - If it´s a sample account, another sell-to customer no. is used, and it can contain several 

    trigger OnRun()
    begin
        recAutoSetup.Get();
        RunningAutomation := true;
        if recAutoSetup.CreateSalesInvoiceNormalAllowed then
            ProcessInvoice('', recAutoSetup."Post Sales Invoice", false);
        //IF recAutoSetup.CreateSalesReturnOrderAllowed THEN
        //  Processcreditmemo('',recAutoSetup."Post Sales Credit Memo",FALSE);
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        CreateInvOnWhseStatus: Integer;
        RunningAutomation: Boolean;


    procedure ProcessInvoice(pDelDocNo: Code[20]; pPostInvoice: Boolean; RunConfirm: Boolean)
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recSalesHead: Record "Sales Header";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesDocEmail: Record "Sales Document E-mail Entry";
        recCust: Record Customer;
        recCountry: Record "Country/Region";
        recFinalDestCountry: Record "Country/Region";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
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
            // Handling normal invoices
            recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Released);
            recDelDocHead.SetRange("Sales Invoice is Created", false);
            recDelDocHead.SetRange("Warehouse Status", recDelDocHead.GetWhseStatusToInvoiceOn(true), recDelDocHead."warehouse status"::Delivered);
            if RunningAutomation then  // 28-08-20 ZY-LD 002
                recDelDocHead.SetRange("Automatic Invoice Handling", recDelDocHead."automatic invoice handling"::"Create Invoice", recDelDocHead."automatic invoice handling"::"Create and Post Invoice");
            if pDelDocNo <> '' then
                recDelDocHead.SetRange("No.", pDelDocNo);
            recDelDocHead.SetAutoCalcFields("Automatic Invoice Handling", "Run Auto. Inv. Hand. on WaitFI");
            if recDelDocHead.FindSet() then begin
                ZGT.OpenProgressWindow('', recDelDocHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(recDelDocHead."No.", 0, true);

                    if CreateInvoice(pPostInvoice, recDelDocHead) then;
                until recDelDocHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            // Handling "Waiting for Invoice"
            recDelDocHead.Reset();
            recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Released);
            recDelDocHead.SetRange("Sales Invoice is Created", false);
            recDelDocHead.SetRange("Warehouse Status", recDelDocHead."warehouse status"::"Waiting for invoice", recDelDocHead."warehouse status"::"Invoice Received");
            if RunningAutomation then  // 28-08-20 ZY-LD 002
                recDelDocHead.SetRange("Automatic Invoice Handling", recDelDocHead."automatic invoice handling"::"Create Invoice", recDelDocHead."automatic invoice handling"::"Create and Post Invoice");
            if pDelDocNo <> '' then
                recDelDocHead.SetRange("No.", pDelDocNo);
            recDelDocHead.SetAutoCalcFields("Automatic Invoice Handling");
            if recDelDocHead.FindSet() then begin
                ZGT.OpenProgressWindow('', recDelDocHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(recDelDocHead."No.", 0, true);

                    //>> 29-11-21 ZY-LD 005
                    recCountry.Get(recDelDocHead."Ship-to Country/Region Code");
                    if (recCountry."EU Country/Region Code" = '') or (recFinalDestCountry."EU Country/Region Code" = '') then begin
                        if (((not recCountry."E-mail Shipping Inv. to Whse.") and (recCountry."EU Country/Region Code" = '')) or  // 23-05-22 ZY-LD 006
                            ((not recFinalDestCountry."E-mail Shipping Inv. to Whse.") and (recFinalDestCountry."EU Country/Region Code" = ''))) and  // 23-05-22 ZY-LD 006
                           (recDelDocHead."Handle Waiting for Invoice" = 0DT)
                        then begin
                            Clear(EmailAddMgt);
                            SI.SetMergefield(100, recDelDocHead."No.");
                            SI.SetMergefield(101, recDelDocHead."Ship-to Country/Region Code");
                            EmailAddMgt.CreateSimpleEmail('LOGWAITINV', '', '');
                            EmailAddMgt.Send;
                            recDelDocHead."Handle Waiting for Invoice" := CurrentDatetime;
                            recDelDocHead.Modify(true);
                        end;
                    end;

                    recCust.Get(recDelDocHead."Sell-to Customer No.");
                    if (recCountry."E-mail Shipping Inv. to Whse." or recCust."E-mail Shipping Inv. to Whse.") and
                       not recDelDocHead."Customs/Shipping Invoice Sent"
                    then
                        recDelDocHead.EmailCustomsInvoice(false);
                    //<< 29-11-21 ZY-LD 005

                    if recDelDocHead."Run Auto. Inv. Hand. on WaitFI" then  //<< 29-11-21 ZY-LD 005
                        if CreateInvoice(pPostInvoice, recDelDocHead) then
                            if recDelDocHead."Automatic Invoice Handling" = recDelDocHead."automatic invoice handling"::"Create and Post Invoice" then begin
                                recSalesHead.SetRange("Picking List No.", recDelDocHead."No.");
                                if recSalesHead.FindFirst() and recSalesHead."Send Mail" then begin
                                    recDelDocHead.Get(recDelDocHead."No.");  // 06-02-20 ZY-LD 001
                                    recDelDocHead."Send Invoice When Delivered" := true;
                                    recDelDocHead.Modify();
                                end;
                            end;
                until recDelDocHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            // Handle previous "Waiting for Invoice" and send e-mail to the customer.
            recDelDocHead.Reset();
            recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Posted);
            recDelDocHead.SetFilter("Warehouse Status", '%1|%2', recDelDocHead.GetWhseStatusToInvoiceOn(true), recDelDocHead."warehouse status"::Delivered);
            recDelDocHead.SetRange("Document Type", recDelDocHead."document type"::Sales);
            recDelDocHead.SetRange("Send Invoice When Delivered", true);
            if pDelDocNo <> '' then
                recDelDocHead.SetRange("No.", pDelDocNo);
            if recDelDocHead.FindSet() then
                repeat
                    // Create in e-mail queue here.
                    recSalesInvHead.SetRange("Picking List No.", recDelDocHead."No.");
                    recSalesInvHead.FindFirst();
                    recCust.Get(recSalesInvHead."Sell-to Customer No.");  // 15-09-21 ZY-LD 004
                    if recCust."E-Mail" <> '' then begin  // 15-09-21 ZY-LD 004
                        Clear(recSalesDocEmail);
                        recSalesDocEmail.Init();
                        recSalesDocEmail.Validate("Document Type", recSalesDocEmail."document type"::"Posted Sales Invoice");
                        recSalesDocEmail.Validate("Document No.", recSalesInvHead."No.");
                        recSalesDocEmail.Insert(true);

                        if pDelDocNo <> '' then
                            Message(lText004, recSalesInvHead."No.");
                    end;

                    recDelDocHead."Send Invoice When Delivered" := false;
                    recDelDocHead.Modify();
                until recDelDocHead.Next() = 0;
        end;
    end;

    local procedure CreateInvoice(pPostInvoice: Boolean; var pDelDocHead: Record "VCK Delivery Document Header"): Boolean
    var
        recSalesHead: Record "Sales Header";
        Cust: Record Customer;
        SI: Codeunit "Single Instance";
        CombineShipmentsZX: Report "Combine Shipments ZX";
    begin
        if pDelDocHead."Automatic Invoice Handling" = pDelDocHead."automatic invoice handling"::"Create Invoice" then
            pPostInvoice := false;

        if Cust.Get(pDelDocHead."Sell-to Customer No.") and (not Cust."Sample Account") then  // 26-07-24 ZY-LD 007
            recSalesHead.SetRange("Sell-to Customer No.", pDelDocHead."Sell-to Customer No.");
        recSalesHead.SetRange("Completely Invoiced", false);
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
            if RunningAutomation then
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
        SI: Codeunit "Single Instance";
    begin
        if pWhseIndbHead."Automatic Invoice Handling" = pWhseIndbHead."automatic invoice handling"::"Create Invoice" then
            pPostCreditMemo := false;

        if GuiAllowed() then
            SI.SetHideSalesDialog(true);
        recSalesHead.SetRange("Completely Invoiced", false);
        recSalesHead.SetRange("Sell-to Customer No.", pWhseIndbHead."Sender No.");
        recSalesHead.SetRange("No.", pWhseIndbHead."Container No.");
        CombineReturnReceipts.SetTableView(recSalesHead);
        CombineReturnReceipts.InitializeRequestZX(Today, Today, false, pPostCreditMemo);
        CombineReturnReceipts.UseRequestPage(false);
        CombineReturnReceipts.RunModal;
        SI.SetHideSalesDialog(false);
        exit(true);
    end;

    local procedure UpdateWarehouseInbound()
    begin
    end;
}
