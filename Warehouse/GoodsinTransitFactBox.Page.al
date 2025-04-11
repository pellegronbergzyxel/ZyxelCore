Page 50008 "Goods in Transit FactBox"
{
    // 001. 14-01-19 ZY-LD 000 - Created.

    Caption = 'Goods in Transit Details';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            field("Goods in Transit to Receive"; Rec."Goods in Transit to Receive")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Quantity to Receive';
                DecimalPlaces = 0 : 0;
            }
            field("Goods in Transit Receipt"; Rec."Goods in Transit Receipt")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Quantity Receipt';
                DecimalPlaces = 0 : 0;
            }
            field("""Goods in Transit to Receive""-""Goods in Transit Receipt"""; Rec."Goods in Transit to Receive" - Rec."Goods in Transit Receipt")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Total';
                DecimalPlaces = 0 : 0;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        VendorInvoiceNo := '';
        recContDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Invoice No.");
        recContDetail.SetRange("Purchase Order No.", Rec."Document No.");
        recContDetail.SetRange("Purchase Order Line No.", Rec."Line No.");
        if recContDetail.FindSet then
            repeat
                if VendorInvoiceNo = '' then
                    VendorInvoiceNo := recContDetail."Invoice No."
                else
                    VendorInvoiceNo := ', ' + recContDetail."Invoice No.";

                recContDetail.SetRange("Invoice No.", recContDetail."Invoice No.");
                recContDetail.FindLast;
                recContDetail.SetRange("Invoice No.");
            until recContDetail.Next() = 0;
    end;

    var
        VendorInvoiceNo: Text;
        recContDetail: Record "VCK Shipping Detail";

    local procedure ShowContainerDetails()
    var
        recContDetail: Record "VCK Shipping Detail";
    begin
        recContDetail.SetRange("Purchase Order No.", Rec."Document No.");
        recContDetail.SetRange("Purchase Order Line No.", Rec."Line No.");
        recContDetail.SetRange(Archive, false);
        Page.RunModal(Page::"Goods in Transit", recContDetail);
    end;
}
