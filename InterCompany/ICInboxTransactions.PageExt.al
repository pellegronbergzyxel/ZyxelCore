pageextension 50222 ICInboxTransactionsZX extends "IC Inbox Transactions"
{
    layout
    {
        addafter("Line Action")
        {
            field(eCommerce; Rec.eCommerce)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        modify(Accept)
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Complete Line Actions")
        {
            Promoted = true;
            PromotedCategory = Process;

            trigger OnBeforeAction()
            begin
                SI.SetHideSalesDialog(true);
            end;

            trigger OnAfterAction()
            begin
                SI.SetHideSalesDialog(false);
            end;
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;

    var
        SI: Codeunit "Single Instance";
}
