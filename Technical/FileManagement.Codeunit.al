codeunit 50021 "ZyXEL File Management"
{

    procedure MoveServerFile(SourceFileName: Text; TargetFileName: Text);
    var
        FileMgt: Codeunit "File Management";
        FileDoesNotExistErr: Label 'The file %1 does not exist.', Comment = '%1 File Path';
    begin
        // System.IO.File.Move is not used due to a known issue in KB310316
        if not FileMgt.ServerFileExists(SourceFileName) then
            Error(FileDoesNotExistErr, SourceFileName);

        if UPPERCASE(SourceFileName) = UPPERCASE(TargetFileName) then
            exit;

        ValidateServerPath(FileMgt.GetDirectoryName(TargetFileName) + '\');

        FileMgt.DeleteServerFile(TargetFileName);
        FileMgt.CopyServerFile(SourceFileName, TargetFileName, true);
        FileMgt.DeleteServerFile(SourceFileName);
    end;

    local procedure ValidateServerPath(FilePath: Text);
    var
        FileMgt: Codeunit "File Management";
        CreatePathQst: Label 'The path %1 does not exist. Do you want to add it now?';
    begin
        if FilePath = '' then
            exit;
        //if FileMgt.ServerFileExists(FilePath) then
        //    exit;
        IF FileMgt.ServerDirectoryExists(FilePath) then //02-03-2026 BK #Job 50048 fejler
            exit;

        if Confirm(CreatePathQst, true, FilePath) then
            FileMgt.ServerCreateDirectory(FilePath)
        else
            Error('');
    end;

    procedure GetClientDownloadFolder() rValue: Text
    begin
        rValue := StrSubstNo('C:\Users\%1\Downloads\', CopyStr(UserId(), 6, StrLen(UserId())));
    end;
}
