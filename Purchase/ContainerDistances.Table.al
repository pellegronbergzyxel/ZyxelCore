Table 50074 "Container Distances"
{
    // 001. 24-03-21 ZY-LD 000 - New field.

    Caption = 'Container Distances';
    Description = 'Container Distances to calculate days from landing to customer';
    DrillDownPageID = "Container Distances";
    LookupPageID = "Container Distances";

    fields
    {
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'PAB 1.0';
            TableRelation = Customer;
        }
        field(3; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            Description = 'PAB 1.0';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(4; "Sea Days"; Integer)
        {
            BlankZero = true;
            Caption = 'Add. Days for Sea Freight';
            Description = 'PAB 1.0';
        }
        field(5; "Air Days"; Integer)
        {
            BlankZero = true;
            Caption = 'Add. Days fpr Air Freight';
            Description = 'PAB 1.0';
        }
        field(6; "Rail Days"; Integer)
        {
            BlankZero = true;
            Caption = 'Add. Days for Rail Freight';
            Description = 'PAB 1.0';
        }
        field(7; "Other Days"; Integer)
        {
            BlankZero = true;
            Caption = 'Add. Days for Other Freight';
            Description = '24-03-21 ZY-LD 001';
        }
        field(8; Description; Text[30])
        {
            Caption = 'Description';
            Description = '24-03-21 ZY-LD 001';
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
