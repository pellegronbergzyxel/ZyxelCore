pageextension 50207 DimensionsZX extends Dimensions
{
    layout
    {
        addafter("Consolidation Code")
        {
            field("Replicate Together with CoA"; Rec."Replicate Together with CoA")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
