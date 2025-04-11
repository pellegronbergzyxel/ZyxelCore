Codeunit 50056 "Job Queue Event"
{
    // 001. 27-06-19 ZY-LD 000 - Send only from production.
    // 002. 05-04-24 ZY-LD 000 - On the general jobs we want a dedicated user to run the job, and not the user that has started the job.

    trigger OnRun()
    begin
    end;

    #region Job Queue Entry
    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure JobQueueEntry_OnBeforeModify(var Rec: Record "Job Queue Entry"; var xRec: Record "Job Queue Entry")
    begin
        // The field is cleared so mail can be sent next time an error occur.
        if (Rec."Last Support Mail Sent" <> 0DT) and (Rec.Status <> Rec.Status::Error) then
            Rec."Last Support Mail Sent" := 0DT;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnScheduleTaskOnAfterCalcShouldChangeUserID', '', false, false)]
    local procedure OnScheduleTaskOnAfterCalcShouldChangeUserID(var JobQueueEntry: Record "Job Queue Entry"; var ShouldChangeUserID: Boolean)
    var
        AutoSetup: Record "Automation Setup";
    begin
        //>> 05-04-24 ZY-LD 002
        AutoSetup.get;
        if AutoSetup."Default Job Queue User" <> '' then begin
            If JobQueueEntry."Job Queue Category Code" IN ['ZCOM', 'ZNET', 'ZYXEL'] then begin
                JobQueueEntry."User ID" := AutoSetup."Default Job Queue User";
                JobQueueEntry.Modify(true);
            end;
        end;
        //<< 05-04-24 ZY-LD 002
    end;
    #endregion

    #region Job Queue Log Entry
    [EventSubscriber(ObjectType::Table, Database::"Job Queue Log Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsert(var Rec: Record "Job Queue Log Entry"; RunTrigger: Boolean)
    begin
        if Rec.Status = Rec.Status::Error then
            SendEmailToNavSupport(Rec.Description, Rec."Error Message");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Log Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModify(var Rec: Record "Job Queue Log Entry"; var xRec: Record "Job Queue Log Entry"; RunTrigger: Boolean)
    begin
        if Rec.Status = Rec.Status::Error then
            SendEmailToNavSupport(Rec.Description, Rec."Error Message");
    end;

    local procedure SendEmailToNavSupport(pDescription: Text; pErrorMessage: Text)
    var
        lEmailAdd: Record "E-mail address";
        recServEnviron: Record "Server Environment";
        recAccJobQueErrMessage: Record "Acc. Job Queue Error Message";
        lText001: label 'Error on task "%1". (%2).';
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        SendEmail: Boolean;
    begin
        if recServEnviron.ProductionEnvironment then begin  // 27-06-19 ZY-LD 001
            SendEmail := true;
            if recAccJobQueErrMessage.FindSet then
                repeat
                    if StrPos(pErrorMessage, recAccJobQueErrMessage.Message) <> 0 then
                        SendEmail := false;
                until (recAccJobQueErrMessage.Next() = 0) or not SendEmail;

            if SendEmail then
                if lEmailAdd.Get('JOBQUEUE') then begin
                    SI.SetMergefield(100, StrSubstNo(lText001, pDescription, pErrorMessage));
                    EmailAddMgt.CreateSimpleEmail(lEmailAdd.Code, '', '');
                    EmailAddMgt.Send;
                end;
        end;
    end;
    #endregion
}
