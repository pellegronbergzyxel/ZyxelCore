report 50006 "Update Test and Dev. Database"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Update Test and Dev. Database';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;

    trigger OnPreReport()
    begin
        //Codeunit.Run(Codeunit::"Update Test and Dev. Database");
        RunUpdate();
        CurrReport.Quit();
    end;

    local procedure RunUpdate()
    var
        Comp: Record Company;
        CompInfo: Record "Company Information";
        JobQueueEntry: Record "Job Queue Entry";
        ServerEnvironment: Record "Server Environment";
        recPurchSetup: Record "Purchases & Payables Setup";
        CRMConnectionSetup: Record "CRM Connection Setup";
        recFTPFolder: Record "FTP Folder";
        WebServSetup: Record "Web Service Setup";
        Choice: Integer;
        ZGT: Codeunit "ZyXEL General Tools";

        Text001: label 'Test,Develop';
        Text002: label 'Choose Database';
        Text003: label 'Do you want to change "System Indicator" on %1?';
        Text004: Label 'TST,DEV';
    begin
        Choice := StrMenu(Text001, 1, Text002);

        // Update system indicator
        if (Choice > 0) and Confirm(Text003, true, SelectStr(Choice, Text001)) then
            if Comp.FindSet then begin
                // Setup environment
                if Choice = 1 then
                    ServerEnvironment.Environment := ServerEnvironment.Environment::Test
                else
                    ServerEnvironment.Environment := ServerEnvironment.Environment::Development;
                if not ServerEnvironment.Modify then
                    ServerEnvironment.Insert;

                repeat
                    CompInfo.ChangeCompany(Comp.Name);
                    if CompInfo.Get then
                        if (CompInfo."System Indicator" <> CompInfo."system indicator"::"Custom") or
                           (StrPos(CompInfo."Custom System Indicator Text", UpperCase(SelectStr(Choice, Text004))) = 0)
                        then begin
                            CompInfo."System Indicator" := CompInfo."system indicator"::"Custom";
                            CompInfo."Custom System Indicator Text" := StrSubstNo('%1 %2', SelectStr(Choice, Text004), CopyStr(CompInfo."Custom System Indicator Text", 5, 2));
                            CompInfo.Modify;
                        end;

                    JobQueueEntry.ChangeCompany(comp.Name);
                    JobQueueEntry.ModifyAll(Status, JobQueueEntry.Status::"On Hold");

                    CRMConnectionSetup.ChangeCompany(Comp.Name);
                    CRMConnectionSetup.ModifyAll("Is Enabled", false);

                    recPurchSetup.ChangeCompany(Comp.Name);
                    if recPurchSetup.Get then begin
                        recPurchSetup."Send Orders To EShop" := false;
                        recPurchSetup.Modify;
                    end;

                    recFTPFolder.ChangeCompany(Comp.Name);
                    recFTPFolder.SetRange("Server Environment", recFTPFolder."server environment"::Production);
                    recFTPFolder.ModifyAll(Active, false);
                    recFTPFolder.SetRange("Server Environment", recFTPFolder."server environment"::Test);
                    recFTPFolder.ModifyAll(Active, true);

                    Comp."Display Name" := StrSubstNo('%1 %2', UpperCase(SelectStr(Choice, Text001)), Comp."Display Name");
                    Comp.Modify(true);

                    WebServSetup.ChangeCompany(Comp.Name);
                    if WebServSetup.FindSet() then
                        repeat
                            WebServSetup.HTTP := WebServSetup.HTTP::"http:";
                            WebServSetup."Server Name" := '';
                            WebServSetup."Port No." := '';
                            WebServSetup."Service Tier Name" := '';
                            WebServSetup.Modify();
                        until WebServSetup.Next() = 0;
                until Comp.Next() = 0;
            end;

        /*        // Set alle job queue entries to "On Hold".
                JobQueueEntry.ChangeCompany(ZGT.GetRHQCompanyName);
                JobQueueEntry.ModifyAll(Status, JobQueueEntry.Status::"On Hold");
                JobQueueEntry.ChangeCompany(ZGT.GetSistersCompanyName(1));
                JobQueueEntry.ModifyAll(Status, JobQueueEntry.Status::"On Hold");

                // CRM Connection
                CRMConnectionSetup.ChangeCompany(ZGT.GetRHQCompanyName);
                CRMConnectionSetup.ModifyAll("Is Enabled", false);
                CRMConnectionSetup.ChangeCompany(ZGT.GetSistersCompanyName(1));
                CRMConnectionSetup.ModifyAll("Is Enabled", false);

                // Update - Send orders to EShop
                recPurchSetup.ChangeCompany(ZGT.GetRHQCompanyName());
                recPurchSetup.Get;
                recPurchSetup."Send Orders To EShop" := false;
                recPurchSetup.Modify;
                recPurchSetup.ChangeCompany(ZGT.GetSistersCompanyName(1));
                recPurchSetup.Get;
                recPurchSetup."Send Orders To EShop" := false;
                recPurchSetup.Modify;

                // Update FTP Folders
                recFTPFolder.ChangeCompany(ZGT.GetRHQCompanyName);
                recFTPFolder.SetRange("Server Environment", recFTPFolder."server environment"::Production);
                recFTPFolder.ModifyAll(Active, false);
                recFTPFolder.ChangeCompany(ZGT.GetSistersCompanyName(1));
                recFTPFolder.SetRange("Server Environment", recFTPFolder."server environment"::Production);
                recFTPFolder.ModifyAll(Active, false);*/
    end;
}
