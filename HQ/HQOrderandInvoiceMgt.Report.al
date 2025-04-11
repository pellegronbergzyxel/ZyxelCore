report 50054 "HQ Order and Invoice Mgt."
{
    Caption = 'HQ Order and Invoice Mgt.';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SplitPurchaseOrder; SplitPurchaseOrder)
                    {
                        Caption = 'Split Purchase Order Line';
                        ToolTip = 'Split and update purchase order lines based on the received unshipped purchase orders.';
                    }
                    field(RcptPostGIT; RcptPostGIT)
                    {
                        Caption = 'Receipt Post Goods in Transit';
                        ToolTip = 'Receipt post the purchase orders into location "In Transit" based on the received HQ sales document. At the same time will a transfer order be created per container. The transfer order will be posted when the products is receipt at the warehouse.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        Process: Boolean;
        UnshipPurchOrderMgt: Codeunit "Unshipped Purchase Order Mgt.";
        lText001: Label 'Do you want to split purchase order lines based on unshipped purchase order lines?';
    begin

        if SplitPurchaseOrder then begin
            if GuiAllowed then
                Process := Confirm(lText001)
            else
                Process := true;

            if Process then
                UnshipPurchOrderMgt.Run();
        end;

        if RcptPostGIT then;
    end;

    var
        SplitPurchaseOrder: Boolean;
        RcptPostGIT: Boolean;
}
