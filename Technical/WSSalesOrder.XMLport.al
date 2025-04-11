XmlPort 50067 "WS Sales Order"
{
    // 001. 12-08-19 ZY-LD 2019071610000038 - Automatic Ship-to Code.
    // 002. 16-08-19 ZY-LD 2019071810000061 - Shipping Request Note is transfered.

    Caption = 'WS Sales Order';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/so';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Sales Header"; "Sales Header")
            {
                MinOccurs = Zero;
                XmlName = 'SalesOrder';
                UseTemporary = true;
                fieldelement(CustomerNo; "Sales Header"."Sell-to Customer No.")
                {
                }
                fieldelement(ExternalDocNo; "Sales Header"."External Document No.")
                {
                }
                fieldelement(ShipRequestNote; "Sales Header"."Shipping Request Notes")
                {
                }
                tableelement("Sales Line"; "Sales Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'SalesOrderLine';
                    UseTemporary = true;
                    fieldelement(ItemNo; "Sales Line"."No.")
                    {
                    }
                    fieldelement(Quantity; "Sales Line".Quantity)
                    {
                    }
                    fieldelement(UnitOfMeasureCode; "Sales Line"."Unit of Measure Code")
                    {
                    }
                    fieldelement(PurchaseOrderNo; "Sales Line"."Ext Vend Purch. Order No.")
                    {
                    }
                    fieldelement(PurchaseOrderLineNo; "Sales Line"."Ext Vend Purch. Order Line No.")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Sales Line".SetRange("Document No.", "Sales Header"."No.");
                    end;

                    trigger OnBeforeInsertRecord()
                    begin
                        LineNo += 10000;
                        "Sales Line"."Line No." := LineNo;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        LineNo: Integer;


    procedure SetData(pPurchOrderNo: Code[20]; pCustomerNo: Code[20]): Boolean
    var
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recItem: Record Item;
    begin
        if recPurchHead.Get(recPurchHead."document type"::Order, pPurchOrderNo) then begin
            "Sales Header"."No." := recPurchHead."No.";
            "Sales Header"."Sell-to Customer No." := pCustomerNo;
            "Sales Header"."External Document No." := recPurchHead."No.";
            "Sales Header"."Shipping Request Notes" := recPurchHead."Shipping Request Notes";  // 16-08-19 ZY-LD 002
            "Sales Header".Insert;

            recPurchLine.SetRange("Document Type", recPurchHead."Document Type");
            recPurchLine.SetRange("Document No.", recPurchHead."No.");
            recPurchLine.SetRange(Type, recPurchLine.Type::Item);
            if recPurchLine.FindSet then
                repeat
                    "Sales Line"."Document No." := "Sales Header"."No.";
                    "Sales Line"."Line No." := recPurchLine."Line No.";
                    //recItem.GET(recPurchLine."No.");
                    //IF recItem."Vendor Item No." <> '' THEN
                    //  "Sales Line"."No." := recItem."Vendor Item No."
                    //ELSE
                    "Sales Line"."No." := recPurchLine."No.";
                    "Sales Line".Quantity := recPurchLine.Quantity;
                    "Sales Line"."Unit of Measure Code" := recPurchLine."Unit of Measure Code";
                    "Sales Line"."Ext Vend Purch. Order No." := recPurchLine."Document No.";
                    "Sales Line"."Ext Vend Purch. Order Line No." := recPurchLine."Line No.";
                    "Sales Line".Insert;
                until recPurchLine.Next() = 0;

            recPurchHead."EShop Order Sent" := true;
            recPurchHead.Modify;
        end;
        exit(true);
    end;


    procedure InsertData()
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recShipToAdd: Record "Ship-to Address";
    begin
        if "Sales Header".FindSet then
            repeat
                Clear(recSalesHead);
                recSalesHead.Validate("Document Type", recSalesHead."document type"::Order);
                recSalesHead.Insert(true);

                recSalesHead.Validate("Sales Order Type", recSalesHead."sales order type"::Normal);
                recSalesHead.Validate("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                recSalesHead.Validate("External Document No.", "Sales Header"."External Document No.");
                recSalesHead.Validate("Shipping Request Notes", "Sales Header"."Shipping Request Notes");  // 16-08-19 ZY-LD 002

                //>> 12-08-19 ZY-LD 001
                recShipToAdd.SetRange("Customer No.", "Sales Header"."Sell-to Customer No.");
                if recShipToAdd.FindFirst and (recShipToAdd.Count = 1) then
                    recSalesHead.Validate("Ship-to Code", recShipToAdd.Code);
                //<< 12-08-19 ZY-LD 001
                recSalesHead.Modify;

                "Sales Line".SetRange("Document No.", "Sales Header"."No.");
                if "Sales Line".FindSet then
                    repeat
                        Clear(recSalesLine);
                        recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                        recSalesLine.Validate("Document No.", recSalesHead."No.");
                        recSalesLine.Validate("Line No.", "Sales Line"."Line No.");
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        recSalesLine.Validate("No.", "Sales Line"."No.");
                        recSalesLine.Validate(Quantity, "Sales Line".Quantity);
                        recSalesLine.Validate("Unit of Measure Code", "Sales Line"."Unit of Measure Code");
                        recSalesLine.Validate("Ext Vend Purch. Order No.", "Sales Line"."Ext Vend Purch. Order No.");
                        recSalesLine.Validate("Ext Vend Purch. Order Line No.", "Sales Line"."Ext Vend Purch. Order Line No.");
                        recSalesLine.Insert(true);
                    until "Sales Line".Next() = 0;
            until "Sales Header".Next() = 0;
    end;
}
