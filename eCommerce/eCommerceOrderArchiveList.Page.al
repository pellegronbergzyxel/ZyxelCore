page 50067 "eCommerce Order Archive List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Order Archive List';
    CardPageID = "eCommerce Order Archive Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "eCommerce Order Archive";
    SourceTableView = sorting("Order Date")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date Archived"; Rec."Date Archived")
                {
                    ApplicationArea = Basic, Suite;
                }
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
                field("Invoice Download"; Rec."Invoice Download")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice Download';
                    Editable = false;
                    ExtendedDatatype = URL;
                    Visible = false;
                }
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-from Country"; Rec."Ship-from Country")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country"; Rec."Ship-to Country")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Type"; Rec."Sell-to Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Export Outside EU"; Rec."Export Outside EU")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Shipment No."; Rec."Sales Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("RHQ Creation Date"; Rec."RHQ Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Give Away Order"; Rec."Give Away Order")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control33; "eCommerce Order Arch. FactBox")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action("Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Invoice';
                    Image = PostedOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "External Document No." = field("eCommerce Order Id");
                }
                action("Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Cr. Memo';
                    Image = PostedCreditMemo;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "External Document No." = field("eCommerce Order Id");
                }
                action("Original eCommerce Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Original eCommerce Document';
                    Image = Document;

                    trigger OnAction()
                    begin
                        Hyperlink(Rec."Invoice Download");
                    end;
                }
            }
        }
        area(processing)
        {
            action("Transfer Old Orders to Archive")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer Old Orders to Archive';
                Image = TransferOrder;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TransferOldeCommerceOrders;
                end;
            }
            action("Batch Update Promo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Update Promo';
                Visible = false;

                trigger OnAction()
                var
                    APIMgt: Codeunit "API Management";
                begin
                    APIMgt.ImportArchiveAdjustment;
                end;
            }
            action("Reverse Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse Order';
                Image = ReverseLines;

                trigger OnAction()
                var
                    recAmzOrdHead: Record "eCommerce Order Header";
                    recAmzArchHead: Record "eCommerce Order Archive";
                    ReverseTransactionType: Option "Order",Refund;
                begin
                    if Rec."Transaction Type" = Rec."transaction type"::Order then
                        ReverseTransactionType := Rec."transaction type"::Refund
                    else
                        ReverseTransactionType := Rec."transaction type"::Order;

                    if recAmzArchHead.Get(ReverseTransactionType, Rec."eCommerce Order Id", Rec."Invoice No.") or
                       recAmzOrdHead.Get(ReverseTransactionType, Rec."eCommerce Order Id", Rec."Invoice No.")
                    then
                        Error(Text004);

                    if Confirm(Text003, false, ReverseTransactionType, Rec."Transaction Type", Rec."eCommerce Order Id") then begin
                        Rec.RestoreeCommerceOrder(1, false, ReverseTransactionType);
                        Message(Text005, ReverseTransactionType, Rec."eCommerce Order Id", Rec."Invoice No.");
                    end;
                end;
            }
            action("Restore Order from Archive")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Restore Order from Archive';
                Image = Restore;
                Visible = RestoreOrderVisible;

                trigger OnAction()
                begin
                    if Confirm(Text001, false, Rec."eCommerce Order Id") then
                        if Confirm(Text002) then
                            Rec.RestoreeCommerceOrder(0, true, 0)
                        else
                            Rec.RestoreeCommerceOrder(0, false, 0);
                end;
            }
            action("Count")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Count';
                Image = Calculate;

                trigger OnAction()
                begin
                    Message('Archived eCommerce Orders: %1', Rec.Count());
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        RestoreOrderVisible := ZGT.UserIsDeveloper;
    end;

    var
        Text001: Label 'Do you want to restore %1 back to eCommerce Order?';
        Text002: Label 'Is it a Correction?';
        Text003: Label 'Do you want to create a %1 %3 based on %2 %3?';
        Text004: Label 'The document cound not be reversed because it already exists.';
        RestoreOrderVisible: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        Text005: Label 'The document has been reversed as\"%1" "%2" "%3",\and is ready to be posted.';
}
