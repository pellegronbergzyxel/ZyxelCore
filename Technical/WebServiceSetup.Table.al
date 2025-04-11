Table 50073 "Web Service Setup"
{
    // 001. 02-04-19 ZY-LD P0213 - Project Rock.
    // 002. 17-04-19 ZY-LD P0221 - HTTP / HTTPS.
    // 003. 30-04-19 ZY-LD P0224 - New fields.

    Caption = 'Web Service Setup';
    DrillDownPageID = "Web Service Setup";
    LookupPageID = "Web Service Setup";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Server Name"; Text[30])
        {
            Caption = 'Server Name';
        }
        field(3; "Port No."; Text[4])
        {
            Caption = 'Port No.';
            Numeric = true;
        }
        field(4; "Service Tier Name"; Text[30])
        {
            Caption = 'Service Tier Name';
        }
        field(5; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
            ValidateTableRelation = false;
        }

        field(6; "User Name"; Code[80])
        {
            DataClassification = AccountData;
        }
        field(7; "Password"; Text[80])
        {
            DataClassification = AccountData;
            //ExtendedDatatype = Masked;
        }

        field(12; "Server Name (Test)"; Text[30])
        {
            Caption = 'Server Name (Test)';
        }
        field(13; "Port No. (Test)"; Text[4])
        {
            Caption = 'Port No. (Test)';
            Numeric = true;
        }
        field(14; "Service Tier Name (Test)"; Text[30])
        {
            Caption = 'Service Tier Name (Test)';
        }
        field(15; "Server Name (Dev)"; Text[30])
        {
            Caption = 'Server Name (Dev)';
        }
        field(16; "Port No. (Dev)"; Text[4])
        {
            Caption = 'Port No. (Dev)';
            Numeric = true;
        }
        field(17; "Service Tier Name (Dev)"; Text[30])
        {
            Caption = 'Service Tier Name (Dev)';
        }
        field(18; "Test Name"; Code[10])
        {
            Caption = 'Test Name';
        }
        field(19; HTTP; Option)
        {
            Caption = 'HTTP';
            Description = '17-04-19 ZY-LD 002';
            OptionMembers = "http:","https:";
        }
        field(20; "HTTP (Test)"; Option)
        {
            Caption = 'HTTP (Test)';
            Description = '17-04-19 ZY-LD 002';
            OptionMembers = "http:","https:";
        }
        field(21; "HTTP (Dev)"; Option)
        {
            Caption = 'HTTP (Dev)';
            Description = '17-04-19 ZY-LD 002';
            OptionMembers = "http:","https:";
        }
        field(22; "Trace Mode"; Boolean)
        {
            Caption = 'Trace Mode';
            Description = '30-04-19 ZY-LD 003';

            trigger OnValidate()
            begin
                if "Trace Mode" then
                    "Trace Mode Date" := Today;
            end;
        }
        field(23; "Trace Mode Date"; Date)
        {
            Caption = 'Trace Mode Date';
            Description = '30-04-19 ZY-LD 003';
        }
    }

    keys
    {
        key(Key1; "Code", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure GetServerNameAndPortNo(pWebServiceSetupCode: Code[20]; pCompanyName: Text): Text
    var
        recSrvEnviron: Record "Server Environment";
        recWebServiceSetup: Record "Web Service Setup";
    begin
        // IF recSrvEnviron.IsItDevelopmentEnvironment THEN BEGIN
        //  recWebServiceSetup."Server Name" := 'ZyEU-NAVDev01.zyeu.zyxel.eu';
        //  recWebServiceSetup."Port No." := '7347';
        //  recWebServiceSetup."Service Tier Name" := 'DEV-Webservice'
        // END ELSE
        //  IF recSrvEnviron.IsItTestEnvironment THEN BEGIN
        //    recWebServiceSetup."Server Name" := 'user_test';
        //    recWebServiceSetup."Port No." := '8847';
        //    recWebServiceSetup."Service Tier Name" := 'WebService_TEST'
        //  END;
        // EXIT(STRSUBSTNO('http://%1:%2/%3',recWebServiceSetup."Server Name",recWebServiceSetup."Port No.",recWebServiceSetup."Service Tier Name"));

        recWebServiceSetup.SetRange(Code, pWebServiceSetupCode);
        recWebServiceSetup.SetFilter("Company Name", '%1|%2', pCompanyName, '');
        recWebServiceSetup.FindLast;
        if recSrvEnviron.ProductionEnvironment then
            exit(
              StrSubstNo('%1//%2:%3/%4',
                Format(recWebServiceSetup.HTTP),  // 17-04-19 ZY-LD 002
                recWebServiceSetup."Server Name", recWebServiceSetup."Port No.", recWebServiceSetup."Service Tier Name"))
        else
            if recSrvEnviron.TestEnvironment then
                exit(
                  StrSubstNo('%1//%2:%3/%4',
                    Format(recWebServiceSetup."HTTP (Test)"),  // 17-04-19 ZY-LD 002
                    recWebServiceSetup."Server Name (Test)", recWebServiceSetup."Port No. (Test)", recWebServiceSetup."Service Tier Name (Test)"))
            else
                exit(
                  StrSubstNo('%1//%2:%3/%4',
                    Format(recWebServiceSetup."HTTP (Dev)"),  // 17-04-19 ZY-LD 002
                    recWebServiceSetup."Server Name (Dev)", recWebServiceSetup."Port No. (Dev)", recWebServiceSetup."Service Tier Name (Dev)"))
    end;


    procedure GetContentType(): Text
    var
        lText001: label '<application/xml; chartset=utf-8>';
    begin
        exit('application/xml; chartset=utf-8');
    end;


    procedure GetWsUrl(pWebSrvSetupCode: Code[10]; pCompany: Text[80]; pObjectID: Integer) rValue: Text
    var
        recSrvEnviron: Record "Server Environment";
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceName: Text;
        CompName: Text;
        lText001: label 'Do you want to send request to\%1?';
        lText002: label 'Request is stopped.';
        SI: Codeunit "Single Instance";
    begin
        WebServiceName := GetWebServiceName(pObjectID);
        pWebSrvSetupCode := GetWebServerSetupCode(pWebSrvSetupCode);
        if recSrvEnviron.ProductionEnvironment then
            CompName := pCompany
        else
            if recWebServiceSetup.Get(pWebSrvSetupCode, pCompany) and (recWebServiceSetup."Test Name" <> '') then
                CompName := StrSubstNo('%1 %2', recWebServiceSetup."Test Name", pCompany)
            else
                CompName := pCompany;

        rValue := StrSubstNo('%1/WS/%2/Codeunit/%3', GetServerNameAndPortNo(pWebSrvSetupCode, pCompany), CompName, WebServiceName);

        if not recSrvEnviron.ProductionEnvironment and
           ZGT.UserIsDeveloper and
           not SI.GetHideSalesDialog and  // 02-04-19 ZY-LD 001
           GuiAllowed  // 16-11-23 ZY-LD 000
        then
            if not Confirm(lText001, true, rValue) then
                Error(lText002);

        //The following is to ensure that the record is fetched, spo the user name and password can be used.
        recWebServiceSetup.SetRange(Code, pWebSrvSetupCode);
        recWebServiceSetup.SetFilter("Company Name", '%1|%2', pCompany, '');
        recWebServiceSetup.FindLast;

        Rec := recWebServiceSetup;

    end;


    procedure GetSoapAction(pFunctionname: Text; pObjectID: Integer): Text
    begin
        if pFunctionname = '' then
            exit(StrSubstNo('urn:microsoft-dynamics-schemas/codeunit/%1', GetWebServiceName(pObjectID)))
        else
            exit(StrSubstNo('urn:microsoft-dynamics-schemas/codeunit/%1:%2', GetWebServiceName(pObjectID), pFunctionname));
    end;

    local procedure GetWebServiceName(pObjectID: Integer): Text
    var
        recWebService: Record "Web Service";
    begin
        recWebService.SetRange("Object Type", recWebService."object type"::Codeunit);
        recWebService.SetRange("Object ID", pObjectID);
        recWebService.FindFirst;
        exit(recWebService."Service Name");
    end;


    procedure GetWebServerSetupCode(pCode: Code[10]): Code[10]
    begin
        case pCode of
            'ZY':
                exit('ZYWEBSERV');
            'NW':
                exit('NWWEBSERV');  // 02-04-19 ZY-LD 001
            'HQ':
                exit('HQWEBSERV');
        end;
    end;
}
