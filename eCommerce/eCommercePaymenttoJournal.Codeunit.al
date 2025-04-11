codeunit 50065 "eCommerce-Payment to Journal"
{
    TableNo = "eCommerce Payment";

    trigger OnRun()
    var
        GLEntry: Record "G/L Entry";
    begin
        Update(Rec);
    end;

    var
        recAmzPayHead: Record "eCommerce Payment Header";
        recAmzCompMap: Record "eCommerce Market Place";
        Text001: Label 'Calculating eCommerce Payments.\';
        ZGT: Codeunit "ZyXEL General Tools";
        RHQName: Text[250];
        Err0001: Label 'The Company does not exist in the eCommerce Setup.';
        Err0002: Label 'The Company is not Active in the eCommerce Setup.';
        Err0003: Label 'The eCommerce Setup is not complete.';
        Text002: Label 'Updating Posting Imformation.\';
        Text003: Label 'Reseting Error Imformation.\';
        Text004: Label 'Searching for Errors.\';
        Text005: Label 'Checking Sales Invoice Headers.\';
        Text006: Label 'Checking eCommerce Sales Header Buffer.\';
        Text007: Label 'Writting General Journal Lines.\';
        Text008: Label 'eCommerce Payments have been Processed.';
        Text009: Label 'Update eCommerce Transactions.\';
        Text010: Label 'Creating Purchase Invoices.\';
        Text011: Label 'New "eCommerce Payment Matrix" is created.\Add "Posting Type" to the line, and run "Progress Fee" again.';
        Text012: Label 'Do you want to create purchase invoices on eCommerce Fees?';
        Err004: Label 'Fee Account Number is missing in eCommerce Setup.';
        Err005: Label 'Charge Account Number is missing in eCommerce Setup.';
        Text013: Label 'Applying Vendor Ledger Entries.\';
        Text014: Label 'Creating Cash Receipt Entries.\';
        Err006: Label 'Payment Journal Template Name missing in eCommerce Setup.';
        Err007: Label 'Payment Journal Batch Name missing in eCommerce Setup.';
        Err008: Label 'eCommerce Customer No. missing in eCommerce Setup.';
        Err009: Label 'eCommerce Payment Description missing in eCommerce Setup.';
        Err010: Label 'eCommerce Periodic Account No. missing in eCommerce Setup.';
        Err011: Label 'eCommerce Periodic Account Description missing in eCommerce Setup.';
        Err012: Label 'eCommerce Payment Number Series missing in eCommerce Setup.';
        NoSeriesMangement: Codeunit NoSeriesManagement;

    procedure RunWithConfirm(var Rec: Record "eCommerce Payment")
    begin
        if Confirm(Text012, true) then
            Update(Rec);
    end;

    local procedure Update(var Rec: Record "eCommerce Payment") rValue: Boolean
    var
        receCommercePayments: Record "eCommerce Payment";
        RHQNo: Code[20];
        recCustomerLedgerEntries: Record "Cust. Ledger Entry";
        recCustLedgEntryDE: Record "Cust. Ledger Entry";
        InvNo: Code[20];
        CrNo: Code[20];
        eCommerceInvoice: Text[250];
        recPurchInvHeader: Record "Purch. Inv. Header";
        PurchNo: Code[20];
        MarketPlace: Text[250];
        CountryCode: Text[250];
        recGenJournalBatch: Record "Gen. Journal Batch";
    begin
        begin
            RHQName := ZGT.GetRHQCompanyName;
            GetPostingInformation(Rec."Journal Batch No.");

            if ReadyToRun(Rec) then begin
                if ZGT.IsZNetCompany then
                    CreateSalesInvoice(Rec);
                CashReceiptJournal(Rec);
                CreatePurchaseInvoice(Rec);
                Message(Text008);
                rValue := true;
            end else
                Message(Text011);
        end;
    end;

    local procedure GetPostingInformation(pJnlBatchNo: Code[20])
    begin
        recAmzPayHead.Get(pJnlBatchNo);
        recAmzPayHead.TestField("Currency Code");
        if CopyStr(recAmzPayHead.Period, StrLen(recAmzPayHead.Period) - 1, 1) = '.' then begin
            recAmzPayHead.Period := recAmzPayHead.Period + Format(Today);
            recAmzPayHead.Modify(true);
        end;

        recAmzCompMap.Get(recAmzPayHead."Market Place ID");
        recAmzCompMap.TestField(Active);

        //recAmzCompMap.TESTFIELD("Fee Account No.");
        //recAmzCompMap.TESTFIELD("Charge Account No.");
        recAmzCompMap.TestField("Currency Code");
        recAmzCompMap.TestField("Vendor No.");
        //recAmzCompMap.TESTFIELD("Posting Company");
        recAmzCompMap.TestField("Cach Recipt G/L Template");
        recAmzCompMap.TestField("Cash Recipt G/L Batch");
        recAmzCompMap.TestField("Customer No.");
        recAmzCompMap.TestField("Cash Recipt Description");
        recAmzCompMap.TestField("Periodic Account No.");
        recAmzCompMap.TestField("Periodic Posting Description");
        recAmzCompMap.TestField("Cash Recipt Number Series");
        recAmzCompMap.TestField("Location Code");
        recAmzCompMap.TestField("Country Dimension");
        recAmzCompMap.TestField("Waste G/L Account No.");
    end;

    local procedure ReadyToRun(var pAmzPay: Record "eCommerce Payment"): Boolean
    var
        recAmzPay: Record "eCommerce Payment";
        PostingDescription: Text[250];
        receCommercePaymentsMatrix: Record "eCommerce Payment Matrix";
        PaymentMatrixCreated: Boolean;
    begin
        recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.");
        recAmzPay.SetRange("Journal Batch No.", pAmzPay."Journal Batch No.");
        recAmzPay.SetRange(Open, true);
        recAmzPay.SetRange("Amount Posting Type", recAmzPay."amount posting type"::" ");
        exit(not recAmzPay.FindFirst());
    end;

    local procedure CreatePurchaseInvoice(Rec: Record "eCommerce Payment")
    var
        recAmzPay: Record "eCommerce Payment";
        recAmzPayMatrix: Record "eCommerce Pay. Matrix";
        recGenJnl: Record "Gen. Journal Line";
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recGenLedgSetup: Record "General Ledger Setup";
        recDefDim: Record "Default Dimension";
        TotalAmount: Decimal;
        LineNo: Integer;
        DocNo: Code[20];
        DocType: Option "0","1",Invoice,"Credit Memo";
        CountryDim: Code[10];
        lText001: Label 'Purchase Invoice';
        i: Integer;
        lText002: Label 'There are lines in "%1" where "%2" is blank. Please choose a value.';
        lText003: Label 'eCommerce Expenses: %1';
        VatText: Text[10];
        lText004: Label 'eCome: %1';
        DimensionChanged: Boolean;
    begin
        begin
            recGenLedgSetup.Get();

            for i := 0 to 1 do begin
                TotalAmount := 0;

                recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.", "Sales Document No.", Open);
                recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
                recAmzPay.SetRange(Open, true);
                recAmzPay.SetFilter("Amount Posting Type", '%1|%2|%3|%4', recAmzPay."amount posting type"::Charge, recAmzPay."amount posting type"::Fee, recAmzPay."amount posting type"::Tax, recAmzPay."amount posting type"::Advertising);
                recAmzPay.SetFilter(Amount, '<>0');
                recAmzPay.SetFilter("Sales Document No.", '<>%1', 'ZYND DE');
                if i = 0 then begin
                    recAmzPay.SetRange("Amount Incl. VAT", recAmzPay."amount incl. vat"::" ");
                    if recAmzPay.FindFirst() then
                        Error(lText002, recAmzPayMatrix.TableCaption(), recAmzPayMatrix.FieldCaption("Amount Incl. VAT"));
                end;
                recAmzPay.SetRange("Amount Incl. VAT", i);
                recAmzPay.SetAutoCalcFields("Amount Posting Type", "G/L Account No.", "Amount Incl. VAT");
                recAmzPay.CalcSums(Amount);

                if recAmzPay.Amount < 0 then
                    DocType := Doctype::Invoice
                else
                    DocType := Doctype::"Credit Memo";

                if recAmzPay.FindSet(true) then begin
                    Clear(ZGT);
                    ZGT.OpenProgressWindow(lText001, recAmzPay.Count());

                    Clear(recPurchHead);
                    recPurchHead.Init();
                    recPurchHead.SetHideValidationDialog(true);
                    recPurchHead.Validate("Document Type", DocType);
                    recPurchHead.Insert(true);
                    recPurchHead.Validate("Buy-from Vendor No.", recAmzCompMap."Vendor No.");
                    if i = 1 then
                        recPurchHead.Validate("Prices Including VAT", true)
                    else
                        recPurchHead.Validate("Prices Including VAT", false);
                    recPurchHead.Validate("Posting Date", Today);
                    recPurchHead.Validate("Document Date", Today);
                    recPurchHead.Validate("Due Date", Today);
                    recPurchHead.Validate("Currency Code", recAmzPayHead."Currency Code");
                    recPurchHead."Posting Description" := CopyStr(StrSubstNo(lText003, recAmzPayHead.Period), 1, MaxStrLen(recPurchHead."Posting Description"));
                    if recPurchHead."Document Type" = recPurchHead."document type"::Invoice then
                        recPurchHead."Vendor Invoice No." := StrSubstNo(lText004, recPurchHead."No.")
                    else
                        recPurchHead."Vendor Cr. Memo No." := StrSubstNo(lText004, recPurchHead."No.");
                    recPurchHead."eCommerce Order" := true;
                    recPurchHead.Modify(true);

                    repeat
                        ZGT.UpdateProgressWindow(StrSubstNo('%1/2 %2', i + 1, lText001), 0, true);

                        recAmzPay.TestField("G/L Account No.");
                        DimensionChanged := false;
                        LineNo += 10000;

                        Clear(recPurchLine);
                        recPurchLine.Init();
                        recPurchLine.Validate("Document Type", recPurchHead."Document Type");
                        recPurchLine.Validate("Document No.", recPurchHead."No.");
                        recPurchLine.Validate("Line No.", LineNo);
                        recPurchLine.Validate(Type, recPurchLine.Type::"G/L Account");
                        recPurchLine.Validate("No.", recAmzPay."G/L Account No.");
                        if not recPurchHead."Prices Including VAT" then
                            recPurchLine.Validate("VAT Prod. Posting Group", '0');
                        recPurchLine.Description := CopyStr(StrSubstNo('%1: %2 %3', CopyStr(recAmzPay."New Transaction Type", 1, 1), recAmzPay."Amount Type", recAmzPay."Amount Description"), 1, MaxStrLen(recPurchLine.Description));
                        recPurchLine."External Document No." := recAmzPay."Order ID";
                        recPurchLine."Unit of Measure Code" := 'PCS';
                        recPurchLine."Vendor Invoice No" := recAmzPay."Order ID";
                        recPurchLine."External Document No." := recAmzPay."Order ID";
                        recPurchLine.Validate(Quantity, 1);
                        if recPurchHead."Document Type" = recPurchHead."document type"::Invoice then
                            recPurchLine.Validate("Direct Unit Cost", -recAmzPay.Amount)
                        else
                            recPurchLine.Validate("Direct Unit Cost", recAmzPay.Amount);
                        TotalAmount := TotalAmount + recPurchLine."Direct Unit Cost";
                        recPurchLine."Location Code" := '';
                        recPurchLine.Insert();

                        recDefDim.SetRange("Table ID", Database::"G/L Account");
                        recDefDim.SetRange("No.", recPurchLine."No.");
                        recDefDim.SetRange("Dimension Code", recGenLedgSetup."Global Dimension 2 Code");
                        if recDefDim.FindFirst() and (recDefDim."Value Posting" = recDefDim."value posting"::"Same Code") then begin
                            recPurchLine.Validate("Shortcut Dimension 2 Code", recDefDim."Dimension Value Code");
                            DimensionChanged := true;
                        end;

                        CountryDim := GetCountryDimension(recAmzPay."Order ID", recAmzCompMap."Country Dimension");
                        if CountryDim <> '' then begin
                            recPurchLine.ValidateShortcutDimCode(3, CountryDim);
                            DimensionChanged := true;
                        end;

                        if DimensionChanged then
                            recPurchLine.Modify();

                        recAmzPay."Fee Purchase Invoice No." := recPurchHead."No.";
                        recAmzPay.Open := false;
                        recAmzPay.Modify();
                    until recAmzPay.Next() = 0;
                    ZGT.CloseProgressWindow;
                end;

                // Create a payment journal
                if TotalAmount <> 0 then begin
                    DocNo := NoSeriesMangement.GetNextNo(recAmzCompMap."Payment Number Series", Today, true);
                    recGenJnl.Validate("Journal Template Name", recAmzCompMap."Payment G/L Template");
                    recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Payment G/L Batch");
                    recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Payment G/L Template", recAmzCompMap."Payment G/L Batch"));
                    recGenJnl.Validate("Posting Date", Today);
                    if recPurchHead."Document Type" = recPurchHead."document type"::Invoice then
                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment)
                    else
                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund);
                    recGenJnl.Validate("Document No.", DocNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Vendor);
                    recGenJnl.Validate("Account No.", recAmzCompMap."Vendor No.");
                    recGenJnl.Validate("Currency Code", recAmzPayHead."Currency Code");
                    if recPurchHead."Document Type" = recPurchHead."document type"::Invoice then
                        recGenJnl.Validate(Amount, TotalAmount)
                    else
                        recGenJnl.Validate(Amount, -TotalAmount);
                    recGenJnl.Validate("Applies-to Doc. Type", recPurchHead."Document Type");
                    recGenJnl.Validate("Applies-to Doc. No.", recPurchHead."No.");
                    recGenJnl.Insert();

                    Clear(recGenJnl);
                    recGenJnl.Validate("Journal Template Name", recAmzCompMap."Payment G/L Template");
                    recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Payment G/L Batch");
                    recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Payment G/L Template", recAmzCompMap."Payment G/L Batch"));
                    recGenJnl.Validate("Posting Date", Today);
                    if recPurchHead."Document Type" = recPurchHead."document type"::Invoice then
                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment)
                    else
                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund);
                    recGenJnl.Validate("Document No.", DocNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                    recGenJnl.Validate("Account No.", recAmzCompMap."Periodic Account No.");
                    recGenJnl.Validate("Currency Code", recAmzPayHead."Currency Code");
                    if recPurchHead."Document Type" = recPurchHead."document type"::Invoice then
                        recGenJnl.Validate(Amount, -TotalAmount)
                    else
                        recGenJnl.Validate(Amount, TotalAmount);
                    recGenJnl.Description := CopyStr(StrSubstNo(lText003, recAmzPayHead.Period), 1, MaxStrLen(recGenJnl.Description));
                    recGenJnl.Insert();
                end;

                Commit();
            end;
        end;
    end;

    local procedure CreateSalesInvoice(Rec: Record "eCommerce Payment")
    var
        recAmzPay: Record "eCommerce Payment";
        recAmzPay2: Record "eCommerce Payment";
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        SalesPost: Codeunit "Sales-Post";
        SI: Codeunit "Single Instance";
        LineNo: Integer;
        lText001: Label 'Sales Invoice';
        ExtDocNo: Code[35];
        ItemNo: Code[30];
        DimCode: Code[20];
    begin
        begin
            recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.", "Sales Document No.", Open, "Order ID");
            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange("Sales Document Created", false);
            recAmzPay.SetRange("Amount Posting Type", recAmzPay."amount posting type"::Sale);
            recAmzPay.SetFilter("Sales Document No.", '<>%1', 'ZYND DE');
            if recAmzPay.FindSet() then begin
                ZGT.OpenProgressWindow(lText001, recAmzPay.Count());
                SI.SetHideSalesDialog(true);
                SI.SetKeepLocationCode(true);

                repeat
                    ZGT.UpdateProgressWindow(lText001, 0, true);

                    if recAmzPay."Order ID" <> '' then
                        ExtDocNo := recAmzPay."Order ID"
                    else
                        ExtDocNo := CopyStr(recAmzPay."Amount Description", 1, MaxStrLen(ExtDocNo));

                    if recSalesHead."External Document No." <> ExtDocNo then begin
                        //IF recSalesHead."No." <> '' THEN
                        //SalesPost.RUN(recSalesHead);

                        Clear(recSalesHead);
                        recSalesHead.Init();
                        if recAmzPay.Amount < 0 then
                            recSalesHead.Validate("Document Type", recSalesHead."document type"::"Credit Memo")
                        else
                            recSalesHead.Validate("Document Type", recSalesHead."document type"::Invoice);
                        recSalesHead.Insert(true);
                        recSalesHead.SetHideValidationDialog(true);
                        recSalesHead.Validate("Sales Order Type", recSalesHead."sales order type"::Normal);
                        recSalesHead.Validate("Sell-to Customer No.", recAmzCompMap."Customer No.");
                        recSalesHead.Validate("Posting Date", Today);
                        recSalesHead.Validate("Document Date", Today);
                        recSalesHead.Validate("Due Date", Today);
                        recSalesHead.Validate("External Document No.", ExtDocNo);
                        recSalesHead."Posting Description" := CopyStr(StrSubstNo('%1 %2', recAmzPay."Amount Description", recAmzPayHead.Period), 1, MaxStrLen(recSalesHead."Posting Description"));
                        recSalesHead.Validate("Location Code", recAmzCompMap."Location Code");
                        recSalesHead.Validate("Currency Code", recAmzPayHead."Currency Code");
                        DimCode := GetCountryDimension(Rec."Order ID", recAmzCompMap."Country Dimension");
                        recSalesHead.ValidateShortcutDimCode(3, DimCode);

                        recSalesHead.Validate(Correction, true);  // It will not be validated against the eCommerce Header.
                        recSalesHead.Validate("Skip Posting Group Validation", true);
                        recSalesHead."eCommerce Order" := true;
                        recSalesHead.Modify(true);

                        LineNo := 0;
                    end;

                    LineNo += 10000;
                    Clear(recSalesLine);
                    recSalesLine.Init();
                    recSalesLine.SetHideValidationDialog(true);
                    recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                    recSalesLine.Validate("Document No.", recSalesHead."No.");
                    recSalesLine.Validate("Line No.", LineNo);
                    recSalesLine.Validate(Type, recSalesLine.Type::Item);
                    ItemNo := recAmzPay."Item No.";
                    if StrLen(ItemNo) > MaxStrLen(recSalesLine."No.") then begin
                        recItemIdent.SetRange(ExtendedCodeZX, recAmzPay."Item No.");
                        if recItemIdent.FindFirst() then
                            ItemNo := recItemIdent."Item No."
                        else
                            ItemNo := CopyStr(ItemNo, 1, MaxStrLen(recSalesLine."No."));
                    end;
                    if recItem.Get(ItemNo) then begin
                        recSalesLine.Validate("No.", recItem."No.");
                        recSalesLine.Validate(Quantity, recAmzPay.Quantity);
                        recSalesLine.Validate("Unit Price", Abs(recAmzPay.Amount) / (1 + (recSalesLine."VAT %" / 100)));
                    end else begin
                        recItemIdent.SetRange(ExtendedCodeZX, ItemNo);
                        if recItemIdent.FindFirst() then begin
                            recSalesLine.Validate("No.", recItemIdent."Item No.");
                            recSalesLine.Validate(Quantity, recAmzPay.Quantity);
                            recSalesLine.Validate("Unit Price", Abs(recAmzPay.Amount) / (1 + (recSalesLine."VAT %" / 100)));
                        end else begin
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", recAmzCompMap."Waste G/L Account No.");
                            recSalesLine.Validate(Quantity, recAmzPay.Quantity);
                            recSalesLine.Validate("Unit Price", Abs(recAmzPay.Amount) / (1 + (recSalesLine."VAT %" / 100)));
                        end;
                    end;
                    if recSalesLine."Document Type" = recSalesLine."document type"::"Credit Memo" then
                        recSalesLine."Return Reason Code" := '13';
                    recSalesLine.Insert();

                    recAmzPay2 := recAmzPay;
                    recAmzPay2."Sales Document Created" := true;
                    recAmzPay2."Sales Document Type" := recSalesHead."Document Type";
                    recAmzPay2."Sales Document No." := recSalesHead."No.";
                    recAmzPay2.Modify(true);
                until recAmzPay.Next() = 0;

                //IF recSalesHead."No." <> '' THEN
                //SalesPost.RUN(recSalesHead);

                SI.SetKeepLocationCode(false);
                SI.SetHideSalesDialog(false);
                ZGT.CloseProgressWindow;

                Commit();
            end;
        end;
    end;

    local procedure CashReceiptJournal(Rec: Record "eCommerce Payment")
    var
        recAmzPayHead: Record "eCommerce Payment Header";
        recAmzPay: Record "eCommerce Payment";
        recAmzPay2: Record "eCommerce Payment";
        recGenJnlTmp: Record "Gen. Journal Line" temporary;
        recGenJnl: Record "Gen. Journal Line";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMHead: Record "Sales Cr.Memo Header";
        recDefDim: Record "Default Dimension";
        recGenLedgSetup: Record "General Ledger Setup";
        recCustLedgEntry: Record "Cust. Ledger Entry";
        TotalAmountAmz: Decimal;
        TotalAmount: Decimal;
        DocumentNo: Code[20];
        SalesHeadAmount: Decimal;
        SalesInvHeadFound: Boolean;
        SalesCrMHeadFound: Boolean;
        lText001: Label 'Rounding';
        Difference: Decimal;
        LineNo: Integer;
        lText002: Label 'Cash Receipt';
        CountryDim: Code[10];
        lText003: Label 'eCommerce Payments: %1';
        ApplDiff: Decimal;
        lText004: Label 'Rounding amount is %1.\Roundings should be less that one. Please investigate.';
    begin
        begin
            recGenLedgSetup.Get();

            // Update Sales Document No. Primary used on Magento.
            recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.");
            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange(Open, true);
            recAmzPay.SetFilter("Amount Posting Type", '%1|%2', recAmzPay."amount posting type"::Payment, recAmzPay."amount posting type"::Sale);
            recAmzPay.SetFilter("Sales Document No.", '%1', '');

            if recAmzPay.FindSet() then
                repeat
                    recAmzPay2 := recAmzPay;
                    recAmzPay2.SetSalesDocumentNo;
                until recAmzPay.Next() = 0;

            recAmzPay.Reset();
            recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.", "Sales Document No.", Open);
            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange(Open, true);
            recAmzPay.SetFilter("Amount Posting Type", '%1|%2', recAmzPay."amount posting type"::Payment, recAmzPay."amount posting type"::Sale);
            recAmzPay.SetFilter("Sales Document No.", '<>%1', 'ZYND DE');

            if recAmzPay.FindSet(true) then begin
                ZGT.OpenProgressWindow(StrSubstNo('1/2 %1', lText002), recAmzPay.Count());
                DocumentNo := GetNextNumberJournal;
                recAmzPayHead.Get(recAmzPay."Journal Batch No.");

                repeat
                    ZGT.UpdateProgressWindow(StrSubstNo('1/2 %1', lText002), 0, true);
                    LineNo += 10000;

                    // Sum up amounts
                    recGenJnlTmp.Reset();
                    Clear(recGenJnlTmp);
                    recGenJnlTmp.SetRange("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                    recGenJnlTmp.SetRange("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                    recGenJnlTmp.SetRange("External Document No.", recAmzPay."Order ID");
                    recGenJnlTmp.SetRange(Description, recAmzPay."Shipment ID");
                    if recAmzPay."Sales Document Type" = recAmzPay."sales document type"::"Credit Memo" then
                        recGenJnlTmp.SetRange("Document Type", recGenJnlTmp."document type"::Refund)
                    else
                        recGenJnlTmp.SetRange("Document Type", recGenJnlTmp."document type"::Payment);
                    recGenJnlTmp.SetRange("Applies-to Doc. No.", recAmzPay."Sales Document No.");  // 03-03-23 ZY-LD - 001
                    if recGenJnlTmp.FindFirst() then begin
                        recGenJnlTmp.Validate(Amount, recGenJnlTmp.Amount + (-recAmzPay.Amount));
                        TotalAmountAmz += recAmzPay.Amount;
                        recGenJnlTmp.Modify();
                    end else begin
                        Clear(recGenJnlTmp);
                        recGenJnlTmp.Init();
                        recGenJnlTmp.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                        recGenJnlTmp.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                        recGenJnlTmp.Validate("Line No.", LineNo);
                        recGenJnlTmp.Validate("Posting Date", Today);
                        if recAmzPay."Sales Document Type" = recAmzPay."sales document type"::"Credit Memo" then
                            recGenJnlTmp.Validate("Document Type", recGenJnlTmp."document type"::Refund)
                        else
                            recGenJnlTmp.Validate("Document Type", recGenJnlTmp."document type"::Payment);
                        if recAmzPay."Sales Document No." <> '' then begin
                            recGenJnlTmp.Validate("Applies-to Doc. Type", recAmzPay."Sales Document Type");
                            recGenJnlTmp."Applies-to Doc. No." := recAmzPay."Sales Document No.";
                        end;
                        recGenJnlTmp.Validate("Document No.", DocumentNo);
                        recGenJnlTmp.Validate("Account Type", recGenJnlTmp."account type"::Customer);
                        recGenJnlTmp.Validate(Amount, -recAmzPay.Amount);
                        TotalAmountAmz += recAmzPay.Amount;
                        recGenJnlTmp.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recAmzPay."Order ID";
                        recGenJnlTmp."Account No." := recAmzCompMap."Customer No.";
                        if recAmzPay."Order ID" <> '' then
                            recGenJnlTmp."External Document No." := recAmzPay."Order ID"
                        else
                            recGenJnlTmp."External Document No." := CopyStr(recAmzPay."Amount Description", 1, MaxStrLen(recGenJnlTmp."External Document No."));
                        recGenJnlTmp.Description := recAmzPay."Shipment ID";
                        recGenJnlTmp.Insert();
                    end;

                    recAmzPay."Cash Receipt Journals Line" := true;
                    recAmzPay.Open := false;
                    recAmzPay.Modify();
                until recAmzPay.Next() = 0;
                ZGT.CloseProgressWindow;

                // Generate Journal
                recGenJnlTmp.Reset();
                if recGenJnlTmp.FindSet() then begin
                    ZGT.OpenProgressWindow(StrSubstNo('2/2 %1', lText002), recGenJnlTmp.Count());

                    repeat
                        ZGT.UpdateProgressWindow(StrSubstNo('2/2 %1', lText002), 0, true);

                        if recGenJnlTmp.Amount <> 0 then begin
                            Clear(recGenJnl);
                            recGenJnl.Init();
                            recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                            recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                            recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                            recGenJnl.Validate("Posting Date", Today);
                            recGenJnl.Validate("Document Type", recGenJnlTmp."Document Type");
                            recGenJnl.Validate("Document No.", DocumentNo);
                            recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                            recGenJnl.Validate("Account No.", recAmzCompMap."Customer No.");
                            recGenJnl.Validate("Currency Code", recAmzPayHead."Currency Code");
                            recGenJnl.Validate(Amount, recGenJnlTmp.Amount);
                            if recGenJnl."Document Type" = recGenJnl."document type"::Refund then
                                recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::"Credit Memo")
                            else
                                recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::Invoice);
                            recGenJnl.Validate("Applies-to Doc. No.", recGenJnlTmp."Applies-to Doc. No.");
                            recGenJnl.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recGenJnlTmp."External Document No.";
                            recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                            CountryDim := GetCountryDimension(recGenJnlTmp."External Document No.", recAmzCompMap."Country Dimension");
                            if CountryDim = '' then begin
                                recDefDim.Get(Database::Customer, recAmzCompMap."Customer No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                                recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                            end else
                                recGenJnl.ValidateShortcutDimCode(3, CountryDim);
                            recGenJnl.Insert(true);

                            ApplDiff := AppliedDiff(recGenJnl);
                            if ApplDiff <> 0 then begin
                                recGenJnl.Validate(Amount, recGenJnl.Amount - ApplDiff);
                                recGenJnl.Modify(true);
                            end;

                            TotalAmount += -recGenJnl.Amount;
                        end;
                    until recGenJnlTmp.Next() = 0;
                    ZGT.CloseProgressWindow;
                end;

                if TotalAmount <> 0 then begin
                    if TotalAmount - TotalAmountAmz <> 0 then begin
                        recGenLedgSetup.Get();

                        Clear(recGenJnl);
                        recGenJnl.Init();
                        recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                        recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                        recGenJnl.Validate("Posting Date", Today);
                        recGenJnl.Validate("Document No.", DocumentNo);
                        recGenJnl.Validate("Account Type", recGenJnl."account type"::"G/L Account");
                        recGenJnl.Validate("Account No.", recAmzCompMap.Roundings);
                        recGenJnl.Validate("Currency Code", recAmzPayHead."Currency Code");
                        recGenJnl.Validate(Amount, TotalAmount - TotalAmountAmz);
                        if Abs(recGenJnl.Amount) > 1 then
                            Message(lText004, TotalAmount - TotalAmountAmz);
                        recDefDim.Get(Database::Customer, recAmzCompMap."Periodic Account No.", recGenLedgSetup."Shortcut Dimension 1 Code");
                        recGenJnl.Validate("Shortcut Dimension 1 Code", recDefDim."Dimension Value Code");
                        recGenJnl.Validate("Shortcut Dimension 2 Code", 'G&A');
                        recGenJnl.Validate("Gen. Posting Type", recGenJnl."gen. posting type"::" ");
                        recGenJnl.Validate("Gen. Bus. Posting Group", '');
                        recGenJnl.Validate("Gen. Prod. Posting Group", '');
                        recGenJnl.Validate("VAT Bus. Posting Group", '');
                        recGenJnl.Validate("VAT Prod. Posting Group", '');
                        recGenJnl.Insert(true);

                        TotalAmount := TotalAmount - (TotalAmount - TotalAmountAmz);
                    end;

                    Clear(recGenJnl);
                    recGenJnl.Init();
                    recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                    recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                    recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                    recGenJnl.Validate("Posting Date", Today);
                    if TotalAmountAmz > 0 then
                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund)
                    else
                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment);
                    recGenJnl.Validate("Document No.", DocumentNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                    recGenJnl.Validate("Account No.", recAmzCompMap."Periodic Account No.");
                    recGenJnl.Validate("Currency Code", recAmzPayHead."Currency Code");
                    recGenJnl.Validate(Amount, TotalAmountAmz);
                    recGenJnl.Description := CopyStr(StrSubstNo(lText003, recAmzPayHead.Period), 1, MaxStrLen(recGenJnl.Description));
                    recDefDim.Get(Database::Customer, recAmzCompMap."Periodic Account No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                    recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                    recGenJnl.Insert(true);
                end;
            end;
            ZGT.CloseProgressWindow;
            Commit();
        end;
    end;

    local procedure OLD_CashReceiptJournal(Rec: Record "eCommerce Payment")
    var
        recAmzPay: Record "eCommerce Payment";
        recGenJnlTmp: Record "Gen. Journal Line" temporary;
        recGenJnl: Record "Gen. Journal Line";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMHead: Record "Sales Cr.Memo Header";
        recDefDim: Record "Default Dimension";
        recGenLedgSetup: Record "General Ledger Setup";
        recCustLedgEntry: Record "Cust. Ledger Entry";
        TotalAmountAzn: Decimal;
        TotalAmount: Decimal;
        DocumentNo: Code[20];
        SalesHeadAmount: Decimal;
        SalesInvHeadFound: Boolean;
        SalesCrMHeadFound: Boolean;
        lText001: Label 'Rounding';
        Difference: Decimal;
        LineNo: Integer;
        lText002: Label 'Cash Receipt';
        CountryDim: Code[10];
        lText003: Label 'eCommerce Payments: %1';
    begin
        begin
            recGenLedgSetup.Get();

            recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.");
            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange(Open, true);
            recAmzPay.SetFilter("Amount Posting Type", '%1|%2', recAmzPay."amount posting type"::Payment, recAmzPay."amount posting type"::Sale);
            recAmzPay.SetFilter("Sales Document No.", '<>%1', 'ZYND DE');

            if recAmzPay.FindSet(true) then begin
                ZGT.OpenProgressWindow(StrSubstNo('1/2 %1', lText002), recAmzPay.Count());
                DocumentNo := GetNextNumberJournal;

                repeat
                    ZGT.UpdateProgressWindow(StrSubstNo('1/2 %1', lText002), 0, true);

                    LineNo += 10000;

                    recGenJnlTmp.Reset();
                    Clear(recGenJnlTmp);
                    recGenJnlTmp.SetRange("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                    recGenJnlTmp.SetRange("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                    recGenJnlTmp.SetRange("External Document No.", recAmzPay."Order ID");
                    if recAmzPay."New Transaction Type" = 'REFUND' then
                        recGenJnlTmp.SetRange("Document Type", recGenJnlTmp."document type"::Refund)
                    else
                        recGenJnlTmp.SetRange("Document Type", recGenJnlTmp."document type"::Payment);
                    if recGenJnlTmp.FindFirst() then begin
                        recGenJnlTmp.Validate(Amount, recGenJnlTmp.Amount + (-recAmzPay.Amount));
                        TotalAmountAzn += recAmzPay.Amount;
                        recGenJnlTmp.Modify();
                    end else begin
                        Clear(recGenJnlTmp);
                        recGenJnlTmp.Init();
                        recGenJnlTmp.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                        recGenJnlTmp.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                        recGenJnlTmp.Validate("Line No.", LineNo);
                        recGenJnlTmp.Validate("Posting Date", Today);
                        if recAmzPay."New Transaction Type" = 'REFUND' then begin
                            recGenJnlTmp.Validate("Document Type", recGenJnlTmp."document type"::Refund);
                            recGenJnlTmp.Validate("Applies-to Doc. Type", recGenJnlTmp."applies-to doc. type"::"Credit Memo");
                            recGenJnlTmp."Applies-to Doc. No." := recAmzPay."Sales Credit No.";
                        end else begin
                            recGenJnlTmp.Validate("Document Type", recGenJnlTmp."document type"::Payment);
                            recGenJnlTmp.Validate("Applies-to Doc. Type", recGenJnlTmp."applies-to doc. type"::Invoice);
                            recGenJnlTmp."Applies-to Doc. No." := recAmzPay."Sales Invoice No.";
                        end;
                        recGenJnlTmp.Validate("Document No.", DocumentNo);
                        recGenJnlTmp.Validate("Account Type", recGenJnlTmp."account type"::Customer);
                        recGenJnlTmp.Validate(Amount, -recAmzPay.Amount);
                        TotalAmountAzn += recAmzPay.Amount;
                        recGenJnlTmp.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recAmzPay."Order ID";
                        recGenJnlTmp."Account No." := recAmzCompMap."Customer No.";
                        recGenJnlTmp."External Document No." := recAmzPay."Order ID";
                        recGenJnlTmp.Insert();
                    end;

                    recAmzPay."Cash Receipt Journals Line" := true;
                    recAmzPay.Open := false;
                    recAmzPay.Modify();
                until recAmzPay.Next() = 0;
                ZGT.CloseProgressWindow;

                recGenJnlTmp.Reset();
                if recGenJnlTmp.FindSet() then begin
                    ZGT.OpenProgressWindow(StrSubstNo('2/2 %1', lText002), recGenJnlTmp.Count());

                    repeat
                        ZGT.UpdateProgressWindow(StrSubstNo('2/2 %1', lText002), 0, true);

                        SalesHeadAmount := 0;
                        SalesInvHeadFound := false;
                        SalesCrMHeadFound := false;

                        if recGenJnlTmp."Document Type" = recGenJnlTmp."document type"::Payment then begin
                            Clear(recSalesInvHead);
                            recSalesInvHead.SetCurrentkey("Your Reference");
                            recSalesInvHead.SetAutoCalcFields("Amount Including VAT");
                            recSalesInvHead.SetRange("Your Reference", recGenJnlTmp."External Document No.");
                            recSalesInvHead.SetFilter("Amount Including VAT", '<>0');
                            recSalesInvHead.SetRange("Cust. Ledg. Entry Open", true);
                            if recSalesInvHead.FindSet() then
                                repeat
                                    SalesHeadAmount += recSalesInvHead."Amount Including VAT";
                                    SalesInvHeadFound := true;
                                until recSalesInvHead.Next() = 0;

                            Difference := Abs(recGenJnlTmp.Amount) - Abs(SalesHeadAmount);
                            if (Difference > -1) and (Difference < 1) then begin
                                if recSalesInvHead.FindSet() then
                                    repeat
                                        Clear(recGenJnl);
                                        recGenJnl.Init();
                                        recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                                        recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                                        recGenJnl.Validate("Posting Date", Today);
                                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment);
                                        recGenJnl.Validate("Document No.", DocumentNo);
                                        recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                        recGenJnl.Validate("Account No.", recAmzCompMap."Customer No.");
                                        recGenJnl.Validate(Amount, -recSalesInvHead."Amount Including VAT");
                                        recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::Invoice);
                                        if recSalesInvHead.Count() > 1 then begin
                                            recGenJnl.Validate("Applies-to ID", recGenJnlTmp."External Document No.");
                                            if recSalesInvHead.FindSet() then
                                                repeat
                                                    if recCustLedgEntry.Get(recSalesInvHead."Cust. Ledger Entry No.") then
                                                        recCustLedgEntry.Validate("Applies-to ID", recGenJnlTmp."External Document No.");
                                                until recSalesInvHead.Next() = 0;
                                        end else
                                            recGenJnl.Validate("Applies-to Doc. No.", recSalesInvHead."No.");
                                        recGenJnl.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recGenJnlTmp."External Document No.";
                                        recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                        CountryDim := GetCountryDimension(recGenJnlTmp."External Document No.", recAmzCompMap."Country Dimension");
                                        if CountryDim = '' then begin
                                            recDefDim.Get(Database::Customer, recAmzCompMap."Customer No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                                            recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                                        end else
                                            recGenJnl.ValidateShortcutDimCode(3, CountryDim);
                                        recGenJnl.Insert(true);

                                        TotalAmount += recSalesInvHead."Amount Including VAT";
                                    until recSalesInvHead.Next() = 0;
                            end else begin
                                Clear(recGenJnl);

                                recGenJnl.Init();
                                recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                                recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                                recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                                recGenJnl.Validate("Posting Date", Today);
                                recGenJnl.Validate("Document Type", recGenJnlTmp."Document Type");
                                recGenJnl.Validate("Document No.", DocumentNo);
                                recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                recGenJnl.Validate("Account No.", recAmzCompMap."Customer No.");
                                recGenJnl.Validate(Amount, recGenJnlTmp.Amount);
                                recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::Invoice);  // 30-01-19 ZY-LD 004
                                recGenJnl."Applies-to Doc. No." := recSalesInvHead."No.";  // 30-01-19 ZY-LD 004
                                recGenJnl.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recGenJnlTmp."External Document No.";
                                recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                CountryDim := GetCountryDimension(recGenJnlTmp."External Document No.", recAmzCompMap."Country Dimension");
                                if CountryDim = '' then begin
                                    recDefDim.Get(Database::Customer, recAmzCompMap."Customer No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                                    recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                                end else
                                    recGenJnl.ValidateShortcutDimCode(3, CountryDim);
                                recGenJnl.Insert(true);

                                TotalAmount += -recGenJnlTmp.Amount;
                            end;
                        end else begin  // Refund
                            Clear(recSalesCrMHead);
                            recSalesCrMHead.SetCurrentkey("Your Reference");  // 17-05-18 ZY-LD 002
                            recSalesCrMHead.SetAutoCalcFields("Amount Including VAT");
                            recSalesCrMHead.SetRange("Your Reference", recGenJnlTmp."External Document No.");
                            recSalesCrMHead.SetFilter("Amount Including VAT", '<>0');  // 17-05-18 ZY-LD 002
                            recSalesCrMHead.SetRange("Cust. Ledg. Entry Open", true);
                            if recSalesCrMHead.FindSet() then
                                repeat
                                    SalesHeadAmount += recSalesInvHead."Amount Including VAT";
                                    SalesCrMHeadFound := true;
                                until recSalesCrMHead.Next() = 0;

                            Difference := Abs(recGenJnlTmp.Amount) - Abs(SalesHeadAmount);
                            if (Difference > -1) and (Difference < 1) then begin
                                if recSalesCrMHead.FindSet() then
                                    repeat
                                        Clear(recGenJnl);
                                        recGenJnl.Init();
                                        recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                                        recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                                        recGenJnl.Validate("Posting Date", Today);
                                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund);
                                        recGenJnl.Validate("Document No.", DocumentNo);
                                        recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                        recGenJnl.Validate("Account No.", recAmzCompMap."Customer No.");
                                        recGenJnl.Validate(Amount, recSalesInvHead."Amount Including VAT");
                                        recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::"Credit Memo");
                                        recGenJnl."Applies-to Doc. No." := recSalesCrMHead."No.";
                                        recGenJnl.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recGenJnlTmp."External Document No.";
                                        recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                        CountryDim := GetCountryDimension(recGenJnlTmp."External Document No.", recAmzCompMap."Country Dimension");
                                        if CountryDim = '' then begin
                                            recDefDim.Get(Database::Customer, recAmzCompMap."Customer No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                                            recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                                        end else
                                            recGenJnl.ValidateShortcutDimCode(3, CountryDim);
                                        recGenJnl.Insert(true);

                                        TotalAmount -= recSalesCrMHead."Amount Including VAT";
                                    until recSalesCrMHead.Next() = 0;
                            end else begin
                                Clear(recGenJnl);
                                recGenJnl.Init();
                                recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                                recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                                recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                                recGenJnl.Validate("Posting Date", Today);
                                recGenJnl.Validate("Document Type", recGenJnlTmp."Document Type");
                                recGenJnl.Validate("Document No.", DocumentNo);
                                recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                recGenJnl.Validate("Account No.", recAmzCompMap."Customer No.");
                                recGenJnl.Validate(Amount, recGenJnlTmp.Amount);
                                recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::"Credit Memo");  // 30-01-19 ZY-LD 004
                                recGenJnl."Applies-to Doc. No." := recSalesCrMHead."No.";  // 30-01-19 ZY-LD 004
                                recGenJnl.Description := recAmzCompMap."Cash Recipt Description" + ' ' + recGenJnlTmp."External Document No.";
                                recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                CountryDim := GetCountryDimension(recGenJnlTmp."External Document No.", recAmzCompMap."Country Dimension");
                                if CountryDim = '' then begin
                                    recDefDim.Get(Database::Customer, recAmzCompMap."Customer No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                                    recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                                end else
                                    recGenJnl.ValidateShortcutDimCode(3, CountryDim);
                                recGenJnl.Insert(true);

                                TotalAmount += -recGenJnlTmp.Amount;
                            end;
                        end;
                    until recGenJnlTmp.Next() = 0;
                    ZGT.CloseProgressWindow;
                end;

                if TotalAmount <> 0 then begin
                    if TotalAmount - TotalAmountAzn <> 0 then begin
                        recGenLedgSetup.Get();

                        Clear(recGenJnl);
                        recGenJnl.Init();
                        recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                        recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                        recGenJnl.Validate("Posting Date", Today);
                        recGenJnl.Validate("Document No.", DocumentNo);
                        recGenJnl.Validate("Account Type", recGenJnl."account type"::"G/L Account");
                        recGenJnl.Validate("Account No.", recAmzCompMap.Roundings);
                        recGenJnl.Validate(Amount, TotalAmount - TotalAmountAzn);

                        recDefDim.Get(Database::Customer, recAmzCompMap."Periodic Account No.", recGenLedgSetup."Shortcut Dimension 1 Code");
                        recGenJnl.Validate("Shortcut Dimension 1 Code", recDefDim."Dimension Value Code");
                        recGenJnl.Validate("Shortcut Dimension 2 Code", 'G&A');
                        recGenJnl.Validate("Gen. Posting Type", recGenJnl."gen. posting type"::" ");
                        recGenJnl.Validate("Gen. Bus. Posting Group", '');
                        recGenJnl.Validate("Gen. Prod. Posting Group", '');
                        recGenJnl.Validate("VAT Bus. Posting Group", '');
                        recGenJnl.Validate("VAT Prod. Posting Group", '');
                        recGenJnl.Insert(true);
                    end;

                    Clear(recGenJnl);
                    recGenJnl.Init();
                    recGenJnl.Validate("Journal Template Name", recAmzCompMap."Cach Recipt G/L Template");
                    recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Cash Recipt G/L Batch");
                    recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Cach Recipt G/L Template", recAmzCompMap."Cash Recipt G/L Batch"));
                    recGenJnl.Validate("Posting Date", Today);
                    recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund);
                    recGenJnl.Validate("Document No.", DocumentNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                    recGenJnl.Validate("Account No.", recAmzCompMap."Periodic Account No.");
                    recGenJnl.Validate(Amount, TotalAmountAzn);
                    recGenJnl.Description := CopyStr(StrSubstNo(lText003, recAmzPayHead.Period), 1, MaxStrLen(recGenJnl.Description));
                    recDefDim.Get(Database::Customer, recAmzCompMap."Periodic Account No.", recGenLedgSetup."Shortcut Dimension 3 Code");
                    recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                    recGenJnl.Insert(true);
                end;
            end;
            ZGT.CloseProgressWindow;
        end;
    end;

    local procedure GetNextJournalLineNo(pTemplate: Code[10]; pBatch: Code[10]) LineNo: Integer
    var
        recGenJournalLine: Record "Gen. Journal Line";
    begin
        LineNo := 1000;
        recGenJournalLine.SetFilter("Journal Template Name", pTemplate);
        recGenJournalLine.SetFilter("Journal Batch Name", pBatch);
        if recGenJournalLine.FindLast() then
            LineNo := recGenJournalLine."Line No." + 1000;
    end;

    local procedure GetNextNumberJournal() LineNo: Code[20]
    var
        recPurchasesPayablesSetup: Record "Purchases & Payables Setup";
        recNoSeries: Record "No. Series";
        NoSer: Code[20];
    begin
        if recAmzCompMap."Cash Recipt Number Series" <> '' then begin
            recNoSeries.SetFilter(Code, recAmzCompMap."Cash Recipt Number Series");
            if recNoSeries.FindSet() then begin
                recNoSeries."Manual Nos." := true;
                recNoSeries.Modify();
            end;
        end;
        LineNo := NoSeriesMangement.GetNextNo(recAmzCompMap."Cash Recipt Number Series", Today, true);
    end;

    local procedure GetCountryDimension(pAmzOrderId: Code[50]; pDefCountryDim: Code[20]) rValue: Code[10]
    var
        recAmzOrderHead: Record "eCommerce Order Header";
        recAmzArch: Record "eCommerce Order Archive";
        recAmzCompMap: Record "eCommerce Market Place";
        recAmzCountryMap: Record "eCommerce Country Mapping";
        lText001: Label '%1 is not created as "%2". Do you want to use "%3"?';
        lText002: Label '"%1" %2 is not created.';
        lText003: Label '"%1" is not created.';
        recAmzCountryMapTmp: Record "eCommerce Country Mapping" temporary;
    begin
        if recAmzArch.IsEmpty() then begin
            recAmzArch.ChangeCompany(ZGT.GetRHQCompanyName);
            recAmzCountryMap.ChangeCompany(ZGT.GetRHQCompanyName);
        end;

        recAmzArch.SetRange("eCommerce Order Id", pAmzOrderId);
        if recAmzArch.FindFirst() then begin
            recAmzCompMap.Get(recAmzArch."Marketplace ID");  // 10-04-19 ZY-LD 005
            if recAmzCountryMapTmp.Get(recAmzCompMap."Customer No.", recAmzArch."Ship-to Country") then  // 10-04-19 ZY-LD 005
                rValue := recAmzCountryMapTmp."Country Dimension"
            else begin
                if not recAmzCountryMap.Get(recAmzCompMap."Customer No.", recAmzArch."Ship-to Country") then begin  // 10-04-19 ZY-LD 005
                    if Confirm(lText001, false, recAmzArch."Ship-to Country", recAmzCountryMap.TableCaption(), recAmzCountryMap.FieldCaption("Default Mapping")) then begin
                        recAmzCountryMap.Reset();
                        recAmzCountryMap.SetRange("Customer No.", recAmzCompMap."Customer No.");  // 10-04-19 ZY-LD 005
                        recAmzCountryMap.SetRange("Default Mapping", true);
                        if recAmzCountryMap.FindFirst() then begin
                            Clear(recAmzCountryMapTmp);
                            recAmzCountryMapTmp."Ship-to Country Code" := recAmzArch."Ship-to Country";
                            recAmzCountryMapTmp."Country Dimension" := recAmzCountryMap."Country Dimension";
                            recAmzCountryMapTmp.Insert();
                            rValue := recAmzCountryMap."Country Dimension"
                        end else
                            Error(lText003, recAmzCountryMap.FieldCaption("Default Mapping"));
                    end else
                        Error(lText002, recAmzCountryMap.TableCaption(), recAmzArch."Ship-to Country");
                end else begin
                    recAmzCountryMapTmp := recAmzCountryMap;
                    recAmzCountryMapTmp.Insert();
                    rValue := recAmzCountryMap."Country Dimension";
                end;
            end;
        end;

        if rValue = '' then
            rValue := pDefCountryDim;
    end;

    local procedure AppliedDiff(var Rec: Record "Gen. Journal Line") AppliedDiff: Decimal
    var
        CustLedEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        ApplyCustLedEntry: Page "Apply Customer Entries";
    begin
        AppliedDiff := 0;
        if (Rec."Applies-to Doc. Type" = Rec."Applies-to Doc. Type"::" ") and
           (Rec."Applies-to Doc. No." = '') and
           (Rec."Applies-to ID" = '') then
            exit;

        if Rec."Applies-to ID" <> '' then
            ApplyCustLedEntry.SetGenJnlLine(Rec, Rec.FieldNo(Rec."Applies-to ID"))
        else
            ApplyCustLedEntry.SetGenJnlLine(Rec, Rec.FieldNo(Rec."Applies-to Doc. No."));
        CustLedEntry.SetCurrentkey("Customer No.", Open, Positive);
        CustLedEntry.SetRange("Customer No.", Rec."Account No.");
        CustLedEntry.SetRange(Open, true);
        if Rec."Applies-to ID" = '' then begin
            CustLedEntry.SetCurrentkey("Document No.", "Document Type", "Customer No.");
            CustLedEntry.SetRange("Document Type", Rec."Applies-to Doc. Type");
            CustLedEntry.SetRange("Document No.", Rec."Applies-to Doc. No.");
            if not CustLedEntry.Find('-') then
                exit;
            CustLedEntry.SetRange("Document Type");
            CustLedEntry.SetRange("Document No.");
        end;
        ApplyCustLedEntry.SetRecord(CustLedEntry);
        ApplyCustLedEntry.SetTableView(CustLedEntry);
        AppliedDiff := ApplyCustLedEntry.GetAppliedAmount + Rec.Amount;
    end;
}
