Report 50087 "Update eCommerce Currency"
{
    // 001. 14-08-23 ZY-LD 000 - Minor changes to help Vojtech.
    // 002. 13-11-23 ZY-LD 000 - Reverse VAT Bus. Posting Group to calculete a correct VAT.

    Caption = 'Update eCommerce Currency';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("eCommerce Order Archive"; "eCommerce Order Archive")
        {
            DataItemTableView = where(Corrected = const(false));
            CalcFields = "Total (Inc. Tax)", "Amount Including VAT";
            RequestFilterFields = "Marketplace ID", "Transaction Type", "eCommerce Order Id", "Invoice No.", Marked;

            trigger OnAfterGetRecord()
            var
                recAmzOrderHead: Record "eCommerce Order Header";
                recAmzCtryMap: Record "eCommerce Country Mapping";
                BatchPostAmazonOrders: Report "Batch Post eCommerce Orders";
                DocType: Enum "Sales Document Type From";
                DocNo: Code[20];
                SellToCustNo: Code[20];
                DocumentDate: Date;
                OldAmount: Decimal;
            begin
                ZGT.UpdateProgressWindow("eCommerce Order Id", 0, true);

                if ForceCorrection or CopyDocument("eCommerce Order Archive") then begin
                    //IF (("Amazon Order Id" <> '028-0658030-0764339') AND ("Invoice No." <> 'INV-DE-315009725-2022-14919')) AND
                    //   (("Amazon Order Id" <> '402-1258469-7213919') AND ("Invoice No." <> 'N/A'))
                    if "Sales Shipment No." <> '' then begin
                        Clear(recSalesHead);
                        recSalesHead.Reset;
                        recSalesHead.Init;
                        Clear(recSalesHead2);
                        recSalesHead2.Reset;
                        recSalesHead2.Init;

                        if "Transaction Type" = "transaction type"::Order then begin
                            recSalesHead.Validate("Document Type", recSalesHead."document type"::"Credit Memo");
                            recSalesHead2.Validate("Document Type", recSalesHead."document type"::Invoice);
                            recSalesHead2.Validate("Sales Order Type", recSalesHead2."sales order type"::Normal);
                            DocType := DocType::"Posted Invoice";

                            recSalesInvHead.SetRange("External Document No.", "eCommerce Order Id");
                            recSalesInvHead.SetRange("External Invoice No.", "Invoice No.");
                            recSalesInvHead.SetRange("Currency Code", "Currency Code");
                            recSalesInvHead.SetAutocalcFields(Amount);
                            if recSalesInvHead.FindFirst then begin
                                DocNo := recSalesInvHead."No.";
                                SellToCustNo := recSalesInvHead."Sell-to Customer No.";
                                OldAmount := recSalesInvHead.Amount;
                                DocumentDate := recSalesInvHead."Document Date";  // 14-08-23 ZY-LD 001
                            end else begin
                                recSalesInvHead.SetRange("External Invoice No.");
                                if recSalesInvHead.FindFirst then begin
                                    DocNo := recSalesInvHead."No.";
                                    SellToCustNo := recSalesInvHead."Sell-to Customer No.";
                                    OldAmount := recSalesInvHead.Amount;
                                    DocumentDate := recSalesInvHead."Document Date";  // 14-08-23 ZY-LD 001
                                end else
                                    Error('%1', "eCommerce Order Id");
                            end;

                            recSalesLineTmp.DeleteAll;
                            recSalesInvLine.SetRange("Document No.", recSalesInvHead."No.");
                            if recSalesInvLine.FindSet then
                                repeat
                                    recSalesLineTmp.TransferFields(recSalesInvLine);
                                    recSalesLineTmp.Insert;
                                until recSalesInvLine.Next = 0;
                        end else begin
                            recSalesHead.Validate("Document Type", recSalesHead."document type"::Invoice);
                            recSalesHead.Validate("Sales Order Type", recSalesHead."sales order type"::Normal);
                            recSalesHead2.Validate("Document Type", recSalesHead."document type"::"Credit Memo");
                            DocType := DocType::"Posted Credit Memo";

                            recSalesCrMemoHead.SetRange("External Document No.", "eCommerce Order Id");
                            recSalesCrMemoHead.SetRange("External Invoice No.", "Invoice No.");
                            recSalesCrMemoHead.SetRange("Currency Code", "Currency Code");
                            recSalesCrMemoHead.SetAutocalcFields(Amount);
                            if recSalesCrMemoHead.FindFirst then begin
                                DocNo := recSalesCrMemoHead."No.";
                                SellToCustNo := recSalesCrMemoHead."Sell-to Customer No.";
                                OldAmount := recSalesCrMemoHead.Amount;
                                DocumentDate := recSalesCrMemoHead."Document Date";  // 14-08-23 ZY-LD
                            end else begin
                                recSalesCrMemoHead.SetRange("External Invoice No.");
                                if recSalesCrMemoHead.FindFirst then begin
                                    DocNo := recSalesCrMemoHead."No.";
                                    SellToCustNo := recSalesCrMemoHead."Sell-to Customer No.";
                                    OldAmount := recSalesCrMemoHead.Amount;
                                    DocumentDate := recSalesCrMemoHead."Document Date";  // 14-08-23 ZY-LD 001
                                end else
                                    Error('%1', "eCommerce Order Id");
                            end;

                            recSalesLineTmp.DeleteAll;
                            recSalesCrMemoLine.SetRange("Document No.", recSalesCrMemoHead."No.");
                            if recSalesCrMemoLine.FindSet then
                                repeat
                                    recSalesLineTmp.TransferFields(recSalesCrMemoLine);
                                    recSalesLineTmp.Insert;
                                until recSalesCrMemoLine.Next = 0;
                        end;

                        // Sales Head
                        recSalesHead.Validate("Sell-to Customer No.", SellToCustNo);
                        recSalesHead.Insert(true);
                        if "Transaction Type" = "transaction type"::Order then
                            recSalesHead.TransferFields(recSalesInvHead, false)
                        else
                            recSalesHead.TransferFields(recSalesCrMemoHead, false);
                        recSalesHead.Validate("Posting Date", Today);
                        recSalesHead."Skip Posting Group Validation" := true;
                        recSalesHead.Modify(true);

                        // Sales Head 2
                        /*recSalesHead2.VALIDATE("Sell-to Customer No.",SellToCustNo);
                        recSalesHead2.INSERT(TRUE);
                        IF "Transaction Type" = "Transaction Type"::Order THEN
                          recSalesHead2.TRANSFERFIELDS(recSalesInvHead,FALSE)
                        ELSE
                          recSalesHead2.TRANSFERFIELDS(recSalesCrMemoHead,FALSE);
                        recSalesHead2.VALIDATE("Posting Date",TODAY);
                        recSalesHead2.VALIDATE("Currency Code","Currency Code");
                        recSalesHead2."Skip Posting Group Validation" := TRUE;
                        recSalesHead2.MODIFY(TRUE);*/

                        recSalesHead.SetHideValidationDialog(true);
                        Clear(CopySalesDoc);
                        CopySalesDoc.SetSalesHeader(recSalesHead);
                        CopySalesDoc.SetParameters(DocType, DocNo, false, false);
                        CopySalesDoc.UseRequestPage(false);
                        Commit;
                        CopySalesDoc.RunModal;
                        if recSalesHead."Document Type" = recSalesHead."document type"::Invoice then begin
                            recSalesHead."Posting Description" := StrSubstNo('Invoice %1', recSalesHead."No.");
                            recSalesHead.Validate("Applies-to Doc. Type", recSalesHead."applies-to doc. type"::"Credit Memo");
                        end else begin
                            recSalesHead."Posting Description" := StrSubstNo('Credit Memo %1', recSalesHead."No.");
                            recSalesHead.Validate("Applies-to Doc. Type", recSalesHead."applies-to doc. type"::Invoice);
                        end;
                        recSalesHead.Validate("Applies-to Doc. No.", DocNo);
                        recSalesHead.Correction := MarkSalesDocAsCorrection;
                        recSalesHead."Transaction Type" := '21';
                        recSalesHead."Reason Code" := 'AMZ-CORR R';
                        recSalesHead.VALIDATE("Document Date", DocumentDate);  // 14-08-23 ZY-LD 001
                        recSalesHead."Applies-to Doc. No." := '';  // 14-08-23 ZY-LD 001
                        recSalesHead.Modify;

                        recSalesLine.SetRange("Document Type", recSalesHead."Document Type");
                        recSalesLine.SetRange("Document No.", recSalesHead."No.");
                        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                        if recSalesLine.FindSet then
                            repeat
                                recSalesLine.SetHideValidationDialog(true);

                                recSalesLineTmp.Get(0, DocNo, recSalesLine."Line No." - 10000);
                                recSalesLine.Validate("Unit Price", recSalesLineTmp."Unit Price");
                                if "Tax Calculation Reason Code" = "tax calculation reason code"::"Not Taxable" then
                                    recSalesLine.Validate("VAT Prod. Posting Group", '0')
                                else
                                    recSalesLine.Validate("VAT Prod. Posting Group", recSalesLineTmp."VAT Prod. Posting Group");
                                recSalesLine."Skip Posting Group Validation" := true;
                                IF recSalesHead."Document Type" = recSalesHead."Document Type"::"Credit Memo" THEN  // 14-08-23 ZY-LD 001
                                    recSalesLine.VALIDATE("Return Reason Code", '11');  // 14-08-23 ZY-LD 001
                                recSalesLine.Modify(true);
                            until recSalesLine.Next = 0;

                        recSalesHead.CalcFields(Amount);
                        if recSalesHead.Amount <> OldAmount then begin
                            Commit;
                            Error('There is a difference in amount on %1.', "eCommerce Order Id");
                        end;

                        /*CLEAR(CopySalesDoc2);
                        CopySalesDoc2.SetSalesHeader(recSalesHead2);
                        CopySalesDoc2.InitializeRequest(DocType,DocNo,FALSE,TRUE);
                        CopySalesDoc2.USEREQUESTPAGE(FALSE);
                        COMMIT;
                        CopySalesDoc2.RUNMODAL;

                        recSalesLine2.SETRANGE("Document Type",recSalesHead2."Document Type");
                        recSalesLine2.SETRANGE("Document No.",recSalesHead2."No.");
                        recSalesLine2.SETRANGE(Type,recSalesLine2.Type::Item);
                        IF recSalesLine2.FINDSET THEN
                          REPEAT
                            recSalesLine2.SetHideValidationDialog(TRUE);

                            recSalesLineTmp.GET(0,DocNo,recSalesLine2."Line No." - 10000);
                            recSalesLine2.VALIDATE("Unit Price",recSalesLineTmp."Unit Price");
                            recSalesLine2.VALIDATE("VAT Prod. Posting Group",recSalesLineTmp."VAT Prod. Posting Group");
                            recSalesLine2."Skip Posting Group Validation" := TRUE;
                            recSalesLine2.MODIFY(TRUE);
                          UNTIL recSalesLine2.NEXT = 0;*/
                    end;

                    "eCommerce Order Archive".RestoreecommerceOrder(0, MarkAmzOrderAsCorrection, "eCommerce Order Archive"."Transaction Type");
                    //>> 13-11-23 ZY-LD 002
                    recAmzOrderHead.GET("ecommerce Order Archive"."Transaction Type", "ecommerce Order Archive"."ecommerce Order Id", "ecommerce Order Archive"."Invoice No.");
                    IF SetAltBusPostGroup THEN BEGIN
                        IF recAmzOrderHead."Tax Address Role" = recAmzOrderHead."Tax Address Role"::"Ship-from" THEN
                            recAmzCtryMap.GET(recAmzOrderHead."Customer No.", recAmzOrderHead."Ship To Country")
                        ELSE
                            recAmzCtryMap.GET(recAmzOrderHead."Customer No.", recAmzOrderHead."Ship From Country");
                        recAmzOrderHead.VALIDATE("Alt. VAT Bus. Posting Group", recAmzCtryMap."VAT Bus. Posting Group");
                    END;

                    recAmzOrderHead.VALIDATE("Prices Including VAT", PricesIncludingVAT);
                    recAmzOrderHead.MODIFY(TRUE);
                    //<< 13-11-23 ZY-LD 002
                    Commit;
                    //>> 14-08-23 ZY-LD 001

                    CLEAR(BatchPostAmazonOrders);
                    BatchPostAmazonOrders.InitReport(FALSE, TODAY, TRUE, FALSE);
                    recAmzOrderHead.SETRANGE("ecommerce Order Id", "ecommerce Order Id");
                    BatchPostAmazonOrders.SETTABLEVIEW(recAmzOrderHead);
                    BatchPostAmazonOrders.USEREQUESTPAGE(FALSE);
                    BatchPostAmazonOrders.RUNMODAL;
                    //<< 14-08-23 ZY-LD 001
                end;

            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
                SI.SetHideSalesDialog(false);
            end;

            trigger OnPreDataItem()
            begin
                IF "ecommerce Order Archive".GETFILTER(Marked) = '' THEN
                    IF "ecommerce Order Archive".COUNT > 1 THEN
                        ERROR('You can only run one order at a time.');

                SI.SetHideSalesDialog(true);
                ZGT.OpenProgressWindow('', Count());
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(MarkSalesDocAsCorrection; MarkSalesDocAsCorrection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Mark Sales Document as Correction';
                    }
                    field(MarkAmzOrderAsCorrection; MarkAmzOrderAsCorrection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Mark Amazon Order as Correction';
                    }
                    field(ForceCorrection; ForceCorrection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Force Correction';
                    }
                    field(SetAltBusPostGroup; SetAltBusPostGroup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reverse VAT Bus. Posting Group';
                    }
                    field(PricesIncludingVAT; PricesIncludingVAT)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prices Including VAT';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recSalesHead: Record "Sales Header";
        recSalesHead2: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesLine2: Record "Sales Line";
        recSalesLineTmp: Record "Sales Line" temporary;
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recSalesCrMemoLine: Record "Sales Cr.Memo Line";
        CopySalesDoc: Report "Copy Sales Document";
        CopySalesDoc2: Report "Copy Sales Document";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        MarkSalesDocAsCorrection: Boolean;
        MarkAmzOrderAsCorrection: Boolean;
        ForceCorrection: Boolean;
        SetAltBusPostGroup: Boolean;
        PricesIncludingVAT: Boolean;


    local procedure CopyDocument(recAmzOrderArch: Record "eCommerce Order Archive") rValue: Boolean
    var
        lSalesInvHead: Record "Sales Invoice Header";
        lSalesCrMemoHead: Record "Sales Cr.Memo Header";
        lAmzOrdLineArch: Record "eCommerce Order Line Archive";
        BusPostGrp: Code[10];
        DocAmount: Decimal;
    begin
        begin
            if recAmzOrderArch."Amount Including VAT" <> 0 then begin
                if recAmzOrderArch."Transaction Type" = recAmzOrderArch."transaction type"::Order then begin
                    lSalesInvHead.SetCurrentkey("External Document No.");
                    lSalesInvHead.SetRange("External Document No.", recAmzOrderArch."eCommerce Order Id");
                    lSalesInvHead.SetRange("External Invoice No.", recAmzOrderArch."Invoice No.");
                    lSalesInvHead.SetRange("Currency Code", recAmzOrderArch."Currency Code");
                    lSalesInvHead.SetAutocalcFields("Amount Including VAT");
                    if lSalesInvHead.FindLast then begin
                        DocAmount := lSalesInvHead."Amount Including VAT";
                        BusPostGrp := lSalesInvHead."Gen. Bus. Posting Group";
                    END;
                end else begin
                    lSalesCrMemoHead.SetCurrentkey("External Document No.");
                    lSalesCrMemoHead.SetRange("External Document No.", recAmzOrderArch."eCommerce Order Id");
                    lSalesCrMemoHead.SetRange("External Invoice No.", recAmzOrderArch."Invoice No.");
                    lSalesCrMemoHead.SetRange("Currency Code", recAmzOrderArch."Currency Code");
                    lSalesCrMemoHead.SetAutocalcFields("Amount Including VAT");
                    if lSalesCrMemoHead.FindLast then begin
                        DocAmount := lSalesCrMemoHead."Amount Including VAT";
                        BusPostGrp := lSalesCrMemoHead."Gen. Bus. Posting Group";
                    END;
                end;

                IF (BusPostGrp = 'E-COM N-EU') AND
                   (recAmzOrderArch."Ship-from Country" <> recAmzOrderArch."Ship-to Country")
                THEN
                    rValue := TRUE;

                /*if recAmzOrderArch."Total (Inc. Tax)" <> DocAmount then
                    rValue := true
                else begin
                    lAmzOrdLineArch.SetRange("eCommerce Order Id", recAmzOrderArch."eCommerce Order Id");
                    lAmzOrdLineArch.SetRange("Invoice No.", recAmzOrderArch."Invoice No.");
                    lAmzOrdLineArch.SetFilter("Total Shipping (Inc. Tax)", '<>0');
                    if lAmzOrdLineArch.FindFirst then
                        rValue := true
                    else begin
                        lAmzOrdLineArch.SetRange("Total Shipping (Inc. Tax)");
                        lAmzOrdLineArch.SetFilter("Total Promo (Inc. Tax)", '<>0');
                        if lAmzOrdLineArch.FindFirst then
                            rValue := true
                        else begin
                            lAmzOrdLineArch.SetRange("Total Promo (Inc. Tax)");
                            lAmzOrdLineArch.SetFilter("Gift Wrap (Inc. Tax)", '<>0');
                            if lAmzOrdLineArch.FindFirst then
                                rValue := true
                            else begin
                                lAmzOrdLineArch.SetRange("Gift Wrap (Inc. Tax)");
                                lAmzOrdLineArch.SetFilter("Gift Wrap Promo (Inc. Tax)", '<>0');
                                if lAmzOrdLineArch.FindFirst then
                                    rValue := true
                                else begin
                                    lAmzOrdLineArch.SetRange("Gift Wrap Promo (Inc. Tax)");
                                    lAmzOrdLineArch.SetFilter("Shipping Promo (Inc. Tax)", '<>0');
                                    if lAmzOrdLineArch.FindFirst then
                                        rValue := true
                                end;
                            end;
                        end;
                    end;
                end;*/
            end;
        end;
    end;

    procedure ReportInit(NewMarkSalesDocAsCorrection: Boolean; NewMarkAmzOrderAsCorrection: Boolean; NewForceCorrection: Boolean; NewSetAltBusPostGroup: Boolean; NewPriceIncludingVat: Boolean);
    BEGIN
        MarkSalesDocAsCorrection := NewMarkSalesDocAsCorrection;
        MarkAmzOrderAsCorrection := NewMarkAmzOrderAsCorrection;
        ForceCorrection := NewForceCorrection;
        SetAltBusPostGroup := NewSetAltBusPostGroup;
        PricesIncludingVAT := NewPriceIncludingVat;
    END;

}
