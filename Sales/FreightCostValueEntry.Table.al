Table 50022 "Freight Cost Value Entry"
{
    Caption = 'Freight Cost Value Entry';
    DrillDownPageID = "Freight Cost Value Entries";
    LookupPageID = "Freight Cost Value Entries";

    fields
    {
        field(1; "Value Entry No."; Integer)
        {
            Caption = 'Value Entry No.';
        }
        field(2; "Cost Value Entry No."; Integer)
        {
            Caption = 'Cost Value Entry No.';
        }
        field(3; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
        }
        field(11; "Charge (Item)"; Code[20])
        {
            Caption = 'Charge (Item)';
            TableRelation = "Item Charge";
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(13; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 2 : 5;
        }
        field(14; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(15; "Freight Posted to G/L"; Boolean)
        {
            Caption = 'Freight Posted to G/L';
        }
        field(16; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(17; "Document Type"; Enum "Item Ledger Document Type")
        {
            CalcFormula = lookup("Value Entry"."Document Type" where("Entry No." = field("Value Entry No.")));
            Caption = 'Document Type';
            FieldClass = FlowField;
        }
        field(18; "Document No."; Code[20])
        {
            CalcFormula = lookup("Value Entry"."Document No." where("Entry No." = field("Value Entry No.")));
            Caption = 'Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Value Entry No.", "Cost Value Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
