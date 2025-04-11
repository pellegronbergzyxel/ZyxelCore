XmlPort 50035 "WS Intercompany"
{
    // 001. 09-10-18 ZY-LD 000 - ShipToCode is added.
    // 002. 10-07-20 ZY-LD P0455 - Transfer of "Shipment Method Code".

    Caption = 'WS Intercompany';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("IC Inbox Transaction"; "IC Inbox Transaction")
            {
                MinOccurs = Zero;
                XmlName = 'IcInboxTransaction';
                UseTemporary = true;
                fieldelement(TransactionNo; "IC Inbox Transaction"."Transaction No.")
                {
                }
                fieldelement(IcPartnerCode; "IC Inbox Transaction"."IC Partner Code")
                {
                }
                fieldelement(SourceType; "IC Inbox Transaction"."Source Type")
                {
                }
                fieldelement(DocumentType; "IC Inbox Transaction"."Document Type")
                {
                }
                fieldelement(DocumentNo; "IC Inbox Transaction"."Document No.")
                {
                }
                fieldelement(PostingDate; "IC Inbox Transaction"."Posting Date")
                {
                }
                fieldelement(TransactionSource; "IC Inbox Transaction"."Transaction Source")
                {
                }
                fieldelement(DocumentDate; "IC Inbox Transaction"."Document Date")
                {
                }
                fieldelement(LineAction; "IC Inbox Transaction"."Line Action")
                {
                }
                fieldelement(OriginalDocNo; "IC Inbox Transaction"."Original Document No.")
                {
                }
                fieldelement(IcPartnerGLAccNo; "IC Inbox Transaction"."IC Account No.")
                {
                }
                fieldelement(SourceLineNo; "IC Inbox Transaction"."Source Line No.")
                {
                }
                //fieldelement(eCommerce; "IC Inbox Transaction".eCommerce)
                //{
                //}
            }
            tableelement("IC Inbox Purchase Header"; "IC Inbox Purchase Header")
            {
                MinOccurs = Zero;
                XmlName = 'IcInboxPurchaseHeader';
                UseTemporary = true;
                fieldelement(TransactionNo; "IC Inbox Purchase Header"."IC Transaction No.")
                {
                }
                fieldelement(ICPartnerCode; "IC Inbox Purchase Header"."IC Partner Code")
                {
                }
                fieldelement(TransactioSource; "IC Inbox Purchase Header"."Transaction Source")
                {
                }
                fieldelement(DocumentType; "IC Inbox Purchase Header"."Document Type")
                {
                }
                fieldelement(No; "IC Inbox Purchase Header"."No.")
                {
                }
                fieldelement(ShipToCode; "IC Inbox Purchase Header"."Ship-to Code")
                {
                }
                fieldelement(ShipToName; "IC Inbox Purchase Header"."Ship-to Name")
                {
                }
                fieldelement(ShipToName2; "IC Inbox Purchase Header"."Ship-to Name 2")
                {
                }
                fieldelement(ShipToAddress; "IC Inbox Purchase Header"."Ship-to Address")
                {
                }
                fieldelement(ShipToAddress2; "IC Inbox Purchase Header"."Ship-to Address 2")
                {
                }
                fieldelement(ShipToCity; "IC Inbox Purchase Header"."Ship-to City")
                {
                }
                fieldelement(ShipToPostCode; "IC Inbox Purchase Header"."Ship-to Post Code")
                {
                }
                fieldelement(ShipToCountryRegion; "IC Inbox Purchase Header"."Ship-to Country/Region Code")
                {
                }
                fieldelement(ShipToContact; "IC Inbox Purchase Header"."Ship-to Contact")
                {
                }
                fieldelement(ShipToCounty; "IC Inbox Purchase Header"."Ship-to County")
                {
                }
                fieldelement(ShipToEmail; "IC Inbox Purchase Header"."Ship-to E-Mail")
                {
                }
                fieldelement(ShipToVat; "IC Inbox Purchase Header"."Ship-to VAT")
                {
                }
                fieldelement(ShipmentMethodCode; "IC Inbox Purchase Header"."Shipment Method Code")
                {
                }
                //fieldelement(eCommerceOrder; "IC Inbox Purchase Header"."eCommerce Order")
                //{
                //}
                fieldelement(YourReference2; "IC Inbox Purchase Header"."Your Reference 2")
                {
                }
                fieldelement(IphPostingDate; "IC Inbox Purchase Header"."Posting Date")
                {
                }
                fieldelement(DueDate; "IC Inbox Purchase Header"."Due Date")
                {
                }
                fieldelement(PaymentDiscount; "IC Inbox Purchase Header"."Payment Discount %")
                {
                }
                fieldelement(PmtDiscountDate; "IC Inbox Purchase Header"."Pmt. Discount Date")
                {
                }
                fieldelement(CurrencyCode; "IC Inbox Purchase Header"."Currency Code")
                {
                }
                fieldelement(IphDocumentDate; "IC Inbox Purchase Header"."Document Date")
                {
                }
                fieldelement(BuyFromVendorNo; "IC Inbox Purchase Header"."Buy-from Vendor No.")
                {
                }
                fieldelement(PayToVendorNo; "IC Inbox Purchase Header"."Pay-to Vendor No.")
                {
                }
                fieldelement(VendorInvoiceNo; "IC Inbox Purchase Header"."Vendor Invoice No.")
                {
                }
                fieldelement(VendorOrderNo; "IC Inbox Purchase Header"."Vendor Order No.")
                {
                }
                fieldelement(VendorCrMemoNo; "IC Inbox Purchase Header"."Vendor Cr. Memo No.")
                {
                }
                fieldelement(YourReference; "IC Inbox Purchase Header"."Your Reference")
                {
                }
                fieldelement(SellToCustomerNo; "IC Inbox Purchase Header"."Sell-to Customer No.")
                {
                }
                fieldelement(ExpectedReceiptDate; "IC Inbox Purchase Header"."Expected Receipt Date")
                {
                }
                fieldelement(RequestedReceiptDate; "IC Inbox Purchase Header"."Requested Receipt Date")
                {
                }
                fieldelement(PromisedReceiptDate; "IC Inbox Purchase Header"."Promised Receipt Date")
                {
                }
                fieldelement(PricesInclVat; "IC Inbox Purchase Header"."Prices Including VAT")
                {
                }
                fieldelement(EndCustomer; "IC Inbox Purchase Header"."End Customer")
                {
                }
                fieldelement(SalesOrderType; "IC Inbox Purchase Header"."Sales Order Type")
                {
                }
                fieldelement(LocationCode; "IC Inbox Purchase Header"."Location Code")
                {
                }
                fieldelement(SalesPersonCode; "IC Inbox Purchase Header"."Salesperson Code")
                {
                }
                fieldelement(OrderDate; "IC Inbox Purchase Header"."Order Date")
                {
                }
                fieldelement(EInvoiceComment; "IC Inbox Purchase Header"."E-Invoice Comment")
                {
                }
                tableelement("IC Inbox Purchase Line"; "IC Inbox Purchase Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'IcInboxPurchaseLine';
                    UseTemporary = true;
                    fieldelement(DocumentType; "IC Inbox Purchase Line"."Document Type")
                    {
                    }
                    fieldelement(DocumentNo; "IC Inbox Purchase Line"."Document No.")
                    {
                    }
                    fieldelement(LineNo; "IC Inbox Purchase Line"."Line No.")
                    {
                    }
                    fieldelement(Description; "IC Inbox Purchase Line".Description)
                    {
                    }
                    fieldelement(Quantity; "IC Inbox Purchase Line".Quantity)
                    {
                    }
                    fieldelement(DirectUnitCost; "IC Inbox Purchase Line"."Direct Unit Cost")
                    {
                    }
                    fieldelement(LineDiscountPct; "IC Inbox Purchase Line"."Line Discount %")
                    {
                    }
                    fieldelement(LineDiscountAmount; "IC Inbox Purchase Line"."Line Discount Amount")
                    {
                    }
                    fieldelement(AmountInclVAT; "IC Inbox Purchase Line"."Amount Including VAT")
                    {
                    }
                    fieldelement(JobNo; "IC Inbox Purchase Line"."Job No.")
                    {
                    }
                    fieldelement(IndirectCostPct; "IC Inbox Purchase Line"."Indirect Cost %")
                    {
                    }
                    fieldelement(ReceiptNo; "IC Inbox Purchase Line"."Receipt No.")
                    {
                    }
                    fieldelement(ReceiptLineNo; "IC Inbox Purchase Line"."Receipt Line No.")
                    {
                    }
                    fieldelement(DropShipment; "IC Inbox Purchase Line"."Drop Shipment")
                    {
                    }
                    fieldelement(CurrencyCode; "IC Inbox Purchase Line"."Currency Code")
                    {
                    }
                    fieldelement(VatBaseAmount; "IC Inbox Purchase Line"."VAT Base Amount")
                    {
                    }
                    fieldelement(UnitCost; "IC Inbox Purchase Line"."Unit Cost")
                    {
                    }
                    fieldelement(LineAmount; "IC Inbox Purchase Line"."Line Amount")
                    {
                    }
                    fieldelement(IcPartnerRefType; "IC Inbox Purchase Line"."IC Partner Ref. Type")
                    {
                    }
                    fieldelement(IcPartnerRef; "IC Inbox Purchase Line"."IC Partner Reference")
                    {
                    }
                    fieldelement(IcPartnerCode; "IC Inbox Purchase Line"."IC Partner Code")
                    {
                    }
                    fieldelement(IcTransactionNo; "IC Inbox Purchase Line"."IC Transaction No.")
                    {
                    }
                    fieldelement(TransactionSource; "IC Inbox Purchase Line"."Transaction Source")
                    {
                    }
                    fieldelement(ItemRef; "IC Inbox Purchase Line"."Item Ref.")
                    {
                    }
                    fieldelement(UnitOfMeasureCode; "IC Inbox Purchase Line"."Unit of Measure Code")
                    {

                        trigger OnAfterAssignField()
                        begin
                            //EVALUATE("IC Inbox Purchase Line"."Requested Receipt Date",ReqReceiptDate);
                        end;
                    }
                    fieldelement(ReqReceiptDate; "IC Inbox Purchase Line"."Requested Receipt Date")
                    {
                    }
                    fieldelement(PromReceiptDate; "IC Inbox Purchase Line"."Promised Receipt Date")
                    {
                    }
                    fieldelement(ReturnShipNo; "IC Inbox Purchase Line"."Return Shipment No.")
                    {
                    }
                    fieldelement(ReturnShipLineNo; "IC Inbox Purchase Line"."Return Shipment Line No.")
                    {
                    }
                    fieldelement(ReturnReasonCode; "IC Inbox Purchase Line"."Return Reason Code")
                    {
                    }
                    fieldelement(HideLine; "IC Inbox Purchase Line"."Hide Line")
                    {
                    }
                    fieldelement(ExternalDocumentNo; "IC Inbox Purchase Line"."External Document No.")
                    {
                    }
                    fieldelement(ExternalDocumentPosNo; "IC Inbox Purchase Line"."External Document Position No.")
                    {
                    }
                    fieldelement(LocationCode; "IC Inbox Purchase Line"."Location Code")
                    {
                    }
                    fieldelement(GenProdPostGrp; "IC Inbox Purchase Line"."Gen. Prod. Posting Group")
                    {
                    }
                    fieldelement(PickingListNo; "IC Inbox Purchase Line"."Picking List No.")
                    {
                    }
                    fieldelement(PackingListNo; "IC Inbox Purchase Line"."Packing List No.")
                    {
                    }
                    fieldelement(IcPayTerms; "IC Inbox Purchase Line"."IC Payment Terms")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "IC Inbox Purchase Line".SetRange("IC Transaction No.", "IC Inbox Purchase Header"."IC Transaction No.");
                        "IC Inbox Purchase Line".SetRange("IC Partner Code", "IC Inbox Purchase Header"."IC Partner Code");
                        "IC Inbox Purchase Line".SetRange("Transaction Source", "IC Inbox Purchase Header"."Transaction Source");
                    end;
                }
            }
            tableelement("IC Document Dimension"; "IC Document Dimension")
            {
                MinOccurs = Zero;
                XmlName = 'IcDocumentDim';
                UseTemporary = true;
                fieldelement(IddTableID; "IC Document Dimension"."Table ID")
                {
                }
                fieldelement(IddTransactionNo; "IC Document Dimension"."Transaction No.")
                {
                }
                fieldelement(IddIcPartnerCode; "IC Document Dimension"."IC Partner Code")
                {
                }
                fieldelement(IddTransactionSource; "IC Document Dimension"."Transaction Source")
                {
                }
                fieldelement(IddLineNo; "IC Document Dimension"."Line No.")
                {
                }
                fieldelement(IddDimensionCode; "IC Document Dimension"."Dimension Code")
                {
                }
                fieldelement(IddDimensionValue; "IC Document Dimension"."Dimension Value Code")
                {
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
        Text002: label '%1 %2 to IC Partner %3 already exists in the IC inbox of IC Partner %3. IC Partner %3 must complete the line action for transaction %2 in their IC inbox.';
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetICInboxTransaction(pICInboxTransaction: Record "IC Inbox Transaction")
    begin
        "IC Inbox Transaction" := pICInboxTransaction;
        "IC Inbox Transaction".Insert;
    end;


    procedure SetICInboxPurchHead(pICInboxPurchHead: Record "IC Inbox Purchase Header")
    var
        recICInboxPurchHead: Record "IC Inbox Purchase Header";
        recICInboxPurchLine: Record "IC Inbox Purchase Line";
    begin
        "IC Inbox Purchase Header" := pICInboxPurchHead;
        "IC Inbox Purchase Header".Insert;
    end;


    procedure SetIcInboxPurchLine(pICInboxPurchLine: Record "IC Inbox Purchase Line")
    begin
        "IC Inbox Purchase Line" := pICInboxPurchLine;
        "IC Inbox Purchase Line".Insert;
    end;


    procedure SetIcInboxPurchDim(pICDocumentDimension: Record "IC Document Dimension")
    begin
        "IC Document Dimension" := pICDocumentDimension;
        "IC Document Dimension".Insert;
    end;


    procedure ReplicateData()
    var
        recICInboxTrans: Record "IC Inbox Transaction";
        recICInboxPurchHead: Record "IC Inbox Purchase Header";
        recICInboxPurchLine: Record "IC Inbox Purchase Line";
        recICDocDim: Record "IC Document Dimension";
        recIcDocValue: Record "IC Dimension Value";
        recDimValue: Record "Dimension Value";
        recGenLedgSetup: Record "General Ledger Setup";
        recItem: Record Item;  // 14-11-23 ZY-LD 003
        lText001: label 'You are trying to import into a wrong table. Please change table no.';
    begin
        // In Italian and Tyrkish Navision the tables must be replaced with 50018, 50027, 50028, 50029
        //if ZGT.ItalianServer or ZGT.TurkishServer then
        if ZGT.TurkishServer then
            if recICInboxTrans.TableName = "IC Inbox Transaction".TableName then
                Error(lText001);

        if "IC Inbox Transaction".FindSet then
            repeat
                recICInboxTrans.TransferFields("IC Inbox Transaction");
                if not recICInboxTrans.Insert then
                    Error(
                      Text002, "IC Inbox Transaction".FieldCaption("Transaction No."),
                      "IC Inbox Transaction"."Transaction No.",
                      "IC Inbox Transaction"."IC Partner Code");
            until "IC Inbox Transaction".Next() = 0;

        if "IC Inbox Purchase Header".FindSet then
            repeat
                recICInboxPurchHead.TransferFields("IC Inbox Purchase Header");
                recICInboxPurchHead.Insert;

                "IC Inbox Purchase Line".SetRange("IC Transaction No.", "IC Inbox Purchase Header"."IC Transaction No.");
                "IC Inbox Purchase Line".SetRange("IC Partner Code", "IC Inbox Purchase Header"."IC Partner Code");
                "IC Inbox Purchase Line".SetRange("Transaction Source", "IC Inbox Purchase Header"."Transaction Source");
                if ZGT.TurkishServer then
                    "IC Inbox Purchase Line".SetRange("Hide Line", false);
                if "IC Inbox Purchase Line".FindSet then
                    repeat
                        recICInboxPurchLine.TransferFields("IC Inbox Purchase Line");
                        recICInboxPurchLine."Return Reason Code" := "IC Inbox Purchase Line"."Return Reason Code";
                        recICInboxPurchLine."Hide Line" := "IC Inbox Purchase Line"."Hide Line";
                        recICInboxPurchLine."External Document No." := "IC Inbox Purchase Line"."External Document No.";
                        recICInboxPurchLine."Location Code" := "IC Inbox Purchase Line"."Location Code";
                        if ZGT.ItalianServer or ZGT.TurkishServer then begin
                            recICInboxPurchLine."Return Shipment No." := '';
                            recICInboxPurchLine."Return Shipment Line No." := 0;
                        end;
                        recICInboxPurchLine.Insert;
                    until "IC Inbox Purchase Line".Next() = 0;
            until "IC Inbox Purchase Header".Next() = 0;

        if "IC Document Dimension".FindSet then begin
            recGenLedgSetup.get;

            repeat
                recICDocDim.TransferFields("IC Document Dimension");
                recICDocDim.Insert;

            //>> 11-03-24 ZY-LD 003
            /*if "IC Document Dimension"."Dimension Code" = recGenLedgSetup."Shortcut Dimension 5 Code" then begin
                Clear(recIcDocValue);
                recIcDocValue.Init();
                recIcDocValue.validate("Dimension Code", "IC Document Dimension"."Dimension Code");
                recIcDocValue.Validate(Code, "IC Document Dimension"."Dimension Value Code");
                recIcDocValue.Validate(Name, "IC Document Dimension"."Dimension Value Code");
                recIcDocValue.Validate("Map-to Dimension Code", "IC Document Dimension"."Dimension Code");
                recIcDocValue.Validate("Map-to Dimension Value Code", "IC Document Dimension"."Dimension Value Code");
                recIcDocValue.Insert(true);
            end;*/  //<< 11-03-24 ZY-LD 003
            until "IC Document Dimension".Next() = 0;
        end;
    end;
}
