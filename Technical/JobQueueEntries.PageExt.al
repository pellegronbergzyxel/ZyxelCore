pageextension 50230 JobQueueEntriesZX extends "Job Queue Entries"
{
    actions
    {
        addafter("Job &Queue")
        {
            group(Process)
            {
                Caption = 'Process';
                action("Process Job")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Process Job';
                    Image = Process;

                    trigger OnAction()
                    begin
                        //>> 17-03-20 ZY-LD 001
                        if Confirm(zText001, true, Rec.Description) then
                            case Rec."Object Type to Run" of
                                Rec."object type to run"::Codeunit:
                                    Codeunit.Run(Rec."Object ID to Run");
                                Rec."object type to run"::Report:
                                    Report.RunModal(Rec."Object ID to Run");
                            end;
                        //<< 17-03-20 ZY-LD 001
                    end;
                }
            }
        }
        addafter(ShowRecord)
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

    var
        zText001: Label 'Do you want to process job "%1"?';
}
