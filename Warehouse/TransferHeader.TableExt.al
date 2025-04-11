tableextension 50209 TransferHeaderZX extends "Transfer Header"
{
    fields
    {
        modify("Transfer-to County")
        {
            TableRelation = "Country/Region".Code;
        }
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50000; "Order For"; Option)
        {
            Caption = 'Order For';
            InitValue = OTHERS;
            OptionCaption = 'Order For CZ,OTHERS';
            OptionMembers = "Order For CZ",OTHERS;
        }
        field(50001; "Send to Warehouse"; Boolean)
        {
            Caption = 'Send to Warehouse';
            Description = 'PAB 1.0';
        }
        field(50002; "Sent to Warehouse"; Boolean)
        {
            CalcFormula = lookup("VCK Delivery Document Header".SentToAllIn where("Source No." = field("No.")));
            Caption = 'Sent to Warehouse';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Delivery Zone"; Option)
        {
            Caption = 'Delivery Zone';
            Description = 'PAB 1.0';
            OptionCaption = 'Zone 1,Zone 2,Zone 3,Zone 4,Zone 5,Zone 6,Zone 7,Zone 8,Zone 9,Zone 10';
            OptionMembers = "Zone 1","Zone 2","Zone 3","Zone 4","Zone 5","Zone 6","Zone 7","Zone 8","Zone 9","Zone 10";
        }
        field(50004; "Ref./ PO"; Text[250])
        {
            Caption = 'Ref./ PO';
            Description = 'PAB 1.0';
        }
        field(50005; "Transfer-to Forecast Territory"; Code[20])
        {
            Caption = 'Transfer-to Forecast Territory';
            Description = '20-11-18 ZY-LD 004';
            TableRelation = "Forecast Territory";
        }
        field(50008; "Completely Confirmed"; Boolean)
        {
            CalcFormula = min("Transfer Line"."Shipment Date Confirmed" where("Document No." = field("No."),
                                                                              "Shipment Date" = field("Date Filter")));
            Caption = 'Completely Confirmed';
            Description = '03-12-20 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Whse. Indb. Sent to Warehouse"; Boolean)
        {
            CalcFormula = lookup("Warehouse Inbound Header"."Sent To Warehouse" where("Shipment No." = field("No.")));
            Caption = 'Whse. Indb. Sent to Warehouse';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Transfer-to Address Code"; Code[10])
        {
            Caption = 'Transfer-to Address Code';
            Description = '08-01-21 ZY-LD 006';
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
        field(50011; "Container No."; Text[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
        }
    }

    trigger OnInsert()
    begin
        "Assigned User ID" := UserId();  // 06-10-17 ZY-LD 002
    end;
}
