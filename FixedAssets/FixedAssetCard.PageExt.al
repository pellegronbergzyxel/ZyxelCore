pageextension 50238 FixedAssetCardZX extends "Fixed Asset Card"
{
    layout
    {
        addafter("No.")
        {
            field("Old Number"; Rec."Old Number")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Budgeted Asset")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
