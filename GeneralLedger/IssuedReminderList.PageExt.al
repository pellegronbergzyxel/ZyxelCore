pageextension 50184 IssuedReminderListZX extends "Issued Reminder List"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Reminder Level"; Rec."Reminder Level")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
