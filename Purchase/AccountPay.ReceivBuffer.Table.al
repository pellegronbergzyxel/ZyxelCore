Table 62001 "Account Pay./Receiv Buffer"
{
    Caption = 'Account Payable/Receivable Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Entity Name';
        }
        field(3; "HQ Account No."; Code[20])
        {
            Caption = 'HQ Account No.';
        }
        field(4; "HQ Account Name"; Text[50])
        {
            Caption = 'HQ Account Name';
        }
        field(5; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
        }
        field(6; "G/L Account Name"; Text[50])
        {
            Caption = 'G/L Account Name';
        }
        field(7; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(8; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
        }
        field(9; Division; Code[20])
        {
            Caption = 'Division';
        }
        field(10; "Payment Terms"; Code[20])
        {
            Caption = 'Payment Terms';
        }
        field(11; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(12; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(13; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(14; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
        }
        field(15; "TXN Currency Code"; Code[10])
        {
            Caption = 'TXN Currency Code';
        }
        field(16; "TXN Amount"; Decimal)
        {
            Caption = 'TXN Amount';
        }
        field(17; "TXN Ending Balance"; Decimal)
        {
            Caption = 'TXN Ending Balance';
        }
        field(18; "LCY Currency Code"; Code[10])
        {
            Caption = 'LCY Currency Code';
        }
        field(19; "LCY Amount"; Decimal)
        {
            Caption = 'LCY Amount';
        }
        field(20; "LCY Ending Balance"; Decimal)
        {
            Caption = 'LCH Ending Balance';
        }
        field(21; "RPT Currency Code"; Code[10])
        {
            Caption = 'RPT Currency Code';
        }
        field(22; "RPT Amount"; Decimal)
        {
            Caption = 'RPT Amount';
        }
        field(23; "RPT Ending Balance"; Decimal)
        {
            Caption = 'RPT Ending Balance';
        }
        field(25; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(26; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(27; "Credit Limit"; Decimal)
        {
            Caption = 'Credit Limit';
        }
        field(28; "Not Due Balance"; Decimal)
        {
            Caption = 'Not Due Balance';
        }
        field(29; "Due Balance over XX Days"; Decimal)
        {
            Caption = 'Due Balance over XX Days';
        }
        field(30; "Due Balance Curr. Month"; Decimal)
        {
            Caption = 'Due Balance Curr. Month';
        }
        field(31; "Due Balance Curr. Month Pl. 1"; Decimal)
        {
            Caption = 'Due Balance Curr. Month Plus 1';
        }
        field(32; "Due Balance Curr. Month Pl. 2"; Decimal)
        {
            Caption = 'Due Balance Curr. Month Plus 2';
        }
        field(33; "Due Balance Curr. Month Pl. 3"; Decimal)
        {
            Caption = 'Due Balance Curr. Month Plus 3';
        }
        field(34; "HQ Company Name"; Text[10])
        {
            Caption = 'HQ Company Name';
        }
        field(35; "Due Balance"; Decimal)
        {
            Caption = 'Due Balance';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
