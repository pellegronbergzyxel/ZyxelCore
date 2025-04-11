page 50027 "Inbound Comparition"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Inbound Comparition';
    PageType = List;
    SourceTable = "Inbound Comparition";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Original Line No."; Rec."Original Line No.")
                {
                    ToolTip = 'Specifies the value of the Original Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Original Quantity"; Rec."Original Quantity")
                {
                    ToolTip = 'Specifies the value of the Original Quantity field.';
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    ToolTip = 'Specifies the value of the Order Quantity field.';
                }
                field("Order Outstanding Quantity"; Rec."Order Outstanding Quantity")
                {
                    Visible = false;
                }
                field("Order Outstanding Qty. Split"; Rec."Order Outstanding Qty. Split")
                {
                    Visible = false;
                }
                field("Order Outstanding Quantity Total"; Rec."Order Outstanding Quantity" + Rec."Order Outstanding Qty. Split")
                {
                    Caption = 'Order Outstanding Quantity';
                    ToolTip = 'Specifies the value of the Order Outstanding Quantity field.';
                    DecimalPlaces = 0 : 0;
                }
                field("Unshipped Quantity"; Rec."Unshipped Quantity")
                {
                    ToolTip = 'Specifies the value of the Unshipped Quantity field.';
                }
                field("Unposted Goods in Transit"; Rec."Unposted Goods in Transit")
                {
                    ToolTip = 'Specifies the value of the Unposted Goods in Transit field.';
                    Visible = false;
                }
                field("Posted Goods in Transit"; Rec."Posted Goods in Transit")
                {
                    ToolTip = 'Specifies the value of the Posted Goods in Transit field.';
                    Visible = false;
                }
                field("Goods in Transit"; Rec."Unposted Goods in Transit" + Rec."Posted Goods in Transit")
                {
                    ToolTip = 'Specifies the total of "Unposted Goods in Transit" and "Posted Goods in Transit".';
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        ShippingDetail: Record "VCK Shipping Detail";
                        ContainerDetail: Page "VCK Container Details";
                    begin
                        ShippingDetail.SetRange("Purchase Order No.", Rec."Document No.");
                        ShippingDetail.SetRange("Purchase Order Line No.", Rec."Original Line No.");

                        ContainerDetail.SetTableView(ShippingDetail);
                        ContainerDetail.Editable(false);
                        ContainerDetail.RunModal;
                    end;
                }
                field("Unshipped + GIT"; Rec."Unposted Goods in Transit" + Rec."Posted Goods in Transit" + Rec."Unshipped Quantity")
                {
                    ToolTip = 'Specifies the total quantity that is unshipped or in transit. The quantity should match order quantity.';
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;
                }
                field(Difference; Rec."Unposted Goods in Transit" + Rec."Posted Goods in Transit" + Rec."Unshipped Quantity" - Rec."Order Outstanding Quantity" - Rec."Order Outstanding Qty. Split")
                {
                    ToolTip = 'Specifies the difference between "Unshipped + GIT" minus order quantity.';
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(RelatedQuantityFaxtbox; "Related Quantity FactBox")
            {
                ApplicationArea = All;
                Caption = 'Details';
                Visible = true;
                SubPageLink = "Document No." = FIELD("Document No."),
                              "Original Line No." = FIELD("Original Line No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Item Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Ledger Entries';
                Image = ItemLedger;
                RunObject = page "Item Ledger Entries";
                RunPageLink = "Item No." = field("Item No."),
                              "Location Code" = field("In Transit Location Filter");
                ShortcutKey = 'Ctrl+F7';
                ToolTip = 'Update inbound comparition with entries from purchase order, unshipped purchase order and goods in transit.';
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                Image = Document;
                RunObject = page "Purchase Order";
                RunPageLink = "Document Type" = const(Order),
                              "No." = field("Document No.");
                ToolTip = 'Update inbound comparition with entries from purchase order, unshipped purchase order and goods in transit.';
            }
        }
        area(Processing)
        {
            action("Update Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Lines';
                Image = UpdateShipment;
                ToolTip = 'Update inbound comparition with entries from purchase order, unshipped purchase order and goods in transit.';
                trigger OnAction()
                var
                    InboundComparition: Record "Inbound Comparition";
                    lText001: Label 'Do you want to update the table?';
                begin
                    if Confirm(lText001) then
                        InboundComparition.UpdateTable();
                end;
            }
            action("Split Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Split Purchase Order';
                Image = Splitlines;
                ToolTip = 'Update and split purchase order lines based on the unshipped purchase order lines.';
                RunObject = report "HQ Order and Invoice Mgt.";
            }
        }
    }
    trigger OnOpenPage()
    var
        InventorySetup: Record "Inventory Setup";

    begin
        InventorySetup.get;
        Rec.SetFilter("In Transit Location Filter", '%1|%2', InventorySetup.GoodsInTransitLocationCode, InventorySetup.GoodsInTransitInTransitCode);
    end;
}
