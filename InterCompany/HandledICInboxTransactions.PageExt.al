pageextension 50223 HandledICInboxTransactionsZX extends "Handled IC Inbox Transactions"
{
    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;
}
