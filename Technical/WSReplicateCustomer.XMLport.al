xmlport 50036 "WS Replicate Customer"
{
    // 001. 02-11-18 ZY-LD 2018103110000111 - Variables for the subs.
    // 002. 27-11-18 ZY-LD 2018112710000074 - New fields. Italy SDI.
    // 003. 08-04-19 ZY-LD 2019040810000139 - In Italy, we don't need the invoice and credit memo. lines.
    // 004. 27-05-19 ZY-LD P0213 - Force replication.
    // 005. 12- 07-19 ZY-LD P0213 - Customer No. is added to the filter.
    // 006. 27-09-19 PAB 2019092710000068 - Added se Currency Code from Sales Document
    // 007. 31-03-20 ZY-LD 000 - Replicate Cross Reference.
    // 008. 28-05-20 ZY-LD 2020052710001357 - Intercompany Purchase must be set in ZyND DK.
    // 009. 09-07-20 ZY-LD 2020070910000021 - Only insert, if the item no. exists.
    // 010. 10-08-20 ZY-LD 2020081010000081 - Transfer Shipment Method.
    // 011. 03-02-21 ZY-LD P0557 - Sample Setup. We don´t want to replicate the sub companies.
    // 012. 15-09-21 ZY-LD 2021091310000081 - ExtDocNoTranslation is added.
    // 013. 07-02-22 ZY-LD 2022012510000105 - Intercompany Purchase
    // 014. 07-03-23 ZY-LD #3412853 - "Ship-to Address" can be local created or it can be used on a sales order.
    // 015. 03-05-23 ZY-LD 000 - We don´t delete if it´s part of sales head.
    // 016. 07-06-23 ZY-LD 000 - Source Type for "Related Company" was in Q4-21 set to text. I don´t know why, but it has been set back to field so the value will be replicated.
    // 017. 16-02-24 ZY-LD 000 - Sales Person is transferred to sub.
    // 018. 28-02-24 ZY-LD 000 - Due to Italian Electronic Invoice, the currency code must be blank.

    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement(Customer; Customer)
            {
                MinOccurs = Zero;
                XmlName = 'Customer';
                UseTemporary = true;
                fieldelement(No; Customer."No.")
                {
                }
                fieldelement(Name; Customer.Name)
                {
                }
                fieldelement(SearchName; Customer."Search Name")
                {
                }
                fieldelement(Name2; Customer."Name 2")
                {
                }
                fieldelement(Address; Customer.Address)
                {
                }
                fieldelement(Address2; Customer."Address 2")
                {
                }
                fieldelement(City; Customer.City)
                {
                }
                fieldelement(Contact; Customer.Contact)
                {
                }
                fieldelement(PhoneNo; Customer."Phone No.")
                {
                }
                fieldelement(TelexNo; Customer."Telex No.")
                {
                }
                fieldelement(DocumentSendingProfile; Customer."Document Sending Profile")
                {
                }
                fieldelement(OurAccountNo; Customer."Our Account No.")
                {
                }
                fieldelement(TerritoryCode; Customer."Territory Code")
                {
                }
                fieldelement(GlobalDimension1Code; Customer."Global Dimension 1 Code")
                {
                }
                fieldelement(GlobalDimension2Code; Customer."Global Dimension 2 Code")
                {
                }
                fieldelement(ChainName; Customer."Chain Name")
                {
                }
                fieldelement(BudgetedAmount; Customer."Budgeted Amount")
                {
                }
                fieldelement(CreditLimitLCY; Customer."Credit Limit (LCY)")
                {
                }
                fieldelement(CustomerPostingGroup; Customer."Customer Posting Group")
                {
                }
                fieldelement(CurrencyCode; Customer."Currency Code")
                {
                }
                fieldelement(CustomerPriceGroup; Customer."Customer Price Group")
                {
                }
                fieldelement(LanguageCode; Customer."Language Code")
                {
                }
                fieldelement(StatisticsGroup; Customer."Statistics Group")
                {
                }
                fieldelement(PaymentTermsCode; Customer."Payment Terms Code")
                {
                }
                fieldelement(FinChargeTermsCode; Customer."Fin. Charge Terms Code")
                {
                }
                fieldelement(SalespersonCode; Customer."Salesperson Code")
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                fieldelement(OrderDeskResponsible; Customer."Order Desk Resposible Code")
                {
                    MinOccurs = Zero; //24-11-2025 BK #528108
                    MaxOccurs = Once;
                }
                fieldelement(ShipmentMethodCode; Customer."Shipment Method Code")
                {
                    FieldValidate = yes;
                }
                fieldelement(ShippingAgentCode; Customer."Shipping Agent Code")
                {
                }
                fieldelement(PlaceofExport; Customer."Place of Export")
                {
                }
                fieldelement(InvoiceDiscCode; Customer."Invoice Disc. Code")
                {
                }
                fieldelement(CustomerDiscGroup; Customer."Customer Disc. Group")
                {
                }
                fieldelement(CountryRegionCode; Customer."Country/Region Code")
                {
                }
                fieldelement(CollectionMethod; Customer."Collection Method")
                {
                }
                fieldelement(Blocked; Customer.Blocked)
                {
                }
                fieldelement(InvoiceCopies; Customer."Invoice Copies")
                {
                }
                fieldelement(LastStatementNo; Customer."Last Statement No.")
                {
                }
                fieldelement(PrintStatements; Customer."Print Statements")
                {
                }
                fieldelement(BilltoCustomerNo; Customer."Bill-to Customer No.")
                {
                }
                fieldelement(Priority; Customer.Priority)
                {
                }
                fieldelement(PaymentMethodCode; Customer."Payment Method Code")
                {
                }
                fieldelement(LastDateModified; Customer."Last Date Modified")
                {
                }
                fieldelement(ApplicationMethod; Customer."Application Method")
                {
                }
                fieldelement(PricesIncludingVAT; Customer."Prices Including VAT")
                {
                }
                fieldelement(LocationCode; Customer."Location Code")
                {
                }
                fieldelement(FaxNo; Customer."Fax No.")
                {
                }
                fieldelement(TelexAnswerBack; Customer."Telex Answer Back")
                {
                }
                fieldelement(VATRegistrationNo; Customer."VAT Registration No.")
                {
                }
                fieldelement(CombineShipments; Customer."Combine Shipments")
                {
                }
                fieldelement(GenBusPostingGroup; Customer."Gen. Bus. Posting Group")
                {
                }
                fieldelement(GLN; Customer.GLN)
                {
                }
                fieldelement(PostCode; Customer."Post Code")
                {
                }
                fieldelement(County; Customer.County)
                {
                }
                fieldelement(EMail; Customer."E-Mail")
                {
                }
                fieldelement(HomePage; Customer."Home Page")
                {
                }
                fieldelement(ReminderTermsCode; Customer."Reminder Terms Code")
                {
                }
                fieldelement(NoSeries; Customer."No. Series")
                {
                }
                fieldelement(TaxAreaCode; Customer."Tax Area Code")
                {
                }
                fieldelement(VATBusPostingGroup; Customer."VAT Bus. Posting Group")
                {
                }
                fieldelement(Reserve; Customer.Reserve)
                {
                }
                fieldelement(BlockPaymentTolerance; Customer."Block Payment Tolerance")
                {
                }
                fieldelement(ICPartnerCode; Customer."IC Partner Code")
                {
                }
                fieldelement(PrePaymentPct; Customer."Prepayment %")
                {
                }
                fieldelement(PartnerType; Customer."Partner Type")
                {
                }
                fieldelement(PreferredBankAccount; Customer."Preferred Bank Account Code")
                {
                }
                fieldelement(CashFlowPaymentTermsCode; Customer."Cash Flow Payment Terms Code")
                {
                }
                fieldelement(PrimaryContactNo; Customer."Primary Contact No.")
                {
                }
                fieldelement(ResponsibilityCenter; Customer."Responsibility Center")
                {
                }
                fieldelement(ShippingAdvice; Customer."Shipping Advice")
                {
                }
                fieldelement(ShippingTime; Customer."Shipping Time")
                {
                }
                fieldelement(ShippingAgentServiceCode; Customer."Shipping Agent Service Code")
                {
                }
                fieldelement(ServiceZoneCode; Customer."Service Zone Code")
                {
                }
                fieldelement(AllowLineDisc; Customer."Allow Line Disc.")
                {
                }
                fieldelement(BaseCalendarCode; Customer."Base Calendar Code")
                {
                }
                fieldelement(CopySelltoAddrtoQteFrom; Customer."Copy Sell-to Addr. to Qte From")
                {
                }
                fieldelement(RelatedCompany; Customer."Related Company")
                {
                }
                textelement(DoNotChangeBillTo)
                {
                }
                textelement(UseCurrencyFrom)
                {
                }
                fieldelement(ExclWeeRep; Customer."Exclude Wee Report")
                {
                }
                fieldelement(StatementType; Customer."Statement Type")
                {
                }
                fieldelement(ExclFromIntra; Customer."Exclude from Intrastat")
                {
                }
                fieldelement(VATRegistrationCode; Customer."VAT Registration Code")
                {
                }
                textelement(ActionCodeSource)
                {
                }
                fieldelement(TurkishCustNo; Customer."Turkish Customer No.")
                {
                }
                fieldelement(ForecastTerritory; Customer."Forecast Territory")
                {
                }
                fieldelement(IntercompanyPurchase; Customer."Intercompany Purchase")
                {
                }
                fieldelement(RegistrationNo; Customer."Registration No.")
                {
                }
                fieldelement(EmailStatemAdd; Customer."E-Mail Statement Address")
                {
                }
                fieldelement(EmailRemindAdd; Customer."E-Mail Reminder Address")
                {
                }
                fieldelement(EmailStatement; Customer."E-Mail Statement")
                {
                }
                fieldelement(EmailReminder; Customer."E-Mail Reminder")
                {
                }
                fieldelement(Category; Customer.Category)
                {
                }
                textelement(Tier)
                {
                }
                textelement(ParrentName)
                {
                }
                fieldelement(AvoidCreatInSub; Customer."Avoid Creation of SI in SUB")
                {
                }
                fieldelement(Subcompany; Customer."Sub company")
                {
                }
                fieldelement(TaxOfficeCode; Customer."Tax Office Code")
                {
                }
                fieldelement(UseEInvoice; Customer."Use E-Invoice")
                {
                }
                fieldelement(EInvoiceProfileID; Customer."E-Invoice Profile ID")
                {
                }
                fieldelement(AdminRef; Customer."Administration Reference")
                {
                }
                fieldelement(RecipientCode; Customer."Recipient Code")
                {
                }
                fieldelement(CustTipology; Customer."Customer Tipology")
                {
                }
                fieldelement(PecEmailAddress; Customer."Recipient PEC E-Mail")
                {
                }
                textelement(MarketSegment)
                {
                }
                fieldelement(ApprovalNoMustBeFilled; Customer."Approval No. must be Filled")
                {
                }
                textelement(SupervisorPassword)
                {
                }
                fieldelement(YourRefTranslation; Customer."Your Reference Translation")
                {
                }
                fieldelement(Active; Customer.Active)
                {
                }
                fieldelement(FiscalCode; Customer."Fiscal Code IT")
                {
                }
                // If you add more fields to the customer, remember to add the fields in local procedure "TransferFieldsCustomer" in the buttom.
                tableelement("Default Dimension"; "Default Dimension")
                {
                    MinOccurs = Zero;
                    XmlName = 'Dimension';
                    SourceTableView = where("Table ID" = const(18));
                    UseTemporary = true;
                    fieldelement(TableID; "Default Dimension"."Table ID")
                    {
                    }
                    fieldelement(DimNo; "Default Dimension"."No.")
                    {
                    }
                    fieldelement(DimCode; "Default Dimension"."Dimension Code")
                    {
                    }
                    fieldelement(DimValueCode; "Default Dimension"."Dimension Value Code")
                    {
                    }
                    fieldelement(ValuePosting; "Default Dimension"."Value Posting")
                    {
                    }
                    fieldelement(MultiSelectAction; "Default Dimension"."Multi Selection Action")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Default Dimension".SetRange("Table ID", 18);
                        "Default Dimension".SetRange("No.", Customer."No.");
                    end;
                }
                tableelement("Ship-to Address"; "Ship-to Address")
                {
                    MinOccurs = Zero;
                    XmlName = 'ShipToAddress';
                    UseTemporary = true;
                    fieldelement(StCustNo; "Ship-to Address"."Customer No.")
                    {
                    }
                    fieldelement(StCode; "Ship-to Address".Code)
                    {
                    }
                    fieldelement(StName; "Ship-to Address".Name)
                    {
                    }
                    fieldelement(StName2; "Ship-to Address"."Name 2")
                    {
                    }
                    fieldelement(StAdd; "Ship-to Address".Address)
                    {
                    }
                    fieldelement(StAdd2; "Ship-to Address"."Address 2")
                    {
                    }
                    fieldelement(StCity; "Ship-to Address".City)
                    {
                    }
                    fieldelement(StContact; "Ship-to Address".Contact)
                    {
                    }
                    fieldelement(StPhoneNo; "Ship-to Address"."Phone No.")
                    {
                    }
                    fieldelement(StTelexNo; "Ship-to Address"."Telex No.")
                    {
                    }
                    fieldelement(StShipMethod; "Ship-to Address"."Shipment Method Code")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(StShipAgent; "Ship-to Address"."Shipping Agent Code")
                    {
                    }
                    fieldelement(StPlaceOfExport; "Ship-to Address"."Place of Export")
                    {
                    }
                    fieldelement(StCountryRegion; "Ship-to Address"."Country/Region Code")
                    {
                    }
                    fieldelement(StLastDateMod; "Ship-to Address"."Last Date Modified")
                    {
                    }
                    fieldelement(StLocationCode; "Ship-to Address"."Location Code")
                    {
                    }
                    fieldelement(StFaxNo; "Ship-to Address"."Fax No.")
                    {
                    }
                    fieldelement(StTelexAnswer; "Ship-to Address"."Telex Answer Back")
                    {
                    }
                    fieldelement(StPostCode; "Ship-to Address"."Post Code")
                    {
                    }
                    fieldelement(StCounty; "Ship-to Address".County)
                    {
                    }
                    fieldelement(StEmail; "Ship-to Address"."E-Mail")
                    {
                    }
                    fieldelement(StHomePage; "Ship-to Address"."Home Page")
                    {
                    }
                    fieldelement(StTaxAreaCode; "Ship-to Address"."Tax Area Code")
                    {
                    }
                    fieldelement(StTaxLiable; "Ship-to Address"."Tax Liable")
                    {
                    }
                    fieldelement(StShipAgentServCode; "Ship-to Address"."Shipping Agent Service Code")
                    {
                    }
                    fieldelement(StSerivceZone; "Ship-to Address"."Service Zone Code")
                    {
                    }
                    textelement(StDelivZone)
                    {
                    }
                    textelement(StShipTime)
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Ship-to Address".SetRange("Customer No.", Customer."No.");
                    end;
                }
                tableelement("Custom Report Selection"; "Custom Report Selection")
                {
                    MinOccurs = Zero;
                    XmlName = 'CustomReportSelection';
                    UseTemporary = true;
                    fieldelement(CpsSourceType; "Custom Report Selection"."Source Type")
                    {
                    }
                    fieldelement(CpsSourceNo; "Custom Report Selection"."Source No.")
                    {
                    }
                    fieldelement(CpsUsage; "Custom Report Selection".Usage)
                    {
                    }
                    fieldelement(CpsSequence; "Custom Report Selection".Sequence)
                    {
                    }
                    fieldelement(CpsSendToEmail; "Custom Report Selection"."Send To Email")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Custom Report Selection".SetRange("Source Type", Database::Customer);
                        "Custom Report Selection".SetRange("Source No.", Customer."No.");
                    end;
                }
                tableelement("Item Cross Reference"; "Item Reference")
                {
                    LinkFields = "Reference Type No." = field("No.");
                    LinkTable = Customer;
                    MinOccurs = Zero;
                    XmlName = 'CrossReference';
                    SourceTableView = sorting("Reference Type", "Reference No.") where("Reference Type" = const("Item Reference Type"::Customer));
                    UseTemporary = true;
                    fieldelement(CrItemNo; "Item Cross Reference"."Item No.")
                    {
                    }
                    fieldelement(CrVariantCode; "Item Cross Reference"."Variant Code")
                    {
                    }
                    fieldelement(CrUoM; "Item Cross Reference"."Unit of Measure")
                    {
                    }
                    fieldelement(CrCrossReferenceType; "Item Cross Reference"."Reference Type")
                    {
                    }
                    fieldelement(CrCrossReferenceTypeNo; "Item Cross Reference"."Reference Type No.")
                    {
                    }
                    fieldelement(CrCrossReferenceNo; "Item Cross Reference"."Reference No.")
                    {
                    }
                    fieldelement(CrDescription; "Item Cross Reference".Description)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    "Ship-to Address".SetRange("Customer No.");
                end;
            }
            tableelement("Gen. Business Posting Group"; "Gen. Business Posting Group")
            {
                MinOccurs = Zero;
                XmlName = 'GenBudPostGrp';
                UseTemporary = true;
                fieldelement(GpgCode; "Gen. Business Posting Group".Code)
                {
                }
                fieldelement(GpgDescription; "Gen. Business Posting Group".Description)
                {
                }
                fieldelement(GpgPostingGrp; "Gen. Business Posting Group"."Def. VAT Bus. Posting Group")
                {
                }
                fieldelement(GpgAutoInsert; "Gen. Business Posting Group"."Auto Insert Default")
                {
                }
            }
            tableelement("General Posting Setup"; "General Posting Setup")
            {
                MinOccurs = Zero;
                XmlName = 'GenPostSetup';
                UseTemporary = true;
                fieldelement(GpsGenBusPostGrp; "General Posting Setup"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(GpsGenProdPostGrp; "General Posting Setup"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(GpsSalesAcc; "General Posting Setup"."Sales Account")
                {
                }
                fieldelement(GpsSalesLineDisc; "General Posting Setup"."Sales Line Disc. Account")
                {
                }
                fieldelement(GpsSalesInvDisc; "General Posting Setup"."Sales Inv. Disc. Account")
                {
                }
                fieldelement(GpsSalesPmtDisc; "General Posting Setup"."Sales Pmt. Disc. Debit Acc.")
                {
                }
                fieldelement(GpsPurchAcc; "General Posting Setup"."Purch. Account")
                {
                }
                fieldelement(GpsPurchLineDisc; "General Posting Setup"."Purch. Line Disc. Account")
                {
                }
                fieldelement(GpsPurchInvDisc; "General Posting Setup"."Purch. Inv. Disc. Account")
                {
                }
                fieldelement(GpsPurchPmtDisc; "General Posting Setup"."Purch. Pmt. Disc. Credit Acc.")
                {
                }
                fieldelement(GpsCogsAcc; "General Posting Setup"."COGS Account")
                {
                }
                fieldelement(GpsInvAdjAcc; "General Posting Setup"."Inventory Adjmt. Account")
                {
                }
                fieldelement(GpsSalesCrMemoAcc; "General Posting Setup"."Sales Credit Memo Account")
                {
                }
                fieldelement(GpsPurchCrMemoAcc; "General Posting Setup"."Purch. Credit Memo Account")
                {
                }
                fieldelement(GpsSalesPmtCredAcc; "General Posting Setup"."Sales Pmt. Disc. Credit Acc.")
                {
                }
                fieldelement(GpsPurchPmdDebAcc; "General Posting Setup"."Purch. Pmt. Disc. Debit Acc.")
                {
                }
                fieldelement(GpsSalesPmtDebAcc; "General Posting Setup"."Sales Pmt. Tol. Debit Acc.")
                {
                }
                fieldelement(GpsSalesPmtTolCreditAcc; "General Posting Setup"."Sales Pmt. Tol. Credit Acc.")
                {
                }
                fieldelement(GpsPurchPmtTolDebAcc; "General Posting Setup"."Purch. Pmt. Tol. Debit Acc.")
                {
                }
                fieldelement(GpsPurchPmtTolCreditAcc; "General Posting Setup"."Purch. Pmt. Tol. Credit Acc.")
                {
                }
                fieldelement(GpsSalesPrePayAcc; "General Posting Setup"."Sales Prepayments Account")
                {
                }
                fieldelement(GpsPurchPrePayAcc; "General Posting Setup"."Purch. Prepayments Account")
                {
                }
                fieldelement(GpsPurchFaDiscAcc; "General Posting Setup"."Purch. FA Disc. Account")
                {
                }
                fieldelement(GpsInvAccAccInterim; "General Posting Setup"."Invt. Accrual Acc. (Interim)")
                {
                }
                fieldelement(GpsCogsAccInterim; "General Posting Setup"."COGS Account (Interim)")
                {
                }
                fieldelement(GpsDirCostAppAcc; "General Posting Setup"."Direct Cost Applied Account")
                {
                }
                fieldelement(GpsOverhAppAcc; "General Posting Setup"."Overhead Applied Account")
                {
                }
                fieldelement(GpsPurchVariAcc; "General Posting Setup"."Purchase Variance Account")
                {
                }
            }
            tableelement("VAT Business Posting Group"; "VAT Business Posting Group")
            {
                MinOccurs = Zero;
                XmlName = 'VatBusPostGrp';
                UseTemporary = true;
                fieldelement(VpgCode; "VAT Business Posting Group".Code)
                {
                }
                fieldelement(VpgDescription; "VAT Business Posting Group".Description)
                {
                }
            }
            tableelement("VAT Posting Setup"; "VAT Posting Setup")
            {
                MinOccurs = Zero;
                XmlName = 'VatPostSetup';
                UseTemporary = true;
                fieldelement(VpsVatBusPostGrp; "VAT Posting Setup"."VAT Bus. Posting Group")
                {
                }
                fieldelement(VpsVatProdPostGrp; "VAT Posting Setup"."VAT Prod. Posting Group")
                {
                }
                fieldelement(VpsVatCalcType; "VAT Posting Setup"."VAT Calculation Type")
                {
                }
                fieldelement(VpsVatPct; "VAT Posting Setup"."VAT %")
                {
                }
                fieldelement(VpsUnrealVatType; "VAT Posting Setup"."Unrealized VAT Type")
                {
                }
                fieldelement(VpsAdjPayDisc; "VAT Posting Setup"."Adjust for Payment Discount")
                {
                }
                fieldelement(VpsSalesVatAcc; "VAT Posting Setup"."Sales VAT Account")
                {
                }
                fieldelement(VpsSalesVatUnrealAcc; "VAT Posting Setup"."Sales VAT Unreal. Account")
                {
                }
                fieldelement(VpsPurchVatAcc; "VAT Posting Setup"."Purchase VAT Account")
                {
                }
                fieldelement(VpsPurchVatUnrealAcc; "VAT Posting Setup"."Purch. VAT Unreal. Account")
                {
                }
                fieldelement(VpsRevCngVatAcc; "VAT Posting Setup"."Reverse Chrg. VAT Acc.")
                {
                }
                fieldelement(VpsRevCngVatUnrealAcc; "VAT Posting Setup"."Reverse Chrg. VAT Unreal. Acc.")
                {
                }
                fieldelement(VpsVatIdentifier; "VAT Posting Setup"."VAT Identifier")
                {
                }
                fieldelement(VpsEuService; "VAT Posting Setup"."EU Service")
                {
                }
                fieldelement(VpsClauseCode; "VAT Posting Setup"."VAT Clause Code")
                {
                }
                fieldelement(VpsCertifSupplyReq; "VAT Posting Setup"."Certificate of Supply Required")
                {
                }
                fieldelement(VpsTaxCategory; "VAT Posting Setup"."Tax Category")
                {
                }
                fieldelement(VpsEuArticle; "VAT Posting Setup"."EU Article Code")
                {
                }
            }
            tableelement("Customer Posting Group"; "Customer Posting Group")
            {
                MinOccurs = Zero;
                XmlName = 'CustPostGrp';
                UseTemporary = true;
                fieldelement(CpgCode; "Customer Posting Group".Code)
                {
                }
                fieldelement(CpgRecAcc; "Customer Posting Group"."Receivables Account")
                {
                }
                fieldelement(CpgServCharAcc; "Customer Posting Group"."Service Charge Acc.")
                {
                }
                fieldelement(CpgPayDiscDebAcc; "Customer Posting Group"."Payment Disc. Debit Acc.")
                {
                }
                fieldelement(CpgRoundAcc; "Customer Posting Group"."Invoice Rounding Account")
                {
                }
                fieldelement(CpgAddFeeAcc; "Customer Posting Group"."Additional Fee Account")
                {
                }
                fieldelement(CpgInterestAcc; "Customer Posting Group"."Interest Account")
                {
                }
                fieldelement(CpgDebCurAppRndAcc; "Customer Posting Group"."Debit Curr. Appln. Rndg. Acc.")
                {
                }
                fieldelement(CpgCredCurAppRndAcc; "Customer Posting Group"."Credit Curr. Appln. Rndg. Acc.")
                {
                }
                fieldelement(CpgDebRoundAcc; "Customer Posting Group"."Debit Rounding Account")
                {
                }
                fieldelement(CpgCredRoundAcc; "Customer Posting Group"."Credit Rounding Account")
                {
                }
                fieldelement(CpgPayDiscCredAcc; "Customer Posting Group"."Payment Disc. Credit Acc.")
                {
                }
                fieldelement(CpgPayTolDebAcc; "Customer Posting Group"."Payment Tolerance Debit Acc.")
                {
                }
                fieldelement(CpgPayTolCredAcc; "Customer Posting Group"."Payment Tolerance Credit Acc.")
                {
                }
                fieldelement(CpgAddFeeLineAcc; "Customer Posting Group"."Add. Fee per Line Account")
                {
                }
            }
            tableelement("Payment Terms"; "Payment Terms")
            {
                MinOccurs = Zero;
                XmlName = 'PaymentTerms';
                UseTemporary = true;
                fieldelement(PtCode; "Payment Terms".Code)
                {
                }
                textelement(PtDueDateCalc)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PtDueDateCalc := Format(PaymentTerms_DueDateCalculation);
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        if PtDueDateCalc <> '' then
                            if not Evaluate(PaymentTerms_DueDateCalculation, PtDueDateCalc) then
                                Clear(PaymentTerms_DueDateCalculation);
                    end;
                }
                textelement(PtDiscDateCalc)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PtDiscDateCalc := Format(PaymentTerms_DiscountDateCalculation);
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        if PtDiscDateCalc <> '' then
                            if not Evaluate(PaymentTerms_DiscountDateCalculation, PtDiscDateCalc) then
                                Clear(PaymentTerms_DiscountDateCalculation);

                    end;
                }
                textelement(PtDiscPct)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PtDiscPct := Format(PaymentTerms_DiscountPct);
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        if PtDiscPct <> '' then
                            if not Evaluate(PaymentTerms_DiscountPct, PtDiscPct) then
                                Clear(PaymentTerms_DiscountPct);

                    end;
                }
                fieldelement(PtDescript; "Payment Terms".Description)
                {
                }
                fieldelement(PtCalcPmtDisc; "Payment Terms"."Calc. Pmt. Disc. on Cr. Memos")
                {
                }
            }
            tableelement("Payment Method"; "Payment Method")
            {
                MinOccurs = Zero;
                XmlName = 'PaymentMethod';
                UseTemporary = true;
                fieldelement(PmCode; "Payment Method".Code)
                {
                }
                fieldelement(PmDescript; "Payment Method".Description)
                {
                }
                fieldelement(PmBalAccType; "Payment Method"."Bal. Account Type")
                {
                }
                fieldelement(PmBalAccNo; "Payment Method"."Bal. Account No.")
                {
                }
                // fieldelement(PmPaymentPro; "Payment Method"."Payment Processor")
                // {
                // }
                fieldelement(PmDirectDebit; "Payment Method"."Direct Debit")
                {
                }
                fieldelement(PmDirectDebPmt; "Payment Method"."Direct Debit Pmt. Terms Code")
                {
                }
                fieldelement(PmPmtExport; "Payment Method"."Pmt. Export Line Definition")
                {
                }
                // fieldelement(PmBankDataConv; "Payment Method"."Bank Data Conversion Pmt. Type")
                // {
                // }
            }
            tableelement("Shipment Method"; "Shipment Method")
            {
                MinOccurs = Zero;
                XmlName = 'ShipmentMethod';
                UseTemporary = true;
                fieldelement(SmCode; "Shipment Method".Code)
                {
                }
                fieldelement(SmDescription; "Shipment Method".Description)
                {
                }
            }
            tableelement("Add. Cust. Posting Grp. Setup"; "Add. Cust. Posting Grp. Setup")
            {
                MinOccurs = Zero;
                XmlName = 'CustPostGrpSetup';
                UseTemporary = true;
                fieldelement(CgcShipToCountry; "Add. Cust. Posting Grp. Setup"."Country/Region Code")
                {
                }
                fieldelement(CgcLocationCode; "Add. Cust. Posting Grp. Setup"."Location Code")
                {
                }
                fieldelement(CgcCustomerNo; "Add. Cust. Posting Grp. Setup"."Customer No.")
                {
                }
                fieldelement(CgcCompanyType; "Add. Cust. Posting Grp. Setup"."Company Type")
                {
                }
                fieldelement(CgcDescription; "Add. Cust. Posting Grp. Setup".Description)
                {
                }
                fieldelement(CgcLocationCodeInSub; "Add. Cust. Posting Grp. Setup"."Location Code in SUB")
                {
                }
                fieldelement(CgcCustPostingGrp; "Add. Cust. Posting Grp. Setup"."Customer Posting Group")
                {
                }
                fieldelement(CgcCurrencyCode; "Add. Cust. Posting Grp. Setup"."Currency Code")
                {
                }
                fieldelement(CgcBillToCustNo; "Add. Cust. Posting Grp. Setup"."Bill-to Customer No.")
                {
                }
                fieldelement(CgcGenBusPostGrp; "Add. Cust. Posting Grp. Setup"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(CgcVatProdPostGrp; "Add. Cust. Posting Grp. Setup"."VAT Prod. Posting Group")
                {
                }
                fieldelement(CgcVatBusPostGrp; "Add. Cust. Posting Grp. Setup"."VAT Bus. Posting Group")
                {
                }
                fieldelement(CgcVatRegistrationNo; "Add. Cust. Posting Grp. Setup"."VAT Registration No.")
                {
                }
                fieldelement(CgcEUThreePartyTrade; "Add. Cust. Posting Grp. Setup"."EU 3-Party Trade")
                {
                }
            }
            tableelement("Intercompany Purchase Code"; "Intercompany Purchase Code")
            {
                MinOccurs = Zero;
                XmlName = 'IntercompanyPurchase';
                UseTemporary = true;
                fieldelement(IpCode; "Intercompany Purchase Code".Code)
                {
                }
                fieldelement(IpReadCompInfoFromCompany; "Intercompany Purchase Code"."Read Comp. Info from Company")
                {
                }
                fieldelement(IpLocatVatForCurrency; "Intercompany Purchase Code"."Calc. Local VAT for Currency")
                {
                }
            }
            tableelement("Salesperson/Purchaser"; "Salesperson/Purchaser")
            {
                MinOccurs = Zero;
                XmlName = 'SalesPerson';
                UseTemporary = true;
                fieldelement(SPCode; "Salesperson/Purchaser".Code) { }
                fieldelement(SPName; "Salesperson/Purchaser".Name) { }
            }
        }
    }

    var
        ZGT: Codeunit "ZyXEL General Tools";
        PaymentTerms_DueDateCalculation: DateFormula;
        PaymentTerms_DiscountDateCalculation: DateFormula;
        PaymentTerms_DiscountPct: Decimal;
        ItalianDB: Boolean;

    procedure SetData(pCompanyName: Text[80]; pCustNoFilter: Text; pForceReplication: Boolean): Boolean
    var
        recCust: Record Customer;
        recBillToCust: Record Customer;
        recDefDim: Record "Default Dimension";
        recShipToAdd: Record "Ship-to Address";
        recICPartner: Record "IC Partner";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        recGenPostSetup: Record "General Posting Setup";
        recVatBusPostGrp: Record "VAT Business Posting Group";
        recVatPostSetup: Record "VAT Posting Setup";
        recCustPostGrp: Record "Customer Posting Group";
        recPaymentTerms: Record "Payment Terms";
        recPaymentMethod: Record "Payment Method";
        recCustRepSelection: Record "Custom Report Selection";
        recDataForRep: Record "Data for Replication";
        recItemCrossRef: Record "Item Reference";
        recShipMethod: Record "Shipment Method";
        recAddPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
        recIntCompPurch: Record "Intercompany Purchase Code";
        recSalesPerson: Record "Salesperson/Purchaser";
        RecRef: RecordRef;
        FldRef: FieldRef;
        lText001: Label 'If you force replication of a customer, you need to fill out "Customer No. Filter".';
        ForceReplication: Boolean;
        CustomerEvent: Codeunit "Customer Events";
    begin
        //>> 27-05-19 ZY-LD 004
        if pForceReplication and (pCustNoFilter = '') then
            Error(lText001);
        //<< 27-05-19 ZY-LD 004

        recICPartner.SetFilter("Inbox Type", '%1|%2', recICPartner."inbox type"::Database, recICPartner."inbox type"::"Web Service");
        recICPartner.SetRange("Inbox Details", pCompanyName);
        recICPartner.SetRange(Blocked, false);
        if recICPartner.FindSet() then
            repeat
                recBillToCust.SetRange("IC Partner Code", recICPartner.Code);
                if (recBillToCust.FindFirst() and recBillToCust."Sub company") or
                   (pForceReplication)  // 27-05-19 ZY-LD 004
                then begin
                    if not pForceReplication then  // 27-05-19 ZY-LD 004
                                                   //>> 12-07-19 ZY-LD 005
                        if (CompanyName() = 'ZNet DK') and (recBillToCust."No." = '200116') then
                            recCust.SetFilter("Bill-to Customer No.", '%1|%2', recBillToCust."No.", pCustNoFilter)
                        else  //<< 12-07-19 ZY-LD 005
                            recCust.SetRange("Bill-to Customer No.", recBillToCust."No.");
                    if pCustNoFilter <> '' then
                        recCust.SetFilter("No.", pCustNoFilter);
                    recCust.SetRange("Sub company", false);  // 08-02-21 ZY-LD 011

                    if recCust.FindSet() then
                        repeat
                            if recCust."Country/Region Code" = 'TR' then
                                recCust.TestField("Tax Office Code");

                            Customer := recCust;
                            //>> 02-11-18 ZY-LD 001
                            recDataForRep.SetRange("Table No.", Database::Customer);
                            recDataForRep.SetFilter("Source No.", '%1|%2', Customer."No.", '');
                            recDataForRep.SetFilter("Company Name", '%1|%2', pCompanyName, '');
                            if recDataForRep.FindFirst() then begin
                                RecRef.Open(recDataForRep."Table No.");
                                RecRef.GetTable(Customer);
                                repeat
                                    FldRef := RecRef.field(recDataForRep."Field No.");
                                    recDataForRep.FormatValue(recDataForRep.Value, FldRef);
                                until recDataForRep.Next() = 0;
                                RecRef.SetTable(Customer);
                                RecRef.Close();
                            end;
                            //<< 02-11-18 ZY-LD 001
                            Customer.Insert();

                            recDefDim.SetRange("Table ID", Database::Customer);
                            recDefDim.SetRange("No.", recCust."No.");
                            if recDefDim.FindSet() then
                                repeat
                                    "Default Dimension" := recDefDim;
                                    "Default Dimension".Insert();
                                until recDefDim.Next() = 0;

                            recShipToAdd.SetRange("Customer No.", recCust."No.");
                            if recShipToAdd.FindSet() then
                                repeat
                                    "Ship-to Address" := recShipToAdd;
                                    "Ship-to Address".Insert();
                                until recShipToAdd.Next() = 0;

                            recCustRepSelection.SetRange("Source Type", Database::Customer);
                            recCustRepSelection.SetRange("Source No.", recCust."No.");
                            if CopyStr(recCust."No.", 1, 1) = 'I' then  // 08-04-19 ZY-LD 003
                                recCustRepSelection.SetFilter(Usage, '<>%1&<>%2', recCustRepSelection.Usage::"S.Invoice", recCustRepSelection.Usage::"S.Cr.Memo");  // 08-04-19 ZY-LD 003
                            if recCustRepSelection.FindSet() then
                                repeat
                                    "Custom Report Selection" := recCustRepSelection;
                                    "Custom Report Selection".Insert();
                                until recCustRepSelection.Next() = 0;

                            //>> 31-03-20 ZY-LD 007
                            recItemCrossRef.SetRange("Reference Type", recItemCrossRef."reference type"::Customer);
                            recItemCrossRef.SetRange("Reference Type No.", recCust."No.");
                            if recItemCrossRef.FindSet() then
                                repeat
                                    "Item Cross Reference" := recItemCrossRef;
                                    "Item Cross Reference".Insert();
                                until recItemCrossRef.Next() = 0;
                            //<< 31-03-20 ZY-LD 007

                            ItalianDB := StrPos(pCompanyName, ' IT') > 0;

                            if not "Payment Terms".Get(Customer."Payment Terms Code") then
                                if recPaymentTerms.Get(Customer."Payment Terms Code") then begin
                                    "Payment Terms" := recPaymentTerms;
                                    "Payment Terms".Insert();

                                    if not ItalianDB then begin
                                        RecRef.GetTable("Payment Terms");

                                        FldRef := RecRef.Field(2);  // Due Date Calculation
                                        PaymentTerms_DueDateCalculation := FldRef.Value();
                                        FldRef := RecRef.Field(3);  // Discount Date Calculation
                                        PaymentTerms_DiscountDateCalculation := FldRef.Value();
                                        FldRef := RecRef.Field(4);  // Discount %
                                        PaymentTerms_DiscountPct := FldRef.Value();

                                        RecRef.Modify();
                                    end;
                                end;

                            if not "Payment Method".Get(Customer."Payment Method Code") then
                                if recPaymentMethod.Get(Customer."Payment Method Code") then begin
                                    "Payment Method" := recPaymentMethod;
                                    "Payment Method".Insert();
                                end;

                            if not "Gen. Business Posting Group".Get(Customer."Gen. Bus. Posting Group") then
                                if recGenBusPostGrp.Get(Customer."Gen. Bus. Posting Group") then begin
                                    "Gen. Business Posting Group" := recGenBusPostGrp;
                                    "Gen. Business Posting Group".Insert();

                                    recGenPostSetup.SetRange("Gen. Bus. Posting Group", Customer."Gen. Bus. Posting Group");
                                    if recGenPostSetup.FindSet() then
                                        repeat
                                            "General Posting Setup" := recGenPostSetup;
                                            "General Posting Setup".Insert();
                                        until recGenPostSetup.Next() = 0;
                                end;

                            if not "VAT Business Posting Group".Get(Customer."VAT Bus. Posting Group") then
                                if recVatBusPostGrp.Get(Customer."VAT Bus. Posting Group") then begin
                                    "VAT Business Posting Group" := recVatBusPostGrp;
                                    "VAT Business Posting Group".Insert();

                                    recVatPostSetup.SetRange("VAT Bus. Posting Group", Customer."VAT Bus. Posting Group");
                                    if recVatPostSetup.FindSet() then
                                        repeat
                                            "VAT Posting Setup" := recVatPostSetup;
                                            "VAT Posting Setup".Insert();
                                        until recVatPostSetup.Next() = 0;
                                end;

                            if not "Customer Posting Group".Get(Customer."Customer Posting Group") then
                                if recCustPostGrp.Get(Customer."Customer Posting Group") then begin
                                    "Customer Posting Group" := recCustPostGrp;
                                    "Customer Posting Group".Insert();
                                end;

                            //>> 10-08-20 ZY-LD 010
                            if not "Shipment Method".Get(Customer."Shipment Method Code") then
                                if recShipMethod.Get(Customer."Shipment Method Code") then begin
                                    "Shipment Method" := recShipMethod;
                                    "Shipment Method".Insert();
                                end;
                            //<< 10-08-20 ZY-LD 010

                            //>> 03-02-21 ZY-LD 011
                            if CustomerEvent.GetCustPostGrpSetupCountryFilter(recCust) <> '' then begin
                                recAddPostGrpSetup.SetFilter("Country/Region Code", CustomerEvent.GetCustPostGrpSetupCountryFilter(recCust));
                                //recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', recCust."No.", '');  // 23-09-24 ZY-LD 000 - We want also local customer no.´s moved to subsidary.
                                recAddPostGrpSetup.SetRange("Company Type", recAddPostGrpSetup."company type"::Subsidary);
                                if recAddPostGrpSetup.FindSet() then
                                    repeat
                                        "Add. Cust. Posting Grp. Setup" := recAddPostGrpSetup;
                                        //"Additional Posting Grp. Setup"."Customer No." := recCust."No.";
                                        if not "Add. Cust. Posting Grp. Setup".Insert() then;
                                    until recAddPostGrpSetup.Next() = 0;
                            end;
                            //<< 03-02-21 ZY-LD 011

                            //>> 07-02-22 ZY-LD 013
                            if not "Intercompany Purchase Code".Get(Customer."Intercompany Purchase") then
                                if recIntCompPurch.Get(Customer."Intercompany Purchase") then begin
                                    "Intercompany Purchase Code" := recIntCompPurch;
                                    "Intercompany Purchase Code".Insert();
                                end;
                            //<< 07-02-22 ZY-LD 013

                            //>> 16-02-24 ZY-LD 017
                            if recCust."Salesperson Code" <> '' then
                                if recSalesPerson.get(recCust."Salesperson Code") then begin
                                    "Salesperson/Purchaser" := recSalesPerson;
                                    "Salesperson/Purchaser".Insert();
                                end;
                            if recCust."Order Desk Resposible Code" <> '' then
                                if not "Salesperson/Purchaser".get(recCust."Order Desk Resposible Code") then
                                    if recSalesPerson.get(recCust."Order Desk Resposible Code") then begin
                                        "Salesperson/Purchaser" := recSalesPerson;
                                        "Salesperson/Purchaser".Insert();
                                    end;
                            //<< 16-02-24 ZY-LD 017

                            ForceReplication := pForceReplication;  // 27-05-19 ZY-LD 004
                        until recCust.Next() = 0;
                end;
            until (recICPartner.Next() = 0) or ForceReplication;  // 27-05-19 ZY-LD 004

        exit(Customer.Count() > 0);
    end;

    procedure ReplicateData()
    var
        recCust: Record Customer;
        recDefDim: Record "Default Dimension";
        recShipToAdd: Record "Ship-to Address";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        recGenPostSetup: Record "General Posting Setup";
        recVatBusPostGrp: Record "VAT Business Posting Group";
        recVatPostSetup: Record "VAT Posting Setup";
        recCustPostGrp: Record "Customer Posting Group";
        recPaymentTerms: Record "Payment Terms";
        recPaymentMethod: Record "Payment Method";
        recSrvEnviron: Record "Server Environment";
        recCustRepSelection: Record "Custom Report Selection";
        recSaveCust: Record Customer;
        recItemCrossRef: Record "Item Reference";
        recItemCrossRef2: Record "Item Reference";
        recItem: Record Item;
        recShipMethod: Record "Shipment Method";
        recAddPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
        recIntCompPurch: Record "Intercompany Purchase Code";
        recSalesHead: Record "Sales Header";
        recSalesPerson: Record "Salesperson/Purchaser";
        recGenLedgSetup: Record "General Ledger Setup";
        RecRef: RecordRef;
        FldRef: FieldRef;
        PrevNo: Code[20];
    begin
        ItalianDB := ZGT.CompanyNameIs(14);  // IT

        if Customer.FindSet() then
            repeat
                if not recCust.Get(Customer."No.") then begin
                    recCust := Customer;
                    recCust."Bill-to Customer No." := '';
                    if not ZGT.CompanyNameIs(10) and  // 28-05-20 ZY-LD 008
                       not ZGT.CompanyNameIs(2)  // 09-02-22 ZY-LD 008
                    then
                        recCust."Intercompany Purchase" := '';
                    recCust."Last Statement No." := 0;

                    if recSrvEnviron.TurkishServer then
                        recCust.Validate("VAT ID", recCust."VAT Registration No.");

                    //>> 28-02-24 ZY-LD 018
                    if ItalianDB then begin
                        recGenLedgSetup.get;
                        if recCust."Currency Code" = recGenLedgSetup."LCY Code" then
                            recCust."Currency Code" := '';
                    end;
                    //<< 28-02-24 ZY-LD 018
                    recCust.Insert();
                end else begin
                    recSaveCust := recCust;
                    //recCust := Customer;
                    TransferFieldsCustomer(recCust, Customer);
                    recCust."Bill-to Customer No." := recSaveCust."Bill-to Customer No.";
                    if not ZGT.CompanyNameIs(10) and  // 28-05-20 ZY-LD 008
                       not ZGT.CompanyNameIs(2)  // 21-11-22 ZY-LD 008
                    then
                        recCust."Intercompany Purchase" := recSaveCust."Intercompany Purchase";
                    recCust."Last Statement No." := recSaveCust."Last Statement No.";

                    if recSrvEnviron.TurkishServer then
                        if recCust."VAT ID" <> recCust."VAT Registration No." then
                            recCust.Validate("VAT ID", recCust."VAT Registration No.");

                    //>> 28-02-24 ZY-LD 018
                    if ItalianDB then begin
                        recGenLedgSetup.get;
                        if recCust."Currency Code" = recGenLedgSetup."LCY Code" then
                            recCust."Currency Code" := '';
                    end;
                    //<< 28-02-24 ZY-LD 018
                    recCust.Modify();
                end;

                // Default Dimensions
                recDefDim.SetRange("Table ID", 18);
                recDefDim.SetRange("No.", Customer."No.");
                recDefDim.DeleteAll();
                recDefDim.Reset();

                "Default Dimension".SetRange("No.", Customer."No.");
                if "Default Dimension".FindSet() then
                    repeat
                        recDefDim := "Default Dimension";
                        recDefDim.Insert();
                    until "Default Dimension".Next() = 0;

                // Ship-to Address
                recShipToAdd.SetRange("Customer No.", Customer."No.");
                //>> 07-03-23 ZY-LD 014
                //recShipToAdd.DELETEALL(TRUE);
                recShipToAdd.SetRange(Replicated, true);
                if recShipToAdd.FindSet(true) then
                    repeat
                        //>> 03-05-23 ZY-LD 015
                        recSalesHead.SetRange("Sell-to Customer No.", Customer."No.");
                        recSalesHead.SetRange("Ship-to Code", recShipToAdd.Code);
                        if not recSalesHead.FindFirst() then  //<< 03-05-23 ZY-LD 015
                            if not recShipToAdd.Delete(true) then;
                    until recShipToAdd.Next() = 0;
                //<< 07-03-23 ZY-LD 014
                recShipToAdd.Reset();

                "Ship-to Address".SetRange("Customer No.", Customer."No.");
                if "Ship-to Address".FindSet() then
                    repeat
                        recShipToAdd := "Ship-to Address";
                        if ZGT.TurkishServer then
                            recShipToAdd."Location Code" := '';
                        recShipToAdd.Replicated := true;
                        //>> 07-03-23 ZY-LD 014
                        //recShipToAdd.INSERT;
                        if not recShipToAdd.Insert() then
                            recShipToAdd.Modify();
                    //<< 07-03-23 ZY-LD 014
                    until "Ship-to Address".Next() = 0;

                // Custom Report Selection
                recCustRepSelection.SetRange("Source Type", Database::Customer);
                recCustRepSelection.SetRange("Source No.", Customer."No.");
                recCustRepSelection.DeleteAll();
                recCustRepSelection.Reset();

                "Custom Report Selection".SetRange("Source Type", Database::Customer);
                "Custom Report Selection".SetRange("Source No.", Customer."No.");
                if "Custom Report Selection".FindSet() then
                    repeat
                        recCustRepSelection := "Custom Report Selection";
                        recCustRepSelection.Insert();
                    until "Custom Report Selection".Next() = 0;

                // Cross-Reference
                //>> 31-03-20 ZY-LD 007
                recItemCrossRef.SetRange("Reference Type", recItemCrossRef."reference type"::Customer);
                recItemCrossRef.SetRange("Reference Type No.", Customer."No.");
                if recItemCrossRef.FindSet() then
                    repeat
                        recItemCrossRef2.SetRange("Reference Type", recItemCrossRef2."reference type"::Vendor);
                        recItemCrossRef2.SetRange("Reference No.", recItemCrossRef."Reference No.");
                        if recItemCrossRef2.FindFirst() then
                            recItemCrossRef2.Delete(true);
                        recItemCrossRef.Delete(true);
                    until recItemCrossRef.Next() = 0;
                recItemCrossRef.Reset();

                "Item Cross Reference".SetRange("Reference Type", recItemCrossRef."reference type"::Customer);
                "Item Cross Reference".SetRange("Reference Type No.", Customer."No.");
                if "Item Cross Reference".FindSet() then
                    repeat
                        if recItem.Get("Item Cross Reference"."Item No.") then begin  // 09-07-20 ZY-LD 009
                            recItemCrossRef := "Item Cross Reference";
                            recItemCrossRef.Insert(true);

                            recItemCrossRef."Reference Type" := recItemCrossRef."reference type"::Vendor;
                            recItemCrossRef."Reference Type No." := '';
                            if not recItemCrossRef.Insert() then;
                        end;
                    until "Item Cross Reference".Next() = 0;
                //<< 31-03-20 ZY-LD 007

                //>> 03-02-21 ZY-LD 011
                recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', Customer."No.", '');
                recAddPostGrpSetup.DeleteAll(true);
                recAddPostGrpSetup.Reset();

                if "Add. Cust. Posting Grp. Setup".FindSet() then
                    repeat
                        recAddPostGrpSetup := "Add. Cust. Posting Grp. Setup";
                        if not recAddPostGrpSetup.Insert() then
                            recAddPostGrpSetup.Modify();
                    until "Add. Cust. Posting Grp. Setup".Next() = 0;
            //<< 03-02-21 ZY-LD 011
            until Customer.Next() = 0;

        if not recSrvEnviron.TurkishServer then begin
            if "Gen. Business Posting Group".FindSet() then
                repeat
                    if not recGenBusPostGrp.Get("Gen. Business Posting Group".Code) then begin
                        recGenBusPostGrp := "Gen. Business Posting Group";
                        recGenBusPostGrp.Insert();
                    end;
                until "Gen. Business Posting Group".Next() = 0;

            if "General Posting Setup".FindSet() then
                repeat
                    if not recGenPostSetup.Get("General Posting Setup"."Gen. Bus. Posting Group", "General Posting Setup"."Gen. Prod. Posting Group") then begin
                        recGenPostSetup."Gen. Bus. Posting Group" := "General Posting Setup"."Gen. Bus. Posting Group";
                        recGenPostSetup."Gen. Prod. Posting Group" := "General Posting Setup"."Gen. Prod. Posting Group";
                        recGenPostSetup.Insert();
                    end;
                until "General Posting Setup".Next() = 0;

            if "VAT Business Posting Group".FindSet() then
                repeat
                    if not recVatBusPostGrp.Get("VAT Business Posting Group".Code) then begin
                        recVatBusPostGrp := "VAT Business Posting Group";
                        recVatBusPostGrp.Insert();
                    end;
                until "VAT Business Posting Group".Next() = 0;

            if "VAT Posting Setup".FindSet() then
                repeat
                    if not recVatPostSetup.Get("VAT Posting Setup"."VAT Bus. Posting Group", "VAT Posting Setup"."VAT Prod. Posting Group") then begin
                        recVatPostSetup."VAT Bus. Posting Group" := "VAT Posting Setup"."VAT Bus. Posting Group";
                        recVatPostSetup."VAT Prod. Posting Group" := "VAT Posting Setup"."VAT Prod. Posting Group";
                        recVatPostSetup.Insert();
                    end;
                until "VAT Posting Setup".Next() = 0;

            if "Customer Posting Group".FindSet() then
                repeat
                    if not recCustPostGrp.Get("Customer Posting Group".Code) then begin
                        recCustPostGrp.Code := "Customer Posting Group".Code;
                        recCustPostGrp.Insert();
                    end;
                until "Customer Posting Group".Next() = 0;
        end;

        //ItalianDB := ZGT.CompanyNameIs(14);  // IT  // 28-02-24 ZY-LD Moved to the top.

        if "Payment Terms".FindSet() then
            repeat
                if not recPaymentTerms.Get("Payment Terms".Code) then begin
                    recPaymentTerms := "Payment Terms";
                    recPaymentTerms.Insert();

                    if not ItalianDB then begin
                        RecRef.GetTable(recPaymentTerms);

                        FldRef := RecRef.Field(2);  // Due Date Calculation
                        FldRef.Value(PaymentTerms_DueDateCalculation);
                        FldRef := RecRef.Field(3);  // Discount Date Calculation
                        FldRef.Value(PaymentTerms_DiscountDateCalculation);
                        FldRef := RecRef.Field(4);  // Discount %
                        FldRef.Value(PaymentTerms_DiscountPct);

                        RecRef.Modify();
                    end;
                end;
            until "Payment Terms".Next() = 0;

        if "Payment Method".FindSet() then
            repeat
                if not recPaymentMethod.Get("Payment Method".Code) then begin
                    recPaymentMethod := "Payment Method";
                    recPaymentMethod.Insert();
                end;
            until "Payment Method".Next() = 0;

        //>> 10-08-20 ZY-LD 010
        if "Shipment Method".FindSet() then
            repeat
                if not recShipMethod.Get("Shipment Method".Code) then begin
                    recShipMethod := "Shipment Method";
                    recShipMethod.Insert();
                end;
            until "Shipment Method".Next() = 0;
        //<< 10-08-20 ZY-LD 010

        //>> 07-02-22 ZY-LD 013
        if "Intercompany Purchase Code".FindSet() then
            repeat
                if not recIntCompPurch.Get("Intercompany Purchase Code".Code) then begin
                    recIntCompPurch := "Intercompany Purchase Code";
                    recIntCompPurch.Insert();
                end;
            until "Intercompany Purchase Code".Next() = 0;
        //<< 07-02-22 ZY-LD 013

        //>> 16-02-24 ZY-LD 017
        if "Salesperson/Purchaser".FindSet() then
            repeat
                if not recSalesPerson.get("Salesperson/Purchaser".Code) then begin
                    recSalesPerson := "Salesperson/Purchaser";
                    recSalesPerson.Insert(true);
                end;
            until "Salesperson/Purchaser".Next() = 0;
        //<< 16-02-24 ZY-LD 017
    end;

    local procedure TransferFieldsCustomer(var ToCust: Record Customer; FromCust: Record Customer)
    begin
        // We transfer fields one by one. Otherwise it will overwrite local fields in Italy BC.
        //ToCust := Customer;  // This is not possible, because it will overwrite local fields in Italy BC.
        //ToCust.TransferFields(Customer);  // This is not possible, because it will overwrite local fields in Italy BC.
        Tocust.Name := FromCust.Name;
        ToCust."Search Name" := FromCust."Search Name";
        ToCust."Name 2" := FromCust."Name 2";
        ToCust.Address := FromCust.Address;
        ToCust."Address 2" := FromCust."Address 2";
        ToCust.City := Customer.City;
        ToCust.Contact := Customer.Contact;
        ToCust."Phone No." := Customer."Phone No.";
        ToCust."Telex No." := Customer."Telex No.";
        ToCust."Document Sending Profile" := Customer."Document Sending Profile";
        ToCust."Our Account No." := Customer."Our Account No.";
        ToCust."Territory Code" := Customer."Territory Code";
        ToCust."Global Dimension 1 Code" := Customer."Global Dimension 1 Code";
        ToCust."Global Dimension 2 Code" := Customer."Global Dimension 2 Code";
        ToCust."Chain Name" := Customer."Chain Name";
        ToCust."Budgeted Amount" := Customer."Budgeted Amount";
        ToCust."Credit Limit (LCY)" := Customer."Credit Limit (LCY)";
        ToCust."Customer Posting Group" := Customer."Customer Posting Group";
        ToCust."Currency Code" := Customer."Currency Code";
        ToCust."Customer Price Group" := Customer."Customer Price Group";
        ToCust."Language Code" := Customer."Language Code";
        ToCust."Statistics Group" := Customer."Statistics Group";
        ToCust."Payment Terms Code" := Customer."Payment Terms Code";
        ToCust."Fin. Charge Terms Code" := Customer."Fin. Charge Terms Code";
        ToCust."Salesperson Code" := Customer."Salesperson Code";
        ToCust."Order Desk Resposible Code" := Customer."Order Desk Resposible Code"; //24-11-2025 BK #528108
        ToCust."Shipment Method Code" := Customer."Shipment Method Code";
        ToCust."Shipping Agent Code" := Customer."Shipping Agent Code";
        ToCust."Place of Export" := Customer."Place of Export";
        ToCust."Invoice Disc. Code" := Customer."Invoice Disc. Code";
        ToCust."Customer Disc. Group" := Customer."Customer Disc. Group";
        ToCust."Country/Region Code" := Customer."Country/Region Code";
        ToCust."Collection Method" := Customer."Collection Method";
        ToCust.Blocked := Customer.Blocked;
        ToCust."Invoice Copies" := Customer."Invoice Copies";
        ToCust."Last Statement No." := Customer."Last Statement No.";
        ToCust."Print Statements" := Customer."Print Statements";
        ToCust."Bill-to Customer No." := Customer."Bill-to Customer No.";
        ToCust.Priority := Customer.Priority;
        ToCust."Payment Method Code" := Customer."Payment Method Code";
        ToCust."Last Date Modified" := Customer."Last Date Modified";
        ToCust."Application Method" := Customer."Application Method";
        ToCust."Prices Including VAT" := Customer."Prices Including VAT";
        ToCust."Location Code" := Customer."Location Code";
        ToCust."Fax No." := Customer."Fax No.";
        ToCust."Telex Answer Back" := Customer."Telex Answer Back";
        ToCust."VAT Registration No." := Customer."VAT Registration No.";
        ToCust."Combine Shipments" := Customer."Combine Shipments";
        ToCust."Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
        ToCust.GLN := Customer.GLN;
        ToCust."Post Code" := Customer."Post Code";
        ToCust.County := Customer.County;
        ToCust."E-Mail" := Customer."E-Mail";
        ToCust."Home Page" := Customer."Home Page";
        ToCust."Reminder Terms Code" := Customer."Reminder Terms Code";
        ToCust."No. Series" := Customer."No. Series";
        ToCust."Tax Area Code" := Customer."Tax Area Code";
        ToCust."VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
        ToCust.Reserve := Customer.Reserve;
        ToCust."Block Payment Tolerance" := Customer."Block Payment Tolerance";
        ToCust."IC Partner Code" := Customer."IC Partner Code";
        ToCust."Prepayment %" := Customer."Prepayment %";
        ToCust."Partner Type" := Customer."Partner Type";
        ToCust."Preferred Bank Account Code" := Customer."Preferred Bank Account Code";
        ToCust."Cash Flow Payment Terms Code" := Customer."Cash Flow Payment Terms Code";
        ToCust."Primary Contact No." := Customer."Primary Contact No.";
        ToCust."Responsibility Center" := Customer."Responsibility Center";
        ToCust."Shipping Advice" := Customer."Shipping Advice";
        ToCust."Shipping Time" := Customer."Shipping Time";
        ToCust."Shipping Agent Service Code" := Customer."Shipping Agent Service Code";
        ToCust."Service Zone Code" := Customer."Service Zone Code";
        ToCust."Allow Line Disc." := Customer."Allow Line Disc.";
        ToCust."Base Calendar Code" := Customer."Base Calendar Code";
        ToCust."Copy Sell-to Addr. to Qte From" := Customer."Copy Sell-to Addr. to Qte From";
        ToCust."Related Company" := Customer."Related Company";
        ToCust."Do Not Change Bill-to Cust No." := Customer."Do Not Change Bill-to Cust No.";
        ToCust."Exclude Wee Report" := Customer."Exclude Wee Report";
        ToCust."Statement Type" := Customer."Statement Type";
        ToCust."Exclude from Intrastat" := Customer."Exclude from Intrastat";
        ToCust."VAT Registration Code" := Customer."VAT Registration Code";
        ToCust."Action Code Source" := Customer."Action Code Source";
        ToCust."Turkish Customer No." := Customer."Turkish Customer No.";
        ToCust."Forecast Territory" := Customer."Forecast Territory";
        ToCust."Intercompany Purchase" := Customer."Intercompany Purchase";
        ToCust."Registration No." := Customer."Registration No.";
        ToCust."E-Mail Statement Address" := Customer."E-Mail Statement Address";
        ToCust."E-Mail Reminder Address" := Customer."E-Mail Reminder Address";
        ToCust."E-Mail Statement" := Customer."E-Mail Statement";
        ToCust."E-Mail Reminder" := Customer."E-Mail Reminder";
        ToCust.Category := Customer.Category;
        ToCust."Avoid Creation of SI in SUB" := Customer."Avoid Creation of SI in SUB";
        ToCust."Sub company" := Customer."Sub company";
        ToCust."Tax Office Code" := Customer."Tax Office Code";
        ToCust."Use E-Invoice" := Customer."Use E-Invoice";
        ToCust."E-Invoice Profile ID" := Customer."E-Invoice Profile ID";
        ToCust."Administration Reference" := Customer."Administration Reference";
        ToCust."Recipient Code" := Customer."Recipient Code";
        ToCust."Customer Tipology" := Customer."Customer Tipology";
        ToCust."Recipient PEC E-Mail" := Customer."Recipient PEC E-Mail";
        ToCust."Approval No. must be Filled" := Customer."Approval No. must be Filled";
        ToCust."Your Reference Translation" := Customer."Your Reference Translation";
        ToCust.Active := Customer.Active;
    end;
}
