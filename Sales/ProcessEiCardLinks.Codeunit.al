Codeunit 50039 "Process EiCard Links"
{
    // 001. 20-09-19 ZY-LD 2019092010000044 - Send reminder to eShop.
    // 002. 15-10-19 ZY-LD 000 - EMS License doesn't have a file to download.
    // 003. 07-01-20 ZY-LD P0368 - Send to eShop with delay.
    // 004. 21-01-20 ZY-LD 2020012110000081 - Send invoice reminder.
    // 005. 18-02-20 ZY-LD P0395 - Don't send Consignment and eCommerce to the customer.
    // 006. 23-03-20 ZY-LD 2020032310000047 - Download only links if quantity is below 100, otherwise it might timeout.
    // 007. 11-09-20 ZY-LD 000 - We have seen issues where the download has timed out on small downloads. This will make it possible to drop the download and only send the links.
    // 008. 14-01-21 ZY-LD 2021011410000075 - The customer can force a download no matter what the automation says.
    // 009. 21-01-21 ZY-LD 000 - SendEicardToEshop is made global.
    // 010. 20-04-22 ZY-LD 000 - Setup secure protocol to handle "https:". EicardLinks.Quantity is set equal to SalesLine.Quantity so we can post the sales order.
    // 011. 24-05-23 ZY-LD 000 - GLC License doesn´t not have a file to download.

    Permissions = TableData "EiCard Link Line" = rm;

    trigger OnRun()
    begin
        recSalesSetup.Get;
        recAutoSetup.Get;
        if recSalesSetup."EiCard Automation Enabled" and
            recAutoSetup.SendEmailWithEicardLinksAlowed
        then
            SendEiCardLinks('', '', false);

        if recAutoSetup.AutomationAllowed and recAutoSetup.EndOfMonthAllowed then
            SendEshopReminder;

        //>> 07-01-20 ZY-LD 003
        if recAutoSetup.SendEicardToEshopAllowed then
            SendEicardToEshop;
        //<< 07-01-20 ZY-LD 003
    end;

    var
        recServEnviron: Record "Server Environment";
        Text01: label '<br><table style="border=&quot;0&quot; width:150%"><tbody>';
        Text02: label '<tr><small>';
        Text04: label '</small></tr>';
        Text03: label '<td style="width: 33%;"><span style="font-family: Century Gothic;">';
        Text05: label '</span></td>';
        Text08: label 'eicard.htm';
        Text09: label 'Dear Customer<br></br>Below is a list of your EiCard order. Your order number: %1.<br></br> Licenses can be downloaded by clicking on the download links or alternatively they are also attached to this email.<br></br>';
        Text10: label '\\ZYEU-NAVSQL02\NAV HTML Emails\';
        Text11: label 'Dear Customer<br></br>Below is your EiCard order. Your order number: %1.<br></br>The License can be downloaded by clicking on the download link or alternatively the license is also attached to this email.<br></br>';
        Text16: label 'EMAIL';
        Text17: label 'NAME';
        Text18: label 'TABLE';
        Text19: label '</Table>';
        Text20: label 'spacer.gif';
        Text21: label 'zyxellogo.gif';
        Text22: label 'nebula.png';
        Text23: label '.zip';
        Text24: label '<b>Item No.</b>';
        Text25: label '<b>Description</b>';
        Text26: label '<b> </b>';
        Text29: label 'ADDRESS1';
        Text30: label 'ADDRESS2';
        Text31: label 'ADDRESS3';
        Text32: label 'PHONE';
        Text33: label 'COLOR';
        Text34: label 'BODY';
        Text35: label 'rgb(0,62,171)';
        Text36: label 'zmangif.gif';
        Text37: label 'DISCLAIMER';
        Text38: label 'disclaimer.htm';
        Text39: label 'download.jpg';
        Text40: label '<a href="LINK"><img src="cid:download.jpg" alt="Download" v:shapes="Picture_x0020_4" border="0" ></a>';
        Text41: label 'LINK';
        Text42: label 'Dear Customer<br></br>Below is a list of your EiCard order. Your order number: %1.<br></br> Licenses can be downloaded by clicking on the download links.<br></br>';
        recSalesSetup: Record "Sales & Receivables Setup";
        recAutoSetup: Record "Automation Setup";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SendEiCardLinks(SalesOrderNo: Code[20]; TestEmailAdd: Text; ReSend: Boolean) rValue: Boolean
    var
        recEiCardQueue: Record "EiCard Queue";
        lText001: label 'Number of "Sales Order Lines" does not match number of "EiCard Link Lines" on %1.';
        lText002: label '"%1" on the sales order must be filled.';
        FilesSavedInFolder: Text;
    begin
        recEiCardQueue.LockTable;
        recEiCardQueue.SetFilter("Purchase Order Status", '%1|%2', recEiCardQueue."purchase order status"::"EiCard Order Accepted", recEiCardQueue."purchase order status"::Posted);
        recEiCardQueue.SetFilter("No. of EiCard Link Lines", '>0');
        if not ReSend then
            recEiCardQueue.SetRange("Sales Order Status", recEiCardQueue."sales order status"::"Purchase Order Created");
        recEiCardQueue.SetRange(Active, not ReSend);
        if SalesOrderNo <> '' then
            recEiCardQueue.SetRange("Sales Order No.", SalesOrderNo);
        recEiCardQueue.SetAutocalcFields("No. of Sales Order Lines", "No. of EiCard Link Lines", "Quantity Sales Order");  // 23-05-23 ZY-LD 011 - "Quantity Sales Order" is added.
        if recEiCardQueue.FindSet(true) then
            repeat
                recEiCardQueue."Error Description" := '';

                //>> 23-05-23 ZY-LD 011
                //IF (recEiCardQueue."No. of Sales Order Lines" = recEiCardQueue."No. of EiCard Link Lines") OR ReSend THEN BEGIN
                if (recEiCardQueue."No. of Sales Order Lines" = recEiCardQueue."No. of EiCard Link Lines") or
                   (recEiCardQueue."Quantity Sales Order" = recEiCardQueue."No. of EiCard Link Lines") or
                   ReSend  //<< 23-05-23 ZY-LD 011
                then begin
                    if recEiCardQueue."External Document No." <> '' then begin
                        if DownloadEiCardLinkFiles(
                             recEiCardQueue."Purchase Order No.",
                             recEiCardQueue."Sales Order No.",  // 23-03-20 ZY-LD 006
                             FilesSavedInFolder,
                             recEiCardQueue."Customer No.")  // 14-01-21 ZY-LD 008
                        then begin
                            recEiCardQueue.CalcFields("Size (Mb)");
                            if SendEiCardLink(recEiCardQueue, TestEmailAdd, ReSend) then begin
                                if TestEmailAdd = '' then begin
                                    recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::"EiCard Sent to Customer");
                                    //FileMgt.ServerRemoveDirectory(FilesSavedInFolder,TRUE);  // Delete files after e-mail.
                                    //recEiCardLinkLine.SETRANGE("Purchase Order No.",recEiCardQueue."Purchase Order No.");
                                    //recEiCardLinkLine.MODIFYALL(Filename,'');
                                end;
                                rValue := true;
                            end else
                                recEiCardQueue."Error Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(recEiCardQueue."Error Description"));
                        end else
                            recEiCardQueue."Error Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(recEiCardQueue."Error Description"));
                    end else
                        recEiCardQueue."Error Description" := StrSubstNo(lText002, recEiCardQueue.FieldCaption("External Document No."));
                end else
                    recEiCardQueue."Error Description" := StrSubstNo(lText001, recEiCardQueue."Sales Order No.");

                recEiCardQueue.Modify(true);
                Commit;
            until recEiCardQueue.Next() = 0;
    end;

    local procedure DownloadEiCardLinkFiles(PurchOrderNo: Code[20]; SalesOrderNo: Code[20]; var SaveFilesInFolder: Text; CustNo: Code[20]) rValue: Boolean
    var
        recEiCardLinkLine: Record "EiCard Link Line";
        recFTPFolder: Record "FTP Folder";
        recFile: Record File;
        recItem: Record Item;
        recSalesLine: Record "Sales Line";
        recCust: Record Customer;
        WebClient: dotnet WebClient;
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
        Filename: Text;
        FileMgt: Codeunit "File Management";
        lText001: label 'EiCard Link file "%1" was not downloaded.';
        ServerDir: Text;
        lText002: label 'Download file';
    begin
        // Download http-links to a file.
        //IF recAutoSetup."Download and Attach Eicards" THEN BEGIN  // 11-09-20 ZY-LD 007  // 14-01-21 ZY-LD 008
        recEiCardLinkLine.SetRange("Purchase Order No.", PurchOrderNo);
        recEiCardLinkLine.SetFilter(Link, '<>%1', '');
        if recEiCardLinkLine.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recEiCardLinkLine.Count);

            recServEnviron.Get;
            recFTPFolder.Get('HQ-EICARD-LINKS', recServEnviron.Environment);
            recFTPFolder.TestField(Active, true);
            recFTPFolder.TestField("Archive Folder");
            SaveFilesInFolder := StrSubstNo('%1%2\', recFTPFolder."Archive Folder", PurchOrderNo);
            if not FileMgt.ServerDirectoryExists(SaveFilesInFolder) then
                FileMgt.ServerCreateDirectory(SaveFilesInFolder);

            repeat
                ZGT.UpdateProgressWindow(lText002, 0, true);
                recItem.Get(recEiCardLinkLine."Item No.");  // 15-10-19 ZY-LD 002
                                                            //IF NOT recItem."EMS License" THEN BEGIN  // 15-10-19 ZY-LD 002  // 24-05-23 ZY-LD 011
                if recItem."Enter Security for Eicard on" = recItem."enter security for eicard on"::" " then begin  // 24-05-23 ZY-LD 011
                    if not recSalesLine.Get(recSalesLine."document type"::Order, SalesOrderNo, recEiCardLinkLine."Purchase Order Line No.") then;  // 23-03-20 ZY-LD 006
                    if not recCust.Get(CustNo) then  // 14-01-21 ZY-LD 008
                        Clear(recCust);  // 14-01-21 ZY-LD 008
                    if (recEiCardLinkLine.Filename = '') and
                        (recSalesLine.Quantity < recAutoSetup."Download if Qty. is Less than") and  // 23-03-20 ZY-LD 006
                        (recAutoSetup."Download and Attach Eicards" or recCust."Download and Attach Eicards")  // 14-01-21 ZY-LD 008
                    then begin
                        Filename := StrSubstNo('%1%2-%3-%4%5', SaveFilesInFolder, PurchOrderNo, recEiCardLinkLine."Purchase Order Line No.", recEiCardLinkLine."Line No.", Text23);
                        ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;  // 20-04-22 ZY-LD 010
                        WebClient := WebClient.WebClient;
                        WebClient.DownloadFile(recEiCardLinkLine.Link, Filename);
                        if FileMgt.ServerFileExists(Filename) then begin
                            recEiCardLinkLine.Filename := Filename;

                            // Find the size of the file
                            recFile.SetRange(Path, FileMgt.GetDirectoryName(recEiCardLinkLine.Filename));
                            recFile.SetRange(Name, FileMgt.GetFileName(recEiCardLinkLine.Filename));
                            if recFile.FindFirst and (recFile.Size > 0) then
                                recEiCardLinkLine."Size (MB)" := ROUND(recFile.Size / 1000000);

                            // Count number of .pdf files. It has to be the same as on the sales order.
                            recFile.Reset;
                            ServerDir := StrSubstNo('%1\%2', FileMgt.GetDirectoryName(recEiCardLinkLine.Filename), PurchOrderNo);
                            FileMgt.ServerCreateDirectory(ServerDir);
                            ExtractZipFile(recEiCardLinkLine.Filename, ServerDir);
                            recFile.SetRange(Path, ServerDir);
                            recFile.SetRange("Is a file", true);
                            recFile.SetFilter(Name, '*.pdf');
                            recEiCardLinkLine.Quantity := recFile.Count;
                            FileMgt.ServerRemoveDirectory(ServerDir, true);

                            recEiCardLinkLine.Modify(true);
                            Commit;  // The file is downloaded, so we have to commit here.

                            rValue := true;
                        end else
                            Error(lText001, Filename);
                    end else begin
                        //>> 20-04-22 ZY-LD 010
                        recEiCardLinkLine.Quantity := recSalesLine.Quantity;
                        recEiCardLinkLine.Modify(true);
                        //<< 20-04-22 ZY-LD 010

                        rValue := true;
                    end;
                end else
                    rValue := true;
            until recEiCardLinkLine.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
        //END ELSE  // 14-01-21 ZY-LD 008
        //  rValue := TRUE;  // 11-09-20 ZY-LD 007  // 14-01-21 ZY-LD 008
    end;

    local procedure SendEiCardLink(recEiCardQueue: Record "EiCard Queue"; TestEmailAdd: Text; ReSend: Boolean): Boolean
    var
        recEiCardLinkLine: Record "EiCard Link Line";
        recEmailAdd: Record "E-mail address";
        "Table": Text;
        Body: Text;
        FilenameCount: Integer;
        AttachementSize: BigInteger;
        EmailAddMgt: Codeunit "E-mail Address Management";
        FileMgt: Codeunit "File Management";
    begin
        recEmailAdd.Get('EICARDLINK');
        Body := GetEmailBody(Text10 + Text08, recEiCardQueue."No. of EiCard Link Lines" > 1, AttachementSize);
        Table := GetTableHeader;

        // Setup Body
        Body := ReplaceString(Body, '%1', recEiCardQueue."External Document No.");
        Body := ReplaceString(Body, Text16, recEiCardQueue."From E-Mail Address");
        Body := ReplaceString(Body, Text17, recEiCardQueue."From E-Mail Signature");

        recEiCardLinkLine.SetRange("Purchase Order No.", recEiCardQueue."Purchase Order No.");
        recEiCardLinkLine.SetFilter(Link, '<>%1', '');
        recEiCardLinkLine.SetAutocalcFields("Item Description");
        if recEiCardLinkLine.FindSet then begin
            repeat
                Table := Table + AddTableLine(recEiCardLinkLine."Item No.", recEiCardLinkLine."Item Description", recEiCardLinkLine.Link);
            until recEiCardLinkLine.Next() = 0;
        end;
        Table := Table + Text19;

        Body := ReplaceString(Body, Text18, Table);

        // Create e-mail
        Clear(EmailAddMgt);
        EmailAddMgt.SetCustomerMergefields(recEiCardQueue."Customer No.");
        if not ReSend then
            EmailAddMgt.SetSalesHeaderMergeFields("Sales Document Type"::Order, recEiCardQueue."Sales Order No.")
        else begin
            SI.SetMergefield(60, recEiCardQueue."External Document No.");
            SI.SetMergefield(68, recEiCardQueue."Distributor Reference");
        end;
        if recServEnviron.ProductionEnvironment and (TestEmailAdd = '') then begin
            EmailAddMgt.CreateEmailWithBodytext2(recEmailAdd.Code, DelChr(recEiCardQueue."Distributor E-mail", '=', ','), Body, '');
            EmailAddMgt.AddCC(DelChr(recEiCardQueue."End User E-mail", '=', ','));
            EmailAddMgt.AddCC(DelChr(recEiCardQueue."EiCard To E-mail 2", '=', ','));
            EmailAddMgt.AddCC(DelChr(recEiCardQueue."EiCard To E-mail 3", '=', ','));
            EmailAddMgt.AddCC(DelChr(recEiCardQueue."EiCard To E-mail 4", '=', ','));
        end else begin
            if TestEmailAdd = '' then
                TestEmailAdd := StrSubstNo('%1@zyxel.eu', CopyStr(UserId(), 6, StrLen(UserId())));
            EmailAddMgt.CreateEmailWithBodytext2(recEmailAdd.Code, TestEmailAdd, Body, '');
        end;

        // Add attachments
        if recEiCardQueue."Size (Mb)" < 15 then
            if recEiCardQueue."No. of EiCard Link Lines" = 1 then begin
                recEiCardLinkLine.FindFirst;
                if FileMgt.ServerFileExists(recEiCardLinkLine.Filename) then
                    EmailAddMgt.AddAttachment(
                      recEiCardLinkLine.Filename,
                      StrSubstNo('%1 - %2%3', recEiCardQueue."External Document No.", recEiCardLinkLine."Item Description", Text23),
                      false)
            end else begin
                FilenameCount := 1;
                if recEiCardLinkLine.FindSet then
                    repeat
                        if FileMgt.ServerFileExists(recEiCardLinkLine.Filename) then begin
                            EmailAddMgt.AddAttachment(
                              recEiCardLinkLine.Filename,
                              StrSubstNo('%1 - %2 - %3%4', recEiCardQueue."External Document No.", recEiCardLinkLine."Item Description", FilenameCount, Text23),
                              false);
                            FilenameCount := FilenameCount + 1;
                        end;
                    until recEiCardLinkLine.Next() = 0;
            end;

        EmailAddMgt.AddAttachment(Text10 + Text20, Text20, false);
        EmailAddMgt.AddAttachment(Text10 + Text21, Text21, false);
        EmailAddMgt.AddAttachment(Text10 + Text22, Text22, false);
        EmailAddMgt.AddAttachment(Text10 + Text36, Text36, false);
        EmailAddMgt.AddAttachment(Text10 + Text39, Text39, false);

        // Send e-mail
        EmailAddMgt.Send;

        exit(true);
    end;

    local procedure GetEmailBody(HTMLFileName: Text[250]; Plural: Boolean; AttachementSize: Decimal) HTMLStr: Text
    var
        file: File;
        Linestr: Text;
        recCompanyInformation: Record "Company Information";
    begin
        if Exists(HTMLFileName) then begin
            file.TextMode(true);
            file.WriteMode(false);
            file.Open(HTMLFileName);
            repeat
                file.Read(Linestr);
                HTMLStr := HTMLStr + Linestr;
            until file.POS = file.LEN;
            file.Close;
            if recCompanyInformation.FindFirst then begin
                HTMLStr := ReplaceString(HTMLStr, Text29, recCompanyInformation.Address);
                HTMLStr := ReplaceString(HTMLStr, Text30, recCompanyInformation.City);
                HTMLStr := ReplaceString(HTMLStr, Text31, recCompanyInformation."Post Code");
                HTMLStr := ReplaceString(HTMLStr, Text32, recCompanyInformation."Phone No.");
            end else begin
                HTMLStr := ReplaceString(HTMLStr, Text29, '');
                HTMLStr := ReplaceString(HTMLStr, Text30, '');
                HTMLStr := ReplaceString(HTMLStr, Text31, '');
                HTMLStr := ReplaceString(HTMLStr, Text32, '');
            end;
            HTMLStr := ReplaceString(HTMLStr, Text33, Text35);
            HTMLStr := ReplaceString(HTMLStr, Text37, GetEmailDisclaimer(Text10 + Text38));
            if AttachementSize < 50000000 then
                if Plural then
                    HTMLStr := ReplaceString(HTMLStr, Text34, Text09)
                else
                    HTMLStr := ReplaceString(HTMLStr, Text34, Text11);
            if AttachementSize >= 50000000 then
                if Plural then
                    HTMLStr := ReplaceString(HTMLStr, Text34, Text42)
                else
                    HTMLStr := ReplaceString(HTMLStr, Text34, Text11);
        end;
    end;

    local procedure GetEmailDisclaimer(HTMLFileName: Text) HTMLStr: Text
    var
        file: File;
        Linestr: Text;
    begin
        if Exists(HTMLFileName) then begin
            file.TextMode(true);
            file.WriteMode(false);
            file.Open(HTMLFileName);
            repeat
                file.Read(Linestr);
                HTMLStr := HTMLStr + Linestr;
            until file.POS = file.LEN;
            file.Close;
        end;
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text[250]; ReplaceWith: Text) NewString: Text
    begin
        while StrPos(String, FindWhat) > 0 do
            String := DelStr(String, StrPos(String, FindWhat)) + ReplaceWith + CopyStr(String, StrPos(String, FindWhat) + StrLen(FindWhat));
        NewString := String;
    end;

    local procedure GetTableHeader() "Table": Text
    begin
        Table := Text01;
        Table := Table + Text02;
        Table := Table + Text03;
        Table := Table + Text24;
        Table := Table + Text05;
        Table := Table + Text03;
        Table := Table + Text25;
        Table := Table + Text05;
        Table := Table + Text03;
        Table := Table + Text26;
        Table := Table + Text05;
        Table := Table + Text04;
    end;

    local procedure AddTableLine(ItemNo: Code[20]; Description: Text; Link: Text) "Table": Text
    var
        LinkStr: Text;
    begin
        LinkStr := ReplaceString(Text40, Text41, Link);
        Table := Table + Text02;
        Table := Table + Text03;
        Table := Table + ItemNo;
        Table := Table + Text05;
        Table := Table + Text03;
        Table := Table + Description;
        Table := Table + Text05;
        Table := Table + Text03;
        Table := Table + LinkStr;
        Table := Table + Text05;
        Table := Table + Text04;
    end;

    local procedure SendEshopReminder()
    var
        recEiCardQueue: Record "EiCard Queue";
        recAutoSetup: Record "Automation Setup";
        recHqInvHead: Record "HQ Invoice Header";
        EmailAddmgt: Codeunit "E-mail Address Management";
    begin
        //>> 21-01-20 ZY-LD 004
        recAutoSetup.Get;
        if recAutoSetup."Purchase Inv. Eicard Reminder" > 0 then begin
            recEiCardQueue.Reset;
            recEiCardQueue.SetRange("Purchase Order Status", recEiCardQueue."purchase order status"::"EiCard Order Accepted");
            recEiCardQueue.SetRange(Active, true);
            recEiCardQueue.SetRange("Invoice Reminder Sent", false);
            recEiCardQueue.SetFilter("Creation Date", '..%1', CurrentDatetime - (1000 * 60 * 60 * 24 * recAutoSetup."Purchase Inv. Eicard Reminder"));
            if recEiCardQueue.FindSet(true) then
                repeat
                    recHqInvHead.SetRange("Purchase Order No.", recEiCardQueue."Purchase Order No.");
                    if not recHqInvHead.FindFirst then begin
                        SI.SetMergefield(71, recEiCardQueue."Purchase Order No.");
                        SI.SetMergefield(100, Format(recEiCardQueue."Creation Date"));
                        EmailAddmgt.CreateSimpleEmail('EICINVRIMD', '', '');
                        EmailAddmgt.Send;

                        recEiCardQueue."Invoice Reminder Sent" := true;
                        recEiCardQueue.Modify;
                        Commit;
                    end;
                until recEiCardQueue.Next() = 0;
        end;
        //<< 21-01-20 ZY-LD 004
    end;


    procedure SendEicardToEshop()
    var
        recEicardQueue: Record "EiCard Queue";
        EicardMgt: Codeunit "ZyXEL EiCards";
    begin
        //>> 07-01-20 ZY-LD 003
        if recAutoSetup."Delay Between Create and eShop" = 0 then
            recAutoSetup."Delay Between Create and eShop" := 1;

        recEicardQueue.SetRange("Purchase Order Status", recEicardQueue."purchase order status"::Created);
        recEicardQueue.SetRange(Active, true);
        recEicardQueue.SetFilter("Creation Date", '..%1', CurrentDatetime - (1000 * 60 * recAutoSetup."Delay Between Create and eShop"));  // 30 min.
        if recEicardQueue.FindSet(true) then
            repeat
                EicardMgt.SendToHQ(recEicardQueue, false);
            until recEicardQueue.Next() = 0;
        //<< 07-01-20 ZY-LD 003
    end;

    local procedure ExtractZipFile(ZipFilePath: Text; DestinationFolder: Text)
    var
        FileMgt: Codeunit "File Management";
        Text004: Label 'The file %1 does not exist.';
        Zip: DotNet Zip;
        ZipFile: DotNet ZipFile;
        ZipArchive: DotNet ZipArchive;
        ZipArchiveMode: DotNet ZipArchiveMode;

    begin
        IF NOT FileMgt.ServerFileExists(ZipFilePath) THEN
            ERROR(Text004, ZipFilePath);

        // Create directory if it doesn't exist
        FileMgt.ServerCreateDirectory(DestinationFolder);

        ZipArchive := ZipFile.Open(ZipFilePath, ZipArchiveMode.Read);
        Zip.ExtractToDirectory(ZipArchive, DestinationFolder);
        ZipArchive.Dispose;
    end;
}
