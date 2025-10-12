Table 50015 "Whse. Stock Corr. Led. Entry"
{
    Caption = 'Whse. Stock Corr. Led. Entry';
    DrillDownPageID = "Whse. Stock Corr. Led. Entries";
    LookupPageID = "Whse. Stock Corr. Led. Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Message No."; Code[10])
        {
            Caption = 'Message No.';
        }
        field(3; "Customer Message No."; Code[10])
        {
            Caption = 'Customer Message No.';
        }
        field(4; Project; Code[10])
        {
            Caption = 'Project';
        }
        field(5; "Cost Center"; Code[10])
        {
            Caption = 'Cost Center';
        }
        field(6; "Posting Type"; Option)
        {
            Caption = 'Posting Type';
            OptionMembers = " ",Move,Correction;
        }
        field(7; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Warehouse Reason Code ZY";
        }
        field(8; "System Date"; DateTime)
        {
            Caption = 'System Date';
        }
        field(9; Customer; Code[10])
        {
            Caption = 'Customer';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(11; "Product No."; Code[20])
        {
            Caption = 'Product No.';
            TableRelation = Item;
        }
        field(12; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(13; Warehouse; Code[10])
        {
            Caption = 'Warehouse';
        }
        field(14; "New Warehouse"; Code[10])
        {
            Caption = 'New Warehouse';
        }
        field(15; Location; Code[10])
        {
            Caption = 'Location';
        }
        field(16; "New Location"; Code[10])
        {
            Caption = 'New Location';
        }
        field(17; "Stock Type"; Code[10])
        {
            Caption = 'Stock Type';
        }
        field(18; "New Stock Type"; Code[10])
        {
            Caption = 'New Stock Type';
        }
        field(19; Grade; Code[10])
        {
            Caption = 'Grade';
        }
        field(20; "New Grade"; Code[10])
        {
            Caption = 'New Grade';
        }
        field(21; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(101; "Reason Description"; Text[50])
        {
            CalcFormula = lookup("Warehouse Reason Code ZY".Description where(Code = field("Reason Code")));
            Caption = 'Reason Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then begin
            if recWhseStockCorrLedEntry.FindLast then
                "Entry No." := recWhseStockCorrLedEntry."Entry No." + 1
            else
                "Entry No." := 1;
        end;
    end;

    var
        recWhseStockCorrLedEntry: Record "Whse. Stock Corr. Led. Entry";
}
