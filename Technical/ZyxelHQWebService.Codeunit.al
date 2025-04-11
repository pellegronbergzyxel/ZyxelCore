codeunit 50076 "Zyxel HQ Web Service"
{
    // 001. 16-04-24 ZY-LD 000 - Moved to handle everything in the xmlport.
    // 002. 17-07-24 ZY-LD 000 - Zyxel Store ship from VCK.

    Permissions = tabledata "Sales Invoice Header" = m,
                  tabledata "Transfer Receipt Header" = m;

    var
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
        ZGT: Codeunit "ZyXEL General Tools";
        ImportErr: Label 'An error occured during import of "%1". Please contact "navsupport@zyxel.eu".';
        EmailAddMgt: Codeunit "E-mail Address Management";

    procedure SendCountryOfOrigin(CountryOfOrigins: XmlPort "HQ Country Of Origins"): Boolean
    var
        recItemTmp: Record Item temporary;
    begin
        if ZGT.IsRhq then begin
            CountryOfOrigins.Import();
            CountryOfOrigins.GetData(recItemTmp);
            exit(ZyHqWebServMgt.CountryOfOrigin(recItemTmp));
        end;
    end;

    procedure SendPLMS(HQPLMS: XmlPort "HQ PLMS"): Boolean
    var
        recItemTmp: Record Item temporary;
        recHqDimTmp: Record SBU temporary;
    begin
        if ZGT.IsRhq then begin
            HQPLMS.Import();
            //>> 16-04-24 ZY-LD 001
            exit(HQPLMS.GetData);
            //HQPLMS.GetData(recItemTmp, recHqDimTmp);  // 18-10-19 ZY-LD 004
            //exit(ZyHqWebServMgt.PLMS(recItemTmp, recHqDimTmp));  // 18-10-19 ZY-LD 004
            //<< 16-04-24 ZY-LD 001
        end;
    end;

    procedure SendEiCardLink(EiCardLinks: XmlPort "HQ EiCard Download Link") rValue: Boolean
    var
        recEicardQueueTmp: Record "EiCard Queue" temporary;
        lText001: Label 'EiCard Links';
        recEiCardLinkLineTmp: Record "EiCard Link Line" temporary;
    begin
        if ZGT.IsRhq then begin
            EiCardLinks.Import();
            //>> 09-06-23 ZY-LD 011
            //EiCardLinks.GetData(recEiCardLinkHeadTmp,recEiCardLinkLineTmp);
            //IF ZyHqWebServMgt.EiCardLinks(recEiCardLinkHeadTmp,recEiCardLinkLineTmp) THEN
            EiCardLinks.GetData(recEicardQueueTmp, recEiCardLinkLineTmp);
            if ZyHqWebServMgt.EiCardLinks(recEicardQueueTmp, recEiCardLinkLineTmp) then  //<< 09-06-23 ZY-LD 011
                rValue := true
            else begin
                SendErrorToNavSupport(lText001);
                Error(ImportErr, lText001);
            end;
        end;
    end;

    procedure SendSalesDocument(Documents: XmlPort "HQ Sales Document") RetuenValue: Boolean
    var
        TempHQSalesHeader: Record "HQ Invoice Header" temporary;
        TempHQSalesLine: Record "HQ Invoice Line" temporary;
        HQSalesDocLbl: Label 'HQ Sales Document';
    begin
        if ZGT.IsRhq or (ZGT.IsZComCompany and (ZGT.CompanyNameIs(9) or ZGT.CompanyNameIs(14))) then begin
            Documents.Import();
            Documents.GetData(TempHQSalesHeader, TempHQSalesLine);
            if ZyHqWebServMgt.HQSalesDocument(TempHQSalesHeader, TempHQSalesLine) then
                RetuenValue := true
            else begin
                SendErrorToNavSupport(HQSalesDocLbl);
                Error(ImportErr, HQSalesDocLbl);
            end;
        end;
    end;

    local procedure UpdateEMEAPurchaseOrder(PurchaseOrders: XmlPort "HQ EMEA Purchase Order"): Boolean
    var
        recPurchaseHeaderTmp: Record "Purchase Header" temporary;
        recPurchaseLineTmp: Record "Purchase Line" temporary;
    begin
        if ZGT.IsRhq then begin
            PurchaseOrders.Import();
            PurchaseOrders.GetData(recPurchaseHeaderTmp, recPurchaseLineTmp);
            exit(ZyHqWebServMgt.UpdateEMEAPurchaseOrder(recPurchaseHeaderTmp, recPurchaseLineTmp));
        end;
    end;

    procedure SendContainerDetail(HQContainerDetail: XmlPort "HQ ContainerDetail") ReturnValue: Boolean
    var
        TempContainerDetail: Record "VCK Shipping Detail" temporary;
        ContainerDetailsLbl: Label 'Container Details';
    begin
        HQContainerDetail.Import();
        HQContainerDetail.GetData(TempContainerDetail);
        if ZyHqWebServMgt.ContainerDetail(TempContainerDetail) then
            ReturnValue := true
        else begin
            SendErrorToNavSupport(ContainerDetailsLbl);
            Error(ImportErr, ContainerDetailsLbl);
        end;
    end;

    local procedure GetForecast(BudgetName: Code[50]; StartingDate: Date; var HQForecast: XmlPort "HQ Forecast")
    begin
        // HQ is reading forecast direct in the sql database via a sql-view.
        if ZGT.IsRhq then;
    end;

    procedure SendForecast(BudgetName: Code[10]; PeriodStartDate: Date; PeriodEndDate: Date; LastUpdate: Boolean; HQForecast: XmlPort "HQ Forecast"): Boolean
    var
        recItemBudgetEntryTmp: Record "Item Budget Entry" temporary;
        lText001: Label '"Budget Name" %1 is not accepted.';
        lText002: Label 'If "Budget Name" is %1, then "Period Start Date" must be blank.';
        lText003: Label 'Check PeriodStartDate: "%1" and PeriodEndDate: "%2".';
    begin
        if ZGT.IsRhq then begin
            if (BudgetName <> 'PREVIOUS') and
               (BudgetName <> 'FORECAST') and
               (BudgetName <> 'MASTER')
            then
                Error(lText001, BudgetName);

            if BudgetName = 'PREVIOUS' then begin
                if PeriodStartDate <> 0D then
                    Error(lText002, BudgetName);
            end else  // FORECAST and MASTER
                if (PeriodEndDate - PeriodStartDate < 0) or (PeriodEndDate - PeriodStartDate > 31) then
                    Error(lText003, PeriodStartDate, PeriodEndDate);

            HQForecast.Import();
            HQForecast.GetData(recItemBudgetEntryTmp);
            exit(ZyHqWebServMgt.Forecast(BudgetName, PeriodStartDate, PeriodEndDate, LastUpdate, recItemBudgetEntryTmp));
        end;
    end;

    procedure GetSerialNo(SourceType: Code[10]; SourceNo: Code[20]; var SerialNos: XmlPort "HQ Serial No.")
    begin
        SerialNos.GetData(SourceType, SourceNo);
    end;

    procedure SendSerialNoStatus(SourceType: Code[10]; SourceNo: Code[20]; Accepted: Boolean)
    var
        recSalesInvHead: Record "Sales Invoice Header";
        recTransRcptHead: Record "Transfer Receipt Header";
    begin
        case SourceType of
            'SALE':
                begin
                    if recSalesInvHead.Get(SourceNo) then begin
                        if Accepted then
                            recSalesInvHead."Serial Numbers Status" := recSalesInvHead."serial numbers status"::Accepted
                        else
                            recSalesInvHead."Serial Numbers Status" := recSalesInvHead."serial numbers status"::Rejected;
                        recSalesInvHead.Modify();
                    end;
                end;
            'TRANSFER':
                begin
                    if recTransRcptHead.Get(SourceNo) then begin
                        if Accepted then
                            recTransRcptHead."Serial Numbers Status" := recTransRcptHead."serial numbers status"::Accepted
                        else
                            recTransRcptHead."Serial Numbers Status" := recTransRcptHead."serial numbers status"::Rejected;
                        recTransRcptHead.Modify();
                    end;
                end;
        end;
    end;

    procedure SendUnshippedQuantity(HqCompany: Code[4]; UnshippedQuantitys: XmlPort "HQ Unshipped Quantity") ReturnValue: Boolean
    var
        //TempPurchLine: Record "Purchase Line" temporary;
        TempUnshipPurchOrder: Record "Unshipped Purchase Order" temporary;
        VendorType: Enum VendorType;
        UnshippedQuantityLbl: Label 'Unshipped Quantity';
    begin
        UnshippedQuantitys.Import();
        UnshippedQuantitys.GetData(TempUnshipPurchOrder);

        case HqCompany of
            'ZCOM':
                VendorType := VendorType::ZCom;
            'ZNET':
                VendorType := VendorType::ZNet;
        end;

        if ZyHqWebServMgt.UnshippedPurchaseOrder(TempUnshipPurchOrder, VendorType) then
            ReturnValue := true
        else begin
            SendErrorToNavSupport(UnshippedQuantityLbl);
            Error(ImportErr, UnshippedQuantityLbl);
        end;
    end;

    procedure SendSalesOrder(SalesOrders: XmlPort "HQ Sales Order"): Boolean
    var
        recSalesHeadTmp: Record "Sales Header" temporary;
        recSalesLineTmp: Record "Sales Line" temporary;
    begin
        if ZGT.IsRhq then begin
            SalesOrders.Import();
            SalesOrders.GetData(recSalesHeadTmp, recSalesLineTmp);
            exit(ZyHqWebServMgt.CreateSalesOrder(recSalesHeadTmp, recSalesLineTmp));
        end;
    end;

    procedure SendPurchasePrice(PurchsePrices: XmlPort "HQ Purchase Price") rValue: Boolean
    var
        recPurchPriceTmp: Record "Price List Line" temporary;
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
        ProcessEMEAPurchasePrice: Codeunit "Process EMEA Purchase Price";
        lText001: Label 'An error occured running "Send Purchase Price".<br>Run "Process EMEA Purchase Price" manually.';
    begin
        if ZGT.IsRhq or (ZGT.IsZComCompany and (ZGT.CompanyNameIs(9) or ZGT.CompanyNameIs(14))) then begin
            //>> 05-12-19 ZY-LD 006
            PurchsePrices.Import();
            PurchsePrices.GetData(recPurchPriceTmp);
            rValue := ZyHqWebServMgt.PurchasePrice(recPurchPriceTmp);
            if rValue then begin
                Commit();
                if not ProcessEMEAPurchasePrice.Run then
                    SendErrorToNavSupport(lText001);
            end;
            //<< 05-12-19 ZY-LD 006
        end;
    end;

    procedure SendPurchasePriceOrder(PurchOrderLines: XmlPort "Update Purchase Price on Order") rValue: Boolean
    var
        recPurchLineTmp: Record "Purchase Line" temporary;
    begin
        if ZGT.IsRhq then begin
            //>> 10-02-20 ZY-LD 008
            PurchOrderLines.Import();
            PurchOrderLines.GetLines(recPurchLineTmp);
            rValue := ZyHqWebServMgt.PurchaseOrderLine(recPurchLineTmp);
            //<< 10-02-20 ZY-LD 008
        end;
    end;

    procedure SendSalesPrice(SalesPrices: XmlPort "HQ Sales Price") rValue: Boolean
    var
        recSalesPriceTmp: Record "Price List Line" temporary;
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
    begin
        if ZGT.IsRhq then begin
            SalesPrices.Import();
            SalesPrices.GetData(recSalesPriceTmp);
            rValue := ZyHqWebServMgt.SalesPrice(recSalesPriceTmp);
        end;
    end;

    local procedure SendErrorToNavSupport(pText: Text)
    var
        recServEnviron: Record "Server Environment";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
    begin
        //>> 13-02-19 ZY-LD 001
        if recServEnviron.ProductionEnvironment then begin
            SI.SetMergefield(100, pText);
            EmailAddMgt.CreateEmailWithBodytext('HQWEBSERR', CopyStr(GetLastErrorText, 1, 1000), '');
        end;
        //<< 13-02-19 ZY-LD 001
    end;

    procedure SendBatteryCertificate(BatteryCertificates: XmlPort "HQ Battery Certificate") rValue: Boolean
    var
        recBatCertTmp: Record "Battery Certificate" temporary;
    begin
        if ZGT.IsRhq then begin
            BatteryCertificates.Import();
            BatteryCertificates.GetData(recBatCertTmp);
            rValue := ZyHqWebServMgt.BatteryCertificate(recBatCertTmp);
        end;
    end;

    procedure SendCategory(HQCategory: XmlPort "HQ Category"): Boolean
    var
        recItemTmp: Record Item temporary;
        recHqDimTmp: Record SBU temporary;
    begin
        //>> 13-01-19 ZY-LD 007
        if ZGT.IsRhq then begin
            HQCategory.Import();
            HQCategory.GetData(recItemTmp, recHqDimTmp);
            exit(ZyHqWebServMgt.Category(recItemTmp, recHqDimTmp));
        end;
        //<< 13-01-19 ZY-LD 007
    end;

    procedure SendCurrencyExchangeRate(CurrencyExchangeRates: XmlPort "HQ Exchange Rate") rValue: Boolean
    var
        recCurrExchRateTmp: Record "Currency Exchange Rate" temporary;
        SI: Codeunit "Single Instance";
    begin
        if ZGT.IsRhq and ZGT.IsZComCompany then begin
            SI.SetWebServiceUpdate(true);
            CurrencyExchangeRates.Import();
            CurrencyExchangeRates.GetData(recCurrExchRateTmp);
            rValue := ZyHqWebServMgt.CurrencyExchangeRate(recCurrExchRateTmp);
            SI.SetWebServiceUpdate(false);
        end;
    end;

    procedure SendECommerceOrder(eCommerceOrders: XmlPort "HQ eCommerce Order") rValue: Boolean
    var
        recAmzHeadTmp: Record "eCommerce Order Header" temporary;
        recAmzLineTmp: Record "eCommerce Order Line" temporary;
    begin
        if ZGT.IsRhq and ZGT.IsZNetCompany then begin
            eCommerceOrders.Import();
            eCommerceOrders.GetData(recAmzHeadTmp, recAmzLineTmp);
            rValue := ZyHqWebServMgt.eCommerceOrder(recAmzHeadTmp, recAmzLineTmp);
        end;
    end;

    procedure SendECommercePayment(eCommercePayments: XmlPort "HQ ECommerce Payment") rValue: Boolean
    var
        recAmzHeadTmp: Record "eCommerce Payment Header" temporary;
        recAmzLineTmp: Record "eCommerce Payment" temporary;
    begin
        if ZGT.IsRhq and ZGT.IsZNetCompany then begin
            rValue := eCommercePayments.Import();
            eCommercePayments.GetData(recAmzHeadTmp, recAmzLineTmp);
            rValue := ZyHqWebServMgt.eCommercePayment(recAmzHeadTmp, recAmzLineTmp);
        end;
    end;

    procedure SendeCommerceOrderValidation(eCommerceOrders: XmlPort "HQ eCommerce Order") rValue: Boolean
    var
        ServerEnviron: Record "Server Environment";
    begin
        //>> 17-07-24 ZY-LD 002            
        if ZGT.IsRhq and ZGT.IsZNetCompany then begin
            eCommerceOrders.Import();
            rValue := eCommerceOrders.ValidateOrder;
        end;
        //<< 17-07-24 ZY-LD 002        
    end;


    local procedure SendErmaDeliveryNote(DeliveryNotes: XmlPort "HQ eRMA Delivery Note"): Boolean
    var
        recDelNoteHeadTmp: Record "Sales Shipment Header" temporary;
        recDelNoteLineTmp: Record "Sales Shipment Line" temporary;
    begin
        if ZGT.TurkishServer and ZGT.IsZComCompany then begin
            DeliveryNotes.Import();
            DeliveryNotes.GetData(recDelNoteHeadTmp, recDelNoteLineTmp);
            exit(ZyHqWebServMgt.eRMADeliveryNote(recDelNoteHeadTmp, recDelNoteLineTmp));
        end;
    end;

    procedure GetAccountReceivable(var AccountReceivables: XmlPort "HQ Account Receivable")
    begin
        AccountReceivables.SetData();
        AccountReceivables.Export();
    end;

    procedure GetZyxelStoreInventory(var Items: XmlPort "HQ Zyxel Store Inventory")
    var
        ZGT: Codeunit "ZyXEL General Tools";
        ServerEnviron: Record "Server Environment";
    begin
        if ZGT.IsRhq() and ZGT.IsZNetCompany() then begin
            Items.Import();
            Items.ProcessData();
            Items.Export();
        end;
    end;

    procedure SendMarginApprovalResponse(EMEACompanyName: Text[20]; var Responses: XmlPort "HQ Margin Approval Response"): Boolean
    var
        lText001: Label '"%1" does not match current company name "%2".';
    begin
        If CompanyName <> EMEACompanyName then
            Error(lText001, EMEACompanyName, CompanyName);
        Responses.Import();
        Responses.ProcessData();
        exit(true);
    end;

    procedure SendEtaDateUpdate(Lines: XmlPort "HQ ETA Update"): Boolean
    begin
        Lines.Import();
        Lines.UpdateData();
        exit(true);
    end;

    local procedure GetPurchaseOrder(SourceType: Code[10]; SourceNo: Code[20]; var PurchaseOrders: XmlPort "HQ Purchase Order")
    begin
        if ZGT.IsRhq then
            PurchaseOrders.GetData(SourceType, SourceNo);
    end;

    local procedure SendPurchaseOrderStatus(PurchaseOrdersStatus: XmlPort "HQ Purchase Order Status")
    var
        recPurchHead: Record "Purchase Header";
    begin
        if ZGT.IsRhq then
            PurchaseOrdersStatus.SetData();
    end;
}
