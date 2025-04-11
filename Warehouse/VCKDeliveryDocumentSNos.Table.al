Table 50043 "VCK Delivery Document SNos"
{
    // 001. 10-04-18 ZY-LD 2018041010000351 - New fields.
    // 002. 18-10-18 ZY-LD 2018101710000121 - New fields.
    // 003. 26-04-19 ZY-LD P0217 - New key.
    // 004. 25-08-20 ZY-LD 2020082410000152 - New key "Item No.,Posting Date,Serial No.".


    fields
    {
        field(1; "Delivery Document No."; Code[30])
        {
            Description = 'PAB 1.0';
            TableRelation = "VCK Delivery Document Header";
        }
        field(2; "Delivery Document Line No."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(3; "Sales Order No."; Code[30])
        {
            Description = 'PAB 1.0';
            TableRelation = "Sales Header"."No.";
            ValidateTableRelation = false;
        }
        field(4; "Sales Order Line No."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(5; "Customer Order No."; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(6; "Item No."; Code[30])
        {
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(7; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Serial No."; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(9; "Customer No."; Code[30])
        {
            Description = 'PAB 1.0';
            TableRelation = Customer;
        }
        field(10; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Grab By HQ"; Boolean)
        {
            Description = 'PAB 1.0';
            InitValue = false;
        }
        field(12; "Customer Country Code"; Code[10])
        {
            CalcFormula = lookup(Customer."Country/Region Code" where("No." = field("Customer No.")));
            Caption = 'Customer Country Code';
            Description = '10-04-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Forecast Territory"; Code[30])
        {
            CalcFormula = lookup(Customer."Forecast Territory" where("No." = field("Customer No.")));
            Caption = 'Forecast Territory';
            Description = '10-04-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "DD Document Date"; Date)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Document Date" where("No." = field("Delivery Document No.")));
            Caption = 'Delivery Document Date';
            Description = 'PAB';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Ship-to Code"; Code[30])
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Ship-to Code" where("No." = field("Delivery Document No.")));
            Caption = 'Ship-to Code';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Ship-to Address";
        }
        field(19; "Ship-to Name"; Text[100])
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Ship-to Name" where("No." = field("Delivery Document No.")));
            Caption = 'Ship-to Name';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Sell-to Customer No."; Code[30])
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Sell-to Customer No." where("No." = field("Delivery Document No.")));
            Caption = 'Sell-to Customer No.';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Sell-to Customer Name" where("No." = field("Delivery Document No.")));
            Caption = 'Sell-to Customer Name';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Posting Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(23; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
        }
        field(51; "Shipment Date (Tmp)"; Date)
        {
            Caption = 'Shipment Date (Tmp)';
        }
        field(52; "Invoice No. (Tmp)"; Code[20])
        {
            Caption = 'Invoice No. (Tmp)';
        }
        field(53; "Invoice No. for End Cust.(Tmp)"; Code[20])
        {
            Caption = 'Invoice No. for End Cust.(Tmp)';
        }
        field(54; "External Document No. (Tmp)"; Text[50])
        {
            Caption = 'External Document No. (Tmp)';
        }
        field(55; "Customer No. (Tmp)"; Code[20])
        {
            Caption = 'Customer No. (Tmp)';
        }
        field(56; "Customer Name (Tmp)"; Text[100])
        {
            Caption = 'Customer Name (Tmp)';
        }
        field(57; "Division Code (Tmp)"; Code[10])
        {
            Caption = 'Division Code (Tmp)';
        }
        field(58; "RMA is Paid By (Tmp)"; Option)
        {
            Caption = 'RMA is Paid By (Tmp)';
            OptionCaption = ',Zyxel,ZNet';
            OptionMembers = ,Zyxel,ZNet;
        }
    }

    keys
    {
        key(Key1; "Serial No.", "Delivery Document No.", "Delivery Document Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Sales Order No.", "Sales Order Line No.")
        {
        }
        key(Key3; "Delivery Document No.", "Delivery Document Line No.")
        {
        }
        key(Key4; "Item No.", "Posting Date", "Serial No.")
        {
        }
    }

    fieldgroups
    {
    }
}
