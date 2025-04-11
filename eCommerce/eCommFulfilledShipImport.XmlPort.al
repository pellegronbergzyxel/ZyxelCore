xmlport 50014 "eComm. Fulfilled Ship. Import"
{
    Caption = 'eCommerce Fulfilled Ship. Import';
    Direction = Import;
    Format = VariableText;
    RecordSeparator = '<LF>';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Attribute';
                SourceTableView = sorting(Number);
                UseTemporary = true;
                textelement(Col01)
                {
                }
                textelement(Col02)
                {
                }
                textelement(Col03)
                {
                }
                textelement(Col04)
                {
                }
                textelement(Col05)
                {
                }
                textelement(Col06)
                {
                }
                textelement(Col07)
                {
                }
                textelement(Col08)
                {
                }
                textelement(Col09)
                {
                }
                textelement(Col10)
                {
                }
                textelement(Col11)
                {
                }
                textelement(Col12)
                {
                }
                textelement(Col13)
                {
                }
                textelement(Col14)
                {
                }
                textelement(Col15)
                {
                }
                textelement(Col16)
                {
                }
                textelement(Col17)
                {
                }
                textelement(Col18)
                {
                }
                textelement(Col19)
                {
                }
                textelement(Col20)
                {
                }
                textelement(Col21)
                {
                }
                textelement(Col22)
                {
                }
                textelement(Col23)
                {
                }
                textelement(Col24)
                {
                }
                textelement(Col25)
                {
                }
                textelement(Col26)
                {
                }
                textelement(Col27)
                {
                }
                textelement(Col28)
                {
                }
                textelement(Col29)
                {
                }
                textelement(Col30)
                {
                }
                textelement(Col31)
                {
                }
                textelement(Col32)
                {
                }
                textelement(Col33)
                {
                }
                textelement(Col34)
                {
                }
                textelement(Col35)
                {
                }
                textelement(Col36)
                {
                }
                textelement(Col37)
                {
                }
                textelement(Col38)
                {
                }
                textelement(Col39)
                {
                }
                textelement(Col40)
                {
                }
                textelement(Col41)
                {
                }
                textelement(Col42)
                {
                }
                textelement(Col43)
                {
                }
                textelement(Col44)
                {
                }
                textelement(Col45)
                {
                }
                textelement(Col46)
                {
                }
                textelement(Col47)
                {
                }
                textelement(Col48)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    CreateOrder: Boolean;
                begin
                    ZGT.UpdateProgressWindow(StrSubstNo('%1 %2', OrderID, ShipmentID), 0, true);

                    if TotalToImport = 0 then
                        TotalToImport := Integer.Count();

                    if SetValues then begin
                        GetMarketPlace;
                        if not OrderPreviousCreated(0, OrderID, VATInvoiceNumber, 0) then begin
                            if (OrderID <> recAmzOrderHead."eCommerce Order Id") or
                               (VATInvoiceNumber <> recAmzOrderHead."Invoice No.")
                            then
                                if not recAmzOrderHead.Get(TransactTypeOption, OrderID, VATInvoiceNumber) then
                                    InsertHeader;

                            InsertLine;
                        end;
                    end;
                    currXMLport.Skip();
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    var
        CustLedgEntryFound: Boolean;
    begin
        ZGT.CloseProgressWindow;

        recAmzMktPlace.Reset();

        recAmzOrderHead.SetRange("Transaction Type", recAmzOrderHead."transaction type"::Order);
        recAmzOrderHead.SetRange("Import Source Type", recAmzOrderHead."import source type"::"eCommerce Fulfilled Shipment");
        recAmzOrderHead.SetRange("Completely Imported", false);
        recAmzOrderHead.SetAutoCalcFields("Amount Including VAT");
        if recAmzOrderHead.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recAmzOrderHead.Count());
            repeat
                ZGT.UpdateProgressWindow(recAmzOrderHead."eCommerce Order Id", 0, true);

                recAmzMktPlace.Get(recAmzOrderHead."Marketplace ID");
                if recAmzMktPlace."Import Data from" = recAmzMktPlace."import data from"::"Tax Document Library" then begin
                    if not OrderPreviousCreated(1, recAmzOrderHead."eCommerce Order Id", recAmzOrderHead."Invoice No.", recAmzOrderHead."Amount Including VAT") then begin
                        recCustLedgEntry.SetCurrentkey("External Document No.");
                        recCustLedgEntry.SetRange("External Document No.", recAmzOrderHead."eCommerce Order Id");
                        recCustLedgEntry.SetRange("Document Type", recCustLedgEntry."document type"::Payment);
                        recCustLedgEntry.SetRange(Open, true);
                        recCustLedgEntry.SetAutoCalcFields("Remaining Amount");
                        if recCustLedgEntry.FindSet() then begin
                            CustLedgEntryFound := false;
                            repeat
                                if recAmzOrderHead."Amount Including VAT" + recCustLedgEntry."Remaining Amount" = 0 then begin
                                    recAmzOrderHead.Validate("Completely Imported", true);
                                    recAmzOrderHead.ValidateDocument;
                                    recAmzOrderHead.Modify(true);

                                    NewRecords := NewRecords + 1;
                                    CustLedgEntryFound := true;
                                end;
                            until (recCustLedgEntry.Next() = 0) or CustLedgEntryFound;

                            if not CustLedgEntryFound then
                                recAmzOrderHead.Delete(true);
                        end else
                            recAmzOrderHead.Delete(true);
                    end else
                        recAmzOrderHead.Delete(true);
                end else begin
                    recAmzOrderHead.Validate("Completely Imported", true);
                    recAmzOrderHead.ValidateDocument;
                    recAmzOrderHead.Modify(true);

                    NewRecords := NewRecords + 1;
                end;
            until recAmzOrderHead.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
        //MESSAGE(Text001,NewRecords);
    end;

    trigger OnPreXmlPort()
    begin
        ZGT.OpenProgressWindow('', 10000);
    end;

    var
        recAmzOrderHead: Record "eCommerce Order Header";
        recAmzMktPlace: Record "eCommerce Market Place";
        recAmzCtryMapTo: Record "eCommerce Country Mapping";
        recAmzCtryMapFrom: Record "eCommerce Country Mapping";
        recEcomWhse: Record "eCommerce Warehouse";
        recCustLedgEntry: Record "Cust. Ledger Entry";
        VATProdPostingGroup: Code[20];
        MarketplaceID: Text[250];
        MerchantID: Text[250];
        OrderDate: Date;
        TransactType: Text[250];
        TransactTypeOption: Option "Order",Refund;
        OrderID: Text[250];
        ShipmentDate: Date;
        ShipmentID: Text[250];
        TransactionID: Text[250];
        ASINImport: Text[250];
        SKU: Text[250];
        QuantityImport: Integer;
        TaxCalculationDate: Date;
        TaxRate: Decimal;
        ProductTaxCode: Text[250];
        Currency: Text[250];
        TaxType: Text[250];
        TaxCalculationReasonCode: Text[250];
        TaxAddressRole: Text[250];
        JurisdictionLevel: Text[250];
        JurisdictionName: Text[250];
        ItemPrice: Decimal;
        ItemPriceTax: Decimal;
        ItemPriceInclTax: Decimal;
        ItemPromoDiscount: Decimal;
        ItemPromoDiscountTax: Decimal;
        ItemPromoDiscountInclTax: Decimal;
        DeliveryInclTax: Decimal;
        DeliveryTax: Decimal;
        DeliveryPrice: Decimal;
        ShipmentPromoDiscount: Decimal;
        ShipmentPromoDiscountTax: Decimal;
        ShipmentPromoDiscountInclTax: Decimal;
        GiftWrapPrice: Decimal;
        GiftWrapPriceTax: Decimal;
        GiftWrapPriceInclTax: Decimal;
        GIFTWRAPTaxInclusivePromoAmount: Decimal;
        GIFTWRAPTaxAmountPromo: Decimal;
        GIFTWRAPTaxExclusivePromoAmount: Decimal;
        SellerTaxRegistration: Text[250];
        SellerTaxRegistrationJurisdiction: Text[250];
        BuyerTaxRegistration: Text[250];
        BuyerTaxRegistrationJurisdiction: Text[250];
        BuyerTaxRegistrationType: Code[20];
        InvoiceLevelCurrencyCode: Text[250];
        InvoiceLevelExchangeRate: Decimal;
        InvoiceLevelExchangeRateDate: Date;
        ConvertedTaxAmount: Decimal;
        VATInvoiceNumber: Text[250];
        InvoiceUrl: Text[250];
        ExportOutsideEU: Boolean;
        ShipFromCity: Text[250];
        ShipFromState: Text[250];
        ShipFromCountry: Text[250];
        ShipFromPostalCode: Text[250];
        ShipFromTaxLocationCode: Text[250];
        ShipToCity: Text[250];
        ShipToState: Text[250];
        ShipToCountry: Text[250];
        ShipToPostalCode: Text[250];
        ShipToLocationCode: Text[250];
        ReturnFcCountry: Text[250];
        ErrorTxt: Text[250];
        NewRecords: Integer;
        Text001: Label '%1 new order(s) has been inserted.';
        Text002: Label 'Value is missing.';
        Text015: Label '"%1" %2 does not exist.';
        Text023: Label 'Treshold has been reached, but we hav no VAT-no. in %1.';
        TotalToImport: Integer;
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure SetValues(): Boolean
    var
        recCountry: Record "Country/Region";
        recVatPostSetup: Record "VAT Posting Setup";
        TotalTaxAmount: Decimal;
        lText001: Label '"%1" not found.';
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
    begin
        if (StrPos(Col01, 'eCommerce Order Id') <> 0) or (UpperCase(Col48) in ['NON-eCommerce', '']) then
            exit(false);

        OrderID := Col01;
        VATInvoiceNumber := Col03;
        recAmzMktPlace.SetRange("Market Place Name", UpperCase(Col48));
        if not recAmzMktPlace.FindFirst() then
            exit(false);

        MarketplaceID := recAmzMktPlace."Marketplace ID";
        MerchantID := Col02;
        ShipmentID := Col03;
        ASINImport := Col04;
        OrderDate := ConvertToDate(Col07);
        ShipmentDate := ConvertToDate(Col09);
        TransactType := 'SHIPMENT';
        case UpperCase(TransactType) of
            'RETURN',
          'REFUND':
                TransactTypeOption := Transacttypeoption::Refund;
            'SHIPMENT':
                TransactTypeOption := Transacttypeoption::Order;
            else
                Error(lText001, TransactType);
        end;
        SKU := Col14;
        Evaluate(QuantityImport, Col16, 9);
        Currency := Col17;

        ItemPrice := ConvertAmount(Col18);
        ItemPromoDiscount := ConvertAmount(Col41);
        ShipmentPromoDiscount := ConvertAmount(Col42);
        TotalTaxAmount := ConvertAmount(Col19);
        TaxRate := 0;
        if ItemPrice + ItemPromoDiscount + ShipmentPromoDiscount <> 0 then
            TaxRate := Round(TotalTaxAmount / (ItemPrice + ItemPromoDiscount), 1);

        if ItemPromoDiscount <> 0 then begin
            ItemPromoDiscountTax := Round(ItemPromoDiscount * TaxRate / 100);
            ItemPriceTax := TotalTaxAmount - ItemPromoDiscount;
        end else
            ItemPriceTax := TotalTaxAmount;
        ItemPriceInclTax := ItemPrice + ItemPriceTax;

        DeliveryPrice := ConvertAmount(Col20);
        DeliveryTax := ConvertAmount(Col21);
        DeliveryInclTax := DeliveryPrice + DeliveryTax;
        GiftWrapPrice := ConvertAmount(Col22);
        GiftWrapPriceTax := ConvertAmount(Col23);
        GiftWrapPriceInclTax := GiftWrapPrice + GiftWrapPriceTax;

        ItemPromoDiscountInclTax := ItemPromoDiscount + ItemPromoDiscountTax;

        // If there is a promodiscount on the shipment, the Tax is not shown for the discount. Therefore is the tax reversed.
        ShipmentPromoDiscountTax := 0;
        if (ShipmentPromoDiscount <> 0) and (DeliveryTax <> 0) then
            ShipmentPromoDiscountTax := -DeliveryTax;
        ShipmentPromoDiscountInclTax := ShipmentPromoDiscount + ShipmentPromoDiscountTax;

        ShipToCity := Col29;
        ShipToState := Col30;
        ShipToPostalCode := Col31;
        ShipToCountry := Col32;
        if not recCountry.Get(ShipToCountry) then begin
            recCountry.Code := ShipToCountry;
            recCountry.Insert(true);
        end;
        ExportOutsideEU := recCountry."EU Country/Region Code" = '';

        if not recEcomWhse.Get(Col46) then begin
            Clear(recEcomWhse);
            recEcomWhse.Init();
            recEcomWhse.Code := Col46;
            recEcomWhse.Insert(true);

            SI.SetMergefield(100, Col46);
            EmailAddMgt.CreateSimpleEmail('AMZNOWHSE', '', '');
            EmailAddMgt.Send;
        end;
        ShipFromCountry := recEcomWhse."Country Code";

        if TotalTaxAmount <> 0 then
            TaxCalculationReasonCode := 'TAXABLE';

        //SellerTaxRegistration := Col42;
        TaxAddressRole := 'SHIPTO';
        BuyerTaxRegistrationType := '';
        BuyerTaxRegistration := '';
        if recEcomWhse."Country Code" <> ShipToCountry then begin  // Has crossed border and
            if not ExportOutsideEU then begin
                if TotalTaxAmount = 0 then begin
                    BuyerTaxRegistrationType := 'BUSINESSREG';
                    BuyerTaxRegistration := Text002;
                    TaxAddressRole := 'SHIPFROM'
                end else begin
                    if recVatPostSetup.Get(StrSubstNo('DOM %1', recEcomWhse."Country Code"), 'VAT') and (recVatPostSetup."VAT %" = TaxRate) then begin
                        BuyerTaxRegistrationType := 'BUSINESSREG';
                        BuyerTaxRegistration := Text002;
                        TaxAddressRole := 'SHIPFROM'
                    end else
                        if recVatPostSetup.Get(StrSubstNo('DOM %1', ShipToCountry), 'VAT') and (recVatPostSetup."VAT %" = TaxRate) then
                            TaxAddressRole := 'SHIPTO'
                end;
            end else begin  // Exported outside EU
                TaxType := 'VAT';
                TaxAddressRole := 'SHIPFROM'
            end;
        end else begin  // Didn´t cross border.
            if TotalTaxAmount = 0 then begin
                BuyerTaxRegistrationType := 'BUSINESSREG';
                BuyerTaxRegistration := Text002;
            end;
        end;

        exit(true);
    end;

    local procedure InsertHeader()
    var
        recAmzLocation: Record "eCommerce Location Code";
        recVatPostSetup: Record "VAT Posting Setup";
        VATBusPostingGroup: Code[20];
    begin
        begin
            GetMarketPlace;

            Clear(recAmzOrderHead);
            recAmzOrderHead.Init();
            recAmzOrderHead.SetVatProdPostingGroup(VATProdPostingGroup);
            recAmzOrderHead.Validate(recAmzOrderHead."eCommerce Order Id", OrderID);
            recAmzOrderHead.Validate(recAmzOrderHead."Invoice No.", VATInvoiceNumber);
            recAmzOrderHead.Validate(recAmzOrderHead."Marketplace ID", MarketplaceID);
            recAmzOrderHead.Validate(recAmzOrderHead."Purchaser VAT No.", BuyerTaxRegistration);
            recAmzOrderHead.Validate(recAmzOrderHead."Export Outside EU", ExportOutsideEU);
            recAmzOrderHead.SetTransactionType(TransactType);

            recAmzOrderHead.SetTaxValue(TaxType, TaxCalculationReasonCode, TaxAddressRole, BuyerTaxRegistrationType, '', 'SELLER');
            recAmzOrderHead.Validate(recAmzOrderHead."Tax Rate", TaxRate);

            recAmzOrderHead.Validate(recAmzOrderHead."Merchant ID", MerchantID);
            recAmzOrderHead.Validate(recAmzOrderHead."Transaction ID", TransactionID);
            recAmzOrderHead.Validate(recAmzOrderHead."Shipment ID", ShipmentID);
            recAmzOrderHead.Validate(recAmzOrderHead."Order Date", OrderDate);
            recAmzOrderHead.Validate(recAmzOrderHead."Shipment Date", ShipmentDate);
            recAmzOrderHead.Validate(recAmzOrderHead."Invoice No.", VATInvoiceNumber);
            recAmzOrderHead.Validate(recAmzOrderHead."Ship To City", ShipToCity);
            recAmzOrderHead.Validate(recAmzOrderHead."Ship To State", CopyStr(ShipToState, 1, MaxStrLen(recAmzOrderHead."Ship To State")));
            recAmzOrderHead.Validate(recAmzOrderHead."Ship To Country", CopyStr(ShipToCountry, 1, MaxStrLen(recAmzOrderHead."Ship To Country")));
            recAmzOrderHead.Validate(recAmzOrderHead."Ship To Postal Code", CopyStr(ShipToPostalCode, 1, MaxStrLen(recAmzOrderHead."Ship To Postal Code")));
            recAmzOrderHead.Validate(recAmzOrderHead."Ship From City", CopyStr(ShipFromCity, 1, MaxStrLen(recAmzOrderHead."Ship From City")));
            recAmzOrderHead.Validate(recAmzOrderHead."Ship From State", CopyStr(ShipFromState, 1, MaxStrLen(recAmzOrderHead."Ship From State")));
            if ShipFromCountry <> '' then begin
                recAmzOrderHead.Validate(recAmzOrderHead."Ship From Country", CopyStr(ShipFromCountry, 1, MaxStrLen(recAmzOrderHead."Ship From Country")));
                recAmzOrderHead.Validate(recAmzOrderHead."Ship From Postal Code", CopyStr(ShipFromPostalCode, 1, MaxStrLen(recAmzOrderHead."Ship From Postal Code")));
            end;
            recAmzOrderHead.Validate(recAmzOrderHead."Ship From Tax Location Code", CopyStr(ShipFromTaxLocationCode, 1, MaxStrLen(recAmzOrderHead."Ship From Tax Location Code")));
            recAmzOrderHead.Validate(recAmzOrderHead."VAT Registration No. Zyxel");
            recAmzOrderHead.Validate(recAmzOrderHead."Invoice Download", InvoiceUrl);
            recAmzOrderHead.Validate(recAmzOrderHead."Currency Code", Currency);
            recAmzOrderHead.Validate(recAmzOrderHead."Warehouse Code", recEcomWhse.Code);
            recAmzOrderHead.Validate(recAmzOrderHead."Import Source Type", recAmzOrderHead."import source type"::"eCommerce Fulfilled Shipment");

            recAmzOrderHead.Insert(true);
        end;
    end;

    local procedure InsertLine()
    var
        recAmzOrderLine: Record "eCommerce Order Line";
        recAmzOrderLine2: Record "eCommerce Order Line";
    begin
        begin
            recAmzOrderLine2.SetRange("eCommerce Order Id", OrderID);
            recAmzOrderLine2.SetRange("Invoice No.", VATInvoiceNumber);
            if not recAmzOrderLine2.FindLast() then;

            recAmzOrderLine.Init();
            recAmzOrderLine.Validate(recAmzOrderLine."eCommerce Order Id", OrderID);
            recAmzOrderLine.Validate(recAmzOrderLine."Invoice No.", VATInvoiceNumber);
            recAmzOrderLine.Validate(recAmzOrderLine."Line No.", recAmzOrderLine2."Line No." + 10000);
            recAmzOrderLine.Validate(recAmzOrderLine.ASIN, ASINImport);
            recAmzOrderLine.Validate(recAmzOrderLine."Item No.", SKU);
            recAmzOrderLine.Validate(recAmzOrderLine.Quantity, QuantityImport);
            recAmzOrderLine.Validate(recAmzOrderLine."VAT Prod. Posting Group", VATProdPostingGroup);

            recAmzOrderLine.Validate(recAmzOrderLine."Total (Inc. Tax)", ItemPriceInclTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Tax Amount", ItemPriceTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Total (Exc. Tax)", ItemPrice);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Promo (Inc. Tax)", ItemPromoDiscountInclTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Promo Tax Amount", ItemPromoDiscountTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Promo (Exc. Tax)", ItemPromoDiscount);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping (Inc. Tax)", DeliveryInclTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping Tax Amount", DeliveryTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping (Exc. Tax)", DeliveryPrice);
            recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo (Inc. Tax)", ShipmentPromoDiscountInclTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo Tax Amount", ShipmentPromoDiscountTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo (Exc. Tax)", ShipmentPromoDiscount);
            recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap (Inc. Tax)", GiftWrapPriceInclTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Tax Amount", GiftWrapPriceTax);
            recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap (Exc. Tax)", GiftWrapPrice);
            /*VALIDATE("Gift Wrap Promo (Inc. Tax)",GIFTWRAPTaxInclusivePromoAmount);
            VALIDATE("Gift Wrap Promo Tax Amount",GIFTWRAPTaxAmountPromo);
            VALIDATE("Gift Wrap Promo (Exc. Tax)",GIFTWRAPTaxExclusivePromoAmount);*/
            recAmzOrderLine.Validate(recAmzOrderLine.Amount);

            recAmzOrderLine."Ship-to Country Code" := ShipToCountry;
            recAmzOrderLine.Insert();
        end;
    end;

    local procedure FinalizeHeader()
    begin
        begin
            recAmzOrderHead.ValidateDocument;
            recAmzOrderHead.Modify();
        end;
    end;

    local procedure OrderPreviousCreated(Type: Option BeforeInsert,AfterInsert; pOrderID: Code[50]; pInvoiceNo: Code[50]; pAmountInclVAT: Decimal) rValue: Boolean
    var
        recAmzOrder: Record "eCommerce Order Header";
        recAmzOrder2: Record "eCommerce Order Header";
        recAmzOrderArch: Record "eCommerce Order Archive";
        recAmzOrderArch2: Record "eCommerce Order Archive";
    begin
        case recAmzMktPlace."Import Data from" of
            recAmzMktPlace."import data from"::"Tax Document Library":
                begin
                    // If it´s coming from "Tax Library Document" we don´t know which shipment it´s coming from, so we filter only on "OrderID".
                    recAmzOrder.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.", "Completely Imported");
                    recAmzOrder.SetRange("Transaction Type", recAmzOrder."transaction type"::Order);
                    recAmzOrder.SetRange("Import Source Type", recAmzOrder."import source type"::"Tax Library Document");
                    recAmzOrder.SetRange("eCommerce Order Id", pOrderID);
                    recAmzOrder.SetRange("Completely Imported", true);
                    recAmzOrder.SetAutoCalcFields("Amount Including VAT");
                    if (Type = Type::AfterInsert) and recAmzOrder.FindFirst() and (recAmzOrder."Amount Including VAT" = pAmountInclVAT) then
                        rValue := true
                    else begin
                        recAmzOrder2.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.", "Completely Imported");
                        recAmzOrder2.SetRange("Transaction Type", recAmzOrder2."transaction type"::Order);
                        recAmzOrder2.SetRange("Import Source Type", recAmzOrder2."import source type"::"eCommerce Fulfilled Shipment");
                        recAmzOrder2.SetRange("eCommerce Order Id", pOrderID);
                        recAmzOrder2.SetRange("Invoice No.", pInvoiceNo);
                        recAmzOrder2.SetRange("Completely Imported", true);
                        if recAmzOrder2.FindFirst() then
                            rValue := true
                        else begin
                            recAmzOrderArch.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.");
                            recAmzOrderArch.SetRange("Transaction Type", recAmzOrderArch."transaction type"::Order);
                            recAmzOrderArch.SetRange("Import Source Type", recAmzOrderArch."import source type"::"Tax Library Document");
                            recAmzOrderArch.SetRange("eCommerce Order Id", pOrderID);
                            recAmzOrderArch.SetAutoCalcFields("Amount Including VAT");
                            if (Type = Type::AfterInsert) and recAmzOrderArch.FindFirst() and (recAmzOrderArch."Amount Including VAT" = pAmountInclVAT) then
                                rValue := true
                            else begin
                                recAmzOrderArch2.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.");
                                recAmzOrderArch2.SetRange("Transaction Type", recAmzOrderArch2."transaction type"::Order);
                                recAmzOrderArch2.SetRange("Import Source Type", recAmzOrderArch2."import source type"::"eCommerce Fulfilled Shipment");
                                recAmzOrderArch2.SetRange("eCommerce Order Id", pOrderID);
                                recAmzOrderArch2.SetRange("Invoice No.", pInvoiceNo);
                                if recAmzOrderArch2.FindFirst() then
                                    rValue := true;
                            end;
                        end;
                    end;
                end;
            recAmzMktPlace."import data from"::"eCommerce Fulfilled Shipments/Returns":
                exit((recAmzOrder.Get(TransactTypeOption, pOrderID, pInvoiceNo) and recAmzOrder."Completely Imported") or
                      recAmzOrderArch.Get(TransactTypeOption, pOrderID, pInvoiceNo));
        end;
    end;

    local procedure GetMarketPlace()
    begin
        if MarketplaceID <> recAmzMktPlace."Marketplace ID" then begin
            recAmzMktPlace.Reset();
            recAmzMktPlace.SetAutoCalcFields("VAT Bus Post. Grp. (Ship-From)");
            recAmzMktPlace.Get(MarketplaceID);
            recAmzMktPlace.TestField(Active, true);
            recAmzMktPlace.TestField("VAT Bus Post. Grp. (Ship-From)");
            recAmzMktPlace.TestField("VAT Bus Posting Group (EU)");
            recAmzMktPlace.TestField("VAT Bus Posting Group (No VAT)");
            recAmzMktPlace.TestField("Main Market Place ID");
            recAmzMktPlace.TestField("VAT Prod. Posting Group");
        end;
        VATProdPostingGroup := recAmzMktPlace."VAT Prod. Posting Group";
    end;

    local procedure ConvertToDate(DateStr: Text[250]) rValue: Date
    var
        workString: Text[250];
        String1: Text[250];
        String2: Text[250];
        String3: Text[250];
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        if DateStr <> '' then begin
            Evaluate(Year, CopyStr(DateStr, 1, 4));
            Evaluate(Month, CopyStr(DateStr, 6, 2));
            Evaluate(Day, CopyStr(DateStr, 9, 2));
            rValue := Dmy2date(Day, Month, Year);

            /*// Day
            workString := CONVERTSTR(DateStr,'-',',');
            String1 := SELECTSTR(1,workString);
            EVALUATE(Day,String1);

            // Month
            String2 := SELECTSTR(2,workString);
            IF String2 = 'Jan' THEN Month := 1;
            IF String2 = 'Feb' THEN Month := 2;
            IF String2 = 'Mar' THEN Month := 3;
            IF String2 = 'Apr' THEN Month := 4;
            IF String2 = 'May' THEN Month := 5;
            IF String2 = 'Jun' THEN Month := 6;
            IF String2 = 'Jul' THEN Month := 7;
            IF String2 = 'Aug' THEN Month := 8;
            IF String2 = 'Sep' THEN Month := 9;
            IF String2 = 'Oct' THEN Month := 10;
            IF String2 = 'Nov' THEN Month := 11;
            IF String2 = 'Dec' THEN Month := 12;

            // Year
            String3 := SELECTSTR(3,workString);
            String3 := DELCHR(String3,'=',' ');
            String3 := DELCHR(String3,'=','U');
            String3 := DELCHR(String3,'=','T');
            String3 := DELCHR(String3,'=','C');
            EVALUATE(Year,String3);

            rValue := DMY2DATE(Day,Month,Year);*/
        end;
    end;

    local procedure ConvertAmount(pAmountStr: Text): Decimal
    var
        EvaluateTest: Decimal;
        lAmount: Decimal;
        DevideBy: Integer;
        i: Integer;
        j: Integer;
    begin
        pAmountStr := DelChr(pAmountStr, '=', '£$');
        if (CopyStr(pAmountStr, 1, 1) <> '-') and (not Evaluate(EvaluateTest, CopyStr(pAmountStr, 1, 1))) then
            pAmountStr := CopyStr(pAmountStr, 2, MaxStrLen(pAmountStr));  // Removing Euro

        DevideBy := 1;
        for i := StrLen(pAmountStr) downto StrLen(pAmountStr) - 2 do begin
            if i > 0 then begin
                if (pAmountStr[i] = '.') or (pAmountStr[i] = ',') then
                    DevideBy := j;

                if j = 0 then
                    j := 10
                else
                    j := j * 10;
            end;
        end;

        pAmountStr := DelChr(pAmountStr, '=', ',.');
        Evaluate(lAmount, pAmountStr);
        exit(lAmount / DevideBy);
    end;

    procedure GetQuantityImported(): Integer
    begin
        exit(NewRecords);
    end;

    procedure InitXmlPort(NewSize: Integer)
    begin
        //TotalRowCount := ROUND(NewSize / 1000 * 1.66,1);
    end;
}
