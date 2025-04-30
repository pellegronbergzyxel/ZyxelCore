report 50029 "Sales - Customs Invoice ZNet"
{
    // 001. 31-10-17 ZY-LD Country of Region is added after the Terrif Code.
    // 001. 10-01-18 ZY-LD Changed from Sell-to TO Ship-to.
    // 002. 11-02-19 ZY-LD 2019020810000044 - Commercial Invoice.
    // 003. 06-06-19 ZY-LD P0213 - New setup for VAT Registration No. Zyxel.
    // 004. 12-08-19 ZY-LD 2019071210000116 - Show Gross Weight.
    // 005. 19-09-19 ZY-LD 2019091810000067 - "VAT reverse charged to customer; art. 44 and art 196 EU VAT Directive" is added to EiCards.
    // 006. 24-10-19 ZY-LD 2019102110000085 - Use local currency if it's blank on the invoice.
    // 007. 28-10-19 ZY-LD 2019102510000158 - Show number of items on the invoice. "Total Quantity" calculated on the sales header.
    // 008. 13-11-19 ZY-LD 2019111210000108 - Hide article 28 on EiCard Invoice.
    // 009. 03-01-20 ZY-LD 2020010310000052 - Dates are formatted as '<Closing><Day>. <Month Text> <Year4>'.
    // 010. 23-02-20 ZY-LD 2020032310000109 - On sales invoice 19-20005274 we have seen that the last line was not printed on the invoice. We now test the values on the header and the lines.
    // 011. 09-07-20 ZY-LD P0455 - Shipment Method caption is changed to Incoterms, and "Ship-to City is added".
    // 012. 11-12-20 ZY-LD 2020121010000091 - Incoterms city can be different.
    // 013. 27-01-21 ZY-LD P0559 - Customs Invoice.
    // 014. 14-04-21 ZY-LD 2021033010000059 - I can´t figure out why I did this change in the first plase, but it didn´t calculate correct, so I have set it back to default. Then we have to see what happens.
    // 015. 27-05-21 ZY-LD 2021052610000161 - Total Gross Weight is added.
    // 016. 03-08-21 ZY-LD 2021070810000076 - VAT is removed from from the layout. Text006 is changed.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Customs Invoice ZNet.rdlc';
    Caption = 'Sales - Customs Invoice';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            CalcFields = "Total Quantity", "Amount Including VAT";
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(No_SalesInvHdr; "Sales Invoice Header"."No.")
            {
            }
            column(InvDiscountAmtCaption; InvDiscountAmtCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(PaymentTermsDescCaption; PaymentTermsDescCaptionLbl)
            {
            }
            column(ShptMethodDescCaption; ShptMethodDescCaptionLbl)
            {
            }
            column(VATPercentageCaption; VATPercentageCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(VATAmtCaption; VATAmtCaptionLbl)
            {
            }
            column(VATIdentifierCaption; VATIdentifierCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionCap)
            {
            }
            column(EMailCaption; EMailCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(HomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(EMail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(DocumentCaptionCopyText; StrSubstNo(DocumentCaption, CopyText, InvoiceType))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo; CompVATRegNo)
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompanyInfoBankAdress; CompanyInfo."Bank Address")
                    {
                    }
                    column(CompanyInfoBankPostCode; CompanyInfo."Bank Post Code")
                    {
                    }
                    column(CompanyInfoBankCity; CompanyInfo."Bank City")
                    {
                    }
                    column(CompanyInfoCountry; recCountry.Name)
                    {
                    }
                    column(CompanyInfoCurrCode; CompanyInfo."Currency Code")
                    {
                    }
                    column(CompanyInfoIBAN; CompanyInfo.Iban)
                    {
                    }
                    column(CompanyInfoSwift; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfoRegistrationNo; CompanyInfo."Registration No.")
                    {
                    }
                    column(CompanyInfoWeeRegistrationNo; CompanyInfo."Wee Registration No.")
                    {
                    }
                    column(BilltoCustNo_SalesInvHdr; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr; Format("Sales Invoice Header"."Posting Date", 0, '<Closing><Day>. <Month Text> <Year4>'))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHdr; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvHdr; Format("Sales Invoice Header"."Due Date", 0, '<Closing><Day>. <Month Text> <Year4>'))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesInvHdr; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(HdrOrderNo_SalesInvHdr; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(DocDate_SalesInvHdr; Format("Sales Invoice Header"."Document Date", 0, '<Closing><Day>. <Month Text> <Year4>'))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; "Sales Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesInvHdr; Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCptn; CompanyInfoVATRegNoCptnLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCptn; CompanyInfoBankNameCptnLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCptn; CompanyInfoBankAccNoCptnLbl)
                    {
                    }
                    column(SalesInvDueDateCaption; SalesInvDueDateCaptionLbl)
                    {
                    }
                    column(InvNoCaption; InvNoCaptionLbl)
                    {
                    }
                    column(SalesInvPostingDateCptn; SalesInvPostingDateCptnLbl)
                    {
                    }
                    column(BilltoCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(LineText1; LineText[1])
                    {
                    }
                    column(LineText2; LineText[2])
                    {
                    }
                    column(LineText3; LineText[3])
                    {
                    }
                    column(LineText4; LineText[4])
                    {
                    }
                    column(LineText5; LineText[5])
                    {
                    }
                    column(LineText6; LineText[6])
                    {
                    }
                    column(LineText7; LineText[7])
                    {
                    }
                    column(LineText8; LineText[8])
                    {
                    }
                    column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
                    {
                    }
                    column(ShippingAgentCode; "Sales Invoice Header"."Shipping Agent Code")
                    {
                    }
                    column(SelltoCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(SellVATID; SellVATID)
                    {
                    }
                    column(ExternalDocumentNo; "Sales Invoice Line"."External Document No.")
                    {
                    }
                    column(TarrifNo; TarrifCode)
                    {
                    }
                    column(EoriNoCaption; EoriNoCaption)
                    {
                    }
                    column(EoriNoCustomer; EoriNoCustomer)
                    {
                    }
                    column(EoriNoCompany; EoriNoCompany)
                    {
                    }
                    column(CustomsBroker; recCustomsBroker.Name)
                    {
                    }
                    column(TotalWeightText; TotalWeightText)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1Number; DimensionLoop1.Number)
                        {
                        }
                        column(HeaderDimCaption; HeaderDimCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if DimensionLoop1.Number = 1 then begin
                                if not DimSetEntry1.FindSet() then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting("Document No.", "Line No.") where("Hide Line" = const(false));
                        column(LineAmt_SalesInvLine; "Sales Invoice Line"."Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine; "Sales Invoice Line".Description)
                        {
                        }
                        column(No_SalesInvLine; "Sales Invoice Line"."No.")
                        {
                        }
                        column(Qty_SalesInvLine; "Sales Invoice Line".Quantity)
                        {
                        }
                        column(UOM_SalesInvLine; "Sales Invoice Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Sales Invoice Line"."Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(Discount_SalesInvLine; "Sales Invoice Line"."Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesInvLine; "Sales Invoice Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesInvLine; Format("Sales Invoice Line".Type))
                        {
                        }
                        column(InvDiscLineAmt_SalesInvLine; -"Sales Invoice Line"."Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmount; TotalInvDiscAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(Amount_SalesInvLine; "Sales Invoice Line".Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_AmtInclVAT; "Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine; "Sales Invoice Line"."Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(LineAmtAfterInvDiscAmt; -("Sales Invoice Line"."Line Amount" - "Sales Invoice Line"."Inv. Discount Amount" - "Sales Invoice Line"."Amount Including VAT"))
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscOnVAT; TotalPaymentDiscOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_SalesInvLine; TotalInclVATText)
                        {
                        }
                        column(VATAmtText_SalesInvLine; VATAmountLine.VATAmountText)
                        {
                        }
                        column(DocNo_SalesInvLine; "Sales Invoice Line"."Document No.")
                        {
                        }
                        column(LineNo_SalesInvLine; "Sales Invoice Line"."Line No.")
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(SalesInvLineDiscCaption; SalesInvLineDiscCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption; PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(LineAmtAfterInvDiscCptn; LineAmtAfterInvDiscCptnLbl)
                        {
                        }
                        column(PostedShipmentDate; Format(PostedShipmentDate))
                        {
                        }
                        column(Desc_SalesInvLineCaption; "Sales Invoice Line".FieldCaption("Sales Invoice Line".Description))
                        {
                        }
                        column(No_SalesInvLineCaption; "Sales Invoice Line".FieldCaption("Sales Invoice Line"."No."))
                        {
                        }
                        column(Qty_SalesInvLineCaption; "Sales Invoice Line".FieldCaption("Sales Invoice Line".Quantity))
                        {
                        }
                        column(UOM_SalesInvLineCaption; "Sales Invoice Line".FieldCaption("Sales Invoice Line"."Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesInvLineCaption; "Sales Invoice Line".FieldCaption("Sales Invoice Line"."VAT Identifier"))
                        {
                        }
                        column(HideLine; "Sales Invoice Line"."Hide Line")
                        {
                        }
                        dataitem("Sales Shipment Buffer"; "Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(SalesShptBufferPostDate; Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShptBufferQty; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShipmentCaption; ShipmentCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if "Sales Shipment Buffer".Number = 1 then
                                    SalesShipmentBuffer.Find('-')
                                else
                                    SalesShipmentBuffer.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");

                                "Sales Shipment Buffer".SetRange("Sales Shipment Buffer".Number, 1, SalesShipmentBuffer.Count());
                            end;
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                            column(DimText_DimLoop; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if DimensionLoop2.Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostAsmLineVartCode; BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {
                            }
                            column(TempPostedAsmLineUOM; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if AsmLoop.Number = 1 then
                                    TempPostedAsmLine.FindSet()
                                else
                                    TempPostedAsmLine.Next;

                                if ItemTranslation.Get(TempPostedAsmLine."No.",
                                     TempPostedAsmLine."Variant Code",
                                     "Sales Invoice Header"."Language Code")
                                then
                                    TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then
                                    CurrReport.Break();
                                CollectAsmInformation;
                                Clear(TempPostedAsmLine);
                                AsmLoop.SetRange(AsmLoop.Number, 1, TempPostedAsmLine.Count());
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            recVATPostSetup: Record "VAT Posting Setup";
                        begin
                            PostedShipmentDate := 0D;
                            if "Sales Invoice Line".Quantity <> 0 then
                                PostedShipmentDate := FindPostedShipmentDate;

                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account") and (not ShowInternalInfo) then
                                "Sales Invoice Line"."No." := '';

                            VATAmountLine.Init();
                            VATAmountLine."VAT Identifier" := "Sales Invoice Line"."VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "Sales Invoice Line"."VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Sales Invoice Line"."Tax Group Code";
                            VATAmountLine."VAT %" := "Sales Invoice Line"."VAT %";
                            VATAmountLine."VAT Base" := "Sales Invoice Line".Amount;
                            VATAmountLine."Amount Including VAT" := "Sales Invoice Line"."Amount Including VAT";
                            VATAmountLine."Line Amount" := "Sales Invoice Line"."Line Amount";
                            if "Sales Invoice Line"."Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" := "Sales Invoice Line"."Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Sales Invoice Line"."Inv. Discount Amount";
                            VATAmountLine."VAT Clause Code" := "Sales Invoice Line"."VAT Clause Code";
                            VATAmountLine.InsertLine;

                            TotalSubTotal += "Sales Invoice Line"."Line Amount";
                            TotalInvDiscAmount -= "Sales Invoice Line"."Inv. Discount Amount";
                            TotalAmount += "Sales Invoice Line".Amount;
                            TotalAmountVAT += "Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount;
                            TotalAmountInclVAT += "Sales Invoice Line"."Amount Including VAT";
                            TotalPaymentDiscOnVAT += -("Sales Invoice Line"."Line Amount" - "Sales Invoice Line"."Inv. Discount Amount" - "Sales Invoice Line"."Amount Including VAT");


                            //>> 14-04-21 ZY-LD - 014
                            /*
                            //>> 28-01-21 ZY-LD 013
                            IF Type <> Type::" " THEN
                              IF sellcust."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" THEN BEGIN
                                recVATPostSetup.GET(sellcust."VAT Bus. Posting Group","VAT Prod. Posting Group");
                                VATAmountLine.INIT;
                                VATAmountLine."VAT Identifier" := "VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Tax Group Code";
                                VATAmountLine."VAT %" := recVATPostSetup."VAT %";
                                VATAmountLine."VAT Base" := Amount;
                                VATAmountLine."Amount Including VAT" := Amount * (1 + (recVATPostSetup."VAT %" / 100));
                                VATAmountLine."VAT Amount" := Amount * (recVATPostSetup."VAT %" / 100);
                                VATAmountLine."Line Amount" := "Line Amount";
                                IF "Allow Invoice Disc." THEN
                                  VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                                VATAmountLine.InsertLine;
                              END ELSE BEGIN
                                VATAmountLine.INIT;
                                VATAmountLine."VAT Identifier" := "VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Tax Group Code";
                                VATAmountLine."VAT %" := "VAT %";
                                VATAmountLine."VAT Base" := Amount;
                                VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                                VATAmountLine."Line Amount" := "Line Amount";
                                IF "Allow Invoice Disc." THEN
                                  VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                                VATAmountLine.InsertLine;
                              END;
                            //<< 28-01-21 ZY-LD 013
                            
                            TotalSubTotal += "Line Amount";
                            TotalInvDiscAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            //>> 28-01-21 ZY-LD 013
                            IF sellcust."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" THEN BEGIN
                              TotalAmountVAT += VATAmountLine."Amount Including VAT" - VATAmountLine."VAT Base";
                              TotalAmountInclVAT += VATAmountLine."Amount Including VAT";
                            END ELSE BEGIN  //<< 28-01-21 ZY-LD 013
                              TotalAmountVAT += "Amount Including VAT" - Amount;
                              TotalAmountInclVAT += "Amount Including VAT";
                            END;
                            
                            TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                            */
                            //<< 14-04-21 ZY-LD - 014 2021033010000059

                            //RD 1.0

                            //>> 27-05-21 ZY-LD 015
                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) and ("Sales Invoice Line"."No." <> '') then begin
                                recItem.Get("Sales Invoice Line"."No.");
                                TarrifCode := '';
                                TarrifCode := StrSubstNo('Tariff:%1', recItem."Tariff No.");

                                if recItem."Country/Region of Origin Code" <> '' then
                                    TarrifCode := TarrifCode + StrSubstNo('; Coo:%1', recItem."Country/Region of Origin Code");

                                if recItem."Gross Weight" <> 0 then begin
                                    TarrifCode := TarrifCode + StrSubstNo('; GW:%1', recItem."Gross Weight");
                                    TotalGrossWeight += "Sales Invoice Line".Quantity * recItem."Gross Weight";
                                end;

                                if recItem."Net Weight" <> 0 then begin
                                    TarrifCode := TarrifCode + StrSubstNo('; NW:%1', recItem."Net Weight");
                                    TotalNetWeight += "Sales Invoice Line".Quantity * recItem."Net Weight";
                                end;

                                TotalNoOfItems += "Sales Invoice Line".Quantity;
                            end;
                            //<< 27-05-21 ZY-LD 015

                            //>> 19-09-19 ZY-LD 005
                            if recVATPostSetup.Get("Sales Invoice Line"."VAT Bus. Posting Group", "Sales Invoice Line"."VAT Prod. Posting Group") and recVATPostSetup."EU Service" then
                                HideServiceText := true;
                            //<< 19-09-19 ZY-LD 005

                        end;

                        trigger OnPostDataItem()
                        begin
                            //>> 28-01-21 ZY-LD 013
                            /*//>> 23-02-20 ZY-LD 010
                            IF TotalAmountInclVAT <> "Sales Invoice Header"."Amount Including VAT" THEN
                              ERROR(Text50004,"Sales Invoice Header"."Amount Including VAT",TotalAmountInclVAT);
                            //<< 23-02-20 ZY-LD 010*/
                            //<< 28-01-21 ZY-LD 013

                            TotalWeightText := StrSubstNo(Text50005, TotalNoOfItems, TotalGrossWeight, TotalNetWeight);  // 27-05-21 ZY-LD 015
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll();
                            SalesShipmentBuffer.Reset();
                            SalesShipmentBuffer.DeleteAll();
                            FirstValueEntryNo := 0;
                            MoreLines := "Sales Invoice Line".Find('+');
                            while MoreLines and ("Sales Invoice Line".Description = '') and ("Sales Invoice Line"."No." = '') and ("Sales Invoice Line".Quantity = 0) and ("Sales Invoice Line".Amount = 0) do
                                MoreLines := "Sales Invoice Line".Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            "Sales Invoice Line".SetRange("Sales Invoice Line"."Line No.", 0, "Sales Invoice Line"."Line No.");
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPer; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecificationCptn; VATAmtSpecificationCptnLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounter.Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATCounter.SetRange(VATCounter.Number, 1, VATAmountLine.Count());
                        end;
                    }
                    dataitem(VATClauseEntryCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(VATClauseVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATClauseCode; VATAmountLine."VAT Clause Code")
                        {
                        }
                        column(VATClauseDescription; VATClause.Description)
                        {
                        }
                        column(VATClauseDescription2; VATClause."Description 2")
                        {
                        }
                        column(VATClauseAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption; VATClausesCap)
                        {
                        }
                        column(VATClauseVATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption; VATAmtCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATClauseEntryCounter.Number);
                            if not VATClause.Get(VATAmountLine."VAT Clause Code") then
                                CurrReport.Skip();
                            VATClause.TranslateDescription("Sales Invoice Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            VATClauseEntryCounter.SetRange(VATClauseEntryCounter.Number, 1, VATAmountLine.Count());
                        end;
                    }
                    dataitem(VatCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATPer_VATCounterLCY; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATCounterLCY; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VatCounterLCY.Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code",
                                "Sales Invoice Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code",
                                "Sales Invoice Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Invoice Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            VatCounterLCY.SetRange(VatCounterLCY.Number, 1, VATAmountLine.Count());

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", 1);
                            CalculatedExchRate := Round(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(SelltoCustNo_SalesInvHdr; "Sales Invoice Header"."Sell-to Customer No.")
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                                CurrReport.Break();
                        end;
                    }
                    dataitem(LineFee; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1 ..));
                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayAdditionalFeeNote then
                                CurrReport.Break();

                            if LineFee.Number = 1 then begin
                                if not TempLineFeeNoteOnReportHist.FindSet() then
                                    CurrReport.Break
                            end else
                                if TempLineFeeNoteOnReportHist.Next() = 0 then
                                    CurrReport.Break();
                        end;
                    }
                    dataitem(Service; "Integer")
                    {
                        DataItemTableView = where(Number = const(1));
                        column(IsAService; HideServiceText)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            HideServiceText := not HideServiceText;  // 19-09-19 ZY-LD 005
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := Text003;  // 11-02-19 ZY-LD 002 - Set back to standard
                        OutputNo += 1;
                    end;

                    TotalSubTotal := 0;
                    TotalInvDiscAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview() then
                        if not CustomsInvoice then  // 28-01-21 ZY-LD 013
                            SalesInvCountPrinted.Run("Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';  // 11-02-19 ZY-LD 002 - Set back to standard
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                LineText[1] := '';
                LineText[2] := '';
                LineText[3] := '';
                LineText[4] := '';
                LineText[5] := '';
                LineText[6] := '';
                LineText[7] := '';
                LineText[8] := '';
                //>> 27-05-21 ZY-LD 015
                TotalNoOfItems := 0;
                TotalGrossWeight := 0;
                TotalNetWeight := 0;
                //<< 27-05-21 ZY-LD 015

                CurrReport.Language := LanguageCU.GetLanguageIdOrDefault("Sales Invoice Header"."Language Code");

                if RespCenter.Get("Sales Invoice Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Sales Invoice Header"."Dimension Set ID");

                if "Sales Invoice Header"."Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Order No.");
                if "Sales Invoice Header"."Salesperson Code" = '' then begin
                    SalesPurchPerson.Init();
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Sales Invoice Header"."Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Sales Invoice Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Your Reference");
                if "Sales Invoice Header"."VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := "Sales Invoice Header".FieldCaption("Sales Invoice Header"."VAT Registration No.");
                if "Sales Invoice Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Sales Invoice Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Sales Invoice Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Sales Invoice Header"."Currency Code");
                end;
                FormatAddr.SalesInvBillTo(CustAddr, "Sales Invoice Header");
                if not Cust.Get("Sales Invoice Header"."Bill-to Customer No.") then
                    Clear(Cust);

                if "Sales Invoice Header"."Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Sales Invoice Header"."Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Invoice Header"."Language Code");
                end;
                if "Sales Invoice Header"."Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Sales Invoice Header"."Shipment Method Code");
                    //>> 11-12-20 ZY-LD 012
                    case ShipmentMethod."Read Incoterms City From" of
                        ShipmentMethod."read incoterms city from"::"Ship-to City":
                            begin
                                ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Invoice Header"."Language Code");
                                ShipmentMethod.Description := StrSubstNo('%1 %2', "Sales Invoice Header"."Shipment Method Code", "Sales Invoice Header"."Ship-to City");  // 09-07-20 ZY-LD 011
                            end;
                        ShipmentMethod."read incoterms city from"::"Location City":
                            begin
                                recLocation.Get("Sales Invoice Header"."Location Code");
                                ShipmentMethod.Description := StrSubstNo('%1 %2', "Sales Invoice Header"."Shipment Method Code", recLocation.City);
                            end;
                    end;
                    //<< 11-12-20 ZY-LD 012
                end;
                FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, "Sales Invoice Header");
                ShowShippingAddr := "Sales Invoice Header"."Sell-to Customer No." <> "Sales Invoice Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                GetLineFeeNoteOnReportHist("Sales Invoice Header"."No.");

                if LogInteraction then
                    if not CurrReport.Preview() then begin
                        if "Sales Invoice Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              4, "Sales Invoice Header"."No.", 0, 0, Database::Contact, "Sales Invoice Header"."Bill-to Contact No.", "Sales Invoice Header"."Salesperson Code",
                              "Sales Invoice Header"."Campaign No.", "Sales Invoice Header"."Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              4, "Sales Invoice Header"."No.", 0, 0, Database::Customer, "Sales Invoice Header"."Bill-to Customer No.", "Sales Invoice Header"."Salesperson Code",
                              "Sales Invoice Header"."Campaign No.", "Sales Invoice Header"."Posting Description", '');
                    end;

                if "Sales Invoice Header"."Sell-to Customer No." = "Sales Invoice Header"."Bill-to Customer No." then
                    sellcust := Cust
                else
                    sellcust.Get("Sales Invoice Header"."Sell-to Customer No.");

                //>> 06-06-19 ZY-LD 003
                if "Sales Invoice Header"."Company VAT Registration Code" <> '' then
                    CompVATRegNo := "Sales Invoice Header"."Company VAT Registration Code"
                else begin  //<< 06-06-19 ZY-LD 003
                    if "Sales Invoice Header"."VAT Registration Code" <> '' then begin
                        VATRegistrationRec.Get("Sales Invoice Header"."VAT Registration Code");
                        CompVATRegNo := VATRegistrationRec."VAT registration No";
                    end else begin
                        CompVATRegNo := CompanyInfo."VAT Registration No.";
                    end;
                end;

                //>> 28-01-21 ZY-LD 013
                EoriNoCaption := '';
                EoriNoCustomer := '';
                EoriNoCompany := '';
                if CustomsInvoice then
                    if recCountry.Get("Sales Invoice Header"."Ship-to Country/Region Code") and (recCountry."Customs Customer No." <> '') then begin
                        Clear(recCustomsBroker);
                        if sellcust."Customs Broker" <> '' then
                            recCustomsBroker.Get(sellcust."Customs Broker");

                        Clear(CustAddr);
                        CompVATRegNo := CompanyInfo."VAT Registration No.";
                        sellcust.Get(recCountry."Customs Customer No.");
                        FormatAddr.Customer(CustAddr, sellcust);

                        EoriNoCaption := EoriNoCaptionLbl;
                        EoriNoCustomer := sellcust."EORI No.";
                        EoriNoCompany := CompanyInfo."EORI No.";

                        if recCountry."Shipment Method for Customs" <> '' then begin
                            ShipmentMethod.Get(recCountry."Shipment Method for Customs");
                            case ShipmentMethod."Read Incoterms City From" of
                                ShipmentMethod."read incoterms city from"::"Ship-to City":
                                    begin
                                        ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Invoice Header"."Language Code");
                                        ShipmentMethod.Description := StrSubstNo('%1 %2', "Sales Invoice Header"."Shipment Method Code", "Sales Invoice Header"."Ship-to City");
                                    end;
                                ShipmentMethod."read incoterms city from"::"Location City":
                                    begin
                                        recLocation.Get("Sales Invoice Header"."Location Code");
                                        ShipmentMethod.Description := StrSubstNo('%1 %2', "Sales Invoice Header"."Shipment Method Code", recLocation.City);
                                    end;
                            end;
                        end;
                    end;
                //<< 28-01-21 ZY-LD 013

                //RD001
                SellVATID := sellcust."VAT Registration No.";
                LineText[1] := '';
                LineText[2] := '';
                LineText[3] := '';
                LineText[4] := '';
                LineText[5] := '';
                LineText[6] := '';
                LineText[7] := '';
                LineText[8] := '';

                //>> 28-10-19 ZY-LD 007
                if "Sales Invoice Header"."Ship-to Country/Region Code" = 'TR' then begin
                    LineText[1] := StrSubstNo(Text011, "Sales Invoice Header"."Total Quantity");
                    i := 2;
                end else
                    i := 1;
                //<< 28-10-19 ZY-LD 007

                if SalesSetup."Use Sell-to text code filter" then begin
                    InvoiceText.SetRange(InvoiceText."Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                end else begin
                    InvoiceText.SetRange(InvoiceText."Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
                end;
                InvoiceText.SetRange(InvoiceText.Location, "Sales Invoice Header"."Location Code");
                InvoiceText.SetFilter("Sales Order Type", '%1', "Sales Invoice Header"."Sales Order Type");
                InvoiceText.SetFilter("Text ID", '>%1', '');

                if InvoiceText.FindFirst() then begin
                    InvoiceLineText.SetFilter(InvoiceLineText."Invoice Description Code", InvoiceText."Text ID");
                    if InvoiceLineText.FindSet() then begin
                        //i := 1;  // 28-10-19 ZY-LD 007
                        repeat
                            i := i + 1;  // 28-10-19 ZY-LD 007
                            LineText[i] := InvoiceLineText."Line text";
                        //i := i+1;  // 28-10-19 ZY-LD 007
                        until InvoiceLineText.Next() = 0;
                    end;
                end;

                //>> 31-10-17 ZY-LD 001
                Clear(ShipToCountryRegion);
                if "Sales Invoice Header"."Ship-to Country/Region Code" <> '' then
                    ShipToCountryRegion.Get("Sales Invoice Header"."Ship-to Country/Region Code");
                //<< 31-10-17 ZY-LD 001

                /*
                if "Sales Invoice Header"."Currency Code" <> '' then
                    recBankAcc.SetRange("Currency Code", "Sales Invoice Header"."Currency Code")
                else
                    recBankAcc.SetRange("Currency Code", GLSetup."LCY Code");  // 24-10-19 ZY-LD 006
                */
                if ("Currency Code" = GLSetup."LCY Code") or ("Currency Code" = '') then
                    recBankAcc.SetFilter("Currency Code", '%1', '')
                else
                    recBankAcc.SetRange("Currency Code", "Currency Code");

                recBankAcc.SetRange(Blocked, false);
                recBankAcc.FindFirst();
                if recBankAcc.Count() <> 1 then
                    Error(Text50003, recBankAcc.TableCaption(), "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Currency Code"), "Sales Invoice Header"."Currency Code");
                recBankAcc.TestField(Iban);
                CompanyInfo.Iban := recBankAcc.Iban;
                CompanyInfo."Currency Code" := "Sales Invoice Header"."Currency Code";

                recCountry.Get(CompanyInfo."Bank Country/Region Code");

                HideServiceText := false;  // 19-09-19 ZY-LD 005
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Assembly Components';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        ShipmentDate = 'Shipment Date';
        ShippingAgent = 'Shipping Agent';
        ExternalDocument = 'Customer PO. No.:'; //28-04-25 BK #486528
        Tariff = 'Tariff No.:';
        PaymentFoot = 'Please provide payment according to the specific terms';
        PaymentFoot1 = 'Please transfer all payments to:';
        SwiftTxt = 'SWIFT Code:';
        IBANTxT = 'IBAN No.';
        CurrentyText = 'Currency:';
        Text001 = 'Registration No.';
        Text002 = 'Account No.:';
        Text003 = 'IBAN No.:';
        Text004 = 'WEE Registration No.:';
        Text005 = 'Reverse charge, article 28c A in Directive 2006/112/EF artikel 138.';
        Text006 = 'EU VAT reverse Charge art.44 and art. 196 EU VAT Directive';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
        case SalesSetup."Logo Position on Documents" of
            SalesSetup."logo position on documents"::Left:
                begin
                    CompanyInfo3.Get();
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage() then
            InitLogInteraction;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label '%2 - Invoice %1';
        Text005: Label 'Invoice';
        PageCaptionCap: Label 'Page %1 of %2';
        Text006: Label 'Total %1';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        LanguageCU: Codeunit Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        VATClause: Record "VAT Clause";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        VALExchRate: Text[50];
        Text009: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: Label '%2 - Prepayment Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        Text011: Label 'Total quantity of items: %1.';
        Text012: Label 'Commercial';
        Text013: Label 'Sales';
        Text014: Label 'Customs';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: Label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        SalesInvDueDateCaptionLbl: Label 'Due Date';
        InvNoCaptionLbl: Label 'Invoice No.';
        SalesInvPostingDateCptnLbl: Label 'Posting Date';
        HeaderDimCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        SalesInvLineDiscCaptionLbl: Label 'Discount %';
        AmountCaptionLbl: Label 'Amount';
        VATClausesCap: Label 'VAT Clause';
        PostedShipmentDateCaptionLbl: Label 'Posted Shipment Date';
        SubtotalCaptionLbl: Label 'Subtotal';
        LineAmtAfterInvDiscCptnLbl: Label 'Payment Discount on VAT';
        ShipmentCaptionLbl: Label 'Shipment';
        LineDimCaptionLbl: Label 'Line Dimensions';
        VATAmtSpecificationCptnLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        InvDiscountAmtCaptionLbl: Label 'Invoice Discount Amount';
        DocumentDateCaptionLbl: Label 'Document Date';
        PaymentTermsDescCaptionLbl: Label 'Payment Terms';
        ShptMethodDescCaptionLbl: Label 'Incoterms';
        VATPercentageCaptionLbl: Label 'VAT %';
        TotalCaptionLbl: Label 'Total';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        HomePageCaptionCap: Label 'Home Page';
        EMailCaptionLbl: Label 'E-Mail';
        DisplayAdditionalFeeNote: Boolean;
        sellcust: Record Customer;
        SellVATID: Text[20];
        recItem: Record Item;
        TarrifCode: Text;
        InvoiceText: Record "Customer Invoice Texts";
        InvoiceLineText: Record "Invoice Line Text";
        LineText: array[8] of Text[80];
        VATRegistrationRec: Record "IC Vendors";
        CompVATRegNo: Text[50];
        ShipToCountryRegion: Record "Country/Region";
        ItemCountryRegion: Record "Country/Region";
        InvoiceType: Text[10];
        EoriNoCaptionLbl: Label 'EORI No.';
        Text50001: Label 'Sales Invoice';
        Text50002: Label 'Commercial invoice';
        recBankAcc: Record "Bank Account";
        Text50003: Label 'There are more than one "%1" with "%2" %3.';
        ZGT: Codeunit "ZyXEL General Tools";
        recCountry: Record "Country/Region";
        recVatPostSetup: Record "VAT Posting Setup";
        recLocation: Record Location;
        HideServiceText: Boolean;
        Text50004: Label 'Amount incl. VAT on the header and lines does not match.\Header: %1.\Lines: %2.';
        EoriNoCaption: Text[10];
        EoriNoCompany: Code[15];
        EoriNoCustomer: Code[15];
        CustomsInvoice: Boolean;
        recCustomsBroker: Record "Customs Broker";
        TotalGrossWeight: Decimal;
        TotalNetWeight: Decimal;
        TotalNoOfItems: Decimal;
        TotalWeightText: Text;
        Text50005: Label 'Number of Items: %1; Total Gross Weight: %2 kg; Total Net Weight: %3 kg.';

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

    procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then
            if SalesShipmentHeader.Get("Sales Invoice Line"."Shipment No.") then
                exit(SalesShipmentHeader."Posting Date");

        if "Sales Invoice Header"."Order No." = '' then
            exit("Sales Invoice Header"."Posting Date");

        case "Sales Invoice Line".Type of
            "Sales Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Invoice Line");
            "Sales Invoice Line".Type::"G/L Account", "Sales Invoice Line".Type::Resource,
          "Sales Invoice Line".Type::"Charge (Item)", "Sales Invoice Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Invoice Line");
            "Sales Invoice Line".Type::" ":
                exit(0D);
        end;

        SalesShipmentBuffer.Reset();
        SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next() = 0 then begin
                SalesShipmentBuffer.Get(
                  SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete();
                exit(SalesShipmentBuffer2."Posting Date");
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll();
                exit("Sales Invoice Header"."Posting Date");
            end;
        end else
            exit("Sales Invoice Header"."Posting Date");
    end;

    procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentkey("Order No.");
        SalesInvoiceHeader.SetFilter("No.", '..%1', "Sales Invoice Header"."No.");
        SalesInvoiceHeader.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.Find('-') then
            repeat
                SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SetRange("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SetRange("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.Next() = 0;
            until SalesInvoiceHeader.Next() = 0;

        SalesShipmentLine.SetCurrentkey("Order No.", "Order Line No.");
        SalesShipmentLine.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);

        if SalesShipmentLine.Find('-') then
            repeat
                if "Sales Invoice Header"."Get Shipment Used" then
                    CorrectShipment(SalesShipmentLine);
                if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then
                        SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then
                        AddBufferEntry(
                          SalesInvoiceLine,
                          Quantity,
                          SalesShipmentHeader."Posting Date");
                end;
            until (SalesShipmentLine.Next() = 0) or (TotalQuantity = 0);
    end;

    procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentkey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next() = 0;
    end;

    procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.Modify();
            exit;
        end;

        begin
            SalesShipmentBuffer."Document No." := SalesInvoiceLine."Document No.";
            SalesShipmentBuffer."Line No." := SalesInvoiceLine."Line No.";
            SalesShipmentBuffer."Entry No." := NextEntryNo;
            SalesShipmentBuffer.Type := SalesInvoiceLine.Type;
            SalesShipmentBuffer."No." := SalesInvoiceLine."No.";
            SalesShipmentBuffer.Quantity := QtyOnShipment;
            SalesShipmentBuffer."Posting Date" := PostingDate;
            SalesShipmentBuffer.Insert();
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    var
        BillToCountryRegion: Record "Country/Region";
    begin
        //>> 27-01-21 ZY-LD 013
        if CustomsInvoice then
            InvoiceType := Text014
        else  //<< 27-01-21 ZY-LD 013
            InvoiceType := Text013;

        if "Sales Invoice Header"."Prepayment Invoice" then
            exit(Text010);
        exit(Text004);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    procedure CollectAsmInformation()
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DeleteAll();
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then
            exit;
        begin
            ValueEntry.SetCurrentkey(ValueEntry."Document No.");
            ValueEntry.SetRange(ValueEntry."Document No.", "Sales Invoice Line"."Document No.");
            ValueEntry.SetRange(ValueEntry."Document Type", ValueEntry."document type"::"Sales Invoice");
            ValueEntry.SetRange(ValueEntry."Document Line No.", "Sales Invoice Line"."Line No.");
            ValueEntry.SetRange(ValueEntry.Adjustment, false);
            if not ValueEntry.FindSet() then
                exit;
        end;
        repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."document type"::"Sales Shipment" then begin
                    SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet() then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next() = 0;
                    end;
                end;
        until ValueEntry.Next() = 0;
    end;

    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst() then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify();
        end else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert();
        end;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst() then
            exit;

        if not Customer.Get(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet() then begin
            repeat
                TempLineFeeNoteOnReportHist.Init();
                TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert();
            until LineFeeNoteOnReportHist.Next() = 0;
        end else begin
            LineFeeNoteOnReportHist.SetRange("Language Code", LanguageCU.GetLanguageCode(GlobalLanguage));
            if LineFeeNoteOnReportHist.FindSet() then
                repeat
                    TempLineFeeNoteOnReportHist.Init();
                    TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert();
                until LineFeeNoteOnReportHist.Next() = 0;
        end;
    end;

    procedure SetCustomsInvoice(NewCustomsInvoice: Boolean)
    begin
        CustomsInvoice := NewCustomsInvoice;  // 28-01-21 ZY-LD 013
    end;
}
