Report 50018 "Sales - Credit Memo DE"
{
    // 001. 06-06-19 ZY-LD P0213 - New setup for VAT Registration No. Zyxel.
    // 002. 09-08-21 ZY-LD 2021070210000087 - Position on External document No.
    // 003. 31-05-22 ZY-LD 2022053010000106 - "External Document No." and "Tarriff No." is only shown on items.
    // 004. 10-06-22 ZY-LD 2022061010000099 - "EU 3-Party Trade".
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Credit Memo DE.rdlc';

    Caption = 'Sales - Credit Memo';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            column(No_SalesInvHdr; "Sales Cr.Memo Header"."No.")
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
            column(NormalizedPostingDate; NormalizedPostingDate)
            {
            }
            column(NormalizedDueDate; NormalizedDueDate)
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
                    column(DocumentCaptionCopyText; CopyText)
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
                    column(CompanyInfoCurrCode; CompanyInfo."Currency Code")
                    {
                    }
                    column(CompanyInfoCurrCode2; CompanyInfo."Currency Code 2")
                    {
                    }
                    column(CompanyInfoCurrCode3; CompanyInfo."Currency Code 3")
                    {
                    }
                    column(CompanyInfoCurrCode4; CompanyInfo."Currency Code 4")
                    {
                    }
                    column(CompanyInfoIBAN; CompanyInfo.Iban)
                    {
                    }
                    column(CompanyInfoIBAN2; CompanyInfo."IBAN 2")
                    {
                    }
                    column(CompanyInfoIBAN3; CompanyInfo."IBAN 3")
                    {
                    }
                    column(CompanyInfoIBAN4; CompanyInfo."IBAN 4")
                    {
                    }
                    column(CompanyInfoSwift; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(BilltoCustNo_SalesInvHdr; "Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr; Format("Sales Cr.Memo Header"."Posting Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHdr; "Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvHdr; Format("Sales Cr.Memo Header"."Due Date", 0, 4))
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
                    column(YourReference_SalesInvHdr; "Sales Cr.Memo Header"."Your Reference")
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
                    column(DocDate_SalesInvHdr; Format("Sales Cr.Memo Header"."Document Date", 0, 4))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; "Sales Cr.Memo Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesInvHdr; Format("Sales Cr.Memo Header"."Prices Including VAT"))
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
                    column(CompanyInfoBankBranchNo; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(CompanyInfoGeneralManagerTitle; CompanyInfo."General Manager Title")
                    {
                    }
                    column(CompanyInfoGeneralManagerName; CompanyInfo."General Manager Name")
                    {
                    }
                    column(CompanyInfoGeneralManagerAddress; CompanyInfo."General Manager Address")
                    {
                    }
                    column(CompanyInfoGeneralManagerCity; CompanyInfo."General Manager City")
                    {
                    }
                    column(CompanyInfoSteuername; CompanyInfo.Steuername)
                    {
                    }
                    column(CompanyInfoSteuernummer; CompanyInfo.Steuernumber)
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
                    column(BilltoCustNo_SalesInvHdrCaption; "Sales Cr.Memo Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; "Sales Cr.Memo Header".FieldCaption("Prices Including VAT"))
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
                    column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
                    {
                    }
                    column(SelltoCustNo_SalesInvHdrCaption; "Sales Cr.Memo Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(SellVATID; SellVATID)
                    {
                    }
                    column(ExternalDocumentNo; "Sales Cr.Memo Header"."External Document No.")
                    {
                    }
                    column(TarrifNo; recItem."Tariff No.")
                    {
                    }
                    column(ArticleText; ArticleText)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Cr.Memo Header";
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
                                if not DimSetEntry1.FindSet then
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
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting("Document No.", "Line No.") where("Hide Line" = const(false));
                        column(LineAmt_SalesInvLine; "Sales Cr.Memo Line"."Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine; "Sales Cr.Memo Line".Description)
                        {
                        }
                        column(No_SalesInvLine; "Sales Cr.Memo Line"."No.")
                        {
                        }
                        column(Qty_SalesInvLine; "Sales Cr.Memo Line".Quantity)
                        {
                        }
                        column(UOM_SalesInvLine; "Sales Cr.Memo Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Sales Cr.Memo Line"."Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(Discount_SalesInvLine; "Sales Cr.Memo Line"."Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesInvLine; "Sales Cr.Memo Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesInvLine; Format("Sales Cr.Memo Line".Type))
                        {
                        }
                        column(InvDiscLineAmt_SalesInvLine; -"Sales Cr.Memo Line"."Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmount; TotalInvDiscAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(Amount_SalesInvLine; "Sales Cr.Memo Line".Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_AmtInclVAT; "Sales Cr.Memo Line"."Amount Including VAT" - "Sales Cr.Memo Line".Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine; "Sales Cr.Memo Line"."Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(LineAmtAfterInvDiscAmt; -("Sales Cr.Memo Line"."Line Amount" - "Sales Cr.Memo Line"."Inv. Discount Amount" - "Sales Cr.Memo Line"."Amount Including VAT"))
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Cr.Memo Header"."VAT Base Discount %")
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
                        column(DocNo_SalesInvLine; "Sales Cr.Memo Line"."Document No.")
                        {
                        }
                        column(LineNo_SalesInvLine; "Sales Cr.Memo Line"."Line No.")
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
                        column(Desc_SalesInvLineCaption; "Sales Cr.Memo Line".FieldCaption("Sales Cr.Memo Line".Description))
                        {
                        }
                        column(No_SalesInvLineCaption; "Sales Cr.Memo Line".FieldCaption("Sales Cr.Memo Line"."No."))
                        {
                        }
                        column(Qty_SalesInvLineCaption; "Sales Cr.Memo Line".FieldCaption("Sales Cr.Memo Line".Quantity))
                        {
                        }
                        column(UOM_SalesInvLineCaption; "Sales Cr.Memo Line".FieldCaption("Sales Cr.Memo Line"."Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesInvLineCaption; "Sales Cr.Memo Line".FieldCaption("Sales Cr.Memo Line"."VAT Identifier"))
                        {
                        }
                        column(HideLine; "Sales Cr.Memo Line"."Hide Line")
                        {
                        }
                        column(SalesCrMemoLineExternalDocumentNo; "Sales Cr.Memo Line"."External Document No.")
                        {
                        }
                        column(ExternalDocumentNoLine; ExternalDocumentNoLine)
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
                                "Sales Shipment Buffer".SetRange("Sales Shipment Buffer".Number, 1, SalesShipmentBuffer.Count);
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
                                    if not DimSetEntry2.FindSet then
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

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Cr.Memo Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PostedShipmentDate := 0D;
                            if "Sales Cr.Memo Line".Quantity <> 0 then
                                PostedShipmentDate := FindPostedShipmentDate;

                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::"G/L Account") and (not ShowInternalInfo) then
                                "Sales Cr.Memo Line"."No." := '';

                            VATAmountLine.Init;
                            VATAmountLine."VAT Identifier" := "Sales Cr.Memo Line"."VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "Sales Cr.Memo Line"."VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Sales Cr.Memo Line"."Tax Group Code";
                            VATAmountLine."VAT %" := "Sales Cr.Memo Line"."VAT %";
                            VATAmountLine."VAT Base" := "Sales Cr.Memo Line".Amount;
                            VATAmountLine."Amount Including VAT" := "Sales Cr.Memo Line"."Amount Including VAT";
                            VATAmountLine."Line Amount" := "Sales Cr.Memo Line"."Line Amount";
                            if "Sales Cr.Memo Line"."Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" := "Sales Cr.Memo Line"."Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Sales Cr.Memo Line"."Inv. Discount Amount";
                            VATAmountLine."VAT Clause Code" := "Sales Cr.Memo Line"."VAT Clause Code";
                            VATAmountLine.InsertLine;

                            TotalSubTotal += "Sales Cr.Memo Line"."Line Amount";
                            TotalInvDiscAmount -= "Sales Cr.Memo Line"."Inv. Discount Amount";
                            TotalAmount += "Sales Cr.Memo Line".Amount;
                            TotalAmountVAT += "Sales Cr.Memo Line"."Amount Including VAT" - "Sales Cr.Memo Line".Amount;
                            TotalAmountInclVAT += "Sales Cr.Memo Line"."Amount Including VAT";
                            TotalPaymentDiscOnVAT += -("Sales Cr.Memo Line"."Line Amount" - "Sales Cr.Memo Line"."Inv. Discount Amount" - "Sales Cr.Memo Line"."Amount Including VAT");

                            //RD 1.0


                            TarrifCode := '';
                            recItem.SetFilter("No.", "Sales Cr.Memo Line"."No.");
                            if recItem.FindFirst then begin
                                TarrifCode := recItem."Tariff No.";
                            end;

                            if "Sales Cr.Memo Line".Type in ["Sales Cr.Memo Line".Type::"G/L Account", "Sales Cr.Memo Line".Type::Item] then
                                ReportEvent.GetEUArticle(
                                  '',
                                  "Sales Cr.Memo Header"."Sell-to Country/Region Code",
                                  "Sales Cr.Memo Line"."VAT Bus. Posting Group",
                                  "Sales Cr.Memo Line"."VAT Prod. Posting Group",
                                  "Sales Cr.Memo Line"."Sell-to Customer No.",
                                  "Sales Cr.Memo Header"."EU 3-Party Trade",  // 10-06-22 ZY-LD 004
                                  ArticleText);

                            //>> 09-08-21 ZY-LD 002
                            ExternalDocumentNoLine := '';
                            if "Sales Cr.Memo Line"."External Document No." <> '' then
                                ExternalDocumentNoLine := "Sales Cr.Memo Line"."External Document No."
                            else
                                ExternalDocumentNoLine := "Sales Cr.Memo Header"."External Document No.";
                            if "Sales Cr.Memo Line"."External Document Position No." <> '' then
                                ExternalDocumentNoLine += StrSubstNo(', Pos: %1', "Sales Cr.Memo Line"."External Document Position No.");
                            //<< 09-08-21 ZY-LD 002
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            SalesShipmentBuffer.Reset;
                            SalesShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := "Sales Cr.Memo Line".Find('+');
                            while MoreLines and ("Sales Cr.Memo Line".Description = '') and ("Sales Cr.Memo Line"."No." = '') and ("Sales Cr.Memo Line".Quantity = 0) and ("Sales Cr.Memo Line".Amount = 0) do
                                MoreLines := "Sales Cr.Memo Line".Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            "Sales Cr.Memo Line".SetRange("Sales Cr.Memo Line"."Line No.", 0, "Sales Cr.Memo Line"."Line No.");
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
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
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounter.Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATCounter.SetRange(VATCounter.Number, 1, VATAmountLine.Count);
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
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
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
                                CurrReport.Skip;
                            VATClause.TranslateDescription("Sales Cr.Memo Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            VATClauseEntryCounter.SetRange(VATClauseEntryCounter.Number, 1, VATAmountLine.Count);
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
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Cr.Memo Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            VatCounterLCY.SetRange(VatCounterLCY.Number, 1, VATAmountLine.Count);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(SelltoCustNo_SalesInvHdr; "Sales Cr.Memo Header"."Sell-to Customer No.")
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
                                if not TempLineFeeNoteOnReportHist.FindSet then
                                    CurrReport.Break
                            end else
                                if TempLineFeeNoteOnReportHist.Next() = 0 then
                                    CurrReport.Break();
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := Text005 + Text003;
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
                    if not CurrReport.Preview then
                        SalesCrMemoCountPrinted.Run("Sales Cr.Memo Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := Text005;
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := LanguageCU.GetLanguageIdOrDefault("Sales Cr.Memo Header"."Language Code");

                CompanyInfo.Get;

                if RespCenter.Get("Sales Cr.Memo Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Sales Cr.Memo Header"."Dimension Set ID");

                //PAB
                if StrPos("Sales Cr.Memo Header"."Sell-to Customer Name", 'ALSO') > 0 then begin
                    NormalizedPostingDate := NormalizeDate("Sales Cr.Memo Header"."Posting Date");
                    NormalizedDueDate := NormalizeDate("Sales Cr.Memo Header"."Due Date");
                end;
                if StrPos("Sales Cr.Memo Header"."Sell-to Customer Name", 'ALSO') = 0 then begin
                    NormalizedPostingDate := Format("Sales Cr.Memo Header"."Posting Date");
                    NormalizedDueDate := Format("Sales Cr.Memo Header"."Due Date");
                end;

                //PAB


                if "Sales Cr.Memo Header"."Return Order No." = '' then
                    ReturnOrderNoText := ''
                else
                    ReturnOrderNoText := "Sales Cr.Memo Header".FieldCaption("Sales Cr.Memo Header"."Return Order No.");
                if "Sales Cr.Memo Header"."Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Sales Cr.Memo Header"."Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Sales Cr.Memo Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Sales Cr.Memo Header".FieldCaption("Sales Cr.Memo Header"."Your Reference");
                if "Sales Cr.Memo Header"."VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := "Sales Cr.Memo Header".FieldCaption("Sales Cr.Memo Header"."VAT Registration No.");
                if "Sales Cr.Memo Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Sales Cr.Memo Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Sales Cr.Memo Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Sales Cr.Memo Header"."Currency Code");
                end;
                FormatAddr.SalesCrMemoBillTo(CustAddr, "Sales Cr.Memo Header");
                if "Sales Cr.Memo Header"."Applies-to Doc. No." = '' then
                    AppliedToText := ''
                else
                    AppliedToText := StrSubstNo(Text003, "Sales Cr.Memo Header"."Applies-to Doc. Type", "Sales Cr.Memo Header"."Applies-to Doc. No.");

                FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, "Sales Cr.Memo Header");
                ShowShippingAddr := "Sales Cr.Memo Header"."Sell-to Customer No." <> "Sales Cr.Memo Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                if LogInteraction then
                    if not CurrReport.Preview then
                        if "Sales Cr.Memo Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              6, "Sales Cr.Memo Header"."No.", 0, 0, Database::Contact, "Sales Cr.Memo Header"."Bill-to Contact No.", "Sales Cr.Memo Header"."Salesperson Code",
                              "Sales Cr.Memo Header"."Campaign No.", "Sales Cr.Memo Header"."Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              6, "Sales Cr.Memo Header"."No.", 0, 0, Database::Customer, "Sales Cr.Memo Header"."Sell-to Customer No.", "Sales Cr.Memo Header"."Salesperson Code",
                              "Sales Cr.Memo Header"."Campaign No.", "Sales Cr.Memo Header"."Posting Description", '');


                if "Sales Cr.Memo Header"."Sell-to Customer No." = "Sales Cr.Memo Header"."Bill-to Customer No." then
                    sellcust := Cust
                else
                    sellcust.Get("Sales Cr.Memo Header"."Sell-to Customer No.");

                //RD001
                SellVATID := sellcust."VAT Registration No.";

                //>> 06-06-19 ZY-LD 001
                if "Sales Cr.Memo Header"."Company VAT Registration Code" <> '' then
                    CompVATRegNo := "Sales Cr.Memo Header"."Company VAT Registration Code"
                else
                    CompVATRegNo := CompanyInfo."VAT Registration No.";
                //<< 06-06-19 ZY-LD 001

                ArticleText := '';
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
        ExternalDocument = 'Ext. Doc. No.:';
        Tariff = 'Tariff No.:';
        PaymentFoot = 'Der Gutschriftsbetrag wird Ihrem Konto gutgeschrieben.';
        PaymentFoot1 = 'Origin of products: TAIWAN';
        SwiftTxt = 'SWIFT Code:';
        IBANTxT = 'IBAN No.';
        OurReference = 'Our Reference';
        Text004 = 'Rechnungsnr.';
        Text005 = 'Belegdatum';
        Text006 = 'Kundenummer';
        Text007 = 'VAT Reg. No.';
        Text008 = 'Zahlungsbedingung';
        Text009 = 'Fälligkeitsdatum';
        Text010 = 'Lieferbedingung';
        Text011 = 'Lieferdatum';
        Text012 = 'Liefer-Agent';
        Text013 = 'Nr.';
        Text014 = 'Beschreibung';
        Text015 = 'Menge';
        Text016 = 'Einheit';
        Text017 = 'VK-Preis';
        Text018 = 'Rabatt %';
        Text019 = 'Betrag';
        Text020 = 'VAT Betrag';
        Text021 = 'RHQ Nr.:';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;
        CompanyInfo.VerifyAndSetPaymentInfo;
        case SalesSetup."Logo Position on Documents" of
            SalesSetup."logo position on documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
    end;

    var
        Text000: label 'Salesperson';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. VAT';
        Text003: label 'Kopie';
        Text004: label 'Sales - Invoice %1';
        Text005: label 'Gutschrift';
        PageCaptionCap: label 'Page %1 of %2';
        Text006: label 'Total %1 Excl. VAT';
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
        SalesCrMemoCountPrinted: Codeunit "Sales Cr. Memo-Printed";
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
        Text007: label 'VAT Amount Specification in ';
        Text008: label 'Local Currency';
        VALExchRate: Text[50];
        Text009: label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: label 'Sales - Prepayment Invoice %1';
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
        Text011: label 'Sales - Prepmt. Credit Memo %1';
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCptnLbl: label 'Bank';
        CompanyInfoBankAccNoCptnLbl: label 'Account No.';
        SalesInvDueDateCaptionLbl: label 'Due Date';
        InvNoCaptionLbl: label 'Invoice No.';
        SalesInvPostingDateCptnLbl: label 'Posting Date';
        HeaderDimCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        SalesInvLineDiscCaptionLbl: label 'Discount %';
        AmountCaptionLbl: label 'Amount';
        VATClausesCap: label 'VAT Clause';
        PostedShipmentDateCaptionLbl: label 'Posted Shipment Date';
        SubtotalCaptionLbl: label 'Subtotal';
        LineAmtAfterInvDiscCptnLbl: label 'Payment Discount on VAT';
        ShipmentCaptionLbl: label 'Shipment';
        LineDimCaptionLbl: label 'Line Dimensions';
        VATAmtSpecificationCptnLbl: label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: label 'Line Amount';
        ShiptoAddrCaptionLbl: label 'Ship-to Address';
        InvDiscountAmtCaptionLbl: label 'Invoice Discount Amount';
        DocumentDateCaptionLbl: label 'Document Date';
        PaymentTermsDescCaptionLbl: label 'Payment Terms';
        ShptMethodDescCaptionLbl: label 'Shipment Method';
        VATPercentageCaptionLbl: label 'VAT %';
        TotalCaptionLbl: label 'Total';
        VATBaseCaptionLbl: label 'VAT Base';
        VATAmtCaptionLbl: label 'VAT Amount';
        VATIdentifierCaptionLbl: label 'VAT Identifier';
        HomePageCaptionCap: label 'Home Page';
        EMailCaptionLbl: label 'E-Mail';
        DisplayAdditionalFeeNote: Boolean;
        sellcust: Record Customer;
        SellVATID: Text[20];
        recItem: Record Item;
        TarrifCode: Text[30];
        ReturnOrderNoText: Text[80];
        AppliedToText: Text;
        NormalizedPostingDate: Text[8];
        NormalizedDueDate: Text[8];
        CompVATRegNo: Code[20];
        ArticleText: Text;
        ReportEvent: Codeunit "Report Event";
        ExternalDocumentNoLine: Text;


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '';
    end;

    local procedure FindPostedShipmentDate(): Date
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Cr.Memo Line"."Return Receipt No." <> '' then
            if ReturnReceiptHeader.Get("Sales Cr.Memo Line"."Return Receipt No.") then
                exit(ReturnReceiptHeader."Posting Date");
        if "Sales Cr.Memo Header"."Return Order No." = '' then
            exit("Sales Cr.Memo Header"."Posting Date");

        case "Sales Cr.Memo Line".Type of
            "Sales Cr.Memo Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::"G/L Account", "Sales Cr.Memo Line".Type::Resource,
          "Sales Cr.Memo Line".Type::"Charge (Item)", "Sales Cr.Memo Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::" ":
                exit(0D);
        end;

        SalesShipmentBuffer.Reset;
        SalesShipmentBuffer.SetRange("Document No.", "Sales Cr.Memo Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Cr.Memo Line"."Line No.");

        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next() = 0 then begin
                SalesShipmentBuffer.Get(
                  SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete;
                exit(SalesShipmentBuffer2."Posting Date");
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Cr.Memo Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll;
                exit("Sales Cr.Memo Header"."Posting Date");
            end;
        end else
            exit("Sales Cr.Memo Header"."Posting Date");
    end;

    local procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record "Sales Cr.Memo Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", SalesCrMemoLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Cr.Memo Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesCrMemoLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    local procedure GenerateBufferFromShipment(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine2: Record "Sales Cr.Memo Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesCrMemoHeader.SetCurrentkey("Return Order No.");
        SalesCrMemoHeader.SetFilter("No.", '..%1', "Sales Cr.Memo Header"."No.");
        SalesCrMemoHeader.SetRange("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        if SalesCrMemoHeader.Find('-') then
            repeat
                SalesCrMemoLine2.SetRange("Document No.", SalesCrMemoHeader."No.");
                SalesCrMemoLine2.SetRange("Line No.", SalesCrMemoLine."Line No.");
                SalesCrMemoLine2.SetRange(Type, SalesCrMemoLine.Type);
                SalesCrMemoLine2.SetRange("No.", SalesCrMemoLine."No.");
                SalesCrMemoLine2.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
                if SalesCrMemoLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
                    until SalesCrMemoLine2.Next() = 0;
            until SalesCrMemoHeader.Next() = 0;

        ReturnReceiptLine.SetCurrentkey("Return Order No.", "Return Order Line No.");
        ReturnReceiptLine.SetRange("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        ReturnReceiptLine.SetRange("Return Order Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange("Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange(Type, SalesCrMemoLine.Type);
        ReturnReceiptLine.SetRange("No.", SalesCrMemoLine."No.");
        ReturnReceiptLine.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
        ReturnReceiptLine.SetFilter(Quantity, '<>%1', 0);

        if ReturnReceiptLine.Find('-') then
            repeat
                if "Sales Cr.Memo Header"."Get Return Receipt Used" then
                    CorrectShipment(ReturnReceiptLine);
                if Abs(ReturnReceiptLine.Quantity) <= Abs(TotalQuantity - SalesCrMemoLine.Quantity) then
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
                else begin
                    if Abs(ReturnReceiptLine.Quantity) > Abs(TotalQuantity) then
                        ReturnReceiptLine.Quantity := TotalQuantity;
                    Quantity :=
                      ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);

                    SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;

                    if ReturnReceiptHeader.Get(ReturnReceiptLine."Document No.") then
                        AddBufferEntry(
                          SalesCrMemoLine,
                          -Quantity,
                          ReturnReceiptHeader."Posting Date");
                end;
            until (ReturnReceiptLine.Next() = 0) or (TotalQuantity = 0);
    end;

    local procedure CorrectShipment(var ReturnReceiptLine: Record "Return Receipt Line")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.SetCurrentkey("Return Receipt No.", "Return Receipt Line No.");
        SalesCrMemoLine.SetRange("Return Receipt No.", ReturnReceiptLine."Document No.");
        SalesCrMemoLine.SetRange("Return Receipt Line No.", ReturnReceiptLine."Line No.");
        if SalesCrMemoLine.Find('-') then
            repeat
                ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
            until SalesCrMemoLine.Next() = 0;
    end;

    local procedure AddBufferEntry(SalesCrMemoLine: Record "Sales Cr.Memo Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesCrMemoLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesCrMemoLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity - QtyOnShipment;
            SalesShipmentBuffer.Modify;
            exit;
        end;

        begin
            SalesShipmentBuffer.Init;
            SalesShipmentBuffer."Document No." := SalesCrMemoLine."Document No.";
            SalesShipmentBuffer."Line No." := SalesCrMemoLine."Line No.";
            SalesShipmentBuffer."Entry No." := NextEntryNo;
            SalesShipmentBuffer.Type := SalesCrMemoLine.Type;
            SalesShipmentBuffer."No." := SalesCrMemoLine."No.";
            SalesShipmentBuffer.Quantity := -QtyOnShipment;
            SalesShipmentBuffer."Posting Date" := PostingDate;
            SalesShipmentBuffer.Insert;
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        if "Sales Cr.Memo Header"."Prepayment Credit Memo" then
            exit(Text011);
        exit(Text005);
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;


    procedure NormalizeDate(OrigionalDate: Date) NewDate: Text[10]
    var
        DayStr: Text[2];
        MonthStr: Text[2];
        YearStr: Text[4];
    begin
        DayStr := Format(Date2dmy(OrigionalDate, 1));
        MonthStr := Format(Date2dmy(OrigionalDate, 2));
        YearStr := Format(Date2dmy(OrigionalDate, 3));
        if StrLen(DayStr) = 1 then DayStr := '0' + DayStr;
        if StrLen(MonthStr) = 1 then MonthStr := '0' + MonthStr;
        if StrLen(YearStr) = 4 then YearStr := CopyStr(YearStr, 3, 2);
        NewDate := DayStr + '/' + MonthStr + '/' + YearStr;
    end;
}
