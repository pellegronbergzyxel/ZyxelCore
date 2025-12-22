Codeunit 50045 "Process Sales Document E-mail"
{
    // 001. 28-01-21 ZY-LD P0559 - Customs Invoice.
    // 002. 20-11-23 ZY-LD 000 - Mark that the e-mail has been sent.
    // 003. 02-04-24 ZY-LD 000 - An error occur if we sent more than one with code per repeat. We haven´t located the issue yet, so this is a work around.

    trigger OnRun()
    begin
        if not GuiAllowed then begin
            recAutoSetup.Get;
            if recAutoSetup.SendSalesDocByEmailAutoAllowed then
                SendSalesInvoices(false);
        end else begin //11-12-2025 BK #545456
            if ServEnviron.TestEnvironment() then begin
                recAutoSetup.Get;
                if recAutoSetup.SendSalesDocByEmailAutoAllowed then
                    SendSalesInvoices(false);
            end;
        end;

    end;

    var
        recAutoSetup: Record "Automation Setup";
        SI: Codeunit "Single Instance";
        ServEnviron: Record "Server Environment";
        EmailAddMgt: Codeunit "E-mail Address Management";
        FileMgt: Codeunit "File Management";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SendSalesInvoices(WithConfirm: Boolean)
    var
        recSaleDocEmail: Record "Sales Document E-mail Entry";
        recSaleDocEmailSentToWhse: Record "Sales Document E-mail Entry";
        recSaleInvHead: Record "Sales Invoice Header";
        recCustRepSlct: Record "Custom Report Selection";
        recCust: Record Customer;
        recEltrDocFormat: Record "Electronic Document Format";
        recCountry: Record "Country/Region";
        SalesInvoiceZNet: Report "Sales - Invoice ZNet";
        CustomsInvZNet: Report "Sales - Customs Invoice ZNet";
        RecordVariant: Variant;
        RunBatch: Boolean;
        SentWithCode: Boolean;
        lText001: label 'Do you want to e-mail %1 invoice(s)?';
        ServerFilename: Text;
        EmailFilename: Text;


    begin
        recSaleDocEmail.SetRange("Document Type", recSaleDocEmail."document type"::"Posted Sales Invoice");
        recSaleDocEmail.SetFilter("Send E-mail at", '..%1', CurrentDatetime);
        recSaleDocEmail.SetFilter("On Hold", '%1', '');
        recSaleDocEmail.SetRange(Sent, false);
        if WithConfirm then
            RunBatch := Confirm(lText001, false, recSaleDocEmail.Count)
        else
            RunBatch := true;

        if RunBatch and recSaleDocEmail.FindSet(true) then begin
            recSaleDocEmail.LockTable;
            recSaleInvHead.LockTable;
            SI.SetHideReportDialog(true);
            ZGT.OpenProgressWindow('', recSaleDocEmail.Count);
            repeat
                ZGT.UpdateProgressWindow(recSaleDocEmail."Document No.", 0, true);

                if recSaleDocEmail."E-mail Address Code" = '' then begin
                    recSaleDocEmailSentToWhse.SetRange("Document Type", recSaleDocEmail."Document Type");
                    recSaleDocEmailSentToWhse.SetRange("Document No.", recSaleDocEmail."Document No.");
                    recSaleDocEmailSentToWhse.SetFilter("E-mail Address Code", '<>%1', '');

                    recSaleInvHead.SetRange("No.", recSaleDocEmail."Document No.");
                    recSaleInvHead.FindFirst;
                    if (recSaleInvHead."No. Printed" = 0) or
                       ((recSaleDocEmailSentToWhse.FindFirst) and (recSaleInvHead."No. Printed" = 1))
                    then begin
                        recCust.Get(recSaleInvHead."Bill-to Customer No.");
                        recCustRepSlct.SetRange("Source Type", Database::Customer);
                        recCustRepSlct.SetRange("Source No.", recSaleInvHead."Bill-to Customer No.");
                        recCustRepSlct.SetRange(Usage, recCustRepSlct.Usage::"S.Invoice");
                        if (recCustRepSlct.FindFirst and (recCustRepSlct."Send To Email" <> '')) or (recCust."E-Mail" <> '') then begin
                            recSaleInvHead.EmailRecords(false);
                            recSaleDocEmail."Created in Job Queue" := true;
                            recSaleDocEmail.Modify(true);
                            Commit;  // We don't want to send twice if other invoices gets an error.
                        end;
                    end else begin
                        //>> 20-11-23 ZY-LD 002
                        // The e-mail is added to the job queue, and should correctly be updated when actually sent. As a workaround Sent is set here in the flow.
                        // This should be made correct in the future.
                        if recSaleDocEmail."Created in Job Queue" then begin
                            recSaleDocEmail.Validate(Sent, true);
                            recSaleDocEmail.Modify(true);
                        end;
                        //<< 20-11-23 ZY-LD 002
                    end;
                end else
                    if not SentWithCode then begin  // 02-04-24 ZY-LD 003
                        ServerFilename := FileMgt.ServerTempFileName('');
                        RecordVariant := recSaleDocEmail;
                        EmailFilename := recEltrDocFormat.GetAttachmentFileName(RecordVariant, recSaleDocEmail."Document No.", Format(recSaleDocEmail."Document Type"), 'pdf');

                        recSaleInvHead.SetAutocalcFields("Picking List No.");
                        recSaleInvHead.Get(recSaleDocEmail."Document No.");
                        //>> 28-01-21 ZY-LD 001
                        if recCountry.Get(recSaleInvHead."Ship-to Country/Region Code") and
                           (recCountry."Customs Customer No." <> '')
                        then begin
                            Clear(CustomsInvZNet);
                            recSaleInvHead.SetRange("No.", recSaleDocEmail."Document No.");
                            CustomsInvZNet.SetTableview(recSaleInvHead);
                            CustomsInvZNet.UseRequestPage(false);
                            CustomsInvZNet.SetCustomsInvoice(true);
                            CustomsInvZNet.SaveAsPdf(ServerFilename);
                        end else begin  //<< 28-01-21 ZY-LD 001
                            Clear(SalesInvoiceZNet);
                            recSaleInvHead.SetRange("No.", recSaleDocEmail."Document No.");
                            SalesInvoiceZNet.SetTableview(recSaleInvHead);
                            SalesInvoiceZNet.UseRequestPage(false);
                            SalesInvoiceZNet.SaveAsPdf(ServerFilename);
                        end;

                        SI.SetMergefield(64, recSaleInvHead."Picking List No.");
                        EmailAddMgt.CreateEmailWithAttachment(
                          recSaleDocEmail."E-mail Address Code",
                          '',
                          '',
                          ServerFilename,
                          EmailFilename,
                          true);
                        EmailAddMgt.Send;

                        recSaleDocEmail.Validate(Sent, true);
                        recSaleDocEmail.Modify;

                        SentWithCode := true;  // 02-04-24 ZY-LD 003
                    end;
            until recSaleDocEmail.Next() = 0;
            ZGT.CloseProgressWindow;
            SI.SetHideReportDialog(false);
        end;
    end;

    procedure SendCreditMemos()
    var
        recSaleCrMemoHead: Record "Sales Cr.Memo Header";
        recCustRepSlct: Record "Custom Report Selection";
    begin
        recSaleCrMemoHead.SetRange("Send Mail", true);
        recSaleCrMemoHead.SetRange("No. Printed", 0);
        recSaleCrMemoHead.SetFilter(Amount, '>0');
        if recSaleCrMemoHead.FindSet then
            repeat
                recCustRepSlct.SetRange("Source Type", Database::Customer);
                recCustRepSlct.SetRange("Source No.", recSaleCrMemoHead."Bill-to Customer No.");
                recCustRepSlct.SetRange(Usage, recCustRepSlct.Usage::"S.Invoice");
                if recCustRepSlct.FindFirst and (recCustRepSlct."Send To Email" <> '') then
                    recSaleCrMemoHead.EmailRecords(false);
            until recSaleCrMemoHead.Next() = 0;
    end;
}
