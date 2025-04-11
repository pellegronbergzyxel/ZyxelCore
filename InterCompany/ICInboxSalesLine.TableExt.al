tableextension 50188 ICInboxSalesLineZX extends "IC Inbox Sales Line"
{
    fields
    {
        field(50000; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
    }
}
