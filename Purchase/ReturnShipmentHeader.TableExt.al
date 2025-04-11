tableextension 50222 ReturnShipmentHeaderZX extends "Return Shipment Header"
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50001; "Requested Date From Factory"; Date)
        {
            Description = 'DT1.00';
            Editable = false;
        }
        field(62015; IsEICard; Boolean)
        {
            Caption = 'Is EICard';
            Description = 'Tectura Taiwan';
        }
        field(62033; "Dist. PO#"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62034; "Dist. E-mail"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
    }
}
