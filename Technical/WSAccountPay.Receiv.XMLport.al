XmlPort 50015 "WS Account Pay./Receiv"
{
    // 001. 02-11-21 ZY-LD 000 - Posting groups is taken from the Customer/Vendor instead of the entries.
    // 002. 31-01-22 ZY-LD 2022013110000031 - "Credit Limit" must be calculated in reporting currency.
    // 003. 15-08-22 ZY-LD 2022081510000077 - HQ Company Name.
    // 004. 16-06-23 ZY-LD #4416638 - Due Date has been added to Payable.
    // 005. 11-10-23 ZY-LD #4160925 - .

    Caption = 'WS Account Pay./Receiv';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/acc';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            textelement(EndDate)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    Evaluate(gEndDate, EndDate, 9);
                end;
            }
            textelement(CurrencyDate)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    Evaluate(gCurrencyDate, CurrencyDate, 9);
                end;
            }
            textelement(ReportingCurrency)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
            }
            tableelement("Account Pay./Receiv Buffer"; "Account Pay./Receiv Buffer")
            {
                MinOccurs = Zero;
                XmlName = 'Account';
                UseTemporary = true;
                fieldelement(EntryNo; "Account Pay./Receiv Buffer"."Entry No.")
                {
                }
                fieldelement(CompanyName; "Account Pay./Receiv Buffer"."Company Name")
                {
                }
                fieldelement(HQCompanyName; "Account Pay./Receiv Buffer"."HQ Company Name")
                {
                }
                fieldelement(HQAccountNo; "Account Pay./Receiv Buffer"."HQ Account No.")
                {
                }
                fieldelement(HQAccountName; "Account Pay./Receiv Buffer"."HQ Account Name")
                {
                }
                fieldelement(GLAccountNo; "Account Pay./Receiv Buffer"."G/L Account No.")
                {
                }
                fieldelement(GLAccountName; "Account Pay./Receiv Buffer"."G/L Account Name")
                {
                }
                fieldelement(SourceNo; "Account Pay./Receiv Buffer"."Source No.")
                {
                }
                fieldelement(SourceName; "Account Pay./Receiv Buffer"."Source Name")
                {
                }
                fieldelement(CreditLimit; "Account Pay./Receiv Buffer"."Credit Limit")
                {
                }
                fieldelement(Division; "Account Pay./Receiv Buffer".Division)
                {
                }
                fieldelement(PaymentTerms; "Account Pay./Receiv Buffer"."Payment Terms")
                {
                }
                fieldelement(InvoiceNo; "Account Pay./Receiv Buffer"."Invoice No.")
                {
                }
                fieldelement(VendorInvoiceNo; "Account Pay./Receiv Buffer"."Vendor Invoice No.")
                {
                }
                fieldelement(PostingDate; "Account Pay./Receiv Buffer"."Posting Date")
                {
                }
                fieldelement(DocumentDate; "Account Pay./Receiv Buffer"."Document Date")
                {
                }
                fieldelement(DueDate; "Account Pay./Receiv Buffer"."Due Date")
                {
                }
                fieldelement(ClosedAtDate; "Account Pay./Receiv Buffer"."Closed at Date")
                {
                }
                fieldelement(TxnCurrenyCode; "Account Pay./Receiv Buffer"."TXN Currency Code")
                {
                }
                fieldelement(TxnAmount; "Account Pay./Receiv Buffer"."TXN Amount")
                {
                }
                fieldelement(TxnEndingBalance; "Account Pay./Receiv Buffer"."TXN Ending Balance")
                {
                }
                fieldelement(LcyCurrencyCode; "Account Pay./Receiv Buffer"."LCY Currency Code")
                {
                }
                fieldelement(LcyAmount; "Account Pay./Receiv Buffer"."LCY Amount")
                {
                }
                fieldelement(LcyEndingBalance; "Account Pay./Receiv Buffer"."LCY Ending Balance")
                {
                }
                fieldelement(RptCurrencyCode; "Account Pay./Receiv Buffer"."RPT Currency Code")
                {
                }
                fieldelement(RptAmount; "Account Pay./Receiv Buffer"."RPT Amount")
                {
                }
                fieldelement(RptEndingBalance; "Account Pay./Receiv Buffer"."RPT Ending Balance")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    if "Account Pay./Receiv Buffer"."Entry No." = 0 then
                        currXMLport.Skip;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        LbNo: Integer;
        gEndDate: Date;
        gCurrencyDate: Date;


    procedure SetRequest(pEndDate: Date; pCurrencyDate: Date; pReportingCurrency: Code[10])
    begin
        EndDate := Format(pEndDate, 0, 9);
        CurrencyDate := Format(pCurrencyDate, 0, 9);
        ReportingCurrency := pReportingCurrency;
    end;


    procedure SetDataPayable()
    var
        recVendLedgEntry: Record "Vendor Ledger Entry";
        recGlSetup: Record "General Ledger Setup";
        recVend: Record Vendor;
        recVendPostGrp: Record "Vendor Posting Group";
        recGlAcc: Record "G/L Account";
        recCurrExchRate: Record "Currency Exchange Rate";
    begin
        begin
            recGlSetup.Get;

            recVend.SetFilter("Date Filter", '..%1', gEndDate);
            recVend.SetFilter("Net Change", '<>0');
            if recVend.FindSet then
                repeat
                    Clear("Account Pay./Receiv Buffer");
                    "Account Pay./Receiv Buffer".Init;
                    "Account Pay./Receiv Buffer"."Company Name" := CompanyName();
                    "Account Pay./Receiv Buffer"."Source No." := recVend."No.";
                    "Account Pay./Receiv Buffer"."Source Name" := recVend.Name;
                    "Account Pay./Receiv Buffer"."Payment Terms" := recVend."Payment Terms Code";

                    //>> 02-11-21 ZY-LD 001
                    if recVendPostGrp.Code <> recVend."Vendor Posting Group" then begin
                        recVendPostGrp.Get(recVend."Vendor Posting Group");
                        recGlAcc.Get(recVendPostGrp."Payables Account");
                    end;
                    //<< 02-11-21 ZY-LD 001

                    recVendLedgEntry.SetRange(recVendLedgEntry."Vendor No.", recVend."No.");
                    recVend.Copyfilter("Date Filter", recVendLedgEntry."Date Filter");
                    //SETFILTER("Date Filter",'..%1',gEndDate);
                    recVendLedgEntry.SetFilter(recVendLedgEntry."Remaining Amount", '<>0');
                    recVendLedgEntry.SetAutocalcFields(recVendLedgEntry.Amount, recVendLedgEntry."Amount (LCY)", recVendLedgEntry."Remaining Amount", recVendLedgEntry."Remaining Amt. (LCY)");
                    if recVendLedgEntry.FindSet then
                        repeat
                            if recVendLedgEntry."Currency Code" = '' then
                                recVendLedgEntry."Currency Code" := recGlSetup."LCY Code";

                            //>> 02-11-21 ZY-LD 001
                            /*IF recVendPostGrp.Code <> "Vendor Posting Group" THEN BEGIN
                              recVendPostGrp.GET("Vendor Posting Group");
                              recGlAcc.GET(recVendPostGrp."Payables Account");
                            END;*/
                            //<< 02-11-21 ZY-LD 001

                            LbNo += 1;
                            "Account Pay./Receiv Buffer"."Entry No." := LbNo;
                            "Account Pay./Receiv Buffer"."HQ Account No." := recGlAcc."No. 2";
                            "Account Pay./Receiv Buffer"."HQ Account Name" := recGlAcc."Name 2";
                            "Account Pay./Receiv Buffer"."G/L Account No." := recGlAcc."RHQ G/L Account No.";
                            "Account Pay./Receiv Buffer"."G/L Account Name" := recGlAcc."RHQ G/L Account Name";
                            "Account Pay./Receiv Buffer".Division := GetDivision(recVendLedgEntry."Global Dimension 1 Code");
                            "Account Pay./Receiv Buffer"."Invoice No." := recVendLedgEntry."Document No.";
                            "Account Pay./Receiv Buffer"."Vendor Invoice No." := GetExternalDocumentNo(recVendLedgEntry."Document Type", recVendLedgEntry."Document No.");
                            "Account Pay./Receiv Buffer"."Posting Date" := recVendLedgEntry."Posting Date";
                            "Account Pay./Receiv Buffer"."Due Date" := recVendLedgEntry."Due Date";  // 16-06-23 ZY-LD 004
                            "Account Pay./Receiv Buffer"."TXN Currency Code" := recVendLedgEntry."Currency Code";
                            "Account Pay./Receiv Buffer"."TXN Amount" := recVendLedgEntry.Amount;
                            "Account Pay./Receiv Buffer"."TXN Ending Balance" := recVendLedgEntry."Remaining Amount";
                            "Account Pay./Receiv Buffer"."LCY Currency Code" := recGlSetup."LCY Code";
                            "Account Pay./Receiv Buffer"."LCY Amount" := recVendLedgEntry."Amount (LCY)";
                            "Account Pay./Receiv Buffer"."LCY Ending Balance" := recVendLedgEntry."Remaining Amt. (LCY)";

                            "Account Pay./Receiv Buffer"."RPT Currency Code" := ReportingCurrency;
                            if recGlSetup."LCY Code" = ReportingCurrency then begin
                                "Account Pay./Receiv Buffer"."RPT Amount" := recVendLedgEntry."Amount (LCY)";
                                "Account Pay./Receiv Buffer"."RPT Ending Balance" := recVendLedgEntry."Remaining Amt. (LCY)";
                            end else
                                if recVendLedgEntry."Currency Code" = ReportingCurrency then begin
                                    "Account Pay./Receiv Buffer"."RPT Amount" := recVendLedgEntry.Amount;
                                    "Account Pay./Receiv Buffer"."RPT Ending Balance" := recVendLedgEntry."Remaining Amount";
                                end else begin
                                    "Account Pay./Receiv Buffer"."RPT Amount" := recCurrExchRate.ExchangeAmount(recVendLedgEntry.Amount, recVendLedgEntry."Currency Code", ReportingCurrency, gCurrencyDate);
                                    "Account Pay./Receiv Buffer"."RPT Ending Balance" := recCurrExchRate.ExchangeAmount(recVendLedgEntry."Remaining Amount", recVendLedgEntry."Currency Code", ReportingCurrency, gCurrencyDate);
                                end;
                            "Account Pay./Receiv Buffer".Insert;
                        until recVendLedgEntry.Next() = 0;
                until recVend.Next() = 0;

            EndDate := '';
            CurrencyDate := '';
            ReportingCurrency := '';
        end;

    end;


    procedure SetDataReceivable()
    var
        recCustLedgEntry: Record "Cust. Ledger Entry";
        recGlSetup: Record "General Ledger Setup";
        recCust: Record Customer;
        recCustPostGrp: Record "Customer Posting Group";
        recGlAcc: Record "G/L Account";
        recCurrExchRate: Record "Currency Exchange Rate";
        recCompInfo: Record "Company Information";
    begin
        begin
            recGlSetup.Get;
            recCompInfo.Get;  // 15-08-22 ZY-LD 003

            recCust.SetFilter("Date Filter", '..%1', gEndDate);
            recCust.SetFilter("Net Change", '<>0');
            if recCust.FindSet then
                repeat
                    Clear("Account Pay./Receiv Buffer");
                    "Account Pay./Receiv Buffer".Init;
                    "Account Pay./Receiv Buffer"."Company Name" := CompanyName();
                    "Account Pay./Receiv Buffer"."HQ Company Name" := recCompInfo."HQ Company Name";  // 15-08-22 ZY-LD 003
                    "Account Pay./Receiv Buffer"."Source No." := recCust."No.";
                    "Account Pay./Receiv Buffer"."Source Name" := recCust.Name;
                    "Account Pay./Receiv Buffer"."Payment Terms" := recCust."Payment Terms Code";
                    if recGlSetup."LCY Code" = ReportingCurrency then  // 31-01-22 ZY-LD 002
                        "Account Pay./Receiv Buffer"."Credit Limit" := recCust."Credit Limit (LCY)"
                    else
                        "Account Pay./Receiv Buffer"."Credit Limit" := recCurrExchRate.ExchangeAmount(recCust."Credit Limit (LCY)", recGlSetup."LCY Code", ReportingCurrency, gCurrencyDate);  // 31-01-22 ZY-LD 002

                    //>> 02-11-21 ZY-LD 001
                    if recCustPostGrp.Code <> recCust."Customer Posting Group" then begin
                        recCustPostGrp.Get(recCust."Customer Posting Group");
                        recGlAcc.Get(recCustPostGrp."Receivables Account");
                    end;
                    //<< 02-11-21 ZY-LD 001

                    recCustLedgEntry.SetRange(recCustLedgEntry."Customer No.", recCust."No.");
                    recCust.Copyfilter("Date Filter", recCustLedgEntry."Date Filter");
                    recCustLedgEntry.SetFilter(recCustLedgEntry."Remaining Amount", '<>0');
                    recCustLedgEntry.SetAutocalcFields(recCustLedgEntry.Amount, recCustLedgEntry."Amount (LCY)", recCustLedgEntry."Remaining Amount", recCustLedgEntry."Remaining Amt. (LCY)");
                    if recCustLedgEntry.FindSet then
                        repeat
                            if recCustLedgEntry."Currency Code" = '' then
                                recCustLedgEntry."Currency Code" := recGlSetup."LCY Code";

                            //>> 02-11-21 ZY-LD 001
                            /*IF recCustPostGrp.Code <> "Customer Posting Group" THEN BEGIN
                              recCustPostGrp.GET("Customer Posting Group");
                              recGlAcc.GET(recCustPostGrp."Receivables Account");
                            END;*/
                            //<< 02-11-21 ZY-LD 001

                            LbNo += 1;
                            "Account Pay./Receiv Buffer"."Entry No." := LbNo;
                            "Account Pay./Receiv Buffer"."HQ Account No." := recGlAcc."No. 2";
                            "Account Pay./Receiv Buffer"."HQ Account Name" := recGlAcc."Name 2";
                            "Account Pay./Receiv Buffer"."G/L Account No." := recGlAcc."RHQ G/L Account No.";
                            "Account Pay./Receiv Buffer"."G/L Account Name" := recGlAcc."RHQ G/L Account Name";
                            "Account Pay./Receiv Buffer".Division := GetDivision(recCustLedgEntry."Global Dimension 1 Code");
                            "Account Pay./Receiv Buffer"."Invoice No." := recCustLedgEntry."Document No.";
                            "Account Pay./Receiv Buffer"."Posting Date" := recCustLedgEntry."Posting Date";
                            "Account Pay./Receiv Buffer"."Document Date" := recCustLedgEntry."Document Date";
                            "Account Pay./Receiv Buffer"."Due Date" := recCustLedgEntry."Due Date";
                            "Account Pay./Receiv Buffer"."TXN Currency Code" := recCustLedgEntry."Currency Code";
                            "Account Pay./Receiv Buffer"."TXN Amount" := recCustLedgEntry.Amount;
                            "Account Pay./Receiv Buffer"."TXN Ending Balance" := recCustLedgEntry."Remaining Amount";
                            "Account Pay./Receiv Buffer"."LCY Currency Code" := recGlSetup."LCY Code";
                            "Account Pay./Receiv Buffer"."LCY Amount" := recCustLedgEntry."Amount (LCY)";
                            "Account Pay./Receiv Buffer"."LCY Ending Balance" := recCustLedgEntry."Remaining Amt. (LCY)";

                            "Account Pay./Receiv Buffer"."RPT Currency Code" := ReportingCurrency;
                            if recGlSetup."LCY Code" = ReportingCurrency then begin
                                "Account Pay./Receiv Buffer"."RPT Amount" := recCustLedgEntry."Amount (LCY)";
                                "Account Pay./Receiv Buffer"."RPT Ending Balance" := recCustLedgEntry."Remaining Amt. (LCY)";
                            end else
                                if recCustLedgEntry."Currency Code" = ReportingCurrency then begin
                                    "Account Pay./Receiv Buffer"."RPT Amount" := recCustLedgEntry.Amount;
                                    "Account Pay./Receiv Buffer"."RPT Ending Balance" := recCustLedgEntry."Remaining Amount";
                                end else begin
                                    "Account Pay./Receiv Buffer"."RPT Amount" := recCurrExchRate.ExchangeAmount(recCustLedgEntry.Amount, recCustLedgEntry."Currency Code", ReportingCurrency, gCurrencyDate);
                                    "Account Pay./Receiv Buffer"."RPT Ending Balance" := recCurrExchRate.ExchangeAmount(recCustLedgEntry."Remaining Amount", recCustLedgEntry."Currency Code", ReportingCurrency, gCurrencyDate);
                                end;
                            "Account Pay./Receiv Buffer".Insert;
                        until recCustLedgEntry.Next() = 0;
                until recCust.Next() = 0;

            EndDate := '';
            CurrencyDate := '';
            ReportingCurrency := '';
        end;

    end;


    procedure GetDataPayReceive(Type: Option Payment,Receivable; pEndDate: Date; pCurrencyDate: Date; pReportingCurrency: Code[10]; var AccPayBuff: Record "Account Pay./Receiv Buffer" temporary)
    var
        NextEntryNo: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        gEndDate := pEndDate;
        gCurrencyDate := pCurrencyDate;
        ReportingCurrency := pReportingCurrency;
        case Type of
            Type::Payment:
                SetDataPayable;
            Type::Receivable:
                SetDataReceivable;
        end;

        if "Account Pay./Receiv Buffer".FindSet then begin
            ZGT.OpenProgressWindow('', "Account Pay./Receiv Buffer".Count);
            if AccPayBuff.FindLast then
                NextEntryNo := AccPayBuff."Entry No.";

            repeat
                ZGT.UpdateProgressWindow(Format("Account Pay./Receiv Buffer"."Entry No."), 0, true);

                NextEntryNo += 1;
                AccPayBuff := "Account Pay./Receiv Buffer";
                AccPayBuff."Entry No." := NextEntryNo;
                AccPayBuff.Insert;
            until "Account Pay./Receiv Buffer".Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;

    local procedure GetDivision(pGlDim1Code: Code[20]) rValue: Code[20]
    var
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: label 'Channel';
        lText002: label 'Service Provider';
        lText003: label 'Other';
    begin
        case CopyStr(pGlDim1Code, 1, 2) of
            'CH':
                rValue := lText001;
            'SP':
                rValue := lText002;
            else
                IF ZGT.IsZNetCompany AND (pGlDim1Code = '') THEN  // 11-10-23 ZY-LD 005
                    rValue := lText001
                ELSE
                    rValue := lText003;
        end;
    end;

    local procedure GetExternalDocumentNo(pDocType: Enum "Gen. Journal Document Type"; pNo: Code[20]) rValue: Text
    var
        recPurchInvHeader: Record "Purch. Inv. Header";
        recPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        case pDocType of
            Pdoctype::Invoice:
                if recPurchInvHeader.Get(pNo) then
                    rValue := recPurchInvHeader."Vendor Invoice No.";
            Pdoctype::"Credit Memo":
                if recPurchCrMemoHdr.Get(pNo) then
                    rValue := recPurchCrMemoHdr."Vendor Cr. Memo No.";
        end;
    end;
}
