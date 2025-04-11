codeunit 50049 "Process RMA"
{
    trigger OnRun()
    var
        AutoSetup: Record "Automation Setup";
    begin
        AutoSetup.get;
        if AutoSetup.AutomationAllowed() and AutoSetup.EndOfMonthAllowed() then begin
            if AutoSetup."Import and Post LMR" then begin
                DownloadLMR('LMR');
                ImportLMR(0);
            end;
            if AutoSetup."Import and Post Whse. RMA" then
                CreateAndPostVCKRMA();
        end;
    end;

    procedure RunManually();
    var
        lText001: label 'Do you want to download, import and post data from Let me Repair (LMR)?';
    begin
        if Confirm(lText001, true) then
            Run();
    end;

    local procedure DownloadLMR(pFolder: Code[20])
    FtpMgt: Codeunit "VisionFTP Management";
    begin
        FtpMgt.DownloadFolder(pFolder);
    end;

    local procedure ImportLMR(pEntryNo: Integer)
    var
        recZyFileMgt: Record "Zyxel File Management";
        recZyFileMgt2: Record "Zyxel File Management";
        AutoSetup: Record "Automation Setup";
        MailAddMgt: Codeunit "E-mail Address Management";
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        ImportLMRSheet: Report "Import LMR Sheet";
        FilenameForDate: Text;
        lText001: Label 'Import LMR';
    begin
        AutoSetup.get;

        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::LMR);
        recZyFileMgt.SetRange(Open, true);
        recZyFileMgt.SetFilter("On Hold", '%1', '');
        if pEntryNo <> 0 then
            recZyFileMgt.SetRange("Entry No.", pEntryNo);
        if recZyFileMgt.FindSet() then begin
            ZGT.OpenProgressWindow(lText001, recZyFileMgt.Count());
            repeat
                IF GetDateOutOfText(recZyFileMgt.Filename) > AutoSetup."Last LMR Date" then begin
                    ZGT.UpdateProgressWindow(lText001, 0, true);
                    recZyFileMgt2.Get(recZyFileMgt."Entry No.");

                    Clear(ImportLMRSheet);
                    ImportLMRSheet.InitReport(recZyFileMgt.Filename);
                    ImportLMRSheet.useRequestPage(false);
                    ImportLMRSheet.RunModal();

                    recZyFileMgt2.Open := false;
                    recZyFileMgt2."Error Text" := '';
                    recZyFileMgt2.Modify();

                    Commit();
                    PostRMAJnl();

                    AutoSetup.Modify();
                    Commit();
                end;
            until recZyFileMgt.next = 0;
        end else begin
            Clear(MailAddMgt);
            MailAddMgt.CreateSimpleEmail('RMANOFILE', '', '');
            MailAddMgt.Send();
        end;
    end;

    local procedure CreateAndPostVCKRMA()
    var
        ImportVCKRMA: Report "Import VCK RMA";
    begin
        ImportVCKRMA.RunModal();
        Commit();
        PostRMAJnl();
    end;

    local procedure PostRMAJnl()
    var
        ItemRegister: Record "Item Register";
        AutoSetup: Record "Automation Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        FileMgt: Codeunit "File Management";
        MailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        PostLMRStock: Report "Post LMR Stock";
        ItemRegQty: Report "Item Register - Quantity";
        ServerFilename: Text;
        lText001: Label 'Item register - Quantity';
    begin
        PostLMRStock.UseRequestPage(false);
        PostLMRStock.RunModal();
        Commit;

        if PostLMRStock.GetPostingStatus then begin  // Item Journal has been posted.
            SalesSetup.get;
            ItemRegister.SetRange("Creation Date", today);
            ItemRegister.SetRange("Journal Batch Name", SalesSetup."LMR Item Journal Batch Name");
            ItemRegister.SetFilter("From Entry No.", '<>0');
            If ItemRegister.FindLast() then begin
                ServerFilename := FileMgt.ServerTempFileName('');
                ItemRegister.FindLast();
                ItemRegister.SetRange("No.", ItemRegister."No.");
                ItemRegQty.SetTableView(ItemRegister);
                ItemRegQty.SaveAsExcel(ServerFilename);

                AutoSetup.get;
                SI.SetMergefield(100, Format(ItemRegister."To Entry No." - ItemRegister."From Entry No." + 1));
                Clear(MailAddMgt);
                MailAddMgt.CreateEmailWithAttachment('RMAJNLPOST', '', '', ServerFilename, StrSubstNo('%1 %2.xlsx', lText001, AutoSetup."Last LMR Date"), false);
                MailAddMgt.Send();
            end;
        end;
    end;

    local procedure GetDateOutOfText(lDateText: Text) rValue: Date
    var
        FileMgt: Codeunit "File Management";
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
    begin
        lDateText := FileMgt.GetFileName(lDateText);
        Evaluate(YYYY, CopyStr(lDateText, StrPos(lDateText, '_') + 1, 4));
        Evaluate(MM, CopyStr(lDateText, StrPos(lDateText, '_') + 5, 2));
        Evaluate(DD, CopyStr(lDateText, StrPos(lDateText, '_') + 7, 2));
        rValue := DMY2Date(DD, MM, YYYY);
    end;

    /*local procedure SendRMAReminder()
    var
        EmailAdd: Record "E-mail address";
        EmailAddMgt: Codeunit "E-mail Address Management";
    Begin
        // Send every Friday and the last day of the month
        if (Date2DWY(today, 2) = 5) or (CalcDate('<CM>', today) = today) then
            if EmailAdd.get('REMINDRMA') and (DT2Date(EmailAdd."Last E-mail Send Date Time") < today) then begin
                Clear(EmailAddMgt);
                EmailAddMgt.CreateSimpleEmail(EmailAdd.Code, '', '');
                EmailAddMgt.Send();

                EmailAdd."Last E-mail Send Date Time" := CurrentDateTime;
                EmailAdd.Modify;
            end;
    End;*/
}
