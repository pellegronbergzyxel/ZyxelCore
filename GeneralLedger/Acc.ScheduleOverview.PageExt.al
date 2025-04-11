pageextension 50193 AccScheduleOverviewZX extends "Acc. Schedule Overview"
{
    actions
    {
        addafter("Update Existing Document")
        {
            action("G/L Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'G/L Entries';
                Image = ExportToExcel;

                trigger OnAction()
                var
                    ExpAccSchedEntrytoEx: Report "Exp. Acc. Sched. Entry to Ex.";
                begin
                    ExpAccSchedEntrytoEx.SetOptions(Rec, CurrentColumnName, UseAmtsInAddCurr);
                    ExpAccSchedEntrytoEx.Run();
                end;
            }
        }
    }
}
