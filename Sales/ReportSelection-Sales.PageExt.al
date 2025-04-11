pageextension 50171 ReportSelectionSalesZX extends "Report Selection - Sales"
{
    layout
    {
        addafter("Report Caption")
        {
            field("Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
