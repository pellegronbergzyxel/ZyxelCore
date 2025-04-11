tableextension 50221 ReturnReasonZX extends "Return Reason"
{
    fields
    {
        field(50000; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            Description = '24-10-18 ZY-LD 001';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50001; "Gen. Prod. Posting Grp. Filter"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50002; "Exists for Gen. Prod. Post Grp"; Boolean)
        {
            CalcFormula = exist("G.P.P. Group Ret. Reason Relat" where("Gen. Prod. Posting Group" = field("Gen. Prod. Posting Grp. Filter"),
                                                                       "Return Reason Code" = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            Description = '24-10-18 ZY-LD 001';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50004; "Reverse Quantity"; Boolean)
        {
            Caption = 'Reverse Quantity';
            Description = '24-10-18 ZY-LD 001';
        }
        field(50005; "Use on Sales Return Order"; Boolean)
        {
            Caption = 'Use on Sales Return Order';
        }
    }
}
