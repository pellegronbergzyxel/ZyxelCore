pageextension 50002 PostedTransferRcptSubformZX extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(ExpectedReceiptDate; Rec.ExpectedReceiptDate)
            {
                ApplicationArea = Basic, Suite, Location, Planning, Warehouse;
                Visible = false;
                ToolTip = 'Specifies the date you expect the items to be available in your warehouse - copied from the container detail / purchase line.';
            }
            field(PurchaseOrderNo; Rec.PurchaseOrderNo)
            {
                ApplicationArea = Basic, Suite, Location, Planning, Warehouse;
                Visible = false;
                ToolTip = 'Specifies the purchase order number - copied from the container detail / purchase line.';
            }
            field(PurchaseOrderLineNo; Rec.PurchaseOrderLineNo)
            {
                ApplicationArea = Basic, Suite, Location, Planning, Warehouse;
                Visible = false;
                ToolTip = 'Specifies the purchase order line number - copied from the container detail / purchase line.';
            }
        }
    }
}
