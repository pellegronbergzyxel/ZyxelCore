pageextension 50195 CurrencyCardZX extends "Currency Card"
{
    layout
    {
        addafter("EMU Currency")
        {
            group(Control27)
            {
                ShowCaption = false;
                field("Update via Exchange Rate Serv."; Rec."Update via Exchange Rate Serv.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the tick is removed from this field, the "Exchange Rate Services" will not work for this currency.';
                }
                group(HQ)
                {
                    ShowCaption = false;
                    field("Update via HQ Web Service"; Rec."Update via HQ Web Service")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies allowance for HQ to update currency exchangerate via the web service.';
                    }
                    field("Start Date Calculation HQ"; Rec."Start Date Calculation HQ")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'At the end of a month ex. August, HQ send exchange rate update with start date 01-08-24. For RUB we only want it to update on the 01-09-24, so here you can insert a dateformula "1M" to calculate correct start date for the currency.';
                    }
                }
                field("Copy Last Months Exch. Rate"; Rec."Copy Last Months Exch. Rate")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the currency should be copied to next months exchange rate. Ex. Start Date 01-08-24 will also be inserted with start date 01-09-24. This is done due to Precision Point.';
                }
            }
            field(Replicate; Rec.Replicate)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies if the inserted exchange rate must be replicated to the subsidaries.';
            }
            field(Replicated; Rec.Replicated)
            {
                ApplicationArea = Basic, Suite;
                Editable = ReplicatedEditable;
                ToolTip = 'Specifies if the newest exchange rate has been replicated. The field is automatic set to false when a new exchange rate has been inserted.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;  // 19-05-21 ZY-LD 001
    end;

    trigger OnOpenPage()
    begin
        SetActions;  // 19-05-21 ZY-LD 001
    end;

    var
        ReplicatedEditable: Boolean;

    local procedure SetActions()
    begin
        ReplicatedEditable := Rec.Replicate;  // 19-05-21 ZY-LD 001
    end;
}
