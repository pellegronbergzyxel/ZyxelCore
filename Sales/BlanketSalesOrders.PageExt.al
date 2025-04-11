pageextension 50301 BlanketSalesOrdersZX extends "Blanket Sales Orders"
{
    actions
    {
        addafter(Approvals)
        {
            action("Sales Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders';
                Image = OrderList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Sales Order List";
                RunPageLink = "Blanket Order No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 03-05-21 ZY-LD 001
    end;
}
