Page 50041 "Purchase Order Line FactBox"
{
    Caption = 'Purchase Order Line Details';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Quantity Received"; Rec."Quantity Received")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Quantity Invoiced"; Rec."Quantity Invoiced")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }
}
