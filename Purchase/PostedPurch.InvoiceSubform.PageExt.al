pageextension 50155 PostedPurchInvoiceSubformZX extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Appl.-to Item Entry")
        {
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Requested Date From Factory"; Rec."Requested Date From Factory")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Actual shipment date"; Rec."Actual shipment date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Routing Reference No."; Rec."Routing Reference No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DimMgt.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCode);  // 23-02-21 ZY-LD 002
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
        DimMgt: Codeunit DimensionManagement;
}
