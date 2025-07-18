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
        lText001: label 'MR Inventory Template %1 .%2.xlsx';
        TargetFilename: Text;
        tempExcelbuffer: record "Excel Buffer" temporary;
        emailmessage: codeunit "Email Message";
        emailsend: codeunit Email;
        lEmailAdd: Record "E-mail address";
        Recipients: list of [text];
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        InStr: InStream;
        Base64Result: Text;
        lText001a: label 'Detailed ';
        lText002a: label 'Summed Up ';
        lText003a: label 'RMA ';

    begin
        // 
        if lEmailAdd.Get('HQINVTEMPL') then begin

            if lEmailAdd.Recipients <> '' then
                Recipients.Add(lEmailAdd.Recipients);


            emailmessage.Create(Recipients, lEmailAdd.Description, '', true);

            repInvTempl.InitReport(Today, true, true, false, false, true);
            repInvTempl.UseRequestPage(false);
            repInvTempl.RunModal;
            repInvTempl.getExcelbuffer(tempExcelbuffer, 1);
            ExportExcelFileToBlob(tempExcelbuffer, TempBlob);
            TempBlob.CreateInStream(InStr);
            Base64Result := Base64Convert.ToBase64(InStr);
            emailmessage.AddAttachment(StrSubstNo(lText001, lText001a, format(Today)), 'excel', Base64Result);

            //FilenameServerToday := repInvTempl.GetFilenameServer;  // old

            Clear(repInvTempl);
            repInvTempl.InitReport(CalcDate('<CY>', Today), true, true, false, false, true);
            repInvTempl.UseRequestPage(false);
            repInvTempl.RunModal;
            repInvTempl.getExcelbuffer(tempExcelbuffer, 1);
            ExportExcelFileToBlob(tempExcelbuffer, TempBlob);
            TempBlob.CreateInStream(InStr);
            Base64Result := Base64Convert.ToBase64(InStr);
            emailmessage.AddAttachment(StrSubstNo(lText001, lText001a, format(CalcDate('<CY>', Today))), 'excel', Base64Result);

            // FilenameServerEoY := repInvTempl.GetFilenameServer; // old

            //EmailAddMgt.CreateEmailWithAttachment('HQINVTEMPL', '', '', FilenameServerToday, StrSubstNo(lText001, Today), false);//old
            //EmailAddMgt.AddAttachment(FilenameServerEoY, StrSubstNo(lText001, CalcDate('<CY>', Today)), false);//old
            //EmailAddMgt.Send; //old


            //TargetFilename := StrSubstNo('\\ZYEU-NAVSQL02\NAV Archive\ZNet\EMEA\MR Inventory Template\MRInventoryTemplate %1.xlsx', Today);
            //ZyXELFileMgt.MoveServerFile(FilenameServerToday, TargetFilename);


            emailsend.Send(emailmessage, enum::"Email Scenario"::Default);

            //FileMgt.DeleteServerFile(FilenameServerToday); old
            // FileMgt.DeleteServerFile(FilenameServerEoY);
        end;


    end;

    local procedure ExportExcelFileToBlob(
        var TempExcelBuf: Record "Excel Buffer" temporary;
        var TempBlob: Codeunit "Temp Blob")
    var
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr);
        TempExcelBuf.SaveToStream(OutStr, true);
    end;
}
