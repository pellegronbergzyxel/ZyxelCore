Codeunit 50028 "ZyXEL Replication"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if ZGT.IsRhq and not ZGT.IsZNetCompany then
            if not GuiAllowed then
                Replicate
            else
                if Confirm(Text002) then
                    Replicate;
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        Text002: label 'Do you want to run Zyxel Replication?';

    local procedure Replicate()
    var
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        lText003: label 'Item';
    begin
        ZGT.OpenProgressWindow('', 3);

        ZGT.UpdateProgressWindow(lText003, 0, false);
        ZyWebSrvMgt.ReplicateItems('', '', false, false);  // Items pr. country
        ZyWebSrvMgt.ReplicateItems('', '', true, false);  // Dummy items
        ZGT.CloseProgressWindow;
    end;
}
