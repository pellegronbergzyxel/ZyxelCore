tableextension 50213 TransferReceiptHeaderZX extends "Transfer Receipt Header"
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50000; "Serial No. Attached"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("VCK Delivery Document SNos" where("Sales Order No." = field("Transfer Order No.")));
            Caption = 'Serial No. Attached';
            Description = '24-08-22 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50029; "Serial Numbers Status"; Option)
        {
            Caption = 'Serial Numbers Status';
            Description = '03-05-19 ZY-LD 001';
            OptionMembers = " ",Attached,Sent,Rejected,Accepted;
        }
    }

    keys
    {
        key(Key50000; "Serial Numbers Status")
        {
        }
    }
}
