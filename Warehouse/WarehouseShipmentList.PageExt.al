pageextension 50281 WarehouseShipmentListZX extends "Warehouse Shipment List"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addafter("&Shipment")
        {
            group("&Warehouse")
            {
                Caption = '&Warehouse';
                Image = Line;
                action("Response List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Response List';
                    Image = Warehouse;
                    RunObject = Page "Shipment Response List";
                }
            }
        }
    }

    var
        Text001: Label 'Do you want to post all incomiing shipments?';
        PostShipRespMgt: Codeunit "Post Ship Response Mgt.";
}
