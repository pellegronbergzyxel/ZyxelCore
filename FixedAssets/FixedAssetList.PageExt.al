pageextension 50239 FixedAssetListZX extends "Fixed Asset List"
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
        addafter("Search Description")
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Book Value"; Rec."Book Value")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
