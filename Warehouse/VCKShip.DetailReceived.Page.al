Page 50025 "VCK Ship. Detail Received"
{
    Caption = 'VCK Ship. Detail Received';
    Editable = false;
    PageType = ListPart;
    SourceTable = "VCK Shipping Detail Received";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Show)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show';
                Image = ShowSelected;
                RunObject = Page "Shipping Details Received";
                RunPageLink = "Container No." = field("Container No."),
                              "Invoice No." = field("Invoice No."),
                              "Purchase Order No." = field("Purchase Order No."),
                              "Purchase Order Line No." = field("Purchase Order Line No."),
                              "Pallet No." = field("Pallet No."),
                              "Item No." = field("Item No."),
                              "Shipping Method" = field("Shipping Method"),
                              "Order No." = field("Order No.");
            }
        }
    }
}
