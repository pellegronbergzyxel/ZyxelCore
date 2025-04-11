pageextension 50233 MarketingSetupZX extends "Marketing Setup"
{
    layout
    {
        addfirst(Numbering)
        {
            field("Use Cust and Vend No. for Cont"; Rec."Use Cust and Vend No. for Cont")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Duplicates)
        {
            group("Customer Template")
            {
                Caption = 'Customer Template';
                field("Sales Quote Template Code"; Rec."Sales Quote Template Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
