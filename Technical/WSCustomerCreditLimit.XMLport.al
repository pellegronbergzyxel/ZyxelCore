XmlPort 50047 "WS Customer Credit Limit"
{
    Caption = 'WS Customer Credit Limit';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/GetCreditLimit';
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement(Customer; Customer)
            {
                CalcFields = "Balance (LCY)";
                MinOccurs = Zero;
                XmlName = 'Customer';
                UseTemporary = true;
                fieldelement(No; Customer."No.")
                {
                }
                fieldelement(Name; Customer.Name)
                {
                }
                fieldelement(Category; Customer.Category)
                {
                }
                fieldelement(Tier; Customer.Tier)
                {
                }
                fieldelement(BalanceDueLCY; Customer."Balance Due (LCY)")
                {
                }
                textelement(BalanceDueEUR)
                {
                }
                fieldelement(CreditLimitLCY; Customer."Credit Limit (LCY)")
                {
                }
                textelement(CreditLimitEUR)
                {
                }
                fieldelement(Blocked; Customer.Blocked)
                {
                }
                fieldelement(DivisionDim; Customer."Global Dimension 1 Code")
                {
                }
                textelement(CountryDim)
                {
                }
                fieldelement(CurrencyCode; Customer."Currency Code")
                {
                }
                textelement(PaymentTerms)
                {
                }
                textelement(CurrentExchangeRate)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PaymentTerms := '';
                    if Customer."Payment Terms Code" <> '' then
                        if recPayTerms.Get(Customer."Payment Terms Code") then
                            PaymentTerms := recPayTerms.Description;

                    Customer.CalcFields("Balance Due (LCY)");
                    GlSetup.Get;
                    if GlSetup."LCY Code" <> 'EUR' then begin
                        CurrExchRate.GetLastestExchangeRate('EUR', CurrDate, CurrRate);
                        if CurrRate = 0 then
                            CurrRate := 1;
                        CreditLimitEUR := Format(ROUND(Customer."Credit Limit (LCY)" / CurrRate), 0, 9);
                        BalanceDueEUR := Format(ROUND(Customer."Balance Due (LCY)" / CurrRate), 0, 9);
                        CurrentExchangeRate := Format(CurrRate);
                    end else begin
                        CreditLimitEUR := Format(ROUND(Customer."Credit Limit (LCY)"), 0, 9);
                        BalanceDueEUR := Format(ROUND(Customer."Balance Due (LCY)"), 0, 9);
                        CurrentExchangeRate := '0';
                    end;

                    CountryDim := '';
                    if recDefDim.Get(Database::Customer, Customer."No.", GlSetup."Shortcut Dimension 3 Code") then
                        CountryDim := recDefDim."Dimension Value Code";
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
        recPayTerms: Record "Payment Terms";
        CurrExchRate: Record "Currency Exchange Rate";
        GlSetup: Record "General Ledger Setup";
        recDefDim: Record "Default Dimension";
        CurrDate: Date;
        CurrRate: Decimal;
        NewAmount: Decimal;

    procedure SetData()
    var
        Cust: Record Customer;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsZNetCompany then begin
            if ZGT.CompanyNameIs(11) or ZGT.TurkishServer then  // ZyND DE |ZyND TR
                Cust.SetRange("No.", '200000', '299999')
        end else
            Cust.SetFilter("No.", '<%1|>%2', '200000', '299999');
        Cust.SetFilter("Balance Due (LCY)", '<>0');
        Cust.SetRange("Related Company", false);
        if Cust.FindSet then
            repeat
                Customer := Cust;
                Customer.Insert;
            until Cust.Next = 0;
    end;
}
