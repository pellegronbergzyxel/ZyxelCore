Table 50009 "Customer/Item Relation"
{
    Caption = 'Customer/Item Relation';
    DrillDownPageID = "Customer/Item Relation";
    LookupPageID = "Customer/Item Relation";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Block,Seperate Delivery Document';
            OptionMembers = Block,"Seperate Delivery Document";
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                CalcFields("Customer Name");
            end;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                CalcFields("Item Name");
            end;
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
        field(13; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
    }

    keys
    {
        key(Key1; Type, "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
