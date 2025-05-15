table 50090 "Amazon Setup"
{
    Caption = 'Amazon Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Token endpoint"; text[120])
        {
            caption = 'Token endpoint';
        }

        field(5; client_id; text[100])
        {
            caption = 'client_id';
        }
        field(6; client_secret; text[200])
        {
            caption = 'client_secret';
        }
        field(7; grant_type; text[50])
        {
            caption = 'grant_type';
        }

        field(8; Refresh_token; text[1024])
        {
            caption = 'Refresh token';
        }
        field(9; URL_PO_GET; text[200])
        {
            caption = 'URL_PO_GET';
        }
        field(10; URL_PO_GET_status; text[200])
        {
            caption = 'URL_PO_GET_status';
        }
        field(11; URL_Set_AKN; text[200])
        {
            caption = 'URL set PO acknowledgement';
        }
        field(12; ZyxelPartyid; text[10])
        {
            caption = 'Nordisk amazon party id';
        }
        field(13; ActiveClient; Boolean)
        {
            caption = 'Active amazon party id';
        }
        field(14; URL_GET_status_Purchase; text[200])
        {
            caption = 'URL get amazon status';
        }
        field(15; URL_Post_Invoice; text[200])
        {
            caption = 'URL POST invoice';

        }
        field(16; Description; text[100])
        {
            caption = 'Description';

        }
        field(17; URL_PO_GET_order; text[200])
        {
            caption = 'URL_PO_GET_order';
        }
        field(18; lastimport; datetime)
        {
            caption = 'Last import';
        }
        field(19; AmazonPO; Code[20])
        {
            Caption = 'Amazon PO No.';
        }
        field(20; testmode; boolean)
        {
            Caption = 'Amazon import running in testmode';
        }
        field(21; URL_packingSlips_order; text[200])
        {
            caption = 'URL packingSlips Order';
        }
        field(22; Customerno; code[20])
        {
            CalcFormula = lookup(Customer."No." where(AMAZONID = field(ZyxelPartyid)));

            Caption = 'Bill-to customer';
            Editable = false;
            FieldClass = FlowField;

        }

    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }


}
