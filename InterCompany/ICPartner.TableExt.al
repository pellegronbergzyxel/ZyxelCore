tableextension 50176 ICPartnerZX extends "IC Partner"
{
    fields
    {
        modify("Inbox Details")
        {
            TableRelation = if ("Inbox Type" = const(Database)) Company.Name
            else
            if ("Inbox Type" = const("Web Service")) Company.Name;
        }
        field(50000; "Set Posting Date to Today"; Boolean)
        {
            Caption = 'Set Posting Date to Today';
            Description = '11-01-18 ZY-LD 2018011110000149';
        }
        field(50001; "Set Document Date to Today"; Boolean)
        {
            Caption = 'Set Document Date to Today';
            Description = '11-01-18 ZY-LD 2018011110000149';
        }
        field(50002; "Purchase Order Comm. Type"; Option)
        {
            Description = '26-06-19 ZY-LD 002';
            OptionCaption = ' ,E-Shop,Web Service';
            OptionMembers = " ","E-Shop","Web Service";
        }
        field(50003; "Read Company Infor from Sub"; Boolean)
        {
            Caption = 'Read Company Infor from Subsidary';
            Description = '17-03-21 ZY-LD 003';
        }
        field(50004; Skip_sellCustomer; Boolean)
        {
            Caption = 'Skip Sell-to customer';

        }
    }
}
