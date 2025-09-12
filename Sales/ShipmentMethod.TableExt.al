tableextension 50105 ShipmentMethodZX extends "Shipment Method"
{
    fields
    {
        field(50001; "Delivery Time"; DateFormula)
        {
        }
        field(50002; "Send Invoice to Warehouse"; Boolean)
        {
            Caption = 'Send Inv. to Warehouse at "Waiting for Invoice"';
        }
        field(50003; "Send Warning for Freight Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Send Warning for Fraight Time (days)';
        }
        field(50004; "Read Incoterms City From"; Option)
        {
            Caption = 'Read Incoterms City From';
            OptionCaption = 'Ship-to City,Location City';
            OptionMembers = "Ship-to City","Location City";
        }
        field(50005; "Default on Customs Invoice"; Boolean)
        {
        }
        field(50006; "Shipping Days"; DateFormula) //08-09-2025 BK #525482
        {
            Caption = 'Shipping Days';
        }
    }
}
