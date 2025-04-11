XmlPort 50027 "HQ Exchange Rate"
{
    Caption = 'HQ Exchange Rate';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/ExchRate';
    Direction = Import;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Currency Exchange Rate"; "Currency Exchange Rate")
            {
                XmlName = 'CurrencyExchangeRate';
                UseTemporary = true;
                fieldelement(CurrencyCode; "Currency Exchange Rate"."Currency Code")
                {
                }
                fieldelement(StartDate; "Currency Exchange Rate"."Starting Date")
                {
                }
                fieldelement(ExchangeRateAmount; "Currency Exchange Rate"."Exchange Rate Amount")
                {
                }
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


    procedure GetData(var pCurrExchRateTmp: Record "Currency Exchange Rate" temporary)
    begin
        if "Currency Exchange Rate".FindSet then
            repeat
                pCurrExchRateTmp := "Currency Exchange Rate";
                pCurrExchRateTmp.Insert;
            until "Currency Exchange Rate".Next() = 0;
    end;
}
