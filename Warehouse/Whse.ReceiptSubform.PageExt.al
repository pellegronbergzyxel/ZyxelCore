pageextension 50257 WhseReceiptSubformZX extends "Whse. Receipt Subform"
{
    layout
    {
        modify("Qty. per Unit of Measure")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Warehouse Inbound No."; Rec."Warehouse Inbound No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Line Amount"; Rec."Line Amount")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Qty. per Unit of Measure")
        {
            field("Source Line No."; Rec."Source Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
