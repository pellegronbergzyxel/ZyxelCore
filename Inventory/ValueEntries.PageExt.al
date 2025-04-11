pageextension 50259 ValueEntriesZX extends "Value Entries"
{
    layout
    {
        addafter("Job Ledger Entry No.")
        {
            field("Item Ledger Entry Exists"; Rec."Item Ledger Entry Exists")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("General Ledger")
        {
            action("Ledger E&ntries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger E&ntries';
                Image = ItemLedger;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Entry No." = field("Item Ledger Entry No.");
                RunPageView = sorting("Entry No.");
                ShortCutKey = 'Shift+F7';
            }
        }
    }
}
