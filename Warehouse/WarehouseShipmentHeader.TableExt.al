tableextension 50235 WarehouseShipmentHeaderZX extends "Warehouse Shipment Header"
{
    // 001. 02-11-23 ZY-LD 000 - New field.

    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50000; "Sales Order No."; Code[20])
        {
            CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("No."),
                                                                              "Source Type" = const(37),
                                                                              "Source Document" = const("Sales Order")));
            Caption = 'Sales Order No.';
            Description = '20-02-19 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purchase Header";
        }
        field(50001; "Transfer Order No."; Code[20])  // 02-11-23 ZY-LD 001
        {
            CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("No."),
                                                                              "Source Type" = const(5741),
                                                                              "Source Document" = const("Outbound Transfer")));
            Caption = 'Transfer Order No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Transfer Header";
        }

    }
}
