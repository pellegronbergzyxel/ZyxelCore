pageextension 50293 ItemWarehouseFactBoxZX extends "Item Warehouse FactBox"
{
    layout
    {
        Modify("No.")
        {
            Visible = false;
            ToolTip = 'Specifies the unique number that identifies the item.';
        }
        Modify("Identifier Code")
        {
            Visible = false;
            ToolTip = 'Specifies the identifier code for the item, such as a barcode or RFID tag.';
        }
        Modify("Base Unit of Measure")
        {
            Visible = false;
            ToolTip = 'Specifies the base unit of measure for the item, such as pieces, kilograms, or liters.';
        }
        Modify("Put-away Unit of Measure Code")
        {
            Visible = false;
            ToolTip = 'Specifies the unit of measure used when putting away the item in inventory.';
        }
        Modify("Purch. Unit of Measure")
        {
            Visible = false;
            ToolTip = 'Specifies the unit of measure used when purchasing the item from a vendor.';
        }
        Modify("Item Tracking Code")
        {
            Visible = false;
            ToolTip = 'Specifies the item tracking method for the item, such as serial numbers or lot numbers.';
        }
        Modify("Special Equipment Code")
        {
            Visible = false;
            ToolTip = 'Specifies any special equipment required to handle or store the item, such as refrigeration or hazardous material handling.';
        }
        Modify("Last Phys. Invt. Date")
        {
            Visible = false;
            ToolTip = 'Specifies the date when the last physical inventory was taken for the item.';
        }
        Modify(NetWeight)
        {
            Visible = false;
            ToolTip = 'Specifies the net weight of the item, excluding any packaging or containers.';
        }
        Modify("Warehouse Class Code")
        {
            Visible = false;
            ToolTip = 'Specifies the warehouse class for the item, which determines how the item is stored and handled in the warehouse.';
        }
        addfirst(content)
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 0;
                Importance = Promoted;
                Visible = false;
                HideValue = IsNonInventoriable;
                ToolTip = 'Specifies the quantity of the item that is currently in inventory at the specified location.';
            }
            field("Total Inventory"; Rec."Total Inventory")
            {
                ApplicationArea = Basic, Suite;
                HideValue = IsNonInventoriable;
                ToolTip = 'Specifies the total quantity of the item in inventory across all locations.';
            }
            group(EU2)
            {
                Caption = 'EU2';
                Visible = EU2GroupVisible;

                field(InventoryEU2; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. On-Hand';
                    DecimalPlaces = 0 : 0;
                    HideValue = IsNonInventoriable;
                    ToolTip = 'Specifies the quantity of the item that is currently in inventory at the specified location.';
                }
                field("Qty. on Sales OrderEU2"; Rec."Qty. on Sales Order Total")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total quantity of the item that is on sales orders.';
                }
                field("Qty. on Sales Order ConfirmedEU2"; Rec."Qty. on Sales Order Conf.Total")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total quantity of the item that is on confirmed sales orders.';
                }
                field("Qty. on Delivery Document"; Rec."Qty. on Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total quantity of the item that is on delivery documents.';
                }
                field("Trans. Ord. Shipment (Qty.)EU2"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity of the item that is allocated for transfer order shipments.';
                }
                field("Tr. Or. Ship (Qty.) ConfirmedEU2"; Rec."Tr. Or. Ship (Qty.) Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity of the item that is confirmed for transfer order shipments.';
                }
                field("CalcAvailableStock(TRUE)"; Rec.CalcAvailableStock(true))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. Stock for Sales';
                    DecimalPlaces = 0 : 0;
                    ToolTip = '"Qty. Stock for Sales" = "Qty. On-Hand" - "Qty. on Sales Order Confirmed" - "Trans. Ord. Shipment (Qty.)"';
                }
            }
            group("VCK ZNET")
            {
                Caption = 'VCK ZNET';
                Visible = VCKZNETGroupVisible;
                field(InventoryVCK; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. On-Hand';
                    DecimalPlaces = 0 : 0;
                    HideValue = IsNonInventoriable;
                    ToolTip = 'Specifies the quantity of the item that is currently in inventory at the specified location.';
                }
                field("Qty. on Sales OrderVCK"; Rec."Qty. on Sales Order Total")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total quantity of the item that is on sales orders.';
                }
                field("Qty. on Sales Order ConfirmedVCK"; Rec."Qty. on Sales Order Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total quantity of the item that is on confirmed sales orders.';
                }
                field("Qty. on Delivery DocumentVCK"; Rec."Qty. on Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total quantity of the item that is on delivery documents.';
                }
                field("Trans. Ord. Shipment (Qty.)VCK"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity of the item that is allocated for transfer order shipments.';
                }
                field("Tr. Or. Ship (Qty.) ConfirmedVCK"; Rec."Tr. Or. Ship (Qty.) Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity of the item that is confirmed for transfer order shipments.';
                }
                field("RMA Reserved Quantity"; Rec."RMA Reserved Quantity") //23-10-2025 BK #517106
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'RMA Reserved Qty';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the safety stock quantity for the item to prevent stockouts.';
                }
                field("Qty. Stock for Sales"; Rec.CalcAvailableStock(true))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. Stock for Sales';
                    DecimalPlaces = 0 : 0;
                    ToolTip = '"Qty. Stock for Sales" = "Qty. On-Hand" - "Qty. on Sales Order Confirmed" - "Trans. Ord. Shipment (Qty.)"';
                }

            }
            group("Picking Dates")
            {
                Caption = 'Picking Dates';
                Visible = PickingDateVisible;
                field("Marked Picking Date"; Rec."Marked Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the item was marked for picking.';
                }
                field("Unconfirmed Picking Date"; Rec."Unconfirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the item was picked but not yet confirmed.';
                }
                field("Confirmed Picking Date"; Rec."Confirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the item picking was confirmed.';
                }
            }
            group(HQ)
            {
                Caption = 'HQ';

                field("recItemHQ.""Qty. on Purch. Order ZX"""; recItemHQ."Qty. on Purch. Order ZX")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. on Purch. Order';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the total quantity of the item that is on purchase orders.';

                    trigger OnDrillDown()
                    begin
                        DrillDownPurchaseOrderLine(0);  // 08-07-19 ZY-LD 004
                    end;
                }
                field(GoodsInTransit; recItemHQ."Qty. on Shipping Detail" - recItemHQ."Qty. on Ship. Detail Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Goods in Transit';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the quantity of the item that is currently in transit from the vendor to the warehouse.';

                    //trigger OnLookup(var Text: Text): Boolean
                    trigger OnDrillDown()
                    begin
                        OnLookUpGoodsInTransit(0);
                    end;
                }
                field("recItemHQ.""HQ Unshipped Purchase Order"""; recItemHQ."HQ Unshipped Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unshipped Quantity';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = UnshippedQtyStyle;
                    ToolTip = 'Specifies the quantity of the item that has been ordered but not yet shipped by the vendor.';

                    trigger OnDrillDown()
                    begin
                        DrillDownUnshippedQuantity(0);
                    end;
                }
            }
            group("Zyxel / ZNet")
            {
                Caption = 'Zyxel / ZNet';
                field("Qty. on Purch. Order2"; recItemEmea."Qty. on Purch. Order ZX")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. on Purch. Order';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the total quantity of the item that is on purchase orders.';

                    trigger OnDrillDown()
                    begin
                        DrillDownPurchaseOrderLine(1);
                    end;
                }
                field(GoodsInTransit2; recItemEmea."Qty. on Shipping Detail" - recItemEmea."Qty. on Ship. Detail Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Goods in Transit';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the quantity of the item that is currently in transit from the vendor to the warehouse.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        OnLookUpGoodsInTransit(1);
                    end;
                }
                field("HQ Unshipped Purchase Order2"; recItemEmea."HQ Unshipped Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unshipped Quantity';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = UnshippedQtyStyle;
                    ToolTip = 'Specifies the quantity of the item that has been ordered but not yet shipped by the vendor.';

                    trigger OnDrillDown()
                    begin
                        DrillDownUnshippedQuantity(1);
                    end;
                }
            }
            group("Sales- and Transfer Order")
            {
                Caption = 'Sales- and Transfer Order';
                field("Qty. on Reciept Lines"; Rec."Qty. on Reciept Lines")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                    ToolTip = 'Specifies the total quantity of the item that is on receipt lines.';
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Order in Transit';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the total quantity of the item that is currently in transit due to transfer orders.';
                }
                field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Specifies the quantity of the item that is allocated for transfer order shipments.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if ZGT.IsRhq() then begin
            recHQSetup.FindFirst();
            recHQSetup.TestField("SBU Filter Channel");

            recInvSetup.Get();
            recInvSetup.TestField("AIT Location Code");
            recPurchSetup.Get();
            if ZGT.IsZNetCompany() then begin
                recPurchSetup.TestField("EShop Vendor No. CH");
                Rec.SetRange("Buy-from Vendor No. Filter", recPurchSetup."EShop Vendor No. CH");
            end else begin
                recPurchSetup.TestField("EShop Vendor No.");
                Rec.SetRange("Buy-from Vendor No. Filter", recPurchSetup."EShop Vendor No.");
            end;
        end;

        VCKZNETGroupVisible := ZGT.IsZNetCompany();
        EU2GroupVisible := ZGT.IsZComCompany();

        if UserSetup.Get(UserId()) then
            PickingDateVisible := UserSetup."Show Picking Date"
        else
            PickingDateVisible := false;
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();


        recItemHQ.SetFilter("Buy-from Vendor No. Filter", VendorEvent.GetFilterZyxelVendors(1, true));
        recItemHQ.SetAutoCalcFields("Qty. on Purch. Order ZX", "Qty. on Shipping Detail", "Qty. on Ship. Detail Received", "HQ Unshipped Purchase Order");
        recItemHQ.Get(Rec."No.");

        recItemEmea.SetFilter("Buy-from Vendor No. Filter", '%1', VendorEvent.GetFilterZyxelVendors(1, false));
        recItemEmea.SetAutoCalcFields("Qty. on Purch. Order ZX", "Qty. on Shipping Detail", "Qty. on Ship. Detail Received", "HQ Unshipped Purchase Order");
        recItemEmea.Get(Rec."No.");

    end;

    var

        recItemHQ: Record Item;
        recItemEmea: Record Item;
        UserSetup: Record "User Setup";

        recInvSetup: Record "Inventory Setup";
        recHQSetup: Record "Headquarter Setup";
        recPurchSetup: Record "Purchases & Payables Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        VendorEvent: Codeunit "Vendor Event";
        EU2GroupVisible: Boolean;
        VCKZNETGroupVisible: Boolean;
        HQGroupVisible: Boolean;
        EMEAGroupVisible: Boolean;
        PickingDateVisible: Boolean;
        IsNonInventoriable: Boolean;
        IsInventoriable: Boolean;
        UnshippedQtyStyle: Text;


    local procedure SetActions()
    begin
        if Rec."Qty. on Purch. Order ZX" - (Rec."Qty. on Shipping Detail" - Rec."Qty. on Ship. Detail Received") <> Rec."HQ Unshipped Purchase Order" then
            UnshippedQtyStyle := 'Unfavorable'
        else
            UnshippedQtyStyle := 'StandardAccent';

        HQGroupVisible := false;
        EMEAGroupVisible := false;
        if ZGT.IsZNetCompany() then begin  // ZNet
            if StrPos(recHQSetup."SBU Filter Channel", Rec.SBU) <> 0 then
                HQGroupVisible := true
            else
                if Rec.SBU <> '' then
                    EMEAGroupVisible := true
                else
                    HQGroupVisible := true;
        end else  // Zyxel
            if StrPos(recHQSetup."SBU Filter Channel", Rec.SBU) <> 0 then
                EMEAGroupVisible := true
            else
                HQGroupVisible := true;

        EnableControls();
    end;

    local procedure DrillDownPurchaseOrderLine(Type: Option HQ,EMEA)
    var
        recPurchLine: Record "Purchase Line";
    begin
        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
        recPurchLine.SetRange(Type, recPurchLine.Type::Item);
        recPurchLine.SetRange("No.", Rec."No.");
        recPurchLine.SetFilter("Outstanding Quantity", '<>0');

        if Type = Type::HQ then
            recPurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            recPurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));

        Page.RunModal(Page::"Purchase Lines", recPurchLine);

    end;

    local procedure DrillDownUnshippedQuantity(Type: Option HQ,EMEA)
    var
        recUnshipPurchOrder: Record "Unshipped Purchase Order";

    begin
        // Rolled back to old unshipped.
        recUnshipPurchOrder.SETRANGE("Item No.", Rec."No.");
        IF Type = Type::HQ THEN
            recUnshipPurchOrder.SETFILTER("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, TRUE))
        ELSE
            recUnshipPurchOrder.SETFILTER("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, FALSE));
        PAGE.RUNMODAL(PAGE::"Unshipped Purchase Order", recUnshipPurchOrder);


    end;

    local procedure OnLookUpGoodsInTransit(Type: Option HQ,EMEA)
    var
        recGoodsInTrans: Record "VCK Shipping Detail";
        recGoodsInTransTmp: Record "VCK Shipping Detail" temporary;
        recUserSetup: Record "User Setup";
        NewEntryNo: Integer;
    begin
        recGoodsInTrans.SetRange("Item No.", Rec."No.");
        if Type = Type::HQ then
            recGoodsInTrans.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            recGoodsInTrans.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));
        recGoodsInTrans.SetRange("Order Type", recGoodsInTrans."order type"::"Purchase Order");

        if not recUserSetup.Get(UserId()) or
          (recUserSetup."Show Goods in Transit as" = recUserSetup."show goods in transit as"::Merged)
        then begin
            recGoodsInTrans.SetRange(Archive, false);
            if recGoodsInTrans.FindSet() then
                repeat
                    recGoodsInTransTmp.SetRange("Purchase Order No.", recGoodsInTrans."Purchase Order No.");
                    recGoodsInTransTmp.SetRange("Invoice No.", recGoodsInTrans."Invoice No.");
                    recGoodsInTransTmp.SetRange(Location, recGoodsInTrans.Location);
                    recGoodsInTransTmp.SetRange(ETA, recGoodsInTrans.ETA);
                    recGoodsInTransTmp.SetRange(ETD, recGoodsInTrans.ETD);
                    recGoodsInTransTmp.SetRange("Expected Receipt Date", recGoodsInTrans."Expected Receipt Date");
                    recGoodsInTransTmp.SetRange("Shipping Method", recGoodsInTrans."Shipping Method");
                    if recGoodsInTransTmp.FindFirst() then begin
                        recGoodsInTransTmp.Quantity += recGoodsInTrans.Quantity;
                        recGoodsInTransTmp.Modify();
                    end else begin
                        NewEntryNo += 1;
                        Clear(recGoodsInTransTmp);
                        recGoodsInTransTmp."Entry No." := NewEntryNo;
                        recGoodsInTransTmp."Item No." := recGoodsInTrans."Item No.";
                        recGoodsInTransTmp."Purchase Order No." := recGoodsInTrans."Purchase Order No.";
                        recGoodsInTransTmp."Invoice No." := recGoodsInTrans."Invoice No.";
                        recGoodsInTransTmp.Location := recGoodsInTrans.Location;
                        recGoodsInTransTmp.Quantity := recGoodsInTrans.Quantity;
                        recGoodsInTransTmp.ETA := recGoodsInTrans.ETA;
                        recGoodsInTransTmp.ETD := recGoodsInTrans.ETD;
                        recGoodsInTransTmp."Expected Receipt Date" := recGoodsInTrans."Expected Receipt Date";
                        recGoodsInTransTmp."Shipping Method" := recGoodsInTrans."Shipping Method";
                        //13-10-2025 BK #525482
                        recGoodsInTransTmp."Calculated ETA Date" := recGoodsInTrans."Calculated ETA Date";
                        recGoodsInTransTmp.Insert();
                    end;
                until recGoodsInTrans.Next() = 0;

            recGoodsInTransTmp.Reset();
            Page.RunModal(Page::"VCK Container Details ETA", recGoodsInTransTmp);
        end else
            Page.RunModal(Page::"VCK Container Details", recGoodsInTrans);
    end;

    local procedure EnableControls()
    begin
        IsNonInventoriable := Rec.IsNonInventoriableType();
        IsInventoriable := Rec.IsInventoriableType();
    end;

    procedure SetLocationFilter(LocationCode: Code[20])
    begin
        Rec."Location Filter" := copystr(LocationCode, 1, 10);
    end;
}
