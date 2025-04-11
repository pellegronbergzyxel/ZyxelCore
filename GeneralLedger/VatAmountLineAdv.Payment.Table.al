Table 75064 "Vat Amount Line Adv. Payment"
{
    //       //EZ4.20: Sales advanced payment;
    //       //EZ4.30: Purchase advanced payment;


    fields
    {
        field(1; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(9; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(10; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(15; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(16; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(30; "VAT Base (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base (LCY)';
            Editable = false;
        }
        field(35; "VAT Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount (LCY)';
        }
        field(40; "Amount Including VAT (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(50; "VAT Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base';
            Editable = false;
        }
        field(55; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(60; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(100; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(150; "Sales Adv. Payment Usage Code"; Code[10])
        {
            Caption = 'Sales Adv. Payment Usage Code';
        }
    }

    keys
    {
        key(Key1; "VAT Prod. Posting Group")
        {
            Clustered = true;
        }
        key(Key2; Positive)
        {
        }
        key(Key3; Priority)
        {
        }
    }

    fieldgroups
    {
    }


    procedure InsertLine()
    var
        lreVATAmountLine: Record "Vat Amount Line Adv. Payment";
    begin
        if not (("VAT Base (LCY)" = 0) and ("VAT Amount (LCY)" = 0)) then begin
            lreVATAmountLine := Rec;
            if Find then begin
                "VAT Base (LCY)" := "VAT Base (LCY)" + lreVATAmountLine."VAT Base (LCY)";
                "VAT Amount (LCY)" := "VAT Amount (LCY)" + lreVATAmountLine."VAT Amount (LCY)";
                "Amount Including VAT (LCY)" := "VAT Base (LCY)" + "VAT Amount (LCY)";
                Modify;
            end else begin
                "Amount Including VAT (LCY)" := "VAT Base (LCY)" + "VAT Amount (LCY)";
                Insert;
            end;
        end;
    end;
}
