pageextension 50183 ReminderListZX extends "Reminder List"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Reminder Level"; Rec."Reminder Level")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Reminder Terms Code"; Rec."Reminder Terms Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
