Codeunit 62011 "Download Battery Certificate"
{

    trigger OnRun()
    begin
        recAutoSetup.Get;
        if recAutoSetup.AutomationAllowed then
            ProcessDownload('', 0);
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure ProcessDownload(pItemNo: Code[20]; pEntryNo: Integer)
    var
        recBatCert: Record "Battery Certificate";
    begin
        recBatCert.LockTable;
        recBatCert.SetFilter("File Path", '%1', '');
        if pItemNo <> '' then begin
            recBatCert.SetRange("Item No.", pItemNo);
            recBatCert.SetRange("Entry No.", pEntryNo);
        end;
        if recBatCert.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recBatCert.Count);

            repeat
                ZGT.UpdateProgressWindow(recBatCert."Item No.", 0, true);
                recBatCert.DownloadDocument;
            until recBatCert.Next() = 0;

            ZGT.CloseProgressWindow;
        end;

    end;
}
