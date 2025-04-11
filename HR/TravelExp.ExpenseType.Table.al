Table 50117 "Travel Exp. Expense Type"
{
    Caption = 'Travel Exp. Expense Type';
    DataCaptionFields = "Code", Name;
    DrillDownPageID = "Travel Exp. Expense Types";
    LookupPageID = "Travel Exp. Expense Types";

    fields
    {
        field(1; "Code"; Code[64])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[64])
        {
            Caption = 'Name';
        }
        field(3; "Posting Type"; Option)
        {
            Caption = 'Posting Type';
            OptionMembers = "G/L Account",Salary;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name)
        {
        }
    }
}
