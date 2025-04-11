pageextension 50268 PurchaseReturnOrderZX extends "Purchase Return Order"
{
    layout
    {
        addafter("No. of Archived Versions")
        {
            field(IsEICard; Rec.IsEICard)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
