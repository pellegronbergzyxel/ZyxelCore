pageextension 50188 VATBusinessPostingGroupsZX extends "VAT Business Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Concur Vendor"; Rec."Concur Vendor")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
