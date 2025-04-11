pageextension 50306 PurchaseCreditMemosZX extends "Purchase Credit Memos"
{
    layout
    {
        modify("Purchaser Code")
        {
            Visible = true;
        }
        addafter("Job Queue Status")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter(Control1901138007)
        {
            part(Control25; "Purch. Comment FaxtBox")
            {
                Caption = 'Purch. Comment';
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
        }
    }

    actions
    {
        addafter("&Credit Memo")
        {
            group("&Vendor")
            {
                Caption = '&Vendor';
                action("Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger Entries';
                    Image = LedgerEntries;
                    RunObject = Page "Vendor Ledger Entries";
                    RunPageLink = "Vendor No." = field("Pay-to Vendor No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Pay-to Card")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pay-to Card';
                    Image = Card;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = field("Pay-to Vendor No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Buy-from Card")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Buy-from Card';
                    Image = VendorContact;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = field("Buy-from Vendor No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then; // 03-11-17 ZY-LD 001 Sort Descending.
    end;
}
