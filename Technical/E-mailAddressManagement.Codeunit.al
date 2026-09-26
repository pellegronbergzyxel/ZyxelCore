codeunit 50074 "E-mail Address Management"
{
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
            EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), GetBodyText(pCode, pLanguage), lEmailAdd."Html Formatted");
            AddRecipient(pRecipents, 0);

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.BCC, 2);

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
            AddRecipient(Recipent, 0);

            if EmailAdd.BCC <> '' then
                AddRecipient(EmailAdd.BCC, 2);

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
        if EmailAccounts.count = 0 then //onlu first getaccounts
            EmailConnector.GetAccounts(EmailAccounts);
        EmailAccounts.SetRange("Email Address", FromEmail);
        IF EmailAccounts.FindFirst() then;
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
            if lEmailAdd."Show Variable Body Text in" = lEmailAdd."show variable body text in"::Buttom then begin
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(GetBodyText(pCode, pLanguage) + InsertMergefields(pBodyText)), lEmailAdd."Html Formatted");
                AddRecipient(lEmailAdd.Recipients, 0);
            end else begin
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(pBodyText) + InsertMergefields(GetBodyText(pCode, pLanguage)), lEmailAdd."Html Formatted");
                AddRecipient(lEmailAdd.Recipients, 0);
            end;

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.BCC, 2);

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
                AddRecipient(pRecipents, 0);
            end else begin
                EmailMsg.Create('', InsertMergefields(AddSubject(pCode, pLanguage, lEmailAdd.Subject)), InsertMergefields(pBodyText) + InsertMergefields(GetBodyText(pCode, pLanguage)), lEmailAdd."Html Formatted");
                AddRecipient(pRecipents, 0);
            end;

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.bcc, 2);
        end else
            Error(Text001, pCode, lEmailAdd.TableCaption());
    end;

    procedure CreateEmailWithAttachment(pCode: Code[10]; pLanguage: Code[10]; pRecipents: Text; var tempblob: codeunit "Temp Blob"; pFilename: Text)
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
            AddRecipient(pRecipents, 0);

            if lEmailAdd.BCC <> '' then
                AddRecipient(lEmailAdd.BCC, 2);

            AddAttachment(tempblob, pFilename);
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

        if not recServEnviron.ProductionEnvironment then
            rValue := 'TEST!!!: ' + rValue;
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
        if not recServEnviron.ProductionEnvironment then
            BodyText := lText001 + '</br></br>';

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


    procedure AddAttachment(Var tempblob: Codeunit "Temp Blob"; pFilename: text)
    var
        StreamIn: InStream;
        FileMgt: Codeunit "File Management";
    begin
        tempblob.CreateInStream(StreamIn);
        EmailMsg.AddAttachment(pFilename, FileMgt.GetFileNameMimeType(pFilename), StreamIn);
    end;

    procedure AddCC(Recipient: Text)
    begin
        if Recipient <> '' then
            AddRecipient(Recipient, 1);
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
            if ZGT.UserIsDeveloper() then begin
                recServEnviron.Get();
                if Confirm(lText001, false, recServEnviron.Environment) then
                    EmailConnector.Send(EmailMsg, EmailAccounts."Account Id");
            end;

        Clear(EmailMsg);
        Clear(EmailConnector);
        Clear(EmailAccounts);
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
        Description := ConvertStr(Description, '', '%');

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
        SI.SetMergefield(30, lCompInfo."Finance Phone No.");
        SI.SetMergefield(31, lCompInfo."Finance E-Mail");

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
            SI.SetMergefield(68, '');
            if recEiCardQueue.Get(recSalesHead."No.") then
                if recEiCardQueue."Distributor Reference" <> '' then
                    SI.SetMergefield(68, StrSubstNo('- %1', recEiCardQueue."Distributor Reference"))
        end;
    end;

    procedure GetBody(pCode: Code[10]; pLanguage: Code[10]; pSellToCustCode: Code[20]; pHtml: Boolean) rValue: Text
    var
        lEmailAddBody: Record "E-mail address Body";
        cr: Char;
        lf: Char;
    begin
        SetCrLf;
        SetStandardMergefields;
        lEmailAddBody.SetRange("E-mail Address Code", pCode);
        lEmailAddBody.SetFilter("Language Code", '%1|%2', '', pLanguage);
        lEmailAddBody.SetFilter("Sell-to Customer No.", '%1|%2', '', pSellToCustCode);
        if lEmailAddBody.FindLast() then begin
            lEmailAddBody.SetRange("Language Code", lEmailAddBody."Language Code");
            lEmailAddBody.SetRange("Sell-to Customer No.", lEmailAddBody."Sell-to Customer No.");
            lEmailAddBody.FindFirst();
            repeat
                if pHtml then begin
                    if rValue <> '' then
                        rValue += '</br>';
                    rValue += InsertMergefields(lEmailAddBody."Body Text");
                end else begin
                    if rValue <> '' then
                        rValue += CrLf;
                    rValue += InsertMergefields(lEmailAddBody."Body Text");
                end;
            until lEmailAddBody.Next() = 0;
        end;
    end;

    procedure GetSubject(pCode: Code[10]; pLanguage: Code[10]; pBillToCustNo: Code[20]): Text
    var
        recEmailadd: Record "E-mail address";
        recEmailAddSub: Record "E-mail Address Subject";
    begin
        SetStandardMergefields;
        recEmailAddSub.SetRange("E-mail Address Code", pCode);
        recEmailAddSub.SetFilter("Language Code", '%1|%2', '', pLanguage);
        recEmailAddSub.SetFilter(Subject, '<>%1', '');
        recEmailAddSub.SetFilter("Sell-to Customer No.", '%1|%2', pBillToCustNo, '');
        if recEmailAddSub.FindLast() then
            exit(InsertMergefields(recEmailAddSub.Subject))
        else
            if recEmailadd.Get(pCode) then
                exit(InsertMergefields(recEmailadd.Subject));
    end;

    procedure GetEmailCode(pDocumentOption: Option " ","Sales Invoice","Sales Credit Memo",Statement,Reminder,"Finance Charge Memo"): Code[10]
    var
        recEmailadd: Record "E-mail address";
    begin
        recEmailadd.SetRange("Document Usage", pDocumentOption);
        if recEmailadd.FindFirst() then
            exit(recEmailadd.Code);
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
            TempEmailItem.Subject := GetSubject(recEmailAdd.Code, pLanguageCode, pSellToCustNo);
            TempEmailItem.SetBodyText := GetBody(recEmailAdd.Code, pLanguageCode, pSellToCustNo, pHideDialog);
            TempEmailItem."E-mail Address Code" := recEmailAdd.Code;
            TempEmailItem."E-mail Language Code" := pLanguageCode;
        end;
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
                recEmailHTMLfiles.SetRange(Code, recEmailaddress."E-mail HTML file");
                if recEmailHTMLfiles.FindSet() then HTMLFileName := Text002 + recEmailHTMLfiles.Filename;
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
        end;
    end;
}
