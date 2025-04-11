pageextension 50139 SalesQuoteSubformZX extends "Sales Quote Subform"
{
    layout
    {
        addafter(Type)
        {
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("No.")
        {
            field("End of Life Date"; Rec."End of Life Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Invoice Disc. Pct.")
        {
            field("TotalSalesHeader.""Total Quantity"""; TotalSalesHeader."Total Quantity")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Total Quantity';
                DecimalPlaces = 0 : 0;
                Editable = false;
            }
            field(NoOfLines; NoOfLines)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Number of Lines';
                DecimalPlaces = 0 : 0;
                Editable = false;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        NoOfLines := TotalSalesHeader."No of Lines";  // 25-09-20 ZY-LD 002
    end;

    var
        NoOfLines: Decimal;
}
