xmlport 50021 "Adj. eCommerce Tax Doc. Import"
{
    Caption = 'eCommerce Tax Doc. Import';
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
                textelement(Col49)
                {
                }
                textelement(Col50)
                {
                }
                textelement(Col51)
                {
                }
                textelement(Col52)
                {
                }
                textelement(Col53)
                {
                }
                textelement(Col54)
                {
                }
                textelement(Col55)
                {
                }
                textelement(Col56)
                {
                }
                textelement(Col57)
                {
                }
                textelement(Col58)
                {
                }
                textelement(Col59)
                {
                }
                textelement(Col60)
                {
                }
                textelement(Col61)
                {
                }
                textelement(Col62)
                {
                }
                textelement(Col63)
                {
                }
                textelement(Col64)
                {
                }
                textelement(Col65)
                {
                }
                textelement(Col66)
                {
                }
                textelement(Col67)
                {
                }
                textelement(Col68)
                {
                }
                textelement(Col69)
                {
                }
                textelement(Col70)
                {
                }
                textelement(Col71)
                {
                }
                textelement(Col72)
                {
                }
                textelement(Col73)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    recAmzArch: Record "eCommerce Order Archive";
                    recAmzArchLine: Record "eCommerce Order Line Archive";
                    recAmz: Record "eCommerce Order Header";
                    recAmzLine: Record "eCommerce Order Line";
                    CreateOrder: Boolean;
                    TrType: Integer;
                begin
                    ZGT.UpdateProgressWindow(StrSubstNo('%1 %2', OrderID, ShipmentID), 0, true);

                    if TotalToImport = 0 then
                        TotalToImport := Integer.Count();

                    if SetValues then
                        if OrderPreviousCreated then
                            if (SHIPPINGTaxExclusivePromoAmount <> 0) or
                               (GIFTWRAPTaxExclusiveSellingPrice <> 0) or
                               (GIFTWRAPTaxExclusivePromoAmount <> 0)
                            then
                                if recAmzArch.Get(TransactTypeOption, OrderID, VATInvoiceNumber) then begin
                                    recAmzArchLine.SetRange("Transaction Type", recAmzArch."Transaction Type");
                                    recAmzArchLine.SetRange("eCommerce Order Id", recAmzArch."eCommerce Order Id");
                                    recAmzArchLine.SetRange("Invoice No.", recAmzArch."Invoice No.");
                                    recAmzArchLine.SetRange(ASIN, ASINImport);
                                    recAmzArchLine.SetRange("Item No.", SKU);
                                    recAmzArchLine.SetRange(Quantity, QuantityImport);
                                    recAmzArchLine.FindFirst();
                                    if recAmzArchLine.Count() <> 1 then
                                        Error('More than one line.');

                                    if recAmzArch."Transaction Type" = recAmzArch."transaction type"::Refund then begin
                                        recAmzArchLine."Shipping Promo (Inc. Tax)" := -SHIPPINGTaxInclusivePromoAmount;
                                        recAmzArchLine."Shipping Promo Tax Amount" := -SHIPPINGTaxAmountPromo;
                                        recAmzArchLine."Shipping Promo (Exc. Tax)" := -SHIPPINGTaxExclusivePromoAmount;
                                        recAmzArchLine."Gift Wrap (Inc. Tax)" := -GIFTWRAPTaxInclusiveSellingPrice;
                                        recAmzArchLine."Gift Wrap Tax Amount" := -GIFTWRAPTaxAmount;
                                        recAmzArchLine."Gift Wrap (Exc. Tax)" := -GIFTWRAPTaxExclusiveSellingPrice;
                                        recAmzArchLine."Gift Wrap Promo (Inc. Tax)" := -GIFTWRAPTaxInclusivePromoAmount;
                                        recAmzArchLine."Gift Wrap Promo Tax Amount" := -GIFTWRAPTaxAmountPromo;
                                        recAmzArchLine."Gift Wrap Promo (Exc. Tax)" := -GIFTWRAPTaxExclusivePromoAmount;
                                        recAmzArchLine.Amount :=
                                          recAmzArchLine."Total (Exc. Tax)" +
                                          recAmzArchLine."Total Shipping (Exc. Tax)" + recAmzArchLine."Shipping Promo (Exc. Tax)" +
                                          recAmzArchLine."Total Promo (Exc. Tax)" +
                                          recAmzArchLine."Gift Wrap (Exc. Tax)" + recAmzArchLine."Gift Wrap Promo (Exc. Tax)" +
                                          recAmzArchLine."Line Discount Excl. Tax";
                                        recAmzArchLine."Tax Amount" :=
                                          recAmzArchLine."Total Tax Amount" +
                                          recAmzArchLine."Total Shipping Tax Amount" + recAmzArchLine."Shipping Promo Tax Amount" +
                                          recAmzArchLine."Total Promo Tax Amount" +
                                          recAmzArchLine."Gift Wrap Tax Amount" + recAmzArchLine."Gift Wrap Promo Tax Amount" +
                                          recAmzArchLine."Line Discount Tax Amount";
                                        recAmzArchLine."Amount Including VAT" :=
                                          recAmzArchLine."Total (Inc. Tax)" +
                                          recAmzArchLine."Total Shipping (Inc. Tax)" + recAmzArchLine."Shipping Promo (Inc. Tax)" +
                                          recAmzArchLine."Total Promo (Inc. Tax)" +
                                          recAmzArchLine."Gift Wrap (Inc. Tax)" + recAmzArchLine."Gift Wrap Promo (Inc. Tax)" +
                                          recAmzArchLine."Line Discount Incl. Tax";
                                        recAmzArchLine.Modify();
                                    end else begin
                                        recAmzArchLine."Shipping Promo (Inc. Tax)" := SHIPPINGTaxInclusivePromoAmount;
                                        recAmzArchLine."Shipping Promo Tax Amount" := SHIPPINGTaxAmountPromo;
                                        recAmzArchLine."Shipping Promo (Exc. Tax)" := SHIPPINGTaxExclusivePromoAmount;
                                        recAmzArchLine."Gift Wrap (Inc. Tax)" := GIFTWRAPTaxInclusiveSellingPrice;
                                        recAmzArchLine."Gift Wrap Tax Amount" := GIFTWRAPTaxAmount;
                                        recAmzArchLine."Gift Wrap (Exc. Tax)" := GIFTWRAPTaxExclusiveSellingPrice;
                                        recAmzArchLine."Gift Wrap Promo (Inc. Tax)" := GIFTWRAPTaxInclusivePromoAmount;
                                        recAmzArchLine."Gift Wrap Promo Tax Amount" := GIFTWRAPTaxAmountPromo;
                                        recAmzArchLine."Gift Wrap Promo (Exc. Tax)" := GIFTWRAPTaxExclusivePromoAmount;
                                        recAmzArchLine.Amount :=
                                          recAmzArchLine."Total (Exc. Tax)" +
                                          recAmzArchLine."Total Shipping (Exc. Tax)" + recAmzArchLine."Shipping Promo (Exc. Tax)" +
                                          recAmzArchLine."Total Promo (Exc. Tax)" +
                                          recAmzArchLine."Gift Wrap (Exc. Tax)" + recAmzArchLine."Gift Wrap Promo (Exc. Tax)" +
                                          recAmzArchLine."Line Discount Excl. Tax";
                                        recAmzArchLine."Tax Amount" :=
                                          recAmzArchLine."Total Tax Amount" +
                                          recAmzArchLine."Total Shipping Tax Amount" + recAmzArchLine."Shipping Promo Tax Amount" +
                                          recAmzArchLine."Total Promo Tax Amount" +
                                          recAmzArchLine."Gift Wrap Tax Amount" + recAmzArchLine."Gift Wrap Promo Tax Amount" +
                                          recAmzArchLine."Line Discount Tax Amount";
                                        recAmzArchLine."Amount Including VAT" :=
                                          recAmzArchLine."Total (Inc. Tax)" +
                                          recAmzArchLine."Total Shipping (Inc. Tax)" + recAmzArchLine."Shipping Promo (Inc. Tax)" +
                                          recAmzArchLine."Total Promo (Inc. Tax)" +
                                          recAmzArchLine."Gift Wrap (Inc. Tax)" + recAmzArchLine."Gift Wrap Promo (Inc. Tax)" +
                                          recAmzArchLine."Line Discount Incl. Tax";
                                        recAmzArchLine.Modify();
                                    end;
                                end else begin
                                    if recAmz.Get(TransactTypeOption, OrderID, VATInvoiceNumber) then begin
                                        recAmzLine.SetRange("Transaction Type", recAmz."Transaction Type");
                                        recAmzLine.SetRange("eCommerce Order Id", recAmz."eCommerce Order Id");
                                        recAmzLine.SetRange("Invoice No.", recAmz."Invoice No.");
                                        recAmzLine.SetRange(ASIN, ASINImport);
                                        recAmzLine.SetRange("Item No.", SKU);
                                        recAmzLine.SetRange(Quantity, QuantityImport);
                                        recAmzLine.FindFirst();
                                        if recAmzLine.Count() <> 1 then
                                            Error('More than one line.');

                                        if recAmz."Transaction Type" = recAmz."transaction type"::Refund then begin
                                            recAmzLine."Shipping Promo (Inc. Tax)" := -SHIPPINGTaxInclusivePromoAmount;
                                            recAmzLine."Shipping Promo Tax Amount" := -SHIPPINGTaxAmountPromo;
                                            recAmzLine."Shipping Promo (Exc. Tax)" := -SHIPPINGTaxExclusivePromoAmount;
                                            recAmzLine."Gift Wrap (Inc. Tax)" := -GIFTWRAPTaxInclusiveSellingPrice;
                                            recAmzLine."Gift Wrap Tax Amount" := -GIFTWRAPTaxAmount;
                                            recAmzLine."Gift Wrap (Exc. Tax)" := -GIFTWRAPTaxExclusiveSellingPrice;
                                            recAmzLine."Gift Wrap Promo (Inc. Tax)" := -GIFTWRAPTaxInclusivePromoAmount;
                                            recAmzLine."Gift Wrap Promo Tax Amount" := -GIFTWRAPTaxAmountPromo;
                                            recAmzLine."Gift Wrap Promo (Exc. Tax)" := -GIFTWRAPTaxExclusivePromoAmount;
                                            recAmzLine.Amount :=
                                              recAmzLine."Total (Exc. Tax)" +
                                              recAmzLine."Total Shipping (Exc. Tax)" + recAmzLine."Shipping Promo (Exc. Tax)" +
                                              recAmzLine."Total Promo (Exc. Tax)" +
                                              recAmzLine."Gift Wrap (Exc. Tax)" + recAmzLine."Gift Wrap Promo (Exc. Tax)" +
                                              recAmzLine."Line Discount Excl. Tax";
                                            recAmzLine."Tax Amount" :=
                                              recAmzLine."Total Tax Amount" +
                                              recAmzLine."Total Shipping Tax Amount" + recAmzLine."Shipping Promo Tax Amount" +
                                              recAmzLine."Total Promo Tax Amount" +
                                              recAmzLine."Gift Wrap Tax Amount" + recAmzLine."Gift Wrap Promo Tax Amount" +
                                              recAmzLine."Line Discount Tax Amount";
                                            recAmzLine."Amount Including VAT" :=
                                              recAmzLine."Total (Inc. Tax)" +
                                              recAmzLine."Total Shipping (Inc. Tax)" + recAmzLine."Shipping Promo (Inc. Tax)" +
                                              recAmzLine."Total Promo (Inc. Tax)" +
                                              recAmzLine."Gift Wrap (Inc. Tax)" + recAmzLine."Gift Wrap Promo (Inc. Tax)" +
                                              recAmzLine."Line Discount Incl. Tax";
                                            recAmzLine.Modify();
                                        end else begin
                                            recAmzLine."Shipping Promo (Inc. Tax)" := SHIPPINGTaxInclusivePromoAmount;
                                            recAmzLine."Shipping Promo Tax Amount" := SHIPPINGTaxAmountPromo;
                                            recAmzLine."Shipping Promo (Exc. Tax)" := SHIPPINGTaxExclusivePromoAmount;
                                            recAmzLine."Gift Wrap (Inc. Tax)" := GIFTWRAPTaxInclusiveSellingPrice;
                                            recAmzLine."Gift Wrap Tax Amount" := GIFTWRAPTaxAmount;
                                            recAmzLine."Gift Wrap (Exc. Tax)" := GIFTWRAPTaxExclusiveSellingPrice;
                                            recAmzLine."Gift Wrap Promo (Inc. Tax)" := GIFTWRAPTaxInclusivePromoAmount;
                                            recAmzLine."Gift Wrap Promo Tax Amount" := GIFTWRAPTaxAmountPromo;
                                            recAmzLine."Gift Wrap Promo (Exc. Tax)" := GIFTWRAPTaxExclusivePromoAmount;
                                            recAmzLine.Amount :=
                                              recAmzLine."Total (Exc. Tax)" +
                                              recAmzLine."Total Shipping (Exc. Tax)" + recAmzLine."Shipping Promo (Exc. Tax)" +
                                              recAmzLine."Total Promo (Exc. Tax)" +
                                              recAmzLine."Gift Wrap (Exc. Tax)" + recAmzLine."Gift Wrap Promo (Exc. Tax)" +
                                              recAmzLine."Line Discount Excl. Tax";
                                            recAmzLine."Tax Amount" :=
                                              recAmzLine."Total Tax Amount" +
                                              recAmzLine."Total Shipping Tax Amount" + recAmzLine."Shipping Promo Tax Amount" +
                                              recAmzLine."Total Promo Tax Amount" +
                                              recAmzLine."Gift Wrap Tax Amount" + recAmzLine."Gift Wrap Promo Tax Amount" +
                                              recAmzLine."Line Discount Tax Amount";
                                            recAmzLine."Amount Including VAT" :=
                                              recAmzLine."Total (Inc. Tax)" +
                                              recAmzLine."Total Shipping (Inc. Tax)" + recAmzLine."Shipping Promo (Inc. Tax)" +
                                              recAmzLine."Total Promo (Inc. Tax)" +
                                              recAmzLine."Gift Wrap (Inc. Tax)" + recAmzLine."Gift Wrap Promo (Inc. Tax)" +
                                              recAmzLine."Line Discount Incl. Tax";
                                            recAmzLine.Modify();
                                        end;
                                    end;
                                end;

                    currXMLport.Skip();
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        ZGT.CloseProgressWindow;
        //MESSAGE(Text001,NewRecords);
    end;

    trigger OnPreXmlPort()
    begin
        ZGT.OpenProgressWindow('', TotalRowCount);
    end;

    var
        recAmzOrderHead: Record "eCommerce Order Header";
        recAmzMktPlace: Record "eCommerce Market Place";
        recAmzCtryMapTo: Record "eCommerce Country Mapping";
        recAmzCtryMapFrom: Record "eCommerce Country Mapping";
        ZGT: Codeunit "ZyXEL General Tools";
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
        OUR_PRICETaxInclusiveSellingPrice: Decimal;
        OUR_PRICETaxAmount: Decimal;
        OUR_PRICETaxExclusiveSellingPrice: Decimal;
        OUR_PRICETaxInclusivePromoAmount: Decimal;
        OUR_PRICETaxAmountPromo: Decimal;
        OUR_PRICETaxExclusivePromoAmount: Decimal;
        SHIPPINGTaxInclusiveSellingPrice: Decimal;
        SHIPPINGTaxAmount: Decimal;
        SHIPPINGTaxExclusiveSellingPrice: Decimal;
        SHIPPINGTaxInclusivePromoAmount: Decimal;
        SHIPPINGTaxAmountPromo: Decimal;
        SHIPPINGTaxExclusivePromoAmount: Decimal;
        GIFTWRAPTaxInclusiveSellingPrice: Decimal;
        GIFTWRAPTaxAmount: Decimal;
        GIFTWRAPTaxExclusiveSellingPrice: Decimal;
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
        Text015: Label '"%1" %2 does not exist.';
        Text023: Label 'Treshold has been reached, but we hav no VAT-no. in %1.';
        TotalToImport: Integer;
        TotalRowCount: Integer;

    local procedure SetValues(): Boolean
    var
        recCountry: Record "Country/Region";
        lText001: Label '"%1" not found.';
    begin
        if StrPos(Col01, 'arketpl') <> 0 then
            exit(false);

        MarketplaceID := Col01;
        MerchantID := Col02;
        OrderDate := ConvertToDate(Col03);
        TransactType := Col04;
        case UpperCase(TransactType) of
            'RETURN',
          'REFUND':
                TransactTypeOption := Transacttypeoption::Refund;
            'SHIPMENT',
          'LIQUIDATIONS':
                TransactTypeOption := Transacttypeoption::Order;
            else
                Error(lText001, TransactType);
        end;
        OrderID := Col06;
        ShipmentDate := ConvertToDate(Col07);
        ShipmentID := Col08;
        TransactionID := Col09;
        ASINImport := Col10;
        SKU := Col11;
        Evaluate(QuantityImport, Col12, 9);
        TaxCalculationDate := ConvertToDate(Col13);
        Evaluate(TaxRate, Col14, 9);
        TaxRate := TaxRate * 100;
        ProductTaxCode := Col15;
        Currency := Col16;
        TaxType := Col17;
        TaxCalculationReasonCode := Col18;
        TaxAddressRole := Col21;
        JurisdictionLevel := Col22;
        JurisdictionName := Col23;

        OUR_PRICETaxInclusiveSellingPrice := ConvertAmount(Col24);
        OUR_PRICETaxAmount := ConvertAmount(Col25);
        OUR_PRICETaxExclusiveSellingPrice := ConvertAmount(Col26);
        OUR_PRICETaxInclusivePromoAmount := ConvertAmount(Col27);
        OUR_PRICETaxAmountPromo := ConvertAmount(Col28);
        OUR_PRICETaxExclusivePromoAmount := ConvertAmount(Col29);
        SHIPPINGTaxInclusiveSellingPrice := ConvertAmount(Col30);
        SHIPPINGTaxAmount := ConvertAmount(Col31);
        SHIPPINGTaxExclusiveSellingPrice := ConvertAmount(Col32);
        SHIPPINGTaxInclusivePromoAmount := ConvertAmount(Col33);
        SHIPPINGTaxAmountPromo := ConvertAmount(Col34);
        SHIPPINGTaxExclusivePromoAmount := ConvertAmount(Col35);
        GIFTWRAPTaxInclusiveSellingPrice := ConvertAmount(Col36);
        GIFTWRAPTaxAmount := ConvertAmount(Col37);
        GIFTWRAPTaxExclusiveSellingPrice := ConvertAmount(Col38);
        GIFTWRAPTaxInclusivePromoAmount := ConvertAmount(Col39);
        GIFTWRAPTaxAmountPromo := ConvertAmount(Col40);
        GIFTWRAPTaxExclusivePromoAmount := ConvertAmount(Col41);
        /*IF (SHIPPINGTaxExclusivePromoAmount <> 0) OR
           (GIFTWRAPTaxExclusiveSellingPrice <> 0) OR
           (GIFTWRAPTaxExclusivePromoAmount <> 0)
        THEN
          ERROR('Contact NavSupport@zyxel.eu');*/

        SellerTaxRegistration := Col42;
        SellerTaxRegistrationJurisdiction := Col43;
        BuyerTaxRegistration := Col44;
        BuyerTaxRegistrationJurisdiction := Col45;
        BuyerTaxRegistrationType := UpperCase(Col47);  //XX
        InvoiceLevelCurrencyCode := Col48;
        Evaluate(InvoiceLevelExchangeRate, Col49, 9);
        InvoiceLevelExchangeRateDate := ConvertToDate(Col50);
        Evaluate(ConvertedTaxAmount, Col51, 9);
        VATInvoiceNumber := Col52;
        InvoiceUrl := Col53;
        Evaluate(ExportOutsideEU, Col54);
        ShipFromCity := Col55;
        ShipFromState := Col56;
        ShipFromCountry := Col57;
        ShipFromPostalCode := Col58;
        ShipFromTaxLocationCode := Col59;
        ShipToCity := Col60;
        ShipToState := Col61;
        ShipToCountry := Col62;
        ShipToPostalCode := Col63;
        ShipToLocationCode := Col64;
        ReturnFcCountry := Col65;
        ErrorTxt := '';

        if not recCountry.Get(ShipToCountry) then begin
            recCountry.Code := ShipToCountry;
            recCountry.Insert(true);
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
            //TODO: LD vender tilabge med rettelse til nedenstående
            //recAmzOrderHead.SetTaxValue(TaxType,TaxCalculationReasonCode,TaxAddressRole,BuyerTaxRegistrationType);
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
            recAmzOrderHead.Validate(recAmzOrderHead."Ship From Country", CopyStr(ShipFromCountry, 1, MaxStrLen(recAmzOrderHead."Ship From Country")));
            recAmzOrderHead.Validate(recAmzOrderHead."Ship From Postal Code", CopyStr(ShipFromPostalCode, 1, MaxStrLen(recAmzOrderHead."Ship From Postal Code")));
            recAmzOrderHead.Validate(recAmzOrderHead."Ship From Tax Location Code", CopyStr(ShipFromTaxLocationCode, 1, MaxStrLen(recAmzOrderHead."Ship From Tax Location Code")));
            recAmzOrderHead.Validate(recAmzOrderHead."VAT Registration No. Zyxel", SellerTaxRegistration);
            recAmzOrderHead.Validate(recAmzOrderHead."Invoice Download", InvoiceUrl);
            recAmzOrderHead.Validate(recAmzOrderHead."Currency Code", Currency);

            /*  // VAT Bus. Posting Group
              recAmzCtryMapTo.SETAUTOCALCFIELDS("Threshold Posted","Threshold Posted Archive");
              IF recAmzCtryMapTo.GET("Customer No.","Ship To Country") THEN BEGIN
                recAmzCtryMapTo.TESTFIELD("Country Dimension");
                recAmzCtryMapTo.TESTFIELD("VAT Bus. Posting Group");
                VALIDATE("Country Dimension",recAmzCtryMapTo."Country Dimension");

                recAmzCtryMapFrom.GET("Customer No.","Ship From Country");
                recAmzCtryMapFrom.TESTFIELD("Country Dimension");
                recAmzCtryMapFrom.TESTFIELD("VAT Bus. Posting Group");

                IF NOT ExportOutsideEU THEN BEGIN
                  IF "Sell-to Type" = "Sell-to Type"::Consumer THEN BEGIN
                    IF ShipToCountry = ShipFromCountry THEN BEGIN
                      IF ShipFromCountry <> recAmzMktPlace."Main Market Place ID" THEN
                        VATBusPostingGroup := recAmzCtryMapFrom."VAT Bus. Posting Group"
                      ELSE
                        VATBusPostingGroup := recAmzMktPlace."VAT Bus Post. Grp. (Ship-From)"  // Is the same as (Ship-to)
                    END ELSE BEGIN
                      IF recAmzCtryMapTo."Ship-to VAT No." <> '' THEN BEGIN  // ZNet has a VAT No. in the country
                        IF ShipToCountry = recAmzMktPlace."Main Market Place ID" THEN
                          VATBusPostingGroup := recAmzCtryMapTo."VAT Bus. Posting Group"
                        ELSE BEGIN
                          VATBusPostingGroup := recAmzCtryMapFrom."VAT Bus. Posting Group"
                        END;
                      END ELSE BEGIN
                        IF (recAmzCtryMapTo."Threshold Posted" + recAmzCtryMapTo."Threshold Posted Archive") <= recAmzCtryMapTo."Threshold Amount" THEN BEGIN
                          IF ShipFromCountry <> recAmzMktPlace."Main Market Place ID" THEN BEGIN
                            recAmzCtryMapFrom.TESTFIELD("VAT Bus. Posting Group");
                            VATBusPostingGroup := recAmzCtryMapFrom."VAT Bus. Posting Group"
                          END ELSE
                            VATBusPostingGroup := recAmzMktPlace."VAT Bus Post. Grp. (Ship-From)"
                        END ELSE BEGIN
                          recAmzCtryMapTo."Threshold Reached" := TRUE;
                          recAmzCtryMapTo."Threshold Reached Date" := TODAY;
                          recAmzCtryMapTo.MODIFY;
                          ErrorTxt := STRSUBSTNO(Text023,ShipToCountry);
                        END;
                      END;
                    END;
                  END ELSE BEGIN  // Business
                    IF (ShipToCountry <> ShipFromCountry) OR
                        ((ShipFromCountry = ShipToCountry) AND recAmzCtryMapTo."Use Reverce Charge - DOM Bus")
                    THEN
                      VATBusPostingGroup := recAmzMktPlace."VAT Bus Posting Group (EU)"
                    ELSE
                      IF ShipFromCountry <> recAmzMktPlace."Main Market Place ID" THEN BEGIN
                        recAmzCtryMapFrom.TESTFIELD("VAT Bus. Posting Group");
                        VATBusPostingGroup := recAmzCtryMapFrom."VAT Bus. Posting Group"
                      END ELSE
                        VATBusPostingGroup := recAmzMktPlace."VAT Bus Post. Grp. (Ship-From)"  // Is the same as (Ship-to)
                  END;
                END ELSE BEGIN  // ExportOutsideEU
                  CASE "Sell-to Type" OF
                    "Sell-to Type"::Consumer : VATBusPostingGroup := recAmzMktPlace."VAT Bus Posting Group (No VAT)";
                    "Sell-to Type"::Business : VATBusPostingGroup := recAmzMktPlace."VAT Bus Posting Group (No VAT)";
                  END;
                END;

                // VAT Prod. Posting Group
                IF recVatPostSetup.GET(VATBusPostingGroup,VATProdPostingGroup) THEN
                  IF (recVatPostSetup."VAT %" <> TaxRate) AND
                     (recVatPostSetup."VAT Calculation Type" <> recVatPostSetup."VAT Calculation Type"::"Reverse Charge VAT")
                  THEN BEGIN
                    CASE TaxAddressRole OF
                      'ShipTo' : VATBusPostingGroup := recAmzCtryMapTo."VAT Bus. Posting Group";
                      'ShipFrom' : VATBusPostingGroup := recAmzCtryMapFrom."VAT Bus. Posting Group";
                    END;

                    IF recVatPostSetup.GET(VATBusPostingGroup,VATProdPostingGroup) THEN
                      IF (recVatPostSetup."VAT %" <> TaxRate) AND
                          (recVatPostSetup."VAT Calculation Type" <> recVatPostSetup."VAT Calculation Type"::"Reverse Charge VAT")
                      THEN
                        VATProdPostingGroup := VATProdPostingGroup + FORMAT(TaxRate);
                  END;
              END;

              VALIDATE("VAT Bus. Posting Group",VATBusPostingGroup);
            */
            NewRecords := NewRecords + 1;
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
            recAmzOrderLine.Validate(recAmzOrderLine."Transaction Type", recAmzOrderHead."Transaction Type");
            recAmzOrderLine.Validate(recAmzOrderLine."eCommerce Order Id", OrderID);
            recAmzOrderLine.Validate(recAmzOrderLine."Invoice No.", VATInvoiceNumber);
            recAmzOrderLine.Validate(recAmzOrderLine."Line No.", recAmzOrderLine2."Line No." + 10000);
            recAmzOrderLine.Validate(recAmzOrderLine.ASIN, ASINImport);
            recAmzOrderLine.Validate(recAmzOrderLine."Item No.", SKU);
            recAmzOrderLine.Validate(recAmzOrderLine.Quantity, QuantityImport);
            recAmzOrderLine.Validate(recAmzOrderLine."VAT Prod. Posting Group", VATProdPostingGroup);

            if recAmzOrderLine."Transaction Type" = recAmzOrderLine."transaction type"::Refund then begin
                recAmzOrderLine.Validate(recAmzOrderLine."Total (Inc. Tax)", -OUR_PRICETaxInclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Tax Amount", -OUR_PRICETaxAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total (Exc. Tax)", -OUR_PRICETaxExclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Promo (Inc. Tax)", -OUR_PRICETaxInclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Promo Tax Amount", -OUR_PRICETaxAmountPromo);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Promo (Exc. Tax)", -OUR_PRICETaxExclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping (Inc. Tax)", -SHIPPINGTaxInclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping Tax Amount", -SHIPPINGTaxAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping (Exc. Tax)", -SHIPPINGTaxExclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo (Inc. Tax)", -SHIPPINGTaxInclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo Tax Amount", -SHIPPINGTaxAmountPromo);
                recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo (Exc. Tax)", -SHIPPINGTaxExclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap (Inc. Tax)", -GIFTWRAPTaxInclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Tax Amount", -GIFTWRAPTaxAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap (Exc. Tax)", -GIFTWRAPTaxExclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Promo (Inc. Tax)", -GIFTWRAPTaxInclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Promo Tax Amount", -GIFTWRAPTaxAmountPromo);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Promo (Exc. Tax)", -GIFTWRAPTaxExclusivePromoAmount);
            end else begin
                recAmzOrderLine.Validate(recAmzOrderLine."Total (Inc. Tax)", OUR_PRICETaxInclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Tax Amount", OUR_PRICETaxAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total (Exc. Tax)", OUR_PRICETaxExclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Promo (Inc. Tax)", OUR_PRICETaxInclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Promo Tax Amount", OUR_PRICETaxAmountPromo);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Promo (Exc. Tax)", OUR_PRICETaxExclusivePromoAmount);
                if recAmzOrderLine."Total Promo (Exc. Tax)" > 0 then
                    Error('Contact NAVsupport');
                recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping (Inc. Tax)", SHIPPINGTaxInclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping Tax Amount", SHIPPINGTaxAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Total Shipping (Exc. Tax)", SHIPPINGTaxExclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo (Inc. Tax)", SHIPPINGTaxInclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo Tax Amount", SHIPPINGTaxAmountPromo);
                recAmzOrderLine.Validate(recAmzOrderLine."Shipping Promo (Exc. Tax)", SHIPPINGTaxExclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap (Inc. Tax)", GIFTWRAPTaxInclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Tax Amount", GIFTWRAPTaxAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap (Exc. Tax)", GIFTWRAPTaxExclusiveSellingPrice);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Promo (Inc. Tax)", GIFTWRAPTaxInclusivePromoAmount);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Promo Tax Amount", GIFTWRAPTaxAmountPromo);
                recAmzOrderLine.Validate(recAmzOrderLine."Gift Wrap Promo (Exc. Tax)", GIFTWRAPTaxExclusivePromoAmount);
            end;

            recAmzOrderLine."Ship-to Country Code" := ShipToCountry;
            recAmzOrderLine.Validate(recAmzOrderLine.Amount);
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

    local procedure OrderPreviousCreated(): Boolean
    var
        recAmzOrderHead2: Record "eCommerce Order Header";
        recAmzOrderArch: Record "eCommerce Order Archive";
        Res1: Boolean;
        Res2: Boolean;
    begin
        /*recAmzOrderHead2.SETRANGE("Transaction Type",TransactTypeOption);
        recAmzOrderHead2.SETRANGE("eCommerce Order Id",OrderID);
        recAmzOrderHead2.SETRANGE("Invoice No.",VATInvoiceNumber);
        recAmzOrderHead2.SETRANGE("Completely Imported",TRUE);
        EXIT(recAmzOrderHead2.FINDFIRST OR recAmzOrderArch.GET(TransactTypeOption,OrderID,VATInvoiceNumber));*/
        exit((recAmzOrderHead2.Get(TransactTypeOption, OrderID, VATInvoiceNumber) and recAmzOrderHead2."Completely Imported") or
             recAmzOrderArch.Get(TransactTypeOption, OrderID, VATInvoiceNumber));
    end;

    local procedure GetMarketPlace()
    begin
        if MarketplaceID <> recAmzMktPlace."Marketplace ID" then begin
            recAmzMktPlace.SetAutoCalcFields("VAT Bus Post. Grp. (Ship-From)");
            if not recAmzMktPlace.Get(MarketplaceID) then begin
                recAmzMktPlace.CopyDefaultMapping(MarketplaceID);
                recAmzMktPlace.Get(MarketplaceID);
            end;
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
            // Day
            workString := ConvertStr(DateStr, '-', ',');
            String1 := SelectStr(1, workString);
            Evaluate(Day, String1);

            // Month
            String2 := SelectStr(2, workString);
            if String2 = 'Jan' then Month := 1;
            if String2 = 'Feb' then Month := 2;
            if String2 = 'Mar' then Month := 3;
            if String2 = 'Apr' then Month := 4;
            if String2 = 'May' then Month := 5;
            if String2 = 'Jun' then Month := 6;
            if String2 = 'Jul' then Month := 7;
            if String2 = 'Aug' then Month := 8;
            if String2 = 'Sep' then Month := 9;
            if String2 = 'Oct' then Month := 10;
            if String2 = 'Nov' then Month := 11;
            if String2 = 'Dec' then Month := 12;

            // Year
            String3 := SelectStr(3, workString);
            String3 := DelChr(String3, '=', ' ');
            String3 := DelChr(String3, '=', 'U');
            String3 := DelChr(String3, '=', 'T');
            String3 := DelChr(String3, '=', 'C');
            Evaluate(Year, String3);

            rValue := Dmy2date(Day, Month, Year);
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

    local procedure AcceptVatNumber(pVATNo: Code[20]; pOrderDate: Date; pOrderNo: Code[30]; pInvNo: Code[35]; pTransTypeOption: Option "Order",Refund) rValue: Boolean
    var
        recAmzOrdArch: Record "eCommerce Order Archive";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsZComCompany and ZGT.IsRhq then
            rValue := true
        else
            if ZGT.IsZComCompany then begin
                if pVATNo in ['686640822', 'ATU76537534', 'ATU86640822', 'BE0691804097', 'CZ684340226', 'DE812743356', 'ESN2764659E', 'FR43834569063', 'IT00203809991', 'NL825611349B01', 'PL5263207801'] then
                    rValue := true
                else
                    if (pVATNo = '') and (pOrderDate < 20220601D) then
                        rValue := true;
            end else
                if GuiAllowed() then begin
                    if pVATNo in ['686640822', 'ATU76537534', 'ATU86640822', 'BE0691804097', 'CZ684340226', 'DE812743356', 'ESN2764659E', 'FR43834569063', 'IT00203809991', 'NL825611349B01', 'PL5263207801'] then
                        rValue := false
                    else
                        if (pVATNo = '') and (pOrderDate < 20220601D) then
                            rValue := false
                        else
                            rValue := true;
                end else begin
                    recAmzOrdArch.ChangeCompany(ZGT.GetSistersCompanyName(11));
                    if (pVATNo in ['686640822', 'ATU76537534', 'ATU86640822', 'BE0691804097', 'CZ684340226', 'DE812743356', 'ESN2764659E', 'FR43834569063', 'IT00203809991', 'NL825611349B01', 'PL5263207801']) and
                       (recAmzOrdArch.Get(pTransTypeOption, pOrderNo, pInvNo))
                    then
                        rValue := false
                    else
                        rValue := true;
                end;
    end;

    procedure InitXmlPort(NewSize: Integer)
    begin
        TotalRowCount := Round(NewSize / 1000 * 1.66, 1);
    end;
}
