Codeunit 50037 "ZyXEL Customer Credit Limit"
{
    // // 11-10-17 ZY-LD 001 Filter changed from "Bill-to" to "Sell-to".
    // // 13-10-17 ZY-LD 002 Payment Terms added.
    // // 25-10-17 ZY-LD 003 Currency Code added.


    trigger OnRun()
    begin
    end;

    var
        ProgressWindow: Dialog;
        TxtRHQ: label 'ZyXEL (RHQ) Go LIVE';


    procedure AnalyseCreditLimited()
    var
        recCustomerCreditLimited: Record "Customer Credit Limited";
        recCompany: Record Company;
        recCustomer: Record Customer;
        recDefaultDimension: Record "Default Dimension";
        lPayTerms: Record "Payment Terms";
    begin
        ProgressWindow.Open('Processing Company #1#######');
        recCustomerCreditLimited.DeleteAll;
        if recCompany.FindSet then begin
            repeat
                lPayTerms.ChangeCompany(recCompany.Name);  // 13-10-17 ZY-LD 002
                recCustomer.ChangeCompany(recCompany.Name);
                recCustomer.SetRange("Related Company", false);
                if recCustomer.FindSet then begin
                    repeat
                        ProgressWindow.Update(1, recCompany.Name);
                        recCustomerCreditLimited.Reset;
                        recCustomerCreditLimited.Init;
                        recCustomerCreditLimited.Company := recCompany.Name;
                        recCustomerCreditLimited."Customer No." := recCustomer."No.";
                        recCustomerCreditLimited."Customer Name" := recCustomer.Name;
                        recCustomerCreditLimited.Category := recCustomer.Category;
                        recCustomerCreditLimited.Tier := recCustomer.Tier;
                        recCustomerCreditLimited.Status := recCustomerCreditLimited.Status::OK;
                        recCustomer.CalcFields("Balance Due (LCY)");
                        recCustomer.CalcFields("Outstanding Orders (LCY)");
                        if (recCustomer."Balance Due (LCY)" + recCustomer."Outstanding Orders (LCY)") > recCustomer."Credit Limit (LCY)" then begin
                            recCustomerCreditLimited.Status := recCustomerCreditLimited.Status::Investigate;
                        end;
                        if recCustomer."Balance Due (LCY)" > recCustomer."Credit Limit (LCY)" then begin
                            recCustomerCreditLimited.Status := recCustomerCreditLimited.Status::Warning;
                        end;
                        recCustomerCreditLimited."Credit Limit Sub (LCY)" := recCustomer."Credit Limit (LCY)";
                        recCustomerCreditLimited."Balance Due Sub (LCY)" := recCustomer."Balance Due (LCY)";
                        recCustomerCreditLimited."Outstanding Orders Sub (LCY)" := recCustomer."Outstanding Orders (LCY)";
                        recCustomerCreditLimited.Blocked := recCustomer.Blocked;
                        recCustomerCreditLimited."Outstanding Orders RHQ (LCY)" := OutstandingOrdersRHQ(recCustomer."No.", recCustomer."Global Dimension 1 Filter", recCustomer."Global Dimension 2 Filter", recCustomer."Currency Filter");
                        recDefaultDimension.ChangeCompany(recCompany.Name);
                        recDefaultDimension.SetFilter("Table ID", '18');
                        recDefaultDimension.SetFilter("No.", recCustomer."No.");
                        recDefaultDimension.SetFilter("Dimension Code", 'DIVISION');
                        if recDefaultDimension.FindFirst then recCustomerCreditLimited.Division := recDefaultDimension."Dimension Value Code";
                        recDefaultDimension.SetFilter("Table ID", '18');
                        recDefaultDimension.SetFilter("No.", recCustomer."No.");
                        recDefaultDimension.SetFilter("Dimension Code", 'COUNTRY');
                        recCustomerCreditLimited."Balance Due + Outstanding LCY" := recCustomerCreditLimited."Balance Due Sub (LCY)" + recCustomerCreditLimited."Outstanding Orders RHQ (LCY)";
                        if recDefaultDimension.FindFirst then recCustomerCreditLimited.Country := recDefaultDimension."Dimension Value Code";
                        //>> 13-10-17 ZY-LD 002
                        if recCustomer."Payment Terms Code" <> '' then
                            if lPayTerms.Get(recCustomer."Payment Terms Code") then
                                recCustomerCreditLimited."Payment Terms" := lPayTerms.Description;
                        recCustomerCreditLimited."Cust. Only Created in Sub" := TestCustomer(recCustomer."No.");
                        //<< 13-10-17 ZY-LD 002
                        recCustomerCreditLimited."Currency Code" := recCustomer."Currency Code";  // 25-10-17 ZY-LD 003
                        if recCustomerCreditLimited."Balance Due Sub (LCY)" <> 0 then begin
                            recCustomerCreditLimited.Insert;
                        end;

                    until recCustomer.Next() = 0;
                end;
            until recCompany.Next() = 0;
        end;
        ProgressWindow.Close;
    end;

    local procedure OutstandingOrdersRHQ(CustomerNo: Code[20]; ShortcutDimension1Code: Code[20]; ShortcutDimension2Code: Code[20]; CurrencyCode: Code[20]) Amount: Decimal
    var
        recSalesLine: Record "Sales Line";
    begin
        recSalesLine.ChangeCompany(TxtRHQ);
        //recSalesLine.SETFILTER("Bill-to Customer No.",CustomerNo);  // 11-10-17 ZY-LD 001
        recSalesLine.SetFilter("Sell-to Customer No.", CustomerNo);  // 11-10-17 ZY-LD 001
        recSalesLine.SetFilter("Shortcut Dimension 1 Code", ShortcutDimension1Code);
        recSalesLine.SetFilter("Shortcut Dimension 2 Code", ShortcutDimension2Code);
        recSalesLine.SetFilter("Currency Code", CurrencyCode);
        if recSalesLine.FindSet then begin
            repeat
                Amount := Amount + recSalesLine."Outstanding Amount (LCY)";
            until recSalesLine.Next() = 0;
        end;
    end;

    local procedure TestCustomer(pNo: Code[20]): Boolean
    var
        lCust: Record Customer;
    begin
        lCust.ChangeCompany(TxtRHQ);
        exit(not lCust.Get(pNo));
    end;
}
