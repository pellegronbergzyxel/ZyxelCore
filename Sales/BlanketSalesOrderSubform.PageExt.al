pageextension 50197 BlanketSalesOrderSubformZX extends "Blanket Sales Order Subform"
{
    layout
    {
        addafter("Allow Invoice Disc.")
        {
            field("Qty. Blanket on Sales Order"; Rec."Qty. Blanket on Sales Order")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
