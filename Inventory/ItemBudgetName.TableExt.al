tableextension 50229 ItemBudgetNameZX extends "Item Budget Name"
{
    fields
    {
        field(50000; Campaign; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Freight Cost Value Entry"."Value Entry No.";
        }
        field(50001; Budget; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50002; Archive; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50003; Master; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50004; "Backup Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50005; "Backup User ID"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50006; Opportunity; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50007; Forecast; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50008; "Block Email on Forecast"; Boolean)
        {
            caption = 'Block Email on Receiving Forecast';
        }
    }
}
