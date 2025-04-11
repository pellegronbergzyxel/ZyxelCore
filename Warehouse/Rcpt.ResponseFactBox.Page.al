Page 50055 "Rcpt. Response FactBox"
{
    Caption = 'Rcpt. Response FactBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Rcpt. Response Header";
    SourceTableView = where(Open = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
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
                Caption = 'Show Document';
                Image = TransferReceipt;
                RunObject = Page "Rcpt. Response Card";
                RunPageLink = "Order No." = field("Order No."),
                              "Entry No." = field("Entry No.");
            }
            action("Post Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Response';
                Image = Post;

                trigger OnAction()
                begin
                    PostRespMgt.PostPurchaseOrderResponse(Rec."No.");
                end;
            }
        }
    }

    var
        PostRespMgt: Codeunit "Post Rcpt. Response Mgt.";
}
