codeunit 50025 "Update Curr. Exchange Rates ZX"
{
    trigger OnRun()
    var
        SI: Codeunit "Single Instance";
        ReplicateExchangeRate: Codeunit "Replicate Exchange Rate";
    begin
        SI.SetExchangeRateService(true);
        Codeunit.Run(Codeunit::"Update Currency Exchange Rates");
        SI.SetExchangeRateService(false);
        //>> 14-04-21 ZY-LD 011
        Commit();
        ReplicateExchangeRate.Run;
        //<< 14-04-21 ZY-LD 011
    end;
}
