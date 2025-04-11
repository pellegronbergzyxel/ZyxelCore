tableextension 50199 ContactZX extends Contact
{
    fields
    {
        field(50001; "Business Relation ZX"; Boolean)
        {
            CalcFormula = exist("Contact Business Relation" where("Business Relation Code" = field("Business Relation Filter")));
            Caption = 'Business Relation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Business Relation Filter"; Code[10])
        {
            Caption = 'Business Relation Filter';
            FieldClass = FlowFilter;
            TableRelation = "Contact Business Relation";
        }
        field(50003; "Company Contract"; Boolean)
        {
            CalcFormula = exist("Customer Contract" where("Customer No." = field("No.")));
            Caption = 'Company Contract';
            Description = '07-02-20 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
