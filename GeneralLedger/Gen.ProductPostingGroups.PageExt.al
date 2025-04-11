pageextension 50174 GenProductPostingGroupsZX extends "Gen. Product Posting Groups"
{
    layout
    {
        addafter("Auto Insert Default")
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addfirst(navigation)
        {
            action("Return Reason Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Return Reason Code';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "G.P.P. Group Ret. Reason Relat";
                RunPageLink = "Gen. Prod. Posting Group" = field(Code);
            }
            action(Overshipment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unshipped Sales Order Lines';
                Image = Shipment;
                RunObject = Page "Sales Ord. Line with Overship.";
                RunPageLink = "Gen. Prod. Posting Group" = field(Code);
            }
        }
    }
}
