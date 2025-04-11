XmlPort 50024 "HQ eCommerce Order"
{
    // 001. 16-06-23 ZY-LD 000 - MarketPlace is added.
    // 002. 17-07-24 ZY-LD 000 - Zyxel Store ship from VCK.

    Caption = 'WS Import Online Platform Order';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/ecom_order';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("eCommerce Order Header"; "eCommerce Order Header")
            {
                XmlName = 'Header';
                UseTemporary = true;
                fieldelement(MarketPlace; "eCommerce Order Header"."Marketplace ID")
                {
                    FieldValidate = no;
                }
                fieldelement(OrderNo; "eCommerce Order Header"."eCommerce Order Id")
                {

                    trigger OnAfterAssignField()
                    begin
                        "eCommerce Order Header".TestField("eCommerce Order Id");
                    end;
                }
                fieldelement(InvoiceNo; "eCommerce Order Header"."Invoice No.")
                {

                    trigger OnAfterAssignField()
                    begin
                        "eCommerce Order Header"."Invoice No." := UpperCase("eCommerce Order Header"."Invoice No.");
                        "eCommerce Order Header".TestField("Invoice No.");
                    end;
                }
                fieldelement(TransactionType; "eCommerce Order Header"."Transaction Type")
                {
                }
                fieldelement(TransactionID; "eCommerce Order Header"."Transaction ID")
                {
                }
                fieldelement(OrderDate; "eCommerce Order Header"."Order Date")
                {
                }
                fieldelement(ShipmentDate; "eCommerce Order Header"."Shipment Date")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ShipmentNo; "eCommerce Order Header"."Shipment ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(CurrencyCode; "eCommerce Order Header"."Currency Code")
                {
                }
                textelement(Tax)
                {
                    MaxOccurs = Once;
                    fieldelement(ExportOutsideEU; "eCommerce Order Header"."Export Outside EU")
                    {
                    }
                    fieldelement(TaxCalculationType; "eCommerce Order Header"."Tax Calculation Reason Code")
                    {
                        FieldValidate = No;
                    }
                    fieldelement(TaxRate; "eCommerce Order Header"."Tax Rate")
                    {
                    }
                    fieldelement(TaxAddressType; "eCommerce Order Header"."Tax Address Role")
                    {
                    }
                    textelement(Buyer)
                    {
                        MaxOccurs = Once;
                        fieldelement(TaxRegistrationType; "eCommerce Order Header"."Buyer Tax Reg. Type")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(TaxRegistrationNo; "eCommerce Order Header"."Purchaser VAT No.")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(TaxRegistrationCountry; "eCommerce Order Header"."Buyer Tax Reg. Country")
                        {
                            MinOccurs = Zero;
                        }
                    }
                    textelement(Seller)
                    {
                        MaxOccurs = Once;
                        fieldelement(TaxRegistrationNo; "eCommerce Order Header"."VAT Registration No. Zyxel")
                        {
                        }
                        fieldelement(TaxRegistrationCountry; "eCommerce Order Header"."Seller Tax Reg. Country")
                        {
                        }
                    }
                }
                textelement(ShipFrom)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    fieldelement(PostCode; "eCommerce Order Header"."Ship From Postal Code")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(City; "eCommerce Order Header"."Ship From City")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(State; "eCommerce Order Header"."Ship From State")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Country; "eCommerce Order Header"."Ship From Country")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(LocationCode; "eCommerce Order Header"."Ship From Tax Location Code")
                    {
                        MinOccurs = Zero;
                    }
                }
                textelement(ShipTo)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    fieldelement(PostCode; "eCommerce Order Header"."Ship To Postal Code")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(City; "eCommerce Order Header"."Ship To City")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(State; "eCommerce Order Header"."Ship To State")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Country; "eCommerce Order Header"."Ship To Country")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(LocationCode; "eCommerce Order Header"."Ship-to Tax Location Code")
                    {
                        MinOccurs = Zero;
                    }
                }
                tableelement("eCommerce Order Line"; "eCommerce Order Line")
                {
                    LinkFields = "eCommerce Order Id" = field("eCommerce Order Id"), "Invoice No." = field("Invoice No.");
                    LinkTable = "eCommerce Order Header";
                    XmlName = 'Line';
                    UseTemporary = true;
                    fieldelement(OrderNo; "eCommerce Order Line"."eCommerce Order Id")
                    {

                        trigger OnAfterAssignField()
                        begin
                            "eCommerce Order Line".TestField("eCommerce Order Id");
                        end;
                    }
                    fieldelement(InvoiceNo; "eCommerce Order Line"."Invoice No.")
                    {

                        trigger OnAfterAssignField()
                        begin
                            "eCommerce Order Line"."Invoice No." := UpperCase("eCommerce Order Line"."Invoice No.");
                            "eCommerce Order Line".TestField("Invoice No.");
                        end;
                    }
                    fieldelement(LineNo; "eCommerce Order Line"."Line No.")
                    {
                    }
                    fieldelement(ItemNo; "eCommerce Order Line"."Item No.")
                    {
                    }
                    fieldelement(Quantity; "eCommerce Order Line".Quantity)
                    {
                    }
                    fieldelement(UnitPriceExclVAT; "eCommerce Order Line"."Item Price (Exc. Tax)")
                    {
                    }
                    fieldelement(UnitPriceInclVAT; "eCommerce Order Line"."Item Price (Inc. Tax)")
                    {
                    }
                    fieldelement(AmountExclVAT; "eCommerce Order Line"."Total (Exc. Tax)")
                    {
                    }
                    fieldelement(AmountInclVAT; "eCommerce Order Line"."Total (Inc. Tax)")
                    {
                    }
                    fieldelement(TaxAmount; "eCommerce Order Line"."Total Tax Amount")
                    {
                    }
                    fieldelement(LineDiscountPct; "eCommerce Order Line"."Line Discount Pct.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(LineDiscountExclVAT; "eCommerce Order Line"."Line Discount Excl. Tax")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(LineDiscountInclVAT; "eCommerce Order Line"."Line Discount Incl. Tax")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(LineDiscountTaxAmount; "eCommerce Order Line"."Line Discount Tax Amount")
                    {
                        MinOccurs = Zero;
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        //"eCommerce Order Line"."eCommerce Order Id" := "eCommerce Order Header"."eCommerce Order Id";
                        //"eCommerce Order Line"."Invoice No." := "eCommerce Order Header"."Invoice No.";
                        "eCommerce Order Line"."Transaction Type" := "eCommerce Order Header"."Transaction Type";
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


    procedure GetData(var pAmzHeadTmp: Record "eCommerce Order Header" temporary; var pAmzLineTmp: Record "eCommerce Order Line" temporary)
    begin
        if "eCommerce Order Header".FindSet then
            repeat
                pAmzHeadTmp := "eCommerce Order Header";
                pAmzHeadTmp.Insert;

                "eCommerce Order Line".SetRange("eCommerce Order Id", "eCommerce Order Header"."eCommerce Order Id");
                "eCommerce Order Line".SetRange("Invoice No.", "eCommerce Order Header"."Invoice No.");
                if "eCommerce Order Line".FindSet then
                    repeat
                        pAmzLineTmp := "eCommerce Order Line";
                        pAmzLineTmp.Insert;
                    until "eCommerce Order Line".Next() = 0;
            until "eCommerce Order Header".Next() = 0;
    end;

    procedure ValidateOrder(): Boolean
    var
        SalesHead: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        EcomHeadTmp: Record "eCommerce Order Header" temporary;
        EcomLineTmp: Record "eCommerce Order Line" temporary;
        EcomMktPlace: Record "eCommerce Market Place";
        EcomDocToSalesDoc: Codeunit "eCommerce-Order to Invoice";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        SalesAmountInclVAT: Decimal;
        SumSalesAmountInclVAT: Decimal;
        SumEcomAmountInclVAT: Decimal;
        NewLineNo: Integer;
        lText001: Label 'There is not enough stock avaliable for %1. Avaliable stock: %2.';
    begin
        //>> 17-07-24 ZY-LD 002
        // eCommerce header and line setup data for some fields. Therefore it´s pratical to setup everything before the sales order is created.
        if "eCommerce Order Header".FindSet then
            repeat
                EcomMktPlace.SetRange("Market Place Name", "eCommerce Order Header"."Marketplace ID");
                EcomMktPlace.FindFirst();
                EcomMktPlace.TestField("VAT Prod. Posting Group");

                // Insert eCommerce Header 
                EcomHeadTmp.Init();
                EcomHeadTmp.SetVatProdPostingGroup(EcomMktPlace."VAT Prod. Posting Group");
                EcomHeadTmp.Validate("eCommerce Order Id", "eCommerce Order Header"."eCommerce Order Id");
                EcomHeadTmp.Validate("Invoice No.", "eCommerce Order Header"."Invoice No.");
                EcomHeadTmp.Validate("Marketplace ID", EcomMktPlace."Marketplace ID");
                EcomHeadTmp.Validate("Purchaser VAT No.", "eCommerce Order Header"."Purchaser VAT No.");
                EcomHeadTmp.Validate("Export Outside EU", "eCommerce Order Header"."Export Outside EU");
                EcomHeadTmp.Validate("Transaction Type", "eCommerce Order Header"."Transaction Type");
                EcomHeadTmp.Validate("Tax Type", "eCommerce Order Header"."Tax Type");
                EcomHeadTmp.Validate("Tax Calculation Reason Code", "eCommerce Order Header"."Tax Calculation Reason Code");
                EcomHeadTmp.Validate("Tax Address Role", "eCommerce Order Header"."Tax Address Role");
                EcomHeadTmp.Validate("Buyer Tax Reg. Country", "eCommerce Order Header"."Buyer Tax Reg. Country");
                EcomHeadTmp.Validate("Tax Rate", "eCommerce Order Header"."Tax Rate");
                EcomHeadTmp.Validate("Transaction ID", "eCommerce Order Header"."Transaction ID");
                EcomHeadTmp.Validate("Shipment ID", "eCommerce Order Header"."Shipment ID");
                EcomHeadTmp.Validate("Order Date", "eCommerce Order Header"."Order Date");
                EcomHeadTmp.Validate("Shipment Date", "eCommerce Order Header"."Shipment Date");
                EcomHeadTmp.Validate("Invoice No.", "eCommerce Order Header"."Invoice No.");
                EcomHeadTmp.Validate("Ship To City", "eCommerce Order Header"."Ship To City");
                EcomHeadTmp.Validate("Ship To State", "eCommerce Order Header"."Ship To State");
                EcomHeadTmp.Validate("Ship To Country", "eCommerce Order Header"."Ship To Country");
                EcomHeadTmp.Validate("Ship To Postal Code", "eCommerce Order Header"."Ship To Postal Code");
                EcomHeadTmp.Validate("Ship From City", "eCommerce Order Header"."Ship From City");
                EcomHeadTmp.Validate("Ship From State", "eCommerce Order Header"."Ship From State");
                EcomHeadTmp.Validate("Ship From Country", "eCommerce Order Header"."Ship From Country");
                EcomHeadTmp.Validate("Ship From Postal Code", "eCommerce Order Header"."Ship From Postal Code");
                EcomHeadTmp.Validate("Ship From Tax Location Code", "eCommerce Order Header"."Ship From Tax Location Code");
                EcomHeadTmp.Validate("VAT Registration No. Zyxel", "eCommerce Order Header"."VAT Registration No. Zyxel");
                EcomHeadTmp.Validate("Currency Code", "eCommerce Order Header"."Currency Code");
                EcomHeadTmp.Insert(true);

                // If we see the same order id twice, we will delete the first one.
                SalesHead.SetRange("Document Type", SalesHead."Document Type"::Order);
                SalesHead.SetRange("Sales Order Type", SalesHead."Sales Order Type"::eCommerce);
                SalesHead.SetRange("External Document No.", EcomHeadTmp."eCommerce Order Id");
                if SalesHead.FindFirst() then
                    SalesHead.delete(true);

                SI.SetKeepLocationCode(true);
                Clear(SalesHead);
                SalesHead.reset;
                SalesHead.Init();
                SalesHead.SetHideValidationDialog(true);
                SalesHead.Validate("Document Type", SalesHead."Document Type"::Order);
                SalesHead.Insert(true);

                SalesHead."Sales Order Type" := SalesHead."sales order type"::eCommerce;
                SalesHead."eCommerce Order" := true;
                SalesHead.Validate("Sell-to Customer No.", EcomMktPlace."Customer No.");
                SalesHead.Validate("Salesperson Code", EcomMktPlace."Sales Person Code");
                SalesHead.Validate("External Document No.", EcomHeadTmp."eCommerce Order Id");
                //SalesHead.Validate("External Invoice No.", Rec."Invoice No.");
                //SalesHead.Validate("Your Reference", Rec."eCommerce Order Id");
                //SalesHead.Validate("Reference 2", Rec."eCommerce Order Id");
                SalesHead.Validate("Location Code", EcomHeadTmp."Location Code");
                SalesHead.Validate("Currency Code", EcomHeadTmp."Currency Code");
                IF EcomHeadTmp."Alt. VAT Bus. Posting Group" <> '' THEN BEGIN
                    SalesHead.VALIDATE("VAT Bus. Posting Group", EcomHeadTmp."Alt. VAT Bus. Posting Group");
                END ELSE
                    SalesHead.Validate("VAT Bus. Posting Group", EcomHeadTmp."VAT Bus. Posting Group");
                SalesHead.VALIDATE("Prices Including VAT", EcomHeadTmp."Prices Including VAT");
                SalesHead."Transport Method" := EcomMktPlace."Transport Method";
                SalesHead."Requested Delivery Date" := EcomHeadTmp."Requested Delivery Date";
                SalesHead."Shipment Method Code" := EcomMktPlace."Shipment Method";
                SalesHead."Shipping Agent Code" := EcomMktPlace."Shipping Agent Code";
                SalesHead."Shipment Date" := Today;
                SalesHead.Validate("Transaction Type", EcomMktPlace."Transaction Type - Order");
                SalesHead."Ship-to Name" := copystr(StrSubstNo('%1 %2 %3', EcomHeadTmp."Ship To Postal Code", EcomHeadTmp."Ship To City", EcomHeadTmp."Ship to Country"), 1, Maxstrlen(SalesHead."Ship-to Name"));
                SalesHead."Ship-to Name 2" := '';
                SalesHead."Ship-to Country/Region Code" := EcomHeadTmp."Ship To Country";
                SalesHead."Ship-to County" := CopyStr(EcomHeadTmp."Ship To State", 1, MaxStrLen(SalesHead."Ship-to County"));
                SalesHead."Ship-to Post Code" := EcomHeadTmp."Ship To Postal Code";
                SalesHead."Ship-to City" := CopyStr(EcomHeadTmp."Ship To City", 1, MaxStrLen(SalesHead."Ship-to City"));
                SalesHead."Ship-to VAT" := EcomHeadTmp."Purchaser VAT No.";
                IF EcomHeadTmp."Alt. VAT Reg. No. Zyxel" <> '' THEN
                    SalesHead."VAT Registration No. Zyxel" := EcomHeadTmp."Alt. VAT Reg. No. Zyxel"
                ELSE
                    SalesHead."VAT Registration No. Zyxel" := EcomHeadTmp."VAT Registration No. Zyxel";

                SalesHead.Ship := true;
                SalesHead.Invoice := true;
                SalesHead."eCommerce Order" := true;
                SalesHead."Skip Posting Group Validation" := true;
                SalesHead.Modify();
                SalesHead.ValidateShortcutDimCode(3, EcomHeadTmp."Country Dimension");
                SalesHead.Modify();
                SI.SetKeepLocationCode(false);

                "eCommerce Order Line".SetRange("eCommerce Order Id", "eCommerce Order Header"."eCommerce Order Id");
                "eCommerce Order Line".SetRange("Invoice No.", "eCommerce Order Header"."Invoice No.");
                if "eCommerce Order Line".FindSet then begin
                    repeat
                        NewLineNo += 10000;
                        Clear(EcomLineTmp);
                        EcomLineTmp.Init();

                        EcomLineTmp.Validate("Transaction Type", EcomHeadTmp."Transaction Type");
                        EcomLineTmp.Validate("eCommerce Order Id", EcomHeadTmp."eCommerce Order Id");
                        EcomLineTmp.Validate("Invoice No.", EcomHeadTmp."Invoice No.");
                        EcomLineTmp.Validate("Line No.", NewLineNo);
                        EcomLineTmp.Validate("Item No.", "eCommerce Order Line"."Item No.");
                        EcomLineTmp.Validate(Quantity, "eCommerce Order Line".Quantity);
                        EcomLineTmp.ValidateVATProdPostingGroup(EcomMktPlace."VAT Prod. Posting Group", EcomHeadTmp, EcomLineTmp, EcomMktPlace);
                        EcomLineTmp.Validate("Item Price (Exc. Tax)", "eCommerce Order Line"."Item Price (Exc. Tax)");
                        EcomLineTmp.Validate("Item Price (Inc. Tax)", "eCommerce Order Line"."Item Price (Inc. Tax)");
                        EcomLineTmp.Validate("Total (Exc. Tax)", "eCommerce Order Line"."Total (Exc. Tax)");
                        EcomLineTmp.Validate("Total (Inc. Tax)", "eCommerce Order Line"."Total (Inc. Tax)");
                        EcomLineTmp.Validate("Total Tax Amount", "eCommerce Order Line"."Total Tax Amount");
                        EcomLineTmp.Validate("Line Discount Pct.", "eCommerce Order Line"."Line Discount Pct.");
                        EcomLineTmp.Validate("Line Discount Excl. Tax", "eCommerce Order Line"."Line Discount Excl. Tax");
                        EcomLineTmp.Validate("Line Discount Incl. Tax", "eCommerce Order Line"."Line Discount Incl. Tax");
                        EcomLineTmp.Validate("Line Discount Tax Amount", "eCommerce Order Line"."Line Discount Tax Amount");
                        EcomLineTmp.Validate(Amount);
                        EcomLineTmp.Insert;

                        Item.SetRange("Location Filter", SalesHead."Location Code");
                        if Item.get(EcomLineTmp."Item No.") and (item.CalcAvailableStock(true) < EcomLineTmp.Quantity) then
                            Error(lText001, EcomLineTmp."Item No.", Item.CalcAvailableStock(true));

                        EcomDocToSalesDoc.TransferEComLineToSalesLine(EcomHeadTmp, EcomLineTmp, SalesHead, EcomMktPlace, SalesAmountInclVAT);

                        SumSalesAmountInclVAT += SalesAmountInclVAT;
                        SumEcomAmountInclVAT += EcomLineTmp."Amount Including VAT";
                        EcomLineTmp.Delete;
                    until "eCommerce Order Line".Next() = 0;

                    EcomDocToSalesDoc.EndSalesLine(SalesHead, EcomMktPlace, SumEcomAmountInclVAT, SumSalesAmountInclVAT);
                    Codeunit.Run(Codeunit::"Release Sales Document", SalesHead);
                end;
            until "eCommerce Order Header".Next() = 0;
        exit(true);
        //<< 17-07-24 ZY-LD 002
    end;
}
