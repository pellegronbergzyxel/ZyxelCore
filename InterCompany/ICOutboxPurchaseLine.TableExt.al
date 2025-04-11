tableextension 50183 ICOutboxPurchaseLineZX extends "IC Outbox Purchase Line"
{
    fields
    {
        field(50000; "Return Reason Code"; Code[10])
        {
        }
        field(50103; "IC Payment Terms"; Code[10])
        {
            Caption = 'IC Payment Terms';
            Description = '20-09-18 ZY-LD 001';
            TableRelation = "Payment Terms";
        }
    }
}
