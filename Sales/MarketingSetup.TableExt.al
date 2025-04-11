tableextension 50200 MarketingSetupZX extends "Marketing Setup"
{
    fields
    {
        field(50000; "Use Cust and Vend No. for Cont"; Boolean)
        {
            Caption = 'Use Cust. and Vend. No. for Contact No.';
            Description = '07-02-20 ZY-LD 001';
        }
        field(50001; "Sales Quote Template Code"; Code[10])
        {
            Caption = 'Sales Quote Template Code';
            TableRelation = "Customer Templ.";
        }
    }
}
