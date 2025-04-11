pageextension 50115 CustomerLedgerEntriesZX extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer No.")
        {
            field(ExternalDocumentSL; ExternalDocumentSL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'External Document No. 2';
                Visible = false;
            }
            field("External Order No."; Rec."External Order No.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("Sales (LCY)")
        {
            field("Profit (LCY)"; Rec."Profit (LCY)")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field(eCommerceOrderID; eCommerceOrderID)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Order ID';
                Editable = false;
                Visible = false;
            }
            field(PaymentDueDateComplied; PaymentDueDateComplied)
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Caption = 'Payment Due Date Complied';
                Visible = false;
            }
            field("Forecast Territory"; Rec."Forecast Territory")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part(Control50; "eComm. Pay. Detail FactBox")
            {
                Caption = 'eCommerce Payment Detail';
                SubPageLink = "Order ID" = field("External Document No.");
                Visible = false;
            }
            part(Control54; "eCommerce Ship Details FactBox")
            {
                Caption = 'Archived eCommerce Order';
                SubPageLink = "eCommerce Order Id" = field("External Document No.");
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("Ent&ry")
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ChangeLogEntry: Record "Change Log Entry";
                    begin
                        ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                        ChangeLogEntry.SetAscending("Date and Time", false);
                        ChangeLogEntry.SetRange("Table No.", Database::"Cust. Ledger Entry");
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Entry No."));
                        Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                    end;
                }
            }
        }
        addafter("Show Document")
        {
            group(eCommerce)
            {
                Caption = 'eCommerce';
                action("Search eCommerce Order-id")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Search eCommerce Order-id';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+s';

                    trigger OnAction()
                    begin
                        SearcheCommerceOrderID;
                    end;
                }
                action("Clear Filter on eCommerce Order-id")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Clear Filter on eCommerce Order-id';
                    Image = ClearFilter;
                    ShortCutKey = 'Shift+Ctrl+a';

                    trigger OnAction()
                    begin
                        Rec.ClearMarks;
                        Rec.MarkedOnly(false);
                        //>> 14-03-20 ZY-LD 005
                        //SETRANGE(Open,TRUE);
                        Rec.Reset();
                        Rec.SetCurrentkey(Rec."Customer No.");
                        Rec.Ascending(false);
                        Rec.CopyFilters(CustLedgerEntrySaved);
                        Rec.SetFilter(Rec."Entry No.", '..%1', CustLedgerEntrySaved."Entry No.");
                        if not Rec.FindLast() then;
                        Rec.SetRange(Rec."Entry No.");
                        //<< 14-03-20 ZY-LD 005
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 02-11-17 ZY-LD 001
    end;

    trigger OnAfterGetRecord()
    begin
        //GeteCommerceOrderID;  // 07-11-17 ZY-LD 002  // 22-02-24 ZY-LD 000
        if Rec."Document Type" in [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] then
            GetExternalDocNoFromSalesLine;

        PaymentDueDateComplied := GetPaymentDays;  // 09-08-18 ZY-LD 003
    end;

    var
        eCommerceOrderID: Code[50];
        ExternalDocumentSL: Text;
        CustLedgerEntrySaved: Record "Cust. Ledger Entry";
        PaymentDueDateComplied: Integer;

    // 22-02-24 ZY-LD 000 - Since all eCommerce is in ZNet DK now, this function is not necessary anymore.
    /*local procedure GeteCommerceOrderID()
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        leCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        //>> 07-11-17 ZY-LD 002
        eCommerceOrderID := '';
        if (Rec."Document Type" in [Rec."document type"::Invoice, Rec."document type"::"Credit Memo"]) and
           (Rec."External Document No." <> '') and
           (StrLen(Rec."External Document No.") <= MaxStrLen(leCommerceSalesHeaderBuffer."RHQ Invoice No"))
        then begin
            leCommerceSalesHeaderBuffer.ChangeCompany(ZGT.GetRHQCompanyName);
            leCommerceSalesHeaderBuffer.SetRange("RHQ Invoice No", Rec."External Document No.");
            if leCommerceSalesHeaderBuffer.FindFirst() then
                eCommerceOrderID := leCommerceSalesHeaderBuffer."eCommerce Order Id"
            else begin
                if Rec."Document Type" = Rec."document type"::Invoice then begin
                    lSalesInvoiceHeader.ChangeCompany(ZGT.GetRHQCompanyName);
                    if lSalesInvoiceHeader.Get(Rec."External Document No.") then
                        eCommerceOrderID := lSalesInvoiceHeader."External Document No."
                end else begin
                    lSalesCrMemoHeader.ChangeCompany(ZGT.GetRHQCompanyName);
                    if lSalesCrMemoHeader.Get(Rec."External Document No.") then
                        eCommerceOrderID := lSalesCrMemoHeader."External Document No.";
                end;
            end;
        end;
        //<< 07-11-17 ZY-LD 002
    end;*/

    local procedure SearcheCommerceOrderID()
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        leCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        GenericInputPage: Page "Generic Input Page";
        lText001: Label 'Search eCommerce Order-id';
        lText002: Label 'eCommerce Order-id';
        AmzOrderID: Code[35];
        ZGT: Codeunit "ZyXEL General Tools";
        FilterOnEntries: Boolean;
    begin
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(3);
        GenericInputPage.SetCode20(Rec."External Document No.");
        if GenericInputPage.RunModal = Action::OK then begin
            AmzOrderID := GenericInputPage.GetCode20;
            Rec.ClearMarks;

            leCommerceSalesHeaderBuffer.ChangeCompany(ZGT.GetRHQCompanyName);
            lSalesInvoiceHeader.ChangeCompany(ZGT.GetRHQCompanyName);
            lSalesCrMemoHeader.ChangeCompany(ZGT.GetRHQCompanyName);

            //>> 14-03-20 ZY-LD 005
            CustLedgerEntrySaved.CopyFilters(Rec);
            CustLedgerEntrySaved := Rec;

            Rec.Reset();
            Rec.SetCurrentkey(Rec."Customer No.");
            Rec.Ascending(false);
            Rec.SetRange(Rec."Customer No.", Rec."Customer No.");
            //<< 14-03-20 ZY-LD 005

            // eCommerce Orders
            leCommerceSalesHeaderBuffer.SetRange("eCommerce Order Id", AmzOrderID);
            if leCommerceSalesHeaderBuffer.FindSet() then
                repeat
                    if leCommerceSalesHeaderBuffer."RHQ Invoice No" <> '' then begin
                        lCustLedgerEntry.Reset();
                        lCustLedgerEntry.SetRange("External Document No.", leCommerceSalesHeaderBuffer."RHQ Invoice No");
                        if lCustLedgerEntry.FindSet() then
                            repeat
                                Rec.Get(lCustLedgerEntry."Entry No.");
                                Rec.Mark(true);
                                FilterOnEntries := true;
                            until lCustLedgerEntry.Next() = 0;
                    end;

                    lSalesInvoiceHeader.SetFilter("External Document No.", '%1|%2', leCommerceSalesHeaderBuffer."eCommerce Order Id", leCommerceSalesHeaderBuffer."Invoice No.");
                    if lSalesInvoiceHeader.FindSet() then
                        repeat
                            lCustLedgerEntry.Reset();
                            lCustLedgerEntry.SetRange("External Document No.", lSalesInvoiceHeader."No.");
                            if lCustLedgerEntry.FindSet() then
                                repeat
                                    Rec.Get(lCustLedgerEntry."Entry No.");
                                    Rec.Mark(true);
                                    FilterOnEntries := true;
                                until lCustLedgerEntry.Next() = 0;
                        until lSalesInvoiceHeader.Next() = 0;

                    lSalesCrMemoHeader.SetFilter("External Document No.", '%1|%2', leCommerceSalesHeaderBuffer."eCommerce Order Id", leCommerceSalesHeaderBuffer."Invoice No.");
                    if lSalesCrMemoHeader.FindSet() then
                        repeat
                            lCustLedgerEntry.Reset();
                            lCustLedgerEntry.SetRange("External Document No.", lSalesCrMemoHeader."No.");
                            if lCustLedgerEntry.FindSet() then
                                repeat
                                    Rec.Get(lCustLedgerEntry."Entry No.");
                                    Rec.Mark(true);
                                    FilterOnEntries := true;
                                until lCustLedgerEntry.Next() = 0;
                        until lSalesCrMemoHeader.Next() = 0;

                until leCommerceSalesHeaderBuffer.Next() = 0;

            // Sales Invoice
            lSalesInvoiceHeader.SetRange("External Document No.", AmzOrderID);
            if lSalesInvoiceHeader.FindSet() then
                repeat
                    lCustLedgerEntry.Reset();
                    lCustLedgerEntry.SetRange("External Document No.", lSalesInvoiceHeader."No.");
                    if lCustLedgerEntry.FindSet() then
                        repeat
                            Rec.Get(lCustLedgerEntry."Entry No.");
                            Rec.Mark(true);
                            FilterOnEntries := true;
                        until lCustLedgerEntry.Next() = 0;
                until lSalesInvoiceHeader.Next() = 0;

            // Sales Credit Memo
            lSalesCrMemoHeader.SetRange("External Document No.", AmzOrderID);
            if lSalesCrMemoHeader.FindSet() then
                repeat
                    lCustLedgerEntry.Reset();
                    lCustLedgerEntry.SetRange("External Document No.", lSalesCrMemoHeader."No.");
                    if lCustLedgerEntry.FindSet() then
                        repeat
                            Rec.Get(lCustLedgerEntry."Entry No.");
                            Rec.Mark(true);
                            FilterOnEntries := true;
                        until lCustLedgerEntry.Next() = 0;
                until lSalesCrMemoHeader.Next() = 0;

            // Payments and other
            lCustLedgerEntry.Reset();
            lCustLedgerEntry.SetRange("External Document No.", AmzOrderID);
            if lCustLedgerEntry.FindSet() then
                repeat
                    Rec.Get(lCustLedgerEntry."Entry No.");
                    Rec.Mark(true);
                    FilterOnEntries := true;
                until lCustLedgerEntry.Next() = 0;

            if FilterOnEntries then begin
                Rec.MarkedOnly(true);
                //>> 14-03-20 ZY-LD 005
                //SETRANGE(Open);
                //CustLedgerEntrySaved := Rec;
                //<< 14-03-20 ZY-LD 005
                CurrPage.Update(false);
            end;
        end;
    end;

    local procedure GetExternalDocNoFromSalesLine()
    var
        lSaleInvLine: Record "Sales Invoice Line";
        lSaleCrMemoLine: Record "Sales Cr.Memo Line";
        LastRecordFound: Boolean;
    begin
        //>> 20-12-17 ZY-LD 004
        ExternalDocumentSL := '';
        if Rec."Document Type" = Rec."document type"::Invoice then begin
            lSaleInvLine.SetCurrentkey("External Document No.");
            lSaleInvLine.SetRange("Document No.", Rec."Document No.");
            lSaleInvLine.SetFilter("External Document No.", '<>%1', '');
            if lSaleInvLine.FindSet() then
                repeat
                    if ExternalDocumentSL <> '' then
                        ExternalDocumentSL := ExternalDocumentSL + ', ';
                    ExternalDocumentSL := ExternalDocumentSL + lSaleInvLine."External Document No.";
                    lSaleInvLine.SetRange("External Document No.", lSaleInvLine."External Document No.");
                    //IF NOT lSaleInvLine.FINDLAST THEN;  // 05-04-19 ZY-LD 004  15-06-20 ZY-LD 006
                    LastRecordFound := lSaleInvLine.FindLast();  // 15-06-20 ZY-LD 006
                    lSaleInvLine.SetRange("External Document No.");
                until (lSaleInvLine.Next() = 0) or (not LastRecordFound);  // 15-06-20 ZY-LD 006
        end else begin
            lSaleCrMemoLine.SetCurrentkey("External Document No.");
            lSaleCrMemoLine.SetRange("Document No.", Rec."Document No.");
            lSaleCrMemoLine.SetFilter("External Document No.", '<>%1', '');
            if lSaleCrMemoLine.FindSet() then
                repeat
                    if ExternalDocumentSL <> '' then
                        ExternalDocumentSL := ExternalDocumentSL + ', ';
                    ExternalDocumentSL := ExternalDocumentSL + lSaleCrMemoLine."External Document No.";
                    lSaleCrMemoLine.SetRange("External Document No.", lSaleCrMemoLine."External Document No.");
                    if not lSaleCrMemoLine.FindLast() then;  // 05-04-19 ZY-LD 004  // 15-06-20 ZY-LD 006
                    LastRecordFound := lSaleCrMemoLine.FindLast();  // 15-06-20 ZY-LD 006
                    lSaleCrMemoLine.SetRange("External Document No.");
                until (lSaleCrMemoLine.Next() = 0) or (not LastRecordFound);  // 15-06-20 ZY-LD 006
        end;
        //<< 20-12-17 ZY-LD 004
    end;

    local procedure GetPaymentDays(): Integer
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        //>> 09-08-18 ZY-LD 003
        if Rec."Document Type" = Rec."document type"::Invoice then begin
            CreateCustLedgEntry := Rec;
            DtldCustLedgEntry1.SetCurrentkey("Cust. Ledger Entry No.");
            DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
            DtldCustLedgEntry1.SetRange(Unapplied, false);
            if DtldCustLedgEntry1.Find('-') then
                repeat
                    if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                       DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                    then begin
                        DtldCustLedgEntry2.Init();
                        DtldCustLedgEntry2.SetCurrentkey("Applied Cust. Ledger Entry No.", "Entry Type");
                        DtldCustLedgEntry2.SetRange(
                          "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                        DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."entry type"::Application);
                        DtldCustLedgEntry2.SetRange(Unapplied, false);
                        if DtldCustLedgEntry2.Find('-') then
                            repeat
                                if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                                   DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                                then begin
                                    CustLedgEntry.SetCurrentkey("Entry No.");
                                    CustLedgEntry.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                    if CustLedgEntry.Find('-') then
                                        exit(CreateCustLedgEntry."Due Date" - CustLedgEntry."Posting Date");
                                end;
                            until DtldCustLedgEntry2.Next() = 0;
                    end else begin
                        CustLedgEntry.SetCurrentkey("Entry No.");
                        CustLedgEntry.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                        if CustLedgEntry.Find('-') then
                            exit(CreateCustLedgEntry."Due Date" - CustLedgEntry."Posting Date");
                    end;
                until DtldCustLedgEntry1.Next() = 0;
        end;
        //<< 09-08-18 ZY-LD 003
    end;
}
