pageextension 50146 PostedSalesShipmentZX extends "Posted Sales Shipment"
{
    layout
    {
        addafter("No.")
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

    trigger OnDeleteRecord(): Boolean
    var
        DeleteNotAllowedErr: Label 'Deletion not allowed!';
    begin
        Error(DeleteNotAllowedErr);
    end;
}
