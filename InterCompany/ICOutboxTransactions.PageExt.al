pageextension 50220 ICOutboxTransactionsZX extends "IC Outbox Transactions"
{
    actions
    {
        modify(SendToICPartner)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Complete Line Actions")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        addafter("Complete Line Actions")
        {
            group("Create Outbox")
            {
                Caption = 'Create Outbox';
                Image = CreateDocuments;

                action("Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoice';
                    Image = CreateDocument;

                    trigger OnAction()
                    begin
                        CreateOutboxOnSalesInvoice();  // 18-10-19 ZY-LD 001
                    end;
                }
                action("Posted Sales Credit Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memo';
                    Image = CreateCreditMemo;

                    trigger OnAction()
                    begin
                        CreateOutboxOnSalesCrMemo();  // 18-10-19 ZY-LD 001
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;

    local procedure CreateOutboxOnSalesInvoice()
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lHandledICOutboxTrans: Record "Handled IC Outbox Trans.";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        lText001: Label 'Do you want to create an outbox transaction on "%1"?';
        lText002: Label 'Document "%1" is found in the "%2". Please handle it from there.';
    begin
        Page.RunModal(Page::"Posted Sales Invoices", lSalesInvoiceHeader)  // 18-10-19 ZY-LD 001
    end;

    local procedure CreateOutboxOnSalesCrMemo()
    var
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lHandledICOutboxTrans: Record "Handled IC Outbox Trans.";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        lText001: Label 'Do you want to create an outbox transaction on "%1"?';
        lText002: Label 'Document "%1" is found in the "%2". Please handle it from there.';
    begin
        Page.RunModal(Page::"Posted Sales Credit Memos", lSalesCrMemoHeader)  // 18-10-19 ZY-LD 001
    end;
}
