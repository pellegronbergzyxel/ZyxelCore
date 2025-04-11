pageextension 50215 DetailedVendorLedgEntriesZX extends "Detailed Vendor Ledg. Entries"
{
    actions
    {
        addfirst(navigation)
        {
            action("Show Vendor Ledger Entry")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Vendor Ledger Entry';
                Image = VendorLedger;
                RunObject = Page "Vendor Ledger Entries";
                RunPageLink = "Entry No." = field("Vendor Ledger Entry No.");
            }
        }
    }
}
