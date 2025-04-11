pageextension 50199 SalesLinesZX extends "Sales Lines"
{
    layout
    {
        modify("Shipment Date")
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field("Shipment Date Confirmed"; Rec."Shipment Date Confirmed")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field(SellToCustomerName; SellToCustomerName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sell-to Customer Name';
            }
        }
        addafter("Outstanding Quantity")
        {
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Delivery Document No."; Rec."Delivery Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(ReqDeliveryOverDue; ReqDeliveryOverDue)
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Caption = 'Requested Delivery Over Due';
                Visible = false;
            }
            field("Warehouse Status"; Rec."Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("Show Document")
        {
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Delivery Document No.");
            }
        }
        addafter("Item &Tracking Lines")
        {
            action("Warehouse Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Response';
                Image = List;
                RunObject = Page "Shipment Response List";
                RunPageLink = "Customer Reference" = field("Delivery Document No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Add By Andrew 20100802 (+)
        CustomerCard.Reset();
        CustomerCard.SetRange(CustomerCard."No.", Rec."Sell-to Customer No.");
        if CustomerCard.FindFirst() then begin
            SellToCustomerName := CustomerCard.Name;
        end;
        //Add By Andrew 20100802 (-)

        //>> 03-08-20 ZY-LD 001
        ReqDeliveryOverDue := 0;
        if (Rec."Shipment Date" <> 0D) and (Rec."Requested Delivery Date" <> 0D) then
            ReqDeliveryOverDue := Rec."Shipment Date" - Rec."Requested Delivery Date";
        //<< 03-08-20 ZY-LD 001
    end;

    var
        SellToCustomerName: Text[50];
        CustomerCard: Record Customer;
        ReqDeliveryOverDue: Integer;
}
