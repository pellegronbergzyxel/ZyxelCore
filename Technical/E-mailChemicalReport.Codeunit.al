Codeunit 50013 "E-mail Chemical Report"
{

    trigger OnRun()
    begin
        Process;
    end;

    local procedure Process()
    var
        recCust: Record Customer;
        tempblob: Codeunit "Temp Blob";
        tempblob3: codeunit "Temp Blob";
        varoutstream: outstream;
        varoutstream3: outstream;
        recSaleInvHead: Record "Sales Invoice Header";
        FileMgt: Codeunit "File Management";
        EmailAddmgt: Codeunit "E-mail Address Management";
        ChemicalReport: Report "Item Chemical Report";
        ServerFilename: Text;
        ServerFilename2: Text;
        ServerFilename3: Text;
        ClientFilename: Text;
        ReportParameters: text;
        lText001: label 'Sales - Chemical Report.xlsx';
        lText002: label 'Search for SCIP documentation.pdf';
        lText003: label '\\ZYEU-NAVSQL02\NAV HTML Emails\';
        lText004: label 'List - Chemical Tax Reduction Rate.xlsx';
    begin
        recCust.SetRange("E-mail Chemical Report", true);
        recCust.SetFilter("E-mail for Chemical Report", '<>%1', '');
        if recCust.FindSet(true) then begin
            tempblob3.CreateOutStream(varoutstream3);

            Report.SaveAs(Report::"Item - Chemical Tax Red. Rate", '', ReportFormat::Excel, varoutstream3);

            repeat
                if recCust."Last Chemical Report Sent" = 0D then
                    recCust."Last Chemical Report Sent" := CalcDate('<-1M>', WorkDate);

                if Date2dmy(recCust."Last Chemical Report Sent", 2) <> Date2dmy(WorkDate, 2) then begin
                    //ServerFilename := FileMgt.ServerTempFileName('');
                    ClientFilename := lText001;

                    recSaleInvHead.SetRange("Sell-to Customer No.", recCust."No.");
                    recSaleInvHead.SetRange("Chemical Report Sent", false);
                    if recSaleInvHead.FindFirst then begin
                        Clear(ChemicalReport);
                        Clear(tempblob);
                        clear(varoutstream);
                        tempblob.CreateOutStream(varoutstream);
                        ChemicalReport.Init(true);
                        ChemicalReport.SetTableview(recSaleInvHead);
                        ChemicalReport.SaveAs(ReportParameters, ReportFormat::Excel, varoutstream);

                        Clear(EmailAddmgt);
                        EmailAddmgt.SetCustomerMergefields(recCust."No.");
                        EmailAddmgt.CreateEmailWithAttachment('CUSTCHMTAX', '', recCust."E-mail for Chemical Report", tempblob, ClientFilename);
                        EmailAddmgt.AddAttachment(tempblob3, lText004);
                        // CLOUD READY DELETE
                        //                        if FileMgt.ServerFileExists(lText003 + lText002) then
                        //                          EmailAddmgt.AddAttachment(lText003 + lText002, lText002, false)
                        //                    else begin
                        //                      ServerFilename2 := lText003 + lText002;
                        //                    EmailAddmgt.AddAttachment(ServerFilename2, lText002, false);
                        //              end;
                        EmailAddmgt.Send;

                        //FileMgt.DeleteServerFile(ServerFilename);
                        //FileMgt.DeleteServerFile(ServerFilename2);

                        recCust."Last Chemical Report Sent" := WorkDate;
                        recCust.Modify(true);
                    end;
                end;
            until recCust.Next() = 0;

            //FileMgt.DeleteServerFile(ServerFilename3);
        end;
    end;
}
