table 50069 "eCommerce Location Code"
{
    Caption = 'eCommerce Location Code';

    fields
    {
        field(1; "Ship-from Country Code"; Code[10])
        {
            Caption = 'Ship-from Country Code';
            TableRelation = "Country/Region";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(3; "Ship-from Post Code"; Code[10])
        {
            Caption = 'Ship-from Post Code';
            TableRelation = "Post Code";
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1; "Ship-from Country Code", "Ship-from Post Code")
        {
            Clustered = true;
        }
    }
}
