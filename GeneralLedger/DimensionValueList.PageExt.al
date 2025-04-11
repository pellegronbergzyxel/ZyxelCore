PageExtension 50212 DimensionValueListZX extends "Dimension Value List"
{
    layout
    {
        addafter("Consolidation Code")
        {
            field("HQ Expense Category"; Rec."HQ Expense Category")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;
}
