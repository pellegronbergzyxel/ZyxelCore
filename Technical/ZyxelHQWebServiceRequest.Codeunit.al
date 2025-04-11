Codeunit 50078 "Zyxel HQ Web Service Request"
{

    trigger OnRun()
    begin
        SendCountryOfOrigin('ZyND UK');
    end;

    var
        WebServiceName: Text;
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SendCountryOfOrigin(pCompany: Text[80]) rValue: Text
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
        CodeunitNo := 50076;
        //recWebServiceSetup.GET;
        Url := recWebServiceSetup.GetWsUrl('HQ', pCompany, CodeunitNo);
        WsFunctionName := 'SendCountryOfOrigin';
        TraceMode := true;

        ReqText := '<SendCountryOfOrigin xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyHQ">' +
                   '  <countryOfOrigins>' +
                   '    <CountryOfOrigin xmlns="urn:microsoft-dynamics-nav/coo">' +
                   '      <ItemNo>xxx111</ItemNo>' +
                   '      <Code>TW</Code>' +
                   '    </CountryOfOrigin>' +
                   '    <CountryOfOrigin xmlns="urn:microsoft-dynamics-nav/coo">' +
                   '      <ItemNo>yyy222</ItemNo>' +
                   '      <Code>TW</Code>' +
                   '    </CountryOfOrigin>' +
                   '  </countryOfOrigins>' +
                   '</SendCountryOfOrigin>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, CodeunitNo));
        WebServReqMgt.SetTraceMode(TraceMode);
        WebServReqMgt.DisableHttpsCheck;
        WebServReqMgt.SetBasicCredentials(recWebServiceSetup."User Name", recWebServiceSetup.Password);

        if WebServReqMgt.SendRequestToWebService then begin
            // Get the response
            WebServReqMgt.GetResponseContent(RespBodyInStream);
            ResponseXmlDoc := ResponseXmlDoc.XmlDocument;
            ResponseXmlDoc.Load(RespBodyInStream);
            //  MESSAGE(ResponseXmlDoc.InnerXml);
            ServerFilename := FileMgt.ServerTempFileName('');
            ResponseXmlDoc.Save(ServerFilename);
            FileMgt.DownloadHandler(ServerFilename, '', '', FileMgt.GetToFilterText('', 'XML'), '');

            XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', CodeunitNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;


    procedure GetSerialNo(pCompany: Text[80]) rValue: Text
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
        //>> 11-04-19 ZY-LD 001
        pCompany := ZGT.GetRHQCompanyName;
        Url := recWebServiceSetup.GetWsUrl(GetSetupCode, pCompany, GetWebServiceNo);
        WsFunctionName := 'GetSerialNo';
        TraceMode := true;

        ReqText := '<GetSerialNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyHQ">' +
                     '<sourceType>BLANK</sourceType>' +
                     '<sourceNo>BLANK</sourceNo>' +
                     '<serialNos>' +
                       '<SerialNo xmlns="urn:microsoft-dynamics-nav/sno">' +
                         '<DeliveryDocumentNo />' +
                         '<No />' +
                         '<ItemNo />' +
                         '<ShipmentDate>0001-01-01</ShipmentDate>' +
                         '<InvoiceNo />' +
                         '<InvoiceNoEndCustomer />' +
                         '<ExternalDocumentNo />' +
                         '<CustomerNo />' +
                         '<CustomerName />' +
                         '<DivisionCode />' +
                       '</SerialNo>' +
                       '<AllRecordsSent xmlns="urn:microsoft-dynamics-nav/sno" />' +
                     '</serialNos>' +
                   '</GetSerialNo>';



        // ReqText := '<GetSerialNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyHQ">' +
        //             '<invoiceNo>BLANK</invoiceNo>'+
        //             '<serialNos>'+
        //               '<SerialNo xmlns="urn:microsoft-dynamics-nav/sno">' +
        //                 '<No />' +
        //               '</SerialNo>' +
        //               '<AllRecordsSent xmlns="urn:microsoft-dynamics-nav/sno" />' +
        //             '</serialNos>' +
        //           '</GetSerialNo>';


        // ReqText := '<GetSerialNo xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyHQ">' +
        //            '<invoiceNo>BLANK</invoiceNo>' +
        //             '<salesInvoices>' +
        //               '<SalesInvoice xmlns="urn:microsoft-dynamics-nav/sno">' +
        //                 '<InvoiceNo />' +
        //                 '<InvoiceNoEndCustomer />' +
        //                 '<SellToCustomerNo />' +
        //                 '<SellToCustomerName />' +
        //                 '<DivisionCode />' +
        //                 '<SalesInvLine>' +
        //                   '<ItemNo />' +
        //                   '<SalesShipLine>' +
        //                     '<ShipmentDate>0001-01-01</ShipmentDate>' +
        //                     '<DeliveryDocumentNo />' +
        //                     '<SerialNos>' +
        //                       '<SerialNo />' +
        //                     '</SerialNos>' +
        //                   '</SalesShipLine>' +
        //                 '</SalesInvLine>' +
        //               '</SalesInvoice>' +
        //             '</salesInvoices>' +
        //           '</GetSerialNo>';

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
            ServerFilename := FileMgt.ServerTempFileName('');
            ResponseXmlDoc.Save(ServerFilename);
            FileMgt.DownloadHandler(ServerFilename, '', '', FileMgt.GetToFilterText('', 'XML'), '');

            //  XMLNsMgr := XMLNsMgr.XmlNamespaceManager(ResponseXmlDoc.NameTable);
            //  XMLNsMgr.AddNamespace('s',recWebServiceSetup.GetSoapAction('',GetWebServiceNo));
            //  WorkNodes := ResponseXmlDoc.SelectNodes(STRSUBSTNO('//s:%1_Result',WsFunctionName),XMLNsMgr);
            //
            //  FOR i := 0 TO WorkNodes.Count - 1 DO BEGIN
            //    WorkNode := WorkNodes.ItemOf(i);
            //    EVALUATE(rValue,WorkNode.SelectSingleNode('s:return_value',XMLNsMgr).InnerText);
            //  END;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
        //<< 11-04-19 ZY-LD 001
    end;

    local procedure GetSetupCode(): Code[2]
    begin
        exit('HQ');
    end;


    procedure GetWebServiceNo(): Integer
    begin
        exit(50076);
    end;


    procedure SendSalesOrder(pCompany: Text[80]) rValue: Text
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
        CodeunitNo := 50076;
        //recWebServiceSetup.GET;
        Url := recWebServiceSetup.GetWsUrl('HQ', pCompany, CodeunitNo);
        WsFunctionName := 'SendSalesOrder';
        TraceMode := true;

        ReqText := '<SendSalesOrder xmlns="urn:microsoft-dynamics-schemas/codeunit/ZyHQ">' +
                     '<salesOrders>' +
                       '<SalesHeader xmlns="urn:microsoft-dynamics-nav/so">' +
                         '<CustomerNo>10044</CustomerNo>' +
                         StrSubstNo('<OrderDate>%1</OrderDate>', Format(Today, 0, 9)) +
                         '<CurrencyCode>EUR</CurrencyCode>' +
                         '<ExternalDocumentNo>456</ExternalDocumentNo>' +
                         '<IsEiCard>No</IsEiCard>' +
                         StrSubstNo('<ShipToName>%1</ShipToName>', 'Lars Dyring') +
                         StrSubstNo('<ShipToAddress>%1</ShipToAddress>', 'Rolighedsvænget 6') +
                         StrSubstNo('<ShipToPostCode>%1</ShipToPostCode>', '4622') +
                         StrSubstNo('<ShipToCity>%1</ShipToCity>', 'Havdrup') +
                         StrSubstNo('<ShipToCountryCode>%1</ShipToCountryCode>', 'DK') +
                         '<SalesLine>' +
                           '<ItemNo>1-002-23112002</ItemNo>' +
                           '<Quantity>7</Quantity>' +
                           '<UnitOfMeasure>PCS</UnitOfMeasure>' +
                           '<UnitPrice>123</UnitPrice>' +
                         '</SalesLine>' +
                       '</SalesHeader>' +
                     '</salesOrders>' +
                   '</SendSalesOrder>';

        // Save request text in instream
        TempBlob.CreateOutstream(ReqBodyOutStream, Textencoding::UTF8);
        ReqBodyOutStream.Write(ReqText);
        TempBlob.CreateInstream(ReqBodyInStream, Textencoding::UTF8);

        // Run the WebServReqMgt functions to send the request
        WebServReqMgt.SetGlobals(ReqBodyInStream, Url, Username, Password);
        WebServReqMgt.SetContentType(recWebServiceSetup.GetContentType);
        WebServReqMgt.SetAction(recWebServiceSetup.GetSoapAction(WsFunctionName, CodeunitNo));

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
            XMLNsMgr.AddNamespace('s', recWebServiceSetup.GetSoapAction('', CodeunitNo));
            WorkNodes := ResponseXmlDoc.SelectNodes(StrSubstNo('//s:%1_Result', WsFunctionName), XMLNsMgr);

            for i := 0 to WorkNodes.Count - 1 do begin
                WorkNode := WorkNodes.ItemOf(i);
                rValue := WorkNode.SelectSingleNode('s:return_value', XMLNsMgr).InnerText;
            end;
        end else begin
            WebServiceRequestMgt.ProcessFaultResponse(ErrorTxt);
            Error(ErrorTxt);
        end;
    end;
}
