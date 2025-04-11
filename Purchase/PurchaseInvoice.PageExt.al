pageextension 50133 PurchaseInvoiceZX extends "Purchase Invoice"
{
    layout
    {
        addafter("Campaign No.")
        {

            field(IsEICard; Rec.IsEICard)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Is EICard field.';
            }
        }
        modify("Posting Description")
        {
            Visible = true;
        }
        movelast("Invoice Details"; "Posting Description")
        addafter("Posting Description")
        {

            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the VAT Registration No. Zyxel field.';
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ToolTip = 'Normally "Buy-from Country/Region Code" is used on the "Item Ledger Entries", but on Intercompany Transactions it will give us a wrong "Country/Region Code". This field is therefore filled with the "Country/Region Code" from the "Location Code" on Intercompany Transactions.\Beside that you use the field for normal vendors, if they ship from another country than the "Buy-from Country/Region Code" country.';
        }
        addafter("Ship-to Country/Region Code")
        {
            field("Ship-to VAT"; Rec."Ship-to VAT")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Ship-to VAT field.';
            }
        }
        addafter("Pay-to Contact")
        {

            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
        }
        modify(IncomingDocAttachFactBox)
        {
            Visible = false;
        }
        addlast(factboxes)
        {
            part("Purch. Comment FaxtBox"; "Purch. Comment FaxtBox")
            {
                ApplicationArea = All;
                Caption = 'Purch. Comment';
                Visible = false;
                SubPageLink = "No." = field("No."),
                              "Document Type" = field("Document Type"),
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
    }

    actions
    {
        addafter(Approvals)
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
        addafter(MoveNegativeLines)
        {
            action("Import Purchase Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Purchase Lines';
                Image = ImportExcel;

                trigger OnAction()
                var
                    ImportSalesLine: Report "Import Sales Line";
                begin
                    Clear(ImportSalesLine);
                    ImportSalesLine.Init(Rec."Document Type", Rec."No.");
                    ImportSalesLine.RunModal;
                end;
            }
        }
        addlast("F&unctions")
        {
            group(Correction)
            {
                Caption = 'Correction';
                action(QTYError)
                {
                    Caption = 'QTY Base error correction';
                    ApplicationArea = all;
                    Image = Warning;
                    trigger OnAction()
                    var
                        tempcorrection: codeunit TempCorrection;
                    begin
                        if confirm('Do want to check and correct qty<>qty (base) for this PI and posted ledgers') then begin
                            tempcorrection.coritemledgersandPRFromPI(rec);
                            CurrPage.Update(false);
                        end
                    end;
                }

            }
        }
    }

    var
        PurchLines: Record "Purchase Line";
        repImportVCKCharge: Report "Item Chemical Report";
        recServEnviron: Record "Server Environment";
        zText001: Label 'Has all related items been receipt posted, and is ready to assign?\Answer: %1.';
        zText002: Label 'Do you want to re-assign %1?';

    local procedure GetCompanyKey(): Text[500]
    begin
        case CompanyName() of
            'ZyXEL (RHQ) Go LIVE':
                exit('DefaultCompanyKey');
            else
                exit('DefaultCompanyKey');
        end;
    end;
}
