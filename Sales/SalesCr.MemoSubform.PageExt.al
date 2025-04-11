pageextension 50140 SalesCrMemoSubformZX extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Location Code")
        {
            Editable = true;
        }
        addfirst(Control1)
        {
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Qty. Assigned")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                Visible = false;
            }
        }
        addafter("ShortcutDimCode8")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("External Document Position No."; Rec."External Document Position No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Invoice Disc. Pct.")
        {
            field(TotalSalesHeaderLineDiscountAmount; TotalSalesHeader."Line Discount Amount")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Line Discount Amount';
                Editable = false;
            }
            field(TotalSalesLineAmountPlusTotalSalesLineLineDiscountAmount; TotalSalesLine.Amount + TotalSalesHeader."Line Discount Amount")
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = StrSubstNo(zText001, Currency.Code);
                Caption = 'Total Amount Excl. Disc.';
                DecimalPlaces = 2 : 2;
                Editable = false;
                Style = Strong;
                StyleExpr = true;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Currency.InitRoundingPrecision();
    end;

    trigger OnAfterGetCurrRecord()
    var
        DocumentTotals: Codeunit "Document Totals";
    begin
        DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        SalesLineEvent.OnAfterDeleteSalesLinePage(Rec);  // 31-01-18 ZY-LD 002
    end;

    var
        SalesLineEvent: Codeunit "Sales Header/Line Events";
        zText001: Label 'Total Excl. Disc (%1)';
        Currency: Record Currency;

    procedure GetOrderTotals() rValue: Decimal
    var
        recSalesLine: Record "Sales Line";
    begin
        //>> 23-11-20 ZY-LD 003
        if Rec."Document No." <> '' then begin
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetFilter("Document No.", Rec."Document No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            if recSalesLine.FindSet() then
                repeat
                    rValue += recSalesLine.Quantity * recSalesLine."Unit Price";
                until recSalesLine.Next() = 0;
        end;
        //<< 23-11-20 ZY-LD 003
    end;
}
