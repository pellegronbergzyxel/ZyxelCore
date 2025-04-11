tableextension 50148 VATAmountLineZX extends "VAT Amount Line"
{
    fields
    {
        field(62000; "VAT Base (LCY)"; Decimal)
        {
            Description = 'CO4.20';
        }
        field(62001; "VAT Amount (LCY)"; Decimal)
        {
            Description = 'CO4.20';
        }
        field(62002; "Amount Including VAT (LCY)"; Decimal)
        {
            Description = 'CO4.20';
        }
        field(62003; "Currency Code"; Code[10])
        {
            Description = 'CO4.20';
        }
        field(62004; "VAT Amount Difference (LCY)"; Decimal)
        {
            Description = 'CO4.20';
        }
        field(62005; "External VAT Amount (LCY)"; Decimal)
        {
            Description = 'CO4.20';
        }
    }
}
