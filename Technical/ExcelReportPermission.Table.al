Table 60007 "Excel Report Permission"
{
    Caption = 'Excel Report Permission';

    fields
    {
        field(1; "Excel Report Code"; Code[10])
        {
            TableRelation = "Excel Report Header";
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "Excel Report Code", "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
