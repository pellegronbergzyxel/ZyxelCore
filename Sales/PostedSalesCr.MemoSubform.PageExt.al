pageextension 50151 PostedSalesCrMemoSubformZX extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        modify("Unit Cost (LCY)")
        {
            Visible = true;
        }
        addfirst(Control1)
        {
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Return Reason Code")
        {
            field("Location Code"; Rec."Location Code")
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
    }

    actions
    {
        addafter(DeferralSchedule)
        {
            action("Item Charge &Assignment")
            {
                AccessByPermission = TableData "Item Charge" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Item Charge &Assignment';
                Image = ItemCosts;
                RunObject = Page "Posted Item Charge (Sales-CrM)";
                RunPageLink = "Document No." = field("Document No."),
                              "Document Line No." = field("Line No.");
            }
        }
    }
}
