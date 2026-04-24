Codeunit 50057 "VisionFTP Management"
{
    // 001. 11-06-19 ZY-LD 2019061110000049 - Handling of error code. Locktable is set after Commit, because commit releases the table.
    // 002. 03-10-19 ZY-LD 2019100310000038 - Changed download to copy.
    // 003. 03-01-20 ZY-LD 000 - Adding a subfolder.
    // 004. 27-02-20 ZY-LD 000 - Choose if you want to see the error.
    // 005. 21-04-21 ZY-LD 2021042010000147 - Code has been moved from "DownloadFile" to "DownloadFile2", so it will be possible to rename the file.

    trigger OnRun()
    var
        LbNo: Integer;
    begin
    end;

    var
        recFtpFolder: Record "FTP Folder";
        recServEnviron: Record "Server Environment";
        FTP: dotnet ComFtpClient;
        SFTP: dotnet ComFtpSecure;
        ZGT: Codeunit "ZyXEL General Tools";
        FileMgt: Codeunit "File Management";
        Text50000: label 'Files were not deleted from the FTP-server, bechause you are on the %1-server.';
        FileTmp: Record File temporary;
        Text50001: label 'Clips\%1 created\%2 rejected';
        Text50002: label 'An error occured at file upload.';
        Text50003: label 'The file %1 does not exists.';
        Text50004: label 'Try to create account for 2 minutes.';
        Text50005: label 'An error occured at file download.';
        Text50006: label 'FTP user %1 does not exist';
        Text50007: label 'Path %1 does not exists.';
        Text001: label '%1 is only setup to %2.';
        Text002: label 'An error occured on login to the ftp-server "%1".\It was not possible to upload or download the files.\\%2.';
        SubFolder: Text;

    procedure UploadFile("Code": Code[20]; ServerPathAndFileName: Text; RemoteFileName: Text) rValue: Boolean
    var
        lErrText: Text[250];
    begin
        GetFtpFolder(Code);
        if recFtpFolder.Direction = recFtpFolder.Direction::Receive then
            Error(Text001, Code, recFtpFolder.Direction);

        if recFtpFolder.Secure then begin
            Clear(SFTP);
            ConnectSFTP(FileMgt.GetExtension(ServerPathAndFileName) <> '.txt');

            if lErrText = '' then
                if not Exists(ServerPathAndFileName) then
                    lErrText := StrSubstNo(Text50003, ServerPathAndFileName);

            if lErrText = '' then
                if not SFTP.Upload(ServerPathAndFileName, RemoteFileName) then
                    lErrText := SFTP.LastError;

            if lErrText = '' then
                DisconnectSFTP;
        end else begin
            Clear(FTP);
            ConnectFTP(FileMgt.GetExtension(ServerPathAndFileName) <> '.txt');

            if lErrText = '' then
                if not FileMgt.ServerFileExists(ServerPathAndFileName) then
                    lErrText := StrSubstNo(Text50003, ServerPathAndFileName);

            if lErrText = '' then
                if not FTP.Upload(ServerPathAndFileName, RemoteFileName) then
                    lErrText := FTP.LastError;

            if lErrText = '' then
                DisconnectFTP;
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
    begin
        GetFtpFolder(Code);
        if recFtpFolder.Direction = recFtpFolder.Direction::Send then
            Error(Text001, Code, recFtpFolder.Direction);

        if recFtpFolder.Secure then begin
            Clear(SFTP);
            ConnectSFTP(FileMgt.GetExtension(RemoteFilename) <> '.txt');

            //>> 03-01-20 ZY-LD 003
            if SubFolder <> '' then
                ArchiveFilename := StrSubstNo('%1%2\%3', recFtpFolder."Archive Folder", SubFolder, DestinationFilename)
            else  //<< 03-01-20 ZY-LD 003
                ArchiveFilename := recFtpFolder."Archive Folder" + DestinationFilename;
            if SFTP.Download(ArchiveFilename, RemoteFilename) then begin
                if recFtpFolder."Delete Remote" then
                    SFTP.DeleteFile(RemoteFilename);
            end else
                if ShowError then  // 27-02-20 ZY-LD 004
                    Error(SFTP.LastError);

            DisconnectSFTP;
        end else begin
            Clear(FTP);
            ConnectFTP(FileMgt.GetExtension(RemoteFilename) <> '.txt');

            //>> 03-01-20 ZY-LD 003
            if SubFolder <> '' then
                ArchiveFilename := StrSubstNo('%1%2\%3', recFtpFolder."Archive Folder", SubFolder, DestinationFilename)
            else  //<< 03-01-20 ZY-LD 003
                ArchiveFilename := recFtpFolder."Archive Folder" + DestinationFilename;
            if FTP.Download(ArchiveFilename, RemoteFilename) then begin
                if recFtpFolder."Delete Remote" then
                    FTP.DeleteFile(RemoteFilename);
            end else
                if ShowError then  // 27-02-20 ZY-LD 004
                    Error(FTP.LastError);

            DisconnectFTP;
        end;
    end;

    procedure DownloadFolder("Code": Code[20])
    var
        recZyFileMgt: Record "Zyxel File Management";
        RemoteFilename: Text[250];
        LocalFile: Text[250];
        ArchiveFilename: Text;
        lErrText: Text;
        lText001: label '%1/%2/%3 could not download.';
    begin
        GetFtpFolder(Code);
        if recFtpFolder.Direction = recFtpFolder.Direction::Send then
            Error(Text001, Code, recFtpFolder.Direction);

        if recFtpFolder.Secure then begin
            Clear(SFTP);
            ConnectSFTP(true);

            if SFTP.FindFirst <> '' then begin
                recZyFileMgt.LockTable;
                ZGT.OpenProgressWindow('', CountRemoteFiles(Code, true));  // 11-06-19 ZY-LD 001
                RemoteFilename := SFTP.FindFirst;
                repeat
                    ZGT.UpdateProgressWindow(RemoteFilename, 0, true);  // 11-06-19 ZY-LD 001
                    if (not IsAFolder(RemoteFilename, true)) and (RemoteFilename <> '') and (RemoteFilename <> '.') and (RemoteFilename <> '..') then begin
                        ArchiveFilename := recFtpFolder."Archive Folder" + RemoteFilename;
                        if SFTP.Download(ArchiveFilename, RemoteFilename) then begin
                            recZyFileMgt.Init;
                            recZyFileMgt.Validate(Filename, ArchiveFilename);
                            recZyFileMgt.Insert(true);

                            if recFtpFolder."Delete Remote" then begin
                                SFTP.DeleteFile(RemoteFilename);
                                Commit;  // When we delete the remote file, we need to commit to secure the data in file management
                                recZyFileMgt.LockTable;  // 11-06-19 ZY-LD 001
                            end;
                        end else begin
                            recZyFileMgt.Init;
                            recZyFileMgt.Validate("Error Text", CopyStr(StrSubstNo(lText001, recFtpFolder.Code, recFtpFolder."Remote Folder", RemoteFilename), 1, MaxStrLen(recZyFileMgt."Error Text")));
                            recZyFileMgt.Open := false;
                            recZyFileMgt.Insert(true);
                        end;
                    end;

                    RemoteFilename := SFTP.FindNext;
                until RemoteFilename = '';
                ZGT.CloseProgressWindow;  // 11-06-19 ZY-LD 001
            end;

            SFTP.Disconnect;
        end else begin
            Clear(FTP);
            ConnectFTP(true);

            if FTP.FindFirst <> '' then begin
                recZyFileMgt.LockTable;
                ZGT.OpenProgressWindow('', CountRemoteFiles(Code, true));  // 11-06-19 ZY-LD 001
                RemoteFilename := FTP.FindFirst;
                repeat
                    ZGT.UpdateProgressWindow(RemoteFilename, 0, true);  // 11-06-19 ZY-LD 001
                                                                        //IF (RemoteFilename <> '') AND (RemoteFilename <> '.') AND (RemoteFilename <> '..') THEN BEGIN
                    if (not IsAFolder(RemoteFilename, true)) and (RemoteFilename <> '') and (RemoteFilename <> '.') and (RemoteFilename <> '..') then begin
                        ArchiveFilename := recFtpFolder."Archive Folder" + RemoteFilename;
                        if FTP.Download(ArchiveFilename, RemoteFilename) then begin
                            recZyFileMgt.Init;
                            recZyFileMgt.Validate(Filename, ArchiveFilename);
                            recZyFileMgt.Insert(true);

                            if recFtpFolder."Delete Remote" then begin
                                FTP.DeleteFile(RemoteFilename);
                                Commit;  // When we delete the remote file, we need to commit to secure the data in file management
                                recZyFileMgt.LockTable;  // 11-06-19 ZY-LD 001
                            end;
                        end else begin
                            recZyFileMgt.Init;
                            recZyFileMgt.Validate("Error Text", CopyStr(StrSubstNo(lText001, recFtpFolder.Code, recFtpFolder."Remote Folder", RemoteFilename), 1, MaxStrLen(recZyFileMgt."Error Text")));
                            recZyFileMgt.Open := false;
                            recZyFileMgt.Insert(true);
                        end;
                    end;

                    RemoteFilename := FTP.FindNext;
                until RemoteFilename = '';
                ZGT.CloseProgressWindow;  // 11-06-19 ZY-LD 001
            end;

            FTP.Disconnect;
        end;

        Commit;
    end;

    procedure TestLogin("Code": Code[20]): Boolean
    begin
        GetFtpFolder(Code);

        if recFtpFolder.Secure then begin
            Clear(SFTP);
            ConnectSFTP(true);
            DisconnectSFTP;
        end else begin
            Clear(FTP);
            ConnectFTP(true);
            DisconnectFTP;
        end;

        exit(true);
    end;

    local procedure FileExists("Code": Code[20]; RemoteFileName: Text[250]; DeleteFile: Boolean) rFound: Boolean
    var
        lErrText: Text[250];
        FtpFile: Text[250];
    begin
        GetFtpFolder(Code);

        if recFtpFolder.Secure then begin
            Clear(SFTP);
            ConnectSFTP(FileMgt.GetExtension(RemoteFileName) <> '.txt');

            FtpFile := SFTP.FindFirst;
            if FtpFile <> '' then
                repeat
                    if (FtpFile <> '') and (FtpFile = RemoteFileName) then begin
                        rFound := true;
                        if DeleteFile then
                            SFTP.DeleteFile(RemoteFileName);
                    end;
                    FtpFile := SFTP.FindNext;
                until (FtpFile = '') or (rFound);

            DisconnectSFTP;
        end else begin
            Clear(FTP);
            ConnectFTP(FileMgt.GetExtension(RemoteFileName) <> '.txt');

            FtpFile := FTP.FindFirst;
            if FtpFile <> '' then
                repeat
                    if (FtpFile <> '') and (FtpFile = RemoteFileName) then begin
                        rFound := true;
                        if DeleteFile then
                            FTP.DeleteFile(RemoteFileName);
                    end;
                    FtpFile := FTP.FindNext;
                until (FtpFile = '') or (rFound);

            DisconnectFTP;
        end;
    end;

    procedure DeleteRemoteFile("Code": Code[20]; RemoteFileName: Text[250]) rDeleted: Boolean
    begin
        rDeleted := FileExists(Code, RemoteFileName, true);
    end;

    local procedure CountRemoteFiles("Code": Code[20]; Binary: Boolean) rValue: Integer
    var
        lFTP: dotnet ComFtpClient;
        lSFTP: dotnet ComFtpSecure;
        lErrText: Text;
    begin
        GetFtpFolder(Code);

        if recFtpFolder.Secure then begin
            lSFTP := lSFTP.ComFtpSecure;
            lSFTP.FtpServer := recFtpFolder.Hostname;
            lSFTP.UserName := recFtpFolder.Username;
            lSFTP.Password := recFtpFolder.Password;
            lSFTP.UseBinary := Binary;  // FALSE = Tekstfiler, TRUE= alt andet
            lSFTP.UsePassive := recFtpFolder."Use Passive";
            lSFTP.Protocol := recFtpFolder.Protocol;
            if recFtpFolder.Secure and (recFtpFolder."SFTP Port No." <> 0) then
                lSFTP.FtpPort := recFtpFolder."SFTP Port No.";

            if lSFTP.Connect then begin
                if recFtpFolder."Remote Folder" <> '' then
                    if not lSFTP.ChangeRemoteDir(recFtpFolder."Remote Folder") then
                        Error(lSFTP.LastError);

                if lSFTP.FindFirst <> '' then
                    repeat
                        rValue += 1;
                    until lSFTP.FindNext = '';
                lSFTP.Disconnect;
            end else
                Error(lSFTP.LastError);
        end else begin
            lFTP := lFTP.ComFtpClient;
            lFTP.FtpServer := recFtpFolder.Hostname;
            lFTP.UserName := recFtpFolder.Username;
            lFTP.Password := recFtpFolder.Password;
            lFTP.UseBinary := Binary;  // FALSE = Tekstfiler, TRUE= alt andet
            lFTP.UsePassive := recFtpFolder."Use Passive";

            if lFTP.Connect then begin
                if recFtpFolder."Remote Folder" <> '' then
                    if not lFTP.ChangeRemoteDir(recFtpFolder."Remote Folder") then
                        Error(lFTP.LastError);

                if lFTP.FindFirst <> '' then
                    repeat
                        rValue += 1;
                    until lFTP.FindNext = '';
                lFTP.Disconnect;
            end else
                Error(lFTP.LastError);
        end;

        rValue := rValue - 2;  // "." and ".." is not part of the count
    end;

    local procedure ConnectFTP(Binary: Boolean): Boolean
    begin
        Clear(FTP);
        FTP := FTP.ComFtpClient;
        FTP.FtpServer := recFtpFolder.Hostname;
        FTP.UserName := recFtpFolder.Username;
        FTP.Password := recFtpFolder.Password;
        FTP.UseBinary := Binary;  // FALSE = Tekstfiler, TRUE= alt andet
        FTP.UsePassive := recFtpFolder."Use Passive";

        if FTP.Connect then begin
            //>> 03-01-20 ZY-LD 003
            if SubFolder <> '' then begin
                recFtpFolder."Remote Folder" := DelChr(recFtpFolder."Remote Folder", '>', '/');
                SubFolder := DelChr(SubFolder, '<', '/');
                recFtpFolder."Remote Folder" := StrSubstNo('%1/%2', recFtpFolder."Remote Folder", SubFolder);
            end;
            //<< 03-01-20 ZY-LD 003

            if recFtpFolder."Remote Folder" <> '' then
                if not FTP.ChangeRemoteDir(recFtpFolder."Remote Folder") then
                    Error(FTP.LastError);

            exit(true);
        end else
            //>> 11-06-19 ZY-LD 001
            if StrPos(FTP.LastError, '530') <> 0 then
                Error(Text002, recFtpFolder.Code, FTP.LastError)
            else  //<< 11-06-19 ZY-LD 001
                Error(FTP.LastError);
    end;

    local procedure ConnectSFTP(Binary: Boolean): Boolean
    begin
        Clear(SFTP);
        SFTP := SFTP.ComFtpSecure;

        SFTP.FtpServer := recFtpFolder.Hostname;
        SFTP.UserName := recFtpFolder.Username;
        SFTP.Password := recFtpFolder.Password;
        SFTP.UseBinary := Binary;  // FALSE = Tekstfiler, TRUE= alt andet
        SFTP.UsePassive := recFtpFolder."Use Passive";
        SFTP.Protocol := recFtpFolder.Protocol;
        if recFtpFolder.Secure and (recFtpFolder."SFTP Port No." <> 0) then
            SFTP.FtpPort := recFtpFolder."SFTP Port No.";

        if SFTP.Connect then begin
            //>> 03-01-20 ZY-LD 003
            if SubFolder <> '' then begin
                recFtpFolder."Remote Folder" := DelChr(recFtpFolder."Remote Folder", '>', '/');
                SubFolder := DelChr(SubFolder, '<', '/');
                recFtpFolder."Remote Folder" := StrSubstNo('%1/%2', recFtpFolder."Remote Folder", SubFolder);
            end;
            //<< 03-01-20 ZY-LD 003

            if recFtpFolder."Remote Folder" <> '' then
                if not SFTP.ChangeRemoteDir(recFtpFolder."Remote Folder") then
                    Error(SFTP.LastError);

            exit(true);
        end else
            //>> 11-06-19 ZY-LD 001
            if StrPos(SFTP.LastError, '530') <> 0 then
                Error(Text002, recFtpFolder.Code, SFTP.LastError)
            else  // 11-06-19 ZY-LD 001
                Error(SFTP.LastError);
    end;

    local procedure DisconnectFTP()
    begin
        FTP.Disconnect;
        Clear(FTP);
    end;

    local procedure DisconnectSFTP()
    begin
        SFTP.Disconnect;
        Clear(SFTP);
    end;

    local procedure IsAFolder(Filename: Text; Binary: Boolean) rValue: Boolean
    var
        lFTP: dotnet ComFtpClient;
        lSFTP: dotnet ComFtpSecure;
    begin
        if recFtpFolder.Secure then begin
            lSFTP := lSFTP.ComFtpSecure;
            lSFTP.FtpServer := recFtpFolder.Hostname;
            lSFTP.UserName := recFtpFolder.Username;
            lSFTP.Password := recFtpFolder.Password;
            lSFTP.UseBinary := Binary;  // FALSE = Tekstfiler, TRUE= alt andet
            lSFTP.UsePassive := recFtpFolder."Use Passive";

            if lSFTP.Connect then begin
                rValue := lSFTP.ChangeRemoteDir(StrSubstNo('%1/%2', recFtpFolder."Remote Folder", Filename));
                lSFTP.Disconnect;
            end;

            Clear(lSFTP);
        end else begin
            lFTP := lFTP.ComFtpClient;
            lFTP.FtpServer := recFtpFolder.Hostname;
            lFTP.UserName := recFtpFolder.Username;
            lFTP.Password := recFtpFolder.Password;
            lFTP.UseBinary := Binary;  // FALSE = Tekstfiler, TRUE= alt andet
            lFTP.UsePassive := recFtpFolder."Use Passive";

            if lFTP.Connect then begin
                rValue := lFTP.ChangeRemoteDir(StrSubstNo('%1/%2', recFtpFolder."Remote Folder", Filename));
                lFTP.Disconnect;
            end;

            Clear(lFTP);
        end;
    end;

    local procedure GetFtpFolder("Code": Code[20])
    var
        recServEnviron: Record "Server Environment";
        lText001: label '%1 %2 is not active.';
        lText002: label 'Folder "%1" does not exist.';
    begin
        recServEnviron.Get;
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
