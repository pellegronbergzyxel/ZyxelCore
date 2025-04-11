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
            Description = '14-11-19 ZY-LD 002';
        }
        field(50003; "Send Warning for Freight Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Send Warning for Fraight Time (days)';
            Description = '25-11-19 ZY-LD 003';
        }
        field(50004; "Read Incoterms City From"; Option)
        {
            Caption = 'Read Incoterms City From';
            Description = '11-12-20 ZY-LD 004';
            OptionCaption = 'Ship-to City,Location City';
            OptionMembers = "Ship-to City","Location City";
        }
        field(50005; "Default on Customs Invoice"; Boolean)
        {
            Description = '23-05-22 ZY-LD 005';
        }
    }
}
