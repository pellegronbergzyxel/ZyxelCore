pageextension 50298 SalesQuotesZX extends "Sales Quotes"
{
    layout
    {
        addafter(Status)
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control9; "Sales Comment Line FactBox")
            {
                Caption = 'Comments - Header';
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
        }
    }

    actions
    {
        modify("Co&mments")
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
        }
        modify(MakeOrder)
        {
            Promoted = true;
            PromotedIsBig = true;
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 26-08-20 ZY-LD 001
    end;
}
