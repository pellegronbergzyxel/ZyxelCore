table 50115 "eCommerce Transaction Summary"
{

    fields
    {
        field(2; "Transaction Summary"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(3; "Fee Purchase Invoice No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(4; Amount; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(5; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Transaction Summary")
        {
            Clustered = true;
        }
    }
}
