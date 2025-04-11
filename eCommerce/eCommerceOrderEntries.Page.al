page 50310 "eCommerce Order Entries"
{
    Caption = 'eCommerce Order Entries';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "eCommerce Order Line";

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
                field("eCommerce Order Id"; Rec."eCommerce Order Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Qty; Qty)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                }
                field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Country Code"; Rec."Ship-to Country Code")
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
            action("eCommerce Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Order';
                Image = SpecialOrder;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "eCommerce Order Card";
                RunPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            action("Posted Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Document';
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec."Transaction Type" = Rec."transaction type"::Order then begin
                        SalesInvHead.SetCurrentkey("Sell-to Customer No.", "External Document No.");
                        SalesInvHead.SetRange("External Document No.", Rec."eCommerce Order Id");
                        Page.RunModal(Page::"Posted Sales Invoices", SalesInvHead);
                    end else begin
                        SalesCrMemoHead.SetCurrentkey("Sell-to Customer No.", "External Document No.");
                        SalesCrMemoHead.SetRange("External Document No.", Rec."eCommerce Order Id");
                        Page.RunModal(Page::"Posted Sales Credit Memos", SalesCrMemoHead);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Qty := Rec.Quantity;
        if Rec."Transaction Type" = Rec."transaction type"::Refund then
            Qty := -Rec.Quantity;
    end;

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;  // 26-09-18 ZY-LD 001
    end;

    var
        Qty: Integer;
        SalesInvHead: Record "Sales Invoice Header";
        SalesCrMemoHead: Record "Sales Cr.Memo Header";
}
