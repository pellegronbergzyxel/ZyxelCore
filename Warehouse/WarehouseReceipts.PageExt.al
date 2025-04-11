pageextension 50279 WarehouseReceiptsZX extends "Warehouse Receipts"
{
    layout
    {
        modify("Sorting Method")
        {
            Visible = false;
        }
        modify("Document Status")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        addafter("Assignment Date")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sales Return Order No."; Rec."Sales Return Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control5; "Rcpt. Response FactBox")
            {
                Caption = 'VCK Response';
                SubPageLink = "Customer Reference" = field("Purchase Order No.");
            }
        }
    }

    actions
    {
        addfirst(Category_Process)
        {
            actionref(Comments_Promoted; "Co&mments")
            { }
            actionref(Posted_WhseReceipts_Promoted; "Posted &Whse. Receipts")
            { }
        }
        addafter(Posting)
        {
            Group(Warehouse)
            {
                Caption = '&Warehouse';
                action("Response List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Response List';
                    Image = Warehouse;
                    RunObject = Page "Rcpt. Response List";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 19-02-19 ZY-LD 001
    end;

    var
        Text001: Label 'Delete %1 and set "Completely Invoiced" = Yes on unposted "Sales Return Order Lines".';
        DeleteSalesReturnOrderVisible: Boolean;
}
