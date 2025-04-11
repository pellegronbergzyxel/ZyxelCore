page 50056 "Logicall Cue"
{
    PageType = CardPart;
    SourceTable = "ZY Logistics Cue";

    layout
    {
        area(content)
        {
            cuegroup(NotInvoiced)
            {
                Caption = 'Not Invoiced';
                field("Items not Invoiced"; Rec."Items not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Items not Invoiced';
                    Image = Receipt;
                }
                field("Sales Orders Not Invoiced"; Rec."Sales Orders Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Orders not Invoiced';
                    Image = Receipt;
                }
            }
            cuegroup(Response)
            {
                Caption = 'Warehouse Response';
                field("Whse. Purcase Resp. not Posted"; Rec."Whse. Purcase Resp. not Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Whse. Purchase Response not Posted';
                    Image = Receipt;
                }
                field("Whse. Ship Resp. not Posted"; Rec."Whse. Ship Resp. not Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Whse. Shipment Response not Posted';
                    Image = Receipt;
                }
            }
            cuegroup(StockReturn)
            {
                Caption = 'Stock Return';
                field("Return Order Not Credited"; Rec."Return Order Not Credited")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Stock Return not Posted';
                    Image = Receipt;
                    DrillDownPageId = "Stock Returns to Credit";
                }
            }
            cuegroup(warehouse)
            {
                Caption = 'Warehouse';
                field("Item Can Not Replicate to VCK"; Rec."Item Can Not Replicate to VCK")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Items can not Replicate to Logicall';
                    Image = Receipt;
                }
                field("Container Details Over Due"; Rec."Container Details Over Due")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '´Contaner Details Over Due';
                    Image = Receipt;
                }
                field("Warehouse Inventory Diff."; Rec."Warehouse Inventory Diff.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Difference';
                    Image = Receipt;
                }
            }
        }
    }
}
