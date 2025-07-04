codeunit 50031 InterCompanySubscriber
{
    [EventSubscriber(ObjectType::Table, Database::"IC Inbox Transaction", 'OnBeforeInboxCheckAccept', '', false, false)]
    local procedure ICInboxTransaction_OnBeforeInboxCheckAccept(var ICInboxTransaction: Record "IC Inbox Transaction"; var IsHandled: Boolean; xICInboxTransaction: Record "IC Inbox Transaction")
    var
        ICInboxTransaction2: Record "IC Inbox Transaction";
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
        ConfirmManagement: Codeunit "Confirm Management";
        ICjobqueu: codeunit "Cleanup Jobeueu";
        TransactionAlreadyExistsInInboxHandledQst: Label '%1 %2 has already been received from intercompany partner %3. Accepting it again will create a duplicate %1. Do you want to accept the %1?', Comment = '%1 - Document Type, %2 - Document No, %3 - IC parthner code';
        Text001: Label 'Transaction No. %2 is a copy of Transaction No. %1, which has already been set to Accept.\Do you also want to accept Transaction No. %2?';
    begin
        // 511511 >>
        ICjobqueu.betweenzNetzCom(ICInboxTransaction);
        // 511511 <<

        HandledICInboxTrans.SetRange("IC Partner Code", ICInboxTransaction."IC Partner Code");
        HandledICInboxTrans.SetRange("Document Type", ICInboxTransaction."Document Type");
        HandledICInboxTrans.SetRange("Source Type", ICInboxTransaction."Source Type");
        HandledICInboxTrans.SetRange("Document No.", ICInboxTransaction."Document No.");
        if HandledICInboxTrans.FindFirst() then
            if not ConfirmManagement.GetResponseOrDefault(
                StrSubstNo(
                    TransactionAlreadyExistsInInboxHandledQst, HandledICInboxTrans."Document Type",
                    HandledICInboxTrans."Document No.", HandledICInboxTrans."IC Partner Code"),
                true)
            then
                Error('');

        ICInboxTransaction2.SetRange("IC Partner Code", ICInboxTransaction."IC Partner Code");
        ICInboxTransaction2.SetRange("Document Type", ICInboxTransaction."Document Type");
        ICInboxTransaction2.SetRange("Source Type", ICInboxTransaction."Source Type");
        ICInboxTransaction2.SetRange("Document No.", ICInboxTransaction."Document No.");
        ICInboxTransaction2.SetFilter("Transaction No.", '<>%1', ICInboxTransaction."Transaction No.");
        ICInboxTransaction2.SetRange("IC Account Type", ICInboxTransaction."IC Account Type");
        ICInboxTransaction2.SetRange("IC Account No.", ICInboxTransaction."IC Account No.");
        ICInboxTransaction2.SetRange("Source Line No.", ICInboxTransaction."Source Line No.");
        ICInboxTransaction2.SetRange("Line Action", ICInboxTransaction."Line Action"::Accept);
        if ICInboxTransaction2.FindFirst() then
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(Text001, ICInboxTransaction2."Transaction No.", ICInboxTransaction."Transaction No."), true)
            then
                Error('');

        IsHandled := true;
    end;
}
