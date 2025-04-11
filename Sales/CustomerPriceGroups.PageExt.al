pageextension 50104 CustomerPriceGroupsZX extends "Customer Price Groups"
{
    layout
    {
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
