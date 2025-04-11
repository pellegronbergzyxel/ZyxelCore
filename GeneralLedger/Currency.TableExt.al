tableextension 50102 CurrencyZX extends Currency
{
    fields
    {
        field(50000; "Block Autom. Currency Update"; Boolean)
        {
            Caption = 'Block Automatic Currency Update';
            Description = '02-07-20 ZY-LD 001';
        }
        field(50001; "Exchange Rate Round. Precision"; Decimal)
        {
            Caption = 'Exchange Rate Rounding Precision';
            DecimalPlaces = 2 : 9;
            Description = '02-07-20 ZY-LD 001';
            InitValue = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec."Amount Rounding Precision" <> 0 then
                    Rec."Invoice Rounding Precision" := Round(Rec."Invoice Rounding Precision", Rec."Amount Rounding Precision");
            end;
        }
        field(50002; Replicated; Boolean)
        {
            BlankZero = true;
            Caption = 'Replicated';
            Description = '02-07-20 ZY-LD 001';
        }
        field(50003; "Update via Exchange Rate Serv."; Boolean)
        {
            Caption = 'Update via Exchange Rate Services';
            Description = '26-02-21 ZY-LD 002';
            InitValue = true;

            trigger OnValidate()
            begin
                //>> 31-03-22 ZY-LD 004
                if Rec."Update via Exchange Rate Serv." then
                    Rec."Copy Last Months Exch. Rate" := false;
                //<< 31-03-22 ZY-LD 004
            end;
        }
        field(50004; Replicate; Boolean)
        {
            Caption = 'Replicate Exchange Rate';
            Description = '06-04-21 ZY-LD 003';
        }
        field(50005; "Copy Last Months Exch. Rate"; Boolean)
        {
            Caption = 'Copy Last Months Exch. Rate at End of Month';
            Description = '31-03-22 ZY-LD 004';

            trigger OnValidate()
            begin
                //>> 31-03-22 ZY-LD 004
                if Rec."Copy Last Months Exch. Rate" then
                    Rec."Update via Exchange Rate Serv." := false;
                //<< 31-03-22 ZY-LD 004
            end;
        }
        field(50006; "Update via HQ Web Service"; Boolean)
        {
            Caption = 'Update via HQ Web Service';
            Description = '26-04-22 ZY-LD 005';

            trigger OnValidate()
            begin
                //>> 26-04-22 ZY-LD 005
                if Rec."Update via HQ Web Service" then
                    Rec."Update via Exchange Rate Serv." := false;
                //<< 26-04-22 ZY-LD 005
            end;
        }
        field(50007; "Start Date Calculation HQ"; DateFormula)  // 06-09-24 ZY-LD 000
        {
            Caption = 'Start Date Calculation - Web Service';
        }
    }
}
