Table 66002 "Zyxel File Management"
{
    // 001. 09-01-20 ZY-LD 000 - Delete only file if it's production.
    // 002. 24-02-22 ZY-LD P0767 - New type.
    // 003. 25-05-24 ZY-LD 000 - New Type.

    Caption = 'Zyxel File Management';
    DrillDownPageID = "Zyxel File Management Entries";
    LookupPageID = "Zyxel File Management Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR,"VCK Stock Correction";
        }
        field(3; Filename; Text[250])
        {
            Caption = 'Filename';

            trigger OnValidate()
            begin
                GetFileType;
            end;
        }
        field(4; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
        field(11; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(12; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(51; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
        }
        field(52; "Error Date"; Date)
        {
            Caption = 'Error Date';
        }
        // CLOUD READY
        field(100; filblob; blob)
        {

            Caption = 'File blob';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Creation Date", Open)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()

    begin
        // CLOUD READY DELETE
        //if recServEnviron.ProductionEnvironment then  // 09-01-20 ZY-LD 001
        //   FileMgt.DeleteServerFile(Filename);


    end;

    trigger OnInsert()
    begin
        "Entry No." := GetNextEntryNo;
        "Creation Date" := CurrentDatetime;

        recFileMgt.SetRange(Filename, Filename);
        if recFileMgt.FindFirst then begin
            Open := false;

        end;
    end;

    var
        recServEnviron: Record "Server Environment";
        recFileMgt: Record "Zyxel File Management";
        FileMgt: Codeunit "File Management";

    local procedure GetNextEntryNo(): Integer
    var
        recZyFileMgt: Record "Zyxel File Management";
    begin
        if recZyFileMgt.FindLast then
            exit(recZyFileMgt."Entry No." + 1)
        else
            exit(1);
    end;

    procedure GetFileType(): Integer
    var
        //MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        SOType: Integer;
        lText001: label 'PurchaseOrderResponse';
        lText002: label 'ShippingOrderResponse';
        lText003: label 'InventoryRequestResponse';
        lText004: label 'StockCorrectionNotification';
        lText005: label 'Zyxel_20';
    begin
        // CLOUD READY DELETE >>
        // MyFile.Open(Filename);
        //MyFile.CreateInstream(StreamInTest);
        // CLOUD READY NEW >>

        rec.filblob.CreateInStream(StreamInTest);

        while not StreamInTest.eos do begin
            StreamInTest.ReadText(Buffer);
            break;
        end;
        //MyFile.Close; //


        if StrPos(UpperCase(Buffer), UpperCase(lText001)) > 0 then
            Type := Type::"VCK Purch. Response"
        else
            if StrPos(UpperCase(Buffer), UpperCase(lText002)) > 0 then
                Type := Type::"VCK Ship. Response"
            else
                if StrPos(UpperCase(Buffer), UpperCase(lText003)) > 0 then
                    Type := Type::"VCK Inventory"
                else
                    //>> 24-02-22 ZY-LD 002
                    if StrPos(UpperCase(Buffer), UpperCase(lText004)) > 0 then
                        Type := Type::"VCK Stock Correction"  //<< 24-02-22 ZY-LD 002
                    else
                        //>> 25-05-24 ZY-LD 003
                        if StrPos(UpperCase(Filename), UpperCase(lText005)) > 0 then
                            Type := Type::LMR;  //<< 25-05-24 ZY-LD 003

    end;

    // procedure LoadFileToBlob(FilePath: Text): Boolean
    // var
    //     FileIn: File;
    //     FileStream: InStream;
    //     outstream: OutStream;
    // begin
    //     if not File.Exists(FilePath) then
    //         exit(false);

    //     FileIn.Open(FilePath);
    //     FileIn.CreateInstream(FileStream);
    //     filblob.CreateOutStream(outstream);
    //     CopyStream(outstream, FileStream);
    //     modify();
    //     FileIn.Close;
    //     exit(true);
    // end;

    procedure DownloadBlobToFile(DownloadPath: Text): Boolean
    var
        FileOut: File;
        FileStream: OutStream;
        InStr: instream;
    begin
        Rec.CalcFields("Filblob");
        if filblob.HasValue then begin
            //    FileOut.Create(DownloadPath);
            //  FileOut.CreateOutstream(FileStream);
            Rec.filblob.CreateInStream(InStr, TextEncoding::Windows);
            DownloadFromStream(InStr, 'Download', '', '', Filename);
        end;
        exit(false);
    end;

    procedure GetBlobInStream(var BlobStream: InStream): Boolean
    begin
        if filblob.HasValue then begin
            filblob.CreateInStream(BlobStream);
            exit(true);
        end;
        exit(false);
    end;

    procedure GetBlobOutStream(var BlobStream: OutStream): Boolean
    begin
        filblob.CreateOutStream(BlobStream);
        exit(true);
    end;

    // procedure LoadFileToBase64(FilePath: Text): Boolean
    // var
    //     FileIn: File;
    //     FileStream: InStream;
    //     Base64: Codeunit "Base64 Convert";
    //     BlobStream: OutStream;
    //     Base64Content: Text;
    // begin
    //     if not File.Exists(FilePath) then
    //         exit(false);

    //     FileIn.Open(FilePath);
    //     FileIn.CreateInstream(FileStream);
    //     Base64Content := Base64.ToBase64(FileStream);
    //     FileIn.Close;

    //     filblob.CreateOutStream(BlobStream);
    //     BlobStream.WriteText(Base64Content);
    //     exit(true);
    // end;

    // procedure DownloadBlobFromBase64(DownloadPath: Text): Boolean
    // var
    //     FileOut: File;
    //     FileStream: OutStream;
    //     Base64: Codeunit "Base64 Convert";
    //     BlobStream: InStream;
    //     Base64Content: Text;
    // begin
    //     if not filblob.HasValue then
    //         exit(false);

    //     filblob.CreateInStream(BlobStream);
    //     BlobStream.ReadText(Base64Content);

    //     FileOut.Create(DownloadPath);
    //     FileOut.CreateOutstream(FileStream);
    //     Base64.FromBase64(Base64Content, FileStream);
    //     FileOut.Close;
    //     exit(true);
    // end;

    procedure GetBlobAsBase64(var Base64Content: Text): Boolean
    var
        Base64: Codeunit "Base64 Convert";
        BlobStream: InStream;
    begin
        if filblob.HasValue then begin
            filblob.CreateInStream(BlobStream);
            Base64Content := Base64.ToBase64(BlobStream);
            exit(true);
        end;
        exit(false);
    end;

    procedure SetBlobFromBase64(Base64Content: Text): Boolean
    var
        Base64: Codeunit "Base64 Convert";
        BlobStream: OutStream;
    begin
        filblob.CreateOutStream(BlobStream);
        Base64.FromBase64(Base64Content, BlobStream);
        exit(true);
    end;


    // procedure LoadAllFilesToBlob()
    // var
    //     recZyFileMgt: Record "Zyxel File Management";
    //     checkfile: file;
    // begin
    //     if recZyFileMgt.FindSet() then
    //         repeat
    //             if recZyFileMgt.Filename <> '' then
    //             if file.Exists(recZyFileMgt.Filename) then
    //                 if recZyFileMgt.LoadFileToBlob(recZyFileMgt.Filename) then begin
    //                     recZyFileMgt.Modify(true);

    //                 end;
    //         until recZyFileMgt.Next() = 0;
    // end;



}
