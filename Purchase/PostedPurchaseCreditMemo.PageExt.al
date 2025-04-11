pageextension 50156 PostedPurchaseCreditMemoZX extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Applies-to Doc. No.")
        {
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        NotAllowedErr: Label 'Delete not allowed!';
    begin
        Error(NotAllowedErr);
    end;
}
