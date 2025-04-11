Codeunit 50075 "Update Curr. Exch. Rates - EOM"
{
    // // On the last date of the month, we update next day´s exchange rate in advance, so it will be visible in Precision Point.
    // 001. 25-04-22 ZY-LD 2021090310000054 - Makes it possible to run it test environment any time of the month.


    trigger OnRun()
    begin
        if ((Today = CalcDate('<CM>', Today)) and not GuiAllowed) or
           (recServerEnviron.TestEnvironment)
        then begin
            SI.SetDate(CalcDate('<1D>', Today));
            UpdateCurrencyExchangeRates.Run;
            SI.SetDate(0D);
        end;
    end;

    var
        recServerEnviron: Record "Server Environment";
        SI: Codeunit "Single Instance";
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
}
