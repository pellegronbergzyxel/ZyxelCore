pageextension 50401 "Intercompany Setup" extends "Intercompany Setup"
{
    layout
    {
        addlast(General)
        {
            field("Sample Item"; Rec."Sample Item")  // 02-05-24 - ZY-LD 000
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
