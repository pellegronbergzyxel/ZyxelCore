tableextension 50115 ItemLedgerEntryZX extends "Item Ledger Entry"
{
    fields
    {
        modify("Sales Amount (Actual)")
        {
            Caption = 'Sales Amount (Actual)';
        }
        field(50000; "Cost Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Posted to G/L" where("Item Ledger Entry No." = field("Entry No."),
                                                                       "Posting Date" = field("Date Filter")));
            Caption = 'Cost Posted to G/L';
            Description = '03-04-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = '03-04-18 ZY-LD 002';
            FieldClass = FlowFilter;
        }
        field(50002; "Last Applying Date"; Date)
        {
            Caption = 'Last Applying Date';
        }
        field(50003; "Sell-To Customer Territory"; Code[20])
        {
            CalcFormula = lookup(Customer."Territory Code" where("No." = field("Source No.")));
            Caption = 'Sell-To Customer Territory';
            Description = '20-08-18 ZY-LD 003';
            FieldClass = FlowField;
        }
        field(50004; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Source No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Statistics Group Code"; Code[10])
        {
            CalcFormula = lookup(Item."Statistics Group Code" where("No." = field("Item No.")));
            Caption = 'Statistics Group Code';
            Description = '28-10-21 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Freight Cost per Unit"; Decimal)
        {
            CalcFormula = sum("Freight Cost Value Entry"."Unit Cost" where("Item Ledger Entry No." = field("Entry No.")));
            Caption = 'Freight Cost per Unit';
            DecimalPlaces = 2 : 5;
            Description = '28-02-22 ZY-LD 008';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Freight Cost Amount"; Decimal)
        {
            CalcFormula = sum("Freight Cost Value Entry".Amount where("Item Ledger Entry No." = field("Entry No.")));
            Caption = 'Freight Cost Amount';
            Description = '28-02-22 ZY-LD 008';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Item Charge No. Filter"; Code[20])
        {
            Caption = 'Item Charge No.';
            Description = '12-04-22 ZY-LD 009';
            FieldClass = FlowFilter;
            TableRelation = "Item Charge";
        }
        field(50010; "Expected Cost Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Expected Cost Posted to G/L" where("Item Ledger Entry No." = field("Entry No."),
                                                                                 "Posting Date" = field("Date Filter")));
            Caption = 'Cost Posted to G/L';
            Description = '02-05-22 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Source Description"; Text[100])  // 14-02-24 ZY-LD 000
        {
            Caption = 'Source Description';
            Editable = false;
        }
        field(50036; "Original No."; Code[20])  // 01-05-24 ZY-LD 000
        {
            Caption = 'Original No.';
            Description = 'In case of samples we need to store the original item no. so we can use it in intrastat reporting.';
        }
    }

    keys
    {
        key(ZXKey1; "Item No.", "Variant Code", Open, Positive, "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.")
        {
        }
        key(ZXKey2; "Item No.", "Location Code")
        {
            SumIndexFields = Quantity;
        }
        key(ZXKey3; "Item No.", "Entry Type", "Country/Region Code", "Posting Date")
        {
        }
        key(ZXKey4; "Invoiced Quantity", "Posting Date")
        {
        }
        key(ZXKey5; "External Document No.")
        {
        }
    }
}
