pageextension 50141 PurchCrMemoSubformZX extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("Location Code")
        {
            Editable = false;
        }
        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                PurchLineEvent.OnLookupPurchaseLineNo(Rec);  // 15-02-19 ZY-LD 001
            end;
        }
    }

    var
        PurchLineEvent: Codeunit "Purchase Header/Line Events";
}
