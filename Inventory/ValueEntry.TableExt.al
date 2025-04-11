tableextension 50218 ValueEntryZX extends "Value Entry"
{
    fields
    {
        field(50000; "Item Ledger Entry Exists"; Boolean)
        {
            CalcFormula = exist("Item Ledger Entry" where("Entry No." = field("Item Ledger Entry No."),
                                                           "Item No." = field("Item No.")));
            Caption = 'Item Ledger Entry Exists';
            Description = '20-06-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Sales Value Entry No."; Integer)
        {
            Caption = 'Sales Value Entry No.';
        }
        field(50003; "Freight Cost per Unit"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Freight Cost Value Entry"."Unit Cost" where("Value Entry No." = field("Entry No.")));
            Caption = 'Freight Cost per Unit';
            DecimalPlaces = 2 : 5;
            Description = '11-02-22 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Freight Cost Amount"; Decimal)
        {
            CalcFormula = sum("Freight Cost Value Entry".Amount where("Value Entry No." = field("Entry No.")));
            Caption = 'Freight Cost Amount';
            Description = '11-02-22 ZY-LD 005';
            FieldClass = FlowField;
        }
        field(50005; "Freight Cost Type"; Option)
        {
            Caption = 'Freight Cost Type';
            Description = '11-02-22 ZY-LD 005';
            OptionMembers = " ",Purchase,Sale;
        }
        field(62094; "Source No. 2"; Code[20])
        {
            CalcFormula = lookup("Item Ledger Entry"."Source No." where("Entry No." = field("Item Ledger Entry No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key50000; "Document No.", "Posting Date")
        {
        }
        key(Key50001; "Item No.", "Item Ledger Entry Type", "Entry Type", "Item Charge No.", "Location Code", "Variant Code", "Posting Date")
        {
        }
        key(Key50002; "Global Dimension 2 Code", "Item Ledger Entry Type", "Posting Date", "Entry Type")
        {
            SumIndexFields = "Cost Amount (Actual)";
        }
        key(Key50003; "Source Type", "Source No.", "Item Ledger Entry Type", "Item No.", "Posting Date")
        {
            SumIndexFields = "Discount Amount", "Cost Amount (Non-Invtbl.)", "Cost Amount (Actual)", "Cost Amount (Expected)", "Sales Amount (Actual)", "Sales Amount (Expected)", "Invoiced Quantity";
        }
        key(Key50004; "Item No.", "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code", "Location Code")
        {
            SumIndexFields = "Cost Amount (Actual)", "Cost Posted to G/L", "Cost Amount (Actual) (ACY)", "Cost Posted to G/L (ACY)";
        }
        key(Key50005; "Sales Value Entry No.")
        {
        }
    }
}
