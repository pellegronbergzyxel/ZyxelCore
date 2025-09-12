tableextension 50119 PurchaseLineZX extends "Purchase Line"
{

    fields
    {
        field(50001; "Requested Date From Factory"; Date)
        {
            Caption = 'Requested Date From Factory';
            Description = 'DT1.0';

            trigger OnValidate()
            var
                PurchHeader: Record "Purchase Header";
            begin
                PurchHeader := Rec.GetPurchHeader();
                if (PurchHeader.IsEICard = true) then
                    if (Format(Rec."Requested Date From Factory") <> '') then begin
                        Rec."ETD Date" := Rec."Requested Date From Factory";
                        Rec.ETA := Rec."Requested Date From Factory";
                        Rec."Actual shipment date" := Rec."Requested Date From Factory";
                    end;
            end;
        }
        field(50002; "ETD Date"; Date)
        {
            Caption = 'Factory Schedule Date';
            Description = 'DT1.0, HQ';

            trigger OnValidate()
            var
                lrShipmentMethod: Record "Shipment Method";
                PurchHeader: Record "Purchase Header";
            begin
                PurchHeader := Rec.GetPurchHeader();
                if not lrShipmentMethod.Get(PurchHeader."Shipment Method Code") then
                    lrShipmentMethod.Init();

            end;
        }
        field(50003; ETA; Date)
        {
            Caption = 'ETA';
            Description = 'DT1.0';
        }
        field(50004; "Actual shipment date"; Date)
        {
            Caption = 'Actual shipment date';
            Description = 'DT1.0, HQ';

            trigger OnValidate()
            var
                lrShipmentMethod: Record "Shipment Method";
                PurchHeader: Record "Purchase Header";
            begin
                PurchHeader := Rec.GetPurchHeader();
                if not lrShipmentMethod.Get(PurchHeader."Shipment Method Code") then
                    lrShipmentMethod.Init();

            end;
        }
        field(50005; "Vendor Invoice No"; Text[250])
        {
            Caption = 'Vendor Invoice No';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(50006; "Cost Split Type"; Code[20])
        {
            Caption = 'Cost Split Type';
            Description = 'Unused';
        }
        field(50007; Matched; Boolean)
        {
            Caption = 'Matched';
            Description = 'PAB 1.0';
        }
        field(50008; UpdateAllIn; Boolean)
        {
            Caption = 'UpdateAllIn';
            Description = 'Unused';
            InitValue = true;
        }
        field(50009; "Source Document"; Text[250])
        {
            Caption = 'Source Document';
            Description = 'Unused';
        }
        field(50010; "Container No"; Text[20])
        {
            Caption = 'Container No.';
            Description = 'Used - transfered to Purch. Rcpt. Line';
        }
        field(50011; "Pallet No"; Text[20])
        {
            Caption = 'Pallet No';
            Description = 'Unused';
        }
        field(50012; "Vendor Status"; Option)
        {
            Caption = 'Vendor Status';
            Description = 'PAB 1.0';
            OptionCaption = 'None,Order Created,Order Sent,Order Received,Order Rejected,Partialy Dispatched,Dispatched';
            OptionMembers = "None","Order Created","Order Sent","Order Received","Order Rejected","Partialy Dispatched",Dispatched;
        }
        field(50013; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            Description = 'Unused';
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        }
        field(50014; "Now On Stock"; Boolean)
        {
            Caption = 'Now On Stock';
            Description = 'Unused';
        }
        field(50015; "Visible Fee Line No."; Integer)
        {
            Caption = 'Visible Fee Line No.';
            Description = 'PAB 1.0';
        }
        field(50016; "Goods in Transit to Receive"; Decimal)
        {
            CalcFormula = sum("VCK Shipping Detail".Quantity where("Purchase Order No." = field("Document No."),
                                                                   "Purchase Order Line No." = field("Line No."),
                                                                   Archive = const(false)));
            Caption = 'Goods in Transit to Receive';
            Description = '14-01-19 ZY-LD 006';
            FieldClass = FlowField;
        }
        field(50017; "Goods in Transit Receipt"; Decimal)
        {
            CalcFormula = sum("VCK Shipping Detail Received".Quantity where("Purchase Order No." = field("Document No."),
                                                                            "Purchase Order Line No." = field("Line No."),
                                                                            Archive = const(false)));
            Caption = 'Goods in Transit Receipt';
            Description = '14-01-19 ZY-LD 006';
            FieldClass = FlowField;
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '23-03-20 ZY-LD 003';
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 008';
        }
        field(50028; "GLC Serial No."; Code[20])
        {
            Caption = 'GLC Serial No.';
            Description = '23-02-23 ZY-LD 009';
        }
        field(50029; "GLC Mac Address"; Code[20])
        {
            Caption = 'GLC Mac Address';
            Description = '23-02-23 ZY-LD 009';
        }
        field(50031; "Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            Description = '04-12-23 ZY-LD - Contain the original quantity for the line before the split.';
            Editable = false;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(50032; "Outstanding Quantity Grouped"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = field("Document Type"),
                                                                           "Document No." = field("Document No."),
                                                                           OriginalLineNo = field("Line No.")));
            Caption = 'Outstanding Quantity Grouped';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(50033; "Quantity Received Grouped"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Quantity Received" where("Document Type" = field("Document Type"),
                                                                        "Document No." = field("Document No."),
                                                                        OriginalLineNo = field("Line No.")));
            Caption = 'Quantity Received Grouped';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(50034; "Quantity Invoiced Grouped"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Quantity Invoiced" where("Document Type" = field("Document Type"),
                                                                        "Document No." = field("Document No."),
                                                                        OriginalLineNo = field("Line No.")));
            Caption = 'Quantity Received Grouped';
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(50035; "Unship Related"; Boolean)
        {
            Description = 'Locate if the purchase line has a corresponding line in unshipped purchase order. If not, the line should be GIT.';
            CalcFormula = exist("Unshipped Purchase Order" where("Sales Order Line ID" = field("Sales Order Line ID")));
            Caption = 'Unship Related';
            FieldClass = FlowField;
            Editable = false;
        }
        field(50036; "Original No."; Code[20])
        {
            Caption = 'Original No.';
            Description = 'In case of samples we need to store the original item no. so we can use it in intrastat reporting.';
        }
        field(50101; "Hide Line"; Boolean)
        {
            Caption = 'Hide Line';
        }
        field(50102; "EMS Machine Code"; Text[64]) //22-05-2025 BK #505159
        {
            Caption = 'EMS Machine Code';
            Description = 'PAB 1.0';
        }
        field(50103; "Sales Order Line ID"; Code[30])
        {
            Caption = 'Sales Order Line ID';
            Description = 'Unique identification of the sales order line in HQ.';

        }
        field(500104; "Document Date"; Date) //07-09-2025 BK #511337
        {
            Description = 'Document Date from Purchase Header';
            CalcFormula = lookup("Purchase Header"."Document Date" where("Document Type" = field("document Type"), "No." = field("Document No.")));
            Caption = 'Document Date';
            FieldClass = FlowField;
            Editable = false;
        }
        field(60002; "Vendor Order No."; Text[30])
        {
            Caption = 'Vendor Order No.';
            Description = 'Unused';
        }
        field(62000; "Sales Order Number"; Code[20])
        {
            Caption = 'Sales Order Number';

            trigger OnValidate()
            var
                SalesOrderLine: Record "Sales Line";
                "Count": Integer;
            begin
                SalesOrderLine.Reset();
                SalesOrderLine.SetRange(SalesOrderLine."Document No.", Rec."Sales Order Number");
                SalesOrderLine.SetRange(SalesOrderLine."No.", Rec."No.");

                "Count" := 0;
                if SalesOrderLine.Find('-') then begin
                    repeat
                        "Count" := "Count" + 1;
                        Rec."Sales Line Number" := SalesOrderLine."Line No.";
                    until SalesOrderLine.Next() <= 0;

                    if "Count" > 1 then
                        Message('The Sales Order has more than one Sales_Line_No.');
                end;
            end;
        }
        field(62001; "Sales Line Number"; Integer)
        {
            Caption = 'Sales Line Number';
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(62024; "Lock by Ref Document"; Boolean)
        {
            Caption = 'Lock by Ref Document';
            Description = 'Tectura Taiwan';
        }
        field(62050; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62051; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(66001; "DSV Status"; Option)
        {
            Caption = 'DSV Status';
            Description = 'Unused';
            OptionCaption = ' ,New,Sent,Recieved';
            OptionMembers = " ",New,Sent,Recieved;
        }
        field(66002; "Last Status Change"; DateTime)
        {
            Caption = 'Last Status Change';
            Description = 'Unused';
        }
        field(66003; "Bill of Lading No."; Text[30])
        {
            Caption = 'Bill of Lading No.';
            Description = 'Unused';
        }
        field(66004; "Visible Fee Code"; Code[20])
        {
            Caption = 'Visible Fee Code';
            Description = 'PAB 1.0';
        }
        field(66005; "Visible Fee"; Boolean)
        {
            Caption = 'Visible Fee';
            Description = 'PAB 1.0';
        }
        field(66006; "Visible Fee Amount"; Decimal)
        {
            Caption = 'Visible Fee Amount';
            Description = 'PAB 1.0';
        }
        field(70000; OriginalLineNo; Integer)
        {
            Caption = 'Original Line No.';
            Editable = false;
            DataClassification = CustomerContent;
            Description = 'Also indicates that it is an "Unshipped Purchase Order Line" if greater than zero.';
        }
        field(70001; VendorType; Enum VendorType)
        {
            Caption = 'Vendor Type';
            DataClassification = CustomerContent;
        }
        field(70002; OriginalLocationCode; Code[10])
        {
            Caption = 'Original Location Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key50000; ETA)
        {
        }
        key(Key50001; "Document Type", Type, "No.", Quantity)
        {
        }
    }
}
