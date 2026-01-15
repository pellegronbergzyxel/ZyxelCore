Codeunit 62012 "HQ Sales Document Download"
{

    trigger OnRun()
    var
        recHqInvHead: Record "HQ Invoice Header";
        AutoSetup: Record "Automation Setup";
        EmailAdd: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";

    begin
        begin
            AutoSetup.get();
            recHqInvHead.LockTable();

            recHqInvHead.SetFilter(recHqInvHead."File Path", '%1', '');
            if recHqInvHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recHqInvHead.Count());

                repeat
                    ZGT.UpdateProgressWindow(recHqInvHead."No.", 0, true);

                    if (recHqInvHead.Type = recHqInvHead.Type::Normal) or
                       ((recHqInvHead.Type = recHqInvHead.Type::EiCard) and (recHqInvHead.Status = recHqInvHead.Status::"Document is Posted"))
                    then
                        if recHqInvHead.DownloadDocument(false) then
                            if (recHqInvHead.Type = recHqInvHead.Type::Normal) and (AutoSetup."Received HQ Sales Invoice Mail" <> '') then begin
                                SI.SetMergefield(100, recHqInvHead."No.");
                                Clear(EmailAdd);
                                EmailAdd.CreateEmailWithAttachment(copystr(AutoSetup."Received HQ Sales Invoice Mail", 1, 10), '', '', recHqInvHead."File Path" + recHqInvHead.Filename, recHqInvHead.Filename, false);
                                EmailAdd.Send();
                            end;
                until (recHqInvHead.Next() = 0); //0601-2026 BK #480772

                ZGT.CloseProgressWindow();
            end;
        end;

        ZyWebServMgt.ProcessHqSalesDocument();
    end;

}
