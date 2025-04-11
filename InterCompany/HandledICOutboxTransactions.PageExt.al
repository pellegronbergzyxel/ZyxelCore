pageextension 50221 HandledICOutboxTransactionsZX extends "Handled IC Outbox Transactions"
{
    layout
    {
        addafter("Document Date")
        {
            field(AmountInclVAT; AmountInclVAT)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Amount Incl. VAT';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;

    trigger OnAfterGetRecord()
    begin
        AmountInclVAT := CalcAmount();
    end;

    var
        AmountInclVAT: Decimal;

    local procedure CalcAmount(): Decimal
    var
        lHandledICOutboxSalesLine: Record "Handled IC Outbox Sales Line";
    begin
        lHandledICOutboxSalesLine.SetRange("IC Transaction No.", Rec."Transaction No.");
        if lHandledICOutboxSalesLine.FindFirst() then begin
            lHandledICOutboxSalesLine.CalcSums("Amount Including VAT");
            exit(lHandledICOutboxSalesLine."Amount Including VAT");
        end;
    end;
}
