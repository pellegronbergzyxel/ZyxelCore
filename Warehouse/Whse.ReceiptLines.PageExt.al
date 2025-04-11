pageextension 50282 WhseReceiptLinesZX extends "Whse. Receipt Lines"
{
    layout
    {
        addafter(Control1)
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Line Amount"; Rec."Line Amount")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        modify(ShowDocument)
        {
            Promoted = true;
            PromotedCategory = Process;
        }

    }
}
