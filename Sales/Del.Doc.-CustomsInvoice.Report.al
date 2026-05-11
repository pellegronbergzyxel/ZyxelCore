report 50185 "Del. Doc. - Customs Invoice"
{

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Del. Doc. - Customs Invoice.rdlc';
    Caption = 'Delivery Document - Customs Invoice';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;
    usagecategory = Documents;
    applicationarea = All;

    dataset
    {
        dataitem("VCK Delivery Document Header"; "VCK Delivery Document Header")
        {
            CalcFields = "Total Quantity";
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(No_SalesInvHdr; "VCK Delivery Document Header"."No.")
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
            column(TotalExclVATText; TotalExclVATText)
            {
            }
            column(TotalInclVATText; TotalInclVATText)
            {
            }
            column(TotalAmountInclVAT; TotalAmountInclVAT)
            {
                AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalAmountVAT; TotalAmountVAT)
            {
                AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                AutoFormatType = 1;
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
                    column(DocumentCaptionCopyText; StrSubstNo(CopyText, InvoiceType)) //11-05-2026 BK #570417
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
                    column(CompanyInfoVATRegNo; "VCK Delivery Document Header"."Ship-From TaxID") //11-05-2026 BK #570417
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
                    column(BilltoCustNo_SalesInvHdr; "VCK Delivery Document Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr; Format(Today, 0, '<Closing><Day>. <Month Text> <Year4>'))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHdr; "VCK Delivery Document Header"."Salesperson Code")
                    {
                    }
                    column(DueDate_SalesInvHdr; Format("VCK Delivery Document Header".PickDate, 0, '<Closing><Day>. <Month Text> <Year4>'))
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
                    column(YourReference_SalesInvHdr; "VCK Delivery Document Header"."Salesperson Code")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(HdrOrderNo_SalesInvHdr; "VCK Delivery Document Header"."Salesperson Code")
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
                    column(DocDate_SalesInvHdr; Format("VCK Delivery Document Header"."Document Date", 0, '<Closing><Day>. <Month Text> <Year4>'))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; "VCK Delivery Document Header".SentToAllIn)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesInvHdr; Format("VCK Delivery Document Header".SentToAllIn))
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
                    column(BilltoCustNo_SalesInvHdrCaption; "VCK Delivery Document Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; "VCK Delivery Document Header".FieldCaption(SentToAllIn))
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
                    column(ShipToCountry; "VCK Delivery Document Header"."Ship-to Country/Region Code")
                    {
                    }
                    column(PaymentTermsCode; sellcust."Payment Terms Code")
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
                    column(ShippingAgentCode; "VCK Delivery Document Header"."Shipment Agent Code")
                    {
                    }
                    column(SelltoCustNo_SalesInvHdrCaption; "VCK Delivery Document Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(SellVATID; SellVATID)
                    {
                    }
                    column(ExternalDocumentNo; "VCK Delivery Document Header"."Shipper Reference")
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
                    column(VatRegNoBillTo; VatRegNoBillTo)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "VCK Delivery Document Header";
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
                    dataitem("VCK Delivery Document Line"; "VCK Delivery Document Line")
                    {
                        CalcFields = "Gross Weight", "Net Weight", "External Document No.";
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "VCK Delivery Document Header";
                        DataItemTableView = sorting("Document No.", "Line No.", "Sales Order No.", "Sales Order Line No.") where("Freight Cost Item" = const(false));
                        column(LineAmt_SalesInvLine; "VCK Delivery Document Line"."Line Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine; "VCK Delivery Document Line".Description)
                        {
                        }
                        column(No_SalesInvLine; "VCK Delivery Document Line"."Item No.")
                        {
                        }
                        column(Qty_SalesInvLine; "VCK Delivery Document Line".Quantity)
                        {
                        }
                        column(UOM_SalesInvLine; "VCK Delivery Document Line"."Unit of Measure Code")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "VCK Delivery Document Line"."Unit Price")
                        {
                            AutoFormatType = 2;
                        }
                        column(Discount_SalesInvLine; "VCK Delivery Document Line"."Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesInvLine; '')
                        {
                        }
                        column(Type_SalesInvLine; '')
                        {
                        }
                        column(InvDiscLineAmt_SalesInvLine; 0)
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmount; TotalInvDiscAmount)
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(Amount_SalesInvLine; "VCK Delivery Document Line".Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_AmtInclVAT; "VCK Delivery Document Line"."Amount Including VAT" - "VCK Delivery Document Line".Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine; "VCK Delivery Document Line"."Amount Including VAT")
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText())
                        {
                        }
                        column(LineAmtAfterInvDiscAmt; 0)
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr; 0)
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
                        column(VATAmtText_SalesInvLine; VATAmountLine.VATAmountText())
                        {
                        }
                        column(DocNo_SalesInvLine; "VCK Delivery Document Line"."Document No.")
                        {
                        }
                        column(LineNo_SalesInvLine; "VCK Delivery Document Line"."Line No.")
                        {
                        }
                        column(GrossWeight_Line; "VCK Delivery Document Line"."Gross Weight")
                        {
                        }
                        column(NetWeight_Line; "VCK Delivery Document Line"."Net Weight")
                        {
                        }
                        column(LineHeaderDescription; LineHeaderDescription)
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
                        column(Desc_SalesInvLineCaption; "VCK Delivery Document Line".FieldCaption("VCK Delivery Document Line".Description))
                        {
                        }
                        column(No_SalesInvLineCaption; "VCK Delivery Document Line".FieldCaption("VCK Delivery Document Line"."Item No."))
                        {
                        }
                        column(Qty_SalesInvLineCaption; "VCK Delivery Document Line".FieldCaption("VCK Delivery Document Line".Quantity))
                        {
                        }
                        column(UOM_SalesInvLineCaption; "VCK Delivery Document Line".FieldCaption("VCK Delivery Document Line"."Unit of Measure Code"))
                        {
                        }
                        column(VATIdentifier_SalesInvLineCaption; '')
                        {
                        }
                        column(HideLine; "VCK Delivery Document Line"."Hide Line")
                        {
                        }
                        column(ExternalDocumentNo_Line; "VCK Delivery Document Line"."External Document No.")
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
                                SalesShipmentBuffer.SetRange("Document No.", "VCK Delivery Document Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "VCK Delivery Document Line"."Line No.");

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
                            end;
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(TempPostedAsmLineNo; BlanksForIndent() + TempPostedAsmLine."No.")
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent() + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostAsmLineVartCode; BlanksForIndent() + TempPostedAsmLine."Variant Code")
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
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then
                                    CurrReport.Break();
                                //CollectAsmInformation();
                                Clear(TempPostedAsmLine);
                                AsmLoop.SetRange(AsmLoop.Number, 1, TempPostedAsmLine.Count());
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            recVATPostSetup: Record "VAT Posting Setup";
                        begin
                            "VCK Delivery Document Line".TestField("VCK Delivery Document Line"."Unit Price");

                            PostedShipmentDate := 0D;
                            if "VCK Delivery Document Line".Quantity <> 0 then
                                PostedShipmentDate := FindPostedShipmentDate();

                            VATAmountLine.Init();
                            VATAmountLine."VAT %" := "VCK Delivery Document Line"."VAT %";
                            VATAmountLine."VAT Base" := "VCK Delivery Document Line".Amount;
                            VATAmountLine."Amount Including VAT" := "VCK Delivery Document Line"."Amount Including VAT";
                            VATAmountLine."Line Amount" := "VCK Delivery Document Line"."Line Amount";
                            VATAmountLine.InsertLine;

                            TotalSubTotal += "VCK Delivery Document Line"."Line Amount";
                            TotalAmount += "VCK Delivery Document Line".Amount;
                            TotalAmountVAT += "VCK Delivery Document Line"."Amount Including VAT" - "VCK Delivery Document Line".Amount;
                            TotalAmountInclVAT += "VCK Delivery Document Line"."Amount Including VAT";
                            TotalSubTotal += "VCK Delivery Document Line"."Line Amount";
                            TotalAmount += "VCK Delivery Document Line".Amount;
                            TotalAmountVAT += "VCK Delivery Document Line"."Amount Including VAT" - "VCK Delivery Document Line".Amount;
                            TotalAmountInclVAT += "VCK Delivery Document Line"."Amount Including VAT";

                            if ("VCK Delivery Document Line"."Item No." <> '') then begin
                                recItem.Get("VCK Delivery Document Line"."Item No.");
                                TarrifCode := '';
                                TarrifCode := StrSubstNo('Tariff: %1', recItem."Tariff No.");

                                if recItem."Country/Region of Origin Code" <> '' then
                                    TarrifCode := TarrifCode + StrSubstNo('; Country of Origin: %1', recItem."Country/Region of Origin Code");

                                TotalGrossWeight += "VCK Delivery Document Line".Quantity * recItem."Gross Weight";
                                TotalNetWeight += "VCK Delivery Document Line".Quantity * recItem."Net Weight";
                                TotalNoOfItems += "VCK Delivery Document Line".Quantity;
                            end;

                            if not FirstLine then
                                LineHeaderDescription := '';
                            FirstLine := false;

                        end;

                        trigger OnPostDataItem()
                        begin
                            LineText[1] := StrSubstNo(Text50006, TotalNoOfItems);
                            if ShipToCountryRegion."Show Net Wgt. Total on Ctm.Inv" then
                                LineText[2] := StrSubstNo(Text50008, TotalNetWeight);
                            if ShipToCountryRegion."Show Grs Wgt. Total on Ctm.Inv" then  // Changed because of Turkey
                                LineText[3] := StrSubstNo(Text50007, TotalGrossWeight);
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll();
                            SalesShipmentBuffer.Reset();
                            SalesShipmentBuffer.DeleteAll();
                            FirstValueEntryNo := 0;
                            MoreLines := "VCK Delivery Document Line".Find('+');
                            while MoreLines and ("VCK Delivery Document Line".Description = '') and ("VCK Delivery Document Line"."Item No." = '') and ("VCK Delivery Document Line".Quantity = 0) and ("VCK Delivery Document Line".Amount = 0) do
                                MoreLines := "VCK Delivery Document Line".Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            "VCK Delivery Document Line".SetRange("VCK Delivery Document Line"."Line No.", 0, "VCK Delivery Document Line"."Line No.");
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
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
                        column(VATClauseAmount; VATClause.Description)
                        {
                            AutoFormatExpression = "VCK Delivery Document Header"."Currency Code";
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

                        trigger OnPreDataItem()
                        begin

                            if (not GLSetup."Print VAT specification in LCY") or
                               ("VCK Delivery Document Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            VatCounterLCY.SetRange(VatCounterLCY.Number, 1, VATAmountLine.Count());

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(SelltoCustNo_SalesInvHdr; "VCK Delivery Document Header"."Sell-to Customer No.")
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
                            HideServiceText := not HideServiceText;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;

                    TotalSubTotal := 0;
                    TotalInvDiscAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscOnVAT := 0;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddrExt: Codeunit "Format Address Extension";
            begin
                LineText[1] := '';
                LineText[2] := '';
                LineText[3] := '';
                LineText[4] := '';
                LineText[5] := '';
                LineText[6] := '';
                LineText[7] := '';
                LineText[8] := '';
                TotalNoOfItems := 0;
                TotalGrossWeight := 0;
                TotalNetWeight := 0;

                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if "VCK Delivery Document Header"."Salesperson Code" = '' then begin
                    SalesPurchPerson.Init();
                    SalesPersonText := '';
                end else
                    IF SalesPurchPerson.Get("VCK Delivery Document Header"."Salesperson Code") then
                        SalesPersonText := Text000;

                if "VCK Delivery Document Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "VCK Delivery Document Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "VCK Delivery Document Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "VCK Delivery Document Header"."Currency Code");
                end;

                FormatAddrExt.DeliveryInvBillTo(CustAddr, "VCK Delivery Document Header");

                if not Cust.Get("VCK Delivery Document Header"."Bill-to Customer No.") then
                    Clear(Cust);

                if "VCK Delivery Document Header"."Delivery Terms Terms" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("VCK Delivery Document Header"."Delivery Terms Terms");
                    //>> 11-12-20 ZY-LD 012
                    case ShipmentMethod."Read Incoterms City From" of
                        ShipmentMethod."read incoterms city from"::"Ship-to City":
                            begin
                                ShipmentMethod.TranslateDescription(ShipmentMethod, '');
                                ShipmentMethod.Description := StrSubstNo('%1 %2', "VCK Delivery Document Header"."Delivery Terms Terms", "VCK Delivery Document Header"."Ship-to City");  // 09-07-20 ZY-LD 011
                            end;
                        ShipmentMethod."read incoterms city from"::"Location City":
                            begin
                                recLocation.Get("VCK Delivery Document Header"."Ship-From Code");
                                ShipmentMethod.Description := StrSubstNo('%1 %2', "VCK Delivery Document Header"."Delivery Terms Terms", recLocation.City);
                            end;
                    end;
                    //<< 11-12-20 ZY-LD 012
                end;

                FormatAddrExt.DeliveryInvShipTo(ShipToAddr, "VCK Delivery Document Header");
                ShowShippingAddr := "VCK Delivery Document Header"."Sell-to Customer No." <> "VCK Delivery Document Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                GetLineFeeNoteOnReportHist("VCK Delivery Document Header"."No.");

                if "VCK Delivery Document Header"."Sell-to Customer No." = "VCK Delivery Document Header"."Bill-to Customer No." then
                    sellcust := Cust
                else
                    if "VCK Delivery Document Header"."Document Type" = "VCK Delivery Document Header"."document type"::Sales then
                        sellcust.Get("VCK Delivery Document Header"."Sell-to Customer No.");

                if "VCK Delivery Document Header"."VAT Registration No. Zyxel" = '' then
                    "VCK Delivery Document Header"."VAT Registration No. Zyxel" := recVATRegNoMatrix."GetZyxelVATReg/EoriNo"(0, "VCK Delivery Document Header"."Ship-From Code", "VCK Delivery Document Header"."Ship-to Country/Region Code", "VCK Delivery Document Header"."Sell-to Country/Region Code", "VCK Delivery Document Header"."Sell-to Customer No.");
                "VCK Delivery Document Header".TestField("VCK Delivery Document Header"."VAT Registration No. Zyxel");
                //EoriNoCompany := recVATRegNoMatrix."GetZyxelVATReg/EoriNo"(1, "VCK Delivery Document Header"."Ship-From Code", "VCK Delivery Document Header"."Ship-to Country/Region Code", "VCK Delivery Document Header"."Sell-to Country/Region Code", "VCK Delivery Document Header"."Sell-to Customer No.");
                EoriNoCompany := companyInfo."EORI No."; // 1105-2026 BK #570417
                VatRegNoBillTo := "VCK Delivery Document Header"."Bill-to TaxID";

                EoriNoCaption := '';
                EoriNoCustomer := '';
                if recCountry.Get("VCK Delivery Document Header"."Ship-to Country/Region Code") and (recCountry."Customs Customer No." <> '') then begin
                    Clear(recCustomsBroker);
                    if (sellcust."Customs Broker" <> '') and (recCustomsBroker.Get(sellcust."Customs Broker")) then begin
                        EoriNoCustomer := sellcust."EORI No.";
                        VatRegNoBillTo := sellcust."VAT Registration No.";
                    end else
                        if CountryRegionCustomsBroker.Get(recCountry."Customs Customer No.") then begin
                            EoriNoCustomer := CountryRegionCustomsBroker."Eori no.";
                            VatRegNoBillTo := CountryRegionCustomsBroker."Vat registration no.";
                        end;

                    Clear(CustAddr);
                    FormatAddrExt.DeliveryInvCustomsTo(CustAddr, recCountry."Customs Customer No.");
                    EoriNoCaption := EoriNoCaptionLbl;

                    if recCountry."Shipment Method for Customs" <> '' then begin
                        ShipmentMethod.Get(recCountry."Shipment Method for Customs");
                        case ShipmentMethod."Read Incoterms City From" of
                            ShipmentMethod."read incoterms city from"::"Ship-to City":
                                begin
                                    ShipmentMethod.TranslateDescription(ShipmentMethod, '');
                                    ShipmentMethod.Description := StrSubstNo('%1 %2', recCountry."Shipment Method for Customs", "VCK Delivery Document Header"."Ship-to City");
                                end;
                            ShipmentMethod."read incoterms city from"::"Location City":
                                begin
                                    recLocation.Get("VCK Delivery Document Header"."Ship-to Code");
                                    ShipmentMethod.Description := StrSubstNo('%1 %2', recCountry."Shipment Method for Customs", recLocation.City);
                                end;
                        end;
                    end;
                end;

                if EoriNoCompany <> '' then
                    EoriNoCaption := EoriNoCaptionLbl;

                if "VCK Delivery Document Header"."Ship-to TaxID" <> '' then
                    SellVATID := "VCK Delivery Document Header"."Ship-to TaxID"
                else
                    SellVATID := sellcust."VAT Registration No.";

                LineText[1] := 'xxx';
                LineText[2] := '';
                LineText[3] := '';
                LineText[4] := '';
                LineText[5] := '';
                LineText[6] := '';
                LineText[7] := '';
                LineText[8] := '';

                if "VCK Delivery Document Header"."Ship-to Country/Region Code" = 'TR' then begin
                    LineText[1] := StrSubstNo(Text011, "VCK Delivery Document Header"."Total Quantity");
                    i := 2;
                end else
                    i := 1;

                if SalesSetup."Use Sell-to text code filter" then
                    InvoiceText.SetRange(InvoiceText."Customer No.", "VCK Delivery Document Header"."Sell-to Customer No.")
                else
                    InvoiceText.SetRange(InvoiceText."Customer No.", "VCK Delivery Document Header"."Bill-to Customer No.");


                Clear(ShipToCountryRegion);
                if "VCK Delivery Document Header"."Ship-to Country/Region Code" <> '' then
                    ShipToCountryRegion.Get("VCK Delivery Document Header"."Ship-to Country/Region Code");

                if ShipToCountryRegion."Line Head Desc. on Custom Inv." <> '' then begin
                    LineHeaderDescription := ShipToCountryRegion."Line Head Desc. on Custom Inv.";
                    FirstLine := true;
                end;

                if ("Currency Code" = GLSetup."LCY Code") or ("Currency Code" = '') then
                    recBankAcc.SetFilter("Currency Code", '%1', '')
                else
                    recBankAcc.SetRange("Currency Code", "Currency Code");

                recBankAcc.SetRange(Blocked, false);
                recBankAcc.FindFirst();
                if recBankAcc.Count() <> 1 then
                    Error(Text50003, recBankAcc.TableCaption(), "VCK Delivery Document Header".FieldCaption("VCK Delivery Document Header"."Currency Code"), "VCK Delivery Document Header"."Currency Code");
                recBankAcc.TestField(Iban);
                CompanyInfo.Iban := recBankAcc.Iban;
                CompanyInfo."Currency Code" := "VCK Delivery Document Header"."Currency Code";

                recCountry.Get(CompanyInfo."Bank Country/Region Code");

                HideServiceText := false;



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
                        ToolTip = 'Enter the number of copies to print. The total number of copies will be the sum of this field and the number of copies specified in the customer card.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        toolTip = 'Select to show internal information on the invoice, such as item numbers and dimensions. This information is only visible on the printed invoice and will not be sent to the customer.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        toolTip = 'Select to log the printing of the invoice as an interaction on the customer record. This allows you to keep track of when invoices were printed for each customer.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Assembly Components';
                        toolTip = 'Select to show assembly component details on the invoice. This includes information about the individual components that make up an assembly item. This information is only visible on the printed invoice and will not be sent to the customer.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note';
                        toolTip = 'Select to show additional fee notes on the invoice. This includes any extra charges that may apply to the order, such as handling fees or special delivery charges. This information is only visible on the printed invoice and will not be sent to the customer.';
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
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        ShipmentDate = 'Shipment Date';
        ShippingAgent = 'Shipping Agent';
        ExternalDocument = 'External Document No.:';
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
            InitLogInteraction();
    end;

    var
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
        CountryRegionCustomsBroker: Record Customer;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        VATClause: Record "VAT Clause";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        recVATRegNoMatrix: Record "VAT Reg. No. pr. Location";
        sellcust: Record Customer;
        recItem: Record Item;
        InvoiceText: Record "Customer Invoice Texts";
        ShipToCountryRegion: Record "Country/Region";
        recBankAcc: Record "Bank Account";
        recCountry: Record "Country/Region";
        recLocation: Record Location;
        recCustomsBroker: Record "Customs Broker";
        LanguageCU: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
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
        VALExchRate: Text[50];
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label '%2 - Invoice %1';
        Text005: Label 'Delivery Document';
        PageCaptionCap: Label 'Page %1 of %2';
        Text006: Label 'Total %1 Excl. VAT';

        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        DisplayAdditionalFeeNote: Boolean;
        SellVATID: Text[20];
        TarrifCode: Text;
        LineText: array[8] of Text[80];
        InvoiceType: Text[10];
        HideServiceText: Boolean;
        EoriNoCaption: Text[10];
        EoriNoCompany: Code[15];
        EoriNoCustomer: Code[15];
        TotalGrossWeight: Decimal;
        TotalNetWeight: Decimal;
        TotalNoOfItems: Decimal;
        LineHeaderDescription: Text;
        VatRegNoBillTo: Code[20];
        FirstLine: Boolean;
        Text011: Label 'Total quantity of items: %1.';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: Label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        SalesInvDueDateCaptionLbl: Label 'Due Date';
        InvNoCaptionLbl: Label 'Invoice No.';
        SalesInvPostingDateCptnLbl: Label 'Invoice Date';
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
        EoriNoCaptionLbl: Label 'EORI No.';
        Text50003: Label 'There are more than one "%1" with "%2" %3.';
        Text50006: Label 'Total number of Items: %1';
        Text50007: Label 'Total Gross Weight: %1 kg';
        Text50008: Label 'Total Net Weight: %1 kg.';

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

        exit(0D);

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
}
