Table 62013 "E-mail HTML files"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Filename; Text[250])
        {
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
    }
}
