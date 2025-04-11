pageextension 50137 PurchInvoiceSubformZX extends "Purch. Invoice Subform"
{
    layout
    {
        modify("Location Code")
        {
            Editable = alloweditable;
        }
        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                PurchLineEvent.OnLookupPurchaseLineNo(Rec);  // 15-02-19 ZY-LD 003
            end;
        }
        addafter("No.")
        {
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Original No."; Rec."Original No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies the original item no. when posting a SAMPLE item. The original item no. is storred on the item ledger entry and used when creating intrastat reports.';
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("Requested Date From Factory"; Rec."Requested Date From Factory")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Line No.")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    var
        PurchLineEvent: Codeunit "Purchase Header/Line Events";
        alloweditable: Boolean;

    trigger OnOpenPage()
    var
        Purchasesetup: Record "Purchases & Payables Setup";
    begin
        Purchasesetup.get;
        alloweditable := Purchasesetup.AllowLocationchange;
    end;

}
