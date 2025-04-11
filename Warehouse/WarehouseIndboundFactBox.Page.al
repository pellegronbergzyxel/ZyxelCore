Page 50095 "Warehouse Indbound FactBox"
{
    Editable = false;
    PageType = CardPart;
    SourceTable = "Warehouse Inbound Header";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Shipper Reference"; Rec."Shipper Reference")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Warehouse Status"; Rec."Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sent to Warehouse Date"; Rec."Sent to Warehouse Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Status Update Date"; Rec."Last Status Update Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Warehouse Inbound")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Inbound';
                Image = Document;
                RunObject = Page "Warehouse Inbound Card";
                RunPageLink = "No." = field("No.");
            }
        }
    }
}
