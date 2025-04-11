pageextension 50106 ShipmentMethodsZX extends "Shipment Methods"
{
    Caption = 'Shipment Methods / Incoterms';

    layout
    {
        addafter(Description)
        {
            field("Send Invoice to Warehouse"; Rec."Send Invoice to Warehouse")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Send Warning for Freight Time"; Rec."Send Warning for Freight Time")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Send warning to logistics if days between ETD and ETA is less than the value of the field.';
            }
            field("Read Incoterms City From"; Rec."Read Incoterms City From")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Default on Customs Invoice"; Rec."Default on Customs Invoice")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
