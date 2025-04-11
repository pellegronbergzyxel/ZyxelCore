Table 76127 "Curr. Exch. Rate Country Fill"
{
    //       //CO4.20: Controling - Basic: Firm Registration More Country;

    fields
    {
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if "Currency Code" = "Relational Currency Code" then
                    Error(
                      gtcText000, FieldCaption("Currency Code"), FieldCaption("Relational Currency Code"));
            end;
        }
        field(20; "Performance Country Code"; Code[10])
        {
            Caption = 'Performance Country Code';
            NotBlank = true;
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                lreRegistrationCountry: Record "Registration Country";
            begin
                lreRegistrationCountry.Get(0, '', "Performance Country Code");
                lreRegistrationCountry.TestField("Currency Code (Local)", "Relational Currency Code");
            end;
        }
        field(30; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;
        }
        field(40; "Exchange Rate Amount"; Decimal)
        {
            Caption = 'Exchange Rate Amount';
            DecimalPlaces = 1 : 6;
            MinValue = 0;
        }
        field(50; "Relational Currency Code"; Code[10])
        {
            Caption = 'Relational Currency Code';
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            var
                lreRegistrationCountry: Record "Registration Country";
            begin
                if "Currency Code" = "Relational Currency Code" then
                    Error(
                      gtcText000, FieldCaption("Currency Code"), FieldCaption("Relational Currency Code"));
                if "Performance Country Code" <> '' then begin
                    lreRegistrationCountry.Get(0, '', "Performance Country Code");
                    lreRegistrationCountry.TestField("Currency Code (Local)", "Relational Currency Code");
                end;
            end;
        }
        field(60; "Relational Exch. Rate Amount"; Decimal)
        {
            Caption = 'Relational Exch. Rate Amount';
            DecimalPlaces = 1 : 6;
            MinValue = 0;
        }
        field(70; "Fix Exchange Rate Amount"; Option)
        {
            Caption = 'Fix Exchange Rate Amount';
            OptionCaption = 'Currency,Relational Currency,Both';
            OptionMembers = Currency,"Relational Currency",Both;
        }
        field(80; "Intrastat Rel.Exch.Rate Amt."; Decimal)
        {
            Caption = 'Intrastat Relational Exch. Rate Amount';
            DecimalPlaces = 1 : 6;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Currency Code", "Performance Country Code", "Starting Date")
        {
            Clustered = true;
        }
        key(Key2; "Relational Currency Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        greCurrencyExchRate: array[2] of Record "Curr. Exch. Rate Country Fill";
        greGLSetup: Record "General Ledger Setup";
        gcoCurrencyCode2: array[2] of Code[10];
        gdeCurrencyFactor: Decimal;
        gdaDate2: array[2] of Date;
        gtcText000: label 'The currency code in the %1 field and the %2 field cannot be the same.';


    procedure ExchangeRateCountryFill(Date: Date; CurrencyCode: Code[10]; RelCurrencyCode: Code[10]): Decimal
    begin
        FindCurrency(Date, CurrencyCode, RelCurrencyCode, 1);
        TestField("Exchange Rate Amount");
        TestField("Relational Exch. Rate Amount");
        gdeCurrencyFactor := "Exchange Rate Amount" / "Relational Exch. Rate Amount";
        exit(gdeCurrencyFactor);
    end;


    procedure FindCurrency(ldaDate: Date; lcoCurrencyCode: Code[10]; lcoRelCurrencyCode: Code[10]; linCacheNo: Integer)
    begin
        if (gcoCurrencyCode2[linCacheNo] = lcoCurrencyCode) and (gdaDate2[linCacheNo] = ldaDate) then
            Rec := greCurrencyExchRate[linCacheNo]
        else begin
            greCurrencyExchRate[linCacheNo].SetRange("Relational Currency Code", lcoRelCurrencyCode);
            greCurrencyExchRate[linCacheNo].SetRange("Currency Code", lcoCurrencyCode);
            greCurrencyExchRate[linCacheNo].SetRange("Starting Date", 0D, ldaDate);
            greCurrencyExchRate[linCacheNo].Find('+');
            Rec := greCurrencyExchRate[linCacheNo];
            gcoCurrencyCode2[linCacheNo] := lcoCurrencyCode;
            gdaDate2[linCacheNo] := ldaDate;
        end;
    end;


    procedure CurrExchRateCountry(ldeAmount: Decimal; lreVATEntry: Record "VAT Entry"; RelCurrencyCode: Code[10]): Decimal
    begin
        //15-51643 - lreVATEntry."Currency Code" - NO SUCH FIELD.
        //IF lreVATEntry."Currency Code" <> '' THEN
        //   ldeAmount := ldeAmount * lreVATEntry."Currency Factor";
        //IF lreVATEntry."Currency Code" <> RelCurrencyCode THEN BEGIN
        //  FindCurrency(lreVATEntry."Posting Date",lreVATEntry."Currency Code",RelCurrencyCode,1);
        //  TESTFIELD("Exchange Rate Amount");
        //  TESTFIELD("Relational Exch. Rate Amount");
        //  ldeAmount:= ldeAmount * "Relational Exch. Rate Amount" / "Exchange Rate Amount";
        //END;
        //EXIT(ldeAmount);
        //15-51643 +
    end;
}
