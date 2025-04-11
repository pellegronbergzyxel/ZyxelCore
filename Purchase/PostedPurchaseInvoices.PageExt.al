pageextension 50162 PostedPurchaseInvoicesZX extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field(VATAmount; VATAmount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Amount';
                DecimalPlaces = 2 : 2;
            }
        }
        addafter("Shipment Method Code")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 27-10-17 ZY-LD 001
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Amount Including VAT", Amount);
        VATAmount := Rec."Amount Including VAT" - Rec.Amount;
    end;

    var
        VATAmount: Decimal;
}
