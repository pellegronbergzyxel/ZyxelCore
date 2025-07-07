Codeunit 62024 "Job Queue Monitor"
{
    // 001. 05-10-20 ZY-LD 000 - Created hartbeat to avoid NAV not running.
    // 002. 21-12-20 ZY-LD 000 - Two new messages that needs to be set to ready.
    // 003. 29-03-21 ZY-LD 000 - Two new messages that needs to be set to ready.
    // 004. 17-06-22 ZY-LD 000 - It happens that a job get stock in "In Process". We reset the job to "Ready" after an hour.
    // 005. 17-07-24 ZY-LD 000 - Send mail has been moved and validated against a date.

    trigger OnRun()
    begin
        Monitor(true);
        Heartbeat;  // 05-10-20 ZY-LD 001
    end;

    local procedure Monitor(RunMonitor: Boolean)
    var
        recJobQueCat: Record "Job Queue Category";
        recJobQueEntry: Record "Job Queue Entry";
        recJobQueLogEntry: Record "Job Queue Log Entry";
        recEmailAdd: Record "E-mail address";
        recAccJobQErrMessage: Record "Acc. Job Queue Error Message";
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SendEmail: Boolean;
        lText001: label 'The "Job Queue" %1 are not running.<br><br>';
    begin
        if ZGT.IsRhq then
            if (not GuiAllowed and RunMonitor) or (GuiAllowed and ZGT.UserIsDeveloper) then
                if recEmailAdd.Get('JOBQUEUE') then begin
                    // IF a process is stocked with status "In Process" for more than 60 min, it will be set to ready.
                    recJobQueEntry.SetRange("Job Queue Category Code", recJobQueCat.Code);
                    recJobQueEntry.SetRange(Status, recJobQueEntry.Status::"In Process");
                    recJobQueEntry.SetFilter("User Session Started", '<%1', CreateDatetime(Today, Time - (1000 * 60 * 60)));
                    if recJobQueEntry.FindSet(true) then
                        repeat
                            recJobQueEntry.Restart();  // 15-07-24 ZY-LD 000
                        until recJobQueEntry.Next() = 0;


                    // We have seen entries with status ready but scheduled = false;
                    recJobQueEntry.Reset;
                    recJobQueEntry.SetRange(Status, recJobQueEntry.Status::Ready);
                    recJobQueEntry.SetRange(Scheduled, false);
                    if recJobQueEntry.FindSet() then
                        repeat
                            recJobQueEntry.Restart();
                        until recJobQueEntry.Next = 0;

                    // If a process has status Error, it will be restarted if it´s an accepted error. If not, a mail will be sent.
                    recJobQueEntry.Reset;
                    recJobQueEntry.SetRange(Status, recJobQueEntry.Status::Error);
                    if recJobQueEntry.FindSet(true) then begin
                        repeat
                            recJobQueLogEntry.SetRange(ID, recJobQueEntry.ID);
                            if recJobQueLogEntry.FindLast then
                                if recAccJobQErrMessage.FindSet then begin
                                    SendEmail := true;
                                    repeat
                                        if StrPos(UpperCase(recJobQueLogEntry."Error Message"), UpperCase(recAccJobQErrMessage.Message)) <> 0 then begin
                                            recJobQueEntry.Restart();
                                            SendEmail := false;
                                        end else begin
                                            SI.SetMergefield(101, Format(recJobQueEntry."Object Type to Run"));
                                            SI.SetMergefield(102, Format(recJobQueEntry."Object ID to Run"));
                                            SI.SetMergefield(103, CopyStr(recJobQueLogEntry."Error Message", 1, 250));
                                        end;
                                    until (recAccJobQErrMessage.Next() = 0) or (not SendEmail);
                                end;

                            if SendEmail and not GuiAllowed then begin
                                if DT2Date(recJobQueEntry."Last Support Mail Sent") < today then begin
                                    Clear(EmailAddMgt);
                                    EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
                                    EmailAddMgt.Send;
                                    recJobQueEntry."Last Support Mail Sent" := CurrentDateTime;
                                    recJobQueEntry.Modify;
                                end;
                            end;

                        until recJobQueEntry.Next() = 0;
                    end;
                end;
    end;

    local procedure Heartbeat()
    var
        recEmailAdd: Record "E-mail address";
        recJobQueueLog: Record "Job Queue Log Entry";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
    begin

        if ZGT.IsRhq then
            if (Time >= 060000T) and (Time <= 210000T) then
                if recEmailAdd.Get('HARTBEAT') then begin
                    recJobQueueLog.SetCurrentkey("Start Date/Time", ID);
                    if recJobQueueLog.FindLast and ((CurrentDatetime - recJobQueueLog."Start Date/Time") > (1000 * 60 * 60)) then begin  // One hour
                        EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
                        EmailAddMgt.Send;
                    end;
                end;

    end;
}
