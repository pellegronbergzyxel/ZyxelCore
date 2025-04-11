Table 50057 "LMR Open RMAs"
{
    //DrillDownPageID = "LMR Open Tickets";
    //LookupPageID = "LMR Open Tickets";

    fields
    {
        field(1; UID; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(2; "Ticket ID"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(3; "Job Reference"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(4; "10 Days Overdue"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(5; "Item No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Item."No.";
        }
        field(6; Description; Text[250])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(7; "ZyXEL Item"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(8; "Serial No."; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(9; "Delivery Name"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(10; "Delivery Address 1"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(11; "Delivery Address 2"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(12; "Delivery Address 3"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(13; "Delivery Address 4"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(14; "Delivery Address 5"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(15; "Delivery Address 6"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(17; Outstanding; Decimal)
        {
            BlankZero = true;
            Description = 'PAB 1.0';
        }
        field(18; Filename; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(19; "Time Stamp"; DateTime)
        {
            Description = 'PAB 1.0';
        }
        field(20; "Last Action Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(21; "Country Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Country/Region".Code;
        }
        field(22; "Country Name"; Text[100])
        {
            CalcFormula = lookup("Country/Region".Name where(Code = field("Country Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(23; "Location Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Location.Code;
        }
        field(24; "Location Name"; Text[100])
        {
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50000; "RMA DE"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA DE')));
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50001; "RMA IT"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA IT')));
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50003; "RMA SE"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA SE')));
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50004; "RMA UK"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA UK')));
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
            InitValue = 0;
        }
        field(50005; "RMA TR"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  "Location Code" = const('RMA TR')));
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
            InitValue = 0;
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
