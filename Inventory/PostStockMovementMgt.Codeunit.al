Codeunit 50092 "Post Stock Movement Mgt."
{

    trigger OnRun()
    begin
        DownloadVCK(3, true);
        StockMovementImport(0);
        SendReminder;
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";


    procedure StockMovementImport(pEntryNo: Integer)
    var
        recZyFileMgt: Record "Zyxel File Management";
        recAutoSetup: Record "Automation Setup";
        ArchiveFile: File;
        InStream: InStream;
        xmlStockCorr: XmlPort "Read Stock Correction";
        lText001: label 'Import VCK Stock Movement';
        lText002: label 'Document could not open.';
        ImportErrorOccured: Boolean;
    begin
        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::"VCK Stock Correction");
        recZyFileMgt.SetRange(Open, true);
        recZyFileMgt.SetFilter("On Hold", '%1', '');
        if pEntryNo <> 0 then
            recZyFileMgt.SetRange("Entry No.", pEntryNo);
        if recZyFileMgt.FindSet(true) then begin
            ZGT.OpenProgressWindow(lText001, recZyFileMgt.Count);
            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);
                if ArchiveFile.Open(recZyFileMgt.Filename) then begin
                    ArchiveFile.CreateInstream(InStream);
                    Clear(xmlStockCorr);
                    xmlStockCorr.SetSource(InStream);
                    xmlStockCorr.Init(recZyFileMgt."Entry No.");
                    if xmlStockCorr.Import then begin
                        recZyFileMgt.Open := false;
                        recZyFileMgt."Error Text" := '';
                    end else
                        recZyFileMgt."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(recZyFileMgt."Error Text"));
                    recZyFileMgt.Modify;
                    ArchiveFile.Close;

                    Commit;
                end else begin
                    recZyFileMgt."Error Text" := lText002;
                    recZyFileMgt.Modify;
                end;

                if recZyFileMgt."Error Text" <> '' then begin
                    recAutoSetup.Get;
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today) then begin
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send;

                        recAutoSetup."Warehouse Import Error Date" := Today;
                        recAutoSetup.Modify;
                    end;
                end;
            until recZyFileMgt.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;


    procedure DownloadVCK(Type: Option " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR; Import: Boolean)
    var
        recWhseSetup: Record "Warehouse Setup";
        recWarehouse: Record Location;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'Downloading from VCK';
    begin
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
                        StockMovementImport(0);
                    else
                        StockMovementImport(0);
                end;
        end;
    end;

    local procedure SendReminder()
    var
        recWhseStockCorrLedEntry: Record "Whse. Stock Corr. Led. Entry";
        recEmailadd: Record "E-mail address";
        EmailAddMgt: Codeunit "E-mail Address Management";
    begin
        recWhseStockCorrLedEntry.SetRange(Open, true);
        if not recWhseStockCorrLedEntry.IsEmpty then begin
            recEmailadd.Get('VCKSTCKCOR');
            if Dt2Date(recEmailadd."Last E-mail Send Date Time") < Today then begin
                EmailAddMgt.CreateSimpleEmail(recEmailadd.Code, '', '');
                EmailAddMgt.Send;

                recEmailadd."Last E-mail Send Date Time" := CurrentDatetime;
                recEmailadd.Modify;
            end;
        end;
    end;
}
