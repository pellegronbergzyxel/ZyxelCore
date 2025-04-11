Table 50031 "EU Article Setup"
{
    Caption = 'EU Article Setup';
    DrillDownPageID = "EU Article Setup";
    LookupPageID = "EU Article Setup";

    fields
    {
        field(1; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(2; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(3; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(11; "EU Article Code"; Code[20])
        {
            Caption = 'EU Article Code';
            TableRelation = "EU Article";

            trigger OnValidate()
            begin
                CalcFields("EU Article Description");
            end;
        }
        field(12; "EU Article Description"; Text[150])
        {
            CalcFormula = lookup("EU Article".Description where(Code = field("EU Article Code")));
            Caption = 'EU Article Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "VAT Bus. Posting Group", "VAT Prod. Posting Group", "EU 3-Party Trade")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
