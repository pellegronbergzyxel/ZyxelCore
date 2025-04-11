pageextension 50149 PostedSalesInvoiceSubformZX extends "Posted Sales Invoice Subform"
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
            field("Related Delivery Document"; Rec."Related Delivery Document")
            {
                ApplicationArea = Basic, Suite;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("External Document Position No."; Rec."External Document Position No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
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
                RunObject = Page "Posted Item Charge (Sales-Inv)";
                RunPageLink = "Document No." = field("Document No."),
                              "Document Line No." = field("Line No.");
            }
        }
    }
}
