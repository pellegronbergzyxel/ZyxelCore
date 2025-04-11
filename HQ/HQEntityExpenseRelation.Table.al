Table 60001 "HQ Entity Expense Relation"
{
    // 001. 05-06-18 ZY-LD 2018060410000242 - Created.

    Caption = 'HQ Entity Expense Relation';
    DrillDownPageID = "HQ Entity Expense Relations";
    LookupPageID = "HQ Entity Expense Relations";

    fields
    {
        field(1; "HQ Entity"; Code[10])
        {
            Caption = 'HQ Entity';
            TableRelation = "HQ Entity";
        }
        field(2; "HQ Expense Category"; Code[10])
        {
            Caption = 'HQ Expense Category';
            TableRelation = "HQ Expense Category";
        }
        field(3; "HQ Department Code"; Code[10])
        {
            Caption = 'HQ Department Code';
        }
    }

    keys
    {
        key(Key1; "HQ Entity", "HQ Expense Category")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
