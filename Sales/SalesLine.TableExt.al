tableextension 50117 SalesLineZX extends "Sales Line"
{
    fields
    {
        modify("Location Code")
        {
            TableRelation = Location where("Use As In-Transit" = const(false),
                                           "In Use" = const(true));
        }
        modify("Shipment Date")
        {
            Caption = 'Picking Date';
        }
        modify("Return Reason Code")
        {
            TableRelation = "Return Reason" where("Gen. Prod. Posting Grp. Filter" = field("Gen. Prod. Posting Group"),
                                                  "Exists for Gen. Prod. Post Grp" = const(true));
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                recSalesHeader: Record "Sales Header";
            begin
                if Amount > 1000 then begin
                    recSalesHeader.SetFilter("No.", "Document No.");
                    recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
                    recSalesHeader.SetRange("Sales Order Type", recSalesHeader."Sales Order Type"::EICard);
                    if Not recSalesHeader.IsEmpty() then
                        Message(Text0063);
                end;
            end;
        }
        field(50000; "Order Date"; Date)
        {
            CalcFormula = lookup("Sales Header"."Order Date" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50001; "Sell-to Customer Country"; Code[20])
        {
            CalcFormula = lookup(Customer."Territory Code" where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Territory';
            Description = '20-08-18 ZY-LD 013';
            FieldClass = FlowField;
        }
        field(50002; "End of Life Date"; Date)
        {
            CalcFormula = lookup(Item."End of Life Date" where("No." = field("No.")));
            Caption = 'End of Life Date';
            Description = '25-09-20 ZY-LD 037';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Warehouse Status"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        }
        field(50004; "Unconfirmed Additional Line"; Integer)
        {
            CalcFormula = Count("Sales Line" where("Document Type" = field("Document Type"),
                                                   "Document No." = field("Document No."),
                                                   "Additional Item Line No." = field("Line No."),
                                                   "Shipment Date Confirmed" = const(false)));
            Caption = 'Unconfirmed Additional Line';
            Description = '08-10-20 ZY-LD 038';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Edit Additional Sales Line"; Boolean)
        {
            Caption = 'Edit Additional Sales Line';
            Description = '08-10-20 ZY-LD 038';
        }
        field(50006; "Cost Split Type"; Code[20])
        {
            Description = 'Unused';
        }
        field(50007; "Delivery Document No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "VCK Delivery Document Header";
        }
        field(50008; "Carton Qty Adjust."; Boolean)
        {
            Description = 'Unused';
        }
        field(50009; "Origional Qty."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50010; "Number Per Carton"; Integer)
        {
            CalcFormula = lookup(Item."Number per carton" where("No." = field("No.")));
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(50011; "Visible Fee Amount"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50012; "Visible Fee Line No."; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50013; "Customer Profile Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('CUSTOMERPROFILE'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(50014; "Department Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('DEPARTMENT'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'Unused';
            FieldClass = FlowField;
        }
        field(50015; "Country Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('COUNTRY'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50016; "Division Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('DIVISION'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50017; "Related Delivery Document"; Code[20])
        {
            Description = 'Unused';
            TableRelation = "VCK Delivery Document Header"."No.";
        }
        field(50018; "Additional Item Line No."; Integer)
        {
            Caption = 'Additional Item Line No.';
            Description = 'LD1.0';
        }
        field(50019; "EMS Machine Code"; Text[64]) //22-05-2025 BK #505159
        {
            Description = 'PAB 1.0';
        }
        field(50020; "Additional Item Quantity"; Decimal)
        {
            Caption = 'Additional Item Quantity';
            Description = '20-11-18 ZY-LD 021';
            MinValue = 0;
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '23-03-20 ZY-LD 032';
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 044';
        }
        field(50023; "Freight Cost Related Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Freight Cost Related Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = field("Document Type"),
                                                          "Document No." = field("Document No."),
                                                          Type = const(Item),
                                                          "Freight Cost Item" = const(false),
                                                          "Additional Item Line No." = const(0),
                                                          "Outstanding Quantity" = filter(<> 0));
        }
        field(50024; "Freight Cost Item"; Boolean)
        {
            CalcFormula = lookup(Item."Freight Cost Item" where("No." = field("No.")));
            Caption = 'Freight Cost Item';
            Description = '18-05-22 ZY-LD 016';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "Ext Vend Purch. Order No."; Code[20])
        {
            Caption = 'External Vendor Purch. Order No.';
            Description = '11-07-19 ZY-LD 026';
        }
        field(50026; "Ext Vend Purch. Order Line No."; Integer)
        {
            Caption = 'External Vendor Purch. Order Line No.';
            Description = '11-07-19 ZY-LD 026';
        }
        field(50027; "Qty. Blanket on Sales Order"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Blanket Order No." = field("Document No."),
                                                                        "Blanket Order Line No." = field("Line No.")));
            Caption = 'Qty. on Sales Order (not posted)';
            DecimalPlaces = 0 : 5;
            Description = '03-05-21 ZY-LD 042';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "GLC Serial No."; Code[10])
        {
            Caption = 'GLC Serial No.';
            Description = '23-02-23 ZY-LD 048';
        }
        field(50029; "GLC Mac Address"; Code[10])
        {
            Caption = 'GLC Mac Address';
            Description = '23-02-23 ZY-LD 048';
        }
        field(50036; "Skip Posting Group Validation"; Boolean)
        {
            Caption = 'Skip Posting Group Validation';
            Description = '22-06-21 ZY-LD 043';
        }
        field(50037; "Sell-to Name"; Text[100])
        {
            CalcFormula = lookup("Sales Header"."Sell-to Customer Name" where("Document Type" = field("Document Type"),
                                                                              "No." = field("Document No.")));
            Caption = 'Sell-to Name';
            Description = '12-08-21 ZY-LD 045';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50038; "Ship-to Name"; Text[100])
        {
            CalcFormula = lookup("Sales Header"."Ship-to Name" where("Document Type" = field("Document Type"),
                                                                     "No." = field("Document No.")));
            Caption = 'Ship-to Name';
            Description = '12-08-21 ZY-LD 045';
            FieldClass = FlowField;
        }
        field(50039; "Ship-to Address"; Text[100])
        {
            CalcFormula = lookup("Sales Header"."Ship-to Address" where("Document Type" = field("Document Type"),
                                                                        "No." = field("Document No.")));
            Caption = 'Ship-to Address';
            Description = '12-08-21 ZY-LD 045';
            FieldClass = FlowField;
        }
        field(50040; "Ship-to Country/Region Code"; Code[10])
        {
            CalcFormula = lookup("Sales Header"."Ship-to Country/Region Code" where("Document Type" = field("Document Type"),
                                                                                    "No." = field("Document No.")));
            Description = '12-08-21 ZY-LD 045';
            FieldClass = FlowField;
        }
        field(50041; "Salesperson Code"; Code[20])
        {
            CalcFormula = lookup("Sales Header"."Salesperson Code" where("Document Type" = field("Document Type"),
                                                                         "No." = field("Document No.")));
            Caption = 'Salesperson Code';
            Description = '12-08-21 ZY-LD 045';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(50042; "Overshipment Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Overshipment Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = field("Document Type"),
                                                          "Document No." = field("Document No."),
                                                          "Gen. Prod. Post. Grp. Type" = const(Overshipment));
        }
        field(50043; "Gen. Prod. Post. Grp. Type"; Option)
        {
            CalcFormula = lookup("Gen. Product Posting Group".Type where(Code = field("Gen. Prod. Posting Group")));
            Caption = 'Gen. Prod. Post. Grp. Type';
            Description = '06-10-21 ZY-LD 046';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Overshipment,Create on Delivery Document';
            OptionMembers = " ",Overshipment,"Create on Delivery Document";
        }
        field(50044; "Ship-to Code Cust/Item Relat."; Code[20])
        {
            CalcFormula = lookup("Customer/Item Relation"."Ship-to Code" where(Type = const("Seperate Delivery Document"),
                                                                               "Customer No." = field("Sell-to Customer No."),
                                                                               "Item No." = field("No.")));
            Caption = 'Ship-to Code Cust./Item Relation';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Customer;
        }
        field(50045; "Create Delivery Doc. pr. Item"; Boolean)
        {
            CalcFormula = exist("Customer/Item Relation" where(Type = const("Seperate Delivery Document"),
                                                               "Customer No." = field("Sell-to Customer No."),
                                                               "Item No." = field("No.")));
            Caption = 'Create Delivery Doc. pr. Item';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50046; "Zero Unit Price Accepted"; Boolean)
        {
            Caption = 'Zero Unit Price Approved';
            Description = '24-05-22 ZY-LD 047';

            trigger OnValidate()
            begin //20-08-2025 BK #524052 
                if (Rec."Zero Unit Price Accepted") and (rec.Quantity <> 0) then begin //01-09-2025 BK #425355
                    Rec.Validate("Line Discount %", 0);
                    rec.validate("Line Discount Amount", 0)
                end;
            end;
        }
        field(50047; "Order Desk Responsible Code"; Code[20])
        {
            CalcFormula = lookup("Sales Header"."Order Desk Resposible Code" where("Document Type" = field("Document Type"),
                                                                                         "No." = field("Document No.")));
            Caption = 'Order Desk Responsible Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(50048; "Item Type"; Enum "Item Type")
        {
            Caption = 'Item Type';
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50049; "Margin Approved"; Boolean)
        {
            Caption = 'Margin Approved';
            CalcFormula = exist("Margin Approval" where("Source Type" = const(Sales),
                                                        "Sales Document Type" = field("Document Type"),
                                                        "Source No." = field("Document No."),
                                                        "Source Line No." = field("Line No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(50050; "Not Returnable"; Boolean)
        {
            Caption = 'Not Returnable';
        }
        field(50100; "BOM Line No."; Integer)
        {
            Caption = 'BOM Line No.';
            Description = 'DT1.00';
        }
        field(50101; "Hide Line"; Boolean)
        {
            Description = 'DT1.00';
        }
        field(50102; "Backlog Comment"; Option)
        {
            Caption = 'Backlog Comment';
            Description = '12-09-18 ZY-LD 016';
            OptionCaption = ' ,Awaiting Prepayment,Credit Blocked,On Hold by Customer,Other,Project item on hold';
            OptionMembers = " ","Awaiting Prepayment","Credit Blocked","On Hold by Customer",Other,"Project item on hold";
        }
        field(50103; "IC Payment Terms"; Code[10])
        {
            Caption = 'IC Payment Terms';
            Description = '20-09-18 ZY-LD 017';
            TableRelation = "Payment Terms";
        }
        field(50104; EDI; Boolean)
        {
            Description = 'Unused';
        }
        // amazon
        field(55016; AmazonpurchaseOrderState; text[20])
        {
            Caption = 'Amazon purchaseOrderState';
            DataClassification = ToBeClassified;
        }

        field(55019; AmazconfirmationStatus; text[20])
        {
            Caption = 'Amazon confirmation Status';
            DataClassification = ToBeClassified;
        }
        field(55020; AmazconUnitprice; Decimal)
        {
            Caption = 'Amazon Unit price';
            DataClassification = ToBeClassified;
        }
        field(55021; AmazorderedQuantity; Decimal)
        {
            Caption = 'Amazon orderedQuantity';
            DataClassification = ToBeClassified;
        }
        field(55022; AmazacceptedQuantity; Decimal)
        {
            Caption = 'Amazon acceptedQuantity';
            DataClassification = ToBeClassified;
        }
        field(55023; AmazrejectedQuantity; Decimal)
        {
            Caption = 'Amazon rejectedQuantity';
            DataClassification = ToBeClassified;
        }


        field(62000; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62001; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62005; Status; Option)
        {
            Caption = 'Status';
            Description = 'Tectura Taiwan';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = 'Tectura Taiwan';
        }
        field(62012; "Referance Date"; Date)
        {
            Description = 'Unused';
        }
        field(62013; "Release Date"; Date)
        {
            Description = 'Unused';
        }
        field(62014; "Release Time"; Time)
        {
            Description = 'Unused';
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            Editable = false;
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  //  - eCommerce is added.';
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;
        }
        field(62018; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Description = 'Tectura Taiwan';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(62021; "Qty to Picking"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'Unused';
        }
        field(62022; "Completely Invoiced"; Boolean)
        {
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62023; "Shipment Date Confirmed"; Boolean)
        {
            Caption = 'Picking Date Confirmed';
            Description = 'HQ';

        }
        field(62024; "Lock by Ref Document"; Boolean)
        {
            Description = 'Tectura Taiwan';
        }
        field(62030; "ZBO Document No."; Text[50])
        {
            Description = 'Unused';
        }
        field(62031; "ZBO Line No."; Text[10])
        {
            Description = 'Unused';
        }
        field(62032; "Split Connection"; Integer)
        {
            Description = 'Unused';
        }
        field(66001; "DSV Status"; Option)
        {
            Description = 'Unused';
            OptionCaption = ' ,New,Sent,Mismatch,Recieved,Deliver,Matched';
            OptionMembers = " ",New,Sent,Mismatch,Recieved,Deliver,Matched;
        }
        field(66002; "BOM Header"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                   "Document No." = field("Document No."),
                                                   "BOM Line No." = field("Line No.")));
            FieldClass = FlowField;
        }
        field(66010; "Action Code"; Code[6])
        {
            Description = 'Unused';
            TableRelation = "Action Codes";
        }
        field(66011; "Posted By AIT"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(66012; RemUnitPrice; Decimal)
        {
            Description = 'Remember Unit price';
        }
    }

    keys
    {
        key(Key50000; "Document Type", "Document No.", "Currency Code")
        {
        }
        key(Key50001; Status, "Shipment Date Confirmed")
        {
        }
        key(Key50002; "Shipment Date Confirmed")
        {
        }
    }

    procedure ValidateLocation()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        Location: Record Location;
        LMSG000: Label 'Location and sales order type mismatch!';

    begin
        //Tectura Taiwan ZL100526A+
        SalesSetup.Get();
        if (Rec."Document Type" = Rec."document type"::Order) and
           SalesSetup."Sales Order Type Mandatory"
        then begin
            SalesHeader := Rec.GetSalesHeader();
            if SalesHeader."Sales Order Type" <> Rec."Sales Order Type" then
                Rec."Sales Order Type" := SalesHeader."Sales Order Type";

            if Rec."Sales Order Type" <> 0 then begin
                if Rec."Location Code" = '' then
                    Rec.Validate(Rec."Location Code", SalesHeader."Location Code");

                Clear(Location);
                Location.Reset();
                Location.Get(Rec."Location Code");

                if (Location."Sales Order Type" <> SalesHeader."Sales Order Type") and
                   (Location."Sales Order Type 2" <> SalesHeader."Sales Order Type")
                then
                    Error(LMSG000);
            end;
        end;
        //Tectura Taiwan ZL100526A-
    end;

    procedure ValidateItem()
    var
        SOHeader: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        Item: Record Item;
        LEMSG000: Label 'Item %1 is not match Sales Order Type %2!';
    begin
        SalesSetup.Get();
        if (Rec."Document Type" = Rec."document type"::Order) and
           (SalesSetup."Sales Order Type Mandatory") then begin
            Clear(SOHeader);
            SOHeader.Reset();
            SOHeader.Get(Rec."Document Type", Rec."Document No.");
            if (SOHeader."Sales Order Type" <> 0) then begin
                if (Rec."Location Code" <> SOHeader."Location Code") then Rec.Validate(Rec."Location Code", SOHeader."Location Code");
                if (SOHeader."Sales Order Type" <> 0) then Rec.Validate(Rec."Sales Order Type", SOHeader."Sales Order Type");
                if (Rec.Type = Rec.Type::Item) then begin
                    Clear(Item);
                    Item.Reset();
                    Item.Get(Rec."No.");
                    if ((Rec."Sales Order Type" = Rec."sales order type"::EICard) and
                       (not Item.IsEICard)) or
                       ((Rec."Sales Order Type" <> Rec."sales order type"::EICard) and
                       (Item.IsEICard)) then
                        Error(LEMSG000, Item."No.", Rec."Sales Order Type");
                end;
            end;
        end;

    end;

    procedure UpdateQtytoPick()
    begin
        if (Rec.Type <> Rec.Type::Item) then exit;
        if (Rec.Quantity <= 0) then exit;
    end;

    procedure CheckPicking()
    begin
        if (Rec.Type <> Rec.Type::Item) then exit;
        if (Rec.Quantity <= 0) then exit;

    end;

    procedure UpdateConsumeFlag(RollBack: Boolean; Recalc: Boolean; ForceSon: Boolean)
    begin

    end;

    procedure UpdateActionCode()
    begin

    end;

    procedure DeliveryDocument()
    var
        recDeliveryDocumentHeader: Record "VCK Delivery Document Header";
    begin
        if Rec."Delivery Document No." = '' then
            Error(Text0061);

        recDeliveryDocumentHeader.SetFilter("No.", Rec."Delivery Document No.");
        if recDeliveryDocumentHeader.FindFirst() then
            Page.Run(50086, recDeliveryDocumentHeader);
    end;

    procedure SetConfirmedDate(SET: Boolean)
    begin
        ConfirmDate := SET;
    end;

    procedure SetDontUpdateDeliveryDates(SET: Boolean)
    begin
        DontUpdateDeliveryDates := SET;
    end;

    procedure GetNextLineNo(): Integer
    var
        SalesLine: Record "Sales Line";
    Begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        IF SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000)
        else
            exit(10000);
    End;

    procedure compareAmazonprices(): Boolean
    var
        Salesheader: Record "Sales Header";
        Line: record "Sales Line";
        vLine: Variant;
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";

    begin
        GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
        PriceCalculation.ApplyPrice(line.FieldNo(Quantity));
        PriceCalculation.GetLine(vLine);
        line := vline;
        exit(line."Unit Price" <> rec.AmazconUnitprice);



    end;


    var
        ConfirmDate: Boolean;
        DontUpdateDeliveryDates: Boolean;
        Text0061: Label 'No Delivery Document has been specified.';
        Text0063: Label 'This is an EiCard order with a value of Over 1000 Euros';
}
