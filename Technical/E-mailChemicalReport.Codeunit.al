Codeunit 50013 "E-mail Chemical Report"
{

    trigger OnRun()
    begin
        Process;
    end;

    local procedure Process()
    var
        recCust: Record Customer;
        recSaleInvHead: Record "Sales Invoice Header";
        FileMgt: Codeunit "File Management";
        EmailAddmgt: Codeunit "E-mail Address Management";
        ChemicalReport: Report "Item Chemical Report";
        ServerFilename: Text;
        ServerFilename2: Text;
        ServerFilename3: Text;
        ClientFilename: Text;
        lText001: label 'Sales - Chemical Report.xlsx';
        lText002: label 'Search for SCIP documentation.pdf';
        lText003: label '\\ZYEU-NAVSQL02\NAV HTML Emails\';
        lText004: label 'List - Chemical Tax Reduction Rate.xlsx';
    begin
        recCust.SetRange("E-mail Chemical Report", true);
        recCust.SetFilter("E-mail for Chemical Report", '<>%1', '');
        if recCust.FindSet(true) then begin
            ServerFilename3 := FileMgt.ServerTempFileName('');
            Report.SaveAsExcel(Report::"Item - Chemical Tax Red. Rate", ServerFilename3);

            repeat
                if recCust."Last Chemical Report Sent" = 0D then
                    recCust."Last Chemical Report Sent" := CalcDate('<-1M>', WorkDate);

                if Date2dmy(recCust."Last Chemical Report Sent", 2) <> Date2dmy(WorkDate, 2) then begin
                    ServerFilename := FileMgt.ServerTempFileName('');
                    ClientFilename := lText001;

                    recSaleInvHead.SetRange("Sell-to Customer No.", recCust."No.");
                    recSaleInvHead.SetRange("Chemical Report Sent", false);
                    if recSaleInvHead.FindFirst then begin
                        Clear(ChemicalReport);
                        ChemicalReport.Init(true);
                        ChemicalReport.SetTableview(recSaleInvHead);
                        ChemicalReport.SaveAsExcel(ServerFilename);

                        Clear(EmailAddmgt);
                        EmailAddmgt.SetCustomerMergefields(recCust."No.");
                        EmailAddmgt.CreateEmailWithAttachment('CUSTCHMTAX', '', recCust."E-mail for Chemical Report", ServerFilename, ClientFilename, false);
                        EmailAddmgt.AddAttachment(ServerFilename3, lText004, false);
                        if FileMgt.ServerFileExists(lText003 + lText002) then
                            EmailAddmgt.AddAttachment(lText003 + lText002, lText002, false)
                        else begin
                            ServerFilename2 := lText003 + lText002;
                            EmailAddmgt.AddAttachment(ServerFilename2, lText002, false);
                        end;
                        EmailAddmgt.Send;

                        FileMgt.DeleteServerFile(ServerFilename);
                        FileMgt.DeleteServerFile(ServerFilename2);

                        recCust."Last Chemical Report Sent" := WorkDate;
                        recCust.Modify(true);
                    end;
                end;
            until recCust.Next() = 0;

            FileMgt.DeleteServerFile(ServerFilename3);
        end;
    end;
}
