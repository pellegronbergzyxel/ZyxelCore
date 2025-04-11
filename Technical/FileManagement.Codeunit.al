codeunit 50021 "ZyXEL File Management"
{

    procedure MoveServerFile(SourceFileName: Text; TargetFileName: Text);
    var
        FileMgt: Codeunit "File Management";
        FileDoesNotExistErr: Label 'The file %1 does not exist.', Comment = '%1 File Path';
    begin
        //>> 18-02-21 ZY-LD 002
        // System.IO.File.Move is not used due to a known issue in KB310316
        if not FileMgt.ServerFileExists(SourceFileName) then
            Error(FileDoesNotExistErr, SourceFileName);

        if UPPERCASE(SourceFileName) = UPPERCASE(TargetFileName) then
            exit;

        ValidateServerPath(FileMgt.GetDirectoryName(TargetFileName) + '\');  // 14-06-24 ZY-LD 000 '\' is added.

        FileMgt.DeleteServerFile(TargetFileName);
        FileMgt.CopyServerFile(SourceFileName, TargetFileName, true);
        FileMgt.DeleteServerFile(SourceFileName);
        //<< 18-02-21 ZY-LD 002
    end;

    local procedure ValidateServerPath(FilePath: Text);
    var
        FileMgt: Codeunit "File Management";
        CreatePathQst: Label 'The path %1 does not exist. Do you want to add it now?';
    begin
        //>> 18-02-21 ZY-LD 002
        if FilePath = '' then
            exit;
        if FileMgt.ServerFileExists(FilePath) then
            exit;

        if Confirm(CreatePathQst, true, FilePath) then
            FileMgt.ServerCreateDirectory(FilePath)
        else
            Error('');
        //<< 18-02-21 ZY-LD 002
    end;

    procedure GetClientDownloadFolder() rValue: Text
    begin
        //>> 14-01-19 ZY-LD 001
        rValue := StrSubstNo('C:\Users\%1\Downloads\', CopyStr(UserId(), 6, StrLen(UserId())));
        //<< 14-01-19 ZY-LD 001
    end;
}
