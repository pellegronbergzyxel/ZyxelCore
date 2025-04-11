tableextension 50191 HandledICInboxSalesHeaderZX extends "Handled IC Inbox Sales Header"
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
