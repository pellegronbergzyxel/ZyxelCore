pageextension 50265 SalesReturnOrderZX extends "Sales Return Order"
{
    layout
    {
        addafter("Prices Including VAT")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("Ship-to VAT"; Rec."Ship-to VAT")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                //Visible = VATRegistrationNoSellToVisible;  // 12-02-24 ZY-LD 000
            }
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
    }

    actions
    {
        modify("&Print")
        {
            Caption = '&Print Confirmation';
        }
        addafter("Whse. Receipt Lines")
        {
            action("Warehouse Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Response';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rcpt. Response List";
                RunPageLink = "Shipment No." = field("No.");
            }
        }
        addafter(Approval)
        {
            action("Email Confirmation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email Confirmation';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.EmailSalesHeader(Rec);
                end;
            }
        }
        addafter("Request Approval")
        {
            group(Import)
            {
                Caption = 'Import';
                action("Import Stock Return")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Stock Return';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //>> 30-12-19 ZY-LD 001
                        Clear(ImportCreditMemoLine);
                        ImportCreditMemoLine.ReportInit(3, Rec."No.", Rec."Location Code", '');
                        ImportCreditMemoLine.RunModal;
                        //<< 30-12-19 ZY-LD 001
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 08-09-22 ZY-LD 002
    end;

    var
        ImportCreditMemoLine: Report "Import Price Protection";
        VATRegistrationNoSellToVisible: Boolean;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        //>> 08-09-22 ZY-LD 002
        VATRegistrationNoSellToVisible :=
          ZGT.IsRhq and
          ((ZGT.IsZComCompany and (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.")) or
           (ZGT.IsZNetCompany and (Rec."VAT Registration No." <> Rec."Ship-to VAT")));
        //<< 08-09-22 ZY-LD 002
    end;
}
