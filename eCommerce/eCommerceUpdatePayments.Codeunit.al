codeunit 50064 "eCommerce Update Payments"
{
    Permissions = TableData "Sales Invoice Header" = rimd;
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
        recAznCountryMapTmp: Record "eCommerce Country Mapping" temporary;
        RecNo: Integer;
        Window: Dialog;
        TotalRecNo: Integer;
        RowCount: Integer;
        Text001: Label 'Calculating eCommerce Payments.\';
        ZGT: Codeunit "ZyXEL General Tools";
        RHQName: Text[250];
        UKCompany: Label 'ZyND UK';
        UseRHQ: Boolean;
        Err0001: Label 'The Company does not exist in the eCommerce Setup.';
        Err0002: Label 'The Company is not Active in the eCommerce Setup.';
        Err0003: Label 'The eCommerce Setup is not complete.';
        Text002: Label 'Updating Posting Imformation.\';
        Text003: Label 'Reseting Error Imformation.\';
        Text004: Label 'Searching for Errors.\';
        Text005: Label 'Checking Sales Invoice Headers.\';
        Text006: Label 'Checking eCommerce Sales Header Buffer.\';
        Vendor: Code[20];
        PostingCompanyName: Code[20];
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
        GLTemplate: Code[20];
        GLBatch: Code[20];
        Err006: Label 'Payment Journal Template Name missing in eCommerce Setup.';
        Err007: Label 'Payment Journal Batch Name missing in eCommerce Setup.';
        Customer: Code[20];
        Err008: Label 'eCommerce Customer No. missing in eCommerce Setup.';
        PaymentDescription: Text[20];
        Err009: Label 'eCommerce Payment Description missing in eCommerce Setup.';
        PeriodicAccountNo: Code[20];
        PeriodicAccountDescription: Text[20];
        Err010: Label 'eCommerce Periodic Account No. missing in eCommerce Setup.';
        Err011: Label 'eCommerce Periodic Account Description missing in eCommerce Setup.';
        PaymentNumberSeries: Code[20];
        Err012: Label 'eCommerce Payment Number Series missing in eCommerce Setup.';
        NoSeriesMangement: Codeunit NoSeriesManagement;
        LocationCode: Code[20];

    procedure RunWithConfirm(var Rec: Record "eCommerce Payment")
    begin
        if Confirm(Text012, true) then
            Update(Rec);
    end;

    local procedure Update(var Rec: Record "eCommerce Payment") ret: Boolean
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
            if CompanyName() = UKCompany then
                UseRHQ := true;

            //ResetErrors;
            //FixExternalDocumentNo;
            if UpdatePostingInformation then begin
                receCommercePayments.SetCurrentkey("Journal Batch No.");  // 12-06-20 ZY-LD 006
                receCommercePayments.SetRange("Journal Batch No.", Rec."Journal Batch No.");  // 12-06-20 ZY-LD 006
                                                                                              //receCommercePayments.SETFILTER("Order ID",'<>%1', '');  // 12-06-20 ZY-LD 006
                receCommercePayments.SetRange(Open, true);
                ZGT.OpenProgressWindow('', receCommercePayments.Count());
                if receCommercePayments.FindSet() then begin
                    RowCount := receCommercePayments.Count();
                    RecNo := 0;
                    repeat
                        ZGT.UpdateProgressWindow(receCommercePayments."Order ID", 0, true);

                        RecNo := RecNo + 1;
                        RHQNo := '';
                        InvNo := '';
                        CrNo := '';
                        eCommerceInvoice := '';
                        PurchNo := '';
                        MarketPlace := '';
                        CountryCode := '';
                        //>> 30-01-19 ZY-LD 004
                        /*
                        CountryCode := GeteCommerceCountryCode(receCommercePayments."Order ID");
                        receCommercePayments."Ship To Country" := CountryCode;
                        receCommercePayments.MODIFY;
                        eCommerceInvoice := GeteCommerceInvoiceNo(receCommercePayments."Order ID");
                        receCommercePayments."eCommerce Invoice No." := eCommerceInvoice;
                        receCommercePayments.MODIFY;
                        MarketPlace := GeteCommerceMarketPlace(receCommercePayments."Order ID");
                        receCommercePayments."eCommerce Market Place" := MarketPlace;
                        receCommercePayments.MODIFY;
                        */
                        //<< 30-01-19 ZY-LD 004
                        if ZGT.IsZComCompany and ZGT.CompanyNameIs(2) then begin  //xx
                            RHQNo := GetRHQSalesOrderNo(receCommercePayments."Order ID", eCommerceInvoice);

                            if RHQNo <> '' then begin
                                if CompanyName() = UKCompany then begin
                                    recCustomerLedgerEntries.Reset();
                                    recCustomerLedgerEntries.SetFilter("External Document No.", RHQNo);
                                    recCustomerLedgerEntries.SetRange("Document Type", recCustomerLedgerEntries."document type"::Invoice);
                                    if recCustomerLedgerEntries.FindLast() then
                                        InvNo := recCustomerLedgerEntries."Document No.";
                                end else
                                    InvNo := RHQNo;

                                if CompanyName() = UKCompany then begin
                                    recCustomerLedgerEntries.Reset();
                                    recCustomerLedgerEntries.SetFilter("External Document No.", RHQNo);
                                    recCustomerLedgerEntries.SetRange("Document Type", recCustomerLedgerEntries."document type"::"Credit Memo");
                                    if recCustomerLedgerEntries.FindLast() then
                                        CrNo := recCustomerLedgerEntries."Document No.";
                                end else
                                    CrNo := RHQNo;

                                if CompanyName() = UKCompany then begin
                                    recPurchInvHeader.SetFilter("Vendor Invoice No.", RHQNo);
                                    if recPurchInvHeader.FindFirst() then
                                        PurchNo := recPurchInvHeader."No.";
                                end;

                                receCommercePayments."Purchase Invoice No." := PurchNo;
                                receCommercePayments."Source Invoice No." := RHQNo;
                                receCommercePayments."Sales Invoice No." := InvNo;
                                //receCommercePayments."Sales Credit No." := CrNo;
                                receCommercePayments."eCommerce Invoice No." := eCommerceInvoice;
                                receCommercePayments."Error x" := false;
                                receCommercePayments.Exception := false;
                                receCommercePayments.Modify();
                            end;

                            if RHQNo = '' then begin
                                receCommercePayments.Exception := true;
                                receCommercePayments.Modify();
                            end;
                        end;

                    /*IF ZGT.IsZNetCompany THEN BEGIN
                      recCustomerLedgerEntries.SetCurrentKey("External Document No.");
                      recCustomerLedgerEntries.SETRANGE("External Document No.",receCommercePayments."Order ID");
                      IF receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::Refund THEN
                        recCustomerLedgerEntries.SETRANGE("Document Type",recCustomerLedgerEntries."Document Type"::Reminder)
                      ELSE
                        recCustomerLedgerEntries.SETRANGE("Document Type",recCustomerLedgerEntries."Document Type"::Invoice);
                      IF recCustomerLedgerEntries.FINDLAST THEN BEGIN
                        IF receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::Refund THEN
                          CrNo := recCustomerLedgerEntries."Document No."
                        ELSE
                          InvNo := recCustomerLedgerEntries."Document No.";
                      END ELSE BEGIN
                        recCustLedgEntryDE.CHANGECOMPANY(ZGT.GetSistersCompanyName(11));
                        recCustLedgEntryDE.SetCurrentKey("External Document No.");
                        recCustLedgEntryDE.SETRANGE("External Document No.",receCommercePayments."Order ID");
                        IF receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::Refund THEN
                          recCustLedgEntryDE.SETRANGE("Document Type",recCustLedgEntryDE."Document Type"::Reminder)
                        ELSE
                          recCustLedgEntryDE.SETRANGE("Document Type",recCustLedgEntryDE."Document Type"::Invoice);
                        IF recCustLedgEntryDE.FINDLAST THEN
                          IF receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::Refund THEN
                            CrNo := 'ZyND DE'
                          ELSE
                            InvNo := 'ZyND DE';
                      END;

                      receCommercePayments."Sales Invoice No." := InvNo;
                      receCommercePayments."Sales Credit No." := CrNo;
                      receCommercePayments.MODIFY;
                    END;*/

                    until receCommercePayments.Next() = 0;
                    ZGT.CloseProgressWindow;
                end;
                //FindErrors;
                //UpdateTransactionDetails;
                CreatePurchaseInvoice(Rec);
                CreateSalesInvoice(Rec);
                //ApplyVendorEntries;
                CashReceiptJournal(Rec);
                //PaymentJournal;
                Message(Text008);
                ret := true;
            end else
                Message(Text011);
        end;
    end;

    local procedure GetRHQSalesOrderNo(eCommerceOrderNo: Text[250]; eCommerceInvoiceID: Text[250]) SalesOrderNo: Code[10]
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesInvoiceLine: Record "Sales Invoice Line";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if UseRHQ then begin
            recSalesInvoiceHeader.ChangeCompany(RHQName);
            recSalesCrMemoHeader.ChangeCompany(RHQName);  // 21-11-18 ZY-LD 003
        end;

        if eCommerceOrderNo <> '' then begin
            recSalesInvoiceHeader.SetFilter("External Document No.", eCommerceOrderNo);
            if recSalesInvoiceHeader.FindLast() then
                SalesOrderNo := recSalesInvoiceHeader."No.";
        end;

        if (SalesOrderNo = '') then begin
            recSalesCrMemoHeader.SetRange("External Document No.", eCommerceOrderNo);
            if recSalesCrMemoHeader.FindLast() then
                SalesOrderNo := recSalesCrMemoHeader."No.";
        end;

        if (SalesOrderNo = '') and (eCommerceInvoiceID <> '') then begin
            if UseRHQ then
                recSalesInvoiceLine.ChangeCompany(RHQName);
            recSalesInvoiceLine.SetFilter("External Document No.", eCommerceInvoiceID);
            if recSalesInvoiceLine.FindFirst() then
                SalesOrderNo := recSalesInvoiceLine."Document No.";
        end;

        if UseRHQ then
            receCommerceSalesHeaderBuffer.ChangeCompany(RHQName);
        receCommerceSalesHeaderBuffer.SetFilter("eCommerce Order Id", eCommerceOrderNo);
        if receCommerceSalesHeaderBuffer.FindFirst() then begin
            receCommerceSalesHeaderBuffer."RHQ Invoice No" := SalesOrderNo;
            receCommerceSalesHeaderBuffer.Modify();
        end;
    end;

    procedure GeteCommerceInvoiceNo(pTransactionType: Option ,Payment,Refund; pDocumentNo: Code[20]) rValue: Text[250]
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        lSalesInvHead: Record "Sales Invoice Header";
        lSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recCustLedgEntryDE: Record "Cust. Ledger Entry";
    begin
        // In the beginning of the period of eCommerce there can be two invoices with the same orderno, and we want the last invoice no.
        case pTransactionType of
            Ptransactiontype::Payment:
                begin
                    lSalesInvHead.SetCurrentkey("Your Reference");
                    lSalesInvHead.SetRange("Your Reference", pDocumentNo);
                    if lSalesInvHead.FindLast() then
                        rValue := lSalesInvHead."No."
                    else begin
                        recCustLedgEntryDE.ChangeCompany(ZGT.GetSistersCompanyName(11));
                        recCustLedgEntryDE.SetCurrentkey("External Document No.");
                        recCustLedgEntryDE.SetRange("External Document No.", pDocumentNo);
                        recCustLedgEntryDE.SetRange("Document Type", recCustLedgEntryDE."document type"::Invoice);
                        if recCustLedgEntryDE.FindLast() then
                            rValue := 'ZyND DE';
                    end;
                end;
            Ptransactiontype::Refund:
                begin
                    lSalesCrMemoHead.SetCurrentkey("Your Reference");
                    lSalesCrMemoHead.SetRange("Your Reference", pDocumentNo);
                    if lSalesCrMemoHead.FindLast() then
                        rValue := lSalesCrMemoHead."No."
                    else begin
                        recCustLedgEntryDE.ChangeCompany(ZGT.GetSistersCompanyName(11));
                        recCustLedgEntryDE.SetCurrentkey("External Document No.");
                        recCustLedgEntryDE.SetRange("External Document No.", pDocumentNo);
                        recCustLedgEntryDE.SetRange("Document Type", recCustLedgEntryDE."document type"::"Credit Memo");
                        if recCustLedgEntryDE.FindLast() then
                            rValue := 'ZyND DE';
                    end;
                end;
            else begin
                if UseRHQ then
                    receCommerceSalesHeaderBuffer.ChangeCompany(RHQName);
                receCommerceSalesHeaderBuffer.SetRange("Transaction Type", pTransactionType - 1);
                receCommerceSalesHeaderBuffer.SetFilter("eCommerce Order Id", pDocumentNo);
                if receCommerceSalesHeaderBuffer.FindSet() then
                    rValue := receCommerceSalesHeaderBuffer."Invoice No.";
            end;
        end;
    end;

    procedure GeteCommerceInvoiceNo_New(pTransactionType: Option ,Payment,Refund; pDocumentNo: Code[20]; pPaymentAmount: Decimal) rValue: Text[250]
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        lSalesInvHead: Record "Sales Invoice Header";
        lSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recCustLedgEntry: Record "Cust. Ledger Entry";
        recCustLedgEntryDE: Record "Cust. Ledger Entry";
    begin
        // In the beginning of the period of eCommerce there can be two invoices with the same orderno, and we want the last invoice no.
        case pTransactionType of
            Ptransactiontype::Payment:
                begin
                    recCustLedgEntry.SetCurrentkey("External Document No.");
                    recCustLedgEntry.SetRange("External Document No.", pDocumentNo);
                    if pTransactionType = Ptransactiontype::Payment then
                        recCustLedgEntry.SetRange("Document Type", recCustLedgEntryDE."document type"::Invoice)
                    else
                        recCustLedgEntry.SetRange("Document Type", recCustLedgEntryDE."document type"::"Credit Memo");
                    if recCustLedgEntry.FindFirst() then begin
                        if recCustLedgEntry.Count = 1 then
                            rValue := recCustLedgEntry."Document No."
                        else begin
                            recCustLedgEntry.SetRange("Amount (LCY)", pPaymentAmount);
                            if recCustLedgEntry.FindFirst() then
                                rValue := recCustLedgEntry."Document No.";
                        end;
                    end;


                    lSalesInvHead.SetCurrentkey("Your Reference");
                    lSalesInvHead.SetRange("Your Reference", pDocumentNo);
                    if lSalesInvHead.FindLast() then
                        rValue := lSalesInvHead."No."
                    else begin
                        recCustLedgEntryDE.ChangeCompany(ZGT.GetSistersCompanyName(11));
                        recCustLedgEntryDE.SetCurrentkey("External Document No.");
                        recCustLedgEntryDE.SetRange("External Document No.", pDocumentNo);
                        recCustLedgEntryDE.SetRange("Document Type", recCustLedgEntryDE."document type"::Invoice);
                        if recCustLedgEntryDE.FindLast() then
                            rValue := 'ZyND DE';
                    end;
                end;
            Ptransactiontype::Refund:
                begin
                    lSalesCrMemoHead.SetCurrentkey("Your Reference");
                    lSalesCrMemoHead.SetRange("Your Reference", pDocumentNo);
                    if lSalesCrMemoHead.FindLast() then
                        rValue := lSalesCrMemoHead."No."
                    else begin
                        recCustLedgEntryDE.ChangeCompany(ZGT.GetSistersCompanyName(11));
                        recCustLedgEntryDE.SetCurrentkey("External Document No.");
                        recCustLedgEntryDE.SetRange("External Document No.", pDocumentNo);
                        recCustLedgEntryDE.SetRange("Document Type", recCustLedgEntryDE."document type"::"Credit Memo");
                        if recCustLedgEntryDE.FindLast() then
                            rValue := 'ZyND DE';
                    end;
                end;
            else begin
                if UseRHQ then
                    receCommerceSalesHeaderBuffer.ChangeCompany(RHQName);
                receCommerceSalesHeaderBuffer.SetRange("Transaction Type", pTransactionType - 1);
                receCommerceSalesHeaderBuffer.SetFilter("eCommerce Order Id", pDocumentNo);
                if receCommerceSalesHeaderBuffer.FindSet() then
                    rValue := receCommerceSalesHeaderBuffer."Invoice No.";
            end;
        end;
    end;

    local procedure GeteCommerceMarketPlace(OrderNo: Text[250]) MarketPlace: Text[250]
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
    begin
        if UseRHQ then receCommerceSalesHeaderBuffer.ChangeCompany(RHQName);
        receCommerceSalesHeaderBuffer.SetFilter("eCommerce Order Id", OrderNo);
        if receCommerceSalesHeaderBuffer.FindSet() then MarketPlace := receCommerceSalesHeaderBuffer."Marketplace ID"
    end;

    local procedure GeteCommerceCountryCode(OrderNo: Text[250]) CountryCode: Text[250]
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
    begin
        if UseRHQ then receCommerceSalesHeaderBuffer.ChangeCompany(RHQName);
        receCommerceSalesHeaderBuffer.SetFilter("eCommerce Order Id", OrderNo);
        if receCommerceSalesHeaderBuffer.FindSet() then CountryCode := receCommerceSalesHeaderBuffer."Ship To Country";
    end;

    local procedure FixExternalDocumentNo()
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if UseRHQ then recSalesInvoiceHeader.ChangeCompany(RHQName);
        if UseRHQ then receCommerceSalesHeaderBuffer.ChangeCompany(RHQName);

        Window.Open(Text005 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        recSalesInvoiceHeader.SetFilter("External Document No.", 'INV-GB*');
        if recSalesInvoiceHeader.FindSet() then begin
            RowCount := recSalesInvoiceHeader.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                receCommerceSalesHeaderBuffer.SetFilter("Invoice No.", recSalesInvoiceHeader."External Document No.");
                if receCommerceSalesHeaderBuffer.FindSet() then begin
                    recSalesInvoiceHeader."External Document No." := receCommerceSalesHeaderBuffer."eCommerce Order Id";
                    recSalesInvoiceHeader.Modify();
                end;
            until recSalesInvoiceHeader.Next() = 0;
        end;
        Window.Close();

        Window.Open(Text005 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        recSalesInvoiceHeader.SetFilter("External Document No.", 'INV-DE*');
        if recSalesInvoiceHeader.FindSet() then begin
            RowCount := recSalesInvoiceHeader.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                receCommerceSalesHeaderBuffer.SetFilter("Invoice No.", recSalesInvoiceHeader."External Document No.");
                if receCommerceSalesHeaderBuffer.FindSet() then begin
                    recSalesInvoiceHeader."External Document No." := receCommerceSalesHeaderBuffer."eCommerce Order Id";
                    recSalesInvoiceHeader.Modify();
                end;
            until recSalesInvoiceHeader.Next() = 0;
        end;
        Window.Close();

        Window.Open(Text005 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        recSalesInvoiceHeader.SetFilter("External Document No.", 'CN-GB*');
        if recSalesInvoiceHeader.FindSet() then begin
            RowCount := recSalesInvoiceHeader.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                receCommerceSalesHeaderBuffer.SetFilter("Invoice No.", recSalesInvoiceHeader."External Document No.");
                if receCommerceSalesHeaderBuffer.FindSet() then begin
                    recSalesInvoiceHeader."External Document No." := receCommerceSalesHeaderBuffer."eCommerce Order Id";
                    recSalesInvoiceHeader.Modify();
                end;
            until recSalesInvoiceHeader.Next() = 0;
        end;
        Window.Close();

        Window.Open(Text005 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        recSalesInvoiceHeader.SetFilter("External Document No.", 'CN-DE*');
        if recSalesInvoiceHeader.FindSet() then begin
            RowCount := recSalesInvoiceHeader.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                receCommerceSalesHeaderBuffer.SetFilter("Invoice No.", recSalesInvoiceHeader."External Document No.");
                if receCommerceSalesHeaderBuffer.FindSet() then begin
                    recSalesInvoiceHeader."External Document No." := receCommerceSalesHeaderBuffer."eCommerce Order Id";
                    recSalesInvoiceHeader.Modify();
                end;
            until recSalesInvoiceHeader.Next() = 0;
        end;
        Window.Close();

        Window.Open(Text006 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        receCommerceSalesHeaderBuffer.SetFilter("RHQ Invoice No", '<>%1', '');
        if receCommerceSalesHeaderBuffer.FindSet() then begin
            RowCount := receCommerceSalesHeaderBuffer.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                recSalesInvoiceHeader.SetFilter("External Document No.", receCommerceSalesHeaderBuffer."eCommerce Order Id");
                if recSalesInvoiceHeader.FindSet() then begin
                    receCommerceSalesHeaderBuffer."RHQ Invoice No" := recSalesInvoiceHeader."No.";
                    receCommerceSalesHeaderBuffer.Modify();
                end;
            until receCommerceSalesHeaderBuffer.Next() = 0;
        end;
        Window.Close();
    end;

    local procedure GetPostingInformation(pJnlBatchNo: Code[20])
    begin
        /*recAmzCompMap.SETFILTER("Posting Company",CompanyName());
        recAmzCompMap.FINDFIRST;*/
        recAmzPayHead.Get(pJnlBatchNo);
        recAmzCompMap.Get(recAmzPayHead."Market Place ID");
        recAmzCompMap.TestField(Active);

        recAmzCompMap.TestField("Fee Account No.");
        recAmzCompMap.TestField("Charge Account No.");
        recAmzCompMap.TestField("Currency Code");
        Vendor := recAmzCompMap."Vendor No.";
        PostingCompanyName := recAmzCompMap."Posting Company";
        GLTemplate := recAmzCompMap."Cach Recipt G/L Template";
        GLBatch := recAmzCompMap."Cash Recipt G/L Batch";
        Customer := recAmzCompMap."Customer No.";
        PaymentDescription := recAmzCompMap."Cash Recipt Description";
        PeriodicAccountNo := recAmzCompMap."Periodic Account No.";
        PeriodicAccountDescription := recAmzCompMap."Periodic Posting Description";
        PaymentNumberSeries := recAmzCompMap."Cash Recipt Number Series";
        LocationCode := recAmzCompMap."Location Code";

        if PaymentNumberSeries = '' then
            Error(Err012);
        if PeriodicAccountNo = '' then
            Error(Err010);
        if PeriodicAccountDescription = '' then
            Error(Err011);
        if PaymentDescription = '' then
            Error(Err009);
        if Customer = '' then
            Error(Err008);
        if GLTemplate = '' then
            Error(Err006);
        if GLBatch = '' then
            Error(Err007);
        if Vendor = '' then
            Error(Err0003);
        //IF PostingCompanyName = '' THEN
        //  ERROR(Err0003);
    end;

    local procedure UpdatePostingInformation(): Boolean
    var
        receCommercePayments: Record "eCommerce Payment";
        PostingDescription: Text[250];
        RecNo: Integer;
        RowCount: Integer;
        receCommercePaymentsMatrix: Record "eCommerce Payment Matrix";
        PaymentMatrixCreated: Boolean;
    begin
        Window.Open(Text002 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        receCommercePayments.SetRange(Open, true);
        if receCommercePayments.FindSet() then begin
            RowCount := receCommercePayments.Count();
            RecNo := 0;
            repeat
                PostingDescription := '';
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                receCommercePayments."Posting Currency Code" := recAmzCompMap."Currency Code";
                receCommercePaymentsMatrix.SetRange("Payment Detail", receCommercePayments."Payment Detail");
                receCommercePaymentsMatrix.SetRange("Payment Type", receCommercePayments."Payment Type");
                if receCommercePaymentsMatrix.FindFirst() and (receCommercePaymentsMatrix."Posting Type" <> receCommercePaymentsMatrix."posting type"::" ") then begin
                    receCommercePayments."Posting Type" := receCommercePaymentsMatrix."Posting Type";
                    receCommercePayments.Modify();
                end else begin
                    //>> LD
                    //receCommercePayments."Posting Type" := receCommercePayments."Posting Type"::Other;
                    receCommercePaymentsMatrix."Payment Detail" := receCommercePayments."Payment Detail";
                    receCommercePaymentsMatrix."Payment Type" := receCommercePayments."Payment Type";
                    receCommercePayments."Posting Type" := receCommercePayments."posting type"::" ";
                    if not receCommercePaymentsMatrix.Insert() then;
                    PaymentMatrixCreated := true;
                    //<< LD
                end;
            until receCommercePayments.Next() = 0;
        end;
        Window.Close();
        exit(not PaymentMatrixCreated);  // LD
    end;

    local procedure ResetErrors()
    var
        receCommercePayments: Record "eCommerce Payment";
        RecNo: Integer;
        RowCount: Integer;
    begin
        receCommercePayments.SetFilter("Order ID", '<>%1', '');
        receCommercePayments.SetRange(Open, false);
        Window.Open(Text003 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        if receCommercePayments.FindSet() then begin
            RowCount := receCommercePayments.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                receCommercePayments."Error x" := false;
                receCommercePayments.Modify();
            until receCommercePayments.Next() = 0;
        end;
        Window.Close();
    end;

    local procedure FindErrors()
    var
        receCommercePayments: Record "eCommerce Payment";
        RecNo: Integer;
        RowCount: Integer;
    begin
        receCommercePayments.SetFilter("Source Invoice No.", '%1', '');
        receCommercePayments.SetRange(Open, false);
        Window.Open(Text004 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        if receCommercePayments.FindSet() then begin
            RowCount := receCommercePayments.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                if receCommercePayments."Transaction Type" = receCommercePayments."transaction type"::Order then begin
                    receCommercePayments."Error x" := true;
                    receCommercePayments.Modify();
                end;
                if receCommercePayments."Transaction Type" = receCommercePayments."transaction type"::Refund then begin
                    receCommercePayments."Error x" := true;
                    receCommercePayments.Modify();
                end;
            until receCommercePayments.Next() = 0;
        end;
        Window.Close();
    end;

    local procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]) NewString: Text[250]
    begin
        while StrPos(String, FindWhat) > 0 do
            String := DelStr(String, StrPos(String, FindWhat)) + ReplaceWith + CopyStr(String, StrPos(String, FindWhat) + StrLen(FindWhat));
        NewString := String;
    end;

    local procedure UpdateTransactionDetails()
    var
        receCommerceTransactionSummary: Record "eCommerce Transaction Summary";
        receCommercePayments: Record "eCommerce Payment";
    begin
        // Window.OPEN(Text009 +  '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        // Window.UPDATE(1,0);
        // receCommercePayments.SETFILTER("Fee Purchase Invoice No.",'%1', '');
        // IF receCommercePayments.FINDSET THEN BEGIN
        //  RowCount := receCommercePayments.COUNT;
        //  RecNo := 0;
        //  REPEAT
        //    RecNo := RecNo + 1;
        //    Window.UPDATE(1,ROUND(RecNo / RowCount * 10000,1));
        //    receCommerceTransactionSummary.SETFILTER("Transaction Summary",receCommercePayments."Transaction Summary");
        //    IF NOT receCommerceTransactionSummary.FINDFIRST THEN BEGIN
        //      receCommerceTransactionSummary.INIT;
        //      receCommerceTransactionSummary."Transaction Summary" := receCommercePayments."Transaction Summary";
        //      receCommerceTransactionSummary.INSERT;
        //    END;
        //  UNTIL receCommercePayments.Next() = 0;
        // END;
        // Window.CLOSE;
    end;

    local procedure CreatePurchaseInvoice(Rec: Record "eCommerce Payment")
    var
        recAmzPay: Record "eCommerce Payment";
        receCommercePaymentsMatrix: Record "eCommerce Payment Matrix";
        recGenJnl: Record "Gen. Journal Line";
        RecNo: Integer;
        RowCount: Integer;
        Amount: Decimal;
        recPurchHead: Record "Purchase Header";
        PurchaseNo: Code[20];
        recPurchLine: Record "Purchase Line";
        LineNo: Integer;
        TotalAmount: Decimal;
        DocNo: Code[20];
        DocType: Option "0","1",Invoice,"Credit Memo";
        CountryDim: Code[10];
    begin
        begin
            Window.Open(Text010 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
            Window.Update(1, 0);

            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange(Open, true);
            recAmzPay.SetFilter("Posting Type", '%1|%2', recAmzPay."posting type"::Charge, recAmzPay."posting type"::Fee);
            recAmzPay.SetFilter(Amount, '<>0');
            if recAmzPay.FindSet() then
                repeat
                    TotalAmount := TotalAmount + recAmzPay.Amount;
                until recAmzPay.Next() = 0;

            if TotalAmount < 0 then
                DocType := Doctype::Invoice
            else
                DocType := Doctype::"Credit Memo";

            if recAmzPay.FindSet(true) then begin
                recPurchHead.Init();
                recPurchHead.SetHideValidationDialog(true);
                recPurchHead.Validate("Document Type", DocType);
                recPurchHead.Insert(true);
                recPurchHead.Validate("Buy-from Vendor No.", Vendor);
                recPurchHead.Validate("Posting Date", Today);
                recPurchHead.Validate("Document Date", Today);
                recPurchHead.Validate("Due Date", Today);
                recPurchHead."Posting Description" := 'eCommerce Fee: ' + CopyStr(Rec."Transaction Summary", 25, StrLen(Rec."Transaction Summary"));
                recPurchHead."Vendor Invoice No." := 'eCommerce: ' + recPurchHead."No.";
                recPurchHead."eCommerce Order" := true;
                recPurchHead.Modify(true);

                Rec.Amount := 0;
                TotalAmount := 0;
                LineNo := 10000;
                RowCount := recAmzPay.Count();
                RecNo := 0;

                repeat
                    RecNo := RecNo + 1;
                    Window.Update(1, Round(RecNo / RowCount * 10000, 1));

                    Clear(recPurchLine);
                    recPurchLine.Init();
                    recPurchLine.Validate("Document Type", recPurchHead."Document Type");
                    recPurchLine.Validate("Document No.", recPurchHead."No.");
                    recPurchLine.Validate("Line No.", LineNo);
                    recPurchLine.Validate(Type, recPurchLine.Type::"G/L Account");
                    case recAmzPay."Posting Type" of
                        recAmzPay."posting type"::Fee:
                            recPurchLine.Validate("No.", recAmzCompMap."Fee Account No.");
                        recAmzPay."posting type"::Charge:
                            recPurchLine.Validate("No.", recAmzCompMap."Charge Account No.");
                    end;
                    recPurchLine.Description := Format(recAmzPay."Payment Type");
                    recPurchLine."Description 2" := Format(recPurchLine."Description 2");
                    recPurchLine."Unit of Measure Code" := 'PCS';
                    recPurchLine."Currency Code" := recAmzCompMap."Currency Code";
                    recPurchLine."Vendor Invoice No" := recAmzPay."Order ID";
                    recPurchLine.Validate(Quantity, 1);

                    if DocType = Doctype::Invoice then
                        recPurchLine.Validate("Direct Unit Cost", -recAmzPay.Amount)
                    else
                        recPurchLine.Validate("Direct Unit Cost", recAmzPay.Amount);
                    TotalAmount := TotalAmount + recPurchLine."Direct Unit Cost";
                    recPurchLine."Location Code" := '';
                    recPurchLine.Insert();

                    CountryDim := GetCountryDimension(recAmzPay."Order ID");
                    if CountryDim <> '' then begin
                        recPurchLine.ValidateShortcutDimCode(3, CountryDim);
                        recPurchLine.Modify();
                    end;

                    recAmzPay."Fee Purchase Invoice No." := PurchaseNo;
                    recAmzPay.Open := false;
                    recAmzPay.Modify();

                    LineNo := LineNo + 10000;
                until recAmzPay.Next() = 0;
            end;

            // Create a payment journal
            if TotalAmount <> 0 then begin
                DocNo := NoSeriesMangement.GetNextNo(recAmzCompMap."Payment Number Series", Today, true);
                recGenJnl.Validate("Journal Template Name", recAmzCompMap."Payment G/L Template");
                recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Payment G/L Batch");
                recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Payment G/L Template", recAmzCompMap."Payment G/L Batch"));
                recGenJnl.Validate("Posting Date", Today);
                recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment);
                recGenJnl.Validate("Document No.", DocNo);
                recGenJnl.Validate("Account Type", recGenJnl."account type"::Vendor);
                recGenJnl.Validate("Account No.", Vendor);
                recGenJnl.Validate(Amount, TotalAmount);
                recGenJnl.Validate("Applies-to Doc. Type", recPurchHead."Document Type");
                recGenJnl.Validate("Applies-to Doc. No.", recPurchHead."No.");
                recGenJnl.Insert();

                Clear(recGenJnl);
                recGenJnl.Validate("Journal Template Name", recAmzCompMap."Payment G/L Template");
                recGenJnl.Validate("Journal Batch Name", recAmzCompMap."Payment G/L Batch");
                recGenJnl.Validate("Line No.", GetNextJournalLineNo(recAmzCompMap."Payment G/L Template", recAmzCompMap."Payment G/L Batch"));
                recGenJnl.Validate("Posting Date", Today);
                recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment);
                recGenJnl.Validate("Document No.", DocNo);
                recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                recGenJnl.Validate("Account No.", recAmzCompMap."Periodic Account No.");
                recGenJnl.Validate(Amount, -TotalAmount);
                recGenJnl.Description :=
                  CopyStr(
                    Format(recGenJnl."account type"::Vendor) + ': ' +
                    CopyStr(Rec."Transaction Summary", 25, StrLen(Rec."Transaction Summary")), 1, MaxStrLen(recGenJnl.Description));
                recGenJnl.Insert();
            end;

            Window.Close();
        end;
    end;

    local procedure OLD_CreatePurchaseInvoice(Rec: Record "eCommerce Payment")
    var
        receCommercePayments: Record "eCommerce Payment";
        receCommercePaymentsMatrix: Record "eCommerce Payment Matrix";
        recGenJnl: Record "Gen. Journal Line";
        RecNo: Integer;
        RowCount: Integer;
        receCommerceTransactionSummary: Record "eCommerce Transaction Summary";
        Amount: Decimal;
        recPurchaseHeader: Record "Purchase Header";
        PurchaseNo: Code[20];
        recPurchaseLine: Record "Purchase Line";
        LineNo: Integer;
        TotalAmount: Decimal;
        DocNo: Code[20];
        DocType: Option "0","1",Invoice,"Credit Memo";
        CountryDim: Code[10];
    begin
        // Window.OPEN(Text010 +  '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        // Window.UPDATE(1,0);
        // //receCommerceTransactionSummary.SETFILTER("Fee Purchase Invoice No.",'%1', '');
        // receCommerceTransactionSummary.SETRANGE(Open,TRUE);
        // IF receCommerceTransactionSummary.FINDSET(TRUE) THEN BEGIN
        //  REPEAT
        //    receCommercePayments.SETRANGE(Open,TRUE);
        //    receCommercePayments.SETFILTER("Transaction Summary",receCommerceTransactionSummary."Transaction Summary");
        //    receCommercePayments.SETFILTER("Posting Type",'%1|%2',receCommercePayments."Posting Type"::Charge,receCommercePayments."Posting Type"::Fee);
        //    IF receCommercePayments.FINDSET THEN REPEAT
        //      TotalAmount := TotalAmount + receCommercePayments.Amount;
        //    UNTIL receCommercePayments.Next() = 0;
        //    IF TotalAmount < 0 THEN
        //      DocType := DocType::Invoice
        //    ELSE
        //      DocType := DocType::"Credit Memo";
        //
        //    IF receCommercePayments.FINDSET(TRUE) THEN BEGIN
        //      //PurchaseNo := GetNextNumber;
        //      recPurchaseHeader.INIT;
        //      recPurchaseHeader.SetHideValidationDialog(TRUE);
        //      recPurchaseHeader.VALIDATE("Document Type",DocType);
        //      recPurchaseHeader.INSERT(TRUE);
        //      //recPurchaseHeader.VALIDATE("No.",PurchaseNo);
        //      recPurchaseHeader.VALIDATE("Buy-from Vendor No.",Vendor);
        //      recPurchaseHeader.VALIDATE("Posting Date",TODAY);
        //      recPurchaseHeader.VALIDATE("Document Date",TODAY);
        //      recPurchaseHeader.VALIDATE("Due Date",TODAY);
        //      recPurchaseHeader."Posting Description" := 'eCommerce Fee: ' + COPYSTR(receCommerceTransactionSummary."Transaction Summary",25,STRLEN(receCommerceTransactionSummary."Transaction Summary"));
        //      recPurchaseHeader."Vendor Invoice No." := 'eCommerce: ' + recPurchaseHeader."No.";
        //      recPurchaseHeader."eCommerce Order" := TRUE;
        //      recPurchaseHeader.MODIFY(TRUE);
        //
        //      Amount := 0;
        //      TotalAmount := 0;
        //      LineNo := 10000;
        //      RowCount := receCommercePayments.COUNT;
        //      RecNo := 0;
        //
        //      REPEAT
        //        RecNo := RecNo + 1;
        //        Window.UPDATE(1,ROUND(RecNo / RowCount * 10000,1));
        //        IF receCommercePayments.Amount <> 0 THEN BEGIN
        //          CLEAR(recPurchaseLine);
        //          recPurchaseLine.INIT;
        //          recPurchaseLine.VALIDATE("Document Type",recPurchaseHeader."Document Type");
        //          recPurchaseLine.VALIDATE("Document No.",recPurchaseHeader."No.");
        //          recPurchaseLine.VALIDATE("Line No.",LineNo);
        //          recPurchaseLine.VALIDATE(Type,recPurchaseLine.Type::"G/L Account");
        //          //recPurchaseLine."VAT Bus. Posting Group" := 'DOMESTIC';
        //          CASE receCommercePayments."Posting Type" OF
        //            receCommercePayments."Posting Type"::Fee : recPurchaseLine.VALIDATE("No." , FeeAccountNo);
        //            receCommercePayments."Posting Type"::Charge : recPurchaseLine.VALIDATE("No." , ChargeAccountNo);
        //          END;
        //          recPurchaseLine.Description := FORMAT(receCommercePayments."Payment Type");
        //          recPurchaseLine."Description 2" := FORMAT(recPurchaseLine."Description 2");
        //          recPurchaseLine."Unit of Measure Code" := 'PCS';
        //          recPurchaseLine."Currency Code" := CurrencyCode;
        //          recPurchaseLine."Vendor Invoice No" := receCommercePayments."Order ID";
        //          recPurchaseLine.VALIDATE(Quantity,1);
        //
        //          IF DocType = DocType::Invoice THEN
        //            recPurchaseLine.VALIDATE("Direct Unit Cost",-receCommercePayments.Amount)
        //          ELSE
        //            recPurchaseLine.VALIDATE("Direct Unit Cost",receCommercePayments.Amount);
        //            //Amount := -receCommercePayments.Amount;  // LD - is added.
        //          TotalAmount := TotalAmount + recPurchaseLine."Direct Unit Cost";
        //          //recPurchaseLine.VALIDATE("Direct Unit Cost", Amount);
        //          recPurchaseLine."Location Code" := '';
        //          recPurchaseLine.INSERT;
        //
        //          //>> 13-02-18 ZY-LD 001
        //          CountryDim := GetCountryDimension(receCommercePayments."Order ID");
        //          IF CountryDim <> '' THEN BEGIN
        //            recPurchaseLine.ValidateShortcutDimCode(3,CountryDim);
        //            recPurchaseLine.MODIFY;
        //          END;
        //          //<< 13-02-18 ZY-LD 001
        //
        //          receCommercePayments."Fee Purchase Invoice No." := PurchaseNo;
        //          receCommercePayments.MODIFY;
        //          LineNo := LineNo + 10000;
        //        END;
        //
        //        receCommercePayments.Open := FALSE;
        //        receCommercePayments.MODIFY;
        //      UNTIL receCommercePayments.Next() = 0;
        //    END;
        //    receCommerceTransactionSummary."Fee Purchase Invoice No." := PurchaseNo;
        //    receCommerceTransactionSummary.Amount := TotalAmount;
        //    receCommerceTransactionSummary.Open := FALSE;
        //    receCommerceTransactionSummary.MODIFY;
        //
        //    IF TotalAmount <> 0 THEN BEGIN
        //      DocNo := NoSeriesMangement.GetNextNo(recAmzCompMap."Payment Number Series",TODAY,TRUE);
        //      recGenJnl.VALIDATE("Journal Template Name",recAmzCompMap."Payment G/L Template");
        //      recGenJnl.VALIDATE("Journal Batch Name",recAmzCompMap."Payment G/L Batch");
        //      recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(recAmzCompMap."Payment G/L Template",recAmzCompMap."Payment G/L Batch"));
        //      recGenJnl.VALIDATE("Posting Date",TODAY);
        //      recGenJnl.VALIDATE("Document Type",recGenJnl."Document Type"::Payment);
        //      recGenJnl.VALIDATE("Document No.",DocNo);
        //      recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Vendor);
        //      recGenJnl.VALIDATE("Account No.",Vendor);
        //      recGenJnl.VALIDATE(Amount,TotalAmount);
        //      recGenJnl.VALIDATE("Applies-to Doc. Type",recPurchaseHeader."Document Type");
        //      recGenJnl.VALIDATE("Applies-to Doc. No.",recPurchaseHeader."No.");
        //      recGenJnl.INSERT;
        //
        //      CLEAR(recGenJnl);
        //      recGenJnl.VALIDATE("Journal Template Name",recAmzCompMap."Payment G/L Template");
        //      recGenJnl.VALIDATE("Journal Batch Name",recAmzCompMap."Payment G/L Batch");
        //      recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(recAmzCompMap."Payment G/L Template",recAmzCompMap."Payment G/L Batch"));
        //      recGenJnl.VALIDATE("Posting Date",TODAY);
        //      recGenJnl.VALIDATE("Document Type",recGenJnl."Document Type"::Payment);
        //      recGenJnl.VALIDATE("Document No.",DocNo);
        //      recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Customer);
        //      recGenJnl.VALIDATE("Account No.",recAmzCompMap."Periodic Account No.");
        //      recGenJnl.VALIDATE(Amount,-TotalAmount);
        //      recGenJnl.Description :=
        //        COPYSTR(
        //          FORMAT(recGenJnl."Account Type"::Vendor) + ': ' +
        //          COPYSTR(receCommerceTransactionSummary."Transaction Summary",25,STRLEN(receCommerceTransactionSummary."Transaction Summary")),1,MAXSTRLEN(recGenJnl.Description));
        //      recGenJnl.INSERT;
        //    END;
        //  UNTIL receCommerceTransactionSummary.Next() = 0;
        // END;
        // Window.CLOSE;
    end;

    local procedure CreateSalesInvoice(Rec: Record "eCommerce Payment")
    var
        recAmzPay: Record "eCommerce Payment";
        receCommercePaymentsMatrix: Record "eCommerce Payment Matrix";
        xleCommerceCompMap: Record "eCommerce Market Place";
        RecNo: Integer;
        RowCount: Integer;
        receCommerceTransactionSummary: Record "eCommerce Transaction Summary";
        Amount: Decimal;
        recSalesHeader: Record "Sales Header";
        PurchaseNo: Code[20];
        recSalesLine: Record "Sales Line";
        LineNo: Integer;
        TotalAmount: Decimal;
        lText001: Label 'There are sales invices to be created in RHQ.';
        lText002: Label 'Sales invoice is created, and must be posted.';
        lText003: Label 'There are lines with posting type "Sale" who needs to be handled.';
    begin
        begin
            recAmzPay.SetCurrentkey("Journal Batch No.");
            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange(Open, true);
            recAmzPay.SetRange("Posting Type", recAmzPay."posting type"::Sale);
            if recAmzPay.FindSet(true) then begin
                if ZGT.IsZNetCompany then begin
                    //leCommerceCompMap.SETRANGE("Marketplace ID",'DE');
                    //IF NOT leCommerceCompMap.FINDFIRST THEN;

                    //IF leCommerceCompMap."Marketplace ID" = 'DE' THEN BEGIN
                    repeat
                        Clear(recSalesHeader);
                        Clear(recSalesLine);
                        Rec.Amount := 0;
                        TotalAmount := 0;

                        recSalesHeader.Init();
                        recSalesHeader.Validate("Document Type", recSalesHeader."document type"::Invoice);
                        recSalesHeader.Insert(true);
                        recSalesHeader.SetHideValidationDialog(true);
                        recSalesHeader.Validate("Sales Order Type", recSalesHeader."sales order type"::Normal);
                        //recSalesHeader.VALIDATE("Sell-to Customer No.",leCommerceCompMap."Customer No.");
                        recSalesHeader.Validate("Sell-to Customer No.", Customer);
                        recSalesHeader.Validate("Posting Date", Today);
                        recSalesHeader.Validate("Document Date", Today);
                        recSalesHeader.Validate("Due Date", Today);
                        recSalesHeader."eCommerce Order" := true;
                        if recAmzPay."Order ID" <> '' then
                            recSalesHeader."External Document No." := recAmzPay."Order ID"
                        else
                            recSalesHeader."External Document No." :=
                              CopyStr(Format(recAmzPay."Payment Type"), StrPos(Format(recAmzPay."Payment Type"), '-') + 2, StrLen(Format(recAmzPay."Payment Type")));
                        recSalesHeader."Posting Description" := 'eCommerce : ' + CopyStr(receCommerceTransactionSummary."Transaction Summary", 25, StrLen(receCommerceTransactionSummary."Transaction Summary"));
                        //recSalesHeader."Vendor Invoice No." := 'eCommerce: ' + PurchaseNo;
                        recSalesHeader."eCommerce Order" := true;
                        //recSalesHeader.VALIDATE("Location Code", leCommerceCompMap."Location Code");
                        recSalesHeader.Validate("Location Code", LocationCode);
                        recSalesHeader.Modify(true);

                        LineNo := 10000;
                        recSalesLine.Init();
                        recSalesLine.Validate("Document Type", recSalesHeader."Document Type");
                        recSalesLine.Validate("Document No.", recSalesHeader."No.");
                        recSalesLine.Validate("Line No.", LineNo);
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        recSalesLine.Validate("No.", recAmzPay."Item No.");
                        recSalesLine.Validate(Quantity, recAmzPay.Quantity);
                        recSalesLine.Validate("Unit Price", recAmzPay.Amount / (1 + (recSalesLine."VAT %" / 100)));
                        recSalesLine.Insert();
                        LineNo := LineNo + 10000;
                    until recAmzPay.Next() = 0;
                    Message(lText002);
                    //END ELSE
                    //  MESSAGE(lText001);
                end else
                    Message(lText001);
            end;
        end;
    end;

    local procedure OLD_CreateSalesInvoice()
    var
        receCommercePayments: Record "eCommerce Payment";
        receCommercePaymentsMatrix: Record "eCommerce Payment Matrix";
        leCommerceCompMap: Record "eCommerce Market Place";
        RecNo: Integer;
        RowCount: Integer;
        receCommerceTransactionSummary: Record "eCommerce Transaction Summary";
        Amount: Decimal;
        recSalesHeader: Record "Sales Header";
        PurchaseNo: Code[20];
        recSalesLine: Record "Sales Line";
        LineNo: Integer;
        TotalAmount: Decimal;
        lText001: Label 'There are sales invices to be created in RHQ.';
        lText002: Label 'Sales invoice is created, and must be posted.';
        lText003: Label 'There are lines with posting type "Sale" who needs to be handled.';
    begin
        // receCommercePayments.SETRANGE(Open,TRUE);
        // receCommercePayments.SETRANGE("Posting Type",receCommercePayments."Posting Type"::Sale);
        // IF receCommercePayments.FINDSET THEN BEGIN
        //  leCommerceCompMap.SETRANGE("Marketplace ID",'DE');
        //  IF NOT leCommerceCompMap.FINDFIRST THEN;
        //
        //  IF leCommerceCompMap."Marketplace ID" = 'DE' THEN BEGIN
        //    REPEAT
        //      CLEAR(recSalesHeader);
        //      CLEAR(recSalesLine);
        //      Amount := 0;
        //      TotalAmount := 0;
        //
        //      recSalesHeader.INIT;
        //      recSalesHeader.VALIDATE("Document Type",recSalesHeader."Document Type"::Invoice);
        //      recSalesHeader.INSERT(TRUE);
        //      recSalesHeader.SetHideValidationDialog(TRUE);
        //      recSalesHeader.VALIDATE("Sales Order Type",recSalesHeader."Sales Order Type"::Normal);
        //      recSalesHeader.VALIDATE("Sell-to Customer No.",leCommerceCompMap."Customer No.");
        //      recSalesHeader.VALIDATE("Posting Date",TODAY);
        //      recSalesHeader.VALIDATE("Document Date",TODAY);
        //      recSalesHeader.VALIDATE("Due Date",TODAY);
        //      recSalesHeader."eCommerce Order" := TRUE;
        //      IF receCommercePayments."Order ID" <> '' THEN
        //        recSalesHeader."External Document No." := receCommercePayments."Order ID"
        //      ELSE
        //        recSalesHeader."External Document No." :=
        //          COPYSTR(FORMAT(receCommercePayments."Payment Type"),StrPos(FORMAT(receCommercePayments."Payment Type"),'-') + 2,STRLEN(FORMAT(receCommercePayments."Payment Type")));
        //      recSalesHeader."Posting Description" := 'eCommerce : ' + COPYSTR(receCommerceTransactionSummary."Transaction Summary",25,STRLEN(receCommerceTransactionSummary."Transaction Summary"));
        //      //recSalesHeader."Vendor Invoice No." := 'eCommerce: ' + PurchaseNo;
        //      recSalesHeader."eCommerce Order" := TRUE;
        //      recSalesHeader.VALIDATE("Location Code",leCommerceCompMap."Location Code");
        //      recSalesHeader.MODIFY(TRUE);
        //
        //      LineNo := 10000;
        //      recSalesLine.INIT;
        //      recSalesLine.VALIDATE("Document Type",recSalesHeader."Document Type");
        //      recSalesLine.VALIDATE("Document No.",recSalesHeader."No.");
        //      recSalesLine.VALIDATE("Line No.",LineNo);
        //      recSalesLine.VALIDATE(Type,recSalesLine.Type::Item);
        //      recSalesLine.VALIDATE("No.",receCommercePayments."Item No.");
        //      recSalesLine.VALIDATE(Quantity,receCommercePayments.Quantity);
        //      recSalesLine.VALIDATE("Unit Price",receCommercePayments.Amount / (1 + (recSalesLine."VAT %" / 100)));
        //      recSalesLine.INSERT;
        //      LineNo := LineNo + 10000;
        //    UNTIL receCommercePayments.Next() = 0;
        //    MESSAGE(lText002);
        //  END ELSE
        //    MESSAGE(lText001);
        // END;
    end;

    local procedure GetNextNumber() LineNo: Code[20]
    var
        recPurchasesPayablesSetup: Record "Purchases & Payables Setup";
        recNoSeries: Record "No. Series";
        NoSer: Code[20];
        NoSeriesMangement: Codeunit NoSeriesManagement;
    begin
        if recPurchasesPayablesSetup.FindFirst() then NoSer := recPurchasesPayablesSetup."Invoice Nos.";
        if NoSer <> '' then begin
            recNoSeries.SetFilter(Code, NoSer);
            if recNoSeries.FindSet() then begin
                recNoSeries."Manual Nos." := true;
                recNoSeries.Modify();
            end;
        end;
        LineNo := NoSeriesMangement.GetNextNo(NoSer, Today, true);
    end;

    local procedure ApplyVendorEntries()
    var
        recVendorLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        VendEntryApplyPostEntries: Codeunit "VendEntry-Apply Posted Entries";
    begin
        recVendorLedgerEntry.SetFilter("Vendor No.", Vendor);
        recVendorLedgerEntry.SetRange(Open, true);
        Window.Open(Text013 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        if recVendorLedgerEntry.FindSet() then begin
            RowCount := recVendorLedgerEntry.Count();
            RecNo := 0;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                // VendEntryApplyPostEntries.ApplyVendEntryFormEntry(recVendorLedgerEntry);
                ApplyUnapplyParameters."Document No." := recVendorLedgerEntry."Document No.";
                ApplyUnapplyParameters."Posting Date" := Today();
                VendEntryApplyPostEntries.Apply(recVendorLedgerEntry, ApplyUnapplyParameters);
            until recVendorLedgerEntry.Next() = 0;
        end;
        Window.Close();
    end;

    local procedure CashReceiptJournal(Rec: Record "eCommerce Payment")
    var
        recAmzPay: Record "eCommerce Payment";
        recGenJnlTmp: Record "Gen. Journal Line" temporary;
        recGenJnl: Record "Gen. Journal Line";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMHead: Record "Sales Cr.Memo Header";
        recDefDim: Record "Default Dimension";
        recGenLedgSetup: Record "General Ledger Setup";
        TotalAmountAzn: Decimal;
        TotalAmount: Decimal;
        DocumentNo: Code[20];
        SalesHeadAmount: Decimal;
        SalesInvHeadFound: Boolean;
        SalesCrMHeadFound: Boolean;
        lText001: Label 'Rounding';
        Difference: Decimal;
    begin
        begin
            recAmzPay.SetCurrentkey("Journal Batch No.");
            recAmzPay.SetRange("Journal Batch No.", Rec."Journal Batch No.");
            recAmzPay.SetRange(Open, true);
            recAmzPay.SetFilter("Posting Type", '%1|%2', recAmzPay."posting type"::Payment, recAmzPay."posting type"::Sale);

            Window.Open(Text014 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
            Window.Update(1, 0);
            if recAmzPay.FindSet(true) then begin
                RowCount := recAmzPay.Count();
                RecNo := 0;
                DocumentNo := GetNextNumberJournal;

                repeat
                    RecNo := RecNo + 1;
                    Window.Update(1, Round(RecNo / RowCount * 10000, 1));

                    recGenJnlTmp.Reset();
                    Clear(recGenJnlTmp);  // 09-08-22 ZY-LD 006
                    recGenJnlTmp.SetRange("Journal Template Name", GLTemplate);
                    recGenJnlTmp.SetRange("Journal Batch Name", GLBatch);
                    recGenJnlTmp.SetRange("External Document No.", recAmzPay."Order ID");
                    if recAmzPay."Transaction Type" = recAmzPay."transaction type"::Refund then
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
                        recGenJnlTmp.Validate("Journal Template Name", GLTemplate);
                        recGenJnlTmp.Validate("Journal Batch Name", GLBatch);
                        recGenJnlTmp.Validate("Line No.", RecNo);
                        recGenJnlTmp.Validate("Posting Date", Today);
                        /*        IF (recAmzPay."Transaction Type" = recAmzPay."Transaction Type"::"Order Payment") OR
                                   (recAmzPay."Posting Type" = recAmzPay."Posting Type"::Sale)
                                THEN BEGIN
                                  recGenJnlTmp.VALIDATE("Document Type",recGenJnlTmp."Document Type"::Payment);
                                  recGenJnlTmp.VALIDATE("Applies-to Doc. Type",recGenJnlTmp."Applies-to Doc. Type"::Invoice);
                                  recGenJnlTmp."Applies-to Doc. No." := recAmzPay."Sales Invoice No.";
                                END;*/
                        if recAmzPay."Transaction Type" = recAmzPay."transaction type"::Refund then begin
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
                        recGenJnlTmp.Description := PaymentDescription + ' ' + recAmzPay."Order ID";
                        recGenJnlTmp."Account No." := Customer;
                        recGenJnlTmp."External Document No." := recAmzPay."Order ID";
                        recGenJnlTmp.Insert();
                    end;

                    recAmzPay."Cash Receipt Journals Line" := true;
                    recAmzPay.Open := false;
                    recAmzPay.Modify();
                until recAmzPay.Next() = 0;

                recGenJnlTmp.Reset();
                if recGenJnlTmp.FindSet() then
                    repeat
                        SalesHeadAmount := 0;
                        SalesInvHeadFound := false;
                        SalesCrMHeadFound := false;

                        if recGenJnlTmp."Document Type" = recGenJnlTmp."document type"::Payment then begin
                            Clear(recSalesInvHead);
                            recSalesInvHead.SetCurrentkey("Your Reference");  // 17-05-18 ZY-LD 002
                            recSalesInvHead.SetAutoCalcFields("Amount Including VAT");
                            recSalesInvHead.SetRange("Your Reference", recGenJnlTmp."External Document No.");
                            recSalesInvHead.SetFilter("Amount Including VAT", '<>0');  // 17-05-18 ZY-LD 002
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
                                        recGenJnl.Validate("Journal Template Name", GLTemplate);
                                        recGenJnl.Validate("Journal Batch Name", GLBatch);
                                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(GLTemplate, GLBatch));
                                        recGenJnl.Validate("Posting Date", Today);
                                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Payment);
                                        recGenJnl.Validate("Document No.", DocumentNo);
                                        recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                        recGenJnl.Validate("Account No.", Customer);
                                        recGenJnl.Validate(Amount, -recSalesInvHead."Amount Including VAT");
                                        recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::Invoice);
                                        recGenJnl."Applies-to Doc. No." := recSalesInvHead."No.";
                                        recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
                                        recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                        recGenJnl.Insert(true);

                                        TotalAmount += recSalesInvHead."Amount Including VAT";
                                    until recSalesInvHead.Next() = 0;
                            end else begin
                                Clear(recGenJnl);
                                recGenJnl.Init();
                                recGenJnl.Validate("Journal Template Name", GLTemplate);
                                recGenJnl.Validate("Journal Batch Name", GLBatch);
                                recGenJnl.Validate("Line No.", GetNextJournalLineNo(GLTemplate, GLBatch));
                                recGenJnl.Validate("Posting Date", Today);
                                recGenJnl.Validate("Document Type", recGenJnlTmp."Document Type");
                                recGenJnl.Validate("Document No.", DocumentNo);
                                recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                recGenJnl.Validate("Account No.", Customer);
                                recGenJnl.Validate(Amount, recGenJnlTmp.Amount);
                                recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::Invoice);  // 30-01-19 ZY-LD 004
                                recGenJnl."Applies-to Doc. No." := recSalesInvHead."No.";  // 30-01-19 ZY-LD 004
                                recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
                                recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                recGenJnl.Insert(true);

                                TotalAmount += -recGenJnlTmp.Amount;
                            end;
                        end else begin  // Refund
                            Clear(recSalesCrMHead);
                            recSalesCrMHead.SetCurrentkey("Your Reference");  // 17-05-18 ZY-LD 002
                            recSalesCrMHead.SetAutoCalcFields("Amount Including VAT");
                            recSalesCrMHead.SetRange("Your Reference", recGenJnlTmp."External Document No.");
                            recSalesCrMHead.SetFilter("Amount Including VAT", '<>0');  // 17-05-18 ZY-LD 002
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
                                        recGenJnl.Validate("Journal Template Name", GLTemplate);
                                        recGenJnl.Validate("Journal Batch Name", GLBatch);
                                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(GLTemplate, GLBatch));
                                        recGenJnl.Validate("Posting Date", Today);
                                        recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund);
                                        recGenJnl.Validate("Document No.", DocumentNo);
                                        recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                        recGenJnl.Validate("Account No.", Customer);
                                        recGenJnl.Validate(Amount, recSalesInvHead."Amount Including VAT");
                                        recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::"Credit Memo");
                                        recGenJnl."Applies-to Doc. No." := recSalesCrMHead."No.";
                                        recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
                                        recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                        recGenJnl.Insert(true);

                                        TotalAmount -= recSalesCrMHead."Amount Including VAT";
                                    until recSalesCrMHead.Next() = 0;
                            end else begin
                                Clear(recGenJnl);
                                recGenJnl.Init();
                                recGenJnl.Validate("Journal Template Name", GLTemplate);
                                recGenJnl.Validate("Journal Batch Name", GLBatch);
                                recGenJnl.Validate("Line No.", GetNextJournalLineNo(GLTemplate, GLBatch));
                                recGenJnl.Validate("Posting Date", Today);
                                recGenJnl.Validate("Document Type", recGenJnlTmp."Document Type");
                                recGenJnl.Validate("Document No.", DocumentNo);
                                recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                                recGenJnl.Validate("Account No.", Customer);
                                recGenJnl.Validate(Amount, recGenJnlTmp.Amount);
                                recGenJnl.Validate("Applies-to Doc. Type", recGenJnl."applies-to doc. type"::"Credit Memo");  // 30-01-19 ZY-LD 004
                                recGenJnl."Applies-to Doc. No." := recSalesCrMHead."No.";  // 30-01-19 ZY-LD 004
                                recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
                                recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
                                recGenJnl.Insert(true);

                                TotalAmount += -recGenJnlTmp.Amount;
                            end;
                        end;
                    until recGenJnlTmp.Next() = 0;

                if TotalAmount <> 0 then begin
                    //>> 16-02-18 ZY-LD 001
                    if TotalAmount - TotalAmountAzn <> 0 then begin
                        recGenLedgSetup.Get();

                        Clear(recGenJnl);
                        recGenJnl.Init();
                        recGenJnl.Validate("Journal Template Name", GLTemplate);
                        recGenJnl.Validate("Journal Batch Name", GLBatch);
                        recGenJnl.Validate("Line No.", GetNextJournalLineNo(GLTemplate, GLBatch));
                        recGenJnl.Validate("Posting Date", Today);
                        recGenJnl.Validate("Document No.", DocumentNo);
                        recGenJnl.Validate("Account Type", recGenJnl."account type"::"G/L Account");
                        recGenJnl.Validate("Account No.", recAmzCompMap.Roundings);
                        recGenJnl.Validate(Amount, TotalAmount - TotalAmountAzn);

                        //>> 09-08-22 ZY-LD 006
                        recDefDim.Get(Database::Customer, PeriodicAccountNo, recGenLedgSetup."Shortcut Dimension 1 Code");
                        recGenJnl.Validate("Shortcut Dimension 1 Code", recDefDim."Dimension Value Code");
                        recGenJnl.Validate("Shortcut Dimension 2 Code", 'G&A');
                        recDefDim.Get(Database::Customer, PeriodicAccountNo, recGenLedgSetup."Shortcut Dimension 3 Code");
                        recGenJnl.ValidateShortcutDimCode(3, recDefDim."Dimension Value Code");
                        //recGenJnl.Description := lText001;
                        recGenJnl.Validate("Gen. Posting Type", recGenJnl."gen. posting type"::" ");
                        recGenJnl.Validate("Gen. Bus. Posting Group", '');
                        recGenJnl.Validate("Gen. Prod. Posting Group", '');
                        recGenJnl.Validate("VAT Bus. Posting Group", '');
                        recGenJnl.Validate("VAT Prod. Posting Group", '');
                        //<< 09-08-22 ZY-LD 006
                        recGenJnl.Insert(true);
                    end;
                    //<< 16-02-18 ZY-LD 001

                    Clear(recGenJnl);
                    recGenJnl.Init();
                    recGenJnl.Validate("Journal Template Name", GLTemplate);
                    recGenJnl.Validate("Journal Batch Name", GLBatch);
                    recGenJnl.Validate("Line No.", GetNextJournalLineNo(GLTemplate, GLBatch));
                    recGenJnl.Validate("Posting Date", Today);
                    recGenJnl.Validate("Document Type", recGenJnl."document type"::Refund);
                    recGenJnl.Validate("Document No.", DocumentNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                    recGenJnl.Validate(Amount, TotalAmountAzn);
                    recGenJnl.Description := PeriodicAccountDescription;
                    recGenJnl."Account No." := PeriodicAccountNo;
                    recGenJnl.Insert(true);
                end;
            end;
            Window.Close();
        end;

    end;

    local procedure OLD_CashReceiptJournal()
    var
        receCommercePayments: Record "eCommerce Payment";
        recGenJnlTmp: Record "Gen. Journal Line" temporary;
        recGenJnl: Record "Gen. Journal Line";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMHead: Record "Sales Cr.Memo Header";
        TotalAmountAzn: Decimal;
        TotalAmount: Decimal;
        DocumentNo: Code[20];
        SalesHeadAmount: Decimal;
        SalesInvHeadFound: Boolean;
        SalesCrMHeadFound: Boolean;
        lText001: Label 'Rounding';
        Difference: Decimal;
    begin
        // receCommercePayments.SETRANGE(Open,TRUE);
        // // receCommercePayments.SETFILTER("Transaction Type",'%1|%2',receCommercePayments."Transaction Type"::"Order Payment",receCommercePayments."Transaction Type"::Refund);
        // // receCommercePayments.SETFILTER("Payment Type",'%1|%2',receCommercePayments."Payment Type"::"Product charges",receCommercePayments."Payment Type"::Other);
        // // receCommercePayments.SETFILTER("Payment Detail",'%1|%2',receCommercePayments."Payment Detail"::Blank,receCommercePayments."Payment Detail"::"Product Tax");
        //
        // Window.OPEN(Text014 +  '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        // Window.UPDATE(1,0);
        // receCommercePayments.SETFILTER("Posting Type",'%1|%2',receCommercePayments."Posting Type"::Payment,receCommercePayments."Posting Type"::Sale);
        // IF receCommercePayments.FINDSET(TRUE) THEN BEGIN
        //  RowCount := receCommercePayments.COUNT;
        //  RecNo := 0;
        //  DocumentNo := GetNextNumberJournal;
        //  REPEAT
        //    recGenJnlTmp.RESET;
        //    recGenJnlTmp.SETRANGE("Journal Template Name",GLTemplate);
        //    recGenJnlTmp.SETRANGE("Journal Batch Name",GLBatch);
        //    recGenJnlTmp.SETRANGE("External Document No.",receCommercePayments."Order ID");
        //    IF receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::Refund THEN
        //      recGenJnlTmp.SETRANGE("Document Type",recGenJnlTmp."Document Type"::Refund)
        //    ELSE
        //      recGenJnlTmp.SETRANGE("Document Type",recGenJnlTmp."Document Type"::Payment);
        //    IF recGenJnlTmp.FINDFIRST THEN BEGIN
        //      recGenJnlTmp.VALIDATE(Amount,recGenJnlTmp.Amount + (-receCommercePayments.Amount));
        //      TotalAmountAzn += receCommercePayments.Amount;
        //      recGenJnlTmp.MODIFY;
        //    END ELSE BEGIN
        //      RecNo := RecNo + 1;
        //      Window.UPDATE(1,ROUND(RecNo / RowCount * 10000,1));
        //      CLEAR(recGenJnlTmp);
        //      recGenJnlTmp.INIT;
        //      recGenJnlTmp.VALIDATE("Journal Template Name",GLTemplate);
        //      recGenJnlTmp.VALIDATE("Journal Batch Name",GLBatch);
        //      recGenJnlTmp.VALIDATE("Line No.",RecNo);
        //      recGenJnlTmp.VALIDATE("Posting Date",TODAY);
        //      IF (receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::"Order Payment") OR
        //         (receCommercePayments."Posting Type" = receCommercePayments."Posting Type"::Sale)
        //      THEN BEGIN
        //        recGenJnlTmp.VALIDATE("Document Type",recGenJnlTmp."Document Type"::Payment);
        //        recGenJnlTmp.VALIDATE("Applies-to Doc. Type",recGenJnlTmp."Applies-to Doc. Type"::Invoice);
        //      END;
        //      IF receCommercePayments."Transaction Type" = receCommercePayments."Transaction Type"::Refund THEN BEGIN
        //        recGenJnlTmp.VALIDATE("Document Type",recGenJnlTmp."Document Type"::Refund);
        //        recGenJnlTmp.VALIDATE("Applies-to Doc. Type",recGenJnlTmp."Applies-to Doc. Type"::"Credit Memo");
        //      END;
        //      recGenJnlTmp.VALIDATE("Document No.",DocumentNo);
        //      recGenJnlTmp.VALIDATE("Account Type",recGenJnlTmp."Account Type"::Customer);
        //      recGenJnlTmp.VALIDATE(Amount,-receCommercePayments.Amount);
        //      TotalAmountAzn += receCommercePayments.Amount;
        //      IF recGenJnlTmp."Document Type" = recGenJnlTmp."Document Type"::Payment THEN
        //        recGenJnlTmp."Applies-to Doc. No." := receCommercePayments."Sales Invoice No."
        //      ELSE
        //        recGenJnlTmp."Applies-to Doc. No." := receCommercePayments."Sales Credit No.";
        //      recGenJnlTmp.Description := PaymentDescription + ' ' + receCommercePayments."Order ID";
        //      recGenJnlTmp."Account No." := Customer;
        //      recGenJnlTmp."External Document No." := receCommercePayments."Order ID";
        //      recGenJnlTmp.INSERT;
        //    END;
        //
        //    receCommercePayments."Cash Receipt Journals Line" := TRUE;
        //    receCommercePayments.Open := FALSE;
        //    receCommercePayments.MODIFY;
        //  UNTIL receCommercePayments.Next() = 0;
        //
        //  recGenJnlTmp.RESET;
        //  IF recGenJnlTmp.FINDSET THEN REPEAT
        //    SalesHeadAmount := 0;
        //    SalesInvHeadFound := FALSE;
        //    SalesCrMHeadFound := FALSE;
        //
        //    IF recGenJnlTmp."Document Type" = recGenJnlTmp."Document Type"::Payment THEN BEGIN
        //      recSalesInvHead.SetCurrentKey("Your Reference");  // 17-05-18 ZY-LD 002
        //      recSalesInvHead.SETAUTOCALCFIELDS("Amount Including VAT");
        //      recSalesInvHead.SETRANGE("Your Reference",recGenJnlTmp."External Document No.");
        //      recSalesInvHead.SETFILTER("Amount Including VAT",'<>0');  // 17-05-18 ZY-LD 002
        //      IF recSalesInvHead.FINDSET THEN REPEAT
        //        SalesHeadAmount += recSalesInvHead."Amount Including VAT";
        //        SalesInvHeadFound := TRUE;
        //      UNTIL recSalesInvHead.Next() = 0;
        //
        //      Difference := ABS(recGenJnlTmp.Amount) - ABS(SalesHeadAmount);
        //      IF (Difference > -1) AND (Difference < 1) THEN BEGIN
        //        IF recSalesInvHead.FINDSET THEN REPEAT
        //          CLEAR(recGenJnl);
        //          recGenJnl.INIT;
        //          recGenJnl.VALIDATE("Journal Template Name",GLTemplate);
        //          recGenJnl.VALIDATE("Journal Batch Name",GLBatch);
        //          recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(GLTemplate,GLBatch));
        //          recGenJnl.VALIDATE("Posting Date",TODAY);
        //          recGenJnl.VALIDATE("Document Type",recGenJnl."Document Type"::Payment);
        //          recGenJnl.VALIDATE("Document No.",DocumentNo);
        //          recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Customer);
        //          recGenJnl.VALIDATE("Account No.",Customer);
        //          recGenJnl.VALIDATE(Amount,-recSalesInvHead."Amount Including VAT");
        //          recGenJnl.VALIDATE("Applies-to Doc. Type",recGenJnl."Applies-to Doc. Type"::Invoice);
        //          recGenJnl."Applies-to Doc. No." := recSalesInvHead."No.";
        //          recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
        //          recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
        //          recGenJnl.INSERT;
        //
        //          TotalAmount += recSalesInvHead."Amount Including VAT";
        //        UNTIL recSalesInvHead.Next() = 0;
        //      END ELSE BEGIN
        //        CLEAR(recGenJnl);
        //        recGenJnl.INIT;
        //        recGenJnl.VALIDATE("Journal Template Name",GLTemplate);
        //        recGenJnl.VALIDATE("Journal Batch Name",GLBatch);
        //        recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(GLTemplate,GLBatch));
        //        recGenJnl.VALIDATE("Posting Date",TODAY);
        //        recGenJnl.VALIDATE("Document Type",recGenJnlTmp."Document Type");
        //        recGenJnl.VALIDATE("Document No.",DocumentNo);
        //        recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Customer);
        //        recGenJnl.VALIDATE("Account No.",Customer);
        //        recGenJnl.VALIDATE(Amount,recGenJnlTmp.Amount);
        //        recGenJnl.VALIDATE("Applies-to Doc. Type",recGenJnl."Applies-to Doc. Type"::Invoice);  // 30-01-19 ZY-LD 004
        //        recGenJnl."Applies-to Doc. No." := recSalesInvHead."No.";  // 30-01-19 ZY-LD 004
        //        recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
        //        recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
        //        recGenJnl.INSERT;
        //
        //        TotalAmount += -recGenJnlTmp.Amount;
        //      END;
        //    END ELSE BEGIN  // Refund
        //      recSalesCrMHead.SetCurrentKey("Your Reference");  // 17-05-18 ZY-LD 002
        //      recSalesCrMHead.SETAUTOCALCFIELDS("Amount Including VAT");
        //      recSalesCrMHead.SETRANGE("Your Reference",recGenJnlTmp."External Document No.");
        //      recSalesCrMHead.SETFILTER("Amount Including VAT",'<>0');  // 17-05-18 ZY-LD 002
        //      IF recSalesCrMHead.FINDSET THEN REPEAT
        //        SalesHeadAmount += recSalesInvHead."Amount Including VAT";
        //        SalesCrMHeadFound := TRUE;
        //      UNTIL recSalesCrMHead.Next() = 0;
        //
        //      Difference := ABS(recGenJnlTmp.Amount) - ABS(SalesHeadAmount);
        //      IF (Difference > -1) AND (Difference < 1) THEN BEGIN
        //        IF recSalesCrMHead.FINDSET THEN REPEAT
        //          CLEAR(recGenJnl);
        //          recGenJnl.INIT;
        //          recGenJnl.VALIDATE("Journal Template Name",GLTemplate);
        //          recGenJnl.VALIDATE("Journal Batch Name",GLBatch);
        //          recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(GLTemplate,GLBatch));
        //          recGenJnl.VALIDATE("Posting Date",TODAY);
        //          recGenJnl.VALIDATE("Document Type",recGenJnl."Document Type"::Refund);
        //          recGenJnl.VALIDATE("Document No.",DocumentNo);
        //          recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Customer);
        //          recGenJnl.VALIDATE("Account No.",Customer);
        //          recGenJnl.VALIDATE(Amount,recSalesInvHead."Amount Including VAT");
        //          recGenJnl.VALIDATE("Applies-to Doc. Type",recGenJnl."Applies-to Doc. Type"::"Credit Memo");
        //          recGenJnl."Applies-to Doc. No." := recSalesCrMHead."No.";
        //          recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
        //          recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
        //          recGenJnl.INSERT;
        //
        //          TotalAmount -= recSalesCrMHead."Amount Including VAT";
        //        UNTIL recSalesCrMHead.Next() = 0;
        //      END ELSE BEGIN
        //        CLEAR(recGenJnl);
        //        recGenJnl.INIT;
        //        recGenJnl.VALIDATE("Journal Template Name",GLTemplate);
        //        recGenJnl.VALIDATE("Journal Batch Name",GLBatch);
        //        recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(GLTemplate,GLBatch));
        //        recGenJnl.VALIDATE("Posting Date",TODAY);
        //        recGenJnl.VALIDATE("Document Type",recGenJnlTmp."Document Type");
        //        recGenJnl.VALIDATE("Document No.",DocumentNo);
        //        recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Customer);
        //        recGenJnl.VALIDATE("Account No.",Customer);
        //        recGenJnl.VALIDATE(Amount,recGenJnlTmp.Amount);
        //        recGenJnl.VALIDATE("Applies-to Doc. Type",recGenJnl."Applies-to Doc. Type"::"Credit Memo");  // 30-01-19 ZY-LD 004
        //        recGenJnl."Applies-to Doc. No." := recSalesCrMHead."No.";  // 30-01-19 ZY-LD 004
        //        recGenJnl.Description := PaymentDescription + ' ' + recGenJnlTmp."External Document No.";
        //        recGenJnl."External Document No." := recGenJnlTmp."External Document No.";
        //        recGenJnl.INSERT;
        //
        //        TotalAmount += -recGenJnlTmp.Amount;
        //      END;
        //    END;
        //  UNTIL recGenJnlTmp.Next() = 0;
        //
        //  IF TotalAmount <> 0 THEN BEGIN
        //    //>> 16-02-18 ZY-LD 001
        //    IF TotalAmount - TotalAmountAzn <> 0 THEN BEGIN
        //      CLEAR(recGenJnl);
        //      recGenJnl.INIT;
        //      recGenJnl.VALIDATE("Journal Template Name",GLTemplate);
        //      recGenJnl.VALIDATE("Journal Batch Name",GLBatch);
        //      recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(GLTemplate,GLBatch));
        //      recGenJnl.VALIDATE("Posting Date",TODAY);
        //      recGenJnl.VALIDATE("Document No.",DocumentNo);
        //      recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::"G/L Account");
        //      recGenJnl.VALIDATE("Account No.",recAmzCompMap.Roundings);
        //      recGenJnl.VALIDATE(Amount,TotalAmount - TotalAmountAzn);
        //      recGenJnl.Description := lText001;
        //      recGenJnl.INSERT;
        //    END;
        //    //<< 16-02-18 ZY-LD 001
        //
        //    CLEAR(recGenJnl);
        //    recGenJnl.INIT;
        //    recGenJnl.VALIDATE("Journal Template Name",GLTemplate);
        //    recGenJnl.VALIDATE("Journal Batch Name",GLBatch);
        //    recGenJnl.VALIDATE("Line No.",GetNextJournalLineNo(GLTemplate,GLBatch));
        //    recGenJnl.VALIDATE("Posting Date",TODAY);
        //    recGenJnl.VALIDATE("Document Type",recGenJnl."Document Type"::Refund);
        //    recGenJnl.VALIDATE("Document No.",DocumentNo);
        //    recGenJnl.VALIDATE("Account Type",recGenJnl."Account Type"::Customer);
        //    recGenJnl.VALIDATE(Amount,TotalAmountAzn);
        //    recGenJnl.Description := PeriodicAccountDescription;
        //    recGenJnl."Account No." := PeriodicAccountNo;
        //    recGenJnl.INSERT;
        //  END;
        // END;
        // Window.CLOSE;
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
        if PaymentNumberSeries <> '' then begin
            recNoSeries.SetFilter(Code, PaymentNumberSeries);
            if recNoSeries.FindSet() then begin
                recNoSeries."Manual Nos." := true;
                recNoSeries.Modify();
            end;
        end;
        LineNo := NoSeriesMangement.GetNextNo(PaymentNumberSeries, Today, true);
    end;

    local procedure PaymentJournal()
    var
        receCommercePayments: Record "eCommerce Payment";
        recGenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
    begin
        receCommercePayments.SetRange(Open, true);
        receCommercePayments.SetFilter("Transaction Type", '%1', receCommercePayments."transaction type"::"Service Fees");
        Window.Open(Text014 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        if receCommercePayments.FindSet(true) then begin
            RowCount := receCommercePayments.Count();
            RecNo := 0;
            DocumentNo := GetNextNumberJournal;
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                recGenJournalLine.Init();
                recGenJournalLine."Line No." := GetNextJournalLineNo(GLTemplate, GLBatch);
                recGenJournalLine."Journal Template Name" := GLTemplate;
                recGenJournalLine."Journal Batch Name" := GLBatch;
                recGenJournalLine."Posting Date" := Today;
                recGenJournalLine."Document Type" := recGenJournalLine."document type"::Payment;
                recGenJournalLine."Applies-to Doc. Type" := recGenJournalLine."applies-to doc. type"::Invoice;
                recGenJournalLine."Document No." := DocumentNo;
                recGenJournalLine."Account Type" := recGenJournalLine."account type"::Customer;
                recGenJournalLine.Amount := -receCommercePayments.Amount;
                recGenJournalLine."Applies-to Doc. No." := receCommercePayments."Sales Invoice No.";
                recGenJournalLine.Description := 'Fees' + ' ' + receCommercePayments."Order ID";
                recGenJournalLine."Account No." := Customer;
                recGenJournalLine."External Document No." := receCommercePayments."Order ID";
                recGenJournalLine.Insert();
            until receCommercePayments.Next() = 0;
        end;
        Window.Close();
    end;

    local procedure GetCountryDimension(pAznOrderId: Code[50]): Code[10]
    var
        recAznSalesHead: Record "eCommerce Order Header";
        recAznCompMap: Record "eCommerce Market Place";
        recAznCountryMap: Record "eCommerce Country Mapping";
        lText001: Label '%1 is not created as "%2". Do you want to use "%3"?';
        lText002: Label '"%1" %2 is not created.';
        lText003: Label '"%1" is not created.';
    begin
        //>> 13-02-18 ZY-LD 001
        if recAznSalesHead.IsEmpty() then begin
            recAznSalesHead.ChangeCompany(ZGT.GetRHQCompanyName);
            recAznCountryMap.ChangeCompany(ZGT.GetRHQCompanyName);
        end;

        recAznSalesHead.SetRange("eCommerce Order Id", pAznOrderId);
        if recAznSalesHead.FindFirst() then begin
            recAznCompMap.Get(recAznSalesHead."Marketplace ID");  // 10-04-19 ZY-LD 005
            if recAznCountryMapTmp.Get(recAznCompMap."Customer No.", recAznSalesHead."Ship To Country") then  // 10-04-19 ZY-LD 005
                exit(recAznCountryMapTmp."Country Dimension")
            else begin
                if not recAznCountryMap.Get(recAznCompMap."Customer No.", recAznSalesHead."Ship To Country") then begin  // 10-04-19 ZY-LD 005
                    if Confirm(lText001, false, recAznSalesHead."Ship To Country", recAznCountryMap.TableCaption(), recAznCountryMap.FieldCaption("Default Mapping")) then begin
                        recAznCountryMap.Reset();
                        recAznCountryMap.SetRange("Customer No.", recAznCompMap."Customer No.");  // 10-04-19 ZY-LD 005
                        recAznCountryMap.SetRange("Default Mapping", true);
                        if recAznCountryMap.FindFirst() then begin
                            Clear(recAznCountryMapTmp);
                            recAznCountryMapTmp."Ship-to Country Code" := recAznSalesHead."Ship To Country";
                            recAznCountryMapTmp."Country Dimension" := recAznCountryMap."Country Dimension";
                            recAznCountryMapTmp.Insert();
                            exit(recAznCountryMap."Country Dimension")
                        end else
                            Error(lText003, recAznCountryMap.FieldCaption("Default Mapping"));
                    end else
                        Error(lText002, recAznCountryMap.TableCaption(), recAznSalesHead."Ship To Country");
                end else begin
                    recAznCountryMapTmp := recAznCountryMap;
                    recAznCountryMapTmp.Insert();
                    exit(recAznCountryMap."Country Dimension");
                end;
            end;
        end;
        //<< 13-02-18 ZY-LD 001
    end;
}
