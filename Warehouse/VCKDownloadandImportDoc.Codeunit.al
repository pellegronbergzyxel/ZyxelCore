Codeunit 50099 "VCK Download and  Import Doc."
{

    trigger OnRun()
    begin
        DownloadVCK(0, true);
        InventoryImport(0);
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";


    procedure DownloadAndPostInventory()
    begin
        DownloadVCK(3, true);
        PostInventory(0);
    end;


    procedure PostInventory(pEntryNo: Integer)
    begin
        InventoryImport(pEntryNo);
    end;

    local procedure InventoryImport(pEntryNo: Integer)
    var
        recZyFileMgt: Record "Zyxel File Management";
        recAutoSetup: Record "Automation Setup";
        xmlStockInbound: XmlPort "Read Stock Level Response";
        xmlReadStockReq: XmlPort "Read Stock Level Request";
        InStream: InStream;
        ImportErrorOccured: Boolean;
        FilenameXml: Text;
        LastErrorText: Text;
        YYYY: Integer;
        MM: Integer;
        DD: Integer;
    begin
        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::"VCK Inventory");
        recZyFileMgt.SetRange(Open, true);
        if pEntryNo <> 0 then
            recZyFileMgt.SetRange("Entry No.", pEntryNo);
        if recZyFileMgt.FindSet(true) then
            repeat
                recZyFileMgt.calcfields(filblob);

                if recZyFileMgt.filblob.HasValue() then begin
                    recZyFileMgt.filblob.CreateInstream(InStream);

                    FilenameXml := recZyFileMgt.Filename;
                    FilenameXml := DelChr(FilenameXml, '=', 'NULL');
                    FilenameXml := CopyStr(FilenameXml, StrPos(FilenameXml, '_'), StrLen(FilenameXml));
                    FilenameXml := DelChr(FilenameXml, '=', '_');
                    Evaluate(YYYY, CopyStr(FilenameXml, 1, 4));
                    Evaluate(MM, CopyStr(FilenameXml, 5, 2));
                    Evaluate(DD, CopyStr(FilenameXml, 7, 2));

                    Clear(xmlStockInbound);
                    xmlStockInbound.Init(Dmy2date(DD, MM, YYYY) - 1);  // The warehouse inventory date is the day before the file is created.
                    xmlStockInbound.SetSource(InStream);

                    Commit();
                    LastErrorText := '';
                    ClearLastError();
                    if not xmlStockInbound.Import() then
                        LastErrorText := GetLastErrorText();

                    if LastErrorText = '' then begin
                        recZyFileMgt.Open := false;
                        if not GuiAllowed() then begin
                            EmailAddMgt.CreateSimpleEmail('VCKINVREQ', '', '');
                            EmailAddMgt.Send;
                        end;

                        Clear(xmlReadStockReq);
                        xmlReadStockReq.Init(Dmy2date(DD, MM, YYYY) - 1);
                        xmlReadStockReq.SetSource(InStream);
                        xmlReadStockReq.Import();
                    end else
                        recZyFileMgt."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(recZyFileMgt."Error Text"));
                    recZyFileMgt.Modify;
                end;

                if recZyFileMgt."Error Text" <> '' then begin
                    recAutoSetup.Get;
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today()) then begin
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send;

                        recAutoSetup."Warehouse Import Error Date" := Today;
                        recAutoSetup.Modify();
                    end;
                end;
            until recZyFileMgt.Next() = 0;

    end;


    procedure DownloadVCK(Type: Option " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR; Import: Boolean)
    var
        recWhseSetup: Record "Warehouse Setup";
        recWarehouse: Record Location;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'Downloading from VCK';
    begin
        recWhseSetup.Get();
        if GuiAllowed() or recWhseSetup.WhsePostingAllowed() then begin
            ZGT.OpenProgressWindow(lText001, 1);
            ZGT.UpdateProgressWindow(lText001, 0, true);
            recWarehouse.SetRange(Warehouse, recWarehouse.Warehouse::VCK);
            recWarehouse.FindFirst;
            recWarehouse.TestField("Warehouse Outbound FTP Code");
            FtpMgt.DownloadFolderStream(recWarehouse."Warehouse Outbound FTP Code");
            ZGT.CloseProgressWindow();

            if Import then
                case Type of
                    Type::"VCK Inventory":
                        InventoryImport(0)
                    else
                        InventoryImport(0);
                end;
        end;
    end;
}
