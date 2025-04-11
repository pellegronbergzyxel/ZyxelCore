Codeunit 50003 "Replicate Exchange Rate"
{
    // 001. 29-02-24 ZY-LD 000 - This is a copy from "Currency Exchange Rate" because we need another number of digits that default.

    trigger OnRun()
    var
        RunReplication: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsRhq and ZGT.IsZComCompany then
            if not GuiAllowed then
                RunReplication := true
            else
                RunReplication := Confirm(Text001, true);

        if RunReplication then
            ReplicateExchangeRate;
    end;

    var
        Text001: label 'Do you want to replicate exchange rates?';

    local procedure ReplicateExchangeRate()
    var
        recCurr: Record Currency;
        recExchRateTmp: Record "Currency Exchange Rate Buffer" temporary;
        recCurrExchRateBuf: Record "Currency Exchange Rate Buffer" temporary;
        recCurrExchRate: Record "Currency Exchange Rate";
        recGenSetup: Record "General Ledger Setup";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        lText002: label 'There was nothing to replicate.';
        lText003: label 'Replication of %1 is done.';
        SI: Codeunit "Single Instance";
        RunReplication: Boolean;
    begin
        //>> 12-08-20 ZY-LD 001
        recGenSetup.Get;
        recCurr.SetRange(Replicate, true);  // 06-04-21 ZY-LD 002
        recCurr.SetRange(Replicated, false);
        if not GuiAllowed then
            //>> 29-04-22 ZY-LD 001
            if SI.GetWebServiceUpdate then
                recCurr.SetRange("Update via HQ Web Service", true)
            else  //<< 29-04-22 ZY-LD 001
                recCurr.SetRange("Update via Exchange Rate Serv.", true);
        /*IF pCurrCode <> '' THEN
          recCurr.SETFILTER(Code,'%1&<>%2',pCurrCode,recGenSetup."LCY Code")
        ELSE*/
        recCurr.SetFilter(Code, '<>%1', recGenSetup."LCY Code");
        if recCurr.FindSet then
            repeat
                recExchRateTmp.DeleteAll;
                recCurrExchRateBuf.DeleteAll;
                recCurrExchRate.SetRange("Currency Code", recCurr.Code);
                recCurrExchRate.FindLast;

                // Get currency info from the subsidaries and calculate
                ZyWebSrvMgt.GetExchangeInfo('', recCurr.Code, recCurrExchRateBuf);
                if recCurrExchRateBuf.FindSet then begin
                    repeat
                        recExchRateTmp.TransferFields(recCurrExchRate);
                        recExchRateTmp.Company := recCurrExchRateBuf.Company;
                        recExchRateTmp."LCY Code" := recCurrExchRateBuf."LCY Code";

                        if recCurrExchRateBuf."LCY Code" <> 'EUR' then begin
                            if recCurr.Code = recCurrExchRateBuf."LCY Code" then
                                recExchRateTmp."Currency Code" := 'EUR';
                            //>> 29-02-24 ZY-LD 001                                
                            // TODO: Maybe rewrite - maybe create own ExchangeAmount function (see original modification in table "Currency Exchange Rate").
                            //recCurrExchRate.InitExchangeRateCalculation(true);
                            recExchRateTmp."Exchange Rate Amount" := ExchangeAmount(recCurrExchRate."Relational Exch. Rate Amount", recExchRateTmp."LCY Code", recExchRateTmp."Currency Code", recExchRateTmp."Starting Date");  //<< 29-02-24 ZY-LD 001
                            recExchRateTmp."Adjustment Exch. Rate Amount" := recExchRateTmp."Exchange Rate Amount";
                        end;
                        /*recExchRateTmp."Relational Exch. Rate Amount" := recExchRateTmp."Relational Exch. Rate Amount" / recExchRateTmp."Exchange Rate Amount" * recCurrExchRateBuf."Exchange Rate Amount";
                        recExchRateTmp."Relational Adjmt Exch Rate Amt" := recExchRateTmp."Relational Exch. Rate Amount";
                        recExchRateTmp."Exchange Rate Amount" := recCurrExchRateBuf."Exchange Rate Amount";
                        recExchRateTmp."Adjustment Exch. Rate Amount" := recExchRateTmp."Exchange Rate Amount";*/
                        recExchRateTmp.Insert
                    until recCurrExchRateBuf.Next() = 0;

                    // Update the new calculation in the subsidaries.
                    if not recExchRateTmp.IsEmpty then begin
                        if not GuiAllowed then
                            RunReplication := true
                        else
                            RunReplication := Page.RunModal(Page::"Currency Exchange Rate Buffer", recExchRateTmp) = Action::LookupOK;

                        if RunReplication then begin
                            recCurr.Replicated := ZyWebSrvMgt.ReplicateExchangeRate(recExchRateTmp);
                            recCurr.Modify(true);
                            Commit;
                            Message(lText003, recCurr.Code);
                        end;
                    end else
                        Message(lText002);
                end;
            until recCurr.Next() = 0;
        //<< 12-08-20 ZY-LD 001
    end;

    local procedure ExchangeAmount(Amount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; UsePostingDate: Date): Decimal
    var
        ToCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        //>> 29-02-24 ZY-LD 001
        // Function is copied from table Currency Exchange Rate
        if (FromCurrencyCode = ToCurrencyCode) or (Amount = 0) then
            exit(Amount);

        Amount :=
          CurrExchRate.ExchangeAmtFCYToFCY(
            UsePostingDate, FromCurrencyCode, ToCurrencyCode, Amount);

        if ToCurrencyCode <> '' then begin
            ToCurrency.Get(ToCurrencyCode);

            //Amount := Round(Amount, ToCurrency."Amount Rounding Precision");
            ToCurrency.TESTFIELD("Exchange Rate Round. Precision");
            Amount := ROUND(Amount, ToCurrency."Exchange Rate Round. Precision")
        end else
            Amount := Round(Amount);

        exit(Amount);
        //<< 29-02-24 ZY-LD 001
    end;

}
