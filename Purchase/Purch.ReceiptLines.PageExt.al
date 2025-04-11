pageextension 50263 PurchReceiptLinesZX extends "Purch. Receipt Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 21-01-22 ZY-LD 001
    end;
}
