codeunit 50011 "eCommerce-Order to Invoice"
{
    TableNo = "eCommerce Order Header";

    // 001. 15-06-22 ZY-LD 000 - It happens that the price is zero, and we donÃ¯t want the posting to stop.
    // 002. 29-06-22 ZY-LD 000 - Setup Transaction Type.
    // 003. 18-08-22 ZY-LD 000 - "SHIPPING FEE"
    // 004. 02-09-22 ZY-LD 000 - "Currency Code" has been moved down, because "Currency Code" can be set to customer value on validating location code.
    // 005. 04-01-23 ZY-LD 000 - Amazon credit "Promo Rebate" as "Transaction Type" Order, so we need to use the amount instead.
    // 006. 02-03-23 ZY-LD 000 - Skip Verification.
    // 007. 24-05-23 ZY-LD 000 - Give Away Order.
    // 008. 16-06-23 ZY-LD 000 - Line Discount is added.
    // 009. 15-08-23 ZY-LD 000 - Force Creation.
    // 010. 11-10-23 ZY-LD 010 - "Document Date" is set to the "Order Date".
    // 012. 30-11-23 ZY-LD 000 - Compensation Fee.
    // 013. 18-04-24 ZY-LD 000 - Not all price types had "Price Include VAT".
    // 014. 17-07-24 ZY-LD 000 - Zyxel Store ship from VCK.
    // 015. 13-09-24 ZY-LD 000 - Using new sales order type.

    trigger OnRun()
    var
        recAmzCompMap: Record "eCommerce Market Place";
    begin
        Rec.TestField("Location Code");
        recAmzCompMap.Get(Rec."Marketplace ID");
        recAmzCompMap.TestField("Return Reason Code for Cr. Mem");
        recAmzCompMap.TestField("Customer No.");
        recAmzCompMap.TestField("Transaction Type - Order");  // 29-06-22 ZY-LD 002
        recAmzCompMap.TestField("Transaction Type - Refund");  // 14-10-22 ZY-LD 002

        SI.SetKeepLocationCode(true);
        recSalesHead.Init();
        recSalesHead.SetHideValidationDialog(true);
        //>> 04-01-23 ZY-LD 005
        /*CASE "Transaction Type" OF
          "Transaction Type"::Order : recSalesHead."Document Type" := recSalesHead."Document Type"::Invoice;
          "Transaction Type"::Refund : recSalesHead."Document Type" := recSalesHead."Document Type"::"Credit Memo";
        END;*/
        recSalesHead."Document Type" := Rec."Sales Document Type";
        //<< 04-01-23 ZY-LD 005
        recSalesHead.Insert(true);

        //recSalesHead."Sales Order Type" := recSalesHead."sales order type"::Normal;  // 13-09-24 ZY-LD 015
        recSalesHead."Sales Order Type" := recSalesHead."sales order type"::eCommerce;  // 13-09-24 ZY-LD 015
        recSalesHead.Validate("Sell-to Customer No.", recAmzCompMap."Customer No.");
        if ReplacePostingDate then
            recSalesHead.Validate("Posting Date", PostingDate);
        recSalesHead.VALIDATE("Document Date", Rec."Order Date");  // 11-10-23 ZY-LD 010
        //recSalesHead.VALIDATE("Currency Code","Currency Code");  // 02-09-22 ZY-LD 004
        recSalesHead.Validate("Salesperson Code", recAmzCompMap."Sales Person Code");
        recSalesHead.Validate("External Document No.", Rec."eCommerce Order Id");
        recSalesHead.Validate("External Invoice No.", Rec."Invoice No.");
        recSalesHead.Validate("Your Reference", Rec."eCommerce Order Id");
        recSalesHead.Validate("Reference 2", Rec."eCommerce Order Id");
        recSalesHead.Validate("Location Code", Rec."Location Code");
        recSalesHead.Validate("Currency Code", Rec."Currency Code");  // 02-09-22 ZY-LD 004
        //>> 13-11-23 ZY-LD 011
        //recSalesHead.VALIDATE("VAT Bus. Posting Group","VAT Bus. Posting Group");
        IF Rec."Alt. VAT Bus. Posting Group" <> '' THEN BEGIN
            recSalesHead.VALIDATE("VAT Bus. Posting Group", Rec."Alt. VAT Bus. Posting Group");
        END ELSE
            recSalesHead.Validate("VAT Bus. Posting Group", Rec."VAT Bus. Posting Group");
        recSalesHead.VALIDATE("Prices Including VAT", Rec."Prices Including VAT");
        //<< 13-11-23 ZY-LD 011        
        recSalesHead."Transport Method" := recAmzCompMap."Transport Method";
        recSalesHead."Requested Delivery Date" := Rec."Requested Delivery Date";
        recSalesHead."Shipment Method Code" := recAmzCompMap."Shipment Method";
        recSalesHead."Shipping Agent Code" := recAmzCompMap."Shipping Agent Code";
        recSalesHead."Shipment Date" := Today;
        case Rec."Transaction Type" of
            Rec."transaction type"::Order:
                recSalesHead.Validate("Transaction Type", recAmzCompMap."Transaction Type - Order");  // 29-06-22 ZY-LD 002
            Rec."transaction type"::Refund:
                recSalesHead.Validate("Transaction Type", recAmzCompMap."Transaction Type - Refund");  // 14-10-22 ZY-LD 002
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
        if (ZGT.IsRhq and ZGT.IsZNetCompany) or  // ZNet DK
           (ZGT.IsZComCompany and ZGT.CompanyNameIs(11))  // ZyND DE
        then
            IF Rec."Alt. VAT Reg. No. Zyxel" <> '' THEN
                recSalesHead."VAT Registration No. Zyxel" := Rec."Alt. VAT Reg. No. Zyxel"
            ELSE
                recSalesHead."VAT Registration No. Zyxel" := Rec."VAT Registration No. Zyxel";

        recSalesHead.Ship := true;
        recSalesHead.Invoice := true;
        recSalesHead."eCommerce Order" := true;
        recSalesHead."Skip Posting Group Validation" := true;
        //recSalesHead."Skip Verify on Inventory" := TRUE;  // 02-03-23 ZY-LD 006
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
        recVatProdPostGrp: Record "VAT Product Posting Group";  // 15-08-23 ZY-LD 009
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        recSalesLine: Record "Sales Line";
        ItemNo: Code[50];
        LineNo: Integer;
        lText006: Label 'Item No. %1 does not exists anymore', Comment = '%1 = Item No.';
        i: Integer;
        SumAmountInclVAT: Decimal;
    begin
        with Rec do begin
            recAmzMktPlace.Get("Marketplace ID");  // 18-08-22 ZY-LD 003
            recAmzMktPlace.TestField("Accepted Rounding");
            recAmzMktPlace.TestField(Roundings);

            recAmzSalesLine.SetRange("Transaction Type", "Transaction Type");
            recAmzSalesLine.SetRange("eCommerce Order Id", "eCommerce Order Id");
            recAmzSalesLine.SetRange("Invoice No.", "Invoice No.");
            if recAmzSalesLine.FindSet() then begin
                repeat
                    //>> 18-08-22 ZY-LD 003
                    if (recAmzMktPlace."Code for Shipping Fee" = '') or
                       (recAmzSalesLine."Item No." <> recAmzMktPlace."Code for Shipping Fee")
                    then begin  //<< 18-08-22 ZY-LD 003
                        ItemNo := '';
                        if StrLen(recAmzSalesLine."Item No.") > MaxStrLen(recItem."No.") then begin
                            recItemIdent.SetRange(ExtendedCodeZX, recAmzSalesLine."Item No.");
                            if not recItemIdent.FindFirst() then
                                Error(lText006, recAmzSalesLine."Item No.");
                            ItemNo := recItemIdent."Item No.";
                        end else begin
                            if not recItem.Get(recAmzSalesLine."Item No.") then begin
                                recItemIdent.SetRange(ExtendedCodeZX, recAmzSalesLine."Item No.");
                                if recItemIdent.FindFirst() then
                                    ItemNo := recItemIdent."Item No.";
                            end else
                                ItemNo := recItem."No.";
                        end;
                    end;

                    for i := 1 to 7 do begin
                        if (i = 1) or
                           ((i = 2) and (recAmzSalesLine."Total Shipping (Exc. Tax)" <> 0)) or
                           ((i = 3) and (recAmzSalesLine."Shipping Promo (Exc. Tax)" <> 0)) or
                           ((i = 4) and (recAmzSalesLine."Total Promo (Exc. Tax)" <> 0)) or
                           ((i = 5) and (recAmzSalesLine."Gift Wrap (Exc. Tax)" <> 0)) or
                           ((i = 6) and (recAmzSalesLine."Gift Wrap Promo (Exc. Tax)" <> 0)) or
                           ((i = 7) and (recAmzSalesLine."Line Discount Excl. Tax" <> 0))  // 16-06-23 ZY-LD 008
                        then begin
                            LineNo += 10000;
                            Clear(recSalesLine);
                            recSalesLine.Init();
                            recSalesLine.SetHideValidationDialog(true);
                            recSalesLine.Validate("Document Type", pSalesHead."Document Type");
                            recSalesLine.Validate("Document No.", pSalesHead."No.");
                            recSalesLine.Validate("Line No.", LineNo);
                            //>> 18-08-22 ZY-LD 003
                            case true of
                                recAmzSalesLine."Item No." = recAmzMktPlace."Code for Shipping Fee":
                                    begin
                                        recAmzMktPlace.TestField("Shipping G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Shipping G/L Account No.");
                                        recSalesLine.VALIDATE(Description, recAmzSalesLine."Item No.");  // 30-11-23 ZY-LD 012
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                    end;
                                //>> 30-11-23 ZY-LD 012
                                recAmzSalesLine."Item No." = recAmzMktPlace."Code for Compensation Fee":
                                    BEGIN
                                        recAmzMktPlace.TESTFIELD("Fee Account No.");
                                        recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.VALIDATE("No.", recAmzMktPlace."Fee Account No.");
                                        recSalesLine.VALIDATE(Description, recAmzSalesLine."Item No.");
                                        recSalesLine.VALIDATE(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                    END;
                                //<< 30-11-23 ZY-LD 012
                                recAmzSalesLine."Item No." = recAmzMktPlace."Code for Discount":
                                    begin
                                        recAmzMktPlace.TestField("Discount G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Discount G/L Account No.");
                                        recSalesLine.VALIDATE(Description, recAmzSalesLine."Item No.");  // 30-11-23 ZY-LD 012
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Inc. Tax)"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Item Price (Exc. Tax)";
                                    end;
                                (i = 2) and (recAmzSalesLine."Total Shipping (Exc. Tax)" <> 0):
                                    begin
                                        recAmzMktPlace.TestField("Shipping G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Shipping G/L Account No.");
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Total Shipping (Inc. Tax)"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Total Shipping (Exc. Tax)";
                                    end;
                                (i = 3) and (recAmzSalesLine."Shipping Promo (Exc. Tax)" <> 0):
                                    begin
                                        recAmzMktPlace.TestField("Advertising G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Advertising G/L Account No.");
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 05-01-23 ZY-LD 005
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then begin
                                            if ("Sales Document Type" = "sales document type"::"Credit Memo") and ("Transaction Type" = "transaction type"::Order) then
                                                recSalesLine."Unit Price" := -recAmzSalesLine."Shipping Promo (Inc. Tax)"
                                            else  //<< 05-01-23 ZY-LD 005
                                                recSalesLine."Unit Price" := recAmzSalesLine."Shipping Promo (Inc. Tax)";
                                        end else  //<< 18-04-24 ZY-LD 013 
                                            if ("Sales Document Type" = "sales document type"::"Credit Memo") and ("Transaction Type" = "transaction type"::Order) then
                                                recSalesLine."Unit Price" := -recAmzSalesLine."Shipping Promo (Exc. Tax)"
                                            else  //<< 05-01-23 ZY-LD 005
                                                recSalesLine."Unit Price" := recAmzSalesLine."Shipping Promo (Exc. Tax)";

                                        recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace."Advertising G/L Account No."));
                                    end;
                                (i = 4) and (recAmzSalesLine."Total Promo (Exc. Tax)" <> 0):
                                    begin
                                        recAmzMktPlace.TestField("Advertising G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Advertising G/L Account No.");
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Total Promo (Inc. Tax)"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Total Promo (Exc. Tax)";
                                        recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace."Advertising G/L Account No."));
                                    end;
                                (i = 5) and (recAmzSalesLine."Gift Wrap (Exc. Tax)" <> 0):
                                    begin
                                        recAmzMktPlace.TestField("Fee Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Fee Account No.");
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap (Inc. Tax)"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap (Exc. Tax)";
                                    end;
                                (i = 6) and (recAmzSalesLine."Gift Wrap Promo (Exc. Tax)" <> 0):
                                    begin
                                        recAmzMktPlace.TestField("Advertising G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Advertising G/L Account No.");
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then begin
                                            //>> 05-01-23 ZY-LD 005
                                            if ("Sales Document Type" = "sales document type"::"Credit Memo") and ("Transaction Type" = "transaction type"::Order) then
                                                recSalesLine."Unit Price" := -recAmzSalesLine."Gift Wrap Promo (inc. Tax)"
                                            else  //<< 05-01-23 ZY-LD 005
                                                recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap Promo (inc. Tax)";
                                        end else
                                            //>> 05-01-23 ZY-LD 005
                                            if ("Sales Document Type" = "sales document type"::"Credit Memo") and ("Transaction Type" = "transaction type"::Order) then
                                                recSalesLine."Unit Price" := -recAmzSalesLine."Gift Wrap Promo (Exc. Tax)"
                                            else  //<< 05-01-23 ZY-LD 005
                                                recSalesLine."Unit Price" := recAmzSalesLine."Gift Wrap Promo (Exc. Tax)";
                                        recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace."Advertising G/L Account No."));
                                    end;
                                //>> 16-06-23 ZY-LD 008
                                (i = 7) and (recAmzSalesLine."Line Discount Excl. Tax" <> 0):
                                    begin
                                        recAmzMktPlace.TestField("Discount G/L Account No.");
                                        recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                                        recSalesLine.Validate("No.", recAmzMktPlace."Discount G/L Account No.");
                                        recSalesLine.Validate(Quantity, 1);
                                        //>> 18-04-24 ZY-LD 013 
                                        if recSalesHead."Prices Including VAT" then
                                            recSalesLine."Unit Price" := recAmzSalesLine."Line Discount Incl. Tax"
                                        else  //<< 18-04-24 ZY-LD 013
                                            recSalesLine."Unit Price" := recAmzSalesLine."Line Discount Excl. Tax";
                                    end;
                                //<< 16-06-23 ZY-LD 008
                                else begin  //<< 18-08-22 ZY-LD 003
                                    if (recAmzSalesLine.Quantity > 0) and ((recAmzSalesLine."Item Price (Exc. Tax)" <> 0) or "Give Away Order") then begin  // 24-05-23 ZY-LD 007 - "Give Away Order" is added
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

                            //>> 15-06-22 ZY-LD 001
                            if recSalesLine."Unit Price" = 0 then
                                recSalesLine."Zero Unit Price Accepted" := true;
                            //<< 15-06-22 ZY-LD 001
                            if recSalesHead."Document Type" = recSalesHead."document type"::"Credit Memo" then
                                recSalesLine."Return Reason Code" := pAmzCompMap."Return Reason Code for Cr. Mem";

                            recSalesLine."Skip Posting Group Validation" := pSalesHead."Skip Posting Group Validation";
                            if recSalesLine."No." <> '' then begin
                                IF recVatProdPostGrp.GET(recAmzSalesLine."VAT Prod. Posting Group") THEN  // 15-08-23 ZY-LD 009
                                    recSalesLine.Validate("VAT Prod. Posting Group", recAmzSalesLine."VAT Prod. Posting Group")
                                ELSE
                                    recSalesLine."VAT Prod. Posting Group" := recAmzSalesLine."VAT Prod. Posting Group";  // 15-08-23 ZY-LD 009
                                recSalesLine.Insert();
                            end;
                            SumAmountInclVAT += recSalesLine."Amount Including VAT";
                            recSalesLine.SetHideValidationDialog(false);
                        end;
                    end;
                until recAmzSalesLine.Next() = 0;

                /*pSalesHead.CALCFIELDS("Amount Including VAT");
                IF (ABS(pSalesHead."Amount Including VAT" - "Amount Including VAT") > 0) AND
                   (ABS(pSalesHead."Amount Including VAT" - "Amount Including VAT") <= recAmzMktPlace."Accepted Rounding")*/
                if (Abs(SumAmountInclVAT - "Amount Including VAT") > 0) and
                   (Abs(SumAmountInclVAT - "Amount Including VAT") <= recAmzMktPlace."Accepted Rounding")
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
                    recSalesLine.Validate("Unit Price", "Amount Including VAT" - SumAmountInclVAT);
                    recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, recAmzMktPlace.Roundings));
                    recSalesLine.Insert(true);
                end;
            end;
        end;
    end;

    procedure TransferEComLineToSalesLine(pEcomHead: Record "eCommerce Order Header"; pEcomLine: Record "eCommerce Order Line"; pSalesHead: Record "Sales Header"; pEcomMktPlace: Record "eCommerce Market Place"; pSumAmountInclVAT: Decimal): Boolean
    var
        recVatProdPostGrp: Record "VAT Product Posting Group";  // 15-08-23 ZY-LD 009
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        recSalesLine: Record "Sales Line";
        ItemNo: Code[50];
        i: Integer;
        lText001: Label 'Item No. %1 does not exists anymore', Comment = '%1 = Item No.';
    begin
        //>> 17-07-24 ZY-LD 014
        // The previous procedure was linked to sales invoice, and could not be used here. This procedure is created so it can be used by both order and invoice.
        pEcomMktPlace.TestField("Accepted Rounding");
        pEcomMktPlace.TestField(Roundings);

        if (pEcomMktPlace."Code for Shipping Fee" = '') or
           (pEcomLine."Item No." <> pEcomMktPlace."Code for Shipping Fee")
        then begin  //<< 18-08-22 ZY-LD 003
            ItemNo := '';
            if StrLen(pEcomLine."Item No.") > MaxStrLen(recItem."No.") then begin
                recItemIdent.SetRange(ExtendedCodeZX, pEcomLine."Item No.");
                if not recItemIdent.FindFirst() then
                    Error(lText001, pEcomLine."Item No.");
                ItemNo := recItemIdent."Item No.";
            end else begin
                if not recItem.Get(pEcomLine."Item No.") then begin
                    recItemIdent.SetRange(ExtendedCodeZX, pEcomLine."Item No.");
                    if recItemIdent.FindFirst() then
                        ItemNo := recItemIdent."Item No.";
                end else
                    ItemNo := recItem."No.";
            end;
        end;

        for i := 1 to 7 do begin
            if (i = 1) or
               ((i = 2) and (pEcomLine."Total Shipping (Exc. Tax)" <> 0)) or
               ((i = 3) and (pEcomLine."Shipping Promo (Exc. Tax)" <> 0)) or
               ((i = 4) and (pEcomLine."Total Promo (Exc. Tax)" <> 0)) or
               ((i = 5) and (pEcomLine."Gift Wrap (Exc. Tax)" <> 0)) or
               ((i = 6) and (pEcomLine."Gift Wrap Promo (Exc. Tax)" <> 0)) or
               ((i = 7) and (pEcomLine."Line Discount Excl. Tax" <> 0))  // 16-06-23 ZY-LD 008
            then begin
                Clear(recSalesLine);
                recSalesLine.Init();
                recSalesLine.SetHideValidationDialog(true);
                recSalesLine.Validate("Document Type", pSalesHead."Document Type");
                recSalesLine.Validate("Document No.", pSalesHead."No.");
                recSalesLine.Validate("Line No.", recSalesLine.GetNextLineNo);
                //>> 18-08-22 ZY-LD 003
                case true of
                    pEcomLine."Item No." = pEcomMktPlace."Code for Shipping Fee":
                        begin
                            pEcomMktPlace.TestField("Shipping G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Shipping G/L Account No.");
                            recSalesLine.VALIDATE(Description, pEcomLine."Item No.");  // 30-11-23 ZY-LD 012
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        end;
                    //>> 30-11-23 ZY-LD 012
                    pEcomLine."Item No." = pEcomMktPlace."Code for Compensation Fee":
                        BEGIN
                            pEcomMktPlace.TESTFIELD("Fee Account No.");
                            recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.VALIDATE("No.", pEcomMktPlace."Fee Account No.");
                            recSalesLine.VALIDATE(Description, pEcomLine."Item No.");
                            recSalesLine.VALIDATE(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        END;
                    //<< 30-11-23 ZY-LD 012
                    pEcomLine."Item No." = pEcomMktPlace."Code for Discount":
                        begin
                            pEcomMktPlace.TestField("Discount G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Discount G/L Account No.");
                            recSalesLine.VALIDATE(Description, pEcomLine."Item No.");  // 30-11-23 ZY-LD 012
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        end;
                    (i = 2) and (pEcomLine."Total Shipping (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Shipping G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Shipping G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Shipping (Inc. Tax)")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Shipping (Exc. Tax)");
                        end;
                    (i = 3) and (pEcomLine."Shipping Promo (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Advertising G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Advertising G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);
                            //>> 05-01-23 ZY-LD 005
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then begin
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Shipping Promo (Inc. Tax)")
                                else  //<< 05-01-23 ZY-LD 005
                                    recSalesLine.Validate("Unit Price", pEcomLine."Shipping Promo (Inc. Tax)");
                            end else  //<< 18-04-24 ZY-LD 013 
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Shipping Promo (Exc. Tax)")
                                else  //<< 05-01-23 ZY-LD 005
                                    recSalesLine.Validate("Unit Price", pEcomLine."Shipping Promo (Exc. Tax)");

                            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace."Advertising G/L Account No."));
                        end;
                    (i = 4) and (pEcomLine."Total Promo (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Advertising G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Advertising G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Promo (Inc. Tax)")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Total Promo (Exc. Tax)");
                            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace."Advertising G/L Account No."));
                        end;
                    (i = 5) and (pEcomLine."Gift Wrap (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Fee Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Fee Account No.");
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap (Inc. Tax)")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap (Exc. Tax)");
                        end;
                    (i = 6) and (pEcomLine."Gift Wrap Promo (Exc. Tax)" <> 0):
                        begin
                            pEcomMktPlace.TestField("Advertising G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Advertising G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then begin
                                //>> 05-01-23 ZY-LD 005
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Gift Wrap Promo (inc. Tax)")
                                else  //<< 05-01-23 ZY-LD 005
                                    recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap Promo (inc. Tax)");
                            end else
                                //>> 05-01-23 ZY-LD 005
                                if (pEcomHead."Sales Document Type" = "sales document type"::"Credit Memo") and (pEcomHead."Transaction Type" = pEcomHead."transaction type"::Order) then
                                    recSalesLine.Validate("Unit Price", -pEcomLine."Gift Wrap Promo (Exc. Tax)")
                                else  //<< 05-01-23 ZY-LD 005
                                    recSalesLine.Validate("Unit Price", pEcomLine."Gift Wrap Promo (Exc. Tax)");
                            recSalesLine.Validate("Shortcut Dimension 2 Code", GetGlAccDimension(2, pEcomMktPlace."Advertising G/L Account No."));
                        end;
                    //>> 16-06-23 ZY-LD 008
                    (i = 7) and (pEcomLine."Line Discount Excl. Tax" <> 0):
                        begin
                            pEcomMktPlace.TestField("Discount G/L Account No.");
                            recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                            recSalesLine.Validate("No.", pEcomMktPlace."Discount G/L Account No.");
                            recSalesLine.Validate(Quantity, 1);
                            //>> 18-04-24 ZY-LD 013 
                            if recSalesHead."Prices Including VAT" then
                                recSalesLine.Validate("Unit Price", pEcomLine."Line Discount Incl. Tax")
                            else  //<< 18-04-24 ZY-LD 013
                                recSalesLine.Validate("Unit Price", pEcomLine."Line Discount Excl. Tax");
                        end;
                    //<< 16-06-23 ZY-LD 008
                    else begin  //<< 18-08-22 ZY-LD 003
                        if (pEcomLine.Quantity > 0) then begin  // 24-05-23 ZY-LD 007 - "Give Away Order" is added
                            recSalesLine.Validate(Type, recSalesLine.Type::Item);
                            recSalesLine.Validate("No.", ItemNo);
                            recSalesLine.Validate(Quantity, pEcomLine.Quantity);
                            IF recSalesHead."Prices Including VAT" THEN
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Inc. Tax)")
                            ELSE
                                recSalesLine.Validate("Unit Price", pEcomLine."Item Price (Exc. Tax)");
                        end;
                    end;
                end;

                //>> 15-06-22 ZY-LD 001
                if recSalesLine."Unit Price" = 0 then
                    recSalesLine."Zero Unit Price Accepted" := true;
                //<< 15-06-22 ZY-LD 001
                if recSalesHead."Document Type" = recSalesHead."document type"::"Credit Memo" then
                    recSalesLine."Return Reason Code" := pEcomMktPlace."Return Reason Code for Cr. Mem";

                recSalesLine."Skip Posting Group Validation" := pSalesHead."Skip Posting Group Validation";
                if recSalesLine."No." <> '' then begin
                    IF recVatProdPostGrp.GET(pEcomLine."VAT Prod. Posting Group") THEN  // 15-08-23 ZY-LD 009
                        recSalesLine.Validate("VAT Prod. Posting Group", pEcomLine."VAT Prod. Posting Group")
                    ELSE
                        recSalesLine."VAT Prod. Posting Group" := pEcomLine."VAT Prod. Posting Group";  // 15-08-23 ZY-LD 009

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
        //<< 17-07-24 ZY-LD 014
    end;

    procedure EndSalesLine(pSalesHead: Record "Sales Header"; pEcomMktPlace: Record "eCommerce Market Place"; pEcomAmountInclVAT: Decimal; pSalesAmountInclVAT: Decimal): Boolean
    var
        recSalesLine: Record "Sales Line";
        NewLineNo: Integer;
    begin
        //>> 17-07-24 ZY-LD 014
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
        //<< 17-07-24 ZY-LD 014
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

