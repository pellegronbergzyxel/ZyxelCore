pageextension 50200 PurchaseLinesZX extends "Purchase Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Vendor Invoice No.';
            }
        }
        addafter("Variant Code")
        {
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies ETD Date';
            }
            field("Actual shipment date"; Rec."Actual shipment date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Actual Shipment Date';
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies ETA';
            }
        }
        addafter("Line No.")
        {
            field(OriginalLineNo; Rec.OriginalLineNo)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies OrginalLineNo';
            }
        }
        addafter("Expected Receipt Date")
        {
            field("Requested Date From Factory"; Rec."Requested Date From Factory")
            {
                //16-06-2025 BK #511337
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Requested Date From Factory';
            }

            field("Order Date"; Rec."Order Date")
            {
                //25-06-2025 BK #511337
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Order Date';
            }

            Field(DocumentDate; DocumentDate)
            {
                Caption = 'Document Date';
                ToolTip = 'Specifies Document Date';
                ApplicationArea = Basic, Suite;
                //16-06-2025 BK #511337                
            }

            Field(ShippingRequestNote; ShippingRequestNote)
            {
                Caption = 'Shipping Request Note';
                ToolTip = 'Specifies Shipping Request Note';
                ApplicationArea = Basic, Suite;
                //16-06-2025 BK #511337
            }

        }
    }

    //16-06-2025 BK #511337
    trigger OnAfterGetRecord()
    var
        PurchaseHeader: Record "Purchase Header";

    begin
        If PurchaseHeader.get(rec."Document Type", rec."Document No.") then begin
            DocumentDate := PurchaseHeader."Document Date";
            ShippingRequestNote := PurchaseHeader."Shipping Request Notes";
        end else begin
            clear(DocumentDate);
            clear(ShippingRequestNote);
        end;
    end;

    var
        DocumentDate: Date;
        ShippingRequestNote: Text[96];
}
