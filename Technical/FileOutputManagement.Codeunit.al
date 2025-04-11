Codeunit 50046 "File Output Management"
{

    trigger OnRun()
    begin
    end;

    var
        CsvFile: File;
        ServerFilename: Text;
        NoOfColumns: Integer;
        Content: array[200] of Text[250];
        FieldSeparator: Code[1];
        CrLF: Text[2];
        StreamOut: OutStream;


    procedure OpenCsvFile(AddHeader: Boolean)
    begin
        if FieldSeparator = '' then
            FieldSeparator := ';';
        SetCrLf;
        CreateCsvFile;
        if AddHeader then
            WriteCsvFile;
    end;


    procedure AddTextToContent(Text: Text)
    begin
        NoOfColumns += 1;
        Content[NoOfColumns] := Text;
    end;

    local procedure CreateCsvFile()
    var
        FileMgt: Codeunit "File Management";
    begin
        ServerFilename := FileMgt.ServerTempFileName('');
        CsvFile.Create(ServerFilename);
        CsvFile.CreateOutstream(StreamOut);
    end;


    procedure WriteCsvFile()
    var
        OutputText: Text;
        j: Integer;
    begin
        for j := 1 to NoOfColumns do begin
            Content[j] := DelChr(Content[j], '=', '";');
            OutputText += StrSubstNo('"%1"%2', DelChr(Content[j], '=', FieldSeparator), FieldSeparator);
        end;
        OutputText := DelChr(OutputText, '>', FieldSeparator);
        OutputText += CrLF;
        StreamOut.WriteText(OutputText);
    end;


    procedure CloseCsvAndShowFile(pClientFilename: Text; pShowFile: Boolean; pConvertFileTo: Option " ",Unicode,Ansi,"UTF-8")
    var
        FileMgt: Codeunit "File Management";
        ZyxelFileMgt: Codeunit "Zyxel File Management";
        ConvCodePage: Codeunit "Convert Codepage";
        lText001: label 'Download file';
    begin
        CsvFile.Close;

        case pConvertFileTo of
            Pconvertfileto::Unicode:
                ConvCodePage.ConvertCodepage(ServerFilename, FileMgt.GetExtension(pClientFilename), '', ConvCodePage.CodepageUnicode);
            Pconvertfileto::Ansi:
                ConvCodePage.ConvertCodepage(ServerFilename, FileMgt.GetExtension(pClientFilename), '', ConvCodePage.CodepageANSI);
            Pconvertfileto::"UTF-8":
                ConvCodePage.ConvertCodepage(ServerFilename, FileMgt.GetExtension(pClientFilename), '', ConvCodePage.CodepageUTF8);
        end;

        FileMgt.DownloadHandler(ServerFilename, lText001, ZyxelFileMgt.GetClientDownloadFolder, 'Csv|*.csv|All files|*.*', pClientFilename);
        FileMgt.DeleteServerFile(ServerFilename);
        ServerFilename := '';
        NoOfColumns := 0;

        if pShowFile and (pClientFilename <> '') then
            Hyperlink(pClientFilename);
    end;


    procedure CloseCsvFile(pConvertFileTo: Option " ",Unicode,Ascii,"UTF-8"): Text
    var
        FileMgt: Codeunit "File Management";
        ConvCodePage: Codeunit "Convert Codepage";
    begin
        CsvFile.Close;

        case pConvertFileTo of
            Pconvertfileto::Unicode:
                ConvCodePage.ConvertCodepage(ServerFilename, FileMgt.GetExtension(ServerFilename), '', ConvCodePage.CodepageUnicode);
            Pconvertfileto::Ascii:
                ConvCodePage.ConvertCodepage(ServerFilename, FileMgt.GetExtension(ServerFilename), '', ConvCodePage.CodepageANSI);
            Pconvertfileto::"UTF-8":
                ConvCodePage.ConvertCodepage(ServerFilename, FileMgt.GetExtension(ServerFilename), '', ConvCodePage.CodepageUTF8);
        end;
        exit(ServerFilename);
    end;


    procedure ClearContent()
    begin
        Clear(Content);
        NoOfColumns := 0;
    end;


    procedure SetFieldSeparator(pFieldSeparator: Code[1])
    begin
        FieldSeparator := pFieldSeparator;
    end;

    local procedure SetCrLf()
    begin
        CrLF[1] := 13;
        CrLF[2] := 10;
    end;
}
