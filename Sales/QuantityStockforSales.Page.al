Page 50158 "Quantity Stock for Sales"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Quantity Stock for Sales';
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where(Inactive = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Qty. On-Hand';
                    DecimalPlaces = 0 : 0;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Qty. on Sales Order Confirmed"; Rec."Qty. on Sales Order Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Qty. on Delivery Document"; Rec."Qty. on Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Tr. Or. Ship (Qty.) Confirmed"; Rec."Tr. Or. Ship (Qty.) Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("CalcAvailableStock(TRUE)"; Rec.CalcAvailableStock(true))
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Qty. Stock for Sales';
                    DecimalPlaces = 0 : 0;
                    ToolTip = '"Qty. Stock for Sales" = "Qty. On-Hand" - "Qty. on Sales Order Confirmed" - "Trans. Ord. Shipment (Qty.)"';
                }
            }
        }
        area(factboxes)
        {
            part(Control13; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Bin Filter" = field("Bin Filter"),
                              "Variant Filter" = field("Variant Filter"),
                              "Lot No. Filter" = field("Lot No. Filter"),
                              "Serial No. Filter" = field("Serial No. Filter");
            }
            part(Control12; "Item Invoicing FactBox")
            {
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Bin Filter" = field("Bin Filter"),
                              "Variant Filter" = field("Variant Filter"),
                              "Lot No. Filter" = field("Lot No. Filter"),
                              "Serial No. Filter" = field("Serial No. Filter");
            }
            part(Control10; "Item Replenishment FactBox")
            {
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Bin Filter" = field("Bin Filter"),
                              "Variant Filter" = field("Variant Filter"),
                              "Lot No. Filter" = field("Lot No. Filter"),
                              "Serial No. Filter" = field("Serial No. Filter");
            }
            part(Control9; "Item Planning FactBox")
            {
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Bin Filter" = field("Bin Filter"),
                              "Variant Filter" = field("Variant Filter"),
                              "Lot No. Filter" = field("Lot No. Filter"),
                              "Serial No. Filter" = field("Serial No. Filter");
            }
            part("<Item Picture FactBox>"; "Item Picture FactBox")
            {
                Caption = 'Item Picture';
                SubPageLink = "No." = field("No.");
            }
            systempart(Control6; Links)
            {
            }
            systempart(Control4; Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        WhseClassCode;
        NetWeight;
    end;

    trigger OnOpenPage()
    begin
        if ZGT.IsRhq then begin
            recHQSetup.FindFirst;
            recHQSetup.TestField("SBU Filter Channel");

            Rec.SetRange(Rec."Location Filter", ItemLogisticEvent.GetMainWarehouseLocation);

            recPurchSetup.Get;
            if ZGT.IsZNetCompany then begin
                recPurchSetup.TestField("EShop Vendor No. CH");
                Rec.SetRange(Rec."Buy-from Vendor No. Filter", recPurchSetup."EShop Vendor No. CH");
            end else begin
                recPurchSetup.TestField("EShop Vendor No.");
                Rec.SetRange(Rec."Buy-from Vendor No. Filter", recPurchSetup."EShop Vendor No.");
            end;
        end;

        SI.UseOfReport(8, 50158, 0);  // 14-10-20 ZY-LD 000
    end;

    var
        recHQSetup: Record "Headquarter Setup";
        recPurchSetup: Record "Purchases & Payables Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        VendorEvent: Codeunit "Vendor Event";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        SI: Codeunit "Single Instance";

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Item Card", Rec);
    end;

    local procedure WhseClassCode(): Code[20]
    begin
        exit(Rec."Warehouse Class Code");
    end;

    local procedure NetWeight(): Decimal
    var
        ItemBaseUOM: Record "Item Unit of Measure";
    begin
        if ItemBaseUOM.Get(Rec."No.", Rec."Base Unit of Measure") then
            exit(ItemBaseUOM.Weight);

        exit(0);
    end;

    local procedure DrillDownPurchaseOrderLine(Type: Option HQ,EMEA)
    var
        recPurchLine: Record "Purchase Line";
    begin
        //>> 08-07-19 ZY-LD 004
        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
        recPurchLine.SetRange(Type, recPurchLine.Type::Item);
        recPurchLine.SetRange("No.", Rec."No.");
        recPurchLine.SetFilter("Outstanding Quantity", '<>0');
        //>> 25-11-20 ZY-LD 006
        if Type = Type::HQ then
            recPurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            recPurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));
        //<< 25-11-20 ZY-LD 006
        Page.RunModal(Page::"Purchase Lines", recPurchLine);
        //<< 08-07-19 ZY-LD 004
    end;

    local procedure DrillDownUnshippedQuantity(Type: Option HQ,EMEA)
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("No.", Rec."No.");
        PurchLine.SetFilter(OriginalLineNo, '<>0');
        if Type = Type::HQ then
            PurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            PurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));
        Page.RunModal(Page::"Purchase Lines", PurchLine);
    end;

    local procedure OnLookUpGoodsInTransit(Type: Option HQ,EMEA)
    var
        recGoodsInTrans: Record "VCK Shipping Detail";
    begin
        //>> 25-11-20 ZY-LD 006
        recGoodsInTrans.SetRange("Item No.", Rec."No.");
        if Type = Type::HQ then
            recGoodsInTrans.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            recGoodsInTrans.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));
        recGoodsInTrans.SetRange("Order Type", recGoodsInTrans."order type"::"Purchase Order");
        Page.RunModal(Page::"VCK Container Details", recGoodsInTrans);
        //<< 25-11-20 ZY-LD 006
    end;
}
