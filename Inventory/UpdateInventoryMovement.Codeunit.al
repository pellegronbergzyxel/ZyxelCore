Codeunit 62013 "Update Inventory Movement"
{
    // // Inventory Movement is a table used by HQ in Taiwan. This codeunit updates this table.


    trigger OnRun()
    begin
        recAutoSetup.Get;
        if GuiAllowed then begin
            if Confirm(lText001, true) then
                Process;
        end else
            if recAutoSetup.AutomationAllowed then
                Process;
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: label 'Do you want to update "Inventory Movements"?';

    local procedure Process()
    var
        recDate: Record Date;
        MRInventoryTemplate: Report "MR Inventory Template";
        BaseDate: Date;
    begin
        recDate.SetRange("Period Type", recDate."period type"::Month);
        recDate.SetFilter("Period Start", '%1..%2', CalcDate('<-CM-6M>', Today), CalcDate('<CM-1M>', Today));
        if recDate.FindFirst then begin
            ZGT.OpenProgressWindow('', recDate.Count);
            repeat
                BaseDate := CalcDate('<CM>', recDate."Period Start");
                ZGT.UpdateProgressWindow(Format(BaseDate), 0, true);

                Clear(MRInventoryTemplate);
                MRInventoryTemplate.InitReport(BaseDate, false, false, false, true, false);
                MRInventoryTemplate.UseRequestPage(false);
                MRInventoryTemplate.RunModal;
            until recDate.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;
}
