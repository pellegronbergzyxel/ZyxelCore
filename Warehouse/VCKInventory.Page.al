Page 50096 "VCK Inventory"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "VCK Inventory";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Warehouse; Rec.Warehouse)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Bin; Rec.Bin)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity On Hand"; Rec."Quantity On Hand")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Blocked"; Rec."Quantity Blocked")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Inspecting"; Rec."Quantity Inspecting")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Time Stamp"; Rec."Time Stamp")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
