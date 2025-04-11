Codeunit 62009 "Customer Credit Limit Check"
{
    // 
    // 001.  DT1.01  01-07-2010  SH
    //  .Documention for tectura customasation
    //  .Object created

    Permissions = tabledata "Sales & Receivables Setup" = r,
                  tabledata Customer = r,
                  tabledata "Sales Line" = r;


    trigger OnRun()
    begin
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        CMSG000: label 'Over credit or over due!\Release this order?';
        CMSG001: label 'Over credit or over due!\Post this order?';


    procedure CheckCreditLimit(NewCustNo: Code[20]; CheckOverDueBalance: Boolean; var Balance: Decimal; var DueBalance: Decimal; var CreditLimit: Decimal; OrderAmountThisOrderLCY: Decimal) CheckOK: Boolean
    var
        //CurrExchRate: Record "Currency Exchange Rate";
        OrderAmount: Decimal;
    begin
        CheckOK := true;
        SalesSetup.Get;
        if NewCustNo = '' then
            exit;

        Clear(Customer);
        Customer.Reset;
        if Customer.Get(NewCustNo) then begin
            Customer.SetRange("No.", Customer."No.");
            CreditLimit := Customer."Credit Limit (LCY)";
            Balance := CalcCreditLimitLCY(OrderAmountThisOrderLCY);
            CalcOverdueBalanceLCY;
            DueBalance := Customer."Balance Due (LCY)";

            if SalesSetup."Credit Warnings" in
               [SalesSetup."credit warnings"::"Both Warnings",
                SalesSetup."credit warnings"::"Credit Limit"]
            then begin
                if (Balance > Customer."Credit Limit (LCY)") and
                    (Customer."Credit Limit (LCY)" <> 0) then begin
                    CheckOK := false;
                end;
            end;
            if CheckOverDueBalance and
               (SalesSetup."Credit Warnings" in
                 [SalesSetup."credit warnings"::"Both Warnings",
                 SalesSetup."credit warnings"::"Overdue Balance"])
            then begin
                if DueBalance > 0 then begin
                    CheckOK := false;
                end;
            end;
        end;
    end;

    local procedure CalcCreditLimitLCY(OrderAmountThisOrderLCY: Decimal) CustCreditAmountLCY: Decimal
    var
        OutstandingRetOrdersLCY: Decimal;
        RcdNotInvdRetOrdersLCY: Decimal;
        OrderAmountTotalLCY: Decimal;
        ShippedRetRcdNotIndLCY: Decimal;
    // OrderAmountThisOrderLCY: Decimal;
    begin
        if Customer.GetFilter("Date Filter") = '' then
            Customer.SetFilter("Date Filter", '..%1', WorkDate);
        Customer.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)");
        CalcReturnAmounts(OutstandingRetOrdersLCY, RcdNotInvdRetOrdersLCY, Customer."No.");
        // 493767 >>
        //  OrderAmountTotalLCY := Customer."Outstanding Orders (LCY)" - OutstandingRetOrdersLCY;
        // 493767 <<
        ShippedRetRcdNotIndLCY := Customer."Shipped Not Invoiced (LCY)" - RcdNotInvdRetOrdersLCY;
        // OrderAmountThisOrderLCY := 0;
        CustCreditAmountLCY := Customer."Balance (LCY)" +
          (Customer."Shipped Not Invoiced (LCY)" - RcdNotInvdRetOrdersLCY) +
          OrderAmountTotalLCY + OrderAmountThisOrderLCY;
    end;

    local procedure CalcOverdueBalanceLCY()
    begin
        if Customer.GetFilter("Date Filter") = '' then
            Customer.SetFilter("Date Filter", '..%1', WorkDate);
        Customer.CalcFields("Balance Due (LCY)");
    end;

    local procedure CalcReturnAmounts(var OutstandingRetOrdersLCY2: Decimal; var RcdNotInvdRetOrdersLCY2: Decimal; "CustomerNo.": Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Type", "Bill-to Customer No.", "Currency Code");
        SalesLine.SetRange("Document Type", SalesLine."document type"::"Return Order");
        SalesLine.SetRange("Bill-to Customer No.", "CustomerNo.");
        SalesLine.CalcSums("Outstanding Amount (LCY)", "Return Rcd. Not Invd. (LCY)");
        OutstandingRetOrdersLCY2 := SalesLine."Outstanding Amount (LCY)";
        RcdNotInvdRetOrdersLCY2 := SalesLine."Return Rcd. Not Invd. (LCY)";
    end;


    procedure ReleaseWithCreditCheck(var SOHeader: Record "Sales Header")
    var
        SalesOrderRelease: Codeunit "Release Sales Document";
        Balance: Decimal;
        BalanceDue: Decimal;
        Credit: Decimal;
        Permission: Codeunit "HQ Sales Document Download";
    begin
        if CheckCreditLimit(SOHeader."Bill-to Customer No.", true, Balance, BalanceDue, Credit, SOHeader.TotalOutstandingamount() + CalculateReleaseAmountOtherSO(SOHeader)) then begin
            SalesOrderRelease.PerformManualRelease(SOHeader);
        end else begin
            if Confirm(CMSG000, true) then begin
                Permission.Run;
                SalesOrderRelease.PerformManualRelease(SOHeader);
            end;
        end;
    end;


    procedure PostWithCreditCheck(var SOHeader: Record "Sales Header") ExistFunction: Boolean
    var
        SalesOrderRelease: Codeunit "Release Sales Document";
        Balance: Decimal;
        BalanceDue: Decimal;
        Credit: Decimal;
        Permission: Codeunit "HQ Sales Document Download";
    begin
        ExistFunction := false;
        if CheckCreditLimit(SOHeader."Bill-to Customer No.", true, Balance, BalanceDue, Credit, SOHeader.TotalOutstandingamount() + CalculateReleaseAmountOtherSO(SOHeader)) then begin
        end else begin
            if Confirm(CMSG001, true) then begin
                Permission.Run;
            end else begin
                ExistFunction := true;
            end;
        end;
    end;

    procedure CalculateReleaseAmountOtherSO(Salesheader: record "Sales Header"): Decimal
    var
        salesheaderOther: Record "Sales Header";
        Amt: Decimal;
    begin
        salesheaderOther.setrange("Document Type", salesheaderOther."Document Type"::Order);
        salesheaderOther.setfilter("No.", '<>%', Salesheader."No.");
        if salesheaderOther.findset then
            repeat
                Amt := Amt + salesheaderOther.TotalOutstandingamount();
            until salesheaderOther.next = 0;
        exit(Amt);

    end;
}
