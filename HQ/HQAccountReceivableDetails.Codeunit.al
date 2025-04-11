Codeunit 50014 "HQ Account Receivable Details"
{
    // 001. 21-04-22 ZY-LD 000 - Store the report for Angus to pickup and user for reporting.


    trigger OnRun()
    begin
        ServerFilename := FileMgt.ServerTempFileName('');
        if ZGT.IsZComCompany then
            TargetFilename := '\\ZYEU-NAVSQL02\NAV Archive\Zyxel\EMEA\HQ Account Receivable\HqAccountReceivable.xlsx';
        if ZGT.IsZNetCompany then
            TargetFilename := '\\ZYEU-NAVSQL02\NAV Archive\ZNet\EMEA\HQ Account Receivable\HqAccountReceivable.xlsx';
        FileMgt.DeleteServerFile(TargetFilename);

        Clear(repHQAccountReceivableDetails);
        repHQAccountReceivableDetails.InitReqest(Today, 0);
        repHQAccountReceivableDetails.SaveAsExcel(ServerFilename);

        ZyxelFileMgt.MoveServerFile(ServerFilename, TargetFilename);
        FileMgt.DeleteServerFile(ServerFilename);
    end;

    var
        repHQAccountReceivableDetails: Report "HQ Account Receivable Details";
        FileMgt: Codeunit "File Management";
        ZyxelFileMgt: Codeunit "ZyXel File Management";
        ZGT: Codeunit "ZyXEL General Tools";
        ServerFilename: Text;
        TargetFilename: Text;
}
