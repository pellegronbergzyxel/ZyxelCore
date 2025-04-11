pageextension 50214 DetailedCustLedgEntriesZX extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Cust. Ledger Entry Document No"; Rec."Cust. Ledger Entry Document No")
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
            action("Customer Ledger Entry")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Ledger Entry';
                Image = CustomerLedger;
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Entry No." = field("Cust. Ledger Entry No.");
            }
        }
    }
}
