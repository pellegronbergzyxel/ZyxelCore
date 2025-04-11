pageextension 50293 ItemWarehouseFactBoxZX extends "Item Warehouse FactBox"
{
    layout
    {
        Modify("No.")
        {
            Visible = false;
        }
        Modify("Identifier Code")
        {
            Visible = false;
        }
        Modify("Base Unit of Measure")
        {
            Visible = false;
        }
        Modify("Put-away Unit of Measure Code")
        {
            Visible = false;
        }
        Modify("Purch. Unit of Measure")
        {
            Visible = false;
        }
        Modify("Item Tracking Code")
        {
            Visible = false;
        }
        Modify("Special Equipment Code")
        {
            Visible = false;
        }
        Modify("Last Phys. Invt. Date")
        {
            Visible = false;
        }
        Modify(NetWeight)
        {
            Visible = false;
        }
        Modify("Warehouse Class Code")
        {
            Visible = false;
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
            }
            field("Total Inventory"; Rec."Total Inventory")
            {
                ApplicationArea = Basic, Suite;
                HideValue = IsNonInventoriable;
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
                }
                field("Qty. on Sales OrderEU2"; Rec."Qty. on Sales Order Total")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Sales Order ConfirmedEU2"; Rec."Qty. on Sales Order Conf.Total")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Delivery Document"; Rec."Qty. on Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Trans. Ord. Shipment (Qty.)EU2"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tr. Or. Ship (Qty.) ConfirmedEU2"; Rec."Tr. Or. Ship (Qty.) Confirmed")
                {
                    ApplicationArea = Basic, Suite;
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
                }
                field("Qty. on Sales OrderVCK"; Rec."Qty. on Sales Order Total")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Sales Order ConfirmedVCK"; Rec."Qty. on Sales Order Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Delivery DocumentVCK"; Rec."Qty. on Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Trans. Ord. Shipment (Qty.)VCK"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tr. Or. Ship (Qty.) ConfirmedVCK"; Rec."Tr. Or. Ship (Qty.) Confirmed")
                {
                    ApplicationArea = Basic, Suite;
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
                }
                field("Unconfirmed Picking Date"; Rec."Unconfirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Confirmed Picking Date"; Rec."Confirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
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

                    //trigger OnLookup(var Text: Text): Boolean
                    trigger OnDrillDown()
                    begin
                        OnLookUpGoodsInTransit(0);  // 25-11-20 ZY-LD 006

                        // //>> 15-11-18 ZY-LD 002
                        // recGoodsInTrans.SETRANGE("Item No.","No.");
                        // //recGoodsInTrans.SETFILTER("Buy-from Vendor No.",'<>%1',recPurchSetup."EMEA Vendor No.");  // 08-07-19 ZY-LD 004
                        // recGoodsInTrans.SETFILTER("Buy-from Vendor No.",VendorEvent.GetFilterZyxelVendors(0));  // 08-07-19 ZY-LD 004
                        // recGoodsInTrans.SETRANGE("Order Type",recGoodsInTrans."Order Type"::"Purchase Order");  // 22-04-20 ZY-LD 005
                        // PAGE.RUNMODAL(PAGE::"VCK Container Details",recGoodsInTrans);
                        // //<< 15-11-18 ZY-LD 002
                    end;
                }
                field("recItemHQ.""HQ Unshipped Purchase Order"""; recItemHQ."HQ Unshipped Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unshipped Quantity';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = UnshippedQtyStyle;

                    trigger OnDrillDown()
                    begin
                        DrillDownUnshippedQuantity(0);  // 08-07-19 ZY-LD 004
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

                    trigger OnDrillDown()
                    begin
                        DrillDownPurchaseOrderLine(1);  // 08-07-19 ZY-LD 004
                    end;
                }
                field(GoodsInTransit2; recItemEmea."Qty. on Shipping Detail" - recItemEmea."Qty. on Ship. Detail Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Goods in Transit';
                    DecimalPlaces = 0 : 0;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //>> 25-11-20 ZY-LD 006
                        OnLookUpGoodsInTransit(1);  // 25-11-20 ZY-LD 006
                        /*
                        //>> 15-11-18 ZY-LD 002
                        recGoodsInTrans.SETRANGE("Item No.","No.");
                        //recGoodsInTrans.SETRANGE("Buy-from Vendor No.",recPurchSetup."EMEA Vendor No.");  // 08-07-19 ZY-LD 004
                        recGoodsInTrans.SETFILTER("Buy-from Vendor No.",VendorEvent.GetFilterZyxelVendors(1));  // 08-07-19 ZY-LD 004
                        recGoodsInTrans.SETRANGE("Order Type",recGoodsInTrans."Order Type"::"Purchase Order");  // 22-04-20 ZY-LD 005
                        PAGE.RUNMODAL(PAGE::"VCK Container Details",recGoodsInTrans);
                        //<< 15-11-18 ZY-LD 002
                        */
                        //<< 25-11-20 ZY-LD 006

                    end;
                }
                field("HQ Unshipped Purchase Order2"; recItemEmea."HQ Unshipped Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unshipped Quantity';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = UnshippedQtyStyle;

                    trigger OnDrillDown()
                    begin
                        DrillDownUnshippedQuantity(1);  // 08-07-19 ZY-LD 004
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
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Order in Transit';
                    DecimalPlaces = 0 : 0;
                }
                field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //>> 05-07-19 ZY-LD 003
        if ZGT.IsRhq then begin
            recHQSetup.FindFirst();
            recHQSetup.TestField("SBU Filter Channel");

            recInvSetup.Get();
            recInvSetup.TestField("AIT Location Code");
            //SETRANGE("Location Filter",recInvSetup."AIT Location Code");  // 25-11-20 ZY-LD 006
            //SETRANGE("Location Filter",ItemLogisticEvent.GetMainWarehouseLocation);  // 25-11-20 ZY-LD 006  // 01-06-22 ZY-LD 009
            recPurchSetup.Get();  // 08-07-19 ZY-LD 004
            if ZGT.IsZNetCompany then begin
                recPurchSetup.TestField("EShop Vendor No. CH");
                Rec.SetRange("Buy-from Vendor No. Filter", recPurchSetup."EShop Vendor No. CH");  // 08-07-19 ZY-LD 004
            end else begin
                recPurchSetup.TestField("EShop Vendor No.");
                Rec.SetRange("Buy-from Vendor No. Filter", recPurchSetup."EShop Vendor No.");  // 08-07-19 ZY-LD 004
            end;
        end;
        //VCKZNETGroupVisible := recInvSetup."AIT Location Code" = 'VCK ZNET';  // 25-11-20 ZY-LD 006
        VCKZNETGroupVisible := ZGT.IsZNetCompany;  // 25-11-20 ZY-LD 006
        //EU2GroupVisible := recInvSetup."AIT Location Code" = 'EU2';  // 25-11-20 ZY-LD 006
        EU2GroupVisible := ZGT.IsZComCompany;  // 25-11-20 ZY-LD 006
        //<< 05-07-19 ZY-LD 003

        //PickingDateVisible := ZGT.UserIsLogistics;  // 27-08-21 ZY-LD 007
        if UserSetup.Get(UserId()) then
            PickingDateVisible := UserSetup."Show Picking Date"
        else
            PickingDateVisible := false;
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 05-07-19 ZY-LD 003

        //>> 08-07-19 ZY-LD 004
        //recItemHQ.SETFILTER("Buy-from Vendor No. Filter",'<>%1',recPurchSetup."EMEA Vendor No.");
        recItemHQ.SetFilter("Buy-from Vendor No. Filter", VendorEvent.GetFilterZyxelVendors(1, true));  // 25-11-20 ZY-LD 006
        recItemHQ.SetAutoCalcFields("Qty. on Purch. Order ZX", "Qty. on Shipping Detail", "Qty. on Ship. Detail Received", "HQ Unshipped Purchase Order");
        recItemHQ.Get(Rec."No.");

        //recItemEmea.SETRANGE("Buy-from Vendor No. Filter",recPurchSetup."EMEA Vendor No.");
        recItemEmea.SetFilter("Buy-from Vendor No. Filter", '%1', VendorEvent.GetFilterZyxelVendors(1, false));  // 25-11-20 ZY-LD 006
        recItemEmea.SetAutoCalcFields("Qty. on Purch. Order ZX", "Qty. on Shipping Detail", "Qty. on Ship. Detail Received", "HQ Unshipped Purchase Order");
        recItemEmea.Get(Rec."No.");
        //recItemEmea.SETFILTER("Buy-from Vendor No. Filter",VendorEvent.GetFilterZyxelVendors(0,TRUE));  // 25-11-20 ZY-LD 006
        //recItemEmea.CALCFIELDS("Qty. on Purch. Order");  // 25-11-20 ZY-LD 006

        //<< 08-07-19 ZY-LD 004
    end;

    var
        xxxx: Page "Item List";
        recItemHQ: Record Item;
        recItemEmea: Record Item;
        UserSetup: Record "User Setup";
        UnshippedQtyStyle: Text;
        recInvSetup: Record "Inventory Setup";
        recHQSetup: Record "Headquarter Setup";
        recPurchSetup: Record "Purchases & Payables Setup";
        EU2GroupVisible: Boolean;
        VCKZNETGroupVisible: Boolean;
        HQGroupVisible: Boolean;
        EMEAGroupVisible: Boolean;
        PickingDateVisible: Boolean;
        IsInventoriable: Boolean;
        IsNonInventoriable: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        EMEAVendorNo: Code[20];
        VendorEvent: Codeunit "Vendor Event";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";

    local procedure SetActions()
    begin
        //>> 06-09-18 ZY-LD 001
        if Rec."Qty. on Purch. Order ZX" - (Rec."Qty. on Shipping Detail" - Rec."Qty. on Ship. Detail Received") <> Rec."HQ Unshipped Purchase Order" then
            UnshippedQtyStyle := 'Unfavorable'
        else
            UnshippedQtyStyle := 'StandardAccent';
        //<< 06-09-18 ZY-LD 001

        //>> 05-07-19 ZY-LD 003
        HQGroupVisible := false;
        EMEAGroupVisible := false;
        if ZGT.IsZNetCompany then begin  // ZNet
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
        //<< 05-07-19 ZY-LD 003

        EnableControls();
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
        recUnshipPurchOrder: Record "Unshipped Purchase Order";
        PurchLine: Record "Purchase Line";
    begin
        // Rolled back to old unshipped.
        recUnshipPurchOrder.SETRANGE("Item No.", Rec."No.");
        IF Type = Type::HQ THEN
            recUnshipPurchOrder.SETFILTER("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, TRUE))
        ELSE
            recUnshipPurchOrder.SETFILTER("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, FALSE));
        PAGE.RUNMODAL(PAGE::"Unshipped Purchase Order", recUnshipPurchOrder);

        /*PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("No.", Rec."No.");
        PurchLine.SetFilter(OriginalLineNo, '<>0');
        if Type = Type::HQ then
            PurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            PurchLine.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));
        Page.RunModal(Page::"Purchase Lines", PurchLine);*/
    end;

    local procedure OnLookUpGoodsInTransit(Type: Option HQ,EMEA)
    var
        recGoodsInTrans: Record "VCK Shipping Detail";
        recGoodsInTransTmp: Record "VCK Shipping Detail" temporary;
        recUserSetup: Record "User Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        NewEntryNo: Integer;
    begin
        //>> 25-11-20 ZY-LD 006
        recGoodsInTrans.SetRange("Item No.", Rec."No.");
        if Type = Type::HQ then
            recGoodsInTrans.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type::EMEA, true))
        else
            recGoodsInTrans.SetFilter("Buy-from Vendor No.", VendorEvent.GetFilterZyxelVendors(Type, false));
        recGoodsInTrans.SetRange("Order Type", recGoodsInTrans."order type"::"Purchase Order");

        //>> 09-06-22 ZY-LD 010
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
                        recGoodsInTransTmp.Insert();
                    end;
                until recGoodsInTrans.Next() = 0;

            recGoodsInTransTmp.Reset();
            Page.RunModal(Page::"VCK Container Details ETA", recGoodsInTransTmp);
        end else  //<< 09-06-22 ZY-LD 010
            Page.RunModal(Page::"VCK Container Details", recGoodsInTrans);
        //<< 25-11-20 ZY-LD 006
    end;

    local procedure EnableControls()
    begin
        IsNonInventoriable := Rec.IsNonInventoriableType();
        IsInventoriable := Rec.IsInventoriableType();
    end;

    procedure SetLocationFilter(LocationCode: Code[20])
    begin
        Rec."Location Filter" := LocationCode;
    end;
}
