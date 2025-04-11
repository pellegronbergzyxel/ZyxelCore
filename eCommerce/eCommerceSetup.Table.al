table 76130 "eCommerce Setup"
{
    Caption = 'eCommerce Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Payment Batch Nos."; Code[10])
        {
            Caption = 'Payment Batch Nos.';
            TableRelation = "No. Series";
        }
        field(10; "API Import Path"; Text[250])
        {
            Caption = 'Tax Doc. Path';
        }
        field(11; "API Import Archive Path"; Text[250])
        {
            Caption = 'Tax Doc. Archive Path';
        }
        field(12; "API Import Error Path"; Text[250])
        {
            Caption = 'Tax Doc. Error Path';
        }
        field(13; "Posted Document Path"; Text[250])
        {
            Caption = 'Posted Document Path';
        }
        field(14; "API Import Payment Path"; Text[80])
        {
            Caption = 'Payment Path';
        }
        field(15; "API Import Payment Arch. Path"; Text[80])
        {
            Caption = 'Payment Archive Path';
        }
        field(16; "API Import Payment Error Path"; Text[80])
        {
            Caption = 'Payment Error Path';
        }
        field(17; "Posted Document Payment Path"; Text[80])
        {
            Caption = 'Posted Document Payment Path';
        }
        field(18; "API Import Fulfil. Order  Path"; Text[80])
        {
            Caption = 'Fulfilled Order Path';
        }
        field(19; "API Import Fulfi. Archive Path"; Text[80])
        {
            Caption = 'Fulfilled Order Archive Path';
        }
        field(20; "API Import Fulfi. Error Path"; Text[80])
        {
            Caption = 'Fulfilled Order Error Path';
        }
        field(21; "API Import Return Order  Path"; Text[80])
        {
            Caption = 'FBA Cust. Return Path';
        }
        field(22; "API Import Return Archive Path"; Text[80])
        {
            Caption = 'FBA Cust. Return Archive Path';
        }
        field(23; "API Import Return Error Path"; Text[80])
        {
            Caption = 'FBA Cust. Return Error Path';
        }
        field(24; "N/A Retention Period"; DateFormula)
        {
            Caption = 'N/A Retention Period';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
