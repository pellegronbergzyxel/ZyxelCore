Codeunit 50057 "VisionFTP Management"
{
    // 001. 11-06-19 ZY-LD 2019061110000049 - Handling of error code. Locktable is set after Commit, because commit releases the table.
    // 002. 03-10-19 ZY-LD 2019100310000038 - Changed download to copy.
    // 003. 03-01-20 ZY-LD 000 - Adding a subfolder.
    // 004. 27-02-20 ZY-LD 000 - Choose if you want to see the error.
    // 005. 21-04-21 ZY-LD 2021042010000147 - Code has been moved from "DownloadFile" to "DownloadFile2", so it will be possible to rename the file.

    trigger OnRun()
    begin
    end;

    var
        recFtpFolder: Record "FTP Folder";
        SubFolder: Text;
        Text001: label '%1 is only setup to %2.';
        Text50000: label 'Files were not deleted from the FTP-server, bechause you are on the %1-server.';
        Text50003: label 'The file %1 does not exists.';
        Text50005: label 'An error occured at file download.';

    procedure UploadFile("Code": Code[20]; ServerPathAndFileName: Text; RemoteFileName: Text) rValue: Boolean
    var
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        FileMgt: Codeunit "File Management";
        B64: Codeunit "Base64 Convert";
        FileHandle: File;
        InStr: InStream;
        FTPConnectionString: Text;
        ResponseText: Text;
        lErrText: Text[250];
    begin
        GetFtpFolder(Code);

        if recFtpFolder.Direction = recFtpFolder.Direction::Receive then
            Error(Text001, Code, recFtpFolder.Direction);

        if not Exists(ServerPathAndFileName) then
            lErrText := StrSubstNo(Text50003, ServerPathAndFileName);

        if lErrText = '' then begin
            if SubFolder <> '' then
                recFtpFolder."Remote Folder" := FileMgt.CombinePath(recFtpFolder."Remote Folder", SubFolder);

            FTPConnectionString := GetFTPConnectionString(FileMgt.GetExtension(ServerPathAndFileName) <> '.txt');

            FileHandle.Open(ServerPathAndFileName);
            FileHandle.CreateInStream(InStr);

            ResponseText := FileAPIMgt.FtpUploadFile(FTPConnectionString, recFtpFolder."Remote Folder", RemoteFileName, B64.ToBase64(InStr));
        end;

        if lErrText = '' then begin
            if recFtpFolder."Archive Local File" and (recFtpFolder."Archive Folder" <> '') and (FileMgt.ServerDirectoryExists(recFtpFolder."Archive Folder")) then
                FileMgt.CopyServerFile(ServerPathAndFileName, recFtpFolder."Archive Folder" + RemoteFileName, true);  // 03-10-19 ZY-LD 002
                                                                                                                      //FileMgt.DownloadToFile(ServerPathAndFileName,recFtpFolder."Archive Folder" + RemoteFileName);  // 03-10-19 ZY-LD 002
            FileMgt.DeleteServerFile(ServerPathAndFileName);
            rValue := true;
        end else
            if GuiAllowed then
                Error(lErrText)
            else begin
                // Send e-mail to nav support
                rValue := false;
            end;
    end;

    procedure DownloadFile("Code": Code[20]; RemoteFileName: Text; ShowError: Boolean) ArchiveFilename: Text[250]
    begin
        ArchiveFilename := DownloadFile2(Code, RemoteFileName, RemoteFileName, ShowError);  // 21-04-21 ZY-LD 005
    end;

    procedure DownloadAndRenameFile("Code": Code[20]; RemoteFilename: Text; DestinationFilename: Text; ShowError: Boolean) ArchiveFilename: Text[250]
    var
        FileMgt: Codeunit "File Management";
        TempFilename: Text;
    begin
        //>> 21-04-21 ZY-LD 005
        if DestinationFilename = '' then begin
            TempFilename := FileMgt.ServerTempFileName(FileMgt.GetExtension(RemoteFilename));
            DestinationFilename := FileMgt.GetFileName(TempFilename);
            DestinationFilename := DelStr(DestinationFilename, 1, 8);
            DestinationFilename := DelStr(DestinationFilename, StrPos(DestinationFilename, '.'), 4);
            DestinationFilename := StrSubstNo('%1_%2', DelChr(Format(CurrentDatetime, 0, 9), '=', '/\-,.: APMTZ'), DestinationFilename);
        end;
        ArchiveFilename := DownloadFile2(Code, RemoteFilename, DestinationFilename, ShowError);
        //<< 21-04-21 ZY-LD 005
    end;

    local procedure DownloadFile2("Code": Code[20]; RemoteFilename: Text; DestinationFilename: Text; ShowError: Boolean) ArchiveFilename: Text[250]
    var
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        FileMgt: Codeunit "File Management";
        B64: Codeunit "Base64 Convert";
        FileHandle: File;
        OutStr: OutStream;
        FTPConnectionString: Text;
        ResponseText: Text;
    begin
        GetFtpFolder(Code);

        if SubFolder <> '' then
            ArchiveFilename := FileMgt.CombinePath(FileMgt.CombinePath(recFtpFolder."Archive Folder", SubFolder), DestinationFilename)
        else
            ArchiveFilename := FileMgt.CombinePath(recFtpFolder."Archive Folder", DestinationFilename);

        FTPConnectionString := GetFTPConnectionString(FileMgt.GetExtension(RemoteFilename) <> '.txt');

        ResponseText := FileAPIMgt.FtpDownloadFile(FTPConnectionString, FileMgt.GetDirectoryName(RemoteFilename), FileMgt.GetFileName(RemoteFilename));
        if ResponseText <> '' then begin
            FileHandle.Create(ArchiveFilename);
            FileHandle.CreateOutStream(OutStr);
            OutStr.Write(B64.FromBase64(ResponseText));
            FileHandle.Close();

            if recFtpFolder."Delete Remote" then
                FileAPIMgt.FtpDeleteFile(FTPConnectionString, FileMgt.GetDirectoryName(RemoteFilename), FileMgt.GetFileName(RemoteFilename));
        end else
            if ShowError then  // 27-02-20 ZY-LD 004
                Error(Text50005);
    end;

    procedure DownloadFolder("Code": Code[20])
    var
        recZyFileMgt: Record "Zyxel File Management";
        TempBlob: Codeunit "Temp Blob";
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        FileMgt: Codeunit "File Management";
        B64: Codeunit "Base64 Convert";
        FileHandle: File;
        FileArray: JsonArray;
        FileToken: JsonToken;
        FileOutStream: OutStream;
        FileInStream: InStream;
        FTPConnectionString: Text;
        FileName: Text;
        ArchiveFileName: Text;
        I: Integer;
    begin
        GetFtpFolder(Code);

        if recFtpFolder.Direction = recFtpFolder.Direction::Send then
            Error(Text001, Code, recFtpFolder.Direction);

        if SubFolder <> '' then
            recFtpFolder."Remote Folder" := FileMgt.CombinePath(recFtpFolder."Remote Folder", SubFolder);

        FTPConnectionString := GetFTPConnectionString(true);

        FileArray := FileAPIMgt.FtpGetFileList(FTPConnectionString, recFtpFolder."Remote Folder");
        for I := 0 to FileArray.Count() - 1 do begin
            FileArray.Get(I, FileToken);
            FileName := FileToken.AsValue().AsText();
            ArchiveFileName := FileMgt.CombinePath(recFtpFolder."Archive Folder", FileName);
            if not (FileName in ['.', '..']) then begin
                recZyFileMgt.LockTable();

                TempBlob.CreateOutStream(FileOutStream);
                B64.FromBase64(FileApiMgt.FTPDownloadFile(FTPConnectionString, recFtpFolder."Remote Folder", FileName), FileOutStream);
                TempBlob.CreateInStream(FileInStream);

                FileHandle.Create(ArchiveFileName);
                FileHandle.Write(FileInStream);
                FileHandle.Close();

                recZyFileMgt.Init();
                recZyFileMgt.Validate(Filename, ArchiveFileName);
                recZyFileMgt.Insert(true);

                if recFtpFolder."Delete Remote" then
                    FileAPIMgt.FtpDeleteFile(FTPConnectionString, recFtpFolder."Remote Folder", FileName);

                Commit();
            end;
        end;
    end;

    procedure TestLogin("Code": Code[20]): Boolean
    var
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        FTPConnectionString: Text;
        JsonContent: Text;
        JsonContentLbl: Label '{"connection": %1 ,"remoteDirectory": "%2"}', comment = '%1 is the connection string, %2 is the remote directory', Locked = true;
    begin
        GetFtpFolder(Code);

        FTPConnectionString := GetFTPConnectionString(true);
        JsonContent := StrSubstNo(JsonContentLbl, FTPConnectionString, '');
        exit(FileAPIMgt.FtpTestConnection(JsonContent));
    end;

    local procedure FileExists("Code": Code[20]; RemoteFileName: Text[250]; DeleteFile: Boolean) rFound: Boolean
    var
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        FileMgt: Codeunit "File Management";
        FileArray: JsonArray;
        FileToken: JsonToken;
        FTPConnectionString: Text;
        FileName: Text;
        LowerCaseRemoteFileName: Text;
        I: Integer;
    begin
        GetFtpFolder(Code);

        if SubFolder <> '' then
            recFtpFolder."Remote Folder" := FileMgt.CombinePath(recFtpFolder."Remote Folder", SubFolder);

        LowerCaseRemoteFileName := LowerCase(FileMgt.GetFileName(RemoteFileName));

        FTPConnectionString := GetFTPConnectionString(true);

        FileArray := FileAPIMgt.FtpGetFileList(FTPConnectionString, recFtpFolder."Remote Folder");
        for I := 0 to FileArray.Count() - 1 do begin
            FileArray.Get(I, FileToken);
            FileName := FileToken.AsValue().AsText();
            if not (FileName in ['.', '..']) then
                if LowerCase(FileName) = LowerCaseRemoteFileName then begin
                    rFound := true;
                    if DeleteFile then
                        FileAPIMgt.FtpDeleteFile(FTPConnectionString, recFtpFolder."Remote Folder", FileName);
                    break;
                end;
        end;
    end;

    procedure DeleteRemoteFile("Code": Code[20]; RemoteFileName: Text[250]) rDeleted: Boolean
    begin
        rDeleted := FileExists(Code, RemoteFileName, true);
    end;

    local procedure CountRemoteFiles("Code": Code[20]; Binary: Boolean) rValue: Integer
    var
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        FileArray: JsonArray;
        FileToken: JsonToken;
        FTPConnectionString: Text;
        FileName: Text;
        I: Integer;
    begin
        GetFtpFolder(Code);

        FTPConnectionString := GetFTPConnectionString(Binary);

        FileArray := FileAPIMgt.FtpGetFileList(FTPConnectionString, recFtpFolder."Remote Folder");
        for I := 0 to FileArray.Count() - 1 do begin
            FileArray.Get(I, FileToken);
            FileName := FileToken.AsValue().AsText();
            if not (FileName in ['.', '..']) then
                rValue += 1;
        end;
    end;

    local procedure GetFTPConnectionString(IsBinary: Boolean) FTPConnectionString: Text
    var
        FileAPIMgt: Codeunit FileAPIMgtHLPVPE;
        Protocol: Enum "Ftp Protocol HLPVPE";
        ServerPort: Integer;
        TransferType: Integer;
        ConnectionMode: Integer;
    begin
        case recFtpFolder.Protocol of
            recFtpFolder.Protocol::FTP:
                Protocol := Protocol::FTP;
            recFtpFolder.Protocol::"FTPS Explicit":
                Protocol := Protocol::FTPSExplicit;
            recFtpFolder.Protocol::"FTPS Implicit":
                Protocol := Protocol::FTPSImplicit;
            recFtpFolder.Protocol::SFTP:
                Protocol := Protocol::SFTP;
            recFtpFolder.Protocol::HTTP:
                Protocol := Protocol::HTTP;
            recFtpFolder.Protocol::SCP:
                Protocol := Protocol::SCP;
        end;

        if recFtpFolder.Secure and (recFtpFolder."SFTP Port No." <> 0) then
            ServerPort := recFtpFolder."SFTP Port No."
        else
            ServerPort := 21; // 20...?

        if recFtpFolder."Use Passive" then
            ConnectionMode := 2
        else
            ConnectionMode := 1;

        if IsBinary then
            TransferType := 2  // Binary
        else
            TransferType := 1; // ASCII

        FTPConnectionString := FileAPIMgt.CreateFTPConnectionString(
            recFtpFolder.Hostname,
            ServerPort,
            recFtpFolder.Username,
            recFtpFolder.Password,
            ConnectionMode,
            TransferType,
            Protocol);
    end;

    local procedure GetFtpFolder("Code": Code[20])
    var
        recServEnviron: Record "Server Environment";
        FileMgt: Codeunit "File Management";
        lText001: label '%1 %2 is not active.';
        lText002: label 'Folder "%1" does not exist.';
    begin
        recServEnviron.Get();
        recFtpFolder.Get(Code, recServEnviron.Environment);
        if not recFtpFolder.Active then
            Error(lText001, Code, recServEnviron.Environment);

        recFtpFolder.TestField(Hostname);
        recFtpFolder.TestField(Username);
        recFtpFolder.TestField(Password);
        if recFtpFolder.Direction = recFtpFolder.Direction::Receive then begin
            recFtpFolder.TestField("Archive Folder");
            if not FileMgt.ServerDirectoryExists(recFtpFolder."Archive Folder") then
                Error(lText002, recFtpFolder."Archive Folder");
        end;
    end;

    procedure SetSubFolder(NewSubFolder: Text)
    begin
        SubFolder := NewSubFolder;
    end;
}
