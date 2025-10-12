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
            Caption = 'testmode';
        }
        field(21; URL_packingSlips_order; text[200])
        {
            caption = 'URL packingSlips Order';
        }
        field(22; Customerno; code[20])
        {
            CalcFormula = lookup(Customer."No." where(AMAZONID = field(ZyxelPartyid)));

            Caption = 'Sell-to customer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; NoSendfilonPost; Boolean)
        {
            Caption = 'Skip sending on POST';
        }
        field(24; Bill2Customer; Code[20])
        {
            Caption = 'Bill to customer';
            TableRelation = customer;
        }
        field(25; UpdateCustOnStatus; Boolean)
        {
            Caption = 'Update customer on status';
        }
        field(26; AutorejectedFutureSOOver; Integer)
        {
            Caption = 'Auto reject orders with shipdate over days in the future';
        }
        field(27; OnlyReleaseafterStatus; Boolean)
        {
            Caption = 'Only allow release after confirmed status';
        }
        field(28; OnlyReleaseafterStatusvalue; text[20])
        {
            Caption = 'status value for Only allow release after confirmed status';
        }
        field(29; AutoRejectOrderbelowlcy; decimal)
        {
            Caption = 'Auto reject orders below LCY value';
        }
        field(30; Locationcode; code[10]
         )
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(31; URL_Get_RCT; text[200])
        {
            caption = 'URL Get restricted Token';
        }
        field(32; applicationID; Text[100])
        {
            caption = 'Application ID';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }


    procedure cleanSO()
    var
        so: record "Sales Header";
    begin
        SO.setrange("Document Type", SO."Document Type"::Order);
        So.Setrange("Document Date", 0D, 20250511D);
        So.setfilter(AmazonePoNo, '<>%1', '');
        if SO.findset then
            repeat
                SO.Delete(true);
            until SO.next = 0;

    end;

    //

    Procedure deleteshiptoaddress()
    var
        so: record "Sales Header";
        amaz: record "Amazon Setup";
        customer: record Customer;
        sa: record "Ship-to Address";
    begin
        amaz.setrange(ActiveClient, true);
        if amaz.findset then
            repeat
                customer.setrange(AMAZONID, amaz.ZyxelPartyid);
                if customer.findset then
                    repeat
                        sa.setrange("Customer No.", customer."No.");
                        sa.setfilter(Name, '<>%1', '');
                        if sa.findset then
                            repeat

                                so.SetRange("Sell-to Customer No.", customer."No.");
                                so.setrange("Ship-to Code", sa.Code);
                                if so.isempty then
                                    sa.delete(true);
                            until sa.next = 0;
                    until customer.next = 0;


            until amaz.next = 0;
    end;


}
