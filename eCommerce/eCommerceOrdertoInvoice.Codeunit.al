codeunit 50011 "eCommerce-Order to Invoice"
{
    TableNo = "eCommerce Order Header";


    trigger OnRun()
    var
        recAmzCompMap: Record "eCommerce Market Place";
    begin
        Rec.TestField("Location Code");
        recAmzCompMap.Get(Rec."Marketplace ID");
        recAmzCompMap.TestField("Return Reason Code for Cr. Mem");
        recAmzCompMap.TestField("Customer No.");
        recAmzCompMap.TestField("Transaction Type - Order");
        recAmzCompMap.TestField("Transaction Type - Refund");

        SI.SetKeepLocationCode(true);
        recSalesHead.Init();
        recSalesHead.SetHideValidationDialog(true);
        recSalesHead."Document Type" := Rec."Sales Document Type";
        recSalesHead.Insert(true);

        recSalesHead."Sales Order Type" := recSalesHead."sales order type"::eCommerce;
        recSalesHead.Validate("Sell-to Customer No.", recAmzCompMap."Customer No.");
        if ReplacePostingDate then
            recSalesHead.Validate("Posting Date", PostingDate);
        recSalesHead.VALIDATE("Document Date", Rec."Order Date");
        recSalesHead.Validate("Salesperson Code", recAmzCompMap."Sales Person Code");
        recSalesHead.Validate("External Document No.", Rec."eCommerce Order Id");
        recSalesHead.Validate("External Invoice No.", Rec."Invoice No.");
        recSalesHead.Validate("Your Reference", Rec."eCommerce Order Id");
        recSalesHead.Validate("Reference 2", Rec."eCommerce Order Id");
        recSalesHead.Validate("Location Code", Rec."Location Code");
        recSalesHead.Validate("Currency Code", Rec."Currency Code");

        IF Rec."Alt. VAT Bus. Posting Group" <> '' THEN
            recSalesHead.VALIDATE("VAT Bus. Posting Group", Rec."Alt. VAT Bus. Posting Group")
        ELSE
            recSalesHead.Validate("VAT Bus. Posting Group", Rec."VAT Bus. Posting Group");
        recSalesHead.VALIDATE("Prices Including VAT", Rec."Prices Including VAT");

        recSalesHead."Transport Method" := recAmzCompMap."Transport Method";
        recSalesHead."Requested Delivery Date" := Rec."Requested Delivery Date";
        recSalesHead."Shipment Method Code" := recAmzCompMap."Shipment Method";
        recSalesHead."Shipping Agent Code" := recAmzCompMap."Shipping Agent Code";
        recSalesHead."Shipment Date" := Today;
        case Rec."Transaction Type" of
            Rec."transaction type"::Order:
                recSalesHead.Validate("Transaction Type", recAmzCompMap."Transaction Type - Order");
            Rec."transaction type"::Refund:
                recSalesHead.Validate("Transaction Type", recAmzCompMap."Transaction Type - Refund");
        end;

        recSalesHead."Ship-to Name" := copystr(StrSubstNo('%1 %2 %3', Rec."Ship To Postal Code", Rec."Ship To City", Rec."Ship to Country"), 1, Maxstrlen(recSaleshead."Ship-to Name"));
        recSalesHead."Ship-to Name 2" := '';
        recSalesHead."Ship-to Country/Region Code" := Rec."Ship To Country";
        recSalesHead."Ship-to County" := CopyStr(Rec."Ship To State", 1, MaxStrLen(recSalesHead."Ship-to County"));
        recSalesHead."Ship-to Post Code" := Rec."Ship To Postal Code";
        recSalesHead."Ship-to City" := CopyStr(Rec."Ship To City", 1, MaxStrLen(recSalesHead."Ship-to City"));

        if Rec."Applies-to ID" <> '' then
            recSalesHead.Validate("Applies-to ID", Rec."Applies-to ID")
        else
            if Rec."Applies-to Doc. No." <> '' then begin
                recSalesHead.Validate("Applies-to Doc. Type", Rec."Applies-to Doc. Type");
                recSalesHead.Validate("Applies-to Doc. No.", Rec."Applies-to Doc. No.");
            end;

        recSalesHead."Ship-to VAT" := Rec."Purchaser VAT No.";
        if (ZGT.IsRhq() and ZGT.IsZNetCompany()) or  // ZNet DK
           (ZGT.IsZComCompany() and ZGT.CompanyNameIs(11))  // ZyND DE
        then
            IF Rec."Alt. VAT Reg. No. Zyxel" <> '' THEN
                recSalesHead."VAT Registration No. Zyxel" := Rec."Alt. VAT Reg. No. Zyxel"
            ELSE
                recSalesHead."VAT Registration No. Zyxel" := Rec."VAT Registration No. Zyxel";

        recSalesHead.Ship := true;
        recSalesHead.Invoice := true;
        recSalesHead."eCommerce Order" := true;
        recSalesHead."Skip Posting Group Validation" := true;
        if Rec.Correction then
            recSalesHead."Reason Code" := 'AMZ-CORR F';

        recSalesHead.Modify();
        recSalesHead.ValidateShortcutDimCode(3, Rec."Country Dimension");
        recSalesHead.Modify();
        SI.SetKeepLocationCode(false);

        TransfereCommerceToSalesInvoiceLine(Rec, recSalesHead, recAmzCompMap);
    end;

    var
        recSalesHead: Record "Sales Header";
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        ReplacePostingDate: Boolean;
        PostingDate: Date;

    local procedure TransfereCommerceToSalesInvoiceLine(var Rec: Record "eCommerce Order Header"; var pSalesHead: Record "Sales Header"; var pAmzCompMap: Record "eCommerce Market Place")
    var
        recAmzMktPlace: Record "eCommerce Market Place";
        recAmzSalesLine: Record "eCommerce Order Line";
        recVatProdPostGrp: Record "VAT Product Posting Group";
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        recSalesLine: Record "Sales Line";
        ItemNo: Code[50];
        LineNo: Integer;
        lText006: Label 'Item No. %1 does not exists anymore', Comment = '%1 = Item No.';
        i: Integer;
        SumAmountInclVAT: Decimal;
    begin
        recAmzMktPlace.Get(Rec."Marketplace ID");
        recAmzMktPlace.TestField("Accepted Rounding");
        recAmzMktPlace.TestField(Roundings);

        recAmzSalesLine.SetRange("Transaction Type", Rec."Transaction Type");
        recAmzSalesLine.SetRange("eCommerce Order Id", Rec."eCommerce Order Id");
        recAmzSalesLine.SetRange("Invoice No.", Rec."Invoice No.");
        if recAmzSalesLine.FindSet() then begin
            repeat
                if (recAmzMktPlace."Code for Shipping Fee" = '') or
                   (recAmzSalesLine."Item No." <> recAmzMktPlace."Code for Shipping Fee")
                then begin
                    ItemNo := '';
                    if StrLen(recAmzSalesLine."Item No.") > MaxStrLen(recItem."No.") then begin
                        recItemIdent.SetRange(ExtendedCodeZX, recAmzSalesLine."Item No.");
                        if not recItemIdent.FindFirst() then
                            Error(lText006, recAmzSalesLine."Item No.");
                        ItemNo := recItemIdent."Item No.";
                    end else
                        if not recItem.Get(recAmzSalesLine."Item No.") then begin
                            recItemIdent.SetRange(ExtendedCodeZX, recAmzSalesLine."Item No.");
                            if recItemIdent.FindFirst() then
                                ItemNo := recItemIdent."Item No.";
                        end else
                            ItemNo := recItem."No.";

                end;

                for i := 1 to 7 do begin
                    if (i = 1) or
                       ((i = 2) and (recAmzSalesLine."Total Shipping (Exc. Tax)" <> 0)) or
                       ((i = 3) and (recAmzSalesLine."Shipping Promo (Exc. Tax)" <> 0)) or
                       ((i = 4) and (recAmzSalesLine."Total Promo (Exc. Tax)" <> 0)) or
                       ((i = 5) and (recAmzSalesLine."Gift Wrap (Exc. Tax)" <> 0)) or
                       ((i = 6) and (recAmzSalesLine."Gift Wrap Promo (Exc. Tax)" <> 0)) or
                       ((i = 7) and (recAmzSalesLine."Line Discount Excl. Tax" <> 0))
                    then begin
                        LineNo += 10000;
                        Clear(recSalesLine);
                        recSalesLine.Init();
                        recSalesLine.SetHideValidationDialog(true);
                        recSalesLine.Validate("Document Type", pSalesHead."Document Type");
                        recSalesLine.Validate("Document No.", pSalesHead."No.");
                        recSalesLine.Validate("Line No.", LineNo);

                        case true of
                            recAmzSalesLine."Item No." = recAmzMktPlace."Code for Shipping Fee":
                                begin
                                    recAmzMktPlace.TestField("Shipping G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Shipping G/L Account No.");
                                    recSalesLine.VALIDATE(Description, recAmzSalesLine."Item No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                end;
                            recAmzSalesLine."Item No." = recAmzMktPlace."Code for Compensation Fee":
                                BEGIN
                                    recAmzMktPlace.TESTFIELD("Fee Account No.");
                                    recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.VALIDATE("No.", recAmzMktPlace."Fee Account No.");
                                    recSalesLine.VALIDATE(Description, recAmzSalesLine."Item No.");
                                    recSalesLine.VALIDATE(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                END;
                            recAmzSalesLine."Item No." = recAmzMktPlace."Code for Discount":
                                begin
                                    recAmzMktPlace.TestField("Discount G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Discount G/L Account No.");
                                    recSalesLine.VALIDATE(Description, recAmzSalesLine."Item No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                end;
                            (i = 2) and (recAmzSalesLine."Total Shipping (Exc. Tax)" <> 0):
                                begin
                                    recAmzMktPlace.TestField("Shipping G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Shipping G/L Account No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Total Shipping (Inc. Tax)"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Total Shipping (Exc. Tax)";
                                end;
                            (i = 3) and (recAmzSalesLine."Shipping Promo (Exc. Tax)" <> 0):
                                begin
                                    recAmzMktPlace.TestField("Advertising G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Advertising G/L Account No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then begin
                                        if (Rec."Sales Document Type" = "sales document type"::"Credit Memo") and (Rec."Transaction Type" = Rec."transaction type"::Order) then
                                            recSalesLine."Unit Price" := -recAmzSalesLine."Shipping Promo (Inc. Tax)"
                                        else
                                            recSalesLine."Unit Price" := recAmzSalesLine."Shipping Promo (Inc. Tax)";
                                    end else
                                        if (Rec."Sales Document Type" = "sales document type"::"Credit Memo") and (Rec."Transaction Type" = Rec."transaction type"::Order) then
                                            recSalesLine."Unit Price" := -recAmzSalesLine."Shipping Promo (Exc. Tax)"
                                        else
                                            recSalesLine."Unit Price" := recAmzSalesLine."Shipping Promo (Exc. Tax)";

                                    recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace."Advertising G/L Account No."));
                                end;
                            (i = 4) and (recAmzSalesLine."Total Promo (Exc. Tax)" <> 0):
                                begin
                                    recAmzMktPlace.TestField("Advertising G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Advertising G/L Account No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Total Promo (Inc. Tax)"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Total Promo (Exc. Tax)";
                                    recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace."Advertising G/L Account No."));
                                end;
                            (i = 5) and (recAmzSalesLine."Gift Wrap (Exc. Tax)" <> 0):
                                begin
                                    recAmzMktPlace.TestField("Fee Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Fee Account No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap (Inc. Tax)"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap (Exc. Tax)";
                                end;
                            (i = 6) and (recAmzSalesLine."Gift Wrap Promo (Exc. Tax)" <> 0):
                                begin
                                    recAmzMktPlace.TestField("Advertising G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Advertising G/L Account No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then begin
                                        if (Rec."Sales Document Type" = "sales document type"::"Credit Memo") and (Rec."Transaction Type" = Rec."transaction type"::Order) then
                                            recSalesLine."Unit Price" := -recAmzSalesLine."Gift Wrap Promo (inc. Tax)"
                                        else
                                            recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap Promo (inc. Tax)";
                                    end else
                                        if (Rec."Sales Document Type" = "sales document type"::"Credit Memo") and (Rec."Transaction Type" = Rec."transaction type"::Order) then
                                            recSalesLine."Unit Price" := -recAmzSalesLine."Gift Wrap Promo (Exc. Tax)"
                                        else
                                            recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap Promo (Exc. Tax)";
                                    recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace."Advertising G/L Account No."));
                                end;
                            (i = 7) and (recAmzSalesLine."Line Discount Excl. Tax" <> 0):
                                begin
                                    recAmzMktPlace.TestField("Discount G/L Account No.");
                                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                    recSalesLine.Validate("No.", recAmzMktPlace."Discount G/L Account No.");
                                    recSalesLine.Validate(Quantity, 1);
                                    if recSalesHead."Prices Including VAT" then
                                        recSalesLine."Unit Price" := recAmzSalesLine."Line Discount Incl. Tax"
                                    else
                                        recSalesLine."Unit Price" := recAmzSalesLine."Line Discount Excl. Tax";
                                end;
                            else begin
                                if (recAmzSalesLine.Quantity > 0) and ((recAmzSalesLine."Item Price (Exc. Tax)" <> 0) or Rec."Give Away Order") then begin
                                    recSalesLine.Validate(Type, recSalesLine.Type::Item);
                                    recSalesLine.Validate("No.", ItemNo);
                                    recSalesLine.Validate(Quantity, recAmzSalesLine.Quantity);
                                    IF recSalesHead."Prices Including VAT" THEN
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                    ELSE
                                        recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                end;
                            end;
                        end;

                        if recSalesLine."Unit Price" = 0 then
                            recSalesLine."Zero Unit Price Accepted" := true;
                        if recSalesHead."Document Type" = recSalesHead."document type"::"Credit Memo" then
                            recSalesLine."Return Reason Code" := pAmzCompMap."Return Reason Code for Cr. Mem";

                        recSalesLine."Skip Posting Group Validation" := pSalesHead."Skip Posting Group Validation";
                        if recSalesLine."No." <> '' then begin
                            IF recVatProdPostGrp.GET(recAmzSalesLine."VAT Prod. Posting Group") THEN
                                recSalesLine.Validate("VAT Prod. Posting Group", recAmzSalesLine."VAT Prod. Posting Group")
                            ELSE
                                recSalesLine."VAT Prod. Posting Group" := recAmzSalesLine."VAT Prod. Posting Group";
                            recSalesLine.Insert();
                        end;
                        SumAmountInclVAT += recSalesLine."Amount Including VAT";
                        recSalesLine.SetHideValidationDialog(false);
                    end;
                end;
            until recAmzSalesLine.Next() = 0;

            if (Abs(SumAmountInclVAT - Rec."Amount Including VAT") > 0) and
               (Abs(SumAmountInclVAT - Rec."Amount Including VAT") <= recAmzMktPlace."Accepted Rounding")
            then begin
                LineNo += 10000;
                Clear(recSalesLine);
                recSalesLine.Init();
                recSalesLine.SetHideValidationDialog(true);
                recSalesLine.Validate("Document Type", pSalesHead."Document Type");
                recSalesLine.Validate("Document No.", pSalesHead."No.");
                recSalesLine.Validate("Line No.", LineNo);
                recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                recSalesLine.Validate("No.", recAmzMktPlace.Roundings);
                recSalesLine.Validate(Quantity, 1);
                recSalesLine.Validate("Unit Price", Rec."Amount Including VAT" - SumAmountInclVAT);
                recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace.Roundings));
                recSalesLine.Insert(true);
            end;
        end;
    end;

    procedure TransferEComLineToSalesLine(pEcomHead: Record "eCommerce Order Header"; pEcomLine: Record "eCommerce Order Line"; pSalesHead: Record "Sales Header"; pEcomMktPlace: Record "eCommerce Market Place"; pSumAmountInclVAT: Decimal): Boolean
    var
        recVatProdPostGrp: Record "VAT Product Posting Group";
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        recSalesLine: Record "Sales Line";
        ItemNo: Code[50];
        i: Integer;
        lText001: Label 'Item No. %1 does not exists anymore', Comment = '%1 = Item No.';
    begin
        // The previous procedure was linked to sales invoice, and could not be used here. This procedure is created so it can be used by both order and invoice.
        pEcomMktPlace.TestField("Accepted Rounding");
        pEcomMktPlace.TestField(Roundings);

        if (pEcomMktPlace."Code for Shipping Fee" = '') or
           (pEcomLine."Item No." <> pEcomMktPlace."Code for Shipping Fee")
        then begin
            ItemNo := '';
            if StrLen(pEcomLine."Item No.") > MaxStrLen(recItem."No.") then begin
                recItemIdent.SetRange(ExtendedCodeZX, pEcomLine."Item No.");
                if not recItemIdent.FindFirst() then
                    Error(lText001, pEcomLine."Item No.");
                ItemNo := recItemIdent."Item No.";
            end else
                if not recItem.Get(pEcomLine."Item No.") then begin
                    recItemIdent.SetRange(ExtendedCodeZX, pEcomLine."Item No.");
                    if recItemIdent.FindFirst() then
                        ItemNo := recItemIdent."Item No.";
                end else
                    ItemNo := recItem."No.";
        end;

        for i := 1 to 7 do begin
            if (i = 1) or
               ((i = 2) and (pEcomLine."Total Shipping (Exc. Tax)" <> 0)) or
               ((i = 3) and (pEcomLine."Shipping Promo (Exc. Tax)" <> 0)) or
               ((i = 4) and (pEcomLine."Total Promo (Exc. Tax)" <> 0)) or
               ((i = 5) and (pEcomLine."Gift Wrap (Exc. Tax)" <> 0)) or
               ((i = 6) and (pEcomLine."Gift Wrap Promo (Exc. Tax)" <> 0)) or
               ((i = 7) and (pEcomLine."Line Discount Excl. Tax" <> 0))
            then begin
                Clear(recSalesLine);
                recSalesLine.Init();
                recSalesLine.SetHideValidationDialog(true);
                recSalesLine.Validate("Document Type", pSalesHead."Document Type");
                recSalesLine.Validate("Document No.", pSalesHead."No.");
                recSalesLine.Validate("Line No.", recSalesLine.GetNextLineNo());

                case true of
                    pEcomLine."Item No." = pEcomMktPlace."Code for Shipping Fee":
                        begin
                            pEcomMktPlace.TestField("Shipping G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Shipping G/L Account No.");
                            recSalesLine.VALIDATE(Description, pEcomLine."Item No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        end;

                    pEcomLine."Item No." = pEcomMktPlace."Code for Compensation Fee":
                        BEGIN
                            pEcomMktPlace.TESTFIELD("Fee Account No.");
                            recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.VALIDATE("No.", pEcomMktPlace."Fee Account No.");
                            recSalesLine.VALIDATE(Description, pEcomLine."Item No.");
                            recSalesLine.VALIDATE(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        END;

                    pEcomLine."Item No." = pEcomMktPlace."Code for Discount":
                        begin
                            pEcomMktPlace.TestField("Discount G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Discount G/L Account No.");
                            recSalesLine.VALIDATE(Description, pEcomLine."Item No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        end;
                    (i = 2) and (pEcomLine."Total Shipping (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Shipping G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Shipping G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Shipping (Inc. Tax)")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Shipping (Exc. Tax)");
                        end;
                    (i = 3) and (pEcomLine."Shipping Promo (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Advertising G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Advertising G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then begin
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Shipping Promo (Inc. Tax)")
                                else
                                    recSalesLine.Validate("Unit Price", pEcomLine."Shipping Promo (Inc. Tax)");
                            end else
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Shipping Promo (Exc. Tax)")
                                else
                                    recSalesLine.Validate("Unit Price", pEcomLine."Shipping Promo (Exc. Tax)");

                            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace."Advertising G/L Account No."));
                        end;
                    (i = 4) and (pEcomLine."Total Promo (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Advertising G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Advertising G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Promo (Inc. Tax)")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Promo (Exc. Tax)");
                            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace."Advertising G/L Account No."));
                        end;
                    (i = 5) and (pEcomLine."Gift Wrap (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Fee Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Fee Account No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap (Inc. Tax)")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap (Exc. Tax)");
                        end;
                    (i = 6) and (pEcomLine."Gift Wrap Promo (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Advertising G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Advertising G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then begin
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Gift Wrap Promo (inc. Tax)")
                                else
                                    recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap Promo (inc. Tax)");
                            end else
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Gift Wrap Promo (Exc. Tax)")
                                else
                                    recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap Promo (Exc. Tax)");
                            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace."Advertising G/L Account No."));
                        end;
                    (i = 7) and (pEcomLine."Line Discount Excl. Tax" <> 0):
                        begin
                            pEcomMktPlace.TestField("Discount G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Discount G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);

                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Line Discount Incl. Tax")
                            else
                                recSalesLine.Validate("Unit Price", pEcomLine."Line Discount Excl. Tax");
                        end;
                    else
                        if (pEcomLine.Quantity > 0) then begin  // "Give Away Order" is added
                            recSalesLine.Validate(Type, recSalesLine.Type::Item);
                            recSalesLine.Validate("No.", ItemNo);
                            recSalesLine.Validate(Quantity, pEcomLine.Quantity);
                            IF recSalesHead."Prices Including VAT" THEN
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            ELSE
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        end;
                end;

                if recSalesLine."Unit Price" = 0 then
                    recSalesLine."Zero Unit Price Accepted" := true;

                if recSalesHead."Document Type" = recSalesHead."document type"::"Credit Memo" then
                    recSalesLine."Return Reason Code" := pEcomMktPlace."Return Reason Code for Cr. Mem";

                recSalesLine."Skip Posting Group Validation" := pSalesHead."Skip Posting Group Validation";
                if recSalesLine."No." <> '' then begin
                    IF recVatProdPostGrp.GET(pEcomLine."VAT Prod. Posting Group") THEN
                        recSalesLine.Validate("VAT Prod. Posting Group", pEcomLine."VAT Prod. Posting Group")
                    ELSE
                        recSalesLine."VAT Prod. Posting Group" := pEcomLine."VAT Prod. Posting Group";

                    if recSalesLine."Document Type" = recSalesLine."Document Type"::Order then begin
                        recSalesLine."Shipment Date" := today;
                        recSalesLine."Shipment Date Confirmed" := true;
                    end;
                    recSalesLine.Insert();
                end;
                pSumAmountInclVAT += recSalesLine."Amount Including VAT";
                recSalesLine.SetHideValidationDialog(false);
            end;
        end;
        exit(true);
    end;

    procedure EndSalesLine(pSalesHead: Record "Sales Header"; pEcomMktPlace: Record "eCommerce Market Place"; pEcomAmountInclVAT: Decimal; pSalesAmountInclVAT: Decimal): Boolean
    var
        recSalesLine: Record "Sales Line";
        NewLineNo: Integer;
    begin
        if (Abs(pSalesAmountInclVAT - pEcomAmountInclVAT) > 0) and
           (Abs(pSalesAmountInclVAT - pEcomAmountInclVAT) <= pEcomMktPlace."Accepted Rounding")
        then begin
            recSalesLine.SetRange("Document Type", pSalesHead."Document Type");
            recSalesLine.SetRange("Document No.", pSalesHead."No.");
            recSalesLine.FindLast();

            NewLineNo := recSalesLine."Line No." + 10000;
            Clear(recSalesLine);
            recSalesLine.Reset();
            recSalesLine.Init();
            recSalesLine.SetHideValidationDialog(true);
            recSalesLine.Validate("Document Type", pSalesHead."Document Type");
            recSalesLine.Validate("Document No.", pSalesHead."No.");
            recSalesLine.Validate("Line No.", NewLineNo);
            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
            recSalesLine.Validate("No.", pEcomMktPlace.Roundings);
            recSalesLine.Validate(Quantity, 1);
            recSalesLine.Validate("Unit Price", pEcomAmountInclVAT - pSalesAmountInclVAT);
            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace.Roundings));
            recSalesLine.Insert(true);
        end;
    end;

    procedure GetDocument(var pSalesHead: Record "Sales Header"): Code[20]
    begin
        pSalesHead := recSalesHead;
    end;

    local procedure GetGlAccDimension(pDimCodeNo: Integer; pGlAcc: Code[20]) rValue: Code[20]
    var
        recDefDim: Record "Default Dimension";
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        recGenLedgSetup.Get();
        recDefDim.SetRange("Table ID", Database::"G/L Account");
        recDefDim.SetRange("No.", pGlAcc);
        case pDimCodeNo of
            2:
                recDefDim.SetRange("Dimension Code", recGenLedgSetup."Global Dimension 2 Code");
        end;
        recDefDim.SetFilter("Value Posting", '>%1', recDefDim."value posting"::" ");
        if recDefDim.FindFirst() then
            rValue := recDefDim."Dimension Value Code";
    end;

    procedure InitCodeunit(NewReplacePostingDate: Boolean; NewPostingDate: Date)
    begin
        ReplacePostingDate := NewReplacePostingDate;
        PostingDate := NewPostingDate;
    end;
}

