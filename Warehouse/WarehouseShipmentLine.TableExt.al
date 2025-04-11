tableextension 50236 WarehouseShipmentLineZX extends "Warehouse Shipment Line"
{
    fields
    {
        field(50000; "Delivery Document No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Delivery Document No." where("Document Type" = const(Order),
                                                                            "Document No." = field("Source No."),
                                                                            "Line No." = field("Source Line No.")));
            Caption = 'Delivery Document No.';
            Description = '12-03-19 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66011; "Posted By AIT"; Boolean)
        {
            Description = '12-03-19 ZY-LD 001';
        }
    }
}
