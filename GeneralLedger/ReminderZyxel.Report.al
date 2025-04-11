report 50057 "Reminder Zyxel"
{
    // 16-58056  20/10/16  TB
    //   PES-JLP-16-58056 refers
    //   Created, based on R117.
    // 
    // 001. 08-08-18 ZY-LD 000 - Finance Phone No. added, and reminder lever is printet.
    // 002. 25-10-18 ZY-LD 2018102410000152 - Renamed.
    // 003. 27-08-19 ZY-LD 2019082710000104 - Print correct IBAN No. Fax No. and bank account no is removed.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reminder Zyxel.rdlc';

    Caption = 'Reminder';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder';
            column(No_IssuedReminderHeader; "Issued Reminder Header"."No.")
            {
            }
            column(DueDateCaptiion; DueDateCaptiionLbl)
            {
            }
            column(VATAmountCaption; VATAmountCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(VATPercentCaption; VATPercentCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(DocDateCaption; DocDateCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EMailCaption; EMailCaptionLbl)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(CompanyInfo1Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyInfo2Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyInfo3Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyTxt1; CompanyTxt1)
                {
                }
                column(CompanyTxt2; CompanyTxt2)
                {
                }
                column(CompanyTxt3; CompanyTxt3)
                {
                }
                column(CompanyTxt4; CompanyTxt4)
                {
                }
                column(CompanyTxt5; CompanyTxt5)
                {
                }
                column(CompanyTxt6; CompanyTxt6)
                {
                }
                column(CompanyTxt7; CompanyTxt7)
                {
                }
                column(CompanyInfoBankBranchNo; StrSubstNo(DT005, CompanyInfo."Bank Branch No."))
                {
                }
                column(CompanyInfoSwiftCode; StrSubstNo('SWIFT Code: %1', CompanyInfo."SWIFT Code"))
                {
                }
                column(CompanyInfoIban; StrSubstNo('IBAN: %1', CompanyInfo.Iban))
                {
                }
                column(CompanyInfoGenManTitle; CompanyInfo."General Manager Title")
                {
                }
                column(CompanyInfoGenManName; CompanyInfo."General Manager Name")
                {
                }
                column(CompanyInfoGenManAddr; CompanyInfo."General Manager Address")
                {
                }
                column(CompanyInfoGenManCity; CompanyInfo."General Manager City")
                {
                }
                column(CompanyInfoSteuername; CompanyInfo.Steuername)
                {
                }
                column(CompanyInfoSteuernumber; CompanyInfo.Steuernumber)
                {
                }
                column(DueDate_IssuedReminderHdr; Format("Issued Reminder Header"."Due Date"))
                {
                }
                column(PostDate_IssuedReminderHdr; Format("Issued Reminder Header"."Posting Date"))
                {
                }
                column(No1_IssuedReminderHdr; "Issued Reminder Header"."No.")
                {
                }
                column(YourRef_IssueReminderHdr; "Issued Reminder Header"."Your Reference")
                {
                }
                column(ReferenceText; ReferenceText)
                {
                }
                column(VatRegNo_IssueReminderHdr; "Issued Reminder Header"."VAT Registration No.")
                {
                }
                column(VATNoText; VATNoText)
                {
                }
                column(DocDate_IssueReminderHdr; Format("Issued Reminder Header"."Document Date"))
                {
                }
                column(CustNo_IssueReminderHdr; "Issued Reminder Header"."Customer No.")
                {
                }
                column(CompanyInfoBankAccNo; StrSubstNo('Konto %1', CompanyInfo."Bank Account No."))
                {
                }
                column(CompanyInfoBankName; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoEMail; CompanyInfo."E-Mail")
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                // column(CurrReportPageNo;StrSubstNo(Text002,CurrReport.PageNo))
                // {
                // }
                column(TextPage; TextPageLbl)
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(ReminderNoCaption; ReminderNoCaptionLbl)
                {
                }
                column(BankAccNoCaption; BankAccNoCaptionLbl)
                {
                }
                column(BankNameCaption; BankNameCaptionLbl)
                {
                }
                column(GiroNoCaption; GiroNoCaptionLbl)
                {
                }
                column(VATRegNoCaption; VATRegNoCaptionLbl)
                {
                }
                column(PhoneNoCaption; PhoneNoCaptionLbl)
                {
                }
                column(ReminderCaption; ReminderCaptionLbl)
                {
                }
                column(CustNo_IssueReminderHdrCaption; "Issued Reminder Header".FieldCaption("Customer No."))
                {
                }
                column(ReminderLevelCaption; ReminderLevelCaptionLbl)
                {
                }
                column(ReminderLevel; "Issued Reminder Header"."Reminder Level")
                {
                }
                dataitem(DimensionLoop; "Integer")
                {
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(DimText; DimText)
                    {
                    }
                    column(Number_IntegerLine; DimensionLoop.Number)
                    {
                    }
                    column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if DimensionLoop.Number = 1 then begin
                            if not DimSetEntry.FindSet() then
                                CurrReport.Break();
                        end else
                            if not Continue then
                                CurrReport.Break();

                        Clear(DimText);
                        Continue := false;
                        repeat
                            OldDimText := DimText;
                            if DimText = '' then
                                DimText := StrSubstNo('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
                            else
                                DimText :=
                                  StrSubstNo(
                                    '%1; %2 - %3', DimText,
                                    DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                            if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                            end;
                        until DimSetEntry.Next() = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowInternalInfo then
                            CurrReport.Break();
                    end;
                }
                dataitem("Issued Reminder Line"; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = field("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = sorting("Reminder No.", "Line No.");
                    column(RemAmt_IssuedReminderLine; "Issued Reminder Line"."Remaining Amount")
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Desc_IssuedReminderLine; "Issued Reminder Line".Description)
                    {
                    }
                    column(Type_IssuedReminderLine; Format("Issued Reminder Line".Type, 0, 2))
                    {
                    }
                    column(DocDate_IssuedReminderLine; Format("Issued Reminder Line"."Document Date"))
                    {
                    }
                    column(DocNo_IssuedReminderLine; "Issued Reminder Line"."Document No.")
                    {
                    }
                    column(DocNoCaption_IssuedReminderLine; "Issued Reminder Line".FieldCaption("Issued Reminder Line"."Document No."))
                    {
                    }
                    column(DueDate_IssuedReminderLine; Format("Issued Reminder Line"."Due Date"))
                    {
                    }
                    column(OriginalAmt_IssuedReminderLine; "Issued Reminder Line"."Original Amount")
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(DocType_IssuedReminderLine; "Issued Reminder Line"."Document Type")
                    {
                    }
                    column(LineNo_IssuedReminderLine; "Issued Reminder Line"."No.")
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(NNCInterestAmt; NNC_InterestAmount)
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(NNCTotal; NNC_Total)
                    {
                    }
                    column(TotalInclVATText; TotalInclVATText)
                    {
                    }
                    column(NNCVATAmt; NNC_VATAmount)
                    {
                    }
                    column(NNCTotalInclVAT; NNC_TotalInclVAT)
                    {
                    }
                    column(TotalVATAmt; TotalVATAmount)
                    {
                    }
                    column(RemNo_IssuedReminderLine; "Issued Reminder Line"."Reminder No.")
                    {
                    }
                    column(DocumentDateCaption1; DocumentDateCaption1Lbl)
                    {
                    }
                    column(InterestAmountCaption; InterestAmountCaptionLbl)
                    {
                    }
                    column(RemAmt_IssuedReminderLineCaption; "Issued Reminder Line".FieldCaption("Issued Reminder Line"."Remaining Amount"))
                    {
                    }
                    column(DocNo_IssuedReminderLineCaption; "Issued Reminder Line".FieldCaption("Issued Reminder Line"."Document No."))
                    {
                    }
                    column(OriginalAmt_IssuedReminderLineCaption; "Issued Reminder Line".FieldCaption("Issued Reminder Line"."Original Amount"))
                    {
                    }
                    column(DocType_IssuedReminderLineCaption; "Issued Reminder Line".FieldCaption("Issued Reminder Line"."Document Type"))
                    {
                    }
                    column(Interest; Interest)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.Init();
                        VATAmountLine."VAT Identifier" := "Issued Reminder Line"."VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := "Issued Reminder Line"."VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := "Issued Reminder Line"."Tax Group Code";
                        VATAmountLine."VAT %" := "Issued Reminder Line"."VAT %";
                        VATAmountLine."VAT Base" := "Issued Reminder Line".Amount;
                        VATAmountLine."VAT Amount" := "Issued Reminder Line"."VAT Amount";
                        VATAmountLine."Amount Including VAT" := "Issued Reminder Line".Amount + "Issued Reminder Line"."VAT Amount";
                        VATAmountLine."VAT Clause Code" := "Issued Reminder Line"."VAT Clause Code";
                        VATAmountLine.InsertLine;

                        case "Issued Reminder Line".Type of
                            "Issued Reminder Line".Type::"G/L Account":
                                "Issued Reminder Line"."Remaining Amount" := "Issued Reminder Line".Amount;
                            "Issued Reminder Line".Type::"Line Fee":
                                "Issued Reminder Line"."Remaining Amount" := "Issued Reminder Line".Amount;
                            "Issued Reminder Line".Type::"Customer Ledger Entry":
                                ReminderInterestAmount := "Issued Reminder Line".Amount;
                        end;

                        NNC_InterestAmountTotal += ReminderInterestAmount;
                        NNC_RemainingAmountTotal += "Issued Reminder Line"."Remaining Amount";
                        NNC_VATAmountTotal += "Issued Reminder Line"."VAT Amount";

                        NNC_InterestAmount := (NNC_InterestAmountTotal + NNC_VATAmountTotal + "Issued Reminder Header"."Additional Fee" -
                                               AddFeeInclVAT + "Issued Reminder Header"."Add. Fee per Line" - AddFeePerLineInclVAT) /
                          (VATInterest / 100 + 1);
                        NNC_Total := NNC_RemainingAmountTotal + NNC_InterestAmountTotal;
                        NNC_VATAmount := NNC_VATAmountTotal;
                        NNC_TotalInclVAT := NNC_RemainingAmountTotal + NNC_InterestAmountTotal + NNC_VATAmountTotal;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if "Issued Reminder Line".FindLast() then begin
                            EndLineNo := "Issued Reminder Line"."Line No." + 1;
                            repeat
                                Continue :=
                                  not ShowNotDueAmounts and
                                  ("Issued Reminder Line"."No. of Reminders" = 0) and (("Issued Reminder Line".Type = "Issued Reminder Line".Type::"Customer Ledger Entry") or ("Issued Reminder Line".Type = "Issued Reminder Line".Type::"Line Fee")) or ("Issued Reminder Line".Type = "Issued Reminder Line".Type::" ");
                                if Continue then
                                    EndLineNo := "Issued Reminder Line"."Line No.";
                            until ("Issued Reminder Line".Next(-1) = 0) or not Continue;
                        end;

                        VATAmountLine.DeleteAll();
                        "Issued Reminder Line".SetFilter("Issued Reminder Line"."Line No.", '<%1', EndLineNo);
                    end;
                }
                dataitem(IssuedReminderLine2; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = field("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = sorting("Reminder No.", "Line No.");
                    column(Desc1_IssuedReminderLine; IssuedReminderLine2.Description)
                    {
                    }
                    column(LineNo1_IssuedReminderLine; IssuedReminderLine2."Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        IssuedReminderLine2.SetFilter(IssuedReminderLine2."Line No.", '>=%1', EndLineNo);
                        if not ShowNotDueAmounts then begin
                            IssuedReminderLine2.SetFilter(IssuedReminderLine2.Type, '<>%1', IssuedReminderLine2.Type::" ");
                            if IssuedReminderLine2.FindFirst() then
                                if IssuedReminderLine2."Line No." > EndLineNo then begin
                                    IssuedReminderLine2.SetRange(IssuedReminderLine2.Type);
                                    IssuedReminderLine2.SetRange(IssuedReminderLine2."Line No.", EndLineNo, IssuedReminderLine2."Line No." - 1); // find "Open Entries Not Due" line
                                    if IssuedReminderLine2.FindLast() then
                                        IssuedReminderLine2.SetRange(IssuedReminderLine2."Line No.", EndLineNo, IssuedReminderLine2."Line No." - 1);
                                end;
                            IssuedReminderLine2.SetRange(IssuedReminderLine2.Type);
                        end;
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(VATAmtLineAmtIncludVAT; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATAmount; VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATBase; VALVATBase)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseVALVATAmt; VALVATBase + VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVAT; VATAmountLine."VAT %")
                    {
                    }
                    column(AmountIncVATCaption; AmountIncVATCaptionLbl)
                    {
                    }
                    column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                    {
                    }
                    column(ContinuedCaption; ContinuedCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(VATCounter.Number);
                        VALVATBase := VATAmountLine."Amount Including VAT" / (1 + VATAmountLine."VAT %" / 100);
                        VALVATAmount := VATAmountLine."Amount Including VAT" - VALVATBase;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if VATAmountLine.GetTotalVATAmount = 0 then
                            CurrReport.Break();

                        VATCounter.SetRange(VATCounter.Number, 1, VATAmountLine.Count());

                        VALVATBase := 0;
                        VALVATAmount := 0;
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
                        AutoFormatExpression = "Issued Reminder Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATClausesCaption; VATClausesCap)
                    {
                    }
                    column(VATClauseVATIdentifierCaption; VATIdentifierCap)
                    {
                    }
                    column(VATClauseVATAmtCaption; VATAmountCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(VATClauseEntryCounter.Number);
                        if not VATClause.Get(VATAmountLine."VAT Clause Code") then
                            CurrReport.Skip();
                        VATClause.TranslateDescription("Issued Reminder Header"."Language Code");
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(VATClause);
                        VATClauseEntryCounter.SetRange(VATClauseEntryCounter.Number, 1, VATAmountLine.Count());
                    end;
                }
                dataitem(VATCounterLCY; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(VALExchRate; VALExchRate)
                    {
                    }
                    column(VALSpecLCYHeader; VALSpecLCYHeader)
                    {
                    }
                    column(VALVATAmountLCY; VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseLCY; VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVATCtrl107; VATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(ContinuedCaption1; ContinuedCaption1Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(VATCounterLCY.Number);

                        VALVATBaseLCY := Round(VATAmountLine."Amount Including VAT" / (1 + VATAmountLine."VAT %" / 100) / CurrFactor);
                        VALVATAmountLCY := Round(VATAmountLine."Amount Including VAT" / CurrFactor - VALVATBaseLCY);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (not GLSetup."Print VAT specification in LCY") or
                           ("Issued Reminder Header"."Currency Code" = '') or
                           (VATAmountLine.GetTotalVATAmount = 0)
                        then
                            CurrReport.Break();

                        VATCounterLCY.SetRange(VATCounterLCY.Number, 1, VATAmountLine.Count());

                        VALVATBaseLCY := 0;
                        VALVATAmountLCY := 0;

                        if GLSetup."LCY Code" = '' then
                            VALSpecLCYHeader := Text011 + Text012
                        else
                            VALSpecLCYHeader := Text011 + Format(GLSetup."LCY Code");

                        CurrExchRate.FindCurrency("Issued Reminder Header"."Posting Date", "Issued Reminder Header"."Currency Code", 1);
                        CustEntry.SetRange("Customer No.", "Issued Reminder Header"."Customer No.");
                        CustEntry.SetRange("Document Type", CustEntry."document type"::Reminder);
                        CustEntry.SetRange("Document No.", "Issued Reminder Header"."No.");
                        if CustEntry.FindFirst() then begin
                            CustEntry.CalcFields("Amount (LCY)", Amount);
                            CurrFactor := 1 / (CustEntry."Amount (LCY)" / CustEntry.Amount);
                            VALExchRate := StrSubstNo(Text013, Round(1 / CurrFactor * 100, 0.000001), CurrExchRate."Exchange Rate Amount");
                        end else begin
                            CurrFactor := CurrExchRate.ExchangeRate("Issued Reminder Header"."Posting Date", "Issued Reminder Header"."Currency Code");
                            VALExchRate := StrSubstNo(Text013, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                GLAcc: Record "G/L Account";
                CustPostingGroup: Record "Customer Posting Group";
                VATPostingSetup: Record "VAT Posting Setup";
                FormatAdr: Codeunit "Format Address";
            begin
                CurrReport.Language := LanguageCU.GetLanguageIdOrDefault("Language Code");


                DimSetEntry.SetRange("Dimension Set ID", "Issued Reminder Header"."Dimension Set ID");

                FormatAdr.IssuedReminder(CustAddr, "Issued Reminder Header");
                if "Issued Reminder Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Issued Reminder Header".FieldCaption("Issued Reminder Header"."Your Reference");
                if "Issued Reminder Header"."VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := "Issued Reminder Header".FieldCaption("Issued Reminder Header"."VAT Registration No.");
                if "Issued Reminder Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text000, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text001, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text000, "Issued Reminder Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text001, "Issued Reminder Header"."Currency Code");
                end;
                if not CurrReport.Preview() then begin
                    if LogInteraction then
                        SegManagement.LogDocument(
                          8, "Issued Reminder Header"."No.", 0, 0, Database::Customer, "Issued Reminder Header"."Customer No.", '', '', "Issued Reminder Header"."Posting Description", '');
                    "Issued Reminder Header".IncrNoPrinted;
                end;
                "Issued Reminder Header".CalcFields("Issued Reminder Header"."Additional Fee");
                CustPostingGroup.Get("Issued Reminder Header"."Customer Posting Group");
                if GLAcc.Get(CustPostingGroup."Additional Fee Account") then begin
                    VATPostingSetup.Get("Issued Reminder Header"."VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
                    AddFeeInclVAT := "Issued Reminder Header"."Additional Fee" * (1 + VATPostingSetup."VAT %" / 100);
                end else
                    AddFeeInclVAT := "Issued Reminder Header"."Additional Fee";

                "Issued Reminder Header".CalcFields("Issued Reminder Header"."Add. Fee per Line");
                AddFeePerLineInclVAT := "Issued Reminder Header"."Add. Fee per Line" + "Issued Reminder Header".CalculateLineFeeVATAmount;

                "Issued Reminder Header".CalcFields("Issued Reminder Header"."Interest Amount", "Issued Reminder Header"."VAT Amount");
                if ("Issued Reminder Header"."Interest Amount" <> 0) and ("Issued Reminder Header"."VAT Amount" <> 0) then begin
                    GLAcc.Get(CustPostingGroup."Interest Account");
                    VATPostingSetup.Get("Issued Reminder Header"."VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
                    VATInterest := VATPostingSetup."VAT %";
                    Interest :=
                      ("Issued Reminder Header"."Interest Amount" +
                       "Issued Reminder Header"."VAT Amount" + "Issued Reminder Header"."Additional Fee" - AddFeeInclVAT + "Issued Reminder Header"."Add. Fee per Line" - AddFeePerLineInclVAT) / (VATInterest / 100 + 1);
                end else begin
                    Interest := "Issued Reminder Header"."Interest Amount";
                    VATInterest := 0;
                end;

                TotalVATAmount := "Issued Reminder Header"."VAT Amount";
                NNC_InterestAmountTotal := 0;
                NNC_RemainingAmountTotal := 0;
                NNC_VATAmountTotal := 0;
                NNC_InterestAmount := 0;
                NNC_Total := 0;
                NNC_VATAmount := 0;
                NNC_TotalInclVAT := 0;

                //>> 27-08-19 ZY-LD 003
                /*
                recbankAcc.SetRange("Currency Code", "Issued Reminder Header"."Currency Code");
                */
                if ("Currency Code" = GLSetup."LCY Code") or ("Currency Code" = '') then
                    recBankAcc.SetFilter("Currency Code", '%1', '')
                else
                    recBankAcc.SetRange("Currency Code", "Currency Code");

                recbankAcc.SetRange(Blocked, false);
                //>> 11-09-24 ZY-LD 000
                //recbankAcc.FindFirst();
                recbankAcc.SetRange("Use as Default for Currency", true);
                if not recbankAcc.FindFirst() then begin
                    recbankAcc.SetRange("Use as Default for Currency");
                    recbankAcc.FindFirst();
                end;
                //<< 11-09-24 ZY-LD 000
                if recbankAcc.Count() <> 1 then
                    Error(Text50001, recbankAcc.TableCaption(), "Issued Reminder Header".FieldCaption("Issued Reminder Header"."Currency Code"), "Issued Reminder Header"."Currency Code");
                recbankAcc.TestField(Iban);
                CompanyInfo.Iban := recbankAcc.Iban;
                CompanyInfo."SWIFT Code" := recbankAcc."SWIFT Code";
                CompanyInfo."Currency Code" := "Issued Reminder Header"."Currency Code";
                //<< 27-08-19 ZY-LD 003
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                FormatAddrCodeunit.Company(CompanyAddr, CompanyInfo);
                //16-58056 -
                CompanyInfo.CalcFields(Picture);
                CompanyTxt1 := CompanyInfo.Name;
                CompanyTxt2 := CompanyInfo.Address;
                CompanyTxt3 := CompanyInfo."Country/Region Code" + '-' + CompanyInfo."Post Code" + ' ' + CompanyInfo.City;
                CompanyTxt5 := CompanyInfo."Finance Phone No.";  // 08-08-18 ZY-LD 001
                CompanyTxt6 := CompanyInfo."Fax No.";
                CompanyTxt7 := 'VAT/CVR No. ' + CompanyInfo."VAT Registration No.";
                //16-58056 +
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
                    field(ShowNotDueAmounts; ShowNotDueAmounts)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Not Due Amounts';
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
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Rmdr.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
    end;

    var
        Text000: Label 'Total %1';
        Text001: Label 'Total %1 Incl. VAT';
        Text002: Label 'Page %1';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        VATClause: Record "VAT Clause";
        DimSetEntry: Record "Dimension Set Entry";
        LanguageCU: Codeunit Language;
        CurrExchRate: Record "Currency Exchange Rate";
        FormatAddrCodeunit: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        VATNoText: Text[30];
        ReferenceText: Text[35];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        ReminderInterestAmount: Decimal;
        EndLineNo: Integer;
        Continue: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CurrFactor: Decimal;
        Text011: Label 'VAT Amount Specification in ';
        Text012: Label 'Local Currency';
        Text013: Label 'Exchange rate: %1/%2';
        CustEntry: Record "Cust. Ledger Entry";
        AddFeeInclVAT: Decimal;
        AddFeePerLineInclVAT: Decimal;
        TotalVATAmount: Decimal;
        VATInterest: Decimal;
        Interest: Decimal;
        VALVATBase: Decimal;
        VALVATAmount: Decimal;
        NNC_InterestAmount: Decimal;
        NNC_Total: Decimal;
        NNC_VATAmount: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_InterestAmountTotal: Decimal;
        NNC_RemainingAmountTotal: Decimal;
        NNC_VATAmountTotal: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ShowNotDueAmounts: Boolean;
        TextPageLbl: Label 'Page';
        PostingDateCaptionLbl: Label 'Posting Date';
        ReminderNoCaptionLbl: Label 'Reminder No.';
        BankAccNoCaptionLbl: Label 'Account No.';
        BankNameCaptionLbl: Label 'Bank';
        GiroNoCaptionLbl: Label 'Giro No.';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        PhoneNoCaptionLbl: Label 'Phone No.';
        ReminderCaptionLbl: Label 'Reminder';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        DocumentDateCaption1Lbl: Label 'Document Date';
        InterestAmountCaptionLbl: Label 'Interest Amount';
        AmountIncVATCaptionLbl: Label 'Amount Including VAT';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        VATClausesCap: Label 'VAT Clause';
        VATIdentifierCap: Label 'VAT Identifier';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption1Lbl: Label 'Continued';
        DueDateCaptiionLbl: Label 'Due Date';
        VATAmountCaptionLbl: Label 'VAT Amount';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATPercentCaptionLbl: Label 'VAT %';
        TotalCaptionLbl: Label 'Total';
        PageCaptionLbl: Label 'Page';
        DocDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EMailCaptionLbl: Label 'E-Mail';
        CompanyTxt1: Text[50];
        CompanyTxt2: Text[50];
        CompanyTxt3: Text[50];
        CompanyTxt4: Text[50];
        CompanyTxt5: Text[50];
        CompanyTxt6: Text[50];
        CompanyTxt7: Text[50];
        DT005: Label 'Bank Branch %1';
        RD001: Label '-';
        ReminderLevelCaptionLbl: Label 'Reminder Level';
        CompanyInfoIban: Text[50];
        recbankAcc: Record "Bank Account";
        Text50001: Label 'There are more than one "%1" with "%2" %3.';
}
