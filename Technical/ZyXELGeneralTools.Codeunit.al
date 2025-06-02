Codeunit 50000 "ZyXEL General Tools"
{
    // // The object has been moved to CU 50.000 so it can be copied to IT and TR.
    // 
    // 001. 05-04-18 ZY-LD 2018040410000201 - Accounting Managers.
    // 002. 08-05-18 ZY-LD P0042 - New company functions.
    // 003. 22-05-18 ZY-LD 2018050910000191 - User is HR.
    // 004. 29-06-18 ZY-LD 2018062910000053 - 'ZYEU\ALENA.SEMBEROVA' is added.
    // 005. 06-08-18 ZY-LD 2018080610000128 - Only DK is Accounting Managers.
    // 006. 20-08-18 ZY-LD 2018082010000182 - Translate month no. to text.
    // 007. 20-11-18 PAB - Added function ValidateDirectoryPath to check if a folder exists.
    // 008. 16-01-19 ZY-LD 2019011610000076 - Danish Accounting managers.
    // 009. 24-06-19 ZY-LD 000 - Avoid division by zero.
    // 010. 07-08-19 ZY-LD 2019080610000117 - Validate E-mail.
    // 011. 25-10-19 ZY-LD 000 - Validate E-mail.
    // 012. 28-10-19 ZY-LD 2019102510000131 - Kirstine and Henriette added.
    // 013. 16-01-20 ZY-LD 2020011610000028 - Delete blank values from e-mail.
    // 014. 01-08-22 ZY-LD 2022071510000177 - MDM´s also needs access to picking days.
    // 015. 16-08-22 ZY-LD 2022081610000101 - Ahmad is added.
    // 016. 28-12-22 ZY-LD 000 - Convert Charters on e-mails.
    // 017. 02-02-23 ZY-LD #8882881 - UK is added as accounting manager.


    trigger OnRun()
    var
        xxx: Record "Price List Line";
    begin
    end;

    var
        StartTime: Time;
        QuantityRec: Integer;
        TotalRec: Integer;
        Window: Dialog;
        WindowOpen: Boolean;
        ShowExpEndTime: Boolean;
        PrevPercent: Decimal;


    procedure IsRhq(): Boolean
    var
        Comp: Text;
        GetRh: Text;
    begin
        //Ret := CompanyName() = 'ZyXEL (RHQ) Go LIVE';
        exit(CompanyName() = GetRHQCompanyName);
    end;


    procedure IsUK() Ret: Boolean
    begin
        //Ret := CompanyName() = 'ZyND UK';
        exit(CompanyName() = GetCompanyName(2));
    end;


    procedure IsZComCompany() rValue: Boolean
    begin
        rValue := not IsZNetCompany;
    end;


    procedure IsZNetCompany() rValue: Boolean
    begin
        rValue := StrPos(UpperCase(CompanyName()), 'ZNET') <> 0;
    end;

    procedure IsZNetCompanyv2(Compname: text[30]) rValue: Boolean
    begin
        rValue := UpperCase(Compname).Contains('ZNET');
    end;


    procedure GetRHQCompanyName(): Text
    begin
        //EXIT('ZyXEL (RHQ) Go LIVE');
        exit(GetCompanyName(1));
    end;


    procedure OpenProgressWindow(PrimaryKey: Text; pTotalRec: Integer)
    var
        lText001: label 'Total number of records          #1######## \';
        lText002: label 'Start Time #4#####  Expected End Time #5##### \\';
        lText003: label 'Primary Key ######2####################### \';
    begin
        if not GuiAllowed then
            exit;

        StartTime := Time;
        QuantityRec := 0;
        TotalRec := pTotalRec;
        Window.Open(lText001 +
                    lText002 +
                    lText003 +
                    '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ');

        Window.Update(1, Format(TotalRec, 0, '<Integer Thousand>'));
        Window.Update(2, CopyStr(PrimaryKey, 1, 40));
        Window.Update(4, Format(StartTime, 8, 0));

        WindowOpen := true;
    end;


    procedure UpdateProgressWindow(PrimaryKey: Text; pQuantityRec: Integer; pCalcExpectedEndTime: Boolean)
    var
        CurrTime: Time;
        Percent: Decimal;
        ExpectedRunTime: Decimal;
    begin
        if (not GuiAllowed) or (not WindowOpen) then
            exit;

        if TotalRec = 0 then  // 24-06-19 ZY-LD 009
            TotalRec := 1;  // 24-06-19 ZY-LD 009
        if pQuantityRec = 0 then
            QuantityRec += 1
        else
            QuantityRec += pQuantityRec;
        Window.Update(2, PrimaryKey);
        Window.Update(3, ROUND(QuantityRec / TotalRec * 10000, 1));

        CurrTime := Time;
        Percent := ROUND(QuantityRec / TotalRec * 100, 1, '>');
        if pCalcExpectedEndTime then begin
            if Percent - PrevPercent > 5 then begin
                if ShowExpEndTime then begin
                    ExpectedRunTime := ROUND(100 * (CurrTime - StartTime) / Percent, 1);
                    Window.Update(5, Format(StartTime + ExpectedRunTime, 8, 0));
                end;
                ShowExpEndTime := false;
                PrevPercent := Percent;
            end else
                ShowExpEndTime := true;
        end else
            Window.Update(5, '');

    end;


    procedure CloseProgressWindow()
    begin
        if (not GuiAllowed) or (not WindowOpen) then
            exit;

        Window.Close;
        WindowOpen := false;
    end;


    procedure UserIsDeveloper(): Boolean
    var
        accessControl: Record "Access Control";

    begin
        accessControl.setrange("User Security ID", UserSecurityId());
        accessControl.setrange("Role ID", 'IsDeveloper');
        if accessControl.findset then
            exit(true);

        exit(UpperCase(UserId()) in ['ZYEU\LARS.DYRING', 'ZYEU\SL', 'ZYEU\ANDREA.GIORDANI', 'ZYEU\PELLE.GRONBERG']);
    end;


    procedure UserIsAccManager(Country: Code[10]): Boolean
    begin
        if UserIsDeveloper then
            exit(true);

        //>> 16-01-19 ZY-LD 008
        case Country of
            'DK':
                exit(UpperCase(UserId()) in
                  ['CNIELSEN',
                  'ZYEU\CNIELSEN',
                  'ZYEU\CHRISTEL.NIELSEN',
                  'HBN',
                  'ZYEU\HANNE.NIELSEN',
                  'ZYEU\MIE.RASMUSSEN',
                  'ZYEU\MARIA.NISSEN',
                  'ZYEU\KIRSTINE.SPARRE',  // 28-10-19 ZY-LD 012
                  'ZYEU\FABRIZIO.BONELLI',  // 14-10-20 ZY-LD 014
                  'ZYEU\AHMAD.ALSAID',  // 16-08-22 ZY-LD 015
                  'ZYEU\MARK.ELSNER']);
            'UK':
                exit(UpperCase(UserId()) in ['ZYEU\BEN.WOOD', 'ZYEU\ANGUS.DENWOOD']);  // 02-02-23 ZY-LD 017
            else  //<< 16-01-19 ZY-LD 008
                exit(UpperCase(UserId()) in
                  ['CNIELSEN',
                  'HBN',
                  'ZYEU\HANNE.NIELSEN',
                  'ZYEU\MIE.RASMUSSEN',
                  'ZYEU\MARIA.NISSEN',
                  'ZYEU\VOJTECH.TAKAC',
                  'ZYEU\OLGA.MINARIKOVA',
                  'ZYEU\BLANKA.M',  // 05-04-18 ZY-LD 001
                  'ZYEU\ALENA.SEMBEROVA',  // 29-06-18 ZY-LD 004
                  'ZYEU\EVA.SIMONOVA',  // 14-10-20 ZY-LD 014
                  'ZYEU\KIRSTINE.SPARRE',  // 28-10-19 ZY-LD 012
                  'ZYEU\FABRIZIO.BONELLI',  // 14-10-20 ZY-LD 014
                  'ZYEU\AHMAD.ALSAID',  // 16-08-22 ZY-LD 015
                  'ZYEU\MARK.ELSNER',
                  'ZYEU\BEN.WOOD',  // 02-02-23 ZY-LD 017
                  'ZYEU\ANGUS.DENWOOD']);  // 02-02-23 ZY-LD 017
        end;
    end;


    procedure UserIsHr(): Boolean
    begin
        //>> 22-05-18 ZY-LD 003
        if UserIsDeveloper then
            exit(true);

        exit(UpperCase(UserId()) in
          ['ZYEU\STEINERI', 'ZYEU\JACKIE.MAYERS-FINK']);
        //<< 22-05-18 ZY-LD 003
    end;


    procedure UserIsLogistics(): Boolean
    var
        recUserSetup: Record "User Setup";
    begin
        //>> 27-08-21 ZY-LD 014
        if UserIsDeveloper then
            exit(true);

        if UpperCase(UserId()) in ['PKLUG', 'TM', 'RKAUSSEN', 'ZYEU\MARC.BACKHAUS'] then
            exit(true);
        //<< 27-08-21 ZY-LD 014

        //>> 01-08-22 ZY-LD 014
        if recUserSetup.Get(UserId()) then
            exit(recUserSetup.MDM);
        //<< 01-08-22 ZY-LD 014
    end;


    procedure SendEmailToNavSupport(pDescription: Text; pErrorMessage: Text)
    var
        lEmailAdd: Record "E-mail address";
        MailMgt: Codeunit "E-mail Address Management";
        lText001: label 'Error on task "%1". (%2).';
    begin
        if lEmailAdd.Get('JOBQUEUE') then begin
            MailMgt.CreateEmailWithBodytext(lEmailAdd.Code, StrSubstNo(lText001, pDescription, pErrorMessage), '');
            MailMgt.Send;
        end;
    end;


    procedure ValidateEmailAdd(pEmailAdd: Text) rvalue: Text
    var
        recConvChar: Record "Convert Characters";
        MailMgt: Codeunit "Mail Management";
    begin
        if (StrPos(pEmailAdd, '<') <> 0) or
           (StrPos(pEmailAdd, '[') <> 0)  // 07-08-19 ZY-LD 010
        then begin
            rvalue := pEmailAdd;
            rvalue := CopyStr(rvalue, StrPos(pEmailAdd, '<') + 1, StrLen(pEmailAdd));
            rvalue := DelChr(rvalue, '=', '>');
            rvalue := CopyStr(rvalue, StrPos(pEmailAdd, '[') + 1, StrLen(pEmailAdd));  // 07-08-19 ZY-LD 010
            rvalue := DelChr(rvalue, '=', ']');  // 07-08-19 ZY-LD 010
        end else
            rvalue := pEmailAdd;

        rvalue := DelChr(rvalue, '=', ' ');  // 16-01-20 ZY-LD 013
        //>> 25-10-19 ZY-LD 011
        rvalue := ConvertStr(rvalue, ',', ';');
        rvalue := DelChr(rvalue, '<>', ';:');
        rvalue := recConvChar.ConvertCharacters(rvalue);  // 28-12-22 ZY-LD 016
        if rvalue <> '' then
            MailMgt.CheckValidEmailAddresses(rvalue);
        //<< 25-10-19 ZY-LD 011
    end;


    procedure GetExcelColumnHeader(var pColumnNo: Integer) rValue: Text[2]
    var
        NoOfLetters: Integer;
        NoOfPositions: Integer;
        L1: Integer;
        L2: Integer;
        L3: Integer;
        i: Integer;
    begin
        pColumnNo += 1;

        NoOfLetters := 26;
        if pColumnNo MOD NoOfLetters = 0 then
            NoOfPositions := ROUND(pColumnNo / NoOfLetters, 1, '<')
        else
            NoOfPositions := ROUND(pColumnNo / NoOfLetters, 1, '<') + 1;
        case NoOfPositions of
            1:
                rValue := GetColumnLetter(pColumnNo);
            else begin
                rValue := GetColumnLetter(NoOfPositions - 1);
                if pColumnNo MOD NoOfLetters = 0 then
                    rValue += GetColumnLetter(NoOfLetters)
                else
                    rValue += GetColumnLetter(pColumnNo MOD NoOfLetters);
            end;
        end;

        // IF pColumnNo / NoOfLetters <= 1 then
        //  L1 := pColumnNo
        // ELSE
        //  IF pColumnNo / NoOfLetters <= 2 THEN BEGIN
        //    L1 := 1;
        //    IF pColumnNo / NoOfLetters = 2 THEN
        //      L2 := pColumnNo / NoOfLetters
        //    ELSE
        //      L2 := pColumnNo MOD NoOfLetters;
        //  END ELSE
        //    IF pColumnNo / NoOfLetters <= 3 THEN BEGIN
        //      L1 := 2;
        //      IF pColumnNo / NoOfLetters = 3 THEN
        //        L2 := pColumnNo / NoOfLetters
        //      ELSE
        //        L2 := pColumnNo MOD NoOfLetters;
    end;


    procedure GetColumnLetter(pColumnNo: Integer): Text[2]
    begin
        case pColumnNo of
            1:
                exit('A');
            2:
                exit('B');
            3:
                exit('C');
            4:
                exit('D');
            5:
                exit('E');
            6:
                exit('F');
            7:
                exit('G');
            8:
                exit('H');
            9:
                exit('I');
            10:
                exit('J');
            11:
                exit('K');
            12:
                exit('L');
            13:
                exit('M');
            14:
                exit('N');
            15:
                exit('O');
            16:
                exit('P');
            17:
                exit('Q');
            18:
                exit('R');
            19:
                exit('S');
            20:
                exit('T');
            21:
                exit('U');
            22:
                exit('V');
            23:
                exit('W');
            24:
                exit('X');
            25:
                exit('Y');
            26:
                exit('Z');
            27:
                exit('AA');
            28:
                exit('AB');
            29:
                exit('AC');
            30:
                exit('AD');
            31:
                exit('AE');
            32:
                exit('AF');
            33:
                exit('AG');
            34:
                exit('AH');
            35:
                exit('AI');
            36:
                exit('AJ');
            37:
                exit('AK');
            38:
                exit('AL');
            39:
                exit('AM');
            40:
                exit('AN');
            41:
                exit('AO');
            42:
                exit('AP');
            43:
                exit('AQ');
            44:
                exit('AR');
            45:
                exit('AS');
            46:
                exit('AT');
            47:
                exit('AU');
            48:
                exit('AV');
            49:
                exit('AW');
            50:
                exit('AX');
            51:
                exit('AY');
            52:
                exit('AZ');
        end;
    end;


    procedure GetColumnNumber(pColumn: Code[1]): Integer
    begin
        case pColumn of
            'A':
                exit(1);
            'B':
                exit(2);
            'C':
                exit(3);
            'D':
                exit(4);
            'E':
                exit(5);
            'F':
                exit(6);
            'G':
                exit(7);
            'H':
                exit(8);
            'I':
                exit(9);
            'J':
                exit(10);
            'K':
                exit(11);
            'L':
                exit(12);
            'M':
                exit(13);
            'N':
                exit(14);
            'O':
                exit(15);
            'P':
                exit(16);
            'Q':
                exit(17);
            'R':
                exit(18);
            'S':
                exit(19);
            'T':
                exit(20);
            'U':
                exit(21);
            'V':
                exit(22);
            'W':
                exit(23);
            'X':
                exit(24);
            'Y':
                exit(25);
            'Z':
                exit(26);
        end;
    end;


    procedure GetCompanyName(pCompanyOption: Option " ",RHQ,UK,SE,RU,NO,NL,ME,FI,ES,DK,DE,CZ,SP,IT,TR,HU,PL,FR,BE): Text
    var
        recCompany: Record "Zyxel Company";
        lText001: label '%1 was not found.';
    begin
        // Returns the requested company name
        //>> 11-04-19 ZY-LD 009
        if StrPos(UpperCase(CompanyName()), 'ZNET') = 0 then
            recCompany.SetRange("HQ Company", recCompany."hq company"::Zyxel)
        else
            recCompany.SetRange("HQ Company", recCompany."hq company"::Networks);
        //<< 11-04-19 ZY-LD 009
        //>> 08-05-18 ZY-LD 002
        recCompany.SetRange("Company Option", pCompanyOption);
        if recCompany.FindFirst then
            exit(recCompany.Name);
        // ELSE  // 11-04-19 ZY-LD 009
        //  ERROR(lText001,pCompanyOption);  // 11-04-19 ZY-LD 009
        //<< 08-05-18 ZY-LD 002
    end;


    procedure GetSistersCompanyName(pCompanyOption: Option " ",RHQ,UK,SE,RU,NO,NL,ME,FI,ES,DK,DE,CZ,SP,IT,TR,HU,PL,FR,BE): Text
    var
        recCompany: Record "Zyxel Company";
        lText001: label '%1 was not found.';
    begin
        // Returns the requested company name
        if StrPos(UpperCase(CompanyName()), 'ZNET') <> 0 then
            recCompany.SetRange("HQ Company", recCompany."hq company"::Zyxel)
        else
            recCompany.SetRange("HQ Company", recCompany."hq company"::Networks);
        recCompany.SetRange("Company Option", pCompanyOption);
        if recCompany.FindFirst then
            exit(recCompany.Name);
    end;


    procedure CompanyNameIs(pCompanyOption: Option " ",RHQ,UK,SE,RU,NO,NL,ME,FI,ES,DK,DE,CZ,SP,IT,TR,HU,PL,FR,BE): Boolean
    var
        recCompany: Record Company;
    begin
        // Tell if the user is in a specific company
        //>> 11-04-19 ZY-LD 009
        // //>> 08-05-18 ZY-LD 002
        // recCompany.SETRANGE("Company Option",pCompanyoption);
        // IF recCompany.FINDFIRST AND (CompanyName() = recCompany.Name) THEN
        //  EXIT(TRUE);
        // //<< 08-05-18 ZY-LD 002

        exit(GetCompanyName(pCompanyOption) = CompanyName());
        //<< 11-04-19 ZY-LD 009
    end;

    procedure EMEAServer(): Boolean
    var
        ServerInstance: Record "Server Instance";
    begin
        ServerInstance.Setfilter("Service Name", '%1|%2', 'EMEA-WS', 'TESTEMEA-WS');
        if ServerInstance.FindFirst then
            exit(true);
    end;

    procedure TurkishServer(): Boolean
    var
        ServerInstance: Record "Server Instance";
    begin
        ServerInstance.SetFilter("Service Name", '%1|%2', 'TR-WS', 'TESTTR-WS');
        if ServerInstance.FindFirst then
            exit(true);
    end;


    procedure ItalianServer(): Boolean
    var
        ServerInstance: Record "Server Instance";
    begin
        ServerInstance.SetFilter("Service Name", '%1|%2', 'IT-WS', 'TESTIT-WS');
        if ServerInstance.FindFirst then
            exit(true);
    end;


    procedure GetMonthText(pMonthNo: Integer; pLowercase: Boolean; pUppercase: Boolean; pShortText: Boolean) rValue: Text
    begin
        //>> 20-08-18 ZY-LD 006
        case pMonthNo of
            1:
                rValue := 'January';
            2:
                rValue := 'February';
            3:
                rValue := 'March';
            4:
                rValue := 'April';
            5:
                rValue := 'May';
            6:
                rValue := 'June';
            7:
                rValue := 'July';
            8:
                rValue := 'August';
            9:
                rValue := 'September';
            10:
                rValue := 'October';
            11:
                rValue := 'November';
            12:
                rValue := 'December';
        end;

        if pLowercase then
            rValue := Lowercase(rValue);
        if pUppercase then
            rValue := UpperCase(rValue);
        if pShortText then
            rValue := CopyStr(rValue, 1, 3);
        //<< 20-08-18 ZY-LD 006
    end;


    procedure DecimalFormat(pAmountStr: Text) rValue: Code[2]
    var
        i: Integer;
    begin
        for i := StrLen(pAmountStr) downto StrLen(pAmountStr) - 2 do
            if i > 0 then
                case pAmountStr[i] of
                    ',':
                        rValue := 'DK';
                    '.':
                        rValue := 'UK';
                end;
    end;


    procedure ConvertToUKDecimalFormat(pAmountStr: Text) rValue: Text
    begin
        case DecimalFormat(pAmountStr) of
            'DK':
                begin
                    rValue := DelChr(pAmountStr, '=', '.');
                    rValue := ConvertStr(rValue, ',', '.');
                end;
            'UK':
                rValue := DelChr(pAmountStr, '=', ',')
            else
                rValue := DelChr(pAmountStr, '=', '.,')
        end;
    end;


    procedure ConvertBooleanToTrueFalse(Value: Boolean; CaseOption: Option " ",Uppercase,Lowercase) rValue: Text[5]
    begin
        if Value then
            rValue := 'True'
        else
            rValue := 'False';

        case CaseOption of
            Caseoption::Uppercase:
                rValue := UpperCase(rValue);
            Caseoption::Lowercase:
                rValue := Lowercase(rValue);
        end;
    end;


    procedure ConvertTextToDate(pDateText: Text; FromFormat: Option UK,DK) rValue: Date
    var
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
    begin
        if (StrPos(pDateText, '-') = 5) or (StrPos(pDateText, '/') = 5) then
            FromFormat := Fromformat::UK;
        if (StrPos(pDateText, '-') = 3) or (StrPos(pDateText, '/') = 3) then
            FromFormat := Fromformat::DK;

        case FromFormat of
            Fromformat::DK:
                begin
                    if (StrPos(pDateText, '-') <> 0) or (StrPos(pDateText, '/') <> 0) then begin
                        Evaluate(DD, CopyStr(pDateText, 1, 2));
                        Evaluate(MM, CopyStr(pDateText, 4, 2));
                        if MaxStrLen(pDateText) = 11 then
                            Evaluate(YYYY, CopyStr(pDateText, 7, 4))
                        else begin
                            Evaluate(YYYY, CopyStr(pDateText, 7, 2));
                            YYYY := 2000 + YYYY;
                        end;
                    end else begin
                        Evaluate(DD, CopyStr(pDateText, 1, 2));
                        Evaluate(MM, CopyStr(pDateText, 3, 2));
                        Evaluate(YYYY, CopyStr(pDateText, 5, 4));
                    end;
                end;
            Fromformat::UK:
                begin
                    if (StrPos(pDateText, '-') <> 0) or (StrPos(pDateText, '/') <> 0) then begin
                        Evaluate(DD, CopyStr(pDateText, 9, 2));
                        Evaluate(MM, CopyStr(pDateText, 6, 2));
                        Evaluate(YYYY, CopyStr(pDateText, 1, 4));
                    end else begin
                        Evaluate(DD, CopyStr(pDateText, 7, 2));
                        Evaluate(MM, CopyStr(pDateText, 5, 2));
                        Evaluate(YYYY, CopyStr(pDateText, 1, 4));
                    end;
                end;
        end;
        rValue := Dmy2date(DD, MM, YYYY);
    end;


    procedure ValidateXmlFormattedAmount(AmountText: Text[50]) rValue: Decimal
    var
        Amount: array[2] of Decimal;
        CentText: Text[10];
    begin
        AmountText := ConvertStr(AmountText, '.', ',');
        Evaluate(rValue, AmountText);
    end;


    procedure IsEicard(pLocationCode: Code[10]): Boolean
    begin
        exit(pLocationCode = 'EICARD');
    end;

    local procedure DontDeleteTheseObjects()
    var
        ">> Role Center": Integer;
        AccountingManagerZYXELRTC: Page "Accounting Manager ZYXEL RTC";
        SCMZYXELRTC: Page "SCM Zyxel RTC";
        OrderDeskZYXELRTC: Page "Order Desk ZYXEL RTC";
        SalesManagerZYXELRTC: Page "Sales Manager ZYXEL RTC";
        MDMZYXELRTC: Page "MDM ZYXEL RTC";
        HRRoleCenter: Page "HR Role Center";
        ItRoleCenter: Page "It Role Center";
        LogisticsZYXELRoleCenter: Page "Logistics ZYXEL Role Center";
        LogisticZYXELRTC: Page "Logistic ZYXEL RTC";
        ">> Zetadocs": Integer;
        ZyxelReturnOrderConf: Report "Zyxel - Return Order Conf.";
        ">> Events": Integer;
        VendorEvent: Codeunit "Vendor Event";
        ExcelReportManagement: Codeunit "Excel Report Management";
        JobQueueEvent: Codeunit "Job Queue Event";
        SalesHeaderLineEvents: Codeunit "Sales Header/Line Events";
        CustomerEvents: Codeunit "Customer Events";
        TransferEvent: Codeunit "Transfer Event";
        PurchaseHeaderLineEvents: Codeunit "Purchase Header/Line Events";
        SalesPostEvents: Codeunit "Sales Post Events";
        GeneralLedgerEvent: Codeunit "General Ledger Event";
        ZyxelGeneralEvent: Codeunit "Zyxel General Event";
        PurchasePostEvent: Codeunit "Purchase Post Event";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        OvershipmentEvent: Codeunit "Overshipment Event";
        ">> Web Service": Integer;
        ZyxelWebService: Codeunit "Zyxel Web Service";
        ZyxelHQWebService: Codeunit "Zyxel HQ Web Service";
        PhasesWebService: Codeunit "Phases Web Service";
        ">> Job Queue": Integer;
        CreateandReleaseWhseInbou: Codeunit "Create and Release Whse. Inbou";
        CreateNormalSalesInvoice: Codeunit "Create Normal Sales Invoice";
        DailySalesReportEmail: Codeunit "Daily Sales Report Email";
        DeleteChangeLogentries: Codeunit "Delete Change Log entries";
        DownloadBatteryCertificate: Codeunit "Download Battery Certificate";
        EmailBacklogReport: Codeunit "E-mail Backlog Report";
        ExportCategoryCode: Report "Export Category Code";
        HQSalesDocumentDownload: Codeunit "HQ Sales Document Download";
        HQSalesDocumentManagement: Codeunit "HQ Sales Document Management";
        JobQueueMonitor: Codeunit "Job Queue Monitor";
        ProcessEiCardLinks: Codeunit "Process EiCard Links";
        ProcessEMEAPurchasePrice: Codeunit "Process EMEA Purchase Price";
        ProcessSalesDocumentEmail: Codeunit "Process Sales Document E-mail";
        UpdateEndCustSalesInvNo: Codeunit "Update End Cust. Sales Inv. No";
        UpdateInventoryMovement: Codeunit "Update Inventory Movement";
        WarehouseInventoryRequest: Codeunit "Warehouse Inventory Request";
        ZyXELReplication: Codeunit "ZyXEL Replication";
        ZyxelEmployeeReminderEmail: Report "Zyxel Employee Reminder E-mail";
        ZyxelVCKPostManagement: Codeunit "Zyxel VCK Post Management";
        UpdateCurrExchRatesEOM: Codeunit "Update Curr. Exch. Rates - EOM";
        SendEicardstoeShop: Codeunit "Send Eicards to eShop";
        ">> Documents": Integer;
        ">> MTD": Integer;
    begin
    end;


    procedure "PRODUCTNAME.SHORT"(): Text
    begin
        exit('Dynamics NAV');
    end;


    procedure "PRODUCTNAME.FULL"(): Text
    begin
        exit('Microsoft Dynamics NAV');
    end;


    procedure "PRODUCTNAMT.MARKETING"(): Text
    begin
        exit('Microsoft Dynamics NAV 2017');
    end;

    procedure GetFullUserName(userID: Guid) rValue: Text
    var
        UserInfo: Record User;
    begin
        if UserInfo.Get(userID) then
            rValue := UserInfo."Full Name";
    end;
}
