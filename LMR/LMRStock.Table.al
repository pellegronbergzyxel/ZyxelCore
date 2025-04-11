Table 50056 "LMR Stock"
{

    fields
    {
        field(1; UID; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(2; "Item No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(3; Description; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "ZyXEL Item"; Boolean)
        {
            CalcFormula = exist(Item where("No." = field("Item No.")));
            Caption = 'ZyXEL Item';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(5; Quantity; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(6; Bin; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"),
                                            "Item Filter" = field("Item No."));

            trigger OnValidate()
            begin
                if Bin = '' then
                    Bin := Text001;
            end;
        }
        field(7; Filename; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(8; "Time Stamp"; DateTime)
        {
            Description = 'PAB 1.0';
        }
        field(9; Processed; Boolean)
        {
            Description = 'PAb 1.0';
        }
        field(10; "Country Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                if "Country Code" = 'GB' then
                    "Country Code" := 'UK';

                Validate("Location Code", Text002 + "Country Code");
            end;
        }
        field(11; "Country Name"; Text[50])
        {
            CalcFormula = lookup("Country/Region".Name where(Code = field("Country Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(12; "Location Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(13; "Location Name"; Text[100])
        {
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(14; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
        key(Key2; Open)
        {
        }
        key(Key3; Processed)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if UID = 0 then
            if recLMRStock.FindLast then
                UID := recLMRStock.UID + 1
            else
                UID := 1;
    end;

    var
        Text001: label 'UNKNOWN';
        Text002: label 'RMA ';
        recLMRStock: Record "LMR Stock";
}
