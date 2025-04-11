Table 60005 "Excel Report Header"
{
    Caption = 'Excel Report Header';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "User Filter"; Code[50])
        {
            Caption = 'User Filter';
            FieldClass = FlowFilter;
        }
        field(12; "User Permission"; Code[50])
        {
            CalcFormula = lookup("Excel Report Permission"."User ID" where("Excel Report Code" = field(Code),
                                                                            "User ID" = field("User Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Number of Columns"; Integer)
        {
            CalcFormula = count("Excel Report Line" where("Excel Report Code" = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        recExRepLine.SetRange("Excel Report Code", Code);
        if recExRepLine.IsEmpty then begin
            recExRepLine."Excel Report Code" := Code;
            recExRepLine.Validate("Column No.", 1);
            if not recExRepLine.Insert then;
        end;
    end;

    var
        recExRepLine: Record "Excel Report Line";
}
