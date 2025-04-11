Page 50355 "Posted Warehouse Inbound List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Warehouse Inbound List';
    CardPageID = "Warehouse Inbound Card";
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Inbound Header";
    SourceTableView = sorting("Warehouse Status", "Expected Receipt Date")
                      where("Completely Received" = const(true));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sender No."; Rec."Sender No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sender Name"; Rec."Sender Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimated Date of Departure"; Rec."Estimated Date of Departure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimated Date of Arrival"; Rec."Estimated Date of Arrival")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sent to Warehouse Date"; Rec."Sent to Warehouse Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Status Update Date"; Rec."Last Status Update Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(navigation)
        {
            action("Warehouse Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Response';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rcpt. Response List";
                RunPageLink = "Customer Reference" = field("No.");
            }
        }
    }
}
