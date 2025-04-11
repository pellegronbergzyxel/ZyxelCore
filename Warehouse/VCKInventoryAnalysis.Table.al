Table 50049 "VCK Inventory Analysis"
{
    // 001. 03-04-18 ZY-LD 2018040310000042 - New field.
    // 002. 01-11-18 ZY-LD 000 - New fields.
    // 003. 08-12-20 ZY-LD 2020120710000122 - New field.


    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(2; Description; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Description';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(3; Location; Code[20])
        {
            Caption = 'Location';
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(4; Warehouse; Code[20])
        {
            Caption = 'Warehouse';
            Description = 'PAB 1.0';
        }
        field(5; Bin; Code[20])
        {
            CalcFormula = lookup("VCK Inventory".Bin where("Item No." = field("Item No.")));
            Caption = 'Bin';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(6; Grade; Code[20])
        {
            CalcFormula = lookup("VCK Inventory".Grade where("Item No." = field("Item No.")));
            Caption = 'Bin';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(7; "Quantity On Hand ZyXEL"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity On Hand ZyXEL';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
        }
        field(8; "Quantity On Hand VCK"; Decimal)
        {
            BlankZero = true;
            CalcFormula = lookup("VCK Inventory"."Quantity Available" where("Item No." = field("Item No."),
                                                                             Warehouse = field(Warehouse),
                                                                             Location = field(Location)));
            Caption = 'Quantity On Hand VCK';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(11; Updated; DateTime)
        {
            CalcFormula = lookup("VCK Inventory"."Time Stamp" where("Item No." = field("Item No.")));
            Caption = 'Updated';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(12; Reason; Code[10])
        {
            Caption = 'Reason';
            Description = 'PAB 1.0';
            TableRelation = "VCK Inventory Reason Change".Code;
        }
        field(13; UID; Integer)
        {
            AutoIncrement = false;
            Caption = 'UID';
            Description = 'PAB 1.0';
        }
        field(14; "Time Stamp"; DateTime)
        {
            Caption = 'Time Stamp';
            Description = 'PAB 1.0';
        }
        field(15; Delta; Decimal)
        {
            BlankZero = true;
            Caption = 'Delta';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
        }
        field(16; "Additional Item"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Additional Item" where("Additional Item No." = field("Item No.")));
            Description = '03-04-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Quantity Item Ledger Entry"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity Item Ledger Entry';
            DecimalPlaces = 0 : 0;
            Description = '01-11-18 ZY-LD 002';
        }
        field(18; "Quantity Delivery Document"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity Delivery Document';
            DecimalPlaces = 0 : 0;
            Description = '01-11-18 ZY-LD 002';
        }
        field(19; "Quantity Invoice Received"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity Invoice Received';
            DecimalPlaces = 0 : 0;
            Description = '01-11-18 ZY-LD 002';
        }
        field(20; "Unit Cost"; Decimal)
        {
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("Item No.")));
            Caption = 'Unit Cost';
            Description = '08-12-20 ZY-LD 003';
            Editable = false;
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
