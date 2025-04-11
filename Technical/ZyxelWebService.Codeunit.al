codeunit 50082 "Zyxel Web Service"
{
    // 001. 11-04-19 ZY-LD P0217 - Get Sales Invoice No.
    // 002. 17-07-19 PAB Fixed Get Company Information
    // 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 003. 19-08-19 ZY-LD 2019072910000095 - Filter on DE and TR customers.
    // 004. 27-08-19 ZY-LD 2019072910000095 - Filter on Related Company.
    // 005. 05-12-19 ZY-LD P0334 - Update Purchase Price.
    // 006. 18-02-22 ZY-LD P0747 - Handle Charge (Item).
    Permissions = tabledata "Sales Invoice Header" = m;

    trigger OnRun()
    begin
    end;

    var
        ZyWsMgt: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SendItems(Items: XmlPort "WS Replicate Item"): Boolean
    var
        recItemsTmp: Record Item temporary;
        recItemUOMTmp: Record "Item Unit of Measure" temporary;
        recDefDimTmp: Record "Default Dimension" temporary;
    begin
        Items.Import;
        Items.ReplicateData;
        exit(true);
    end;


    procedure SendCustomers(Customers: XmlPort "WS Replicate Customer"): Boolean
    var
        recCustTmp: Record Customer temporary;
        recDefDimTmp: Record "Default Dimension" temporary;
        recShipToAddTmp: Record "Ship-to Address";
    begin
        Customers.Import;
        Customers.ReplicateData;
        exit(true);
    end;


    procedure SendGlAccounts(GlAccounts: XmlPort "WS Replicate G/L Account"): Boolean
    var
        recGlAccTmp: Record "G/L Account" temporary;
    begin
        GlAccounts.Import;
        GlAccounts.ReplicateData;
        exit(true);
    end;


    procedure SendEmailAddress(EmailAddresses: XmlPort "WS Replicate E-mail Address"): Boolean
    begin
        EmailAddresses.Import;
        EmailAddresses.ReplicateData;
        exit(true);
    end;


    procedure SendSalesPrices(StartDate: Text[20]; SalesPrices: XmlPort "WS Replicate Sales Price"): Boolean
    var
        lStartDate: Date;
    begin
        Evaluate(lStartDate, StartDate);
        SalesPrices.Import;
        SalesPrices.ReplicateData(lStartDate);
        exit(true);
    end;


    procedure SendCostTypes(CostTypes: XmlPort "WS Replicate Cost Type Name"): Boolean
    var
        recCostTypeTmp: Record "Cost Type Name" temporary;
    begin
        CostTypes.Import;
        CostTypes.ReplicateData;
        exit(true);
    end;


    procedure SendTariffNames(TariffNames: XmlPort "WS Replicate Tariff Number"): Boolean
    var
        recTariffNoTmp: Record "Tariff Number" temporary;
    begin
        TariffNames.Import;
        TariffNames.ReplicateData;
        exit(true);
    end;


    procedure SendDimensionValues(DimensionValues: XmlPort "WS Replicate Dimension Value"): Boolean
    var
        recDimValueTmp: Record "Dimension Value" temporary;
    begin
        DimensionValues.Import;
        DimensionValues.ReplicateData;
        exit(true);
    end;


    procedure SendSalesPersons(SalesPersons: XmlPort "WS Replicate Sales Person"): Boolean
    var
        recSalesPersonTmp: Record "Salesperson/Purchaser" temporary;
    begin
        SalesPersons.Import;
        SalesPersons.ReplicateData;
        exit(true);
    end;


    procedure SendIcDimensions(IcDimensionValues: XmlPort "WS Replicate Ic Dim. Value"): Boolean
    var
        recIcDimValueTmp: Record "IC Dimension Value" temporary;
    begin
        IcDimensionValues.Import;
        IcDimensionValues.ReplicateData;
        exit(true);
    end;


    procedure SendICOutboxToICInbox(var ICInboxTransactions: XmlPort "WS IC Inbox Transaction"): Boolean
    var
        recICInboxTransTmp: Record "IC Inbox Transaction" temporary;
    begin
        ICInboxTransactions.Import;
        ICInboxTransactions.ReplicateData;
        exit(true);
    end;


    procedure SendIcInboxPurchHeader(IcInboxPurchaseHeaders: XmlPort "WS Intercompany"): Boolean
    var
        recICInboxPurchaseHeaderTmp: Record "IC Inbox Purchase Header" temporary;
        recICInboxPurchaseLineTmp: Record "IC Inbox Purchase Line" temporary;
    begin
        IcInboxPurchaseHeaders.Import;
        IcInboxPurchaseHeaders.ReplicateData;
        exit(true);
    end;


    // procedure SendPermissions(Permission: XmlPort "WS Replicate Permissions"): Boolean
    // begin
    //     Permission.Import;
    //     Permission.ReplicateData;
    //     exit(true);
    // end;


    procedure SendUserSetups(UserSetup: XmlPort "WS Replicate User Setup"): Boolean
    begin
        UserSetup.Import;
        UserSetup.ReplicateData;
        exit(true);
    end;


    procedure SendSalesOrders(var SalesOrders: XmlPort "WS Sales Order"): Boolean
    begin
        SalesOrders.Import;
        SalesOrders.InsertData;
        exit(true);
    end;


    procedure SendSalesOrdersFrance(var SalesOrdersFR: XmlPort "FR Sales Order"): Boolean
    begin
        SalesOrdersFR.Import;
        SalesOrdersFR.CreateSalesOrder;
        exit(true);
    end;


    procedure SendUnshippedQuantity(UnshippedQuantitys: XmlPort "WS Unshipped Quantity") ReturnValue: Boolean
    var
        //TempPurchLine: Record "Purchase Line" temporary;
        TempUnshipPurchOrder: record "Unshipped Purchase Order" temporary;
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
    begin
        if ZGT.IsRhq() then begin
            UnshippedQuantitys.Import();
            UnshippedQuantitys.GetData(TempUnshipPurchOrder);
            ReturnValue := ZyHqWebServMgt.UnshippedPurchaseOrder(TempUnshipPurchOrder, VendorType::EMEA);
        end;
    end;

    procedure SendContainerDetail(ContainerDetails: XmlPort "WS Container Detail") rValue: Boolean
    var
        recContainerDetailTmp: Record "VCK Shipping Detail" temporary;
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
    begin
        if ZGT.IsRhq then begin
            ContainerDetails.Import;
            ContainerDetails.GetData(recContainerDetailTmp);
            rValue := ZyHqWebServMgt.ContainerDetail(recContainerDetailTmp);
        end;
    end;


    procedure SendPurchasePrice(PurchsePrices: XmlPort "HQ Purchase Price") rValue: Boolean
    var
        recPurchPriceTmp: Record "Price List Line" temporary;
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
    begin
        if ZGT.IsRhq then begin
            //>> 05-12-19 ZY-LD 005
            PurchsePrices.Import;
            PurchsePrices.GetData(recPurchPriceTmp);
            rValue := ZyHqWebServMgt.PurchasePrice(recPurchPriceTmp);
            //<< 05-12-19 ZY-LD 005
        end;
    end;


    procedure SendSalesPrice(SalesPrices: XmlPort "HQ Sales Price") rValue: Boolean
    var
        recSalesPriceTmp: Record "Price List Line" temporary;
        ZyHqWebServMgt: Codeunit "Zyxel HQ Web Service Mgt.";
    begin
        if ZGT.IsRhq then begin
            SalesPrices.Import;
            SalesPrices.GetData(recSalesPriceTmp);
            rValue := ZyHqWebServMgt.SalesPrice(recSalesPriceTmp);
        end;
    end;


    procedure SendTravelExpense(Automation: Boolean; TravelExpenses: XmlPort "WS Travel Expense"): Boolean
    begin
        TravelExpenses.Import;
        exit(TravelExpenses.InsertData(Automation));
    end;


    procedure SendUseOfReport(UseOfReports: XmlPort "WS Use of Report"): Boolean
    begin
        //>> 16-10-20 ZY-LD 006
        UseOfReports.Import;
        UseOfReports.InsertData;
        exit(true);
        //<< 16-10-20 ZY-LD 006
    end;


    procedure GetICVendorNo(ICPartnerCode: Code[20]): Code[20]
    var
        recICPartner: Record "IC Partner";
    begin
        // If Italian or Tyrkish server, IC Partner table must be 50015.
        if recICPartner.Get(ICPartnerCode) then
            exit(recICPartner."Vendor No.");
    end;


    procedure GetCustomerCreditLimit(var Customers: XmlPort "WS Customer Credit Limit"; ZNetCompany: Boolean)
    var
        recCust: Record Customer;
    begin
        //>> 11-07-24 ZY-LD 000
        // //>> 19-08-19 ZY-LD 003
        // if ZNetCompany then begin
        //     if ZGT.CompanyNameIs(11) or ZGT.TurkishServer then  // ZyND DE |ZyND TR
        //         recCust.SetRange("No.", '200000', '299999')
        // end else
        //     recCust.SetFilter("No.", '<%1|>%2', '200000', '299999');
        // //<< 19-08-19 ZY-LD 003
        // recCust.SetFilter("Balance Due (LCY)", '<>0');
        // recCust.SetRange("Related Company", false);  // 27-08-19 ZY-LD 004
        // Customers.SetTableView(recCust);
        Customers.SetData();  //<< 11-07-24 ZY-LD 000
        Customers.Export;
    end;


    procedure GetAccountPayable(var AccountPayables: XmlPort "WS Account Pay./Receiv")
    var
        recCust: Record Customer;
    begin
        AccountPayables.Import;
        AccountPayables.SetDataPayable;
        AccountPayables.Export;
    end;


    procedure GetAccountReceivable(var AccountReceivables: XmlPort "WS Account Pay./Receiv")
    var
        recCust: Record Customer;
    begin
        AccountReceivables.Import;
        AccountReceivables.SetDataReceivable;
        AccountReceivables.Export;
    end;


    procedure GetCustomerBalance(CustNo: Code[20]; DueDate: Date; ShowOpenPayments: Boolean) rValue: Decimal
    var
        CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
        recCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntryRemainAmtQuery.SetRange(Customer_No, CustNo);
        CustLedgEntryRemainAmtQuery.SetRange(IsOpen, true);
        if ShowOpenPayments then
            CustLedgEntryRemainAmtQuery.SetFilter(Document_Type, '%1|%2', recCustLedgerEntry."document type"::Payment, recCustLedgerEntry."document type"::Refund)
        else
            CustLedgEntryRemainAmtQuery.SetFilter(Due_Date, '<%1', DueDate);
        CustLedgEntryRemainAmtQuery.Open;

        if CustLedgEntryRemainAmtQuery.Read then
            rValue := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;


    procedure GetSalesInvoiceNo(pSalesInvNo: Code[20]): Code[20]
    var
        recSalesInvHead: Record "Sales Invoice Header";
    begin
        //>> 11-04-19 ZY-LD 001
        if ZGT.TurkishServer then begin
            recSalesInvHead.SetCurrentkey("Your Reference");
            recSalesInvHead.SetRange("Your Reference", pSalesInvNo);
        end else begin
            recSalesInvHead.SetCurrentkey("Sell-to Customer No.", "External Document No.");
            recSalesInvHead.SetRange("External Document No.", pSalesInvNo);
        end;

        if recSalesInvHead.FindFirst() then
            exit(recSalesInvHead."No.");
        //<< 11-04-19 ZY-LD 001
    end;


    procedure GetIcReconciliation(ICReconciliation: XmlPort "IC Reconciliation") rValue: Text
    var
        RepCurrCode: Code[10];
    begin
        ICReconciliation.Import;
        rValue := ICReconciliation.GetData;
    end;


    // procedure GetConcurVendor(VendorNo: Code[20];var Vendors: XmlPort "WS Concur Vendors")
    // begin
    //     Vendors.SetData_WebService(VendorNo);
    //     Vendors.Export;
    // end;


    procedure GetConcurValidation(SourceTable: Integer; SourceFieldNo: Integer; SourceCode: Code[20]) rValue: Boolean
    var
        recGLAcc: Record "G/L Account";
        recItemCharge: Record "Item Charge";
    begin
        case SourceTable of
            Database::"G/L Account":
                begin
                    recGLAcc.Get(SourceCode);
                    case SourceFieldNo of
                        recGLAcc.FieldNo("Gen. Prod. Posting Group"):
                            if recGLAcc."Gen. Prod. Posting Group" <> '' then
                                rValue := true;
                    end;
                end;
            //>> 18-02-22 ZY-LD 006
            Database::"Item Charge":
                begin
                    recItemCharge.Get(SourceCode);
                    case SourceFieldNo of
                        recItemCharge.FieldNo("Gen. Prod. Posting Group"):
                            if recItemCharge."Gen. Prod. Posting Group" <> '' then
                                rValue := true;
                    end;
                end;
        //<< 18-02-22 ZY-LD 006
        end;
    end;


    // procedure SendConcurVendor(var Vendors: XmlPort "WS Concur Vendors") rValue: Code[20]
    // begin
    //     Vendors.Import;
    //     rValue := Vendors.ReplicateVendor;
    // end;


    // procedure SendConcurPurchaseDocument(PurchaseDocuments: XmlPort "WS Concur Purchase Document"): Boolean
    // begin
    //     PurchaseDocuments.Import;
    //     PurchaseDocuments.InsertData;
    //     exit(true);
    // end;


    procedure ProcessHQSalesDocument(): Boolean
    begin
        Codeunit.Run(Codeunit::"HQ Sales Document Download");
        exit(true);
    end;


    procedure ProcesseCommerceOrders(ImportOrders: Boolean; PostOrders: Boolean): Boolean
    var
        recSalesHead: Record "Sales Header";
        eCommerceApiMgt: Codeunit "API Management";
        BatchPosteCommerceOrders: Report "Batch Post eCommerce Orders";
        BatchPostSalesInvoices: Report "Batch Post Sales Invoices";
        BatchPostSalesCreditMemos: Report "Batch Post Sales Credit Memos";
    begin
        // If invoices has been created, but not posted we post them before we import the next.
        if PostOrders then begin
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::Invoice);
            recSalesHead.SetRange("eCommerce Order", true);
            if recSalesHead.FindFirst() then begin
                BatchPostSalesInvoices.SetTableView(recSalesHead);
                BatchPostSalesInvoices.UseRequestPage(false);
                BatchPostSalesInvoices.RunModal;
            end;

            recSalesHead.SetRange("Document Type", recSalesHead."document type"::"Credit Memo");
            recSalesHead.SetRange("eCommerce Order", true);
            if recSalesHead.FindFirst() then begin
                BatchPostSalesCreditMemos.SetTableView(recSalesHead);
                BatchPostSalesCreditMemos.UseRequestPage(false);
                BatchPostSalesCreditMemos.RunModal;
            end;
        end;

        if ImportOrders then
            eCommerceApiMgt.Run;

        if PostOrders then begin
            Clear(BatchPosteCommerceOrders);
            BatchPosteCommerceOrders.InitReport(PostOrders, Today, true, false);
            BatchPosteCommerceOrders.UseRequestPage(false);
            BatchPosteCommerceOrders.RunModal;
        end;

        exit(true);
    end;


    procedure ProcessSiiSpain(): Boolean
    begin
        Codeunit.Run(Codeunit::"Process SII Spain");
        exit(true);
    end;


    // procedure VendorCreatedInConcur(CompanyName: Text[30]; VendorNo: Code[20]) rValue: Boolean
    // var
    //     recConcVendComp: Record "Concur Vendor Company";
    // begin
    //     recConcVendComp.SetCurrentkey("Company Name", "Vendor No.");
    //     recConcVendComp.SetRange("Company Name", CompanyName);
    //     recConcVendComp.SetRange("Vendor No.", VendorNo);
    //     rValue := recConcVendComp.FindFirst;
    // end;


    procedure SendSalesInvoiceNo(pRHQSalesInvNo: Code[20]; pSubSalesInvNo: Code[20]): Boolean
    var
        recSalesInvHead: Record "Sales Invoice Header";
    begin
        //>> 11-04-19 ZY-LD 001
        if recSalesInvHead.Get(pRHQSalesInvNo) then begin
            recSalesInvHead."Invoice No. for End Customer" := pSubSalesInvNo;
            recSalesInvHead.Modify();
            exit(true);
        end;
        //<< 11-04-19 ZY-LD 001
    end;


    procedure SendItemBudgetEntry(pItemBudgetEntries: XmlPort ItemBudgetEntries): Boolean
    begin
        pItemBudgetEntries.Import;
        pItemBudgetEntries.ReplicateData;
        exit(true);
    end;


    procedure SendExchangeRate(ExchangeRates: XmlPort "WS Replicate Exchange Rate"): Boolean
    begin
        ExchangeRates.Import;
        ExchangeRates.ReplicateData;
        exit(true);
    end;


    procedure GetExchangeRate(var ExchangeRates: XmlPort "WS Replicate Exchange Rate")
    begin
        ExchangeRates.Import;
        ExchangeRates.SetData_Response;
        ExchangeRates.Export;
    end;


    procedure SendPhasesPurchaseOrder(PurchaseOrders: XmlPort "PH Purchase Order"): Boolean
    begin
        PurchaseOrders.Import;
        PurchaseOrders.InsertData;
        exit(true);
    end;
}
