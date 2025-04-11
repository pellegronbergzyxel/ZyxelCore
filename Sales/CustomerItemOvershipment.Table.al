Table 50055 "Customer/Item Overshipment"
{
    Caption = 'Customer/Item Overshipment';
    DataCaptionFields = "Customer No.", "Customer Name";
    DrillDownPageID = "Customer/Item Overshipments";
    LookupPageID = "Customer/Item Overshipments";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                CalcFields("Item Name");
            end;
        }
        field(3; "Overshipment %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Overshipment %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; Type; Option)
        {
            Caption = 'Overshipment Type';
            OptionMembers = "Addition to Quantity","Included in Quantity";
        }
        field(5; "Rounding Direction"; Option)
        {
            Caption = 'Rounding Direction';
            InitValue = ">";
            OptionMembers = "=","<",">";
        }
        field(6; "Unit Price"; Decimal)
        {
            BlankZero = true;
            Caption = 'Unit Price';
            MaxValue = 1;
            MinValue = 0;
        }
        field(11; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Item Name"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
