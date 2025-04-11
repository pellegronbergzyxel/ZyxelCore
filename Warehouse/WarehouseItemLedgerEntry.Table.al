Table 50116 "Warehouse Item Ledger Entry"
{
    Caption = 'Warehouse Item Ledger Entry';
    DrillDownPageID = "Whse. Item Ledger Entry";
    LookupPageID = "Whse. Item Ledger Entry";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Warehouse; Option)
        {
            Caption = 'Warehouse';
            OptionCaption = 'VCK';
            OptionMembers = VCK;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(4; "Warehouse Location Code"; Code[10])
        {
            Caption = 'Warehouse Location Code';
        }
        field(5; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(6; Bin; Code[20])
        {
            Caption = 'Bin';
        }
        field(7; Grade; Code[20])
        {
            Caption = 'Grade';
        }
        field(8; "Quanty Type"; Option)
        {
            Caption = 'Quanty Type';
            OptionCaption = 'On Hand,Blocked,Inspecting,Allocated';
            OptionMembers = "On Hand",Blocked,Inspecting,Allocated;
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(10; Date; Date)
        {
            Caption = 'Date';
        }
        field(11; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
        }
        field(68; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No.")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", Date)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Creation Date" = 0DT then
            "Creation Date" := CurrentDatetime;
    end;


    procedure GetNextEntryNo(): Integer
    var
        recWhseItemLedgerEntry: Record "Warehouse Item Ledger Entry";
    begin
        if recWhseItemLedgerEntry.FindLast then
            exit(recWhseItemLedgerEntry."Entry No." + 1)
        else
            exit(1);
    end;
}
