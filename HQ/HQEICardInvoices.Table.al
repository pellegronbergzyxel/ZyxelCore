Table 50033 "HQ EICard Invoices"
{

    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = true;
            Description = 'PAB 1.0';
        }
        field(2; "Invoice No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(4; "Order No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Purchase Header"."No.";
        }
        field(6; "Item No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Item."No.";
        }
        field(7; Quantity; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(8; Amount; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(9; "Total Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(11; "Document Name"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(12; Matched; Boolean)
        {
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
