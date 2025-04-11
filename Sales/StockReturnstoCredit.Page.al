Page 50210 "Stock Returns to Credit"
{
    Caption = 'Stock Returns to Credit';
    CardPageID = "Warehouse Inbound Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Warehouse Inbound Header";

    layout
    {
        area(content)
        {
            repeater(Control23)
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
                field("Location Code"; Rec."Location Code")
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
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
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
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
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
                RunObject = Page "Rcpt. Response List";
                RunPageLink = "Customer Reference" = field("No.");
            }
        }
        area(processing)
        {
            action("Create Sales Cr. Memo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Sales Cr. Memo';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CreateSalesCreditMemo(false);
                end;
            }
            action("Change Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    recWhseIndbHead.SetRange("No.", Rec."No.");
                    Clear(CngWhseStatusInbound);
                    CngWhseStatusInbound.InitReport(Rec."Warehouse Status", Rec."Document Status", Rec."Location Code");
                    CngWhseStatusInbound.SetTableview(recWhseIndbHead);
                    CngWhseStatusInbound.RunModal;
                end;
            }
        }
    }

    var
        CreateandReleaseMgt: Codeunit "Create and Release Whse. Inbou";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        CngWhseStatusInbound: Report "Cng. Whse. Status - Inbound";
        Text001: label 'Do you want to release all open documents?';
        Text002: label 'Do you want to re-send container details?';
        Text003: label 'Container Details for %1 is re-sent.';
}
