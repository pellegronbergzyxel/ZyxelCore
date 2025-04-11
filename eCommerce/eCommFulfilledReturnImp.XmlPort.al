xmlport 50022 "eComm. Fulfilled Return Imp."
{
    Caption = 'eCommerce Fulfilled Return Import';
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

                trigger OnBeforeInsertRecord()
                var
                    lAmzOrderHead: Record "eCommerce Order Header";
                    CreateOrder: Boolean;
                begin
                    ZGT.UpdateProgressWindow(StrSubstNo('%1 %2', OrderID, ShipmentID), 0, true);

                    if TotalToImport = 0 then
                        TotalToImport := Integer.Count();

                    if SetValues then begin
                        //GetMarketPlace('');
                        if not OrderPreviousCreated(0, OrderID, VATInvoiceNumber, 0) then begin
                            recAmzOrderArch.CopyToEcomOrder(lAmzOrderHead, recAmzOrderArch."transaction type"::Refund, VATInvoiceNumber);
                            lAmzOrderHead."Import Source Type" := lAmzOrderHead."import source type"::"FBA Customer Return";
                            lAmzOrderHead."Ship From City" := recEcomWhse.Code;
                            lAmzOrderHead."Ship From Country" := recEcomWhse."Country Code";
                            lAmzOrderHead."Ship From Postal Code" := '';
                            lAmzOrderHead."Ship From State" := '';
                            lAmzOrderHead."Ship From Tax Location Code" := '';
                            lAmzOrderHead.Modify();
                        end;
                    end;
                    currXMLport.Skip();
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    var
        recAmzOrderLine: Record "eCommerce Order Line";
        CustLedgEntryFound: Boolean;
        ClEntrySum: Decimal;
        PrevExtDocNo: Code[50];
    begin
        ZGT.CloseProgressWindow;

        recAmzMktPlace.Reset();

        recAmzOrderHead.SetRange("Transaction Type", recAmzOrderHead."transaction type"::Refund);
        recAmzOrderHead.SetRange("Import Source Type", recAmzOrderHead."import source type"::"FBA Customer Return");
        recAmzOrderHead.SetRange("Completely Imported", false);
        recAmzOrderHead.SetAutoCalcFields("Amount Including VAT", "Item Amount Incl. VAT");
        if recAmzOrderHead.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recAmzOrderHead.Count());
            repeat
                ZGT.UpdateProgressWindow(recAmzOrderHead."eCommerce Order Id", 0, true);

                recAmzMktPlace.Get(recAmzOrderHead."Marketplace ID");
                //IF recAmzMktPlace."Import Data from" = recAmzMktPlace."Import Data from"::"Tax Document Library" THEN BEGIN  // We don´t know the amount from the FBA Customer Return, so we need to compare against the refund payment.
                if not OrderPreviousCreated(1, recAmzOrderHead."eCommerce Order Id", recAmzOrderHead."Invoice No.", recAmzOrderHead."Amount Including VAT") then begin
                    recCustLedgEntry.SetCurrentkey("External Document No.");
                    recCustLedgEntry.SetRange("External Document No.", recAmzOrderHead."eCommerce Order Id");
                    recCustLedgEntry.SetRange("Document Type", recCustLedgEntry."document type"::Refund);
                    recCustLedgEntry.SetRange(Open, true);
                    recCustLedgEntry.SetAutoCalcFields("Remaining Amount");
                    if recCustLedgEntry.FindSet() then begin
                        CustLedgEntryFound := false;
                        PrevExtDocNo := '';
                        repeat
                            if recCustLedgEntry."External Document No." <> PrevExtDocNo then
                                ClEntrySum := 0;
                            ClEntrySum := ClEntrySum + recCustLedgEntry."Remaining Amount";

                            // It happens that the shipment fee isn´t refunded.
                            if recAmzOrderHead."Item Amount Incl. VAT" - ClEntrySum = 0 then begin
                                recAmzOrderLine.SetRange("Transaction Type", recAmzOrderHead."Transaction Type");
                                recAmzOrderLine.SetRange("eCommerce Order Id", recAmzOrderHead."eCommerce Order Id");
                                recAmzOrderLine.SetRange("Invoice No.", recAmzOrderHead."Invoice No.");
                                if recAmzOrderLine.FindSet(true) then begin
                                    repeat
                                        recAmzOrderLine."Total Promo (Inc. Tax)" := 0;
                                        recAmzOrderLine."Total Promo Tax Amount" := 0;
                                        recAmzOrderLine."Total Shipping (Inc. Tax)" := 0;
                                        recAmzOrderLine."Total Shipping Tax Amount" := 0;
                                        recAmzOrderLine."Total Shipping (Exc. Tax)" := 0;
                                        recAmzOrderLine."Gift Wrap (Inc. Tax)" := 0;
                                        recAmzOrderLine."Gift Wrap Tax Amount" := 0;
                                        recAmzOrderLine."Gift Wrap (Exc. Tax)" := 0;
                                        recAmzOrderLine."Gift Wrap Promo (Inc. Tax)" := 0;
                                        recAmzOrderLine."Gift Wrap Promo Tax Amount" := 0;
                                        recAmzOrderLine."Gift Wrap Promo (Exc. Tax)" := 0;
                                        recAmzOrderLine."Shipping Promo (Inc. Tax)" := 0;
                                        recAmzOrderLine."Shipping Promo Tax Amount" := 0;
                                        recAmzOrderLine."Shipping Promo (Exc. Tax)" := 0;
                                        recAmzOrderLine.Validate(Amount);
                                        recAmzOrderLine.Modify(true);
                                        recAmzOrderHead.CalcFields("Amount Including VAT");
                                    until recAmzOrderLine.Next() = 0;
                                end;
                            end;

                            if recAmzOrderHead."Amount Including VAT" - ClEntrySum = 0 then begin
                                recAmzOrderHead.Validate("Completely Imported", true);
                                recAmzOrderHead.ValidateDocument;
                                recAmzOrderHead.Modify(true);

                                NewRecords := NewRecords + 1;
                                CustLedgEntryFound := true;
                            end;

                            PrevExtDocNo := recCustLedgEntry."External Document No.";
                        until (recCustLedgEntry.Next() = 0) or CustLedgEntryFound;

                        if not CustLedgEntryFound then
                            recAmzOrderHead.Delete(true);
                    end else
                        recAmzOrderHead.Delete(true);
                end else
                    recAmzOrderHead.Delete(true);
            /*END ELSE BEGIN
              recAmzOrderHead.VALIDATE("Completely Imported",TRUE);
              recAmzOrderHead.ValidateDocument;
              recAmzOrderHead.MODIFY(TRUE);
        
              NewRecords := NewRecords + 1;
            END;*/
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
        recAmzOrderArch: Record "eCommerce Order Archive";
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
        PrevOrderID: Code[50];

    local procedure SetValues(): Boolean
    var
        recCountry: Record "Country/Region";
        recVatPostSetup: Record "VAT Posting Setup";
        TotalTaxAmount: Decimal;
        lText001: Label '"%1" not found.';
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        lText002: Label 'FBA-CUST.RETURN';
    begin
        if StrPos(Col01, 'return-date') <> 0 then
            exit(false);

        OrderID := Col02;
        VATInvoiceNumber := lText002;
        if not GetMarketPlace(OrderID) then
            exit(false);

        MarketplaceID := recAmzMktPlace."Marketplace ID";
        MerchantID := Col02;
        ShipmentID := Col03;
        ASINImport := Col04;
        OrderDate := ConvertToDate(Col01);
        ShipmentDate := OrderDate;
        TransactType := 'REFUND';
        case UpperCase(TransactType) of
            'RETURN',
          'REFUND':
                TransactTypeOption := Transacttypeoption::Refund;
            'SHIPMENT':
                TransactTypeOption := Transacttypeoption::Order;
            else
                Error(lText001, TransactType);
        end;
        SKU := Col03;
        Evaluate(QuantityImport, Col07, 9);

        if not recEcomWhse.Get(Col08) then begin
            Clear(recEcomWhse);
            recEcomWhse.Init();
            recEcomWhse.Code := Col08;
            recEcomWhse.Insert(true);

            SI.SetMergefield(100, Col08);
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
        /*WITH recAmzOrderHead DO BEGIN
          GetMarketPlace('');
        
          CLEAR(recAmzOrderHead);
          INIT;
          SetVatProdPostingGroup(VATProdPostingGroup);
          VALIDATE("eCommerce Order Id",OrderID);
          VALIDATE("Invoice No.",VATInvoiceNumber);
          VALIDATE("Marketplace ID",MarketplaceID);
          VALIDATE("Purchaser VAT No.",BuyerTaxRegistration);
          VALIDATE("Export Outside EU",ExportOutsideEU);
          SetTransactionType(TransactType);
          SetTaxValue(TaxType,TaxCalculationReasonCode,TaxAddressRole,BuyerTaxRegistrationType);
          VALIDATE("Tax Rate",TaxRate);
        
          VALIDATE("Merchant ID",MerchantID);
          VALIDATE("Transaction ID",TransactionID);
          VALIDATE("Shipment ID",ShipmentID);
          VALIDATE("Order Date",OrderDate);
          VALIDATE("Shipment Date",ShipmentDate);
          VALIDATE("Invoice No.",VATInvoiceNumber);
          VALIDATE("Ship To City",ShipToCity);
          VALIDATE("Ship To State",COPYSTR(ShipToState,1,MAXSTRLEN("Ship To State")));
          VALIDATE("Ship To Country",COPYSTR(ShipToCountry,1,MAXSTRLEN("Ship To Country")));
          VALIDATE("Ship To Postal Code",COPYSTR(ShipToPostalCode,1,MAXSTRLEN("Ship To Postal Code")));
          VALIDATE("Ship From City",COPYSTR(ShipFromCity,1,MAXSTRLEN("Ship From City")));
          VALIDATE("Ship From State",COPYSTR(ShipFromState,1,MAXSTRLEN("Ship From State")));
          IF ShipFromCountry <> '' THEN BEGIN
            VALIDATE("Ship From Country",COPYSTR(ShipFromCountry,1,MAXSTRLEN("Ship From Country")));
            VALIDATE("Ship From Postal Code",COPYSTR(ShipFromPostalCode,1,MAXSTRLEN("Ship From Postal Code")));
          END;
          VALIDATE("Ship From Tax Location Code",COPYSTR(ShipFromTaxLocationCode,1,MAXSTRLEN("Ship From Tax Location Code")));
          VALIDATE("VAT Registration No. Zyxel");
          VALIDATE("Invoice Download",InvoiceUrl);
          VALIDATE("Currency Code",Currency);
          VALIDATE("Warehouse Code",recEcomWhse.Code);
          VALIDATE("Import Source Type","Import Source Type"::"eCommerce Fulfilled Shipment");
        
          INSERT(TRUE);
        END;*/

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
        recAmzOrder3: Record "eCommerce Order Header";
        recAmzOrderArch: Record "eCommerce Order Archive";
        recAmzOrderArch2: Record "eCommerce Order Archive";
    begin
        if pOrderID = PrevOrderID then
            rValue := true
        else
            case recAmzMktPlace."Import Data from" of
                recAmzMktPlace."import data from"::"Tax Document Library":
                    begin
                        recAmzOrder3.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.", "Completely Imported");
                        recAmzOrder3.SetRange("Transaction Type", recAmzOrder3."transaction type"::Refund);
                        recAmzOrder3.SetRange("Import Source Type", recAmzOrder3."import source type"::"FBA Customer Return");
                        recAmzOrder3.SetRange("eCommerce Order Id", pOrderID);
                        recAmzOrder3.SetRange("Invoice No.", pInvoiceNo);
                        recAmzOrder3.SetRange("Completely Imported", false);
                        if (Type = Type::BeforeInsert) and recAmzOrder3.FindFirst() then
                            rValue := true
                        else begin
                            // If it´s coming from "Tax Library Document" we don´t know which shipment it´s coming from, so we filter only on "OrderID".
                            recAmzOrder.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.", "Completely Imported");
                            recAmzOrder.SetRange("Transaction Type", recAmzOrder."transaction type"::Refund);
                            recAmzOrder.SetRange("Import Source Type", recAmzOrder."import source type"::"FBA Customer Return");
                            recAmzOrder.SetRange("eCommerce Order Id", pOrderID);
                            recAmzOrder.SetRange("Completely Imported", true);
                            recAmzOrder.SetAutoCalcFields("Amount Including VAT");
                            if (Type = Type::AfterInsert) and recAmzOrder.FindFirst() and (recAmzOrder."Amount Including VAT" = pAmountInclVAT) then
                                rValue := true
                            else begin
                                recAmzOrder2.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.", "Completely Imported");
                                recAmzOrder2.SetRange("Transaction Type", recAmzOrder2."transaction type"::Refund);
                                recAmzOrder2.SetRange("Import Source Type", recAmzOrder2."import source type"::"FBA Customer Return");
                                recAmzOrder2.SetRange("eCommerce Order Id", pOrderID);
                                recAmzOrder2.SetRange("Invoice No.", pInvoiceNo);
                                recAmzOrder2.SetRange("Completely Imported", true);
                                if recAmzOrder2.FindFirst() then
                                    rValue := true
                                else begin
                                    recAmzOrderArch.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.");
                                    recAmzOrderArch.SetRange("Transaction Type", recAmzOrderArch."transaction type"::Refund);
                                    recAmzOrderArch.SetRange("Import Source Type", recAmzOrderArch."import source type"::"FBA Customer Return");
                                    recAmzOrderArch.SetRange("eCommerce Order Id", pOrderID);
                                    recAmzOrderArch.SetAutoCalcFields("Amount Including VAT");
                                    if (Type = Type::AfterInsert) and recAmzOrderArch.FindFirst() and (recAmzOrderArch."Amount Including VAT" = pAmountInclVAT) then
                                        rValue := true
                                    else begin
                                        recAmzOrderArch2.SetCurrentkey("Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.");
                                        recAmzOrderArch2.SetRange("Transaction Type", recAmzOrderArch2."transaction type"::Refund);
                                        recAmzOrderArch2.SetRange("Import Source Type", recAmzOrderArch2."import source type"::"FBA Customer Return");
                                        recAmzOrderArch2.SetRange("eCommerce Order Id", pOrderID);
                                        recAmzOrderArch2.SetRange("Invoice No.", pInvoiceNo);
                                        if recAmzOrderArch2.FindFirst() then
                                            rValue := true;
                                    end;
                                end;
                            end;
                        end;
                    end;
                recAmzMktPlace."import data from"::"eCommerce Fulfilled Shipments/Returns":
                    exit((Type = Type::BeforeInsert) and (recAmzOrder.Get(TransactTypeOption, pOrderID, pInvoiceNo)) or
                         (Type = Type::AfterInsert) and (recAmzOrder.Get(TransactTypeOption, pOrderID, pInvoiceNo) and recAmzOrder."Completely Imported") or
                         recAmzOrderArch.Get(TransactTypeOption, pOrderID, pInvoiceNo));
            end;
        PrevOrderID := pOrderID;
    end;

    local procedure GetMarketPlace(pOrderID: Code[50]): Boolean
    begin
        if pOrderID <> '' then begin
            recAmzOrderArch.SetRange("Transaction Type", recAmzOrderArch."transaction type"::Order);
            recAmzOrderArch.SetRange("eCommerce Order Id", pOrderID);
            if recAmzOrderArch.FindFirst() then
                recAmzMktPlace.Get(recAmzOrderArch."Marketplace ID")
            else
                exit(false);
        end else
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
        exit(true);
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
