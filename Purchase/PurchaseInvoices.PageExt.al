pageextension 50305 PurchaseInvoicesZX extends "Purchase Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("eCommerce Order"; Rec."eCommerce Order")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        modify("Purchaser Code")
        {
            Visible = true;
        }
        modify(IncomingDocAttachFactBox)
        {
            Visible = false;
        }
        addafter("Job Queue Status")
        {
            field("From SO No."; Rec."From SO No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Dist. PO#"; Rec."Dist. Purch. Order No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Dist. PO# field.';
            }
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("On Hold"; Rec."On Hold")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter(Control1901138007)
        {
            part(Control36; "Purch. Comment FaxtBox")
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
        addafter("&Invoice")
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
        if not Rec.FindFirst() then;  // 03-11-17 ZY-LD 001
    end;

    var
        recServEnviron: Record "Server Environment";
        zText001: Label 'Has all related items been receipt posted, and is ready to assign?\Answer: %1.';
}
