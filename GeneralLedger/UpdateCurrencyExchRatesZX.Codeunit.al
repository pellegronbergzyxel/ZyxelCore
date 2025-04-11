codeunit 50016 UpdateCurrencyExchRatesZX
{
    trigger OnRun()
    var
        ReplicateExchangeRate: Codeunit "Replicate Exchange Rate";
        SI: Codeunit "Single Instance";

    begin
        SI.SetExchangeRateService(true);
        SI.SetDate(today);
        Codeunit.Run(Codeunit::"Update Currency Exchange Rates");
        SI.SetDate(0D);
        SI.SetExchangeRateService(false);
        Commit();
        ReplicateExchangeRate.Run();
    end;
}
