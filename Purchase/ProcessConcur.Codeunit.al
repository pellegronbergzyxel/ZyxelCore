Codeunit 50032 "Process Concur"
{

    trigger OnRun()
    var
        recConcurSetup: Record "Concur Setup";
    begin
        recAutoSetup.Get;

        recConcurSetup.Get;
        if recAutoSetup.AutomationAllowed then begin
            // Travel Expense
            if (recAutoSetup."Travel Expense Process" >= recAutoSetup."travel expense process"::Import) and
               (recConcurSetup."Import Folder - Travel Expense" <> '')
            then
                ImportFile(1, recConcurSetup."Import Folder - Travel Expense");

            if recAutoSetup."Travel Expense Process" >= recAutoSetup."travel expense process"::"Import & Transfer" then
                TransferAndPostDocument(1, recAutoSetup."Invoice Capture Process" = recAutoSetup."invoice capture process"::"Import & Transfer & Post");

            // Invoice Capture
            /*if (recAutoSetup."Invoice Capture Process" >= recAutoSetup."invoice capture process"::Import) and
                (recConcurSetup."Import Folder - Invoice Captur" <> '')
            then
                ImportFile(0, recConcurSetup."Import Folder - Invoice Captur");

            if recAutoSetup."Invoice Capture Process" >= recAutoSetup."invoice capture process"::"Import & Transfer" then
                TransferAndPostDocument(0, recAutoSetup."Invoice Capture Process" = recAutoSetup."invoice capture process"::"Import & Transfer & Post"); */
        end;
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure ImportFile(Type: Option "Invoice Capture","Travel Expense"; ClientDir: Text)
    var
        recConcurSetup: Record "Concur Setup";
        recNameValueBuf: Record "Name/Value Buffer" temporary;
        repImpConcurTrExp: Report "Import Concur Travel Expense";
        FileMgt: Codeunit "File Management";
        ZyXELFileMgt: Codeunit "ZyXEL File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ServerFilename: Text;
        ClientFilename: Text;
        ClientErrorDir: Text;
        ClientUploadDir: Text;
        ClientFromConcDir: Text;
        ClientArchiveDir: Text;
        LastModifyDate: Date;
        LastModifyTime: Time;
        FileSize: BigInteger;
    begin
        // Setup directory
        recConcurSetup.Get;
        ClientErrorDir := ClientDir + recConcurSetup."Error Folder";
        if not FileMgt.ServerDirectoryExists(ClientErrorDir) then
            FileMgt.ServerCreateDirectory(ClientErrorDir);
        ClientUploadDir := ClientDir + recConcurSetup."Uploaded Folder";
        if not FileMgt.ServerDirectoryExists(ClientUploadDir) then
            FileMgt.ServerCreateDirectory(ClientUploadDir);
        ClientFromConcDir := ClientDir + recConcurSetup."From Concur Folder";
        if not FileMgt.ServerDirectoryExists(ClientFromConcDir) then
            FileMgt.ServerCreateDirectory(ClientFromConcDir);
        ClientArchiveDir := StrSubstNo('%1%2%3\%4-%5\', ClientDir, recConcurSetup."Archive Folder", Date2dmy(Today, 3), Date2dmy(Today, 2), ZGT.GetMonthText(Date2dmy(Today, 2), false, false, false));
        if not FileMgt.ServerDirectoryExists(ClientArchiveDir) then
            FileMgt.ServerCreateDirectory(ClientArchiveDir);

        //>> Search for errors
        recNameValueBuf.DeleteAll;
        FileMgt.GetServerDirectoryFilesList(recNameValueBuf, ClientErrorDir);
        if recNameValueBuf.FindFirst and (StrPos(UpperCase(recNameValueBuf.Name), 'THUMB') = 0) then begin
            recConcurSetup.Get;
            SI.SetMergefield(100, Format(Type));
            SI.SetMergefield(101, ClientErrorDir);
            EmailAddMgt.CreateSimpleEmail(recConcurSetup."Import Error E-mail Code", '', '');
            EmailAddMgt.Send;
        end;

        FileMgt.GetServerDirectoryFilesList(recNameValueBuf, ClientDir);
        if recNameValueBuf.FindSet then
            repeat
                // Updoad file to server
                ClientFilename := ClientErrorDir + FileMgt.GetFileName(recNameValueBuf.Name);
                ZyxelFileMgt.MoveServerFile(recNameValueBuf.Name, ClientFilename);
                ServerFilename := FileMgt.ServerTempFileName(FileMgt.GetExtension(ClientFilename));
                FileMgt.CopyServerFile(ClientFilename, ServerFilename, true);

                // Import file
                case Type of
                    Type::"Travel Expense":
                        begin
                            Clear(repImpConcurTrExp);
                            repImpConcurTrExp.InitReport(ServerFilename);
                            repImpConcurTrExp.UseRequestPage(false);
                            repImpConcurTrExp.RunModal;
                        end;
                end;

                // Store file
                FileMgt.DeleteServerFile(ServerFilename);
                ZyxelFileMgt.MoveServerFile(ClientFilename, ClientUploadDir + FileMgt.GetFileName(recNameValueBuf.Name));
            until recNameValueBuf.Next() = 0;

        // Move Concur files into the archive
        recNameValueBuf.DeleteAll;
        FileMgt.GetServerDirectoryFilesList(recNameValueBuf, ClientFromConcDir);
        if recNameValueBuf.FindSet then
            repeat
                ZyxelFileMgt.MoveServerFile(recNameValueBuf.Name, ClientArchiveDir + FileMgt.GetFileName(recNameValueBuf.Name));
            until recNameValueBuf.Next() = 0;

        // Delete uploaded files older than 3 months
        recNameValueBuf.DeleteAll;
        FileMgt.GetServerDirectoryFilesList(recNameValueBuf, ClientUploadDir);
        if recNameValueBuf.FindSet then
            repeat
                FileMgt.GetServerFileProperties(recNameValueBuf.Name, LastModifyDate, LastModifyTime, FileSize);
                if CalcDate('3M', LastModifyDate) < Today then
                    FileMgt.DeleteServerFile(recNameValueBuf.Name);
            until recNameValueBuf.Next() = 0;

        Commit;
    end;

    local procedure TransferAndPostDocument(Type: Option "Invoice Capture","Travel Expense"; PostDocument: Boolean)
    var
        BatchTransferTravelExp: Report "Batch Transfer Travel Exp.";
    begin
        case Type of
            Type::"Travel Expense":
                begin
                    Clear(BatchTransferTravelExp);
                    BatchTransferTravelExp.UseRequestPage(false);
                    BatchTransferTravelExp.InitReport(PostDocument);
                    BatchTransferTravelExp.Run;
                end;
        end;
    end;
}
