Table 76124 "Item Picking Date pr. Country"
{
    // 001. 19-03-19 ZY-LD 2019031910000031 - Created.

    Caption = 'Item Picking Date pr. Country';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(2; "Ship-to Country Code"; Code[10])
        {
            Caption = 'Ship-to Country Code';
            TableRelation = "Country/Region";
        }
        field(11; "Picking Start Date"; Date)
        {
            Caption = 'Picking Start Date';
        }
    }

    keys
    {
        key(Key1; "Item No.", "Ship-to Country Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
