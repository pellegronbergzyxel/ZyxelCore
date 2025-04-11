tableextension 50210 TransferLineZX extends "Transfer Line"
{
    fields
    {
        modify("Shipment Date")
        {
            Caption = 'Picking Date';
        }
        field(50000; "Shipment Date Confirmed"; Boolean)
        {
            Caption = 'Picking Date Confirmed';
            Description = 'ZY1.0';
        }
        field(50001; "Picking Status"; Option)
        {
            Description = 'ZY1.0';
            OptionCaption = ' ,New,Sent';
            OptionMembers = " ",New,Sent;
        }
        field(50002; "DSV Sent Date Time"; DateTime)
        {
            Description = 'ZY1.0';
        }
        field(50003; "Warehouse Status"; Option)
        {
            CalcFormula = lookup("VCK Delivery Document Line"."Warehouse Status" where("Document Type" = const(Transfer),
                                                                                       "Sales Order No." = field("Document No."),
                                                                                       "Sales Order Line No." = field("Line No.")));
            Caption = 'Warehouse Status';
            Description = '07-01-21 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        }
        field(50007; "Delivery Document No."; Code[20])
        {
            CalcFormula = lookup("VCK Delivery Document Line"."Document No." where("Document Type" = const(Transfer),
                                                                                   "Sales Order No." = field("Document No."),
                                                                                   "Sales Order Line No." = field("Line No.")));
            Caption = 'Delivery Document No.';
            Description = '07-01-21 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; Customer_PO; Code[20])
        {
            Description = 'ZY1.1';
        }
        field(50011; "Transfer-to Address Code"; Code[10])
        {
            Caption = 'Transfer-to Address Code';
            Description = '30-06-22 ZY-LD 007';
            TableRelation = "Transfer-to Address".Code where("Location Code" = field("Transfer-to Code"));

            trigger OnValidate()
            var
                recSalesLine: Record "Sales Line";
                AllInDates: Codeunit "Delivery Document Management";
            begin
                /*IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Ship-to Code" <> "Ship-to Code")
                THEN BEGIN
                  SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
                  SalesLine.SETRANGE("Document No.","No.");
                  SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
                  IF NOT SalesLine.ISEMPTY THEN
                    ERROR(
                      Text006,
                      FieldCaption("Ship-to Code"));
                  SalesLine.RESET;
                END;
                
                IF ("Document Type" <> "Document Type"::"Return Order") AND
                   ("Document Type" <> "Document Type"::"Credit Memo")
                THEN
                  IF "Ship-to Code" <> '' THEN BEGIN
                    IF xRec."Ship-to Code" <> '' THEN
                      BEGIN
                      GetCust("Sell-to Customer No.");
                      IF Cust."Location Code" <> '' THEN
                        VALIDATE("Location Code",Cust."Location Code");
                      "Tax Area Code" := Cust."Tax Area Code";
                    END;
                    ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
                    "Ship-to Name" := ShipToAddr.Name;
                    "Ship-to Name 2" := ShipToAddr."Name 2";
                    "Ship-to Address" := ShipToAddr.Address;
                    "Ship-to Address 2" := ShipToAddr."Address 2";
                    "Ship-to City" := ShipToAddr.City;
                    "Ship-to Post Code" := ShipToAddr."Post Code";
                    "Ship-to County" := ShipToAddr.County;
                    VALIDATE("Ship-to Country/Region Code",ShipToAddr."Country/Region Code");
                    "Ship-to Contact" := ShipToAddr.Contact;
                    "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                    IF ShipToAddr."Location Code" <> '' THEN
                      VALIDATE("Location Code",ShipToAddr."Location Code");
                    "Ship-to E-Mail" :=  ShipToAddr."E-Mail"; //15-51643
                    "Delivery Zone" := ShipToAddr."Delivery Zone"; //15-51643
                    "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
                    "Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
                    IF ShipToAddr."Tax Area Code" <> '' THEN
                      "Tax Area Code" := ShipToAddr."Tax Area Code";
                    "Tax Liable" := ShipToAddr."Tax Liable";
                  END ELSE
                    IF "Sell-to Customer No." <> '' THEN BEGIN
                      GetCust("Sell-to Customer No.");
                      "Ship-to Name" := Cust.Name;
                      "Ship-to Name 2" := Cust."Name 2";
                      "Ship-to Address" := Cust.Address;
                      "Ship-to Address 2" := Cust."Address 2";
                      "Ship-to City" := Cust.City;
                      "Ship-to Post Code" := Cust."Post Code";
                      "Ship-to County" := Cust.County;
                      VALIDATE("Ship-to Country/Region Code",Cust."Country/Region Code");
                      "Delivery Zone" := Cust."Delivery Zone"; //15-51643
                      "Ship-to Contact" := Cust.Contact;
                      "Shipment Method Code" := Cust."Shipment Method Code";
                      "Tax Area Code" := Cust."Tax Area Code";
                      "Tax Liable" := Cust."Tax Liable";
                      IF Cust."Location Code" <> '' THEN
                        VALIDATE("Location Code",Cust."Location Code");
                      "Shipping Agent Code" := Cust."Shipping Agent Code";
                      "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
                    END;
                
                GetShippingTime(FIELDNO("Ship-to Code"));
                GetDefaultActionCode; //15-51643
                
                IF (xRec."Sell-to Customer No." = "Sell-to Customer No.") AND
                   (xRec."Ship-to Code" <> "Ship-to Code")
                THEN
                  IF (xRec."VAT Country/Region Code" <> "VAT Country/Region Code") OR
                     (xRec."Tax Area Code" <> "Tax Area Code")
                  THEN
                    RecreateSalesLines(FieldCaption("Ship-to Code"))
                  ELSE BEGIN
                    IF xRec."Shipping Agent Code" <> "Shipping Agent Code" THEN
                      MessageIfSalesLinesExist(FieldCaption("Shipping Agent Code"));
                    IF xRec."Shipping Agent Service Code" <> "Shipping Agent Service Code" THEN
                      MessageIfSalesLinesExist(FieldCaption("Shipping Agent Service Code"));
                    IF xRec."Tax Liable" <> "Tax Liable" THEN
                      VALIDATE("Tax Liable");
                  END;
                
                // PAB
                //"Shipment Date" := AllInDates.xCalcShipmentDate("Ship-to Country/Region Code","Shipment Date") ;  // 06-09-18 ZY-LD 014
                "Shipment Date" := AllInDates.CalcShipmentDate('','',"Ship-to Country/Region Code","Shortcut Dimension 1 Code","Shipment Date",FALSE);  // 06-09-18 ZY-LD 014  // 14-11-18 ZY-LD 016
                
                // PAB
                recSalesLine.SETFILTER("Document No.","No.");
                recSalesLine.SETRANGE(Type,recSalesLine.Type::Item);
                IF recSalesLine.FINDFIRST THEN BEGIN
                  REPEAT
                    recSalesLine."Ship-to Code" := "Ship-to Code";
                    recSalesLine.MODIFY;
                    //recSalesLine.UpdateActionCode;  // 11-11-19 ZY-LD 027
                  UNTIL recSalesLine.Next() = 0;
                END;
                */
            end;
        }
        field(50018; "Additional Item Line No."; Integer)
        {
            Caption = 'Additional Item Line No.';
            Description = '15-01-18 ZY-LD 001';
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '23-03-20 ZY-LD 003';
        }
        field(70000; ExpectedReceiptDate; Date)
        {
            Caption = 'Expected Receipt Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(70001; PurchaseOrderNo; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(70002; PurchaseOrderLineNo; Integer)
        {
            Caption = 'Purchase Order Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
