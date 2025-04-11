pageextension 50231 JobQueueLogEntriesZX extends "Job Queue Log Entries"
{
    actions
    {
        addfirst(navigation)
        {
            action(AccptedErrorMessage)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Accepted Error Messages';
                Image = PrevErrorMessage;
                RunObject = Page "Acc. Job Queue Error Messages";
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;  // 27-08-19 ZY-LD 001
    end;
}
