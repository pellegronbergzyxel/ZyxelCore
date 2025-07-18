table 50012 "Unshipped Purchase Order"
{
    Caption = 'Unshipped Purchase Order';
    DrillDownPageId = "Unshipped Purchase Order";
    LookupPageId = "Unshipped Purchase Order";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Order Line ID"; Code[30])
        {
            Caption = 'Sales Order Line ID';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(4; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Line No.';
        }
        field(5; "ETD Date"; Date)
        {
            Caption = 'Factory Schedule Date';
        }
        field(6; "ETA Date"; Date)
        {
            Caption = 'ETA Date';
        }
        field(7; "Shipping Order ETD Date"; Date)
        {
            Caption = 'Shipping Order ETD Date';
        }
        field(8; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 2;
        }
        field(10; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Vendor Type"; Enum VendorType)
        {
            Caption = 'Vendor Type';
        }
        field(13; "Location Code"; Code[10])
        {
            CalcFormula = lookup("Purchase Line"."Location Code" where("Document Type" = const(Order),
                                                                       "Document No." = field("Purchase Order No."),
                                                                       "Line No." = field("Purchase Order Line No.")));

            Caption = 'Location Code';
            FieldClass = FlowField;
            Editable = false;
        }
        field(14; "Buy-from Vendor No."; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor No." where("Document Type" = const(Order),
                                                                               "No." = field("Purchase Order No.")));
            Caption = 'Buy-from Vendor No.';
            FieldClass = FlowField;
            Editable = false;
        }
        field(15; "DN Number"; Code[20])
        {
            Caption = 'DN Number';
        }
        //Mail from John in HQ - first in test BK
    }
    keys
    {
        key(Key1; "Sales Order Line ID")
        {
            Clustered = true;
        }
        key(Key2; "Purchase Order No.", "Purchase Order Line No.", "ETA Date")
        {

        }
    }
}
