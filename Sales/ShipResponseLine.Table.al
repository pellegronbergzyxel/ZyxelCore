Table 66009 "Ship Response Line"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 26-01-21 ZY-LD 000 - New field.

    Caption = 'Ship Response Line';
    Description = 'Ship Response Line';

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Description = 'PAB 1.0';
        }
        field(2; "Index No."; Integer)
        {
            Caption = 'Index No.';
            Description = 'PAB 1.0';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'PAB 1.0';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
        }
        field(5; "Product No."; Code[20])
        {
            Caption = 'Product No.';
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(6; Warehouse; Code[20])
        {
            Caption = 'Warehouse';
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(7; Location; Code[20])
        {
            Caption = 'Location';
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(8; Grade; Code[20])
        {
            Caption = 'Grade';
            Description = 'PAB 1.0';
        }
        field(9; "Ordered Quantity"; Integer)
        {
            Caption = 'Ordered Quantity';
            Description = 'PAB 1.0';
        }
        field(10; Quantity; Integer)
        {
            Caption = 'Quantity';
            Description = 'PAB 1.0';
        }
        field(11; "Customer Order No."; Text[250])
        {
            Caption = 'Customer Order No.';
            Description = 'PAB 1.0';
        }
        field(12; "Customer Order Line No."; Integer)
        {
            Caption = 'Customer Order Line No.';
            Description = 'PAB 1.0';
        }
        field(13; "Sales Order No."; Code[250])
        {
            Caption = 'Sales Order No.';
            Description = 'PAB 1.0';
        }
        field(14; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Description = 'PAB 1.0';
        }
        field(15; "Value 1"; Text[250])
        {
            Caption = 'Value 1';
            Description = 'PAB 1.0';
        }
        field(16; "Value 2"; Text[250])
        {
            Caption = 'Value 2';
            Description = 'PAB 1.0';
        }
        field(17; "Value 3"; Text[250])
        {
            Caption = 'Value 3';
            Description = 'PAB 1.0';
        }
        field(18; "Value 4"; Text[250])
        {
            Caption = 'Value 4';
            Description = 'PAB 1.0';
        }
        field(19; "Value 5"; Text[250])
        {
            Caption = 'Value 5';
            Description = 'PAB 1.0';
        }
        field(20; "Value 6"; Text[250])
        {
            Caption = 'Value 6';
            Description = 'PAB 1.0';
        }
        field(21; "Value 7"; Text[250])
        {
            Caption = 'Value 7';
            Description = 'PAB 1.0';
        }
        field(22; "Value 8"; Text[250])
        {
            Caption = 'Value 8';
            Description = 'PAB 1.0';
        }
        field(23; "Value 9"; Text[250])
        {
            Caption = 'Value 9';
            Description = 'PAB 1.0';
        }
        field(24; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = 'PAB 1.0';
        }
        field(25; Description; Text[250])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
        field(26; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(27; "Alt. Product No."; Code[20])
        {
            Caption = 'Alternative Product No.';
            Description = '26-01-21 ZY-LD 002';
        }
        field(28; "Mail Missing Del. Doc. Sent"; Boolean)  // 09-04-24 ZY-LD 000
        {
            Caption = 'Mail About Missing Del. Doc. Line is Sent';
            Description = 'If a delivery document line has been deleted, but the warehouse has sent it anyway we send a mail to order desk, but only once.';
        }
        field(100; "Open - Receipt"; Boolean)
        {
            Caption = 'Open - Receipt';
            InitValue = true;
        }
        field(101; Open; Boolean)
        {
            Caption = 'Open';
            Description = 'PAB 1.0';
            InitValue = true;
        }
        field(102; "Warehouse Status"; Option)
        {
            CalcFormula = lookup("Ship Response Header"."Warehouse Status" where("No." = field("Response No.")));
            Caption = 'Warehouse Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        }
        field(103; "Delivery Document Line Posted"; Boolean)
        {
            CalcFormula = lookup("VCK Delivery Document Line".Posted where("Document No." = field("Sales Order No."),
                                                                            "Line No." = field("Sales Order Line No.")));
            Caption = 'Delivery Document Line Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Sales Order Qty. Shipped"; Decimal)
        {
            CalcFormula = lookup("Sales Line"."Qty. Shipped Not Invoiced" where("Document Type" = const(Order),
                                                                                 "Document No." = field("Customer Order No."),
                                                                                 "Line No." = field("Customer Order Line No.")));
            Caption = 'Sales Order Qty. Shipped';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Sales Order Qty. Invoiced"; Decimal)
        {
            CalcFormula = lookup("Sales Line"."Qty. Invoiced (Base)" where("Document Type" = const(Order),
                                                                            "Document No." = field("Customer Order No."),
                                                                            "Line No." = field("Customer Order Line No.")));
            Caption = 'Sales Order Qty. Invoiced';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Transfer Order Qty. Shipped"; Decimal)
        {
            CalcFormula = lookup("Transfer Line"."Quantity Shipped" where("Document No." = field("Customer Order No."),
                                                                           "Line No." = field("Customer Order Line No.")));
            Caption = 'Transfer Order Qty. Shipped';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "Quantity on Delivery Document"; Integer)
        {
            CalcFormula = lookup("VCK Delivery Document Line".Quantity where("Document No." = field("Sales Order No."),
                                                                              "Line No." = field("Sales Order Line No.")));
            Caption = 'Quantity on Delivery Document';
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Response No."; Code[20])
        {
            Caption = 'Response No.';
            TableRelation = "Ship Response Header";
        }
        field(202; "Response Line No."; Integer)
        {
            Caption = 'Response Line No.';
        }
        field(203; "Previously Posted"; Boolean)
        {
            Caption = 'Previously Posted';
        }
        field(204; "No. of Serial No."; Integer)
        {
            CalcFormula = count("Ship Responce Serial Nos." where("Response No." = field("Response No."),
                                                                   "Response Line No." = field("Response Line No.")));
            Caption = 'No. of Serial No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Response No.", "Response Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Response No.", "Customer Order No.", "Customer Order Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recShipRespSerial.SetRange("Response No.", "Response No.");
        recShipRespSerial.SetRange("Response Line No.", "Response Line No.");
        if recShipRespSerial.FindSet(true) then
            repeat
                recShipRespSerial.Delete(true);
            until recShipRespSerial.Next() = 0;
    end;

    var
        recShipRespSerial: Record "Ship Responce Serial Nos.";
}
