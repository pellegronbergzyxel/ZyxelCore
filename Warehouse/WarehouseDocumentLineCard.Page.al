Page 50277 "Warehouse Document Line Card"
{
    Caption = 'Warehouse Document Line Card';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "VCK Shipping Detail";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
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
