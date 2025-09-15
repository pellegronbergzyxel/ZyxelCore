Table 50046 "VCK Shipping Detail"
{

    DrillDownPageID = "VCK Shipping Detail";
    LookupPageID = "VCK Shipping Detail";
    Permissions = TableData "Change Log Entry" = d;

    fields
    {
        field(1; "Container No."; Code[30])
        {
            Caption = 'Container No.';
            Description = 'PAB 1.0';
        }
        field(2; "Invoice No."; Code[30])
        {
            Caption = 'Invoice No.';
            Description = 'PAB 1.0';
        }
        field(3; "Purchase Order No."; Code[20])
        {
            Caption = 'Order No.';
            Description = 'PAB 1.0';
            TableRelation = if ("Order Type" = const("Purchase Order")) "Purchase Header"."No." where("Document Type" = const(Order))
            else
            if ("Order Type" = const("Sales Return Order")) "Sales Header"."No." where("Document Type" = const("Return Order"))
            else
            if ("Order Type" = const("Transfer Order")) "Transfer Header"
            else
            if ("Order Type" = const("Purchase Invoice")) "Purchase Header"."No." where("Document Type" = const(Invoice));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(4; "Purchase Order Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Order Line No.';
            Description = 'PAB 1.0';
        }
        field(5; "Pallet No."; Code[30])
        {
            Caption = 'Pallet No.';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Evaluate("Pallet No. 2", DelChr("Pallet No.", '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'));
            end;
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
            TableRelation = Item."No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; Quantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
            Description = 'PAB 1.0';
        }
        field(8; ETA; Date)
        {
            Caption = 'ETA Date';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                if ETA <> 0D then
                    "Previous ETA Date" := xRec.ETA;

                "Expected Shipping Days" := ETA - ETD;
                if (xRec.ETA <> 0D) and ("Expected Receipt Date" <> 0D) then
                    Validate("Expected Receipt Date", CalcDate('+' + Format("Expected Receipt Date" - xRec.ETA) + 'D', ETA));
            end;
        }
        field(9; ETD; Date)
        {
            Caption = 'ETD Date';
            Description = 'PAB 1.0';

            trigger OnValidate() //08-09-2025 BK #525482
            var
                ZGT: Codeunit "Zyxel General Tools";
                WarehouseSetup: Record "Warehouse Setup";
            begin
                if zgt.IsZComCompany() then
                    If (ETD <> 0D) and (WarehouseSetup.get()) and (format(WarehouseSetup."Calculated ETA Calculation") <> '') THEN
                        Validate("Calculated ETA Date", CALCDATE(WarehouseSetup."Calculated ETA Calculation", ETD))
                    else
                        Validate("Calculated ETA Date", 0D);
            end;
        }
        field(10; "Shipping Method"; Code[30])
        {
            Caption = 'Shipping Method Code / Incoterms';
            Description = 'PAB 1.0';
            TableRelation = "Shipment Method";
        }
        field(11; "Order No."; Code[30])
        {
            Caption = 'Shipment No.';
            Description = 'PAB 1.0';
        }
        field(12; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            Description = 'PAB 1.0';
        }
        field(13; Archive; Boolean)
        {
            Caption = 'Archive';
            Description = 'PAB 1.0';
        }
        field(14; "Bill of Lading No."; Text[30])
        {
            Caption = 'Bill of Lading No.';
        }
        field(15; Location; Code[10])
        {
            Caption = 'Location';
            Description = 'RD 1.0';

            trigger OnValidate()
            var
                LocationRec: Record Location;
            begin
                //17-06-2025 BK #511511
                if locationRec.get(location) then
                    IF LocationRec."Main Warehouse" then
                        "Main Warehouse" := locationrec."Main Warehouse";
            end;

        }
        field(16; "Quantity Received"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("VCK Shipping Detail Received"."Quantity Received" where("Container No." = field("Container No."),
                                                                                        "Invoice No." = field("Invoice No."),
                                                                                        "Purchase Order No." = field("Purchase Order No."),
                                                                                        "Purchase Order Line No." = field("Purchase Order Line No."),
                                                                                        "Pallet No." = field("Pallet No."),
                                                                                        "Item No." = field("Item No."),
                                                                                        "Shipping Method" = field("Shipping Method"),
                                                                                        "Order No." = field("Order No.")));
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 0;
            Description = '24-10-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; Amount; Decimal)
        {
            BlankZero = true;
            Caption = 'Amount';
        }
        field(19; "Calculated Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(31; "Data Received Created"; DateTime)
        {
            Caption = 'Data Received Created';
            Description = '24-10-18 ZY-LD 001';
        }
        field(32; "Data Received Updated"; DateTime)
        {
            Caption = 'Data Received Updated';
            Description = '24-10-18 ZY-LD 001';
        }
        field(33; "Direct Unit Cost"; Decimal)
        {
            BlankZero = true;
            CalcFormula = lookup("Purchase Line"."Direct Unit Cost" where("Document Type" = const(Order),
                                                                           "Document No." = field("Purchase Order No."),
                                                                           "Line No." = field("Purchase Order Line No.")));
            Caption = 'Direct Unit Cost';
            DecimalPlaces = 2 : 5;
            Description = '01-11-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Item Description"; Code[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Description = '01-11-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Item Category 1 Code"; Code[100])
        {
            CalcFormula = lookup(Item."Category 1 Code" where("No." = field("Item No.")));
            Caption = 'Item Category 1 Code';
            Description = '01-11-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Item Category 2 Code"; Code[100])
        {
            CalcFormula = lookup(Item."Category 2 Code" where("No." = field("Item No.")));
            Caption = 'Item Category 2 Code';
            Description = '01-11-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "P.O. Line No. Found by Us"; Boolean)
        {
            Caption = 'P.O. Line No. Found by Us';
            Description = '01-11-18 ZY-LD 002';
        }
        field(38; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            Description = '01-11-18 ZY-LD 002';
            Editable = false;
            SQLDataType = Integer;
        }
        field(39; "Division Code"; Code[20])
        {
            CalcFormula = lookup(Item."Global Dimension 1 Code" where("No." = field("Item No.")));
            Caption = 'Business Model (Division Code)';
            Description = '01-11-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Previous Batch No."; Code[50])
        {
            Description = '15-03-19 ZY-LD 005';
            Editable = false;
        }
        field(41; "Buy-from Vendor No."; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Buy-from Vendor No." where("No." = field("Purchase Order No.")));
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vendor;
        }
        field(42; "SBU Company"; Option)
        {
            CalcFormula = lookup(Vendor."SBU Company" where("No." = field("Buy-from Vendor No.")));
            Caption = 'Zyxel Company';
            Description = '14-01-20 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,ZCom HQ,ZNet HQ,ZCom EMEA,ZNet EMEA';
            OptionMembers = " ","ZCom HQ","ZNet HQ","ZCom EMEA","ZNet EMEA";
        }
        field(43; "Pallet No. 2"; Integer)
        {
            Caption = 'Pallet No. 2';
        }
        field(44; "Previous ETA Date"; Date)
        {
            Caption = 'Previous ETA Date';
            Description = '27-07-21 ZY-LD 011';
            Editable = false;
        }
        field(45; "Original ETA Date"; Date)
        {
            Caption = 'Original ETA Date';
            Description = '24-11-21 ZY-LD 012';
            Editable = false;

            trigger OnValidate()
            begin
                "Original Shipping Days" := "Original ETA Date" - ETD;
                Validate(ETA);
            end;
        }
        field(46; "Expected Shipping Days"; Integer)
        {
            BlankZero = true;
            Caption = 'Expected Shipping Days';
            Description = '24-11-21 ZY-LD 012';
            Editable = false;
        }
        field(47; "Original Shipping Days"; Integer)
        {
            BlankZero = true;
            Caption = 'Original Shipping Days';
            Description = '24-11-21 ZY-LD 012';
            Editable = false;
        }
        field(48; "Main Warehouse"; Boolean)
        {
            Caption = 'Main Warehouse';
            Description = '20-01-22 ZY-LD 014';
        }
        field(49; "Vessel Code"; Code[50])
        {
            Caption = 'Vessel Code';
            TableRelation = Vessel;
        }
        field(50; "Item Category 3 Code"; Code[100])
        {
            CalcFormula = lookup(Item."Category 3 Code" where("No." = field("Item No.")));
            Caption = 'Item Category 3 Code';
            Description = '01-09-22 ZY-LD 016';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = '15-11-21 ZY-LD 012';
        }
        field(101; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = '06-02-20 ZY-LD 007';
            TableRelation = "Warehouse Inbound Header";
        }
        field(102; "Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Line No.';
            Description = '06-02-20 ZY-LD 007';
        }
        field(103; "Order Type"; Option)
        {
            Caption = 'Order Type';
            Description = '06-02-20 ZY-LD 007';
            Editable = false;
            OptionCaption = 'Purchase Order,Sales Return Order,Transfer Order,Purchase Invoice';
            OptionMembers = "Purchase Order","Sales Return Order","Transfer Order","Purchase Invoice";
        }
        field(104; "Outstanding Quantity"; Decimal)
        {
            BlankZero = true;
            CalcFormula = lookup("Purchase Line"."Outstanding Quantity" where("Document Type" = filter(Order),
                                                                               "Document No." = field("Purchase Order No."),
                                                                               "Line No." = field("Purchase Order Line No.")));
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 0;
            Description = '06-02-20 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; tobeETA; Date)  // #490711 >>
        {
            Caption = 'Not updated ETA from Zyxel HQ';
        }
        field(50007; "Calculated ETA Date"; Date) //08-09-2025 BK #525482
        {
            Caption = 'Calculated ETA Date';

            trigger OnValidate()
            var
                ZGT: Codeunit "Zyxel General Tools";
                ShipmentMethodrec: Record "Shipment Method";
            begin
                if zgt.IsZComCompany() then
                    if ShipmentMethodrec.get(rec."Shipping Method") then
                        If Format(ShipmentMethodrec."Shipping Days") <> '' THEN
                            If "Calculated ETA Date" <> 0D THEN
                                Validate("Expected Receipt Date", CALCDATE(ShipmentMethodrec."Shipping Days", "Calculated ETA Date"))
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Container No.", "Invoice No.", "Purchase Order No.", "Purchase Order Line No.", "Pallet No.", "Item No.", "Shipping Method", "Order No.")
        {
            Clustered = true;
            SumIndexFields = Quantity;
        }
        key(Key3; "Purchase Order No.", "Purchase Order Line No.", "Invoice No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key4; Archive, "Batch No.")
        {
        }
        key(Key5; "Container No.", "Bill of Lading No.", "Invoice No.", Archive)
        {
        }
        key(Key6; "Document No.", "Pallet No. 2")
        {
        }
        key(Key7; "Item No.", Archive, "Order Type")
        {
        }
        key(Key8; ETA)
        {
        }
        key(Key9; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if recPurchLine.Get(recPurchLine."document type"::Order, "Purchase Order No.", "Purchase Order Line No.") then begin
            recShipDet.SetRange("Invoice No.", "Invoice No.");
            recShipDet.SetRange("Purchase Order No.", "Purchase Order No.");
            recShipDet.SetRange("Purchase Order Line No.", "Purchase Order Line No.");
            recShipDet.SetRange("Pallet No.", "Pallet No.");
            recShipDet.SetRange("Item No.", "Item No.");
            recShipDet.SetRange("Shipping Method", "Shipping Method");
            recShipDet.SetRange("Order No.");
            recShipDet.SetFilter("Container No.", '<>%1', "Container No.");
            if not recShipDet.FindFirst() then
                Error(Text001, recPurchLine.TableCaption);
        end;
        if "Purchase Order Line No." = 0 then
            Error(Text002, FieldCaption("Purchase Order Line No."));

        recShipDetReceived.SetRange("Container No.", "Container No.");
        recShipDetReceived.SetRange("Invoice No.", "Invoice No.");
        recShipDetReceived.SetRange("Purchase Order No.", "Purchase Order No.");
        recShipDetReceived.SetRange("Purchase Order Line No.", "Purchase Order Line No.");
        recShipDetReceived.SetRange("Pallet No.", "Pallet No.");
        recShipDetReceived.SetRange("Item No.", "Item No.");
        recShipDetReceived.SetRange("Shipping Method", "Shipping Method");
        recShipDetReceived.SetRange("Order No.", "Order No.");
        recShipDetReceived.DeleteAll(true);

        recCngLogEntry.SetCurrentkey("Table No.", "Primary Key Field 1 Value");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Shipping Detail");
        recCngLogEntry.SetRange("Primary Key Field 1 Value", Format("Entry No."));
        recCngLogEntry.DeleteAll(true);

    end;

    trigger OnInsert()
    var
        recShipDetail: Record "VCK Shipping Detail";
    begin
        if "Entry No." = 0 then
            if recShipDetail.FindLast() then
                "Entry No." := recShipDetail."Entry No." + 1
            else
                "Entry No." := 1;
    end;

    var
        recShipDet: Record "VCK Shipping Detail";
        recShipDetReceived: Record "VCK Shipping Detail Received";
        recPurchLine: Record "Purchase Line";
        recCngLogEntry: Record "Change Log Entry";
        Text001: label 'You canÍt delete the line, while the "%1" still exists.';
        Text002: label 'You canÍt delete the line, because "%1" is 0.';


    procedure movetobeETA()
    var
        VcKshipdetail: record "VCK Shipping Detail";
    begin
        if VcKshipdetail.findset() then
            repeat
                if VcKshipdetail.tobeETA <> 0D Then begin
                    VcKshipdetail.validate(ETA, VcKshipdetail.tobeETA);
                    VcKshipdetail.tobeETA := 0D;
                    VcKshipdetail.modify(true);
                end
            until VcKshipdetail.next() = 0;

    end;


}
