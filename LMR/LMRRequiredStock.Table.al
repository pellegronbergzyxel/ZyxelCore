Table 50058 "LMR Required Stock"
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
            FieldClass = FlowField;
        }
        field(4; "ZyXEL Item"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(5; Quantity; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(6; "Time Stamp"; DateTime)
        {
            Description = 'PAB 1.0';
        }
        field(7; Filename; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(8; Processed; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(9; "Country Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";
        }
        field(10; "Country Name"; Text[50])
        {
            CalcFormula = lookup("Country/Region".Name where(Code = field("Country Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(11; "Location Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(12; "Location Name"; Text[100])
        {
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(13; "EU2 Inventory"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('VCK ZNET')));
            Caption = 'Qty. on Hand';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(14; "RMA DE Inventory"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA DE')));
            Caption = 'RMA DE';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(15; "RMA SE Inventory"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA SE')));
            Caption = 'RMA SE';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(16; "RMA UK Inventory"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA UK')));
            Caption = 'RMA UK';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(17; "RMA IT Inventory"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA IT')));
            Caption = 'RMA IT';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(18; "RMA TR Inventory"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA TR')));
            Caption = 'RMA TR';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
