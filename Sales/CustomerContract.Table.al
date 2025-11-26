Table 50062 "Customer Contract"
{
    // 001. 06-01-20 ZY-LD 000 - Documents are moved to another share.
    // 002. 07-02-20 ZY-LD 000 - Creating a test folder, if it's not production.

    Caption = 'Company Contract';

    fields
    {
        field(1; "Document No."; Code[10])
        {
            Caption = 'Document No.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Contact No.';
            Editable = false;
            TableRelation = Contact;
        }
        field(3; Filename; Text[250])
        {
            Caption = 'Filename';
            Editable = false;
        }
        field(4; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(6; "Valid From"; Date)
        {
            Caption = 'Valid From';
        }
        field(7; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
        field(8; "Tag is Found"; Boolean)
        {
            CalcFormula = exist("Customer Contract Tag" where("Document No." = field("Document No."),
                                                               Tag = field("Tag Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Folder and Filename"; Text[250])
        {
            Caption = 'Folder and Filename';
        }
        field(10; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Contact.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Contact Person"; Text[50])
        {
            Caption = 'Contact Person';
        }
        field(12; "Customer Country Code"; Code[10])
        {
            CalcFormula = lookup(Contact."Country/Region Code" where("No." = field("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Waiting for Document,Uploaded,Moved,,,,,,,Cancled';
            OptionMembers = "Waiting for Document",Uploaded,Moved,,,,,,,Cancled;
        }
        field(51; "Tag Filter"; Code[250])
        {
            FieldClass = FlowFilter;
            TableRelation = "Contract Tag";
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Document No." = '' then begin
            CustContractSetup.Get;
            CustContractSetup.TestField("Serial No.");
            NoSeriesMgt.GetNextNo(CustContractSetup."Serial No.", Today, true);
        end;
    end;

    var
        CustContractSetup: Record "Customer Contract Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure UploadFile(pCustomerNo: Code[20]; pCustomerName: Text)
    var
        lCustContractSetup: Record "Customer Contract Setup";
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        lCustContract: Record "Customer Contract";
        ImportTxt: label 'Insert HR File';
        FileDialogTxt: label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        Err001: label 'The content of the document could not be found in the database.';
        InputFilename: Text;
        OutputFilename: Text;
        ClientFolder: Text;
        BaseFolderName: Text;
        lText001: label 'Filename "%1" already exists.';
        NewStream: InsTream;
        NewStream2: InsTream;
        NewoStream: outsTream;
        NewoStream2: outsTream;
        serverFile: File;
    begin
        if "Folder and Filename" = '' then begin
            lCustContractSetup.Get;
            TempBlob.CreateInStream(NewStream);
            TempBlob.CreateOutStream(NewoStream);
            InputFilename := FileMgt.BLOBImportWithFilter(TempBlob, ImportTxt, Filename, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
            if InputFilename <> '' then begin
                BaseFolderName := GetBaseFolderName;  // 07-02-20 ZY-LD 002
                ClientFolder := StrSubstNo('%1%2 - %3\', BaseFolderName, pCustomerNo, FileMgt.StripNotsupportChrInFileName(pCustomerName));
                if not FileMgt.ServerDirectoryExists(ClientFolder) then
                    FileMgt.ServerCreateDirectory(ClientFolder);
                OutputFilename := ClientFolder + FileMgt.GetFileName(InputFilename);
                Filename := FileMgt.GetFileName(OutputFilename);
                //>> 06-01-20 ZY-LD 001
                //"Folder and Filename" := OutputFilename;
                "Folder and Filename" := CopyStr(OutputFilename, StrLen(BaseFolderName), StrLen(OutputFilename));
                //<< 06-01-20 ZY-LD 001
                if FileMgt.ServerFileExists(OutputFilename) then
                    Error(lText001, OutputFilename);
                if serverFile.Create(OutputFilename) then begin
                    serverFile.CreateOutStream(NewoStream2);
                    CopyStream(NewoStream2, NewStream);
                    //     FileMgt.CopyServerFile(InputFilename, OutputFilename, false);
                    //   FIleMgt.DeleteServerFile(InputFilename);
                    serverFile.Close();
                    Status := Status::Uploaded;
                    Modify(true);
                end;
            end;
        end;
    end;


    procedure GetFilename(): Text
    var
        recCustCtctSetup: Record "Customer Contract Setup";
    begin
        if StrPos("Folder and Filename", 'X:\HR\Company contracts') <> 0 then begin
            "Folder and Filename" := CopyStr("Folder and Filename", 24, StrLen("Folder and Filename"));
            if WritePermission then
                Modify;
        end;

        recCustCtctSetup.Get;
        exit(StrSubstNo('%1\%2', DelChr(recCustCtctSetup."Folder Name", '>', '\'), DelChr("Folder and Filename", '<', '\')));
    end;

    local procedure GetBaseFolderName(): Text
    var
        recServEnviron: Record "Server Environment";
        recCustCtctSetup: Record "Customer Contract Setup";
    begin
        recCustCtctSetup.Get;
        //>> 07-02-20 ZY-LD 002
        if recServEnviron.ProductionEnvironment then
            exit(recCustCtctSetup."Folder Name")
        else
            exit(recCustCtctSetup."Folder Name (Test)");
        //<< 07-02-20 ZY-LD 002
    end;


    procedure ShowFile()
    begin
        //>> 06-01-20 ZY-LD 001
        //HYPERLINK("Folder and Filename");
        // IF StrPos("Folder and Filename",'X:\HR\Company contracts') <> 0 THEN BEGIN
        //  "Folder and Filename" := COPYSTR("Folder and Filename",24,STRLEN("Folder and Filename"));
        //  MODIFY;
        // END;
        //
        // recCustCtctSetup.GET;
        // Filename := STRSUBSTNO('%1\%2',DELCHR(recCustCtctSetup."Folder Name",'>','\'),DELCHR("Folder and Filename",'<','\'));
        //<< 06-01-20 ZY-LD 001
        Hyperlink(GetFilename);
    end;

    procedure DownloadToClient()
    var
        FileMgt: Codeunit "File Management";
        lText001: label 'Download Battery Certificate';
    begin
        FileMgt.DownloadHandler(GetFilename, lText001, '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', Filename);
    end;


    procedure InsertTag(pTag: Text[20])
    var
        lContractTag: Record "Contract Tag";
    begin
        lContractTag.Tag := pTag;
        lContractTag.Insert;
    end;


    procedure downloadcontractFile()
    var
        lCustContractSetup: Record "Customer Contract Setup";
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        lCustContract: Record "Customer Contract";
        ImportTxt: label 'Insert HR File';
        FileDialogTxt: label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        Err001: label 'The content of the document could not be found in the database.';
        InputFilename: Text;
        OutputFilename: Text;
        ClientFolder: Text;
        BaseFolderName: Text;
        lText001: label 'Filename "%1" already exists.';
        NewStream: InsTream;
        NewStream2: InsTream;
        NewoStream: outsTream;
        NewoStream2: outsTream;
        serverFile: File;
    begin
        if rec."Folder and Filename" <> '' then begin
            lCustContractSetup.Get;
            TempBlob.CreateInStream(NewStream);
            TempBlob.CreateOutStream(NewoStream);
            BaseFolderName := GetBaseFolderName + Copystr(rec."Folder and Filename", 2);
            if FILE.Exists(BaseFolderName) then begin
                serverFile.Open(BaseFolderName);
                serverFile.CreateInStream(NewStream);
                Filename := FileMgt.GetFileName(BaseFolderName);
                if DownloadFromStream(NewStream, 'Export', '', 'All Files (*.*)|*.*', Filename) then
                    message('fil downloaded')
            end;
        end;
    end;
}
