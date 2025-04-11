Page 50351 "Whse. Inbound Order Subpage"
{
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "VCK Shipping Detail";
    SourceTableView = sorting("Document No.", "Pallet No. 2")
                      where("Document No." = filter(<> ''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Description"; Rec."Item Description")
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
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = OutstandingQuantityVisible;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Archive; Rec.Archive)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted (Archived)';
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Order';
                Image = Document;

                trigger OnAction()
                begin
                    case Rec."Order Type" of
                        Rec."order type"::"Purchase Order":
                            begin
                                recPurchHead.Get(recPurchHead."document type"::Order, Rec."Purchase Order No.");
                                Page.RunModal(Page::"Purchase Order", recPurchHead);
                            end;
                        Rec."order type"::"Sales Return Order":
                            begin
                                recSalesHead.Get(recSalesHead."document type"::"Return Order", Rec."Purchase Order No.");
                                Page.RunModal(Page::"Sales Return Order", recSalesHead);
                            end;
                    end;
                end;
            }
            action("Close Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set to posted';
                Image = Close;

                trigger OnAction()
                begin
                    if Confirm(Text001, true) then begin
                        Rec.Archive := true;
                        Rec.Modify(true);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        OutstandingQuantityVisible := Rec."Order Type" = Rec."order type"::"Purchase Order";
    end;

    var
        recPurchHead: Record "Purchase Header";
        recSalesHead: Record "Sales Header";
        Text001: label 'Do you want to set the line to posted?';
        OutstandingQuantityVisible: Boolean;
}
