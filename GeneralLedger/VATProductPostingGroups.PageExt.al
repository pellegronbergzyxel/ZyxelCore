pageextension 50189 "VAT ProductPostingGroupsZX" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Turkish Code"; Rec."Turkish Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
