Page 50102 "VCK Archived Container Details"
{
    // 001. 24-10-18 ZY-LD 000 - New field.
    // 002. 15-02-19 ZY-LD 000 - Open previous archived lines.
    // 003. 09-05-19 ZY-LD 2019050910000073 - Delete subtable.

    ApplicationArea = Basic, Suite;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "VCK Shipping Detail";
    SourceTableView = where(Archive = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
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
                field("Item No."; Rec."Item No.")
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
                    Visible = false;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quantity-""Quantity Received"""; Rec.Quantity - Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control5; "VCK Ship. Detail Received")
            {
                Caption = 'Received Details';
                SubPageLink = "Container No." = field("Container No."),
                              "Invoice No." = field("Invoice No."),
                              "Purchase Order No." = field("Purchase Order No."),
                              "Purchase Order Line No." = field("Purchase Order Line No."),
                              "Pallet No." = field("Pallet No."),
                              "Item No." = field("Item No."),
                              Quantity = field(Quantity),
                              "Shipping Method" = field("Shipping Method"),
                              "Order No." = field("Order No.");
            }
            part(Control6; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field(Location);
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
        }
        area(processing)
        {
            action("Archive Multiple Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open the selected lines';
                Image = Archive;
                ToolTip = 'Open the selected lines';

                trigger OnAction()
                begin
                    OpenSelectedLines;  // 15-02-19 ZY-LD 002
                end;
            }
        }
    }

    var
        Text001: label 'Do you want to open %1 line(s)?';
        recShipDetRcpt: Record "VCK Shipping Detail Received";

    local procedure OpenSelectedLines()
    var
        recShipDetail: Record "VCK Shipping Detail";
        recShipDetRcpt: Record "VCK Shipping Detail Received";
    begin
        //>> 15-02-19 ZY-LD 002
        CurrPage.SetSelectionFilter(recShipDetail);
        if Confirm(Text001, true, recShipDetail.Count) then begin
            if recShipDetail.FindSet(true) then
                repeat
                    recShipDetail.Archive := false;
                    recShipDetail.Modify;

                    //>> 09-05-19 ZY-LD 003
                    recShipDetRcpt.SetRange("Container No.", recShipDetail."Container No.");
                    recShipDetRcpt.SetRange("Invoice No.", recShipDetail."Invoice No.");
                    recShipDetRcpt.SetRange("Purchase Order No.", recShipDetail."Purchase Order No.");
                    recShipDetRcpt.SetRange("Purchase Order Line No.", recShipDetail."Purchase Order Line No.");
                    recShipDetRcpt.SetRange("Pallet No.", recShipDetail."Pallet No.");
                    recShipDetRcpt.SetRange("Item No.", recShipDetail."Item No.");
                    recShipDetRcpt.SetRange("Shipping Method", recShipDetail."Shipping Method");
                    recShipDetRcpt.SetRange("Order No.", recShipDetail."Order No.");
                    recShipDetRcpt.ModifyAll("Quantity Received", 0);
                //<< 09-05-19 ZY-LD 003
                until recShipDetail.Next() = 0;

            CurrPage.Update;
        end;
        //<< 15-02-19 ZY-LD 002
    end;
}
