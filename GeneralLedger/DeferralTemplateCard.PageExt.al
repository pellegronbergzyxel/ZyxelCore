pageextension 50232 DeferralTemplateCardZX extends "Deferral Template Card"
{
    layout
    {
        addafter("Period Description")
        {
            field("Deferral Line Description"; Rec."Deferral Line Description")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
