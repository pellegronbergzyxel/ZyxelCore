pageextension 50660 "Item Invoicing Factbox" extends "Item Invoicing FactBox"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Qty. Stock for Sales"; Rec.CalcAvailableStock(true))
            {
                ApplicationArea = Basic, Suite;
                Visible = QtyStockforSalesVisible;
                Caption = 'Qty. Stock for Sales';
                DecimalPlaces = 0 : 0;
                ToolTip = '"Qty. Stock for Sales" = "Qty. On-Hand" - "Qty. on Sales Order Confirmed" - "Trans. Ord. Shipment (Qty.)"';
            }
        }
    }

    trigger OnOpenPage()
    begin
        if ZGT.IsZNetCompany() then
            SetQtyStockForSalesVisible(true);
    end;

    var
        [InDataSet]
        QtyStockforSalesVisible: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure SetQtyStockForSalesVisible(NewQtyStockforSalesVisible: Boolean)
    begin
        QtyStockforSalesVisible := NewQtyStockforSalesVisible;
    end;
}