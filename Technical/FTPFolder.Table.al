Table 62016 "FTP Folder"
{
    Caption = 'FTP Folders';
    DataCaptionFields = "Code";
    Description = 'FTP Folders';
    DrillDownPageID = "FTP Folders";
    LookupPageID = "FTP Folders";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Hostname; Text[250])
        {
            Caption = 'Hostname';

            trigger OnValidate()
            begin
                //ValidateFTP;
            end;
        }
        field(3; Username; Text[250])
        {
            Caption = 'Username';

            trigger OnValidate()
            begin
                ValidateFTP;
            end;
        }
        field(4; Password; Text[250])
        {
            Caption = 'Password';

            trigger OnValidate()
            begin
                ValidateFTP;
            end;
        }
        field(5; "Local Folder"; Text[250])
        {
            Caption = 'Local Folder';

            trigger OnValidate()
            begin
                "Local Folder" := ValidateFolder("Local Folder");
            end;
        }
        field(6; "Remote Folder"; Text[250])
        {
            Caption = 'Remote Folder';

            trigger OnValidate()
            begin
                "Remote Folder" := ValidateRemoteFolder("Remote Folder");
                ValidateFTP;
            end;
        }
        field(7; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Send,Receive';
            OptionMembers = Send,Receive;
        }
        field(8; "Delete Local File"; Boolean)
        {
            Caption = 'Delete Local File';
        }
        field(9; "Archive Local File"; Boolean)
        {
            Caption = 'Archive Local File';
        }
        field(10; "Archive Folder"; Text[250])
        {
            Caption = 'Archive Folder';

            trigger OnValidate()
            begin
                "Archive Folder" := ValidateFolder("Archive Folder");
            end;
        }
        field(11; "File Mask"; Text[5])
        {
            Caption = 'File Mask';
        }
        field(12; "Delete Remote"; Boolean)
        {
            Caption = 'Delete Remote';
        }
        field(13; Secure; Boolean)
        {
        }
        field(14; "Server Environment"; Option)
        {
            Caption = 'Server Environment';
            NotBlank = true;
            OptionCaption = ' ,Development,Test,Production';
            OptionMembers = " ",Development,Test,Production;
        }
        field(15; Active; Boolean)
        {
            Caption = 'Active';

            trigger OnValidate()
            begin
                ValidateFTP;
            end;
        }
        field(16; VCK; Boolean)
        {
        }
        field(17; "Accept Creation of Sub Folder"; Boolean)
        {
            Caption = 'Accept Creation of Sub Folder';
        }
        field(20; "Use Passive"; Boolean)
        {
            Caption = 'Use Passive';
            InitValue = true;
        }
        field(21; "SFTP Port No."; Integer)
        {
            Caption = 'SFTP Port No.';
        }
        field(22; Protocol; Option)  // 22-05-24 ZY-LD 000
        {
            Caption = 'Protocol';
            OptionMembers = FTP,"FTPS Explicit","FTPS Implicit",SFTP,HTTP,,SCP;
            OptionCaption = 'FTP,FTPS Explicit,FTPS Implicit,SFTP,HTTP,,SCP';
        }
    }

    keys
    {
        key(Key1; "Code", "Server Environment")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure ValidateFTP()
    var
        recFTPFolder: Record "FTP Folder";
    begin
        if (Hostname = '') or
           (Username = '') or
           (Password = '') or
           ("Remote Folder" = '')
        then
            Active := false;

        if "Server Environment" = "server environment"::Production then begin
            recFTPFolder.SetRange(Code, Code);
            recFTPFolder.SetFilter("Server Environment", '<>%1', "server environment"::Production);
            if recFTPFolder.FindFirst then
                if (Username = recFTPFolder.Username) and ("Remote Folder" = recFTPFolder."Remote Folder") then
                    Active := false;
        end else begin
            recFTPFolder.Get(Code, "server environment"::Production);
            if (Username = recFTPFolder.Username) and ("Remote Folder" = recFTPFolder."Remote Folder") then
                Active := false;
        end;
    end;

    local procedure ValidateFolder(pFolder: Text) rValue: Text
    begin
        if pFolder <> '' then begin
            rValue := pFolder;
            rValue := ConvertStr(rValue, '/', '\');
            rValue := DelChr(rValue, '>', '\');
            rValue := rValue + '\';
        end;
    end;

    local procedure ValidateRemoteFolder(pFolder: Text) rValue: Text
    begin
        if pFolder <> '' then begin
            rValue := pFolder;
            rValue := ConvertStr(rValue, '\', '/');
            rValue := DelChr(rValue, '<', '/');
            rValue := '/' + rValue;
        end;
    end;


    procedure TestConnection()
    var
        FileMgt: Codeunit "File Management";
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'Connection to %1 is ok.';
        lText002: label 'Do you want to test the connection?';
        lText003: label 'Archive "%1" is not created.';
    begin
        if Confirm(lText002, true) then begin
            if FtpMgt.TestLogin(Code) then
                Message(lText001, Code);

            if not FileMgt.ServerDirectoryExists("Archive Folder") then
                Message(lText003, "Archive Folder");
        end;
    end;
}
