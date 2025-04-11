pageextension 50267 ReturnReasonsZX extends "Return Reasons"
{
    layout
    {
        addafter("Inventory Value Zero")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Reverse Quantity"; Rec."Reverse Quantity")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Use on Sales Return Order"; Rec."Use on Sales Return Order")
            {
                ApplicationArea = Basic, Suite;
                Tooltip = 'If you tick off this field, it can be selected as return reason on a sales return order.';
            }
        }
    }
}
