Page 50094 "VCK Shipping Detail"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "VCK Shipping Detail";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Warehouse Inbound")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Inbound';
                Image = Document;
                RunObject = Page "Warehouse Inbound Card";
                RunPageLink = "No." = field("Document No.");
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageLink = "No." = field("Purchase Order No.");
                RunPageView = where("Document Type" = const(Order));
            }
            action("Unshipped Quantity")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unshipped Quantity';
                Image = Shipment;
                RunObject = Page "Purchase Lines";
                RunPageLink = "Document Type" = const(Order), Type = const(Item), OriginalLineNo = filter(<> 0);
            }
        }
    }


    procedure SetFilter(SalesOrderNo: Code[20])
    begin
        Rec.SetFilter("Purchase Order No.", SalesOrderNo);
    end;
}
