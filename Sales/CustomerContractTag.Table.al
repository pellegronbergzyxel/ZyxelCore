Table 50063 "Customer Contract Tag"
{
    Caption = 'Company Contract Tag';

    fields
    {
        field(1; "Document No."; Code[10])
        {
            Caption = 'Document No.';
            TableRelation = "Customer Contract";
        }
        field(2; Tag; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", Tag)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
