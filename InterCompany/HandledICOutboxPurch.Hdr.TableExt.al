tableextension 50186 HandledICOutboxPurchHdrZX extends "Handled IC Outbox Purch. Hdr"
{
    fields
    {
        field(50006; "Ship-to E-Mail"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50007; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Sell-to)';
            Description = 'eCommerce';
        }
        field(50008; "Ship-to Contact"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50011; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Description = '09-10-18 ZY-LD 001';
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
