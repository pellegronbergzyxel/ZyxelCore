tableextension 50187 ICInboxSalesHeaderZX extends "IC Inbox Sales Header"
{
    fields
    {
        field(50001; "Ship-to E-Mail"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50002; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Sell-to)';
            Description = 'eCommerce';
        }
        field(50003; "Ship-to Name 2"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50004; "Ship-to Contact"; Text[30])
        {
            Description = 'eCommerce';
        }
        field(50011; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Description = '09-10-18 ZY-LD 002';
            TableRelation = "Ship-to Address";
        }
        field(50026; "eCommerce Order"; Boolean)
        {
            Description = 'eCommerce';
        }
        field(50027; "Your Reference 2"; Text[50])
        {
            Description = 'eCommerce';
        }
    }
}
