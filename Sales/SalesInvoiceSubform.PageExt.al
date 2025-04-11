pageextension 50130 SalesInvoiceSubformZX extends "Sales Invoice Subform"
{
    layout
    {
        modify("Location Code")
        {
            Editable = false;
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
        addafter("Line No.")
        {
            field("IC Payment Terms"; Rec."IC Payment Terms")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Zero Unit Price Accepted"; Rec."Zero Unit Price Accepted")
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
                CaptionClass = StrSubstNo(zText001, CUrrency.Code);
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
        SalesLineEvent.OnAfterDeleteSalesLinePage(Rec);  // 31-01-18 ZY-LD 003
    end;

    var
        SalesLineEvent: Codeunit "Sales Header/Line Events";
        zText001: Label 'Total Excl. Disc (%1)';
        Currency: Record Currency;
}
