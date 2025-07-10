Codeunit 62007 "Inventory Template Report"
{
    // 001. 01-12-20 ZY-LD 2020113010000045 - Created.
    // 002. 18-10-22 ZY-LD 000 - Gus need this report every week.


    trigger OnRun()
    begin
        Process;
    end;

    local procedure Process()
    var
        EmailAddMgt: Codeunit "E-mail Address Management";
        FileMgt: Codeunit "File Management";
        ZyXELFileMgt: Codeunit "ZyXEL File Management";
        repInvTempl: Report "MR Inventory Template";
        FilenameServerToday: Text;
        FilenameServerEoY: Text;
        lText001: label 'MR Inventory Template ..%1.xlsx';
        TargetFilename: Text;
    begin
        repInvTempl.InitReport(Today, true, true, false, false);
        repInvTempl.UseRequestPage(false);
        repInvTempl.RunModal;
        FilenameServerToday := repInvTempl.GetFilenameServer;

        Clear(repInvTempl);
        repInvTempl.InitReport(CalcDate('<CY>', Today), true, true, false, false);
        repInvTempl.UseRequestPage(false);
        repInvTempl.RunModal;
        FilenameServerEoY := repInvTempl.GetFilenameServer;

        EmailAddMgt.CreateEmailWithAttachment('HQINVTEMPL', '', '', FilenameServerToday, StrSubstNo(lText001, Today), false);
        EmailAddMgt.AddAttachment(FilenameServerEoY, StrSubstNo(lText001, CalcDate('<CY>', Today)), false);
        EmailAddMgt.Send;


        //TargetFilename := StrSubstNo('\\ZYEU-NAVSQL02\NAV Archive\ZNet\EMEA\MR Inventory Template\MRInventoryTemplate %1.xlsx', Today);
        //ZyXELFileMgt.MoveServerFile(FilenameServerToday, TargetFilename);


        FileMgt.DeleteServerFile(FilenameServerToday);
        FileMgt.DeleteServerFile(FilenameServerEoY);
    end;
}
