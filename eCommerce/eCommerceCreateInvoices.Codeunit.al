codeunit 50066 "eCommerce Create Invoices"
{
    trigger OnRun()
    begin
        RuneCommerceSalesOrders('', '');
    end;

    var
        recGeneralLedgerSetup: Record "General Ledger Setup";
        RHQName: Code[20];
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        UseRHQ: Boolean;
        UKCompany: Label 'ZyND UK';
        Window: Dialog;
        Text009: Label 'Calculating Order Totals...\';
        RowCount: Integer;
        RecNo: Integer;
        Error01: Label 'Sales Header %1 not Found in Inercompany. \Cannot Continue...';
        Text012: Label 'Calculating Euro Values...\';
        Text001: Label 'Creating and posting missing orders...\';
        AutoPost: Boolean;
        Text002: Label 'Do you want to automatically post the orders?';
        CreateInSpiteOfError: Boolean;
        Text003: Label '"%1" must not be blank.';

    local procedure RuneCommerceSalesOrders(pOrderID: Code[50]; pInvoiceNo: Code[50])
    begin
        //UpdatePrices;  // 05-12-18 ZY-LD 007 - Price fields on header has become flowfields.
        //UpdatePricesEUR;  // 05-12-18 ZY-LD 007 - The calculation was wrong. Nowbody complained, so it's not needed.
        if ZGT.IsRhq or ZGT.CompanyNameIs(11) then  // 05-12-18 ZY-LD 007 - RHQ or DE
            CheckForInvoices(pOrderID, pInvoiceNo);
    end;

    procedure RunWithConfirm()
    begin
        //AutoPost := CONFIRM(Text002,FALSE);
        AutoPost := false;
        CreateInSpiteOfError := false;
        RuneCommerceSalesOrders('', '');
    end;

    procedure RunCreateInSpiteOfError(pOrderID: Code[50]; pInvoiceNo: Code[50]; pCreateWithError: Boolean)
    begin
        AutoPost := false;
        CreateInSpiteOfError := pCreateWithError;  // 05-12-18 ZY-LD 007
        RuneCommerceSalesOrders(pOrderID, pInvoiceNo);
    end;

    procedure CheckForInvoices(pOrderID: Code[50]; pInvoiceNo: Code[50])
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        recAmzOrderLine: Record "eCommerce Order Line";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesInvoiceHeader2: Record "Sales Invoice Header";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        recSalesCrMemoHeader2: Record "Sales Cr.Memo Header";
        recSalesHeader: Record "Sales Header";
        recVATPostSetup: Record "VAT Posting Setup";
        CreateDocument: Boolean;
        lText001: Label 'The %1 does not exist. Identification fields and values: %2=''%3'', %4=''%5''.';
    begin
        //>> 05-12-18 ZY-LD 007 not nedded.
        // RHQName := ZyXEL.GetRHQCompanyName;
        // IF CompanyName() = UKCompany THEN UseRHQ :=TRUE;
        // IF UseRHQ THEN receCommerceSalesHeaderBuffer.CHANGECOMPANY(RHQName);
        //<< 05-12-18 ZY-LD 007

        recGeneralLedgerSetup.Get();  // xx
        receCommerceSalesHeaderBuffer.SetRange(Open, true);
        //receCommerceSalesHeaderBuffer.SETRANGE("Sent To Intercompany",FALSE);
        if pOrderID <> '' then
            receCommerceSalesHeaderBuffer.SetRange("eCommerce Order Id", pOrderID);
        if pInvoiceNo <> '' then
            receCommerceSalesHeaderBuffer.SetRange("Invoice No.", pInvoiceNo);
        receCommerceSalesHeaderBuffer.SetAutoCalcFields(
          "Unexpected Item",
          "Total (Inc. Tax)");  // 05-12-18 ZY-LD 005
        if receCommerceSalesHeaderBuffer.FindSet() then begin
            Window.Open(Text001 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
            Window.Update(1, 0);
            RowCount := receCommerceSalesHeaderBuffer.Count();
            RecNo := 0;
            repeat
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                //>> At the moment we don't need this code.
                /*
                IF receCommerceSalesHeaderBuffer."Transaction Type" = receCommerceSalesHeaderBuffer."Transaction Type"::Order THEN BEGIN
                  recSalesHeader.SETRANGE("Document Type",recSalesHeader."Document Type"::Invoice);
                  recSalesHeader.SETRANGE("External Document No.",receCommerceSalesHeaderBuffer."eCommerce Order Id");
                  recSalesInvoiceHeader.SETRANGE("External Document No.",receCommerceSalesHeaderBuffer."eCommerce Order Id");
                  recSalesInvoiceHeader2.SETRANGE("External Document No.",receCommerceSalesHeaderBuffer."Invoice No.");
                  CreateDocument := (NOT recSalesInvoiceHeader.FINDFIRST) AND (NOT recSalesInvoiceHeader2.FINDFIRST) AND (NOT recSalesHeader.FINDFIRST);
                END ELSE BEGIN
                  recSalesHeader.SETRANGE("Document Type",recSalesHeader."Document Type"::"Credit Memo");
                  recSalesHeader.SETRANGE("External Document No.",receCommerceSalesHeaderBuffer."eCommerce Order Id");
                  recSalesCrMemoHeader.SETRANGE("External Document No.",receCommerceSalesHeaderBuffer."eCommerce Order Id");
                  recSalesCrMemoHeader2.SETRANGE("External Document No.",receCommerceSalesHeaderBuffer."Invoice No.");
                  CreateDocument := (NOT recSalesCrMemoHeader.FINDFIRST) AND (NOT recSalesCrMemoHeader2.FINDFIRST) AND (NOT recSalesHeader.FINDFIRST);
                END;

                IF CreateDocument THEN*/
                SI.SetHideSalesDialog(true);
                if not receCommerceSalesHeaderBuffer."Unexpected Item" then begin
                    if (receCommerceSalesHeaderBuffer."Error Description" = '') or  // 19-12-17 ZY-LD 002
                       CreateInSpiteOfError
                    then
                        if receCommerceSalesHeaderBuffer."Country Dimension" = '' then begin
                            receCommerceSalesHeaderBuffer."Error Description" := StrSubstNo(Text003, receCommerceSalesHeaderBuffer.FieldCaption("Country Dimension"));
                            receCommerceSalesHeaderBuffer.Modify();
                        end else
                            //>> 05-12-18 ZY-LD 007
                            if receCommerceSalesHeaderBuffer."Currency Code" = '' then begin
                                receCommerceSalesHeaderBuffer."Error Description" := StrSubstNo(Text003, receCommerceSalesHeaderBuffer.FieldCaption("Currency Code"));
                                receCommerceSalesHeaderBuffer.Modify();
                            end else begin  //<< 05-12-18 ZY-LD 007
                                            //>> 31-08-21 ZY-LD 014
                                recAmzOrderLine.SetRange("eCommerce Order Id", receCommerceSalesHeaderBuffer."eCommerce Order Id");
                                recAmzOrderLine.SetRange("Invoice No.", receCommerceSalesHeaderBuffer."Invoice No.");
                                if recAmzOrderLine.FindSet() then begin
                                    repeat
                                        if not recVATPostSetup.Get(receCommerceSalesHeaderBuffer."VAT Bus. Posting Group", recAmzOrderLine."VAT Prod. Posting Group") then begin
                                            receCommerceSalesHeaderBuffer."Error Description" :=
                                              StrSubstNo(lText001,
                                                recVATPostSetup.TableCaption(),
                                                receCommerceSalesHeaderBuffer.FieldCaption("VAT Bus. Posting Group"), receCommerceSalesHeaderBuffer."VAT Bus. Posting Group",
                                                recAmzOrderLine.FieldCaption("VAT Prod. Posting Group"), recAmzOrderLine."VAT Prod. Posting Group");
                                            receCommerceSalesHeaderBuffer.Modify();
                                        end;
                                    until recAmzOrderLine.Next() = 0;
                                end;

                                if receCommerceSalesHeaderBuffer."Error Description" = '' then begin  //<< 31-08-21 ZY-LD 014
                                    receCommerceSalesHeaderBuffer."Error Description" := '';
                                    ProcessSalesOrder(receCommerceSalesHeaderBuffer);
                                end;
                            end;
                end else begin
                    receCommerceSalesHeaderBuffer."Error Description" := receCommerceSalesHeaderBuffer.FieldCaption("Unexpected Item");
                    receCommerceSalesHeaderBuffer.Modify();
                end;
                RecNo := RecNo + 1;
                SI.SetHideSalesDialog(false);
            until receCommerceSalesHeaderBuffer.Next() = 0;
            Window.Close();
        end;

    end;

    procedure ProcessSalesOrder(recAmzSaleHeadBuf: Record "eCommerce Order Header")
    var
        recAmzCompMap: Record "eCommerce Market Place";
        recCust: Record Customer;
        recSalesHead: Record "Sales Header";
        recAmzSaleLineBuf: Record "eCommerce Order Line";
        recSalesLine: Record "Sales Line";
        recICOutboxTransaction: Record "IC Outbox Transaction";
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        LocationCode: Code[10];
        LineNo: Integer;
        lText001: Label 'Amount on Sales Header %1 do not equal amount %2.';
        TotalSLAmount: Decimal;
        lText002: Label 'Unknown Transaction Type on Order ID: %1.';
        lText003: Label 'Marketplace "%1" is inactive.';
        VatLineAmount: Decimal;
        lText004: Label '"%1" is missing.';
        ItemNo: Code[20];
        lText005: Label 'Item No. %1 was not found. If %1 is an eCommerce ghost item, you must create it in "%2" on the item card.';
        lText006: Label 'The "Item No." %1 should be created as "Item Identifier".\Please contact the eCommerce Team.';
    begin
        //>> 05-12-18 ZY-LD 007
        recAmzCompMap.SetRange("Marketplace ID", recAmzSaleHeadBuf."Marketplace ID");
        if recAmzCompMap.FindFirst() then begin
            if not recAmzCompMap.Active then
                Error(lText003, recAmzSaleHeadBuf."Marketplace ID");
            recAmzCompMap.TestField("Return Reason Code for Cr. Mem");  // 18-12-17 ZY-LD 001
            recAmzCompMap.TestField("Customer No.");
            //recAmzCompMap.TESTFIELD("Posting Company");
            recAmzCompMap.TestField("VAT Prod. Posting Group");

            //>> 16-01-18 ZY-LD 003
            if recAmzSaleHeadBuf."Location Code" <> '' then
                LocationCode := recAmzSaleHeadBuf."Location Code"
            else  //<< 16-01-18 ZY-LD 003
                LocationCode := recAmzCompMap."Location Code";

            recCust.Get(recAmzCompMap."Customer No.");
            recCust.TestField("Customer Price Group", '');

            recSalesHead.Init();
            recSalesHead.SetHideValidationDialog(true);
            case recAmzSaleHeadBuf."Transaction Type" of
                recAmzSaleHeadBuf."transaction type"::Order:
                    recSalesHead."Document Type" := recSalesHead."document type"::Invoice;
                recAmzSaleHeadBuf."transaction type"::Refund:
                    recSalesHead."Document Type" := recSalesHead."document type"::"Credit Memo";
                else
                    Error(lText002, recAmzSaleHeadBuf."eCommerce Order Id");
            end;
            recSalesHead.Insert(true);

            SI.SetKeepLocationCode(true);  // 30-08-21 ZY-LD 013
            recSalesHead."eCommerce Order" := true;
            recSalesHead."Sales Order Type" := recSalesHead."sales order type"::Normal;
            recSalesHead.Validate("Sell-to Customer No.", recCust."No.");
            recSalesHead.Validate("Currency Code", recAmzSaleHeadBuf."Currency Code");
            //recSalesHead.VALIDATE("VAT Bus. Posting Group",recAmzSaleHeadBuf."VAT Bus. Posting Group");  // 15-01-18 ZY-LD 003  // 30-10-19 ZY-LD 009
            recSalesHead.Validate("Salesperson Code", recAmzCompMap."Sales Person Code");
            recSalesHead.Validate("External Document No.", recAmzSaleHeadBuf."eCommerce Order Id");
            recSalesHead.Validate("Your Reference", recAmzSaleHeadBuf."eCommerce Order Id");
            recSalesHead.Validate("Reference 2", recAmzSaleHeadBuf."eCommerce Order Id");
            recSalesHead.Validate("Location Code", LocationCode);
            recSalesHead.Validate("VAT Bus. Posting Group", recAmzSaleHeadBuf."VAT Bus. Posting Group");  // 30-10-19 ZY-LD 009
            recSalesHead.Ship := true;
            recSalesHead.Invoice := true;
            recSalesHead."Assigned User ID" := UserId();
            recSalesHead."Transport Method" := recAmzCompMap."Transport Method";
            recSalesHead."Requested Delivery Date" := recAmzSaleHeadBuf."Requested Delivery Date";
            recSalesHead."Shipment Method Code" := recAmzCompMap."Shipment Method";
            recSalesHead."Shipping Agent Code" := recAmzCompMap."Shipping Agent Code";
            recSalesHead."Ship-to Country/Region Code" := recAmzSaleHeadBuf."Ship To Country";
            recSalesHead."Ship-to County" := recAmzSaleHeadBuf."Ship To State";
            recSalesHead."Ship-to Post Code" := recAmzSaleHeadBuf."Ship To Postal Code";
            recSalesHead."Ship-to City" := CopyStr(recAmzSaleHeadBuf."Ship To City", 1, MaxStrLen(recSalesHead."Ship-to City"));
            recSalesHead."Ship-to VAT" := recAmzSaleHeadBuf."Purchaser VAT No.";
            recSalesHead."VAT Registration No. Zyxel" := recAmzSaleHeadBuf."VAT Registration No. Zyxel";  // 30-05-19 ZY-LD 008
            recSalesHead."Shipment Date" := Today;  // 26-02-21 ZY-LD 012
            recSalesHead."Skip Posting Group Validation" := true;  // 31-08-21 ZY-LD 014
            recSalesHead.Modify();
            //>> 18-01-18 ZY-LD 004
            recSalesHead.ValidateShortcutDimCode(3, recAmzSaleHeadBuf."Country Dimension");
            recSalesHead.Modify();
            //<< 18-01-18 ZY-LD 004
            SI.SetKeepLocationCode(false);  // 30-08-21 ZY-LD 013

            LineNo := 10000;
            recAmzSaleLineBuf.SetRange("eCommerce Order Id", recAmzSaleHeadBuf."eCommerce Order Id");
            recAmzSaleLineBuf.SetRange("Invoice No.", recAmzSaleHeadBuf."Invoice No.");
            if recAmzSaleLineBuf.FindSet() then
                repeat
                    //>> 31-03-20 ZY-LD 011
                    ItemNo := '';
                    //>> 27-04-21 ZY-LD 013
                    if StrLen(recAmzSaleLineBuf."Item No.") > MaxStrLen(recItem."No.") then begin
                        recItemIdent.SetRange(ExtendedCodeZX, recAmzSaleLineBuf."Item No.");
                        if not recItemIdent.FindFirst() then
                            Error(lText006, recAmzSaleLineBuf."Item No.");
                        ItemNo := recItemIdent."Item No.";
                    end else  //<< 27-04-21 ZY-LD 013
                        if not recItem.Get(recAmzSaleLineBuf."Item No.") then begin
                            recItemIdent.SetRange(ExtendedCodeZX, recAmzSaleLineBuf."Item No.");
                            if not recItemIdent.FindFirst() then
                                ItemNo := recItemIdent."Item No.";
                        end else
                            ItemNo := recItem."No.";

                    if ItemNo <> '' then begin  //<< 31-03-20 ZY-LD 011
                        recSalesLine.Init();
                        recSalesLine.SetHideValidationDialog(true);
                        recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                        recSalesLine.Validate("Document No.", recSalesHead."No.");
                        recSalesLine.Validate("Line No.", LineNo);
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        //recSalesLine.VALIDATE("No.", recAmzSaleLineBuf."Item No.");  // 31-03-20 ZY-LD 011
                        recSalesLine.Validate("No.", ItemNo);  // 31-03-20 ZY-LD 011
                                                               //>> 23-02-21 ZY-LD 012
                        if recAmzSaleLineBuf."VAT Prod. Posting Group" <> '' then
                            recSalesLine.Validate("VAT Prod. Posting Group", recAmzSaleLineBuf."VAT Prod. Posting Group")
                        else  //<< 23-02-21 ZY-LD 012
                            recSalesLine.Validate("VAT Prod. Posting Group", recAmzCompMap."VAT Prod. Posting Group");
                        case recAmzSaleHeadBuf."Transaction Type" of
                            recAmzSaleHeadBuf."transaction type"::Order:
                                recSalesLine."Unit Price" := recAmzSaleLineBuf."Item Price (Exc. Tax)";
                            recAmzSaleHeadBuf."transaction type"::Refund:
                                begin
                                    if recAmzSaleLineBuf."Item Price (Exc. Tax)" < 0 then
                                        recSalesLine."Unit Price" := 0 - recAmzSaleLineBuf."Item Price (Exc. Tax)";
                                    if recAmzSaleLineBuf."Item Price (Exc. Tax)" > 0 then
                                        recSalesLine."Unit Price" := recAmzSaleLineBuf."Item Price (Exc. Tax)";
                                    if recAmzSaleLineBuf."Item Price (Exc. Tax)" = 0 then begin
                                        recSalesLine."Unit Price" :=
                                          recAmzSaleLineBuf."Total Promo (Inc. Tax)" +
                                          recAmzSaleLineBuf."Total Promo Tax Amount" +
                                          recAmzSaleLineBuf."Total Promo (Exc. Tax)" +
                                          recAmzSaleLineBuf."Total Shipping (Inc. Tax)" +
                                          recAmzSaleLineBuf."Total Shipping Tax Amount" +
                                          recAmzSaleLineBuf."Total Shipping (Exc. Tax)";
                                    end;
                                    recSalesLine."Return Reason Code" := recAmzCompMap."Return Reason Code for Cr. Mem";  // 18-12-17 ZY-LD 001
                                end;
                        end;

                        if recAmzSaleLineBuf.Quantity = 0 then
                            recSalesLine.Validate(Quantity, 1)
                        else
                            recSalesLine.Validate(Quantity, recAmzSaleLineBuf.Quantity);

                        recSalesLine."Skip Posting Group Validation" := true;  // 31-08-21 ZY-LD 014
                        recSalesLine.Insert();
                        recSalesLine.SetHideValidationDialog(false);
                        LineNo := LineNo + 10000;

                        VatLineAmount := Round((recSalesLine.Quantity * recSalesLine."Unit Price") * (recSalesLine."VAT %" / 100));
                        TotalSLAmount := TotalSLAmount + Round((recSalesLine.Quantity * recSalesLine."Unit Price") + VatLineAmount);
                    end else
                        recAmzSaleHeadBuf."Error Description" := StrSubstNo(lText005, recAmzSaleLineBuf."Item No.", recItemIdent.TableCaption());  // 31-03-20 ZY-LD 011
                until (recAmzSaleLineBuf.Next() = 0) or (recAmzSaleHeadBuf."Error Description" <> '');

            if recAmzSaleHeadBuf."Error Description" = '' then  // 31-03-20 ZY-LD 011
                if (Abs(recAmzSaleHeadBuf."Total (Inc. Tax)" - TotalSLAmount) <= 0.05) or
                   (CreateInSpiteOfError)
                then begin
                    if AutoPost then
                        recSalesHead.SendToPosting(Codeunit::"Sales-Post");

                    recAmzSaleHeadBuf."RHQ Invoice No" := recSalesHead."No.";
                    recAmzSaleHeadBuf.Open := false;
                    recAmzSaleHeadBuf."Error Description" := '';
                end else
                    recAmzSaleHeadBuf."Error Description" := StrSubstNo(lText001, TotalSLAmount, recAmzSaleHeadBuf."Total (Inc. Tax)");

            if recAmzSaleHeadBuf."Error Description" <> '' then begin
                recSalesHead.SetHideValidationDialog(true);  // 31-10-19 ZY-LD 010
                recSalesHead.Delete(true);
                recSalesHead.SetHideValidationDialog(false);  // 31-10-19 ZY-LD 010
            end;

            recAmzSaleHeadBuf.Modify();
        end;
        //<< 05-12-18 ZY-LD 007
    end;
}
