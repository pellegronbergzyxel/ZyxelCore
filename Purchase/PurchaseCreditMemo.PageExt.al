pageextension 50134 PurchaseCreditMemoZX extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Campaign No.")
        {
            field(IsEICard; Rec.IsEICard)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("On Hold"; Rec."On Hold")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Contact")
        {
            field("Ship-from Country/Region Code"; Rec."Ship-from Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Normally "Buy-from Country/Region Code" is used on the "Item Ledger Entries", but on Intercompany Transactions it will give us a wrong "Country/Region Code". This field is therefore filled with the "Country/Region Code" from the "Location Code" on Intercompany Transactions.\Beside that you use the field for normal vendors, if they ship from another country than the "Buy-from Country/Region Code" country.';
            }
        }
        addafter(WorkflowStatus)
        {
            part(Control75; "Purch. Comment FaxtBox")
            {
                ApplicationArea = All;
                Caption = 'Purch. Comment';
                Visible = false;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
            part(ItemCommentFactBox; "Item Comment FactBox")
            {
                ApplicationArea = All;
                Caption = 'Item Comment';
                Visible = false;
                SubPageLink = "Table Name" = const(Item),
                              "No." = field("No.");
                Provider = PurchLines;
            }
        }
        moveafter("Buy-from Contact"; "Due Date")
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
        addafter("P&osting")
        {
            group(Import)
            {
                Caption = 'Import';
                action("Import Price Protection and Rebate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Price Protection and Rebate';
                    Image = ImportExcel;

                    trigger OnAction()
                    begin
                        // 25-10-18 ZY-LD 004
                        Clear(ImportCreditMemoLine);
                        ImportCreditMemoLine.ReportInit(8, Rec."No.", Rec."Location Code", '');
                        ImportCreditMemoLine.RunModal;
                        //<< 25-10-18 ZY-LD 004
                    end;
                }
            }
        }
    }

    var
        ImportCreditMemoLine: Report "Import Price Protection";
        zText001: Label 'Has all related items been receipt posted, and is ready to assign?\Answer: %1.';
        zText002: Label 'Do you want to re-assign %1?';
}
