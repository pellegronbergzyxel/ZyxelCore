Codeunit 50084 "Zyxel Web Service Request"
{
    trigger OnRun()
    begin
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        ServerEnviron: Record "Server Environment";

    procedure ReplicateItem(pCompany: Text[80]; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendItems';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendItems xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<items>' +
                      pInnerText +
                     '</items>' +
                   '</SendItems>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));

        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateItemOLD(pCompany: Text[80]; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendItems';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendItems xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<items>' +
                      pInnerText +
                     '</items>' +
                   '</SendItems>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));

        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure ReplicateGlAccount(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendGlAccount';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendGlAccounts xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<glAccounts>' +
                       pInnerXML +
                     '</glAccounts>' +
                   '</SendGlAccounts>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));

        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateGlAccountOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendGlAccount';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendGlAccounts xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<glAccounts>' +
                       pInnerXML +
                     '</glAccounts>' +
                   '</SendGlAccounts>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));

        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure ReplicateCostTypeName(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendCostTypes';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendCostTypes xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<costTypes>' +
                       pInnerXML +
                     '</costTypes>' +
                   '</SendCostTypes>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateCostTypeNameOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendCostTypes';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendCostTypes xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<costTypes>' +
                       pInnerXML +
                     '</costTypes>' +
                   '</SendCostTypes>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure ReplicateCustomer(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendCustomers';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<SendCustomers xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<customers>' +
                       pInnerXML +
                     '</customers>' +
                   '</SendCustomers>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateCustomerOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendCustomers';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<SendCustomers xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<customers>' +
                       pInnerXML +
                     '</customers>' +
                   '</SendCustomers>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure ReplicateEmailAddress(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendEmailAddress';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendEmailAddress xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<emailAddresses>' +
                       pInnerXML +
                     '</emailAddresses>' +
                   '</SendEmailAddress>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateEmailAddressOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendEmailAddress';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendEmailAddress xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<emailAddresses>' +
                       pInnerXML +
                     '</emailAddresses>' +
                   '</SendEmailAddress>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure ReplicateUserSetup(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendUserSetups';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendUserSetups xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<userSetup>' +
                       pInnerXML +
                     '</userSetup>' +
                   '</SendUserSetups>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateUserSetupOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendUserSetups';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendUserSetups xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<userSetup>' +
                       pInnerXML +
                     '</userSetup>' +
                   '</SendUserSetups>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure ReplicateICInboxPurchHead(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendIcInboxPurchHeader';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<SendIcInboxPurchHeader xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<icInboxPurchaseHeaders>' +
                       pInnerXML +
                     '</icInboxPurchaseHeaders>' +
                   '</SendIcInboxPurchHeader>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateICInboxPurchHeadOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendIcInboxPurchHeader';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<SendIcInboxPurchHeader xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<icInboxPurchaseHeaders>' +
                       pInnerXML +
                     '</icInboxPurchaseHeaders>' +
                   '</SendIcInboxPurchHeader>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;

    local procedure ReplicatePermission(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendPermissions';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<SendPermissions xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<permission>' +
                       pInnerXML +
                     '</permission>' +
                   '</SendPermissions>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    local procedure ReplicatePermissionOLD(pCompany: Text[80]; pInnerXML: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendPermissions';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<SendPermissions xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<permission>' +
                       pInnerXML +
                     '</permission>' +
                   '</SendPermissions>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;
    // CLOUD READY DELETE
    procedure ReplicateItemBudgetEntry(pCompany: Text[80]; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendItemBudgetEntry';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendItemBudgetEntry xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<pItemBudgetEntries>' +
                      pInnerText +
                     '</pItemBudgetEntries>' +
                   '</SendItemBudgetEntry>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure ReplicateItemBudgetEntryOLD(pCompany: Text[80]; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendItemBudgetEntry';
        TraceMode := SetTraceMode(pCompany);

        // ReqText := '<SendItems xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
        //             '<items>' +
        //              pInnerText +
        //             '</items>' +
        //           '</SendItems>';

        ReqText := '<SendItemBudgetEntry xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<pItemBudgetEntries>' +
                      pInnerText +
                     '</pItemBudgetEntries>' +
                   '</SendItemBudgetEntry>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure GetCustomerCreditLimit(pCompany: Text[80]; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        FieldNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
        recCustCredLimit: Record "Customer Credit Limited";
        recRHQCust: Record Customer;
        CustNo: Code[20];
        FieldText: Text;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetCustomerCreditLimit';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<GetCustomerCreditLimit xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<customers>' +
                       '<Customer xmlns="urn:microsoft-dynamics-nav/GetCreditLimit">' +
                         '<No />' +
                         '<Name />' +
                         '<Category />' +
                         '<Tier />' +
                         '<BalanceDueLCY>0</BalanceDueLCY>' +
                         '<BalanceDueEUR />' +
                         '<CreditLimitLCY>0</CreditLimitLCY>' +
                         '<CreditLimitEUR />' +
                         '<Blocked />' +
                         '<DivisionDim />' +
                         '<CountryDim />' +
                         '<CurrencyCode />' +
                         '<PaymentTerms />' +
                         '<CurrentExchangeRate />' +
                       '</Customer>' +
                     '</customers>' +
                     StrSubstNo('<zNetCompany>%1</zNetCompany>', ZGT.ConvertBooleanToTrueFalse(ZGT.IsZNetCompany, 2)) +
                   '</GetCustomerCreditLimit>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/GetCreditLimit');
            if ResponseXmlDoc.SelectNodes('//s:Customer', XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do begin
                    Clear(recCustCredLimit);
                    recRHQCust.SetAutocalcFields("Outst. Orders Sell-to (LCY)");
                    if WorkNode.SelectSingleNode('s:No', XMLNsMgr, FieldNode) then
                        CustNo := FieldNode.AsXmlElement().InnerXml();
                    if recRHQCust.Get(CustNo) then
                        recCustCredLimit."Cust. Only Created in Sub" := true
                    else
                        Clear(recRHQCust);

                    recCustCredLimit."Customer No." := CustNo;
                    recCustCredLimit.Company := pCompany;
                    if WorkNode.SelectSingleNode('s:Name', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Customer Name" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CreditLimitLCY', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Credit Limit Sub (LCY)" := EvaluateAmount(FieldNode.AsXmlElement().InnerXml());
                    if WorkNode.SelectSingleNode('s:BalanceDueLCY', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Balance Due Sub (LCY)" := EvaluateAmount(FieldNode.AsXmlElement().InnerXml());
                    if WorkNode.SelectSingleNode('s:CreditLimitEUR', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Credit Limit Sub (EUR)" := EvaluateAmount(FieldNode.AsXmlElement().InnerXml());
                    if WorkNode.SelectSingleNode('s:BalanceDueEUR', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Balance Due Sub (EUR)" := EvaluateAmount(FieldNode.AsXmlElement().InnerXml());
                    if WorkNode.SelectSingleNode('s:CurrencyCode', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Currency Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:DivisionDim', XMLNsMgr, FieldNode) then
                        recCustCredLimit.Division := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CountryDim', XMLNsMgr, FieldNode) then
                        recCustCredLimit.Country := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Blocked', XMLNsMgr, FieldNode) then
                        Evaluate(recCustCredLimit.Blocked, FieldNode.AsXmlElement().InnerXml());
                    if WorkNode.SelectSingleNode('s:Category', XMLNsMgr, FieldNode) then
                        Evaluate(recCustCredLimit.Category, FieldNode.AsXmlElement().InnerXml());
                    if WorkNode.SelectSingleNode('s:Tier', XMLNsMgr, FieldNode) then
                        recCustCredLimit.Tier := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:PaymentTerms', XMLNsMgr, FieldNode) then
                        recCustCredLimit."Payment Terms" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CurrentExchangeRate', XMLNsMgr, FieldNode) then begin
                        FieldText := FieldNode.AsXmlElement().InnerXml();
                        if FieldText <> '' then
                            recCustCredLimit."Current Exchange Rate" := EvaluateAmount(FieldText);
                    end;

                    recCustCredLimit."Outstanding Orders RHQ (LCY)" := recRHQCust."Outst. Orders Sell-to (LCY)";
                    //recCustCredLimit."Balance Due + Outstanding LCY" := recCustCredLimit."Balance Due Sub (LCY)" + recCustCredLimit."Outstanding Orders RHQ (LCY)";
                    recCustCredLimit."Balance Due + Outstanding EUR" := recCustCredLimit."Balance Due Sub (EUR)" + recRHQCust."Outst. Orders Sell-to (LCY)";

                    recCustCredLimit.Status := recCustCredLimit.Status::OK;
                    if (recCustCredLimit."Balance Due Sub (LCY)" + recCustCredLimit."Outstanding Orders RHQ (LCY)") > recCustCredLimit."Credit Limit Sub (LCY)" then
                        recCustCredLimit.Status := recCustCredLimit.Status::Investigate;
                    if recCustCredLimit."Balance Due Sub (LCY)" > recCustCredLimit."Credit Limit Sub (LCY)" then
                        recCustCredLimit.Status := recCustCredLimit.Status::Warning;
                    recCustCredLimit.Insert;
                end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    procedure GetCustomerCreditLimitOLD(pCompany: Text[80]; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
        recCustCredLimit: Record "Customer Credit Limited";
        recRHQCust: Record Customer;
        CustNo: Code[20];
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetCustomerCreditLimit';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<GetCustomerCreditLimit xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<customers>' +
                       '<Customer xmlns="urn:microsoft-dynamics-nav/GetCreditLimit">' +
                         '<No />' +
                         '<Name />' +
                         '<Category />' +
                         '<Tier />' +
                         '<BalanceDueLCY>0</BalanceDueLCY>' +
                         '<BalanceDueEUR />' +
                         '<CreditLimitLCY>0</CreditLimitLCY>' +
                         '<CreditLimitEUR />' +
                         '<Blocked />' +
                         '<DivisionDim />' +
                         '<CountryDim />' +
                         '<CurrencyCode />' +
                         '<PaymentTerms />' +
                         '<CurrentExchangeRate />' +
                       '</Customer>' +
                     '</customers>' +
                     StrSubstNo('<zNetCompany>%1</zNetCompany>', ZGT.ConvertBooleanToTrueFalse(ZGT.IsZNetCompany, 2)) +
                   '</GetCustomerCreditLimit>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);

            //  MESSAGE(COPYSTR(ResponseXmlDoc.OuterXml,1,1024));
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/GetCreditLimit');  //   recWebServiceSetup.GetSoapAction('',GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1', 'Customer', WsFunctionName), XMLNsMgr);
            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Clear(recCustCredLimit);
                recRHQCust.SetAutocalcFields("Outst. Orders Sell-to (LCY)");
                CustNo := WorkNode.SelectSingleNode('s:No', XMLNsMgr).InnerText;
                if recRHQCust.Get(CustNo) then
                    recCustCredLimit."Cust. Only Created in Sub" := true
                else
                    Clear(recRHQCust);

                recCustCredLimit."Customer No." := WorkNode.SelectSingleNode('s:No', XMLNsMgr).InnerText;
                recCustCredLimit.Company := pCompany;
                recCustCredLimit."Customer Name" := WorkNode.SelectSingleNode('s:Name', XMLNsMgr).InnerText;
                recCustCredLimit."Credit Limit Sub (LCY)" := EvaluateAmount(WorkNode.SelectSingleNode('s:CreditLimitLCY', XMLNsMgr).InnerText);
                recCustCredLimit."Balance Due Sub (LCY)" := EvaluateAmount(WorkNode.SelectSingleNode('s:BalanceDueLCY', XMLNsMgr).InnerText);
                recCustCredLimit."Credit Limit Sub (EUR)" := EvaluateAmount(WorkNode.SelectSingleNode('s:CreditLimitEUR', XMLNsMgr).InnerText);
                recCustCredLimit."Balance Due Sub (EUR)" := EvaluateAmount(WorkNode.SelectSingleNode('s:BalanceDueEUR', XMLNsMgr).InnerText);
                recCustCredLimit."Currency Code" := WorkNode.SelectSingleNode('s:CurrencyCode', XMLNsMgr).InnerText;
                recCustCredLimit.Division := WorkNode.SelectSingleNode('s:DivisionDim', XMLNsMgr).InnerText;
                recCustCredLimit.Country := WorkNode.SelectSingleNode('s:CountryDim', XMLNsMgr).InnerText;
                Evaluate(recCustCredLimit.Blocked, WorkNode.SelectSingleNode('s:Blocked', XMLNsMgr).InnerText);
                Evaluate(recCustCredLimit.Category, WorkNode.SelectSingleNode('s:Category', XMLNsMgr).InnerText);
                recCustCredLimit.Tier := WorkNode.SelectSingleNode('s:Tier', XMLNsMgr).InnerText;
                recCustCredLimit."Payment Terms" := WorkNode.SelectSingleNode('s:PaymentTerms', XMLNsMgr).InnerText;
                if WorkNode.SelectSingleNode('s:CurrentExchangeRate', XMLNsMgr).InnerText <> '' then
                    recCustCredLimit."Current Exchange Rate" := EvaluateAmount(WorkNode.SelectSingleNode('s:CurrentExchangeRate', XMLNsMgr).InnerText);

                recCustCredLimit."Outstanding Orders RHQ (LCY)" := recRHQCust."Outst. Orders Sell-to (LCY)";
                //recCustCredLimit."Balance Due + Outstanding LCY" := recCustCredLimit."Balance Due Sub (LCY)" + recCustCredLimit."Outstanding Orders RHQ (LCY)";
                recCustCredLimit."Balance Due + Outstanding EUR" := recCustCredLimit."Balance Due Sub (EUR)" + recRHQCust."Outst. Orders Sell-to (LCY)";

                recCustCredLimit.Status := recCustCredLimit.Status::OK;
                if (recCustCredLimit."Balance Due Sub (LCY)" + recCustCredLimit."Outstanding Orders RHQ (LCY)") > recCustCredLimit."Credit Limit Sub (LCY)" then
                    recCustCredLimit.Status := recCustCredLimit.Status::Investigate;
                if recCustCredLimit."Balance Due Sub (LCY)" > recCustCredLimit."Credit Limit Sub (LCY)" then
                    recCustCredLimit.Status := recCustCredLimit.Status::Warning;
                recCustCredLimit.Insert;

            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure GetAccountPay_Receivable(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; var AccPayBuff: Record "Account Pay./Receiv Buffer" temporary) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        FieldNode: XmlNode;
        TraceMode: Boolean;
        NextEntryNo: Integer;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := pWsFunctionName;
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                      StrSubstNo('<%1>', pWsHeader) +
                        pInnerText +
                      StrSubstNo('</%1>', pWsHeader) +
                    StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/acc');

            if AccPayBuff.FindLast then
                NextEntryNo := AccPayBuff."Entry No.";

            if ResponseXmlDoc.SelectNodes('//s:Account', XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do begin
                    NextEntryNo += 1;
                    Clear(AccPayBuff);
                    AccPayBuff.Init;
                    AccPayBuff."Entry No." := NextEntryNo;
                    if WorkNode.SelectSingleNode('s:CompanyName', XMLNsMgr, FieldNode) then
                        AccPayBuff."Company Name" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:HQCompanyName', XMLNsMgr, FieldNode) then
                        AccPayBuff."HQ Company Name" := FieldNode.AsXmlElement().InnerXml();  // 15-08-22 ZY-LD 004
                    if WorkNode.SelectSingleNode('s:HQAccountNo', XMLNsMgr, FieldNode) then
                        AccPayBuff."HQ Account No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:HQAccountName', XMLNsMgr, FieldNode) then
                        AccPayBuff."HQ Account Name" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:GLAccountNo', XMLNsMgr, FieldNode) then
                        AccPayBuff."G/L Account No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:GLAccountName', XMLNsMgr, FieldNode) then
                        AccPayBuff."G/L Account Name" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:SourceNo', XMLNsMgr, FieldNode) then
                        AccPayBuff."Source No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:SourceName', XMLNsMgr, FieldNode) then
                        AccPayBuff."Source Name" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CreditLimit', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."Credit Limit", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:Division', XMLNsMgr, FieldNode) then
                        AccPayBuff.Division := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:PaymentTerms', XMLNsMgr, FieldNode) then
                        AccPayBuff."Payment Terms" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:InvoiceNo', XMLNsMgr, FieldNode) then
                        AccPayBuff."Invoice No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:VendorInvoiceNo', XMLNsMgr, FieldNode) then
                        AccPayBuff."Vendor Invoice No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:PostingDate', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."Posting Date", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:DocumentDate', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."Document Date", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:DueDate', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."Due Date", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:ClosedAtDate', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."Closed at Date", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:TxnCurrenyCode', XMLNsMgr, FieldNode) then
                        AccPayBuff."TXN Currency Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:TxnAmount', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."TXN Amount", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:TxnEndingBalance', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."TXN Ending Balance", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:LcyCurrencyCode', XMLNsMgr, FieldNode) then
                        AccPayBuff."LCY Currency Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:LcyAmount', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."LCY Amount", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:LcyEndingBalance', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."LCY Ending Balance", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:RptCurrencyCode', XMLNsMgr, FieldNode) then
                        AccPayBuff."RPT Currency Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:RptAmount', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."RPT Amount", FieldNode.AsXmlElement().InnerXml(), 9);
                    if WorkNode.SelectSingleNode('s:RptEndingBalance', XMLNsMgr, FieldNode) then
                        Evaluate(AccPayBuff."RPT Ending Balance", FieldNode.AsXmlElement().InnerXml(), 9);
                    AccPayBuff.Insert(true);
                end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure GetAccountPay_ReceivableOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; var AccPayBuff: Record "Account Pay./Receiv Buffer" temporary) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
        NextEntryNo: Integer;
        WSAccountPayable: XmlPort "WS Account Pay./Receiv";
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := pWsFunctionName;
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                      StrSubstNo('<%1>', pWsHeader) +
                        pInnerText +
                      StrSubstNo('</%1>', pWsHeader) +
                    StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //WSAccountPayable.SETSOURCE(RespBodyInStream);
            //WSAccountPayable.IMPORT;

            //MESSAGE(COPYSTR(ResponseXmlDoc.OuterXml,1,1024));
            /*ServerFilename := FileMgt.ServerTempFileName('');
            ClientFilename := FileMgt.ClientTempFileName('xml');
            ResponseXmlDoc.Save(ServerFilename);
            FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            HYPERLINK(ClientFilename);*/

            if AccPayBuff.FindLast then
                NextEntryNo := AccPayBuff."Entry No.";

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/acc');  //   recWebServiceSetup.GetSoapAction('',GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1', 'Account', WsFunctionName), XMLNsMgr);
            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);

                NextEntryNo += 1;
                Clear(AccPayBuff);
                AccPayBuff.Init;
                AccPayBuff."Entry No." := NextEntryNo;
                AccPayBuff."Company Name" := WorkNode.SelectSingleNode('s:CompanyName', XMLNsMgr).InnerText;
                AccPayBuff."HQ Company Name" := WorkNode.SelectSingleNode('s:HQCompanyName', XMLNsMgr).InnerText;  // 15-08-22 ZY-LD 004
                AccPayBuff."HQ Account No." := WorkNode.SelectSingleNode('s:HQAccountNo', XMLNsMgr).InnerText;
                AccPayBuff."HQ Account Name" := WorkNode.SelectSingleNode('s:HQAccountName', XMLNsMgr).InnerText;
                AccPayBuff."G/L Account No." := WorkNode.SelectSingleNode('s:GLAccountNo', XMLNsMgr).InnerText;
                AccPayBuff."G/L Account Name" := WorkNode.SelectSingleNode('s:GLAccountName', XMLNsMgr).InnerText;
                AccPayBuff."Source No." := WorkNode.SelectSingleNode('s:SourceNo', XMLNsMgr).InnerText;
                AccPayBuff."Source Name" := WorkNode.SelectSingleNode('s:SourceName', XMLNsMgr).InnerText;
                Evaluate(AccPayBuff."Credit Limit", WorkNode.SelectSingleNode('s:CreditLimit', XMLNsMgr).InnerText, 9);
                AccPayBuff.Division := WorkNode.SelectSingleNode('s:Division', XMLNsMgr).InnerText;
                AccPayBuff."Payment Terms" := WorkNode.SelectSingleNode('s:PaymentTerms', XMLNsMgr).InnerText;
                AccPayBuff."Invoice No." := WorkNode.SelectSingleNode('s:InvoiceNo', XMLNsMgr).InnerText;
                AccPayBuff."Vendor Invoice No." := WorkNode.SelectSingleNode('s:VendorInvoiceNo', XMLNsMgr).InnerText;
                Evaluate(AccPayBuff."Posting Date", WorkNode.SelectSingleNode('s:PostingDate', XMLNsMgr).InnerText, 9);
                Evaluate(AccPayBuff."Document Date", WorkNode.SelectSingleNode('s:DocumentDate', XMLNsMgr).InnerText, 9);
                Evaluate(AccPayBuff."Due Date", WorkNode.SelectSingleNode('s:DueDate', XMLNsMgr).InnerText, 9);
                Evaluate(AccPayBuff."Closed at Date", WorkNode.SelectSingleNode('s:ClosedAtDate', XMLNsMgr).InnerText, 9);
                AccPayBuff."TXN Currency Code" := WorkNode.SelectSingleNode('s:TxnCurrenyCode', XMLNsMgr).InnerText;
                Evaluate(AccPayBuff."TXN Amount", WorkNode.SelectSingleNode('s:TxnAmount', XMLNsMgr).InnerText, 9);
                Evaluate(AccPayBuff."TXN Ending Balance", WorkNode.SelectSingleNode('s:TxnEndingBalance', XMLNsMgr).InnerText, 9);
                AccPayBuff."LCY Currency Code" := WorkNode.SelectSingleNode('s:LcyCurrencyCode', XMLNsMgr).InnerText;
                Evaluate(AccPayBuff."LCY Amount", WorkNode.SelectSingleNode('s:LcyAmount', XMLNsMgr).InnerText, 9);
                Evaluate(AccPayBuff."LCY Ending Balance", WorkNode.SelectSingleNode('s:LcyEndingBalance', XMLNsMgr).InnerText, 9);
                AccPayBuff."RPT Currency Code" := WorkNode.SelectSingleNode('s:RptCurrencyCode', XMLNsMgr).InnerText;
                Evaluate(AccPayBuff."RPT Amount", WorkNode.SelectSingleNode('s:RptAmount', XMLNsMgr).InnerText, 9);
                Evaluate(AccPayBuff."RPT Ending Balance", WorkNode.SelectSingleNode('s:RptEndingBalance', XMLNsMgr).InnerText, 9);
                AccPayBuff.Insert(true);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);

    end;

    //CLOUD READY DELETE
    /*procedure GetSalesInvoiceNo(pCompany: Text[80]; var pSalesInvNo: Code[20]) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        //>> 11-04-19 ZY-LD 001
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetSalesInvoiceNo';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<GetSalesInvoiceNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<pSalesInvNo>%1</pSalesInvNo>', pSalesInvNo) +
                   '</GetSalesInvoiceNo>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
        //<< 11-04-19 ZY-LD 001
    end; */


    procedure GetSalesInvoiceNoOLD(pCompany: Text[80]; var pSalesInvNo: Code[20]) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
        recCustCredLimit: Record "Customer Credit Limited";
        recRHQCust: Record Customer;
    begin
        // CLOUD READY DELETE
        //>> 11-04-19 ZY-LD 001
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetSalesInvoiceNo';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<GetSalesInvoiceNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<pSalesInvNo>%1</pSalesInvNo>', pSalesInvNo) +
                   '</GetSalesInvoiceNo>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);

            //  MESSAGE(COPYSTR(ResponseXmlDoc.OuterXml,1,1024));
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
        //<< 11-04-19 ZY-LD 001
    end;


    procedure GetExchangeInfo(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; var pCurrExchRateBuf: Record "Currency Exchange Rate Buffer" temporary)
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        FieldNode: XmlNode;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/exchrate');
            if ResponseXmlDoc.SelectNodes('//s:ExchangeRate', XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do begin
                    if WorkNode.SelectSingleNode('s:Company', XMLNsMgr, FieldNode) then
                        pCurrExchRateBuf.Company := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CurrencyCode', XMLNsMgr, FieldNode) then
                        pCurrExchRateBuf."Currency Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:LCYCode', XMLNsMgr, FieldNode) then
                        pCurrExchRateBuf."LCY Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:ExchangeRangeAmount', XMLNsMgr, FieldNode) then
                        Evaluate(pCurrExchRateBuf."Exchange Rate Amount", FieldNode.AsXmlElement().InnerXml(), 9);
                    pCurrExchRateBuf.Insert;
                end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure GetExchangeInfoOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; var pCurrExchRateBuf: Record "Currency Exchange Rate Buffer" temporary)
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/exchrate');  //   recWebServiceSetup.GetSoapAction('',GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1', 'ExchangeRate', pWsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);

                pCurrExchRateBuf.Company := WorkNode.SelectSingleNode('s:Company', XMLNsMgr).InnerText;
                pCurrExchRateBuf."Currency Code" := WorkNode.SelectSingleNode('s:CurrencyCode', XMLNsMgr).InnerText;
                pCurrExchRateBuf."LCY Code" := WorkNode.SelectSingleNode('s:LCYCode', XMLNsMgr).InnerText;
                Evaluate(pCurrExchRateBuf."Exchange Rate Amount", WorkNode.SelectSingleNode('s:ExchangeRangeAmount', XMLNsMgr).InnerText, 9);
                pCurrExchRateBuf.Insert;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure GetConcurVendor(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; var pVendTmp: Record Vendor temporary; pVendorNo: Code[20])
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        FieldNode: XmlNode;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<vendorNo>%1</vendorNo>', pVendorNo) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/concurvendor');
            if ResponseXmlDoc.SelectNodes('//s:Vendor', XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do begin
                    if WorkNode.SelectSingleNode('s:No', XMLNsMgr, FieldNode) then
                        pVendTmp."No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Name', XMLNsMgr, FieldNode) then
                        pVendTmp.Name := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Name2', XMLNsMgr, FieldNode) then
                        pVendTmp."Name 2" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Address', XMLNsMgr, FieldNode) then
                        pVendTmp.Address := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Address2', XMLNsMgr, FieldNode) then
                        pVendTmp."Address 2" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:PostCode', XMLNsMgr, FieldNode) then
                        pVendTmp."Post Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:City', XMLNsMgr, FieldNode) then
                        pVendTmp.City := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Country', XMLNsMgr, FieldNode) then
                        pVendTmp."Country/Region Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Contact', XMLNsMgr, FieldNode) then
                        pVendTmp.Contact := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CurrencyCode', XMLNsMgr, FieldNode) then
                        pVendTmp."Currency Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:VatRegNo', XMLNsMgr, FieldNode) then
                        pVendTmp."VAT Registration No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:VatRegNoZyxel', XMLNsMgr, FieldNode) then
                        pVendTmp."FTP Code Normal" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:PaymentTerms', XMLNsMgr, FieldNode) then
                        pVendTmp."Payment Terms Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:DivisionCode', XMLNsMgr, FieldNode) then
                        pVendTmp."Global Dimension 1 Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:DepartmentCode', XMLNsMgr, FieldNode) then
                        pVendTmp."Global Dimension 2 Code" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:CountryCode', XMLNsMgr, FieldNode) then
                        pVendTmp."Creditor No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:PhoneNo', XMLNsMgr, FieldNode) then
                        pVendTmp."Phone No." := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Email', XMLNsMgr, FieldNode) then
                        pVendTmp."E-Mail" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:GenBusPostGrp', XMLNsMgr, FieldNode) then
                        pVendTmp."Gen. Bus. Posting Group" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:VatBusPostGrp', XMLNsMgr, FieldNode) then
                        pVendTmp."VAT Bus. Posting Group" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:VendPostGrp', XMLNsMgr, FieldNode) then
                        pVendTmp."Vendor Posting Group" := FieldNode.AsXmlElement().InnerXml();
                    if WorkNode.SelectSingleNode('s:Blocked', XMLNsMgr, FieldNode) then
                        Evaluate(pVendTmp.Blocked, FieldNode.AsXmlElement().InnerXml());
                    pVendTmp.Insert;
                end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure GetConcurVendorOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; var pVendTmp: Record Vendor temporary; pVendorNo: Code[20])
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<vendorNo>%1</vendorNo>', pVendorNo) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', 'urn:microsoft-dynamics-nav/concurvendor');  //   recWebServiceSetup.GetSoapAction('',GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1', 'Vendor', pWsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);

                pVendTmp."No." := WorkNode.SelectSingleNode('s:No', XMLNsMgr).InnerText;
                pVendTmp.Name := WorkNode.SelectSingleNode('s:Name', XMLNsMgr).InnerText;
                pVendTmp."Name 2" := WorkNode.SelectSingleNode('s:Name2', XMLNsMgr).InnerText;
                pVendTmp.Address := WorkNode.SelectSingleNode('s:Address', XMLNsMgr).InnerText;
                pVendTmp."Address 2" := WorkNode.SelectSingleNode('s:Address2', XMLNsMgr).InnerText;
                pVendTmp."Post Code" := WorkNode.SelectSingleNode('s:PostCode', XMLNsMgr).InnerText;
                pVendTmp.City := WorkNode.SelectSingleNode('s:City', XMLNsMgr).InnerText;
                pVendTmp."Country/Region Code" := WorkNode.SelectSingleNode('s:Country', XMLNsMgr).InnerText;
                pVendTmp.Contact := WorkNode.SelectSingleNode('s:Contact', XMLNsMgr).InnerText;
                pVendTmp."Currency Code" := WorkNode.SelectSingleNode('s:CurrencyCode', XMLNsMgr).InnerText;
                pVendTmp."VAT Registration No." := WorkNode.SelectSingleNode('s:VatRegNo', XMLNsMgr).InnerText;
                pVendTmp."FTP Code Normal" := WorkNode.SelectSingleNode('s:VatRegNoZyxel', XMLNsMgr).InnerText;
                pVendTmp."Payment Terms Code" := WorkNode.SelectSingleNode('s:PaymentTerms', XMLNsMgr).InnerText;
                pVendTmp."Global Dimension 1 Code" := WorkNode.SelectSingleNode('s:DivisionCode', XMLNsMgr).InnerText;
                pVendTmp."Global Dimension 2 Code" := WorkNode.SelectSingleNode('s:DepartmentCode', XMLNsMgr).InnerText;
                pVendTmp."Creditor No." := WorkNode.SelectSingleNode('s:CountryCode', XMLNsMgr).InnerText;
                pVendTmp."Phone No." := WorkNode.SelectSingleNode('s:PhoneNo', XMLNsMgr).InnerText;
                pVendTmp."E-Mail" := WorkNode.SelectSingleNode('s:Email', XMLNsMgr).InnerText;
                pVendTmp."Gen. Bus. Posting Group" := WorkNode.SelectSingleNode('s:GenBusPostGrp', XMLNsMgr).InnerText;
                pVendTmp."VAT Bus. Posting Group" := WorkNode.SelectSingleNode('s:VatBusPostGrp', XMLNsMgr).InnerText;
                pVendTmp."Vendor Posting Group" := WorkNode.SelectSingleNode('s:VendPostGrp', XMLNsMgr).InnerText;
                Evaluate(pVendTmp.Blocked, WorkNode.SelectSingleNode('s:Blocked', XMLNsMgr).InnerText);
                pVendTmp.Insert;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendSalesInvoiceNo(pCompany: Text[80]; pRHQSalesInvNo: Code[20]; pSubSalesInvNo: Code[20]) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        //>> 11-04-19 ZY-LD 001
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendSalesInvoiceNo';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesInvoiceNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<pRHQSalesInvNo>%1</pRHQSalesInvNo>', pRHQSalesInvNo) +
                     StrSubstNo('<pSubSalesInvNo>%1</pSubSalesInvNo>', pSubSalesInvNo) +
                   '</SendSalesInvoiceNo>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
        //<< 11-04-19 ZY-LD 001
    end;


    procedure SendSalesInvoiceNoOLD(pCompany: Text[80]; pRHQSalesInvNo: Code[20]; pSubSalesInvNo: Code[20]) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
        recCustCredLimit: Record "Customer Credit Limited";
        recRHQCust: Record Customer;
    begin
        // CLOUD READY DELETE
        //>> 11-04-19 ZY-LD 001
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendSalesInvoiceNo';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesInvoiceNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<pRHQSalesInvNo>%1</pRHQSalesInvNo>', pRHQSalesInvNo) +
                     StrSubstNo('<pSubSalesInvNo>%1</pSubSalesInvNo>', pSubSalesInvNo) +
                   '</SendSalesInvoiceNo>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);

            //  MESSAGE(COPYSTR(ResponseXmlDoc.OuterXml,1,1024));
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
        //<< 11-04-19 ZY-LD 001
    end;


    procedure SendPurchaseOrder(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesOrders xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<salesOrders>' +
                      pInnerText +
                     '</salesOrders>' +
                   '</SendSalesOrders>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure SendPurchaseOrderOLD(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesOrders xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<salesOrders>' +
                      pInnerText +
                     '</salesOrders>' +
                   '</SendSalesOrders>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure SendUnshippedQuantity(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendUnshippedQuantity';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendUnshippedQuantity xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<unshippedQuantitys>' +
                      pInnerText +
                     '</unshippedQuantitys>' +
                   '</SendUnshippedQuantity>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure SendUnshippedQuantityOLD(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendUnshippedQuantity';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendUnshippedQuantity xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<unshippedQuantitys>' +
                      pInnerText +
                     '</unshippedQuantitys>' +
                   '</SendUnshippedQuantity>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure SendContainerDetails(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendContainerDetail';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendContainerDetail xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<containerDetails>' +
                      pInnerText +
                     '</containerDetails>' +
                   '</SendContainerDetail>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure SendContainerDetailsOLD(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendContainerDetail';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendContainerDetail xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<containerDetails>' +
                      pInnerText +
                     '</containerDetails>' +
                   '</SendContainerDetail>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := '';
        Password := '';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;

    // CLOUD READY DELETE
    /*procedure SendSalesOrderFrance(pCompany: Text[80]; pInnerXml: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        //Url := recWebServiceSetup.GetWsUrl(GetSetupCode,pCompany,GetWebServiceNo);
        Url := 'https://zyeu-navws01.zyeu.zyxel.eu:7447/ZyWebServiceTest/WS/ZNet DK/Codeunit/ZyWS';
        WsFunctionName := 'SendSalesOrdersFrance';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesOrdersFrance xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<salesOrdersFR>' +
                     pInnerXml +
                     '</salesOrdersFR>' +
                   '</SendSalesOrdersFrance>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        //WebServReqMgt.SetGlobalsZyxel(recWebServiceSetup.GetContentType,recWebServiceSetup.GetSoapAction(WsFunctionName,CodeunitNo));
        WebServReqMgt.SetContentType('application/xml; chartset=utf-8');
        WebServReqMgt.SetAction(StrSubstNo('urn:microsoft-dynamics-schemas/codeunit/%1:%2', 'ZyWS', WsFunctionName));

        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            //XMLNsMgr.AddNamespace('s',recWebServiceSetup.GetSoapAction('',CodeunitNo));
            XMLNsMgr.AddNamespace('s', StrSubstNo('urn:microsoft-dynamics-schemas/codeunit/%1', 'ZyWS'));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;*/


    procedure SendSalesOrderFranceOLD(pCompany: Text[80]; pInnerXml: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CodeunitNo: Integer;
    begin
        // CLOUD READY DELETE
        //Url := recWebServiceSetup.GetWsUrl(GetSetupCode,pCompany,GetWebServiceNo);
        Url := 'https://zyeu-navws01.zyeu.zyxel.eu:7447/ZyWebServiceTest/WS/ZNet DK/Codeunit/ZyWS';
        WsFunctionName := 'SendSalesOrdersFrance';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesOrdersFrance xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<salesOrdersFR>' +
                     pInnerXml +
                     '</salesOrdersFR>' +
                   '</SendSalesOrdersFrance>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        //WebServReqMgt.SetGlobalsZyxel(recWebServiceSetup.GetContentType,recWebServiceSetup.GetSoapAction(WsFunctionName,CodeunitNo));
        WebServReqMgt.SetContentType('application/xml; chartset=utf-8');
        WebServReqMgt.SetAction(StrSubstNo('urn:microsoft-dynamics-schemas/codeunit/%1:%2', 'ZyWS', WsFunctionName));

        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            //XMLNsMgr.AddNamespace('s',recWebServiceSetup.GetSoapAction('',CodeunitNo));
            XMLNsMgr.AddNamespace('s', StrSubstNo('urn:microsoft-dynamics-schemas/codeunit/%1', 'ZyWS'));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendRequestBoolean(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; pTopHeader: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        if pWsHeader <> '' then begin
            if pTopHeader <> '' then
                ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                             pTopHeader +
                             StrSubstNo('<%1>', pWsHeader) +
                               pInnerText +
                             StrSubstNo('</%1>', pWsHeader) +
                           StrSubstNo('</%1>', pWsFunctionName)
            else
                ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                             StrSubstNo('<%1>', pWsHeader) +
                               pInnerText +
                             StrSubstNo('</%1>', pWsHeader) +
                           StrSubstNo('</%1>', pWsFunctionName)
        end else
            ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                         pInnerText +
                       StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendRequestBooleanOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text; pTopHeader: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        if pWsHeader <> '' then begin
            if pTopHeader <> '' then
                ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                             pTopHeader +
                             StrSubstNo('<%1>', pWsHeader) +
                               pInnerText +
                             StrSubstNo('</%1>', pWsHeader) +
                           StrSubstNo('</%1>', pWsFunctionName)
            else
                ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                             StrSubstNo('<%1>', pWsHeader) +
                               pInnerText +
                             StrSubstNo('</%1>', pWsHeader) +
                           StrSubstNo('</%1>', pWsFunctionName)
        end else
            ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                         pInnerText +
                       StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;

    // CLOUD READY DELETE
    /*
    procedure SendRequestText(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendRequestTextOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end; */


    procedure SendRequestDecimal(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text) rValue: Decimal
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        // Username := 'navservice';
        // Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml(), 9);
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendRequestDecimalOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text) rValue: Decimal
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        // Username := 'navservice';
        // Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText, 9);
                //rValue := ZGT.ValidateXmlFormattedAmount(WorkNode.SelectSingleNode('s:return_value',XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendRequestDecimalText(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        // Username := 'navservice';
        // Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure SendRequestDecimalTextOLD(pCompany: Text[80]; pWsFunctionName: Text; pWsHeader: Text; pInnerText: Text) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        //WsFunctionName := 'SendSalesOrders';
        TraceMode := SetTraceMode(pCompany);

        ReqText := StrSubstNo('<%1 xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">', pWsFunctionName) +
                     StrSubstNo('<%1>', pWsHeader) +
                      pInnerText +
                     StrSubstNo('</%1>', pWsHeader) +
                   StrSubstNo('</%1>', pWsFunctionName);

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        // Username := 'navservice';
        // Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(pWsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', pWsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure OutboxSalesHdrToInbox()
    begin
    end;


    procedure SendPurchasePrice(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendPurchasePrice';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendPurchasePrice xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<purchsePrices>' +
                      pInnerText +
                     '</purchsePrices>' +
                   '</SendPurchasePrice>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        //Username := 'navservice';
        //Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure SendPurchasePriceOLD(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendPurchasePrice';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendPurchasePrice xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<purchsePrices>' +
                      pInnerText +
                     '</purchsePrices>' +
                   '</SendPurchasePrice>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        //Username := 'navservice';
        //Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;


    procedure SendSalesPrice(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendSalesPrice';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesPrice xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<salesPrices>' +
                      pInnerText +
                     '</salesPrices>' +
                   '</SendSalesPrice>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        //Username := 'navservice';
        //Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        Evaluate(rValue, ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure SendSalesPriceOLD(pCompany: Text[80]; pInnerText: Text) rValue: Boolean
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'SendSalesPrice';
        TraceMode := SetTraceMode(pCompany);

        ReqText := '<SendSalesPrice xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     '<salesPrices>' +
                      pInnerText +
                     '</salesPrices>' +
                   '</SendSalesPrice>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        //Username := 'navservice';
        //Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                Evaluate(rValue, WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;

    local procedure GetSetupCode(): Code[2]
    begin
        exit('ZY');
    end;

    local procedure GetWebServiceNo(): Integer
    begin
        exit(50082);
    end;


    procedure ICPartnerExistsInSub(pCompany: Text[80]; pICPartnerCode: Code[20]) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetICVendorNo';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<GetICVendorNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<iCPartnerCode>%1</iCPartnerCode>', pICPartnerCode) +
                   '</GetICVendorNo>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := 'navservice';
        Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := ReturnValueNode.AsXmlElement().InnerXml();
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end;


    procedure ICPartnerExistsInSubOLD(pCompany: Text[80]; pICPartnerCode: Code[20]) rValue: Text
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetICVendorNo';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<GetICVendorNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<iCPartnerCode>%1</iCPartnerCode>', pICPartnerCode) +
                   '</GetICVendorNo>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := 'navservice';
        Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;

    //CLOUD READY DELETE
    /*
    procedure GetCustomerOverdueBalance(pCompany: Text[80]; pCustNo: Code[20]; pDueDate: Date; pShowOpenPayments: Boolean) rValue: Decimal
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: XmlNamespaceManager;
        WorkNodes: XmlNodeList;
        WorkNode: XmlNode;
        ReturnValueNode: XmlNode;
        WsFunctionName: Text;
        TraceMode: Boolean;
    begin
        // CLOUD READY NEW
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetCustomerBalance';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<GetCustomerBalance xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<custNo>%1</custNo>', pCustNo) +
                     StrSubstNo('<dueDate>%1</dueDate>', Format(pDueDate, 0, 9)) +
                     StrSubstNo('<showOpenPayments>%1</showOpenPayments>', Format(pShowOpenPayments, 0, 9)) +
                   '</GetCustomerBalance>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := 'navservice';
        Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            XmlDocument.ReadFrom(RespBodyInStream, ResponseXmlDoc);
            XMLNsMgr.NameTable(ResponseXmlDoc.NameTable());
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            if ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr, WorkNodes) then
                foreach WorkNode in WorkNodes do
                    if WorkNode.SelectSingleNode('s:return_value', XMLNsMgr, ReturnValueNode) then
                        rValue := EvaluateAmount(ReturnValueNode.AsXmlElement().InnerXml());
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

    end; */


    procedure GetCustomerOverdueBalanceOLD(pCompany: Text[80]; pCustNo: Code[20]; pDueDate: Date; pShowOpenPayments: Boolean) rValue: Decimal
    var
        recWebServiceSetup: Record "Web Service Setup";
        WebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseInStream: InStream;
        ReqBodyInStream: InStream;
        ReqBodyOutStream: OutStream;
        RespBodyInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Url: Text;
        ReqText: Text;
        Username: Text;
        Password: Text;
        WebServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        ResponseXmlDoc: dotnet XmlDocument;
        ErrorTxt: Text;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        i: Integer;
        WsFunctionName: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgt: Codeunit "File Management";
        TraceMode: Boolean;
        CurDT: DateTime;
    begin
        // CLOUD READY DELETE
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetCustomerBalance';  // Change here
        TraceMode := SetTraceMode(pCompany);

        // Change here
        ReqText := '<GetCustomerBalance xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyWS">' +
                     StrSubstNo('<custNo>%1</custNo>', pCustNo) +
                     StrSubstNo('<dueDate>%1</dueDate>', Format(pDueDate, 0, 9)) +
                     StrSubstNo('<showOpenPayments>%1</showOpenPayments>', Format(pShowOpenPayments, 0, 9)) +
                   '</GetCustomerBalance>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        Username := 'navservice';
        Password := 'NGsGcv2fB+DYGead';
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, GetWebServiceNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        //CurDT := CURRENTDATETIME;
        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            //  ServerFilename := FileMgt.ServerTempFileName('');
            //  ClientFilename := FileMgt.ClientTempFileName('xml');
            //  ResponseXmlDoc.Save(ServerFilename);
            //  FileMgt.DownloadToFile(ServerFilename,ClientFilename);
            //  HYPERLINK(ClientFilename);

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', GetWebServiceNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                //EVALUATE(rValue,WorkNode.SelectSingleNode('s:return_value',XMLNsMgr).InnerText);  // 24-02-20 ZY-LD 003
                rValue := EvaluateAmount(WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText);  // 24-02-20 ZY-LD 003
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;

        //MESSAGE('Time: %1',CURRENTDATETIME - CurDT);
    end;

    local procedure EvaluateAmount(pAmount: Text) rValue: Decimal
    begin
        if pAmount = '' then
            pAmount := '0';
        pAmount := ConvertStr(pAmount, '.', ',');
        if not Evaluate(rValue, pAmount) then begin
            pAmount := ConvertStr(pAmount, ',', '.');
            Evaluate(rValue, pAmount);
        end;
    end;

    local procedure SetTraceMode(pCompany: Text[80]): Boolean
    var
        recWebServSetup: Record "Web Service Setup";
    begin
        //>> 30-04-19 ZY-LD 002
        if recWebServSetup.Get(recWebServSetup.GetWebServerSetupCode(GetSetupCode), pCompany) and recWebServSetup."Trace Mode" then
            if Today > recWebServSetup."Trace Mode Date" then begin
                recWebServSetup."Trace Mode" := false;
                recWebServSetup.Modify;
            end;

        exit(recWebServSetup."Trace Mode");
        //<< 30-04-19 ZY-LD 002
    end;
}
