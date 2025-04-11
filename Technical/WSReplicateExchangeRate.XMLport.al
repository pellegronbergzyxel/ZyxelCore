XmlPort 50008 "WS Replicate Exchange Rate"
{
    Caption = 'WS Replicate Exchange Rate';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/exchrate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Currency Exchange Rate Buffer"; "Currency Exchange Rate Buffer")
            {
                MinOccurs = Zero;
                XmlName = 'ExchangeRate';
                UseTemporary = true;
                fieldelement(Company; "Currency Exchange Rate Buffer".Company)
                {
                }
                fieldelement(CurrencyCode; "Currency Exchange Rate Buffer"."Currency Code")
                {
                }
                fieldelement(StartingDate; "Currency Exchange Rate Buffer"."Starting Date")
                {
                }
                fieldelement(ExchangeRangeAmount; "Currency Exchange Rate Buffer"."Exchange Rate Amount")
                {
                }
                fieldelement(AdjExchRangeAmount; "Currency Exchange Rate Buffer"."Adjustment Exch. Rate Amount")
                {
                }
                fieldelement(RelationalCurrencyCode; "Currency Exchange Rate Buffer"."Relational Currency Code")
                {
                }
                fieldelement(RelExchRateAmount; "Currency Exchange Rate Buffer"."Relational Exch. Rate Amount")
                {
                }
                fieldelement(FixExchRateAmount; "Currency Exchange Rate Buffer"."Fix Exchange Rate Amount")
                {
                }
                fieldelement(RelAdjExchRateAmount; "Currency Exchange Rate Buffer"."Relational Adjmt Exch Rate Amt")
                {
                }
                fieldelement(LCYCode; "Currency Exchange Rate Buffer"."LCY Code")
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


    procedure SetData_Replication(var pExchRateTmp: Record "Currency Exchange Rate Buffer" temporary)
    begin
        "Currency Exchange Rate Buffer" := pExchRateTmp;
        "Currency Exchange Rate Buffer".Insert;
    end;


    procedure SetData_Response()
    var
        recCurrency: Record Currency;
        recCurrExchRate: Record "Currency Exchange Rate";
        recGenSetup: Record "General Ledger Setup";
        CurrencyCode: Code[10];
    begin
        "Currency Exchange Rate Buffer".FindFirst;
        CurrencyCode := "Currency Exchange Rate Buffer"."Currency Code";
        "Currency Exchange Rate Buffer".DeleteAll;

        if recCurrency.Get(CurrencyCode) and (not recCurrency."Block Autom. Currency Update") then begin
            recGenSetup.Get;
            recCurrExchRate.SetRange("Currency Code", CurrencyCode);
            if not recCurrExchRate.FindLast then
                recCurrExchRate."Exchange Rate Amount" := 100;

            "Currency Exchange Rate Buffer".Company := CompanyName();
            "Currency Exchange Rate Buffer"."Currency Code" := CurrencyCode;
            "Currency Exchange Rate Buffer"."LCY Code" := recGenSetup."LCY Code";
            "Currency Exchange Rate Buffer"."Exchange Rate Amount" := recCurrExchRate."Exchange Rate Amount";
            "Currency Exchange Rate Buffer".Insert;
        end;
    end;


    procedure SetData_Request(pCurrencyCode: Code[10])
    begin
        "Currency Exchange Rate Buffer"."Currency Code" := pCurrencyCode;
        "Currency Exchange Rate Buffer".Insert;
    end;


    procedure ReplicateData()
    var
        recGenSetup: Record "General Ledger Setup";
        recCurrency: Record Currency;
        recExchRate: Record "Currency Exchange Rate";
    begin
        recGenSetup.Get;
        recGenSetup.TestField("LCY Code");

        if "Currency Exchange Rate Buffer".FindSet then
            repeat
                if recCurrency.Get("Currency Exchange Rate Buffer"."Currency Code") then
                    if recExchRate.Get("Currency Exchange Rate Buffer"."Currency Code", "Currency Exchange Rate Buffer"."Starting Date") then begin
                        recExchRate.TransferFields("Currency Exchange Rate Buffer");
                        recExchRate.Modify(true);
                    end else begin
                        recExchRate.TransferFields("Currency Exchange Rate Buffer");
                        recExchRate.Insert(true);
                    end;
            until "Currency Exchange Rate Buffer".Next() = 0;
    end;
}
