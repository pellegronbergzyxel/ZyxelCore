pageextension 50244 ItemReferenceEntriesZX extends "Item Reference Entries"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = true;
        }
        addafter("Unit of Measure")
        {
            field("Add EAN Code to Delivery Note"; Rec."Add EAN Code to Delivery Note")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
