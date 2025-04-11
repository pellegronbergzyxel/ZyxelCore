XmlPort 50071 "FR Sales Order"
{
    // 001. 04-10-19 ZY-LD P0314 - "ShipToCode" is added.

    Caption = 'FR Sales Order';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/sofr';
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
                XmlName = 'SalesHeaderFr';
                UseTemporary = true;
                fieldelement(CustomerNo; "Sales Header"."Sell-to Customer No.")
                {
                }
                fieldelement(OrderDate; "Sales Header"."Order Date")
                {
                }
                fieldelement(CurrencyCode; "Sales Header"."Currency Code")
                {
                }
                fieldelement(ExternalDocumentNo; "Sales Header"."External Document No.")
                {
                }
                fieldelement(ShipToCode; "Sales Header"."Ship-to Code")
                {
                }
                tableelement("Ship-to Address"; "Ship-to Address")
                {
                    MinOccurs = Zero;
                    XmlName = 'ShipToAddFr';
                    UseTemporary = true;
                    fieldelement(ShipToCustNo; "Ship-to Address"."Customer No.")
                    {
                    }
                    fieldelement(ShipToCode; "Ship-to Address".Code)
                    {
                    }
                    fieldelement(ShipToName; "Ship-to Address".Name)
                    {
                    }
                    fieldelement(ShipToName2; "Ship-to Address"."Name 2")
                    {
                    }
                    fieldelement(ShipToAdd; "Ship-to Address".Address)
                    {
                    }
                    fieldelement(ShipToAdd2; "Ship-to Address"."Address 2")
                    {
                    }
                    fieldelement(ShipToPostCode; "Ship-to Address"."Post Code")
                    {
                    }
                    fieldelement(ShipToCity; "Ship-to Address".City)
                    {
                    }
                    fieldelement(ShipToContact; "Ship-to Address".Contact)
                    {
                    }
                    fieldelement(ShipToCountry; "Ship-to Address"."Country/Region Code")
                    {
                    }
                    fieldelement(ShipToCounty; "Ship-to Address".County)
                    {
                    }
                    fieldelement(ShipToEmail; "Ship-to Address"."E-Mail")
                    {
                    }
                }
                tableelement("Sales Line"; "Sales Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'SalesLineFr';
                    UseTemporary = true;
                    fieldelement(ItemNo; "Sales Line"."No.")
                    {
                    }
                    fieldelement(Quantity; "Sales Line".Quantity)
                    {
                    }
                    fieldelement(UnitPrice; "Sales Line"."Unit Price")
                    {
                    }
                    fieldelement(ExternalDocumentNo; "Sales Line"."External Document No.")
                    {
                    }

                    trigger OnAfterInitRecord()
                    begin
                        DummyLineNo += 10000;
                        "Sales Line"."Document Type" := "Sales Header"."Document Type";
                        "Sales Line"."Document No." := "Sales Header"."No.";
                        "Sales Line"."Line No." := DummyLineNo;
                    end;
                }

                trigger OnAfterInitRecord()
                begin
                    DummyNo := IncStr(DummyNo);
                    "Sales Header"."Document Type" := "Sales Header"."document type"::Order;
                    "Sales Header"."No." := DummyNo;
                end;
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

    trigger OnPreXmlPort()
    begin
        DummyNo := '0';
    end;

    var
        recInvSetup: Record "Inventory Setup";
        DummyNo: Code[10];
        DummyLineNo: Integer;
        Text001: label '<br><table style="border=&quot;0&quot; width:150%"><tbody>';
        Text002: label '<tr><small>';
        Text003: label '<td style="width: 33%;"><span style="font-family: Century Gothic;">';
        Text004: label '</small></tr>';
        Text005: label '</span></td>';
        "Table": Text;
        Text006: label '</Table>';


    procedure SetData(pPurchOrderNo: Code[20]): Boolean
    var
        recShipToAdd: Record "Ship-to Address";
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
    begin
        if recPurchHead.Get(recPurchHead."document type"::Order, pPurchOrderNo) then begin
            //  IF recPurchHead."Order type" = recPurchHead."Order type"::"1" THEN
            //    "Sales Header"."Sell-to Customer No." := '200150'
            //  ELSE
            "Sales Header"."Sell-to Customer No." := '200149';
            "Sales Header"."Order Date" := Today;
            "Sales Header"."External Document No." := recPurchHead."No.";
            "Sales Header"."Currency Code" := recPurchHead."Currency Code";
            "Sales Header"."Bill-to Customer No." := recPurchHead."Sell-to Customer No.";
            "Sales Header"."Ship-to Code" := recPurchHead."Ship-to Code";
            "Sales Header".Insert;

            recShipToAdd.Get(recPurchHead."Sell-to Customer No.", recPurchHead."Ship-to Code");
            "Ship-to Address" := recShipToAdd;
            "Ship-to Address".Insert;

            recPurchLine.SetRange("Document Type", recPurchHead."Document Type");
            recPurchLine.SetRange("Document No.", recPurchHead."No.");
            if recPurchLine.FindSet then
                repeat
                    "Sales Line"."Line No." := recPurchLine."Line No.";
                    "Sales Line"."No." := recPurchLine."Vendor Item No.";
                    "Sales Line".Quantity := recPurchLine.Quantity;
                    "Sales Line"."Unit Price" := recPurchLine."Unit Cost";
                    "Sales Line"."External Document No." := recPurchLine."External Document No.";
                    "Sales Line".Insert;
                until recPurchLine.Next() = 0;
        end;

        exit(true);
    end;


    procedure CreateSalesOrder() rValue: Boolean
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesSetup: Record "Sales & Receivables Setup";
        recShipToAdd: Record "Ship-to Address";
        recItem: Record Item;
        LiNo: Integer;
        lText001: label 'Sales Order';
        EmailText: Text;
        lText002: label 'Different price';
        BodyVariant: array[6] of Variant;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
    begin
        if "Sales Header".FindSet then begin
            recSalesHead.LockTable;
            recSalesLine.LockTable;
            repeat
                Clear(recSalesHead);
                recSalesHead.Init;
                recSalesHead."Document Type" := recSalesHead."document type"::Order;
                recSalesSetup.Get;
                if "Sales Header"."Sell-to Customer No." = '200149' then
                    recSalesHead."Sales Order Type" := recSalesHead."sales order type"::Normal
                else
                    recSalesHead."Sales Order Type" := recSalesHead."sales order type"::EICard;
                recSalesHead.Insert(true);

                recSalesHead.Validate("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                //recSalesHead.VALIDATE("Location Code","Sales Header"."Location Code");
                recSalesHead.Validate("External Document No.", "Sales Header"."External Document No.");

                if "Sales Header"."Ship-to Code" <> '' then begin
                    recShipToAdd.SetRange("Customer No.", "Sales Header"."Sell-to Customer No.");
                    recShipToAdd.SetRange("External Customer No.", "Sales Header"."Bill-to Customer No.");
                    recShipToAdd.SetRange("External Ship-to Code", "Sales Header"."Ship-to Code");
                    if not recShipToAdd.FindFirst then begin
                        "Ship-to Address".FindFirst;
                        recShipToAdd := "Ship-to Address";
                        recShipToAdd."Customer No." := "Sales Header"."Sell-to Customer No.";
                        recShipToAdd.Code := CopyStr(DelChr(Format(CurrentDatetime, 0, 9), '=', ' .:-/APMTZ'), 3, 10);
                        recShipToAdd."External Customer No." := "Sales Header"."Bill-to Customer No.";
                        recShipToAdd."External Ship-to Code" := "Sales Header"."Ship-to Code";
                        recShipToAdd."Location Code" := 'VCK ZNET';
                        recShipToAdd."Shipment Method Code" := 'DAP';
                        recShipToAdd."Shipping Agent Code" := 'VCK';
                        recShipToAdd.Insert;

                        EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type", recSalesHead."No.");
                        EmailAddMgt.SetCustomerMergefields(recSalesHead."Sell-to Customer No.");
                        SI.SetMergefield(100, recShipToAdd.Code);
                        SI.SetMergefield(60, recSalesHead."External Document No.");
                        EmailAddMgt.CreateSimpleEmail('FRNEWSHIP', '', '');
                        EmailAddMgt.Send;
                    end;

                    recSalesHead.Validate("Ship-to Code", recShipToAdd.Code);
                end;
                recSalesHead.Modify(true);

                "Sales Line".SetRange("Document Type", "Sales Header"."Document Type");
                "Sales Line".SetRange("Document No.", "Sales Header"."No.");
                if "Sales Line".FindSet then begin
                    SetTableHeader;

                    repeat
                        recItem.Get("Sales Line"."No.");

                        LiNo += 10000;
                        Clear(recSalesLine);
                        recSalesLine.Init;
                        recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                        recSalesLine.Validate("Document No.", recSalesHead."No.");
                        recSalesLine.Validate("Line No.", LiNo);
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        recSalesLine.Validate("No.", "Sales Line"."No.");
                        recSalesLine.Validate(Quantity, "Sales Line".Quantity);
                        //recSalesLine.VALIDATE("Unit Price","Sales Line"."Unit Price");
                        recSalesLine.Validate("External Document No.", "Sales Line"."External Document No.");
                        recSalesLine.Insert(true);


                        Clear(BodyVariant);
                        BodyVariant[1] := recSalesLine."No.";
                        BodyVariant[2] := recSalesLine.Quantity;
                        BodyVariant[3] := "Sales Line"."Unit Price";
                        BodyVariant[4] := recSalesLine."Unit Price";
                        BodyVariant[6] := Format(recItem.Blocked);
                        if recSalesLine."Unit Price" <> "Sales Line"."Unit Price" then
                            BodyVariant[5] := lText002;
                        AddTable(1, BodyVariant, 6);

                    until "Sales Line".Next() = 0;

                    Clear(BodyVariant);
                    AddTable(2, BodyVariant, 0);
                end;

                Clear(EmailAddMgt);
                EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type", recSalesHead."No.");
                EmailAddMgt.CreateEmailWithBodytext('FRORDERCON', Table, '');
                EmailAddMgt.Send;
            until "Sales Header".Next() = 0;

            rValue := true;
        end;
    end;

    local procedure SetTableHeader()
    var
        lText001: label 'Part No.';
        lText002: label 'Quantity';
        lText003: label 'ZyFR Price';
        lText004: label 'ZNet Price';
        lText005: label 'Check Result';
        lText006: label 'Item Blocked';
        HeaderVariant: array[6] of Variant;
    begin
        HeaderVariant[1] := lText001;
        HeaderVariant[2] := lText002;
        HeaderVariant[3] := lText003;
        HeaderVariant[4] := lText004;
        HeaderVariant[5] := lText005;
        HeaderVariant[6] := lText006;
        AddTable(0, HeaderVariant, 6);
    end;

    local procedure AddTable(pOption: Option Header,Body,"End"; pValue: array[6] of Variant; pColumns: Integer)
    var
        i: Integer;
    begin
        if pOption = Poption::Header then
            Table := Text001;

        if pOption < Poption::"End" then begin
            Table := Table + Text002;
            for i := 1 to pColumns do begin
                Table := Table + Text003;
                Table := Table + Format(pValue[i]);
                Table := Table + Text005;
            end;
            Table := Table + Text004;
        end;

        if pOption = Poption::"End" then
            Table := Table + Text006;
    end;

    local procedure AddTableLine(pValue: array[6] of Variant; Columns: Integer)
    var
        LinkStr: Text;
        i: Integer;
    begin
        Table := Table + Text002;
        for i := 1 to Columns do begin
            Table := Table + Text003;
            Table := Table + Format(pValue[i]);
            Table := Table + Text005;
        end;
        Table := Table + Text004;
    end;

    local procedure SetTableEnd()
    begin
        Table := Table + Text006;
    end;
}
