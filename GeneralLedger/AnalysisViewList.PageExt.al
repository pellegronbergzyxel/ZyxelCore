pageextension 50211 AnalysisViewListZX extends "Analysis View List"
{
    layout
    {
        addafter("Include Budgets")
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
