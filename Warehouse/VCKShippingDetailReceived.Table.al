Table 50034 "VCK Shipping Detail Received"
{
    // 001. 26-10-18 ZY-LD 000 - Created.
    // 002. 21-08-19 ZY-LD 000 - New field.
    // 003. 22-04-20 ZY-LD P0388 - New field.
    // 004. 23-04-20 ZY-LD 2020042310000054 - New field.
    // 005. 03-11-20 ZY-LD 2020110310000088 - Unarchive container details.
    // 006. 11-01-21 ZY-LD 000 "Item No.,Order Type" new key based on SQL Powerhouse.

    Caption = 'VCK Shipping Detail Received';
    DrillDownPageID = "Shipping Details Received";
    LookupPageID = "Shipping Details Received";

    fields
    {
        field(1; "Container No."; Code[30])
        {
            Caption = 'Container No.';
        }
        field(2; "Invoice No."; Code[30])
        {
            Caption = 'Invoice No.';
        }
        field(3; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            TableRelation = "Purchase Header"."No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(4; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
        }
        field(5; "Pallet No."; Code[30])
        {
            Caption = 'Pallet No.';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(10; "Shipping Method"; Code[30])
        {
            Caption = 'Shipping Method';
        }
        field(11; "Order No."; Code[30])
        {
            Caption = 'Shipment No.';
        }
        field(13; Archive; Boolean)
        {
            CalcFormula = lookup("VCK Shipping Detail".Archive where("Container No." = field("Container No."),
                                                                      "Invoice No." = field("Invoice No."),
                                                                      "Purchase Order No." = field("Purchase Order No."),
                                                                      "Purchase Order Line No." = field("Purchase Order Line No."),
                                                                      "Pallet No." = field("Pallet No."),
                                                                      "Item No." = field("Item No."),
                                                                      "Shipping Method" = field("Shipping Method"),
                                                                      "Order No." = field("Order No.")));
            Caption = 'Archive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Location Code"; Code[10])
        {
            CalcFormula = lookup("Purchase Header"."Location Code" where("Document Type" = const(Order),
                                                                          "No." = field("Purchase Order No.")));
            Caption = 'Location';
            Description = '23-04-20 ZY-LD 004';
            FieldClass = FlowField;
        }
        field(16; "Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 0;
        }
        field(17; "Date Posted"; DateTime)
        {
            Caption = 'Date Posted';
        }
        field(21; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(41; "Buy-from Vendor No."; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor No." where("No." = field("Purchase Order No.")));
            Caption = 'Buy-from Vendor No.';
            Description = '21-08-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vendor;
        }
        field(103; "Order Type"; Option)
        {
            Caption = 'Order Type';
            Description = '22-04-20 ZY-LD 003';
            Editable = false;
            OptionCaption = 'Purchase Order,Sales Return Order';
            OptionMembers = "Purchase Order","Sales Return Order";
        }
        field(104; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
        }
        field(105; "Receipt Line No."; Integer)
        {
            Caption = 'Receipt Line No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Container No.", "Invoice No.", "Purchase Order No.", "Purchase Order Line No.", "Pallet No.", "Item No.", "Shipping Method", "Order No.")
        {
            Clustered = true;
            SumIndexFields = "Quantity Received";
        }
        key(Key3; "Item No.", "Order Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //>> 03-11-20 ZY-LD 005
        recShipDetail.SetRange("Container No.", "Container No.");
        recShipDetail.SetRange("Invoice No.", "Invoice No.");
        recShipDetail.SetRange("Purchase Order No.", "Purchase Order No.");
        recShipDetail.SetRange("Purchase Order Line No.", "Purchase Order Line No.");
        recShipDetail.SetRange("Pallet No.", "Pallet No.");
        recShipDetail.SetRange("Item No.", "Item No.");
        recShipDetail.SetRange("Shipping Method", "Shipping Method");
        recShipDetail.SetRange("Order No.", "Order No.");
        if recShipDetail.FindFirst then begin
            recShipDetail.Archive := false;
            recShipDetail.Modify(true);
        end;
        //<< 03-11-20 ZY-LD 005
    end;

    var
        recShipDetail: Record "VCK Shipping Detail";
}
