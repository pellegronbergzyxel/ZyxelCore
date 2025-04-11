pageextension 50291 CustomerDetailsFactBoxZX extends "Customer Details FactBox"
{
    layout
    {
        addafter("No.")
        {
            field("Forecast Territory"; Rec."Forecast Territory")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
