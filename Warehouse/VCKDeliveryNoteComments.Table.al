Table 50038 "VCK Delivery Note Comments"
{

    fields
    {
        field(1; "Delivery Document No."; Code[20])
        {
            TableRelation = "VCK Delivery Document Header"."No.";
        }
        field(2; "Delivery Comment 1"; Text[30])
        {
        }
        field(3; "Delivery Comment 2"; Text[30])
        {
        }
        field(4; "Delivery Comment 3"; Text[30])
        {
        }
        field(5; "Delivery Comment 4"; Text[30])
        {
        }
        field(6; "Delivery Comment 5"; Text[30])
        {
        }
        field(7; "Delivery Comment 6"; Text[30])
        {
        }
        field(8; "Delivery Comment 7"; Text[30])
        {
        }
        field(9; "Delivery Comment 8"; Text[30])
        {
        }
        field(10; "Delivery Comment 9"; Text[30])
        {
        }
        field(11; "Delivery Comment 10"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Delivery Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
