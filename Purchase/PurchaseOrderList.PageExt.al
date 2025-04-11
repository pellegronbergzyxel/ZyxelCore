pageextension 50304 PurchaseOrderListZX extends "Purchase Order List"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("EShop Order Sent"; Rec."EShop Order Sent")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(SentToAllIn; Rec.SentToAllIn)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sent to Warehouse';
            }
        }
    }

    actions
    {
        modify(Post)
        {
            Enabled = PostButtonsEnabled;
        }
        modify(PostAndPrint)
        {
            Enabled = PostButtonsEnabled;
        }
        modify(PostBatch)
        {
            Enabled = PostButtonsEnabled;
        }
        addafter(Warehouse)
        {
            group(History)
            {
                Caption = 'History';
            }
            action("Purchase Order History")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order History';
                Image = History;
                RunObject = Page "Rcpt Responsce Subform";
                RunPageLink = "Order No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 08-01-19 ZY-LD 001

        SetActions();  // 13-03-19 ZY-LD 002
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 13-03-19 ZY-LD 002
    end;

    var
        PostButtonsEnabled: Boolean;

    local procedure SetActions()
    var
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        PostButtonsEnabled := SalesHeadEvent.HidePostButtons(Rec."Location Code", '');  // 13-03-19 ZY-LD 002
    end;
}
