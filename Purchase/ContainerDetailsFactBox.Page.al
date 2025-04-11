Page 50030 "Container Details FactBox"
{
    Caption = 'Container Details';
    Editable = false;
    PageType = ListPart;
    SourceTable = "VCK Shipping Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity to Receive';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
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
            action(View)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View';
                Image = View;
                RunObject = Page "VCK Container Details";
                RunPageLink = "Purchase Order No." = field("Purchase Order No."),
                              "Purchase Order Line No." = field("Purchase Order Line No."),
                              Archive = const(false);
            }
        }
    }
}
