Table 76152 "Headquarter Setup"
{
    // 001. 05-07-19 ZY-LD 000 - New fields.


    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = true;
            Description = 'PAB 1.0';
        }
        field(2; "NAV Server Name"; Text[30])
        {
            Caption = 'CH NAV Server Name';
            Description = 'PAB 1.0';
            InitValue = '172.28.12.130';
        }
        field(3; "NAV Database Name"; Text[30])
        {
            Caption = 'NAV Database Name';
            Description = 'PAB 1.0';
            InitValue = 'nav_erbu';
        }
        field(4; "NAV User Name"; Text[30])
        {
            Caption = 'NAV User Name';
            Description = 'PAB 1.0';
            InitValue = 'bi';
        }
        field(5; "NAV Password"; Text[30])
        {
            Caption = 'NAV Password';
            Description = 'PAB 1.0';
            InitValue = 'fireballxl5';
        }
        field(6; "NAV Company Name"; Code[20])
        {
            Caption = 'NAV Company Name';
            Description = 'PAB 1.0';
            InitValue = 'ZYXEL (RHQ) GO LIVE';
            TableRelation = Company.Name;
        }
        field(7; "Archive Folder"; Text[250])
        {
            Caption = 'Archive Folder';
            Description = 'PAB 1.0';
            InitValue = '\\ZYEU-NAVSQL02\Invoices3\CH';
        }
        field(14; "Exchange Account"; Text[30])
        {
            Caption = 'Exchange Account';
            Description = 'PAB 1.0';
            InitValue = 'HQInvoiceCH';
        }
        field(16; "Exchange Account Password"; Text[30])
        {
            Caption = 'Exchange Account Password';
            Description = 'PAB 1.0';
            InitValue = '7wU66$YZ9dPa9#';
        }
        field(26; "EiCard Archive Folder"; Text[250])
        {
            Caption = 'EiCard Archive Folder';
            Description = 'PAB 1.0';
        }
        field(28; "LMR Exchange Account"; Text[30])
        {
            Caption = 'LMR Exchange Account';
            Description = 'PAB 1.0';
            InitValue = 'ait';
        }
        field(29; "LMR Exchange Password"; Text[30])
        {
            Caption = 'LMR Exchange Password';
            Description = 'PAB 1.0';
            InitValue = 'zuvEswe2a9UW';
        }
        field(30; "LMR Archive Folder"; Text[250])
        {
            Caption = 'LMR Archive Folder';
            Description = 'PAB 1.0';
        }
        field(31; "LMR Company Name"; Code[20])
        {
            Caption = 'LMR Company Name';
            Description = 'PAB 1.0';
            InitValue = 'ZYXEL (RHQ) GO LIVE';
            TableRelation = Company.Name;
        }
        field(36; "SBU Filter Channel"; Code[20])
        {
            Caption = 'SBU Filter CH';
            Description = '05-07-19 ZY-LD 001';
            TableRelation = SBU.Code where(Type = const(SBU));
            ValidateTableRelation = false;
        }
        field(37; "SBU Filter Service Provider"; Code[20])
        {
            Caption = 'SBU Filter SP';
            Description = '05-07-19 ZY-LD 001';
            TableRelation = SBU.Code where(Type = const(SBU));
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
