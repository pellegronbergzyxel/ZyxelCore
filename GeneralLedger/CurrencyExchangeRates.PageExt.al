pageextension 50192 CurrencyExchangeRatesZX extends "Currency Exchange Rates"
{
    actions
    {
        addfirst(navigation)
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
                    begin
                        recCngLogEntry.SetCurrentKey("Table No.", "Date and Time");
                        recCngLogEntry.FilterGroup(2);
                        recCngLogEntry.SetRange("Table No.", Database::"Currency Exchange Rate");
                        recCngLogEntry.FilterGroup(0);
                        recCngLogEntry.SetRange("Primary Key Field 1 Value", Rec."Currency Code");
                        recCngLogEntry.SetRange("Primary Key Field 2 Value", Format(Rec."Starting Date", 0, 9));
                        Page.RunModal(Page::"Change Log Entries", recCngLogEntry);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        recCurrency.Get(Rec."Currency Code");
        if not recCurrency."Update via Exchange Rate Serv." then begin
            recCurrency."Update via Exchange Rate Serv." := true;
            recCurrency.Modify();
            UpdateCurrency := true;
        end;
    end;

    trigger OnClosePage()
    begin
        if UpdateCurrency then begin
            recCurrency.Get(Rec."Currency Code");
            recCurrency."Update via Exchange Rate Serv." := false;
            recCurrency.Modify();
        end;
    end;

    var
        recExchRateTmp: Record "Currency Exchange Rate Buffer" temporary;
        recCngLogEntry: Record "Change Log Entry";
        recCurrency: Record Currency;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ChangeHasBeenMade: Boolean;
        PrevValue: Boolean;
        UpdateCurrency: Boolean;
}
