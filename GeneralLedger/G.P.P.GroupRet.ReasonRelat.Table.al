Table 50108 "G.P.P. Group Ret. Reason Relat"
{
    // 001. 17-06-19 ZY-LD 2019061210000065 - New field.
    // 002. 08-09-20 ZY-LD 2020090810000109 - New field.

    Caption = 'Gen. Prod. Posting Group Return Reason Relation';

    fields
    {
        field(1; "Gen. Prod. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(2; "Return Reason Code"; Code[10])
        {
            TableRelation = "Return Reason";

            trigger OnValidate()
            begin
                CalcFields("Return Reason Description");
            end;
        }
        field(3; "Return Reason Description"; Text[100])
        {
            CalcFormula = lookup("Return Reason".Description where(Code = field("Return Reason Code")));
            Caption = 'Return Reason Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Mandatory; Boolean)
        {
            Description = '17-06-19 ZY-LD 001';
        }
        field(5; "Sales Unit Price Must be Zero"; Boolean)
        {
            Caption = 'Sales Unit Price Must be Zero';
            Description = '08-09-20 ZY-LD 002';

            trigger OnValidate()
            begin
                if "Sales Unit Price Must be Zero" then
                    "Max. Sales Unit Price" := 0;
            end;
        }
        field(6; "Max. Sales Unit Price"; Decimal)
        {
            Caption = 'Max. Sales Unit Price';
            MaxValue = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Max. Sales Unit Price" > 0 then
                    "Sales Unit Price Must be Zero" := false;
            end;
        }
    }

    keys
    {
        key(Key1; "Gen. Prod. Posting Group", "Return Reason Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
