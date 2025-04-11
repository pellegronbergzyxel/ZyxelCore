codeunit 50018 "Process eCommerce"
{
    trigger OnRun()
    begin
        recAutoSetup.Get();

        // If invoices has been created, but not posted we post them before we import the next.
        if recAutoSetup.CreateSalesDocOneCommerceOrder and recAutoSetup."Post Prev. Created Sales Doc." then begin
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::Invoice);
            recSalesHead.SetRange("eCommerce Order", true);
            if recSalesHead.FindFirst() then begin

                BatchPostSalesInvoices.SetTableView(recSalesHead);
                BatchPostSalesInvoices.UseRequestPage(false);
                BatchPostSalesInvoices.RunModal;
            end;

            recSalesHead.SetRange("Document Type", recSalesHead."document type"::"Credit Memo");
            recSalesHead.SetRange("eCommerce Order", true);
            if recSalesHead.FindFirst() then begin
                BatchPostSalesCreditMemos.SetTableView(recSalesHead);
                BatchPostSalesCreditMemos.UseRequestPage(false);
                BatchPostSalesCreditMemos.RunModal;
            end;
        end;

        if recAutoSetup.ImporteCommerceOrders then
            eCommerceApiMgt.Run;

        if recAutoSetup.CreateSalesDocOneCommerceOrder then begin
            Clear(BatchPosteCommerceOrders);
            BatchPosteCommerceOrders.InitReport(recAutoSetup.PosteCommerceOrders, Today, true, false);
            BatchPosteCommerceOrders.UseRequestPage(false);
            BatchPosteCommerceOrders.RunModal;
        end;
    end;

    var
        recAutoSetup: Record "Automation Setup";
        recSalesHead: Record "Sales Header";
        BatchPosteCommerceOrders: Report "Batch Post eCommerce Orders";
        BatchPostSalesInvoices: Report "Batch Post Sales Invoices";
        BatchPostSalesCreditMemos: Report "Batch Post Sales Credit Memos";
        eCommerceApiMgt: Codeunit "API Management";

    [EventSubscriber(ObjectType::Report, Report::"Batch Post Sales Invoices", 'OnAfterOnOpenPage', '', false, false)]
    local procedure BatchPostSalesInvoices_OnAfterOnOpenPage(var CalcInvDisc: Boolean; var ReplacePostingDate: Boolean; var ReplaceDocumentDate: Boolean; var PrintDoc: Boolean; var PrintDocVisible: Boolean; var PostingDateReq: Date; var ReplaceVATDateReq: Boolean; var VATDateReq: Date)
    begin
        ReplacePostingDate := true;
        PostingDateReq := today;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Batch Post Sales Credit Memos", 'OnAfterOnOpenPage', '', false, false)]
    local procedure BatchPostSalesCreditMemos_OnAfterOnOpenPage(var CalcInvDisc: Boolean; var ReplacePostingDate: Boolean; var ReplaceDocumentDate: Boolean; var PrintDoc: Boolean; var PrintDocVisible: Boolean; var PostingDateReq: Date; var ReplaceVATDateReq: Boolean; var VATDateReq: Date)
    begin
        ReplacePostingDate := true;
        PostingDateReq := today;
    end;

}
