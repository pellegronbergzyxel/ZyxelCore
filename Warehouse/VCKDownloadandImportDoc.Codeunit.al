Codeunit 50099 "VCK Download and  Import Doc."
{
    // 001. 10-01-20 ZY-LD 000 - Send e-mail when error.
    // 002. 30-01-20 ZY-LD 000 - Import stocklevel the old way.
    // 003. 21-12-21 ZY-LD 000 - On the old way, it send an e-mail every 5 min, and that was a problem in the weekend.


    trigger OnRun()
    begin
        DownloadVCK(0, true);
        InventoryImport(0);
    end;

    var
        VisionFTPMgt: Codeunit "VisionFTP Management";
        FileMgt: Codeunit "File Management";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        Servername: Text;


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
        ArchiveFile: File;
        InStream: InStream;
        xmlStockInbound: XmlPort "Read Stock Level Response";
        xmlReadStockReq: XmlPort "Read Stock Level Request";
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
        if recZyFileMgt.FindSet(true) then begin
            repeat
                if ArchiveFile.Open(recZyFileMgt.Filename) then begin
                    ArchiveFile.CreateInstream(InStream);

                    //>> 05-04-22 ZY-LD 004
                    FilenameXml := recZyFileMgt.Filename;
                    FilenameXml := DelChr(FilenameXml, '=', 'NULL');
                    FilenameXml := CopyStr(FilenameXml, StrPos(FilenameXml, '_'), StrLen(FilenameXml));
                    FilenameXml := DelChr(FilenameXml, '=', '_');
                    Evaluate(YYYY, CopyStr(FilenameXml, 1, 4));
                    Evaluate(MM, CopyStr(FilenameXml, 5, 2));
                    Evaluate(DD, CopyStr(FilenameXml, 7, 2));

                    Clear(xmlStockInbound);
                    xmlStockInbound.Init(Dmy2date(DD, MM, YYYY) - 1);  // The warehouse inventory date is the day before the file is created.
                    //<< 05-04-22 ZY-LD 004
                    xmlStockInbound.SetSource(InStream);

                    //if xmlStockInbound.Import then begin
                    Commit;
                    LastErrorText := '';
                    ClearLastError();
                    if not xmlStockInbound.Import() then
                        LastErrorText := GetLastErrorText();

                    if LastErrorText = '' then begin
                        recZyFileMgt.Open := false;
                        if not GuiAllowed then begin
                            EmailAddMgt.CreateSimpleEmail('VCKINVREQ', '', '');
                            EmailAddMgt.Send;
                        end;

                        //>> 05-04-22 ZY-LD 004
                        Clear(xmlReadStockReq);
                        xmlReadStockReq.Init(Dmy2date(DD, MM, YYYY) - 1);
                        //<< 05-04-22 ZY-LD 004
                        //>> 30-01-20 ZY-LD 002
                        xmlReadStockReq.SetSource(InStream);
                        xmlReadStockReq.Import;
                        //<< 30-01-20 ZY-LD 002
                    end else
                        recZyFileMgt."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(recZyFileMgt."Error Text"));
                    recZyFileMgt.Modify;
                    ArchiveFile.Close;
                end;

                //>> 21-12-21 ZY-LD 003
                //ImportErrorOccured := recZyFileMgt."Error Text" <> '';  // 10-01-20 ZY-LD 001
                if recZyFileMgt."Error Text" <> '' then begin
                    recAutoSetup.Get;
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today) then begin
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send;

                        recAutoSetup."Warehouse Import Error Date" := Today;
                        recAutoSetup.Modify;
                    end;
                end;
            //<< 21-12-21 ZY-LD 003
            until recZyFileMgt.Next() = 0;

            //>> 21-12-21 ZY-LD 003
            /*//>> 10-01-20 ZY-LD 001
            IF ImportErrorOccured THEN BEGIN
              EmailAddMgt.CreateSimpleEmail('VCKIMPDOC','','');
              EmailAddMgt.Send;
            END;
            //<< 10-01-20 ZY-LD 001*/
            //<< 21-12-21 ZY-LD 003
        end;

    end;


    procedure DownloadVCK(Type: Option " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR; Import: Boolean)
    var
        recWhseSetup: Record "Warehouse Setup";
        recWarehouse: Record Location;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'Downloading from VCK';
    begin
        recWhseSetup.Get;
        if GuiAllowed or recWhseSetup.WhsePostingAllowed then begin
            ZGT.OpenProgressWindow(lText001, 1);
            ZGT.UpdateProgressWindow(lText001, 0, true);
            recWarehouse.SetRange(Warehouse, recWarehouse.Warehouse::VCK);
            recWarehouse.FindFirst;
            recWarehouse.TestField("Warehouse Outbound FTP Code");
            FtpMgt.DownloadFolder(recWarehouse."Warehouse Outbound FTP Code");
            ZGT.CloseProgressWindow;

            if Import then
                case Type of
                    Type::"VCK Inventory":
                        InventoryImport(0);
                    else begin
                        InventoryImport(0);
                    end;
                end;
        end;
    end;
}
