pageextension 50147 PostedSalesShptSubformZX extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Correction)
        {
            field("Picking List No."; Rec."Picking List No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
