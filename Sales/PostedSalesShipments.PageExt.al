pageextension 50158 PostedSalesShipmentsZX extends "Posted Sales Shipments"
{
    layout
    {
        addfirst(Control1)
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addafter("&Shipment")
        {
            group("Order")
            {
                Caption = 'Order';
                action("Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order';
                    Image = "Order";
                    RunObject = Page "Sales Order";
                    RunPageLink = "No." = field("Order No.");
                    RunPageView = where("Document Type" = const(Order));
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;  // 27-10-17 ZY-LD 002
    end;
}
