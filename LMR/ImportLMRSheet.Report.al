Report 50122 "Import LMR Sheet"
{
    // 001. 25-01-22 ZY-LD 000 - We now take the bin direct from the imported file.
    // 002. 18-12-23 ZY-LD 000 - Data is not longer used at Zyxel, and is therefore not imported.
    // 003. 09-09-24 ZY-LD 003 - We only need to read one value bin.   

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Import from")
                    {
                        Caption = 'Import from';
                        field(Filename; Filename)
                        {
                            ApplicationArea = Basic, Suite;
                            AssistEdit = true;
                            Caption = 'Workbook File Name';

                            trigger OnAssistEdit()
                            begin
                                UploadFile;
                            end;
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        if CompanyName() <> 'ZNet DK' then Error(Text016);
        if FileName = '' then Error(Text001);
        ShortFilename := SplitFilename(Filename);
        if CheckExists then
            if not Confirm(Text015, false) then exit;
        LMRGoodStock;
        Message(Text002, ShortFilename);

        SI.UseOfReport(3, 50122, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        ZGT: Codeunit "ZyXEL General Tools";
        Filename: Text[1024];
        TotalRow: Integer;
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'File %1 has been Imported.';
        Text004: label 'RMA ';
        Text005: label 'LMR Stock';
        Sheet001: label 'LMR Good Stock';
        ShortFilename: Text;
        Text015: label 'The file has already been imported. Do you want to import again?';
        Text016: label 'You must be in the ZNet DK Company to Import LMR Sheets.';
        SI: Codeunit "Single Instance";

    local procedure LMRGoodStock()
    var
        recLMRStock: Record "LMR Stock";
        SalesSetup: Record "Sales & Receivables Setup";  // 09-09-24 ZY-LD 003
        ItemNo: Code[30];
        CountryCode: Code[20];
        Bin: Code[20];
        RenamedBin: Code[20];
        Location: Code[20];
        RowCount: Integer;
        Row: Integer;
        Qty: Integer;
        UID: Integer;

    begin
        SalesSetup.get;  //>> 09-09-24 ZY-LD 003
        ReadExcelSheet(Sheet001);

        recLMRStock.SetRange(Filename, ShortFilename);
        if recLMRStock.FindSet then
            recLMRStock.DeleteAll;
        recLMRStock.Reset;

        UID := GetGoodStockLast;
        if ExcelBuffer.FindLast then begin
            RowCount := ExcelBuffer."Row No.";
            ZGT.OpenProgressWindow(Text005, RowCount);
            for Row := 2 to RowCount do begin
                ItemNo := '';
                Qty := 0;
                CountryCode := '';
                Bin := '';
                UID := UID + 1;
                ZGT.UpdateProgressWindow(Text005, Row, true);
                if ExcelBuffer.Get(Row, 1) then ItemNo := ExcelBuffer."Cell Value as Text";
                if StrLen(ItemNo) > 20 then ItemNo := CopyStr(ItemNo, 1, 20);
                if ExcelBuffer.Get(Row, 3) then Evaluate(Qty, ExcelBuffer."Cell Value as Text");
                if ExcelBuffer.Get(Row, 4) then Bin := ExcelBuffer."Cell Value as Text";
                if ExcelBuffer.Get(Row, 5) then CountryCode := ExcelBuffer."Cell Value as Text";
                //>> 25-01-22 ZY-LD 001
                /*CASE Bin OF
                  Text010 : RenamedBin := Text010;
                  Text011 : RenamedBin := Text011;
                  Text012 : RenamedBin := Text012;
                  Text013 : RenamedBin := Text013;

                ELSE
                  RenamedBin := Text014;
                END;
                IF RenamedBin = 'RMA GB' THEN
                  RenamedBin := 'RMA UK';*/
                //<< 25-01-22 ZY-LD 001
                if Bin = SalesSetup."LMR Value Bin" then begin  // 09-09-24 ZY-LD 003
                    if CountryCode = 'GB' then
                        CountryCode := 'UK';
                    recLMRStock.Init;
                    recLMRStock.UID := UID;
                    recLMRStock."Item No." := ItemNo;
                    recLMRStock."ZyXEL Item" := IsZyXELItem(ItemNo);
                    recLMRStock.Quantity := Qty;
                    //recLMRStock.Bin := RenamedBin;  // 25-01-22 ZY-LD 001
                    recLMRStock.Bin := UpperCase(Bin);  // 25-01-22 ZY-LD 001
                    recLMRStock.Filename := ShortFilename;
                    recLMRStock."Time Stamp" := CurrentDatetime;
                    recLMRStock."Country Code" := CountryCode;
                    Location := Text004 + CountryCode;
                    if Location = 'RMA GB' then Location := 'RMA UK';
                    recLMRStock."Location Code" := Location;
                    recLMRStock.Insert;
                end;
            end;
            ZGT.CloseProgressWindow;
        end;
    end;

    local procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
    begin
        Upload('Upload', 'C:\', 'Excel file(*.xlsx)|*.xlsx', '', FileName);
        //Filename := UploadedFileName
    end;

    local procedure SplitFilename(Filename: Text) Name: Text
    var
        Path: Text;
        Pos: Integer;
        Found: Boolean;
    begin
        Path := '';
        Name := '';
        Filename := DelChr(Filename, '<>');
        if (Filename = '') then exit;
        Pos := StrLen(Filename);
        repeat
            Found := (CopyStr(Filename, Pos, 1) = '\');
            if not Found then
                Pos := Pos - 1;
        until (Pos = 0) or Found;
        if Found then begin
            Path := CopyStr(Filename, 1, Pos);
            Name := CopyStr(Filename, Pos + 1);
        end else begin
            Path := '';
            Name := Filename;
        end;
    end;

    local procedure IsZyXELItem(ItemNo: Code[30]): Boolean
    var
        recItem: Record Item;
    begin
        recItem.SetRange("No.", ItemNo);
        exit(recItem.FindFirst)
    end;

    local procedure ReadExcelSheet(SheetName: Text[100])
    begin
        if FileName = '' then
            UploadFile;
        //else
        //    Filename := UploadedFileName;
        ExcelBuffer.OpenBook(Filename, SheetName);
        ExcelBuffer.ReadSheet;
    end;

    local procedure GetGoodStockLast(): Integer
    var
        recLMRStock: Record "LMR Stock";
    begin
        if recLMRStock.FindLast then
            exit(recLMRStock.UID + 1);
    end;

    local procedure GetOpenRMASLast(): Integer
    var
        recLMROpenRMAs: Record "LMR Open RMAs";
    begin
        if recLMROpenRMAs.FindLast then
            exit(recLMROpenRMAs.UID + 1);
    end;

    local procedure GetRequiredStockLast(): Integer
    var
        recLMRRequiredStock: Record "LMR Required Stock";
    begin
        if recLMRRequiredStock.FindLast then
            exit(recLMRRequiredStock.UID + 1);
    end;

    local procedure CheckExists(): Boolean
    var
        recLMRStock: Record "LMR Stock";
    begin
        recLMRStock.SetRange(Filename, ShortFilename);
        exit(recLMRStock.FindFirst);
    end;

    procedure InitReport(NewFilename: Text)
    begin
        Filename := NewFilename;
    end;
}