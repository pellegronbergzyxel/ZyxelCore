pageextension 50262 ItemChargeAssignmentPurchZX extends "Item Charge Assignment (Purch)"
{
    actions
    {
        modify(GetReceiptLines)
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
        }
        modify(SuggestItemChargeAssignment)
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
        }
    }
}
