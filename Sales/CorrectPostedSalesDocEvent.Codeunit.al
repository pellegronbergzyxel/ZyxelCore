codeunit 50051 "Correct Post. Sales Doc. Event"
{
    // 12-02-24 ZY-LD 000 - If the month has been closed, the correction must be posted in the current month.    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnAfterCreateCorrectiveSalesCrMemo', '', false, false)]
    local procedure OnAfterCreateCorrectiveSalesCrMemo(SalesHeader: Record "Sales Header"; SalesInvoiceHeader: Record "Sales Invoice Header"; CancellingOnly: Boolean)
    var
        GenLedgSetup: Record "General Ledger Setup";
    begin
        //>> 12-02-24 ZY-LD 000
        GenLedgSetup.get;
        if SalesHeader."Posting Date" < GenLedgSetup."Allow Posting From" then
            SalesHeader.validate("Posting Date", WorkDate);
        //<< 12-02-24 ZY-LD 000
    end;
}
