codeunit 50074 "E-mail Address Management"
{
    // 001. 14-05-18 ZY-LD 2018051410000154 - Subject pr. language.
    // 002. 23-05-18 ZY-LD 000 - New fields.
    // 003. 02-08-18 ZY-LD 2018060810000271 - Get subject and body.
    // 004. 28-09-18 ZY-LD 2018060810000271 - Get body in HTML.
    // 005. 16-10-18 ZY-LD 2018101610000042 - Get E-mail Code.
    // 006. 06-12-18 ZY-LD 000 - Setup e-mail.
    // 12-12-18 PAB - Added functionality for HTML templates.
    // 007. 03-01-18 ZY-LD 000 - User personal footer is added.
    // 008. 03-01-19 PAB - Added additional body Text
    // 009. 11-09-19 ZY-LD P0290 - Set Distributor reference.
    // 010. 14-11-19 ZY-LD P0339 - Delete server file.
    // 011. 22-11-19 ZY-LD 2019112110000029 - Individual subject pr. customer.
    // 012. 17-04-20 ZY-LD 000 - New mergefields.
    // 013. 29-10-23 ZY-LD 000 - For test in BC, can the developer now send emails from the test.
    // 014. 06-02-24 ZY-LD 000 - It could not handle more than one e-mail adderess in one field.
    Permissions = TableData "E-mail address" = rm;

    trigger OnRun()
    begin
    end;

    var
        EmailAccounts: Record "Email Account" temporary;
        recEmailaddress: Record "E-mail address";
        EmailConnector: Interface "Email Connector";
        EmailMsg: Codeunit "Email Message";
        CrLf: Text[2];
        Text001: Label '%1 is not created as "%2".';
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        Text002: Label '\\ZYEU-NAVSQL02\NAV HTML Emails\';
        Text003: Label 'COLOR';
        Text004: Label 'DIRECTORY';
        Text005: Label 'TITLE';
        Text006: Label 'ZyXEL Communications';
        Text007: Label 'BODY';
        Text008: Label 'NAME';
        Text009: Label 'EMAIL';
        Text010: Label 'PHONE';
        Text011: Label 'ADDRESS1';
        Text012: Label 'ADDRESS2';
        Text013: Label 'ADDRESS3';
        Err001: Label 'No HTML File specified for Email';
        Err002: Label 'HTML Templaye file not found.';
        Text014: Label '\\';
        Text015: Label '</br>';
        Text016: Label '|';
        Text017: Label '&nbsp;&nbsp;&nbsp;';
        "Table": Text;
        Text018: Label 'TABLE';
        Text019: Label 'ADDBDY';
        AdditionalText: Text;
        ServerFilenameToDelete: Text;

    procedure CreateSimpleEmail(pCode: Code[10]; pLanguage: Code[10]; pRecipents: Text)
    var
        lEmailAdd: Record "E-mail address";
        recCustomer: Record Customer;
        strFilename: Text[1024];
        SenderName: Text[250];
        Recipients: Text[250];
        Subject: Text[250];
        Body: Text[250];
        FilePart: Text[250];
        SenderEmailAddress: Text[250];
        Window: Dialog;
        recCustomer2: Record Customer;
        ServerFilename: Text;
    begin
        Clear(EmailMsg);
        SetStandardMergefields;

        if lEmailAdd.Get(pCode) then begin
            if pRecipents = '' then
                pRecipents := lEmailAdd.Recipients
            else
                if lEmailAdd.Recipients <> '' then
                    pRecipents := pRecipents + ';' + lEmailAdd.Recipients;

            FindMailAccount(lEmailAdd."Sender Address");

            //EmailMsg.Create(pRecipents, InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), GetBodyText(pCode, pLanguage), lEmailAdd."Html Formatted");
            EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), GetBodyText(pCode, pLanguage), lEmailAdd."Html Formatted");
            AddRecipient(pRecipents, 0);  // 06-02-24 ZY-LD 014

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.BCC, 2);  // 06-02-24 ZY-LD 014
            //EmailMsg.AddRecipient("EMail Recipient Type"::BCC, lEmailAdd.BCC);  // 06-02-24 ZY-LD 014

            GetBodyText(pCode, pLanguage);
        end else
            Error(Text001, pCode, lEmailAdd.TableCaption());
    end;

    procedure CreateNewEmail(MailAddressCode: Code[10]; LanguageCode: Code[10]; Recipent: Text)
    var
        EmailAdd: Record "E-mail address";
    begin
        Clear(EmailMsg);
        SetStandardMergefields();

        if EmailAdd.Get(MailAddressCode) then begin
            if Recipent = '' then
                Error('');

            FindMailAccount(EmailAdd."Sender Address");

            EmailMsg.Create('', InsertMergefields(AddSubject(MailAddressCode, LanguageCode, EmailAdd.Subject)), GetBodyText(MailAddressCode, LanguageCode), EmailAdd."Html Formatted");
            AddRecipient(Recipent, 0);  // 06-02-24 ZY-LD 014

            if EmailAdd.BCC <> '' then
                AddRecipient(EmailAdd.BCC, 2);  // 06-02-24 ZY-LD 014
            //EmailMsg.AddRecipient("EMail Recipient Type"::BCC, EmailAdd.BCC);  // 06-02-24 ZY-LD 014

            GetBodyText(MailAddressCode, LanguageCode);
        end else
            Error(Text001, MailAddressCode, EmailAdd.TableCaption());
    end;

    local procedure FindMailAccount(FromEmail: Text)
    var
        EmailConn: Enum "Email Connector";
    begin
        Clear(EmailConnector);
        Clear(EmailAccounts);
        EmailConnector := EmailConn::SMTP;
        EmailConnector.GetAccounts(EmailAccounts);
        EmailAccounts.SetRange("Email Address", FromEmail);
        EmailAccounts.FindFirst();
    end;

    procedure CreateEmailWithBodytext(pCode: Code[10]; pBodyText: Text; pLanguage: Code[10])
    var
        lEmailAdd: Record "E-mail address";
        recCustomer: Record Customer;
        strFilename: Text[1024];
        SenderName: Text[250];
        Recipients: Text[250];
        Subject: Text[250];
        Body: Text[250];
        FilePart: Text[250];
        SenderEmailAddress: Text[250];
        Window: Dialog;
        recCustomer2: Record Customer;
        ServerFilename: Text;
    begin
        Clear(EmailMsg);
        SetStandardMergefields;

        if lEmailAdd.Get(pCode) then begin
            //>> 22-08-22 ZY-LD 013
            if lEmailAdd."Show Variable Body Text in" = lEmailAdd."show variable body text in"::Buttom then begin
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(GetBodyText(pCode, pLanguage) + InsertMergefields(pBodyText)), lEmailAdd."Html Formatted");
                AddRecipient(lEmailAdd.Recipients, 0);  // 06-02-24 ZY-LD 014
            end else begin  //<< 22-08-22 ZY-LD 013
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(pBodyText) + InsertMergefields(GetBodyText(pCode, pLanguage)), lEmailAdd."Html Formatted");
                AddRecipient(lEmailAdd.Recipients, 0);  // 06-02-24 ZY-LD 014
            end;

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.BCC, 2);  // 06-02-24 ZY-LD 014
            // EmailMsg.AddRecipient("EMail Recipient Type"::BCC, lEmailAdd.BCC);  // 06-02-24 ZY-LD 014

        end else
            Error(Text001, pCode, lEmailAdd.TableCaption());
    end;

    procedure CreateEmailWithBodytext2(pCode: Code[10]; pRecipents: Text; pBodyText: Text; pLanguage: Code[10])
    var
        lEmailAdd: Record "E-mail address";
        recCustomer: Record Customer;
        strFilename: Text[1024];
        SenderName: Text[250];
        Recipients: Text[250];
        Subject: Text[250];
        Body: Text[250];
        FilePart: Text[250];
        SenderEmailAddress: Text[250];
        Window: Dialog;
        recCustomer2: Record Customer;
        ServerFilename: Text;
    begin
        Clear(EmailMsg);
        SetStandardMergefields;

        if lEmailAdd.Get(pCode) then begin
            if pRecipents = '' then
                pRecipents := lEmailAdd.Recipients
            else
                if lEmailAdd.Recipients <> '' then
                    pRecipents := pRecipents + ';' + lEmailAdd.Recipients;

            FindMailAccount(lEmailAdd."Sender Address");
            //>> 22-08-22 ZY-LD 013
            if lEmailAdd."Show Variable Body Text in" = lEmailAdd."show variable body text in"::Buttom then begin
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(GetBodyText(pCode, pLanguage)) + InsertMergefields(pBodyText), lEmailAdd."Html Formatted");
                AddRecipient(pRecipents, 0);  // 06-02-24 ZY-LD 014
            end else begin  //<< 22-08-22 ZY-LD 013
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(pBodyText) + InsertMergefields(GetBodyText(pCode, pLanguage)), lEmailAdd."Html Formatted");
                AddRecipient(pRecipents, 0);  // 06-02-24 ZY-LD 014
            end;

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.bcc, 2);  // 06-02-24 ZY-LD 014
            //EmailMsg.AddRecipient("EMail Recipient Type"::BCC, lEmailAdd.BCC);  // 06-02-24 ZY-LD 014
        end else
            Error(Text001, pCode, lEmailAdd.TableCaption());
    end;

    procedure CreateEmailWithAttachment(pCode: Code[10]; pLanguage: Code[10]; pRecipents: Text; pServerFilename: Text; pFilename: Text; pDeleteFile: Boolean)
    var
        lEmailAdd: Record "E-mail address";
        recCustomer: Record Customer;
        strFilename: Text[1024];
        SenderName: Text[250];
        Recipients: Text[250];
        Subject: Text[250];
        Body: Text[250];
        FilePart: Text[250];
        SenderEmailAddress: Text[250];
        Window: Dialog;
        recCustomer2: Record Customer;
        ServerFilename: Text;
    begin
        Clear(EmailMsg);
        SetStandardMergefields;

        if lEmailAdd.Get(pCode) then begin
            if pRecipents = '' then
                pRecipents := lEmailAdd.Recipients
            else
                if lEmailAdd.Recipients <> '' then
                    pRecipents := pRecipents + ';' + lEmailAdd.Recipients;

            FindMailAccount(lEmailAdd."Sender Address");
            EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), GetBodyText(pCode, pLanguage), lEmailAdd."Html Formatted");
            AddRecipient(pRecipents, 0);  // 06-02-24 ZY-LD 014

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.BCC, 2);  // 06-02-24 ZY-LD 014
            //EmailMsg.AddRecipient("EMail Recipient Type"::BCC, lEmailAdd.BCC);  // 06-02-24 ZY-LD 014

            AddAttachment(pServerFilename, pFilename, pDeleteFile);

            //>> 14-11-19 ZY-LD 010
            if pDeleteFile then
                ServerFilenameToDelete := pServerFilename;
            //<< 14-11-19 ZY-LD 01
        end else
            Error(Text001, pCode, lEmailAdd.TableCaption());
    end;

    local procedure AddSubject(pCode: Code[10]; pLanguage: Code[10]; pSubject: Text) rValue: Text
    var
        recEmailAddSub: Record "E-mail Address Subject";
        recServEnviron: Record "Server Environment";
    begin
        if recEmailAddSub.Get(pCode, pLanguage) and (recEmailAddSub.Subject <> '') then
            rValue := recEmailAddSub.Subject
        else
            rValue := pSubject;

        //>> 29-01-19 ZY-LD 009
        if not recServEnviron.ProductionEnvironment then
            rValue := 'TEST!!!: ' + rValue;
        //<< 29-01-19 ZY-LD 009
    end;

    local procedure GetBodyText(pCode: Code[10]; pLanguage: Code[10]): Text
    var
        lEmailAddBody: Record "E-mail address Body";
        recServEnviron: Record "Server Environment";
        cr: Char;
        lf: Char;
        recEmailaddress: Record "E-mail address";
        BodyText: Text;
        lText001: Label 'The e-mail is send from the "TEST ENVIRONMENT".';
    begin
        //>> 29-01-19 ZY-LD 009
        if not recServEnviron.ProductionEnvironment then
            BodyText := lText001 + '</br></br>';
        //<< 29-01-19 ZY-LD 009

        //SetCrLf;
        lEmailAddBody.SetRange("E-mail Address Code", pCode);
        lEmailAddBody.SetFilter("Language Code", '%1|%2', '', pLanguage);
        if lEmailAddBody.FindLast() then begin
            // IF STRLEN(lEmailAddBody."E-mail HTML file") = 0 THEN BEGIN
            lEmailAddBody.SetRange("Language Code", lEmailAddBody."Language Code");
            lEmailAddBody.FindFirst();
            repeat
                BodyText := BodyText + InsertMergefields(lEmailAddBody."Body Text") + '</br>';
            until lEmailAddBody.Next() = 0;
            // END;
        end;
        recEmailaddress.SetRange(Code, pCode);
        if recEmailaddress.FindSet() then begin
            if recEmailaddress."E-mail HTML file" <> '' then
                BodyText := AddFooter(pCode, pLanguage, BodyText)
        end;
        exit(BodyText);
    end;

    procedure AddAttachment(pServerFilename: Text; pFilename: Text; pDeleteFile: Boolean)
    var
        FileMgt: Codeunit "File Management";
        StreamIn: InStream;
        f: File;
    begin
        if FileMgt.ServerFileExists(pServerFilename) then begin
            f.Open(pServerFilename);
            f.CreateInStream(StreamIn);

            EmailMsg.AddAttachment(pFilename, FileMgt.GetFileNameMimeType(pFilename), StreamIn);
            f.Close();

            //IF pDeleteFile THEN  // 14-11-19 ZY-LD 010
            //  FileMgt.DeleteServerFile(pServerFilename);  // 14-11-19 ZY-LD 010
        end;
    end;

    procedure AddCC(Recipient: Text)
    begin
        if Recipient <> '' then
            AddRecipient(Recipient, 1);  // 06-02-24 ZY-LD 014
        //EmailMsg.AddRecipient("EMail Recipient Type"::CC, Recipent);  // 06-02-24 ZY-LD 014
    end;

    procedure Send()
    var
        recServEnviron: Record "Server Environment";
        FileMgt: Codeunit "File Management";
        ZGT: Codeunit "ZyXEL General Tools";
        TempMailItem: Record "email item" temporary;
        lText001: Label 'You are emailing from the %1 environment.\Are you sure you want to send the mail?';
    begin
        if recServEnviron.ProductionEnvironment then
            EmailConnector.Send(EmailMsg, EmailAccounts."Account Id")
        else
            //>> 29-10-23 ZY-LD 013
            if ZGT.UserIsDeveloper() then begin
                recServEnviron.Get();
                if Confirm(lText001, false, recServEnviron.Environment) then
                    EmailConnector.Send(EmailMsg, EmailAccounts."Account Id");
            end;
        //<< 29-10-23 ZY-LD 013
        Clear(EmailMsg);
        Clear(EmailConnector);
        Clear(EmailAccounts);

        //>> 14-11-19 ZY-LD 010
        if ServerFilenameToDelete <> '' then begin
            FileMgt.DeleteServerFile(ServerFilenameToDelete);
            ServerFilenameToDelete := '';
        end;
        //<< 14-11-19 ZY-LD 010
    end;

    local procedure InsertMergefields(Description: Text): Text
    var
        Position: Integer;
        Length: Integer;
        i: Integer;
        j: Integer;
        SI: Codeunit "Single Instance";
        TextStrToInsert: Text[250];
        lText001: Label 'Text string will exeed 250 charcters.';
    begin
        for i := 120 downto 1 do begin
            TextStrToInsert := SI.GetMergefield(i);
            for j := 1 to 3 do begin
                if StrPos(Description, '%' + Format(i)) <> 0 then begin
                    Position := StrPos(Description, '%' + Format(i));
                    Length := StrLen('%' + Format(i));
                    Description := DelStr(Description, Position, Length);
                    if StrLen(Description) + StrLen(TextStrToInsert) < 250 then begin
                        Description := InsStr(Description, TextStrToInsert, Position);
                    end else
                        Message(lText001);
                    //Error(lText001);
                    if i >= 100 then  // CommentLines.
                        if Description = '' then
                            Description := '**SLETLINIE**';
                end;
            end;
        end;
        Description := ConvertStr(Description, '', '%');  // 24-05-13 CD-LD 2851

        // Link breaks if there are blank characters.
        if StrPos(Description, 'LINK') <> 0 then begin
            for i := StrLen(Description) downto 1 do
                if Description[i] = ' ' then begin
                    Position := i;
                    Length := 1;
                    TextStrToInsert := '%20';
                    Description := DelStr(Description, Position, Length);
                    if StrLen(Description) + StrLen(TextStrToInsert) < 250 then begin
                        Description := InsStr(Description, TextStrToInsert, Position);
                    end else
                        Message(lText001);
                end;
            Description := DelStr(Description, 1, 4);
            Description := DelChr(Description, '=', '[]');
        end;

        exit(Description);
    end;

    local procedure SetCrLf()
    begin
        CrLf[1] := 13;
        CrLf[2] := 10;
    end;

    local procedure SetStandardMergefields()
    var
        lCompInfo: Record "Company Information";
        lUserSetup: Record "User Setup";
        lSalesPers: Record "Salesperson/Purchaser";
        lShipToCountry: Record "Country/Region";
        lCompany: Record Company;
        SI: Codeunit "Single Instance";
    begin
        lCompInfo.Get();
        SI.SetMergefield(21, lCompInfo.Name);
        SI.SetMergefield(22, lCompInfo."Name 2");
        SI.SetMergefield(23, lCompInfo.Address);
        SI.SetMergefield(24, lCompInfo."Address 2");
        SI.SetMergefield(25, lCompInfo."Post Code");
        SI.SetMergefield(26, lCompInfo.City);
        SI.SetMergefield(27, lCompInfo."Country/Region Code");
        SI.SetMergefield(28, lCompInfo."Phone No.");
        SI.SetMergefield(29, lCompInfo."E-Mail");
        SI.SetMergefield(30, lCompInfo."Finance Phone No.");  // 23-05-18 ZY-LD 002
        SI.SetMergefield(31, lCompInfo."Finance E-Mail");  // 23-05-18 ZY-LD 002

        //>> 17-04-20 ZY-LD 012
        if not lShipToCountry.Get(lCompInfo."Ship-to Country/Region Code") then;
        SI.SetMergefield(81, lCompInfo."Ship-to Name");
        SI.SetMergefield(82, lCompInfo."Ship-to Name 2");
        SI.SetMergefield(83, lCompInfo."Ship-to Address");
        SI.SetMergefield(84, lCompInfo."Ship-to Address 2");
        SI.SetMergefield(85, lCompInfo."Ship-to Post Code");
        SI.SetMergefield(86, lCompInfo."Ship-to City");
        SI.SetMergefield(87, lCompInfo."Ship-to County");
        SI.SetMergefield(88, lShipToCountry.Name);
        SI.SetMergefield(89, lCompInfo."Ship-to Contact");
        //<< 17-04-20 ZY-LD 012

        SI.SetMergefield(40, UserId());
        if lUserSetup.Get(UserId()) then
            if lSalesPers.Get(lUserSetup."Salespers./Purch. Code") then begin
                SI.SetMergefield(41, lSalesPers.Name);
                SI.SetMergefield(42, lSalesPers."Job Title");
            end;
        if lSalesPers."Phone No." <> '' then
            SI.SetMergefield(43, lSalesPers."Phone No.")
        else
            SI.SetMergefield(43, lCompInfo."Phone No.");
        if lSalesPers."E-Mail" <> '' then
            SI.SetMergefield(44, lSalesPers."E-Mail")
        else
            SI.SetMergefield(44, lCompInfo."E-Mail");

        SI.SetMergefield(51, Format(Today, 0, '<Day,2>.<Month,2>.<Year4>'));
        SI.SetMergefield(52, Format(Today, 0, 4));

        lCompany.get(CompanyName);
        SI.SetMergeField(91, CompanyName);
        SI.SetMergeField(92, lCompany."Display Name");
    end;

    procedure SetCustomerMergefields(pCustNo: Code[20])
    var
        recCust: Record Customer;
    begin
        //>> 02-08-18 ZY-LD 003
        begin
            recCust.Get(pCustNo);

            SI.SetMergefield(1, recCust."No.");
            SI.SetMergefield(2, recCust.Name);
            SI.SetMergefield(3, recCust."Name 2");
            SI.SetMergefield(4, recCust.Address);
            SI.SetMergefield(5, recCust."Address 2");
            SI.SetMergefield(6, recCust."Post Code");
            SI.SetMergefield(7, recCust.City);
            SI.SetMergefield(8, recCust."Country/Region Code");
            SI.SetMergefield(9, recCust.Contact);
        end;
        //<< 02-08-18 ZY-LD 003
    end;

    procedure SetSalesHeaderMergeFields(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20])
    var
        recSalesHead: Record "Sales Header";
        recEiCardQueue: Record "EiCard Queue";
    begin
        begin
            recSalesHead.Get(DocumentType, DocumentNo);
            SI.SetMergefield(60, recSalesHead."External Document No.");
            SI.SetMergefield(61, recSalesHead."No.");
            //>> 11-09-19 ZY-LD 009
            SI.SetMergefield(68, '');
            if recEiCardQueue.Get(recSalesHead."No.") then
                if recEiCardQueue."Distributor Reference" <> '' then
                    SI.SetMergefield(68, StrSubstNo('- %1', recEiCardQueue."Distributor Reference"))
            //<< 11-09-19 ZY-LD 009
        end;
    end;

    procedure GetBody(pCode: Code[10]; pLanguage: Code[10]; pSellToCustCode: Code[20]; pHtml: Boolean) rValue: Text
    var
        lEmailAddBody: Record "E-mail address Body";
        cr: Char;
        lf: Char;
    begin
        //>> 02-08-18 ZY-LD 003
        SetCrLf;
        SetStandardMergefields;
        lEmailAddBody.SetRange("E-mail Address Code", pCode);
        lEmailAddBody.SetFilter("Language Code", '%1|%2', '', pLanguage);
        lEmailAddBody.SetFilter("Sell-to Customer No.", '%1|%2', '', pSellToCustCode);  // 16-03-22 ZY-LD 013
        if lEmailAddBody.FindLast() then begin
            lEmailAddBody.SetRange("Language Code", lEmailAddBody."Language Code");
            lEmailAddBody.SetRange("Sell-to Customer No.", lEmailAddBody."Sell-to Customer No.");  // 16-03-22 ZY-LD 013
            lEmailAddBody.FindFirst();
            repeat
                //>> 28-09-18 ZY-LD 004
                if pHtml then begin
                    if rValue <> '' then
                        rValue += '</br>';
                    rValue += InsertMergefields(lEmailAddBody."Body Text");
                end else begin  //<< 28-09-18 ZY-LD 004
                    if rValue <> '' then
                        rValue += CrLf;
                    rValue += InsertMergefields(lEmailAddBody."Body Text");
                end;
            until lEmailAddBody.Next() = 0;
        end;
        //<< 02-08-18 ZY-LD 003
    end;

    procedure GetSubject(pCode: Code[10]; pLanguage: Code[10]; pBillToCustNo: Code[20]): Text
    var
        recEmailadd: Record "E-mail address";
        recEmailAddSub: Record "E-mail Address Subject";
    begin
        //>> 22-11-19 ZY-LD 011
        SetStandardMergefields;
        recEmailAddSub.SetRange("E-mail Address Code", pCode);
        //recEmailAddSub.SETRANGE("Language Code",pLanguage);  // 16-03-22 ZY-LD 013
        recEmailAddSub.SetFilter("Language Code", '%1|%2', '', pLanguage);  // 16-03-22 ZY-LD 013
        recEmailAddSub.SetFilter(Subject, '<>%1', '');
        recEmailAddSub.SetFilter("Sell-to Customer No.", '%1|%2', pBillToCustNo, '');
        if recEmailAddSub.FindLast() then
            exit(InsertMergefields(recEmailAddSub.Subject))
        else
            if recEmailadd.Get(pCode) then
                exit(InsertMergefields(recEmailadd.Subject));

        /*//>> 02-08-18 ZY-LD 003
        SetStandardMergefields;
        IF recEmailAddSub.GET(pCode,pLanguage) AND (recEmailAddSub.Subject <> '') THEN
          EXIT(InsertMergefields(recEmailAddSub.Subject))
        ELSE
          IF recEmailadd.GET(pCode) THEN
            EXIT(InsertMergefields(recEmailadd.Subject));
        //<< 02-08-18 ZY-LD 003*/
        //<< 22-11-19 ZY-LD 011
    end;

    procedure GetEmailCode(pDocumentOption: Option " ","Sales Invoice","Sales Credit Memo",Statement,Reminder,"Finance Charge Memo"): Code[10]
    var
        recEmailadd: Record "E-mail address";
    begin
        //>> 16-10-18 ZY-LD 005
        recEmailadd.SetRange("Document Usage", pDocumentOption);
        if recEmailadd.FindFirst() then
            exit(recEmailadd.Code);
        //<< 16-10-18 ZY-LD 005
    end;

    procedure UpdateLastEmailSendDateTime(pCode: Code[20])
    begin
        if recEmailaddress.Get(pCode) then begin
            recEmailaddress."Last E-mail Send Date Time" := CurrentDatetime;
            recEmailaddress.Modify();
        end;
    end;

    procedure EmailIsSendToday(pCode: Code[20]; pUpdateLastEmailSendDateTime: Boolean): Boolean
    begin
        if recEmailaddress.Get(pCode) then
            if Dt2Date(recEmailaddress."Last E-mail Send Date Time") = Today then
                exit(true)
            else
                if pUpdateLastEmailSendDateTime then
                    UpdateLastEmailSendDateTime(pCode);
    end;

    procedure SetupEmailDocument(pDocUsage: Option " ","Sales Invoice","Sales Credit Memo",Statement,Reminder,"Finance Charge Memo","Sales Order","Sales Return Order"; pLanguageCode: Code[10]; pHideDialog: Boolean; pSellToCustNo: Code[20]; var TempEmailItem: Record "Email Item" temporary)
    var
        recEmailAdd: Record "E-mail address";
        recUserSetup: Record "User Setup";
    begin
        //>> 06-12-18 ZY-LD 006
        recEmailAdd.SetRange("Document Usage", pDocUsage);
        if recEmailAdd.FindFirst() then begin
            TempEmailItem."From Name" := recEmailAdd."Sender Name";
            if (pDocUsage in [Pdocusage::"Sales Order", Pdocusage::"Sales Invoice", Pdocusage::"Sales Credit Memo"]) and
               recUserSetup.Get(UserId()) and
               (recUserSetup."Use User E-mail on Documents") and
               (recUserSetup."E-Mail" <> '')
            then
                TempEmailItem."From Address" := recUserSetup."E-Mail"
            else
                TempEmailItem."From Address" := recEmailAdd."Sender Address";
            TempEmailItem."Send BCC" := recEmailAdd.BCC;
            TempEmailItem.Subject := GetSubject(recEmailAdd.Code, pLanguageCode, pSellToCustNo);  // 22-11-19 ZY-LD 011
            TempEmailItem.SetBodyText := GetBody(recEmailAdd.Code, pLanguageCode, pSellToCustNo, pHideDialog);  // 16-03-22 ZY-LD 013 - pSellToCustNo is added.
            TempEmailItem."E-mail Address Code" := recEmailAdd.Code;
            TempEmailItem."E-mail Language Code" := pLanguageCode;
        end;
        //<< 06-12-18 ZY-LD 006
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text[250]; ReplaceWith: Text) NewString: Text
    begin
        //PAB
        while StrPos(String, FindWhat) > 0 do
            String := DelStr(String, StrPos(String, FindWhat)) + ReplaceWith + CopyStr(String, StrPos(String, FindWhat) + StrLen(FindWhat));
        NewString := String;
    end;

    procedure AddFooter(pCode: Code[10]; pLanguage: Code[10]; BodyText: Text): Text
    var
        RValue: Integer;
        GValue: Integer;
        BValue: Integer;
        recEmailHTMLColorSchemes: Record "E-mail HTML Color Schemes";
        HTMLFileName: Text[250];
        File: File;
        Linestr: Text;
        HTMLStr: Text;
        ColorStr: Text[250];
        recUserSetup: Record "User Setup";
        Signature: Text[250];
        SenderEmail: Text[250];
        recCompInfo: Record "Company Information";
        Address1: Text[250];
        Address2: Text[250];
        CountryRegionCode: Code[20];
        recCountryRegionCode: Record "Country/Region";
        Address3: Text[250];
        Phone: Text[250];
        recEmailHTMLfiles: Record "E-mail HTML files";
        recEmailaddress: Record "E-mail address";
    begin
        recEmailaddress.SetRange(Code, pCode);
        if recEmailaddress.FindSet() then begin
            if recEmailaddress."E-mail HTML file" <> '' then begin
                //Color Scheme
                RValue := 0;
                GValue := 62;
                BValue := 171;
                recEmailHTMLColorSchemes.SetRange(Code, recEmailaddress."Color Scheme");
                if recEmailHTMLColorSchemes.FindSet() then begin
                    RValue := recEmailHTMLColorSchemes."R Value";
                    GValue := recEmailHTMLColorSchemes."G Value";
                    BValue := recEmailHTMLColorSchemes."B Value";
                end;
                //Get the HTML File
                recEmailHTMLfiles.SetRange(Code, recEmailaddress."E-mail HTML file");
                if recEmailHTMLfiles.FindSet() then HTMLFileName := Text002 + recEmailHTMLfiles.Filename;
                // Error Checking
                if StrLen(HTMLFileName) = 0 then Error(Err001);
                if not Exists(HTMLFileName) then Error(Err002);
                // String Replacement
                if Exists(HTMLFileName) then begin
                    File.TextMode(true);
                    File.WriteMode(false);
                    File.Open(HTMLFileName);
                    repeat
                        File.Read(Linestr);
                        HTMLStr := HTMLStr + Linestr;
                    until File.POS = File.LEN;
                    File.Close();
                    // CR and Tab
                    HTMLStr := ReplaceString(HTMLStr, Text014, Text015);
                    HTMLStr := ReplaceString(HTMLStr, Text016, Text017);
                    // Title
                    HTMLStr := ReplaceString(HTMLStr, Text005, Text006);
                    // Body Text
                    HTMLStr := ReplaceString(HTMLStr, Text007, BodyText);
                    // Build Color
                    ColorStr := 'rgb(' + Format(RValue) + ', ' + Format(GValue) + ', ' + Format(BValue) + ')';
                    HTMLStr := ReplaceString(HTMLStr, Text003, ColorStr);
                    // Images
                    HTMLStr := ReplaceString(HTMLStr, Text004, Text002);
                    //>> 03-01-18 ZY-LD 007
                    if recUserSetup.Get(UserId()) and recUserSetup."Use User E-mail on Documents" then begin
                        recUserSetup.TestField("E-Mail Footer Name");
                        recUserSetup.TestField("E-mail Footer Address");
                        recUserSetup.TestField("E-Mail");
                        // Signature
                        HTMLStr := ReplaceString(HTMLStr, Text008, recUserSetup."E-Mail Footer Name");
                        HTMLStr := ReplaceString(HTMLStr, Text009, recUserSetup."E-Mail");
                        // Company
                        if recUserSetup."E-mail Footer Mobile Phone No." <> '' then
                            Phone := recUserSetup."E-mail Footer Mobile Phone No."
                        else
                            Phone := recUserSetup."E-mail Footer Phone No.";
                        Address1 := recUserSetup."E-mail Footer Address";
                        Address2 := recUserSetup."E-mail Footer Address 2";
                        Address3 := recUserSetup."E-mail Footer Address 3";
                    end else begin  // Company Info  //<< 03-01-18 ZY-LD 007
                                    // Signature
                        HTMLStr := ReplaceString(HTMLStr, Text009, recEmailaddress."Footer E-Mail");
                        // Company
                        if recCompInfo.FindFirst() then begin
                            Phone := recCompInfo."Finance Phone No.";
                            HTMLStr := ReplaceString(HTMLStr, Text008, recCompInfo.Name);
                            Address1 := recCompInfo.Address;
                            if StrLen(recCompInfo."Address 2") > 0 then
                                Address1 := Address1 + ', ' + recCompInfo."Address 2";
                            Address2 := recCompInfo.City;
                            if StrLen(recCompInfo."Post Code") > 0 then
                                Address2 := Address2 + ', ' + recCompInfo."Post Code";
                            //>> 03-01-18 ZY-LD 007
                            if ZGT.IsRhq then
                                recCountryRegionCode.Get('DK')
                            else  //<< 03-01-18 ZY-LD 007
                                recCountryRegionCode.Get(recCompInfo."Country/Region Code");
                            Address3 := recCountryRegionCode.Name;
                        end;
                    end;
                    HTMLStr := ReplaceString(HTMLStr, Text010, Phone);
                    HTMLStr := ReplaceString(HTMLStr, Text011, Address1);
                    HTMLStr := ReplaceString(HTMLStr, Text012, Address2);
                    HTMLStr := ReplaceString(HTMLStr, Text013, Address3);
                    // Additional Body Text
                    HTMLStr := ReplaceString(HTMLStr, Text019, AdditionalText);
                    // Table
                    HTMLStr := ReplaceString(HTMLStr, Text018, Table);
                    exit(HTMLStr);
                end;
            end;
        end;
    end;

    procedure SetTableString(TableBody: Text)
    begin
        Table := TableBody;
    end;

    procedure SetAdditionalBody(AdditionalBody: Text)
    begin
        AdditionalText := AdditionalBody;
    end;

    local procedure AddRecipient(pRecipient: Text; pRecipentType: Option Recipient,CC,BCC)
    var
        lRecipient: Text;
    begin
        //>> 06-02-24 ZY-LD 014
        if pRecipient <> '' then begin
            pRecipient := ConvertStr(pRecipient, ',', ';');
            pRecipient := DelChr(pRecipient, '>', ';');
            repeat
                if StrPos(pRecipient, ';') <> 0 then begin
                    lRecipient := CopyStr(pRecipient, 1, StrPos(pRecipient, ';') - 1);
                    pRecipient := CopyStr(pRecipient, StrPos(pRecipient, ';') + 1, StrLen(pRecipient))
                end else begin
                    lRecipient := pRecipient;
                    pRecipient := '';
                end;

                case pRecipentType of
                    precipenttype::Recipient:
                        EmailMsg.AddRecipient("EMail Recipient Type"::"To", lRecipient);
                    precipenttype::CC:
                        EmailMsg.AddRecipient("EMail Recipient Type"::Cc, lRecipient);
                    precipenttype::BCC:
                        EmailMsg.AddRecipient("EMail Recipient Type"::Bcc, lRecipient);
                end;
            until pRecipient = '';
            //<< 06-02-24 ZY-LD 014
        end;
    end;
}
