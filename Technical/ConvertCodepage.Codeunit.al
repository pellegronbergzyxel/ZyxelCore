Codeunit 50015 "Convert Codepage"
{

    trigger OnRun()
    begin
    end;

    var
        Text50000: label 'The file "%1" could not be found.';
        FileMgt: Codeunit "File Management";


    procedure ConvertCodepageOld(pInputFileName: Text; pOutPutExt: Text[5]; pFromCodePage: Code[10]; pToCodePage: Code[10])
    var
        lOutputFileName: Text[250];
        f: dotnet File;
        InEnc: dotnet Encoding;
        OutEnc: dotnet Encoding;
    begin
        // CLOUD READY DELETE
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

   procedure ConvertCodepage(pInputFileName: Text; pOutPutExt: Text[5]; pFromCodePage: Code[10]; pToCodePage: Code[10])
    var
        InFile: File;
        OutFile: File;
        lLine: Text;
        lLines: List of [Text];
    begin
        if not Exists(pInputFileName) then
            Error(Text50000, pInputFileName);

        // Set default
        if pFromCodePage = '' then
            pFromCodePage := CodepageANSI;
        if pToCodePage = '' then
            pToCodePage := CodepageUTF8;

        // Read all lines from input file
        InFile.TextMode(true);
        InFile.Open(pInputFileName, CodePageToTextEncoding(pFromCodePage));
        while InFile.Read(lLine) > 0 do
            lLines.Add(lLine);
        InFile.Close();

        // Erase and recreate the same file with new encoding
        Erase(pInputFileName);
        OutFile.TextMode(true);
        OutFile.WriteMode(true);
        OutFile.Create(pInputFileName, CodePageToTextEncoding(pToCodePage));
        foreach lLine in lLines do
            OutFile.Write(lLine);
        OutFile.Close();
    end;

    local procedure ConvertCodepageStrOld(pInputFileName: Text; pOutPutExt: Text[5]; pFromCodePage: Code[10]; pToCodePage: Code[10])
    var
        lOutputFileName: Text[250];
        f: dotnet File;
        InEnc: dotnet Encoding;
        OutEnc: dotnet Encoding;
    begin
        // CLOUD READY DELETE
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

    
    local procedure ConvertCodepageStr(pInputFileName: Text; pOutPutExt: Text[5]; pFromCodePage: Code[10]; pToCodePage: Code[10])
    var
        InFile: File;
        OutFile: File;
        lLine: Text;
        lLines: List of [Text];
    begin
        if not Exists(pInputFileName) then
            Error(Text50000);

        // Set default
        if pFromCodePage = '' then
            pFromCodePage := 'ISO-8859-1';  // ANSI
        if pToCodePage = '' then
            pToCodePage := 'UTF-8';

        // Read all lines from input file
        InFile.TextMode(true);
        InFile.Open(pInputFileName, CodePageToTextEncoding(pFromCodePage));
        while InFile.Read(lLine) > 0 do
            lLines.Add(lLine);
        InFile.Close();

        // Erase and recreate the same file with new encoding
        Erase(pInputFileName);
        OutFile.TextMode(true);
        OutFile.WriteMode(true);
        OutFile.Create(pInputFileName, CodePageToTextEncoding(pToCodePage));
        foreach lLine in lLines do
            OutFile.Write(lLine);
        OutFile.Close();
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

    local procedure CodePageToTextEncoding(pCodePage: Code[10]): TextEncoding
    begin
        case UpperCase(pCodePage) of
            'UTF-8', 'UTF8':
                exit(TextEncoding::UTF8);
            'UNICODE', 'UTF-16', 'UTF16':
                exit(TextEncoding::UTF16);
            'MSDOS', 'DOS':
                exit(TextEncoding::MSDos);
            else
                exit(TextEncoding::Windows);  // ISO-8859-1, ANSI, Windows-1252
        end;
    end;

}
