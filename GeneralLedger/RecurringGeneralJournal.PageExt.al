pageextension 50168 RecurringGeneralJournalZX extends "Recurring General Journal"
{
    layout
    {
        addafter(Comment)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
