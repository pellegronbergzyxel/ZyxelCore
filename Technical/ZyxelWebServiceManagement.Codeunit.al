Codeunit 50083 "Zyxel Web Service Management"
{
    // 001. 06-12-18 ZY-LD 000 - Replicate User Setup.
    // 002. 07-01-19 ZY-LD 000 - Forece replication.
    // 003. 11-04-19 ZY-LD P0217 - Get Sales Invoice No.
    // 004. 27-05-19 ZY-LD P0213 - Force replication on customers.
    // 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 005. 21-01-20 ZY-LD 2020012110000081 - Filter on company.
    // 006. 18-03-20 ZY-LD P0362 - Container details.
    // 007. 16-10-20 ZY-LD P0500 - Use of Report.
    // 008. 30-11-20 ZY-LD P0499 - Transfer order is added to container details.
    // 009. 01-09-21 ZY-LD 000 - Process HQ Sales Document.
    // 010. 07-09-21 ZY-LD 000 - Process eCommerce Ordres is temporary, until we get up and running in ZNet DK.

    trigger OnRun()
    begin
    end;

    var
        ZyWebServReq: Codeunit "Zyxel Web Service Request";
        ZGT: Codeunit "ZyXEL General Tools";
        CompanyInformation: Record "Company Information" temporary;

    procedure ReplicateGlAccounts(pCompanyName: Text[80]; pNo: Code[20])
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate G/L Account";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
    begin
        if not ZGT.CompanyNameIs(1) then  // RHQ
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetData(pNo);
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');
        rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        // Replicate
        if pCompanyName <> '' then
            recRepComp.SetRange("Company Name", pCompanyName);
        recRepComp.SetRange("Replicate Chart of Account", true);
        if recRepComp.FindSet then begin
            ZGT.OpenProgressWindow('', recRepComp.Count);
            repeat
                ZGT.UpdateProgressWindow(recRepComp."Company Name", 0, true);
                if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                    XDoc.Save('C:\Tmp\BlobContent Chart of Account.xml');
                ZyWebServReq.ReplicateGlAccount(recRepComp."Company Name", rValue);
            until recRepComp.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;

    procedure ReplicateCostTypeName(pCompanyName: Text[80]; pNo: Code[20])
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate Cost Type Name";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
    begin
        if not ZGT.CompanyNameIs(1) then  // RHQ
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetData;
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');
        rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        // Replicate
        if pCompanyName <> '' then
            recRepComp.SetRange("Company Name", pCompanyName);
        recRepComp.SetRange("Replicate Cost Type Name", true);
        if recRepComp.FindSet then begin
            ZGT.OpenProgressWindow('', recRepComp.Count);
            repeat
                ZGT.UpdateProgressWindow(recRepComp."Company Name", 0, true);
                if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                    XDoc.Save('C:\Tmp\BlobContent Cost Type Name.xml');
                ZyWebServReq.ReplicateCostTypeName(recRepComp."Company Name", rValue);
            until recRepComp.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;

    procedure ReplicateCustomers(pCompanyName: Text[30]; pCustNoFilter: Text; pForceReplication: Boolean)
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate Customer";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
    begin
        if not ZGT.CompanyNameIs(1) then  // RHQ
            exit;

        if pCompanyName <> '' then
            recRepComp.SetRange("Company Name", pCompanyName);
        recRepComp.SetRange("Replicate Customer", true);
        if recRepComp.FindSet then
            repeat
                // Create Inner XML
                Clear(TempBlob);
                TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

                Clear(WsXmlPort);
                if WsXmlPort.SetData(recRepComp."Company Name", pCustNoFilter, pForceReplication) then begin
                    WsXmlPort.SetDestination(StreamOut);
                    WsXmlPort.Export;

                    TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

                    Clear(XDoc);
                    XDoc := XDoc.XmlDocument();
                    XDoc.Load(StreamIn);
                    NS := NS.XmlNamespaceManager(XDoc.NameTable);
                    NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');
                    rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;
                    if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                        xDoc.Save(StrSubstNo('C:\Tmp\BlobContent Customer %1.xml', recRepComp."Company Name"));

                    // Replicate
                    ZyWebServReq.ReplicateCustomer(recRepComp."Company Name", rValue);
                end;
            until recRepComp.Next() = 0;
    end;

    procedure ReplicateItems(pCompanyName: Text[30]; pItemNoFilter: Text; pReplicateDummy: Boolean; pForceReplication: Boolean)
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate Item";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
    begin
        if not ZGT.CompanyNameIs(1) then  // RHQ
            exit;

        if pReplicateDummy then begin
            // Create Inner XML
            TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

            Clear(WsXmlPort);
            WsXmlPort.SetData(recRepComp."Company Name", pItemNoFilter, pReplicateDummy, pForceReplication);  // 07-01-19 ZY-LD 002
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');  // Change "Rep*" here
            rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                XDoc.Save(StrSubstNo('C:\Tmp\BlobContent Item %1.xml', recRepComp."Company Name"));

            // Replicate
            if pCompanyName <> '' then
                recRepComp.SetRange("Company Name", pCompanyName);
            recRepComp.SetRange("Replicate Item", true);
            if recRepComp.FindSet then
                repeat
                    ZyWebServReq.ReplicateItem(recRepComp."Company Name", rValue);  // Change call of function here
                until recRepComp.Next() = 0;
        end else begin
            if pCompanyName <> '' then
                recRepComp.SetRange("Company Name", pCompanyName);
            recRepComp.SetRange("Replicate Item", true);
            if recRepComp.FindSet then
                repeat
                    // Create Inner XML
                    Clear(TempBlob);
                    TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

                    Clear(WsXmlPort);
                    if WsXmlPort.SetData(recRepComp."Company Name", pItemNoFilter, pReplicateDummy, pForceReplication) then begin  // 07-01-19 ZY-LD 002
                        WsXmlPort.SetDestination(StreamOut);
                        WsXmlPort.Export;  // Change XMLPortNo.

                        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

                        Clear(XDoc);
                        XDoc := XDoc.XmlDocument();
                        XDoc.Load(StreamIn);
                        NS := NS.XmlNamespaceManager(XDoc.NameTable);
                        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');  // Change "Rep*" here
                        rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

                        if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                            XDoc.Save(StrSubstNo('C:\Tmp\BlobContent Item %1.xml', recRepComp."Company Name"));

                        // Replicate
                        ZyWebServReq.ReplicateItem(recRepComp."Company Name", rValue);  // Change call of function here
                    end;
                until recRepComp.Next() = 0;
        end;
    end;

    procedure ReplicateEmailAddress(pCompany: Text[80]; pCode: Code[20])
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate E-mail Address";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
    begin
        if not ZGT.IsRhq then  // RHQ
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetData(pCode);
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');
        rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        // Replicate
        //>> 21-01-20 ZY-LD 005
        if pCompany <> '' then
            recRepComp.SetRange("Company Name", pCompany)  //<< 21-01-20 ZY-LD 005
        else
            recRepComp.SetRange("Replicate E-mail Address", true);
        if recRepComp.FindSet then begin
            ZGT.OpenProgressWindow('', recRepComp.Count);
            repeat
                ZGT.UpdateProgressWindow(recRepComp."Company Name", 0, true);
                if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                    XDoc.Save('C:\Tmp\BlobContent Chart of Account.xml');
                ZyWebServReq.ReplicateEmailAddress(recRepComp."Company Name", rValue);
            until recRepComp.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;

    procedure ReplicateUserSetup(pCode: Code[50])
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate User Setup";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
    begin
        //>> 06-12-18 ZY-LD 001
        if not ZGT.CompanyNameIs(1) then  // RHQ
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetData(pCode);
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');
        rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        // Replicate
        recRepComp.SetRange("Replicate User Setup", true);
        if recRepComp.FindSet then begin
            ZGT.OpenProgressWindow('', recRepComp.Count);
            repeat
                ZGT.UpdateProgressWindow(recRepComp."Company Name", 0, true);
                if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                    XDoc.Save('C:\Tmp\BlobContent Chart of Account.xml');
                ZyWebServReq.ReplicateUserSetup(recRepComp."Company Name", rValue);
            until recRepComp.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
        //>> 06-12-18 ZY-LD 001
    end;

    procedure ReplicateExchangeRate(var pExchRateTmp: Record "Currency Exchange Rate Buffer" temporary) rValue: Boolean
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate Exchange Rate";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        lText001: label 'Replicate %1 - %2';
        InnerText: Text;
    begin
        if not ZGT.IsRhq then  // RHQ
            exit;

        if pExchRateTmp.FindSet then begin
            ZGT.OpenProgressWindow('', pExchRateTmp.Count);

            repeat
                ZGT.UpdateProgressWindow(StrSubstNo(lText001, pExchRateTmp."Currency Code", pExchRateTmp.Company), 0, true);

                // Create Inner XML
                Clear(TempBlob);
                TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

                Clear(WsXmlPort);
                WsXmlPort.SetData_Replication(pExchRateTmp);
                WsXmlPort.SetDestination(StreamOut);
                WsXmlPort.Export;

                TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

                Clear(XDoc);
                XDoc := XDoc.XmlDocument();
                XDoc.Load(StreamIn);
                NS := NS.XmlNamespaceManager(XDoc.NameTable);
                NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/exchrate');
                InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

                // Replicate
                recRepComp.Get(pExchRateTmp.Company);
                if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                    XDoc.Save(StrSubstNo('C:\Tmp\Exchange Rate %1.xml', pExchRateTmp.Company));
                rValue := ZyWebServReq.SendRequestBoolean(pExchRateTmp.Company, 'SendExchangeRate', 'exchangeRates', InnerText, '');
            until pExchRateTmp.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
    end;

    procedure GetCustomerCreditLimits()
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Customer Credit Limit";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
        recCustCredLimit: Record "Customer Credit Limited";
    begin
        if not ZGT.IsRhq then  // RHQ
            exit;

        recRepComp.SetRange("Customer Credit Limit", true);
        if recRepComp.FindSet then begin
            recCustCredLimit.DeleteAll;
            Commit;
            ZGT.OpenProgressWindow('', recRepComp.Count);

            repeat
                ZGT.UpdateProgressWindow(recRepComp."Company Name", 0, true);
                ZyWebServReq.GetCustomerCreditLimit(recRepComp."Company Name", rValue);  // Change call of function here
            until recRepComp.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
    end;

    procedure GetAccountPay_Receivable(pType: Option Payable,Receivable; pCompanyName: Text[30]; EndDate: Date; CurrencyDate: Date; ReportingCurrency: Code[10]; var AccPayBuff: Record "Account Pay./Receiv Buffer" temporary)
    var
        recRepSetup: Record "Replication Company";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Account Pay./Receiv";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
    begin
        if not recRepSetup.Get(pCompanyName) then;
        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetRequest(EndDate, CurrencyDate, ReportingCurrency);
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;  // Change XMLPortNo.

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/acc');  // Change "Rep*" here
        InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        if recRepSetup."Save XML File" and ZGT.UserIsDeveloper then
            XDoc.Save(StrSubstNo('C:\Tmp\BlobContent Account Payable %1.xml', pCompanyName));

        // Get data
        ZGT.OpenProgressWindow('', 1);
        ZGT.UpdateProgressWindow(pCompanyName, 0, true);
        if pType = Ptype::Payable then
            ZyWebServReq.GetAccountPay_Receivable(pCompanyName, 'GetAccountPayable', 'accountPayables', InnerText, AccPayBuff)  // Change call of function here
        else  // Receivable
            ZyWebServReq.GetAccountPay_Receivable(pCompanyName, 'GetAccountReceivable', 'accountReceivables', InnerText, AccPayBuff);  // Change call of function here
        ZGT.CloseProgressWindow;
    end;

    procedure GetCustomerOverdueBalance(pCustNo: Code[20]; pDueDate: Date; pShowOpenPayments: Boolean): Decimal
    var
        recCust: Record Customer;
        recBillToCust: Record Customer;
        recICPartner: Record "IC Partner";
    begin
        if recCust.Get(pCustNo) then
            if recBillToCust.Get(recCust."Bill-to Customer No.") then
                if recICPartner.Get(recBillToCust."IC Partner Code") then
                    exit(ZyWebServReq.GetCustomerOverdueBalance(recICPartner."Inbox Details", pCustNo, pDueDate, pShowOpenPayments));
    end;

    procedure GetSalesInvoiceNo(pCompany: Text[80]; pSalesInvNo: Code[20]): Code[20]
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Customer Credit Limit";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
        CrFilter: Text;
    begin
        //>> 11-04-19 ZY-LD 003
        if not ZGT.IsRhq then  // RHQ
            exit;

        if recRepComp.Get(pCompany) and (recRepComp."Get End Cust. Sales Inv. No.") then
            exit(ZyWebServReq.GetSalesInvoiceNo(pCompany, pSalesInvNo));  // Change call of function here
        //<< 11-04-19 ZY-LD 003
    end;

    procedure GetIcReconciliation(IcReconName: Record "IC Reconciliation Name"; IcReconLine: Record "IC Reconciliation Line"; Level: Integer; StartDate: Date; EndDate: Date; var ReportingCurrency: Code[10]) rValue: Decimal
    var
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "IC Reconciliation";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerXml: Text;
        CrFilter: Text;
        DecimalText: Text;
    begin
        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetData(IcReconName, IcReconLine, StartDate, EndDate, ReportingCurrency);
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/IcRecon');
        InnerXml := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        // Replicate
        //XDoc.Save('C:\Tmp\BlobContent Chart of Account.xml');
        DecimalText := ZyWebServReq.SendRequestDecimalText(IcReconLine."Company Name", 'GetIcReconciliation', 'iCReconciliation', InnerXml);
        if StrLen(DecimalText) > 4 then begin
            ReportingCurrency := CopyStr(DecimalText, 1, 3);
            Evaluate(rValue, CopyStr(DecimalText, 4, StrLen(DecimalText)), 9);
        end;
    end;

    procedure GetExchangeInfo(pCompany: Text[80]; pCurrencyCode: Code[10]; var pExchRateTmp: Record "Currency Exchange Rate Buffer" temporary)
    var
        recCurrExchRateBuf: Record "Currency Exchange Rate Buffer" temporary;
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Replicate Exchange Rate";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
        lText001: label 'Get info %1 - %2';
    begin
        if not ZGT.IsRhq then  // RHQ
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        WsXmlPort.SetData_Request(pCurrencyCode);
        WsXmlPort.SetDestination(StreamOut);
        WsXmlPort.Export;

        TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

        XDoc := XDoc.XmlDocument();
        XDoc.Load(StreamIn);
        NS := NS.XmlNamespaceManager(XDoc.NameTable);
        NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/exchrate');
        rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

        // Replicate
        if pCompany <> '' then
            recRepComp.SetRange("Company Name", pCompany)
        else
            recRepComp.SetRange("Replicate Exchange Rate", recRepComp."replicate exchange rate"::Yes);

        Clear(TempBlob);
        if recRepComp.FindSet then begin
            ZGT.OpenProgressWindow('', recRepComp.Count);

            repeat
                ZGT.UpdateProgressWindow(StrSubstNo(lText001, pCurrencyCode, recRepComp."Company Name"), 0, true);

                if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
                    XDoc.Save('C:\Tmp\Exchange Rate.xml');
                recCurrExchRateBuf.DeleteAll;
                ZyWebServReq.GetExchangeInfo(recRepComp."Company Name", 'GetExchangeRate', 'exchangeRates', rValue, recCurrExchRateBuf);

                if recCurrExchRateBuf.FindFirst then begin
                    pExchRateTmp := recCurrExchRateBuf;

                    if CopyStr(pExchRateTmp.Company, 1, 4) = 'TEST' then
                        pExchRateTmp.Company := CopyStr(pExchRateTmp.Company, 6, StrLen(pExchRateTmp.Company));
                    pExchRateTmp.Insert;
                end;
            until recRepComp.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
    end;

    // procedure GetConcurVendor(pCompany: Text[80]; var pVendTmp: Record Vendor temporary; pVendorNo: Code[20])
    // var
    //     recCurrExchRateBuf: Record "Currency Exchange Rate Buffer" temporary;
    //     recItem: Record Item;
    //     StreamOut: OutStream;
    //     StreamIn: InStream;
    //     TempBlob: Codeunit "Temp Blob";
    //     Item: Record Item;
    //     WsXmlPort: XmlPort "WS Concur Vendors";
    //     XDoc: dotnet XmlDocument;
    //     NS: dotnet XmlNamespaceManager;
    //     InnerText: Text;
    //     lText001: label 'Get info %1 - %2';
    // begin
    //     if not ZGT.IsRhq then  // RHQ
    //         exit;

    //     // Create Inner XML
    //     TempBlob.Insert;
    //     TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

    //     //WsXmlPort.SetData_Request;
    //     WsXmlPort.SetDestination(StreamOut);
    //     WsXmlPort.Export;

    //     TempBlob.Modify;
    //     TempBlob.CalcFields(Blob);
    //     TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

    //     XDoc := XDoc.XmlDocument();
    //     XDoc.Load(StreamIn);
    //     NS := NS.XmlNamespaceManager(XDoc.NameTable);
    //     NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/concurvendor');
    //     InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

    //     // Get Data
    //     ZyWebServReq.GetConcurVendor(pCompany, 'GetConcurVendor', 'vendors', InnerText, pVendTmp, pVendorNo);
    // end;

    procedure GetConcurValidation(pCompany: Text[80]; SourceTable: Integer; SourceFieldNo: Integer; SourceCode: Code[20]): Boolean
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Customer Credit Limit";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
    begin
        if not ZGT.IsRhq then  // RHQ
            exit;

        InnerText :=
          StrSubstNo('<sourceTable>%1</sourceTable>', SourceTable) +
          StrSubstNo('<sourceFieldNo>%1</sourceFieldNo>', SourceFieldNo) +
          StrSubstNo('<sourceCode>%1</sourceCode>', SourceCode);

        if recRepComp.Get(pCompany) then
            exit(ZyWebServReq.SendRequestBoolean(pCompany, 'GetConcurValidation', '', InnerText, ''));  // Change call of function here
    end;

    // procedure SendConcurVendor(pCompany: Text[80]; var pConcVend: Record "Concur Vendor") rValue: Code[20]
    // var
    //     recCurrExchRateBuf: Record "Currency Exchange Rate Buffer" temporary;
    //     recItem: Record Item;
    //     recRepComp: Record "Replication Company";
    //     StreamOut: OutStream;
    //     StreamIn: InStream;
    //     TempBlob: Codeunit "Temp Blob";
    //     Item: Record Item;
    //     WsXmlPort: XmlPort "WS Concur Vendors";
    //     XDoc: dotnet XmlDocument;
    //     NS: dotnet XmlNamespaceManager;
    //     InnerText: Text;
    //     lText001: label 'Get info %1 - %2';
    // begin
    //     if not ZGT.IsRhq then  // RHQ
    //         exit;

    //     // Create Inner XML
    //     TempBlob.Insert;
    //     TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

    //     WsXmlPort.SetData_Request(pCompany, pConcVend);
    //     WsXmlPort.SetDestination(StreamOut);
    //     WsXmlPort.Export;

    //     TempBlob.Modify;
    //     TempBlob.CalcFields(Blob);
    //     TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);
    //     recRepComp.Get(pCompany);
    //     if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
    //         XDoc.Save('C:\Tmp\Send Concur Vendor.xml');

    //     XDoc := XDoc.XmlDocument();
    //     XDoc.Load(StreamIn);
    //     NS := NS.XmlNamespaceManager(XDoc.NameTable);
    //     NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/concurvendor');
    //     InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

    //     // Send Data
    //     rValue := ZyWebServReq.SendRequestText(pCompany, 'SendConcurVendor', 'vendors', InnerText);
    // end;

    procedure SendSalesInvoiceNo(pCompany: Text[30]; pRHQSalesInvNo: Code[35]; pSubSalesInvNo: Code[20]): Boolean
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Customer Credit Limit";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
        CrFilter: Text;
        lText001: label 'Invoice No. could not be updated in "%1".';
    begin
        //>> 11-04-19 ZY-LD 003
        if ZGT.IsRhq then  // RHQ
            exit;

        if not ZyWebServReq.SendSalesInvoiceNo(pCompany, CopyStr(pRHQSalesInvNo, 1, 20), pSubSalesInvNo) then;  // If it's not a RHQ invoice, then nothing happens.
        //<< 11-04-19 ZY-LD 003
    end;

    procedure SendPurchasOrders(pCompany: Text[50]; pPurchOrderNo: Code[20]; pCustomerNo: Code[20]) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Sales Order";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
    begin
        if not ZGT.IsRhq then
            exit;

        recPurchHead.Get(recPurchHead."document type"::Order, pPurchOrderNo);
        if not recPurchHead."EShop Order Sent" then begin
            // Create Inner XML
            TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

            Clear(WsXmlPort);
            if WsXmlPort.SetData(pPurchOrderNo, pCustomerNo) then begin
                WsXmlPort.SetDestination(StreamOut);
                WsXmlPort.Export;  // Change XMLPortNo.

                //IF ZGT.UserIsDeveloper THEN
                //  XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
                TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

                XDoc := XDoc.XmlDocument();
                XDoc.Load(StreamIn);
                NS := NS.XmlNamespaceManager(XDoc.NameTable);
                NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/so');  // Change "Rep*" here
                InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

                // Replicate
                rValue := ZyWebServReq.SendPurchaseOrder(pCompany, InnerText);  // Change call of function here

                Message(lText001, pPurchOrderNo);
            end;
        end else
            Message(lText002, pPurchOrderNo);
    end;

    procedure SendTravelExpense(var pTrExpHead: Record "Travel Expense Header"; NewPostDocument: Boolean) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Travel Expense";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
        TopHeader: Text;
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        if WsXmlPort.SetData(pTrExpHead, NewPostDocument) then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            //IF ZGT.UserIsDeveloper THEN
            //  XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/transfer');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            TopHeader := StrSubstNo('<automation>%1</automation>', ZGT.ConvertBooleanToTrueFalse(not GuiAllowed, 1));

            // Replicate
            if ZyWebServReq.SendRequestBoolean(pTrExpHead."Concur Company Name", 'SendTravelExpense', 'travelExpenses', InnerText, TopHeader) then begin  // Change call of function here
                pTrExpHead.ModifyAll("Document Status", pTrExpHead."document status"::Transferred);
                rValue := true;
            end;
        end;
    end;

    procedure SendUnshippedQuantity(pCompany: Text[50]; pCustomerNo: Code[20]) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Unshipped Quantity";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        if WsXmlPort.SetData(pCustomerNo) then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            //IF ZGT.UserIsDeveloper THEN
            //  XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/uq');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            // Replicate
            rValue := ZyWebServReq.SendUnshippedQuantity(pCompany, InnerText);  // Change call of function here
        end;
    end;

    procedure SendContainerDetails(pCompany: Text[50]; pSourceType: Option "Sales Invoice","Sales Return Order","Purchase Order","Transfer Order"; pSourceNo: Code[20]) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Container Detail";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
        SetDataOK: Boolean;
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);

        //>> 18-03-20 ZY-LD 006
        //IF WsXmlPort.SetData(pSalesInvNo) THEN BEGIN
        case pSourceType of
            Psourcetype::"Sales Invoice":
                SetDataOK := WsXmlPort.SetData(pSourceNo);
            Psourcetype::"Sales Return Order":
                SetDataOK := WsXmlPort.SetData_SalesReturn(pSourceNo);
            Psourcetype::"Purchase Order":
                SetDataOK := WsXmlPort.SetData_PurchaseOrder(pSourceNo);
            Psourcetype::"Transfer Order":
                SetDataOK := WsXmlPort.SetData_TransferOrder(pSourceNo);  // 30-11-20 ZY-LD 008
        end;
        //<< 18-03-20 ZY-LD 006
        if SetDataOK then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            //IF ZGT.UserIsDeveloper THEN
            //  XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/cd');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            // Replicate
            rValue := ZyWebServReq.SendContainerDetails(pCompany, InnerText);  // Change call of function here
        end;
    end;

    procedure SendSalesOrderFrance(pPurchOrderNo: Code[20]) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "FR Sales Order";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        if WsXmlPort.SetData(pPurchOrderNo) then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/sofr');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            // Send
            rValue := ZyWebServReq.SendSalesOrderFrance('ZNet DK', InnerText);  // Change call of function here
        end;
    end;

    procedure SendPurchasePrice(pCompany: Text[50]; pVendorCode: Code[10]; var pPurchPriceTmp: Record "Price List Line" temporary) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "HQ Purchase Price";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        if WsXmlPort.SetData(pVendorCode, pPurchPriceTmp) then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            //IF ZGT.UserIsDeveloper THEN
            //  XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/pp');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:Root', NS).InnerXml;

            // Replicate
            rValue := ZyWebServReq.SendPurchasePrice(pCompany, InnerText);  // Change call of function here
        end;
    end;

    procedure SendSalesPrice(pCompany: Text[50]; var pSalesPriceTmp: Record "Price List Line" temporary) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "HQ Sales Price";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        if WsXmlPort.SetData(pSalesPriceTmp) then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            //IF ZGT.UserIsDeveloper THEN
            //  XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/sp');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:Root', NS).InnerXml;

            // Replicate
            rValue := ZyWebServReq.SendSalesPrice(pCompany, InnerText);  // Change call of function here
        end;
    end;

    procedure SendPhasesPurchaseOrder(pPurchOrderNo: Code[20]) rValue: Boolean
    var
        recItem: Record Item;
        recPurchHead: Record "Purchase Header";
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "PH Purchase Order";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        InnerText: Text;
        lText001: label 'Purchase Order "%1" has been sent.';
        lText002: label 'Purchase Order "%1" has already been sent.';
    begin
        if not ZGT.IsRhq then
            exit;

        // Create Inner XML
        TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

        Clear(WsXmlPort);
        if WsXmlPort.SetData(pPurchOrderNo) then begin
            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;  // Change XMLPortNo.

            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/purchaseorder');  // Change "Rep*" here
            InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            // Send
            rValue := ZyWebServReq.SendRequestBoolean('ZNet DK', 'SendPhasesPurchaseOrder', 'purchaseOrders', InnerText, '');  // Change call of function here
        end;
    end;

    // procedure SendConcurPurchaseDocument(pCompanyName: Text; var pInvCapHead: Record "CC Inv. Capture Header" temporary; PostDocument: Boolean) rValue: Boolean
    // var
    //     StreamOut: OutStream;
    //     StreamIn: InStream;
    //     TempBlob: Codeunit "Temp Blob";
    //     Item: Record Item;
    //     recRepComp: Record "Replication Company";
    //     WsXmlPort: XmlPort "WS Concur Purchase Document";
    //     XDoc: dotnet XmlDocument;
    //     NS: dotnet XmlNamespaceManager;
    //     InnerText: Text;
    // begin
    //     if not ZGT.IsRhq then
    //         exit;

    //     // Create Inner XML
    //     Clear(TempBlob);
    //     if TempBlob.IsEmpty then
    //         TempBlob.Insert;
    //     TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

    //     Clear(WsXmlPort);

    //     if WsXmlPort.SetData(pInvCapHead, PostDocument) then begin
    //         WsXmlPort.SetDestination(StreamOut);
    //         WsXmlPort.Export;  // Change XMLPortNo.

    //         TempBlob.Modify;
    //         TempBlob.CalcFields(Blob);
    //         TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);
    //         recRepComp.Get(pCompanyName);
    //         if recRepComp."Save XML File" and ZGT.UserIsDeveloper then
    //             XDoc.Save(StrSubstNo('C:\Tmp\Concur Purchase Document %1.xml', pInvCapHead."No."));

    //         XDoc := XDoc.XmlDocument();
    //         XDoc.Load(StreamIn);
    //         NS := NS.XmlNamespaceManager(XDoc.NameTable);
    //         NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/purchasedocument');  // Change "Rep*" here
    //         InnerText := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

    //         // Send
    //         rValue := ZyWebServReq.SendRequestBoolean(pCompanyName, 'SendConcurPurchaseDocument', 'purchaseDocuments', InnerText, '');  // Change call of function here
    //     end;
    // end;

    procedure SendUseOfReport(var pUseOfReportTmp: Record "Use of Report Entry" temporary)
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort "WS Use of Report";
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
        lText001: label 'Replicate %1 - %2';
    begin
        //>> 16-10-20 ZY-LD 006
        Clear(WsXmlPort);
        if WsXmlPort.SetData(pUseOfReportTmp) then begin
            // Create Inner XML
            Clear(TempBlob);
            TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

            WsXmlPort.SetDestination(StreamOut);
            WsXmlPort.Export;

            TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

            XDoc := XDoc.XmlDocument();
            XDoc.Load(StreamIn);
            NS := NS.XmlNamespaceManager(XDoc.NameTable);
            NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/useofreport');
            rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

            // Send
            ZyWebServReq.SendRequestBoolean(ZGT.GetCompanyName(1), 'SendUseOfReport', 'useOfReports', rValue, '');
        end;
        //<< 16-10-20 ZY-LD 006
    end;

    procedure ProcessHqSalesDocument()
    var
        recRepComp: Record "Replication Company";
        Dummy: Text;
    begin
        //>> 01-09-21 ZY-LD 009
        recRepComp.SetRange("Download HQ Sales Document", true);
        if recRepComp.FindSet then
            repeat
                ZyWebServReq.SendRequestBoolean(recRepComp."Company Name", 'ProcessHQSalesDocument', '', Dummy, '');
            until recRepComp.Next() = 0;
        //<< 01-09-21 ZY-LD 009
    end;

    procedure ProcesseCommerceOrders(pImportOrders: Boolean; pPostOrders: Boolean) rValue: Boolean
    var
        InnerText: Text;
    begin
        //>> 07-09-21 ZY-LD 010
        InnerText :=
          StrSubstNo('<importOrders>%1</importOrders>', ZGT.ConvertBooleanToTrueFalse(pImportOrders, 0)) +
          StrSubstNo('<postOrders>%1</postOrders>', ZGT.ConvertBooleanToTrueFalse(pPostOrders, 0));
        rValue := ZyWebServReq.SendRequestBoolean('ZyND DE', 'ProcesseCommerceOrders', '', InnerText, '');
        //<< 07-09-21 ZY-LD 010
    end;

    procedure ProcessSiiSpain()
    var
        recRepComp: Record "Replication Company";
        Dummy: Text;
    begin
        //>> 01-09-21 ZY-LD 009
        recRepComp.SetRange("SII Spain", true);
        if recRepComp.FindSet then
            repeat
                ZyWebServReq.SendRequestBoolean(recRepComp."Company Name", 'ProcessSiiSpain', '', Dummy, '');
            until recRepComp.Next() = 0;
        //<< 01-09-21 ZY-LD 009
    end;

    procedure xReplicateItem(var pItemTmp: Record Item temporary)
    var
        subItem: Record Item;
        recItemKeepValues: Record Item;
    begin
        if pItemTmp.FindSet then
            repeat
                if subItem.Get(pItemTmp."No.") then
                    recItemKeepValues := subItem
                else
                    Clear(recItemKeepValues);

                subItem.TransferFields(pItemTmp, false);
                subItem."No." := pItemTmp."No.";
                if recItemKeepValues."No." <> '' then begin
                    subItem."Cost is Adjusted" := recItemKeepValues."Cost is Adjusted";
                    subItem.Modify
                end else
                    subItem.Insert;
            until pItemTmp.Next() = 0;
    end;

    procedure ReplicateItemUTM(var pItemUOMTmp: Record "Item Unit of Measure" temporary)
    var
        subItemUOM: Record "Item Unit of Measure";
    begin
        if pItemUOMTmp.FindSet then
            repeat
                if subItemUOM.Get(pItemUOMTmp."Item No.", pItemUOMTmp.Code) then begin
                    subItemUOM := pItemUOMTmp;
                    subItemUOM.Modify;
                end else begin
                    subItemUOM := pItemUOMTmp;
                    subItemUOM.Insert;
                end;
            until pItemUOMTmp.Next() = 0;
    end;

    procedure InsertICInboxTrans(pICInboxTrans: Record "IC Inbox Transaction" temporary): Boolean
    var
        recICInboxTrans: Record "IC Inbox Transaction";
        lText004: label 'Transaction %1 for %2 %3 already exists in the %4 table.';
        recHandICInboxTrans: Record "Handled IC Inbox Trans.";
    begin
        if recICInboxTrans.Get(
            pICInboxTrans."Transaction No.", pICInboxTrans."IC Partner Code",
            pICInboxTrans."Transaction Source", pICInboxTrans."Document Type")
        then
            Error(
              lText004, recICInboxTrans."Transaction No.", recICInboxTrans.FieldCaption("IC Partner Code"),
              recICInboxTrans."IC Partner Code", recHandICInboxTrans.TableCaption);

        recICInboxTrans := pICInboxTrans;
        recICInboxTrans.Insert(true);
    end;

    procedure ReplicateItemBudgetEntries(pCompanyName: Text[30])
    var
        recRepComp: Record "Replication Company";
        recItem: Record Item;
        StreamOut: OutStream;
        StreamIn: InStream;
        TempBlob: Codeunit "Temp Blob";
        Item: Record Item;
        WsXmlPort: XmlPort ItemBudgetEntries;
        XDoc: dotnet XmlDocument;
        NS: dotnet XmlNamespaceManager;
        rValue: Text;
        recItemBudgetEntry: Record "Item Budget Entry";
    begin
        if not ZGT.CompanyNameIs(1) then  // RHQ
            exit;

        recItemBudgetEntry.SetCurrentkey("Analysis Area", "Budget Name", "Item No.", "Source Type", "Source No.", Date, "Location Code", "Global Dimension 1 Code");
        recItemBudgetEntry.SetRange("Global Dimension 1 Code", 'CH');
        recItemBudgetEntry.SetFilter("Budget Name", 'MASTER', 'FORECAST', 'PREVIOUS');
        if recItemBudgetEntry.FindSet then begin
            ZGT.OpenProgressWindow('', recItemBudgetEntry.Count);

            repeat
                ZGT.UpdateProgressWindow(Format(recItemBudgetEntry."Entry No."), 0, true);
                // Create Inner XML
                Clear(TempBlob);
                TempBlob.CreateOutstream(StreamOut, Textencoding::UTF8);

                Clear(WsXmlPort);
                if WsXmlPort.SetData(recItemBudgetEntry) then begin  // 07-01-19 ZY-LD 002
                    WsXmlPort.SetDestination(StreamOut);
                    WsXmlPort.Export;  // Change XMLPortNo.

                    //  IF recRepComp."Save XML File" AND ZGT.UserIsDeveloper THEN
                    //    XDoc.Save(STRSUBSTNO('C:\Tmp\BlobContent Item %1.xml',recRepComp."Company Name"));
                    TempBlob.CreateInstream(StreamIn, Textencoding::UTF8);

                    Clear(XDoc);
                    XDoc := XDoc.XmlDocument();
                    XDoc.Load(StreamIn);
                    NS := NS.XmlNamespaceManager(XDoc.NameTable);
                    NS.AddNamespace('d', 'urn:microsoft-dynamics-nav/Replicate');  // Change "Rep*" here
                    rValue := XDoc.SelectSingleNode('//d:root', NS).InnerXml;

                    // Replicate
                    ZyWebServReq.ReplicateItemBudgetEntry(pCompanyName, rValue);  // Change call of function here
                end;
            until recItemBudgetEntry.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
    end;

    procedure VendorCreatedInConcur(pVendorNo: Code[20]) rValue: Boolean
    var
        ZyWebServReq: Codeunit "Zyxel Web Service Request";
        ZGT: Codeunit "ZyXEL General Tools";
        InnerText: Text;
        SendToCompanyName: Text;
    begin
        // Create Inner XML
        // TempBlob.INSERT;
        // TempBlob.CreateOutstream(StreamOut,TEXTENCODING::UTF8);
        //
        // //WsXmlPort.SetData_Request;
        // WsXmlPort.SETDESTINATION(StreamOut);
        // WsXmlPort.EXPORT;
        //
        // TempBlob.MODIFY;
        // TempBlob.CALCFIELDS(Blob);
        // TempBlob.CreateInstream(StreamIn,TEXTENCODING::UTF8);
        //
        // XDoc := XDoc.XmlDocument();
        // XDoc.Load(StreamIn);
        // NS := NS.XmlNamespaceManager(XDoc.NameTable);
        // NS.AddNamespace('d','urn:microsoft-dynamics-nav/concurvendor');
        // InnerText := XDoc.SelectSingleNode('//d:root',NS).InnerXml;

        InnerText :=
          StrSubstNo('<companyName>%1</companyName>', CompanyName()) +
          StrSubstNo('<vendorNo>%1</vendorNo>', pVendorNo);

        // Get Data
        if ZGT.IsZComCompany then
            SendToCompanyName := ZGT.GetRHQCompanyName
        else
            SendToCompanyName := ZGT.GetSistersCompanyName(1);  // RHQ
        rValue := ZyWebServReq.SendRequestBoolean(SendToCompanyName, 'VendorCreatedInConcur', '', InnerText, '')
    end;
}
