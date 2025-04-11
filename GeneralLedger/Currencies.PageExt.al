pageextension 50103 CurrenciesZX extends Currencies
{
    layout
    {
        addafter(ExchangeRateAmt)
        {
            field(Control37; Rec.Replicate)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The field decides whether the currency can be replicated or not.';
            }
            field(Replicated; Rec.Replicated)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The field shows whether the the currency has been replicated or not.';
            }
        }
        addafter(CurrencyFactor)
        {
            field("Block Autom. Currency Update"; Rec."Block Autom. Currency Update")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Exchange Rate Round. Precision"; Rec."Exchange Rate Round. Precision")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addafter(UpdateExchangeRates)
        {
            action(UpdateExchangeRatesDate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Exchange Rates on a Selected Date';
                Image = UpdateXML;
            }
            group(Replicate)
            {
                Caption = 'Replicate';
                action("Replicate Exchange Rates")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replicate Exchange Rates';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        ReplicateExchangeRate.Run;  // 12-08-20 ZY-LD 001
                    end;
                }
            }
        }
        addafter(ActionGroupCRM)
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
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(4));
                }
            }
            action("Replication Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Replication Setup';
                Image = Setup;

                trigger OnAction()
                begin
                    ReplicationSetup;  // 12-08-20 ZY-LD 001
                end;
            }
        }
    }

    var
        ReplicateExchangeRate: Codeunit "Replicate Exchange Rate";

    local procedure ReplicationSetup()
    var
        pageRepSetup: Page "Replication Setup";
    begin
        //>> 12-08-20 ZY-LD 001
        pageRepSetup.InitPage(1);
        pageRepSetup.RunModal;
        //<< 12-08-20 ZY-LD 001
    end;
}
