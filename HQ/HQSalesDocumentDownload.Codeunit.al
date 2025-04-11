Codeunit 62012 "HQ Sales Document Download"
{
    // 001. 01-09-21 ZY-LD 000 - Web service call is added.


    trigger OnRun()
    var
        recHqInvHead: Record "HQ Invoice Header";
        AutoSetup: Record "Automation Setup";
        EmailAdd: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        MailIsSent: Boolean;
    begin
        begin
            AutoSetup.get;
            recHqInvHead.LockTable;

            //recHqInvHead.SETRANGE(Type,recHqInvHead.Type::Normal);
            recHqInvHead.SetFilter(recHqInvHead."File Path", '%1', '');
            if recHqInvHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recHqInvHead.Count);

                repeat
                    ZGT.UpdateProgressWindow(recHqInvHead."No.", 0, true);

                    if (recHqInvHead.Type = recHqInvHead.Type::Normal) or
                       ((recHqInvHead.Type = recHqInvHead.Type::EiCard) and (recHqInvHead.Status = recHqInvHead.Status::"Document is Posted"))
                    then
                        if recHqInvHead.DownloadDocument(false) then
                            if (recHqInvHead.Type = recHqInvHead.Type::Normal) and (AutoSetup."Received HQ Sales Invoice Mail" <> '') then begin
                                SI.SetMergefield(100, recHqInvHead."No.");
                                Clear(EmailAdd);
                                EmailAdd.CreateEmailWithAttachment(AutoSetup."Received HQ Sales Invoice Mail", '', '', recHqInvHead."File Path" + recHqInvHead.Filename, recHqInvHead.Filename, false);
                                EmailAdd.Send;
                                if AutoSetup."Send Only One Received Mail" then
                                    MailIsSent := true;
                            end;
                until (recHqInvHead.Next() = 0) OR MailIsSent;

                ZGT.CloseProgressWindow;
            end;
        end;

        ZyWebServMgt.ProcessHqSalesDocument;  // 01-09-21 ZY-LD 001
    end;

}
