Table 50048 "VCK Inventory"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML

    DrillDownPageID = "VCK Inventory";
    LookupPageID = "VCK Inventory";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
            TableRelation = Item."No.";
        }
        field(2; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(3; Warehouse; Code[20])
        {
            Caption = 'Warehouse';
            Description = 'PAB 1.0';
        }
        field(4; Location; Code[20])
        {
            Caption = 'Location';
            Description = 'PAB 1.0';
        }
        field(5; Bin; Code[20])
        {
            Caption = 'Bin';
            Description = 'PAB 1.0';
        }
        field(6; Grade; Code[20])
        {
            Caption = 'Grade';
            Description = 'PAB 1.0';
        }
        field(7; "Quantity On Hand"; Decimal)
        {
            Caption = 'Qty. On Hand';
            Description = 'PAB 1.0';
        }
        field(8; "Quantity Blocked"; Decimal)
        {
            Caption = 'Qty. Blocked';
            Description = 'PAB 1.0';
        }
        field(9; "Quantity Inspecting"; Decimal)
        {
            Caption = 'Qty. Inspecting';
            Description = 'PAB 1.0';
        }
        field(10; "Time Stamp"; DateTime)
        {
            Caption = 'Time Stamp';
            Description = 'PAB 1.0';
        }
        field(11; "Quantity Allocated"; Decimal)
        {
            Caption = 'Qty. Allocated';
            Description = 'PAB 1.0';
        }
        field(12; "Quantity Available"; Decimal)
        {
            Caption = 'Qty. Available';
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; "Item No.", Location, Warehouse, Bin)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
