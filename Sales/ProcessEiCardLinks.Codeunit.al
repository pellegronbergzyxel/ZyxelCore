Codeunit 50039 "Process EiCard Links"
{

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

        if recAutoSetup.SendEicardToEshopAllowed then
            SendEicardToEshop;
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
        recEiCardQueue.SetAutocalcFields("No. of Sales Order Lines", "No. of EiCard Link Lines", "Quantity Sales Order");
        if recEiCardQueue.FindSet(true) then
            repeat
                recEiCardQueue."Error Description" := '';
                if (recEiCardQueue."No. of Sales Order Lines" = recEiCardQueue."No. of EiCard Link Lines") or
                   (recEiCardQueue."Quantity Sales Order" = recEiCardQueue."No. of EiCard Link Lines") or
                   ReSend
                then begin
                    if recEiCardQueue."External Document No." <> '' then begin
                        if DownloadEiCardLinkFiles(
                             recEiCardQueue."Purchase Order No.",
                             recEiCardQueue."Sales Order No.",
                             FilesSavedInFolder,
                             recEiCardQueue."Customer No.")
                        then begin
                            recEiCardQueue.CalcFields("Size (Mb)");
                            if SendEiCardLink(recEiCardQueue, TestEmailAdd, ReSend) then begin
                                if TestEmailAdd = '' then begin
                                    recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::"EiCard Sent to Customer");
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
        //recFile: Record File;
        recItem: Record Item;
        recSalesLine: Record "Sales Line";
        recCust: Record Customer;
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        ContentInStream: InStream;
        //OutFile: File;
        OutStream: OutStream;
        Filename: Text;
        FileMgt: Codeunit "File Management";
        lText001: label 'EiCard Link file "%1" was not downloaded.';
        ServerDir: Text;
        lText002: label 'Download file';
        lText003: label 'HttpClient.Get failed';
    begin
        // // CLOUD READY NEW
        recEiCardLinkLine.SetRange("Purchase Order No.", PurchOrderNo);
        recEiCardLinkLine.SetFilter(Link, '<>%1', '');
        if recEiCardLinkLine.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recEiCardLinkLine.Count);

            recServEnviron.Get;
            recFTPFolder.Get('HQ-EICARD-LINKS', recServEnviron.Environment);
            recFTPFolder.TestField(Active, true);
            recFTPFolder.TestField("Archive Folder");
            SaveFilesInFolder := StrSubstNo('%1%2\', recFTPFolder."Archive Folder", PurchOrderNo);

            repeat
                ZGT.UpdateProgressWindow(lText002, 0, true);
                recItem.Get(recEiCardLinkLine."Item No.");
                if recItem."Enter Security for Eicard on" = recItem."enter security for eicard on"::" " then begin
                    if not recSalesLine.Get(recSalesLine."document type"::Order, SalesOrderNo, recEiCardLinkLine."Purchase Order Line No.") then;
                    if not recCust.Get(CustNo) then
                        Clear(recCust);
                    if (recEiCardLinkLine.Filename = '') and
                        (recSalesLine.Quantity < recAutoSetup."Download if Qty. is Less than") and
                        (recAutoSetup."Download and Attach Eicards" or recCust."Download and Attach Eicards")
                    then begin
                        Filename := StrSubstNo('%1%2-%3-%4%5', SaveFilesInFolder, PurchOrderNo, recEiCardLinkLine."Purchase Order Line No.", recEiCardLinkLine."Line No.", Text23);
                        if HttpClient.Get(recEiCardLinkLine.Link, HttpResponse) and HttpResponse.IsSuccessStatusCode() then begin
                            HttpResponse.Content.ReadAs(ContentInStream);
                            recEiCardLinkLine.filblob.CreateOutStream(OutStream);
                            CopyStream(OutStream, ContentInStream);
                            if ContentInStream.Length <> 0 then
                                recEiCardLinkLine."Size (MB)" := ContentInStream.Length / 1000000;
                            recEiCardLinkLine.modify;

                            if (recEiCardLinkLine."Purchase Order No." <> '') and (recEiCardLinkLine."Purchase Order Line No." <> 0) then //30-06-2026 BK ##581893
                                recEiCardLinkLine.Quantity := FindPurchaseOrder(recEiCardLinkLine."Purchase Order No.", recEiCardLinkLine."Purchase Order Line No.");
                            recEiCardLinkLine.Modify(true);

                            Commit;  // The file is downloaded, so we have to commit here.
                            rValue := true;
                        end else begin
                            recEiCardLinkLine.Quantity := recSalesLine.Quantity;
                            recEiCardLinkLine.Modify(true);
                            Error(lText003); //08-07-2026 BK #585893
                        end;
                    end else begin
                        rValue := true;
                    end;
                end else
                    rValue := true; //08-07-2026 BK #585893
            until recEiCardLinkLine.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
    end;

    procedure createEicardLinkHtml(recEiCardQueue: Record "EiCard Queue"): Text
    var
        tempblob: codeunit "Temp Blob";
        EiCardQueue: Record "EiCard Queue";
        EiCardQueueRecord: report "EiCard Queue Record";
        varoutstream: OutStream;
        Varinstream: instream;
        BodyTextOut: text;
        ReportParameters: text;
    begin
        tempblob.CreateOutStream(varoutstream, TextEncoding::UTF8);
        EiCardQueue.setrange("Sales Order No.", recEiCardQueue."Sales Order No.");
        EiCardQueueRecord.SetTableView(EiCardQueue);
        EiCardQueueRecord.SaveAs(ReportParameters, ReportFormat::Html, varoutstream);
        tempblob.CreateInStream(Varinstream, TextEncoding::UTF8);
        Varinstream.ReadText(BodyTextOut);
        exit(BodyTextOut);
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
        // CLOUR READY DELETE

        // CLOUD READY NEW >>
        Body := createEicardLinkHtml(recEiCardQueue);

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
        EmailAddMgt.Send;

        exit(true);
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
    end;


    procedure SendEicardToEshop()
    var
        recEicardQueue: Record "EiCard Queue";
        EicardMgt: Codeunit "ZyXEL EiCards";
    begin
        if recAutoSetup."Delay Between Create and eShop" = 0 then
            recAutoSetup."Delay Between Create and eShop" := 1;

        recEicardQueue.SetRange("Purchase Order Status", recEicardQueue."purchase order status"::Created);
        recEicardQueue.SetRange(Active, true);
        recEicardQueue.SetFilter("Creation Date", '..%1', CurrentDatetime - (1000 * 60 * recAutoSetup."Delay Between Create and eShop"));  // 30 min.
        if recEicardQueue.FindSet(true) then
            repeat
                EicardMgt.SendToHQ(recEicardQueue, false);
            until recEicardQueue.Next() = 0;
    end;
    //30-06-2026 BK #581893
    procedure FindPurchaseOrder(PurchaseOrderNo: Code[20]; PurchaseOrderLineNo: Decimal): Decimal
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if (PurchaseOrderNo <> '') and (PurchaseOrderLineNo <> 0) then
            if PurchaseLine.get(PurchaseLine."Document Type"::Order, PurchaseOrderNo, PurchaseOrderLineNo) then
                exit(PurchaseLine.Quantity);

    end;
}
