Codeunit 50015 "Convert Codepage"
{

    trigger OnRun()
    begin
    end;

    var
        Text50000: label 'The file "%1" could not be found.';
        FileMgt: Codeunit "File Management";


    procedure ConvertCodepage(pInputFileName: Text; pOutPutExt: Text[5]; pFromCodePage: Code[10]; pToCodePage: Code[10])
    var
        lOutputFileName: Text[250];
        f: dotnet File;
        InEnc: dotnet Encoding;
        OutEnc: dotnet Encoding;
    begin
        if not Exists(pInputFileName) then
            Error(Text50000, pInputFileName);

        // Set default
        if pFromCodePage = '' then
            pFromCodePage := CodepageANSI;
        if pToCodePage = '' then
            pToCodePage := CodepageUTF8;
        if pOutPutExt = '' then
            pOutPutExt := FileMgt.GetExtension(pInputFileName);
        if CopyStr(pOutPutExt, 1, 1) <> '.' then
            pOutPutExt := '.' + pOutPutExt;

        InEnc := InEnc.GetEncoding(pFromCodePage);
        OutEnc := OutEnc.GetEncoding(pToCodePage);
        lOutputFileName := FileMgt.GetDirectoryName(pInputFileName) + '\' + FileMgt.GetFileNameWithoutExtension(pInputFileName) + pOutPutExt;
        f.WriteAllLines(lOutputFileName, f.ReadAllLines(pInputFileName, InEnc), OutEnc);
    end;

    local procedure ConvertCodepageStr(pInputFileName: Text; pOutPutExt: Text[5]; pFromCodePage: Code[10]; pToCodePage: Code[10])
    var
        lOutputFileName: Text[250];
        f: dotnet File;
        InEnc: dotnet Encoding;
        OutEnc: dotnet Encoding;
    begin
        if not Exists(pInputFileName) then
            Error(Text50000);

        // Set default
        if pFromCodePage = '' then
            pFromCodePage := 'ISO-8859-1';  // ANSI
        if pToCodePage = '' then
            pToCodePage := 'UTF-8';
        if pOutPutExt = '' then
            pOutPutExt := FileMgt.GetExtension(pInputFileName)
        else
            if CopyStr(pOutPutExt, 1, 1) <> '.' then
                pOutPutExt := '.' + pOutPutExt;

        InEnc := InEnc.GetEncoding(pFromCodePage);
        OutEnc := OutEnc.GetEncoding(pToCodePage);
        lOutputFileName := CopyStr(pInputFileName, 1, StrPos(pInputFileName, '.') - 1) + pOutPutExt;
        f.WriteAllLines(lOutputFileName, f.ReadAllLines(pInputFileName, InEnc), OutEnc);
    end;


    procedure CodepageUnicode(): Code[10]
    begin
        exit('UNICODE');
    end;


    procedure CodepageANSI(): Code[10]
    begin
        exit('ISO-8859-1');
    end;


    procedure CodepageUTF8(): Code[10]
    begin
        exit('UTF-8');
    end;
}
