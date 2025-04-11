Table 50079 "Rcpt. Response Line"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 02-11-23 ZY-LD 000 - New field.

    Caption = 'Rcpt. Response Line';
    Description = 'Rcpt. Response Line';

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(2; Index; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(3; "Line No."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(4; "Item No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(5; "Product No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(6; Warehouse; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(7; Location; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(8; Grade; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(9; "Ordered Qty"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(10; Quantity; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(11; "Customer Order No."; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(12; "Customer Order Line No."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(13; "Source Order No."; Code[250])
        {
            Caption = 'Source Order No.';
            Description = 'PAB 1.0';
        }
        field(14; "Source Order Line No."; Integer)
        {
            Caption = 'Source Order Line No.';
            Description = 'PAB 1.0';
        }
        field(15; "Value 1"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(16; "Value 2"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(17; "Value 3"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(18; "Value 4"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(19; "Value 5"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(20; "Value 6"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(21; "Value 7"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(22; "Value 8"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(23; "Value 9"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(24; "Entry No."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(25; Open; Boolean)
        {
            Caption = 'Open - Receipt';
            InitValue = true;
        }
        field(26; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(27; "Open - Shipment"; Boolean)  // 02-11-23 ZY-LD 002
        {
            Caption = 'Open - Shipment';
            InitValue = true;
        }
        field(31; "Real Source Order No."; Code[20])
        {
            CalcFormula = lookup("VCK Shipping Detail"."Purchase Order No." where("Document No." = field("Source Order No."),
                                                                                   "Line No." = field("Source Order Line No.")));
            Caption = 'Real Source Order No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Real Source Order Line No."; Integer)
        {
            CalcFormula = lookup("VCK Shipping Detail"."Purchase Order Line No." where("Document No." = field("Source Order No."),
                                                                                        "Line No." = field("Source Order Line No.")));
            Caption = 'Real Source Order Line No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Warehouse Status"; Option)
        {
            CalcFormula = lookup("Rcpt. Response Header"."Warehouse Status" where("No." = field("Response No.")));
            Caption = 'Warehouse Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Order Sent, Order Sent (2),Goods Received,Putting Away,On Stock';
            OptionMembers = " ","Order Sent"," Order Sent (2)","Goods Received","Putting Away","On Stock";
        }
        field(103; "Customer Reference"; Text[250])
        {
            CalcFormula = lookup("Rcpt. Response Header"."Customer Reference" where("No." = field("Response No.")));
            Caption = 'Customer Reference';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Purchase Order Qty. Received"; Decimal)
        {
            CalcFormula = lookup("Purchase Line"."Qty. Received (Base)" where("Document Type" = const(Order),
                                                                              "Document No." = field("Customer Order No."),
                                                                              "Line No." = field("Customer Order Line No.")));
            Caption = 'Purch. Order Qty. Received';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Purchase Order Qty. Invoiced"; Decimal)
        {
            CalcFormula = lookup("Purchase Line"."Qty. Invoiced (Base)" where("Document Type" = const(Order),
                                                                               "Document No." = field("Customer Order No."),
                                                                               "Line No." = field("Customer Order Line No.")));
            Caption = 'Purch Order Qty. Invoiced';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Invoice No."; Code[30])
        {
            CalcFormula = lookup("VCK Shipping Detail"."Invoice No." where("Document No." = field("Source Order No."),
                                                                            "Line No." = field("Source Order Line No.")));
            Caption = 'Invoice No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Response No."; Code[20])
        {
            Caption = 'Response No.';
            TableRelation = "Rcpt. Response Header";
        }
        field(202; "Response Line No."; Integer)
        {
        }
        field(203; "Previously Posted"; Boolean)
        {
            Caption = 'Previously Posted';
        }
    }

    keys
    {
        key(Key1; "Response No.", "Response Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Response No.", "Source Order No.", "Source Order Line No.")
        {
        }
        key(Key3; "Response No.", Location, Open)
        {
        }
    }

    fieldgroups
    {
    }
}
