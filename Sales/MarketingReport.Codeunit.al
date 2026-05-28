Codeunit 50020 "Marketing Report"
{

    trigger OnRun()
    begin
        EndDate := Today;
        StartDate := CalcDate('-1Y', EndDate);
        // CLOUD READY DELETE
        //ServerFilename := FileMkt.ServerTempFileName('');
        TempBlob.CreateOutStream(varoutstream);
        repMarketingReport.InitReport(StartDate, EndDate, 'CH-REGION', '54750|54825|54850|54860|54900|54950|55050|55100|55150|55200');
        repMarketingReport.SaveAs(dummy, ReportFormat::Excel, varoutstream);
        //repMarketingReport.SaveAsExcel(ServerFilename);

        EmailAdd.CreateEmailWithAttachment('REP50088', '', '', TempBlob, StrSubstNo(Text001, StartDate, EndDate));
        EmailAdd.Send;
        // CLOUD READY delete
        //FileMkt.DeleteServerFile(ServerFilename);
    end;

    var
        EmailAdd: Codeunit "E-mail Address Management";
        FileMkt: Codeunit "File Management";
        repMarketingReport: Report "Marketing Report";
        ServerFilename: Text;
        Text001: label 'Marketing Data %1..%2.xlsx';
        StartDate: Date;
        EndDate: Date;
        Dummy: text;
        TempBlob: codeunit "Temp Blob";
        varoutstream: outstream;
}
