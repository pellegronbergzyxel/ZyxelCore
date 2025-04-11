page 50029 "Related Quantity FactBox"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Related Quantity FactBox';
    PageType = CardPart;
    SourceTable = "Inbound Comparition";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Order Outstanding Qty. Split"; Rec."Order Outstanding Qty. Split")
                {
                    Visible = false;
                }
                field("Order Outstanding Quantity"; Rec."Order Outstanding Quantity" + Rec."Order Outstanding Qty. Split")
                {
                    DecimalPlaces = 0 : 0;
                }
                field(UnshippedQuantityGeneral; Rec."Unshipped Quantity")
                {

                }
                field(UnpostedGoodsinTransitGeneral; Rec."Unposted Goods in Transit")
                {
                    Visible = false;
                }
                field("Posted Goods in Transit"; Rec."Posted Goods in Transit" + Rec."Unposted Goods in Transit")
                {
                    Caption = 'Goods in Transit';
                    DecimalPlaces = 0 : 0;
                }
                field(UnshippedPlusGIT; Rec."Unposted Goods in Transit" + Rec."Posted Goods in Transit" + Rec."Unshipped Quantity")
                {
                    Caption = 'Unshipped + GIT';
                    DecimalPlaces = 0 : 0;
                }
                field(Difference; Rec."Unposted Goods in Transit" + Rec."Posted Goods in Transit" + Rec."Unshipped Quantity" - Rec."Order Outstanding Quantity" - Rec."Order Outstanding Qty. Split")
                {
                    ToolTip = 'Specifies the difference between "Unshipped + GIT" minus order quantity.';
                    DecimalPlaces = 0 : 0;
                }
            }
            group(Related)
            {
                Caption = 'Related / Unshipped / GIT';

                field("Related Order Outstanding Qty."; Rec."Related Order Outstanding Qty.")
                {
                    Caption = 'Related Order Outst. Qty.';
                    ToolTip = 'Show the purchase line outstanding quantity that is related to unshipped purchase order.';
                }
                field("Unshipped Quantity"; Rec."Unshipped Quantity")
                {
                }
                field("Unrelated Order Outst. Qty."; Rec."Unrelated Order Outst. Qty.")
                {
                    Caption = 'Unrelated Order Outst. Qty.';
                    ToolTip = 'Show the purchase line outstanding quantity that is unrelated to unshipped purchase order, but related to unposted goods in transit.';
                }
                field("Unposted Goods in Transit"; Rec."Unposted Goods in Transit")
                {
                }
                group(Invoice)
                {
                    field("Order Qty. to Invoice"; Rec."Order Qty. to Invoice")
                    {
                        ToolTip = 'Specifies the receipt posted quantity, that not have been posted yet.';
                    }
                    field("Order Quantity Invoiced"; Rec."Order Quantity Invoiced")
                    {
                        ToolTip = 'Specifies the invoiced quantity for the order line.';
                    }
                    field("HQ Invoice Qty. to Invoice"; Rec."HQ Invoice Qty. to Invoice")
                    {
                        ToolTip = 'Specifies the quantity not yet invoiced on the sales invoice received from HQ.';
                    }
                    field("HQ Invoice Quantity Invoiced"; Rec."HQ Invoice Quantity Invoiced")
                    {
                        ToolTip = 'Specifies the quantity invoiced on the sales invoice received from HQ.';
                    }
                }
            }
        }
    }
    var
        pagexx: Page "Sales Order";
}
