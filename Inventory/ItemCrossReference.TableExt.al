tableextension 50206 ItemReferenceZX extends "Item Reference"
{
    fields
    {
        field(50000; "Add EAN Code to Delivery Note"; Boolean)
        {
            Caption = 'Add EAN Code to Delivery Note';
            Description = '17-01-20 ZY-LD 011';
        }
        field(50001; "Cross-Reference EAN Code"; Code[13])
        {
            Caption = 'Cross-Reference EAN Code';
            Description = '17-01-20 ZY-LD 011';
        }
    }
}
