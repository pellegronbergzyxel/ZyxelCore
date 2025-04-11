Table 76122 "Detailed G/L Entry"
{
    //       //CO4.20: Controling - Basic: Applying G/L Entries;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            TableRelation = "G/L Entry";
        }
        field(12; "Applied G/L Entry No."; Integer)
        {
            Caption = 'Applied G/L Entry No.';
            TableRelation = "G/L Entry";
        }
        field(15; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(25; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(30; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(40; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(50; Unapplied; Boolean)
        {
            Caption = 'Unapplied';
        }
        field(55; "Unapplied by Entry No."; Integer)
        {
            Caption = 'Unapplied by Entry No.';
            TableRelation = "Detailed G/L Entry";
        }
        field(60; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "G/L Entry No.", "Posting Date")
        {
        }
        key(Key3; "Transaction No.")
        {
        }
        key(Key4; "Applied G/L Entry No.")
        {
        }
        key(Key5; "G/L Account No.")
        {
        }
    }

    fieldgroups
    {
    }
}
