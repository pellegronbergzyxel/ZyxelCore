Table 60000 "HQ Expense Category"
{
    // 001. 05-06-18 ZY-LD 2018060410000242 - Created.

    Caption = 'HQ Expense Category';
    DrillDownPageID = "HQ Expense Categorys";
    LookupPageID = "HQ Expense Categorys";

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description)
        {
        }
    }
}
