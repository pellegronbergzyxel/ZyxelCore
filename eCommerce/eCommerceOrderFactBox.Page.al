page 50122 "eCommerce Order FactBox"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "eCommerce Order Line Archive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; Rec."Transaction Type")
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
                field("Amount Including VAT"; Rec."Amount Including VAT")
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
            action("Open eCommerce Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open eCommerce Order';
                Image = "Order";
                RunObject = Page "eCommerce Order Archive List";
                RunPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
        }
    }
}
