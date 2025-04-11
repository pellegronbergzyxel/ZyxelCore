table 50053 "Inbound Comparition"
{
    Caption = 'Inbound Comparition';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header";
        }
        field(2; "Original Line No."; Integer)
        {
            Caption = 'Original Line No.';
        }
        field(3; "Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(4; "Order Quantity"; Decimal)
        {
            CalcFormula = sum("Purchase Line".Quantity where("Document Type" = const(Order),
                                                             "Document No." = field("Document No."),
                                                             OriginalLineNo = field("Original Line No.")));
            Caption = 'Order Quantity';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Order Outstanding Quantity"; Decimal)
        {
            // Show the outstanding quantity on the original entered line. The field will only have a value until the first time we receive unshipped purchase order
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order),
                                                                           "Document No." = field("Document No."),
                                                                           "Line No." = field("Original Line No.")));
            Caption = 'Order Outstanding Quantity';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(6; "Unshipped Quantity"; Decimal)
        {
            CalcFormula = sum("Unshipped Purchase Order".Quantity where("Purchase Order No." = field("Document No."),
                                                                        "Purchase Order Line No." = field("Original Line No.")));
            Caption = 'Unshipped Quantity';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(7; "Unposted Goods in Transit"; Decimal)
        {
            CalcFormula = sum("VCK Shipping Detail".Quantity where("Purchase Order No." = field("Document No."),
                                                                   "Purchase Order Line No." = field("Original Line No."),
                                                                   Archive = const(false)));
            Caption = 'Unposted Goods in Transit';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(8; "Posted Goods in Transit"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                 "Location Code" = FIELD("In Transit Location Filter")));

            Caption = 'Posted Goods in Transit';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(11; "In Transit Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(12; "Order Qty. to Invoice"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Qty. to Invoice" where("Document Type" = const(Order),
                                                                      "Document No." = field("Document No."),
                                                                      OriginalLineNo = field("Original Line No.")));
            Caption = 'Order Qty. to Invoice';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(13; "Order Quantity Invoiced"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Quantity Invoiced" where("Document Type" = const(Order),
                                                                        "Document No." = field("Document No."),
                                                                        OriginalLineNo = field("Original Line No.")));
            Caption = 'Order Quantity Invoiced';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(14; "HQ Invoice Qty. to Invoice"; Decimal)
        {
            CalcFormula = sum("HQ Invoice Line".Quantity where("Document Type" = const(Invoice),
                                                               "Purchase Order No." = field("Document No."),
                                                               "Purchase Order Line No." = field("Original Line No.")));
            // Filter on not invoiced
            Caption = 'HQ Invoice Qty. to Invoice';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(15; "HQ Invoice Quantity Invoiced"; Decimal)
        {
            CalcFormula = sum("HQ Invoice Line".Quantity where("Document Type" = const(Invoice),
                                                               "Purchase Order No." = field("Document No."),
                                                               "Purchase Order Line No." = field("Original Line No.")));
            // Filter on Invoiced
            Caption = 'HQ Invoice Qty. Invoiced';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(16; "Order Outstanding Qty. Split"; Decimal)
        {
            Description = 'Show outstanding quantity for the purchase order line after it has been splitted.';
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order),
                                                                           "Document No." = field("Document No."),
                                                                            OriginalLineNo = field("Original Line No.")));
            Caption = 'Order Outstanding Quantity Split';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(17; "Related Order Outstanding Qty."; Decimal)
        {
            // Show the outstanding quantity for the purchase lines that have a relation to unshipped purchase order.
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order),
                                                                           "Document No." = field("Document No."),
                                                                           OriginalLineNo = field("Original Line No."),
                                                                           "Unship Related" = const(true)));
            Caption = 'Related Order Outstanding Quantity';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(18; "Unrelated Order Outst. Qty."; Decimal)
        {
            // Show the outstanding quantity for the purchase lines that not have a relation to unshipped purchase order.
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order),
                                                                           "Document No." = field("Document No."),
                                                                           OriginalLineNo = field("Original Line No."),
                                                                           "Unship Related" = const(false)));
            Caption = 'Unrelated Order Outstanding Quantity';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
    }
    keys
    {
        key(key1; "Document No.", "Original Line No.")
        {
            Clustered = true;
        }
    }
    procedure InsertInboundComparition(pPurchOrderNo: Code[20]; pPurchOrderLineNo: Integer; pItemNo: Code[20]; pLocation: Code[10]; pQuantity: Decimal)
    var
        InboundComparition: Record "Inbound Comparition";
        PurchHead: Record "Purchase Header";
        Vendor: Record Vendor;

    begin
        if not InboundComparition.get(pPurchOrderNo, pPurchOrderLineNo) then
            if PurchHead.get(PurchHead."Document Type"::Order, pPurchOrderNo) then begin
                Vendor.GET(PurchHead."Buy-from Vendor No.");
                IF Vendor."SBU Company" IN [Vendor."SBU Company"::"ZCom HQ", Vendor."SBU Company"::"ZNet HQ"] THEN BEGIN
                    InboundComparition.Init();
                    InboundComparition."Document No." := pPurchOrderNo;
                    InboundComparition."Original Line No." := pPurchOrderLineNo;
                    InboundComparition."Item No." := pItemNo;
                    InboundComparition."Location Code" := pLocation;
                    InboundComparition."Original Quantity" := pQuantity;
                    InboundComparition.INSERT(TRUE);
                END;
            end
    end;

    procedure UpdateTable()
    var
        recVend: Record Vendor;
        recPurchLine: Record "Purchase Line";
        recInbCompLine: Record "Inbound Comparition";
        recUnshipQty: Record "Unshipped Purchase Order";
        recShipDetail: Record "VCK Shipping Detail";
        ItemLogEvent: Codeunit "Item / Logistic Events";
        ZGT: Codeunit "Zyxel General Event";

    begin
        recPurchLine.SETRANGE(Type, recPurchLine.Type::Item);
        recPurchLine.SETFILTER("Location Code", '%1|%2', ItemLogEvent.GetMainWarehouseLocation, 'WX');
        recPurchLine.SETFILTER("Outstanding Quantity", '<>0');
        recpurchline.SetRange(OriginalLineNo, 0);
        IF recPurchLine.FINDSET THEN BEGIN
            //ZGT.OpenProgressWindow('', recPurchLine.COUNT);
            recInbCompLine.DELETEALL;
            REPEAT
                InsertInboundComparition(recPurchLine."Document No.", recPurchLine."Line No.", recPurchLine."No.", recPurchLine."Location Code", recPurchLine.Quantity);
            UNTIL recPurchLine.NEXT = 0;
            //ZGT.CloseProgressWindow;

            recPurchLine.RESET;
            recUnshipQty.SETFILTER("Location Code", '%1|%2', ItemLogEvent.GetMainWarehouseLocation, 'WX');
            recUnshipQty.SETAUTOCALCFIELDS("Location Code");
            IF recUnshipQty.FINDSET THEN BEGIN
                //ZGT.OpenProgressWindow('', recUnshipQty.COUNT);
                REPEAT
                    InsertInboundComparition(recUnshipQty."Purchase Order No.", recUnshipQty."Purchase Order Line No.", recUnshipQty."Item No.", '', recUnshipQty.Quantity);
                UNTIL recUnshipQty.NEXT = 0;
                //ZGT.CloseProgressWindow;
            END;

            recShipDetail.SETRANGE("Order Type", recShipDetail."Order Type"::"Purchase Order");
            recShipDetail.SETRANGE(Archive, FALSE);
            recShipDetail.SETFILTER(Location, '%1|%2', ItemLogEvent.GetMainWarehouseLocation, 'WX');
            IF recShipDetail.FINDSET THEN BEGIN
                //ZGT.OpenProgressWindow('', recShipDetail.COUNT);
                REPEAT
                    InsertInboundComparition(recShipDetail."Purchase Order No.", recShipDetail."Purchase Order Line No.", recShipDetail."Item No.", recShipDetail.Location, recShipDetail.Quantity);
                UNTIL recShipDetail.NEXT = 0;
                //ZGT.CloseProgressWindow;
            END;
        END;
    end;
}
