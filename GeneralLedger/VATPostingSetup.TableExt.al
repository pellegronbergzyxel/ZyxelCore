tableextension 50160 VATPostingSetupZX extends "VAT Posting Setup"
{
    fields
    {
        field(50000; "EU Article Code"; Code[20])
        {
            Caption = 'EU Article Code';
            Description = '13-04-21 ZY-LD 004';
            TableRelation = "EU Article";
        }
        field(50001; "EU Article"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("EU Article Setup" where("VAT Bus. Posting Group" = field("VAT Bus. Posting Group"),
                                                          "VAT Prod. Posting Group" = field("VAT Prod. Posting Group")));
            Caption = 'EU Article';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
