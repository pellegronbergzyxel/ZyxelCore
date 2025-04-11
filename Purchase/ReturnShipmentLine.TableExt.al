tableextension 50223 ReturnShipmentLineZX extends "Return Shipment Line"
{
    fields
    {
        field(50001; "Requested Date From Factory"; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50002; "ETD Date"; Date)
        {
            Caption = 'Factory Schedule Date';
            Description = 'DT1.0';
            Editable = false;

            trigger OnValidate()
            var
                lrShipmentMethod: Record "Shipment Method";
            begin
            end;
        }
        field(50003; ETA; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50004; "Actual shipment date"; Date)
        {
            Description = 'DT1.0';
            Editable = false;

            trigger OnValidate()
            var
                lrShipmentMethod: Record "Shipment Method";
            begin
            end;
        }
    }
}
