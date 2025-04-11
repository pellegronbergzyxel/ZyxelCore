Table 50016 "Battery Certificate"
{
    Caption = 'Battery Certificate';
    DataCaptionFields = "Entry No.", Description;
    DrillDownPageID = "Battery Certificates";
    LookupPageID = "Battery Certificates";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Filename; Text[50])
        {
            Caption = 'Filename';
        }
        field(5; "File Path"; Text[80])
        {
            Caption = 'File Path';
        }
        field(6; "Date Imported"; Date)
        {
            Caption = 'Date Imported';
        }
    }

    keys
    {
        key(Key1; "Item No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Date Imported" := Today;

        if "Entry No." = 0 then begin
            recBatDocEntry.SetRange("Item No.", "Item No.");
            if recBatDocEntry.FindLast then
                "Entry No." := recBatDocEntry."Entry No." + 1
            else
                "Entry No." := 1;
        end;
    end;

    var
        recBatDocEntry: Record "Battery Certificate";
        recFtpFolder: Record "FTP Folder";
        FileMgt: Codeunit "File Management";
        NewFolder: Text;
        Text001: label 'Download Battery Certificate';


    procedure GetFilename(): Text
    begin
        exit("File Path" + Filename);
    end;


    procedure DownloadDocument()
    var
        recServEnviron: Record "Server Environment";
        VisionFTPMgt: Codeunit "VisionFTP Management";
        FileMgt: Codeunit "File Management";
        lText001: label 'Downloading document';
        ZGT: Codeunit "ZyXEL General Tools";
        FilePath: Text;
    begin
        LockTable;

        if "File Path" = '' then begin
            ZGT.OpenProgressWindow('', 1);

            ZGT.UpdateProgressWindow(lText001, 0, true);
            if recServEnviron.ProductionEnvironment then begin
                TestField("Item No.");

                recServEnviron.Get;
                recFtpFolder.Get('HQ-BATTERY', recServEnviron.Environment);
                NewFolder := recFtpFolder."Archive Folder" + "Item No.";
                if not FileMgt.ServerDirectoryExists(NewFolder) then
                    FileMgt.ServerCreateDirectory(NewFolder);

                VisionFTPMgt.SetSubFolder("Item No.");
                FilePath := VisionFTPMgt.DownloadFile(recFtpFolder.Code, Filename, false);
                "File Path" := FileMgt.GetDirectoryName(FilePath) + '\';

                if FileMgt.ServerFileExists(GetFilename) then begin
                    Modify;
                    Commit;
                end;
            end;

            ZGT.CloseProgressWindow;
        end;
    end;


    procedure DownloadToClient()
    var
        FileMgt: Codeunit "File Management";
    begin
        FileMgt.DownloadHandler(GetFilename, Text001, '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', Filename);
    end;
}
