xmlport 50020 "eCommerce Payment Import"
{
    // 001. 30-10-23 ZY-LD 000 - Handling different fee vendors.
    // 002. 30-08-24 ZY-LD 000 - Not sure why there was a if. It has been removed to see what happens.

    Caption = 'eCommerce Payment Import';
    Direction = Import;
    FieldSeparator = '<TAB>';
    Format = VariableText;
    RecordSeparator = '<LF>';
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(payment; Integer)
            {
                XmlName = 'Payment';
                SourceTableView = sorting(Number);
                UseTemporary = true;
                textelement(SettlementID)
                {
                }
                textelement(SettlementStartDate)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    begin
                        if FileHeader then
                            if not Evaluate(SettleStartDate, SettlementStartDate, 9) then
                                Evaluate(SettleStartDate, ConvertStr(CopyStr(SettlementStartDate, 1, 19), '.', '-'));
                    end;
                }
                textelement(SettlementEndDate)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    begin
                        if FileHeader then
                            if not Evaluate(SettleEndDate, SettlementEndDate, 9) then
                                Evaluate(SettleEndDate, ConvertStr(CopyStr(SettlementEndDate, 1, 19), '.', '-'));
                    end;
                }
                textelement(DepositDate)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    begin
                        if FileHeader then
                            if not Evaluate(DeposDate, DepositDate, 9) then
                                Evaluate(DeposDate, ConvertStr(CopyStr(DepositDate, 1, 19), '.', '-'));
                    end;
                }
                textelement(TotalAmount)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    begin
                        if FileHeader then begin
                            TotalAmount := ConvertStr(TotalAmount, ',', '.');
                            if not Evaluate(ImportedAmount, TotalAmount, 9) then
                                TotalAmount := ConvertStr(TotalAmount, '.', ',');
                            Evaluate(ImportedAmount, TotalAmount, 9);
                        end;
                    end;
                }
                textelement(CurrencyCode)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    begin
                        if FileHeader then
                            CurrCode := CurrencyCode;
                    end;
                }
                textelement(TransactType)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    var
                        recAmzTransactType: Record "eCommerce Transaction Type";
                    begin
                        if FilePayment then
                            if not recAmzTransactType.Get(UpperCase(TransactType)) then begin
                                recAmzTransactType.Init();
                                recAmzTransactType.Validate(Code, TransactType);
                                recAmzTransactType.Validate(Description, TransactType);
                                recAmzTransactType.Insert();
                            end;
                    end;
                }
                textelement(OrderID)
                {
                    MinOccurs = Zero;
                }
                textelement(MerchantOrderID)
                {
                    MinOccurs = Zero;
                }
                textelement(AdjustmentID)
                {
                    MinOccurs = Zero;
                }
                textelement(ShipmentID)
                {
                    MinOccurs = Zero;
                }
                textelement(MarketplaceName)
                {
                    MinOccurs = Zero;
                }
                textelement(AmountType)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    var
                        recAmzPayAmountType: Record "eCommerce Payment Amount Type";
                    begin
                        if FilePayment then
                            if not recAmzPayAmountType.Get(UpperCase(AmountType)) then begin
                                recAmzPayAmountType.Init();
                                recAmzPayAmountType.Validate(Code, AmountType);
                                recAmzPayAmountType.Validate(Description, AmountType);
                                recAmzPayAmountType.Insert();
                            end;
                    end;
                }
                textelement(AmountDescription)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    var
                        recAmzPayAmountDesc: Record "eComm. Pay. Amount Descript.";
                    begin
                        if FilePayment then begin
                            if StrLen(AmountDescription) > MaxStrLen(recAmzPayAmountDesc.Code) then
                                AmountDescription := CopyStr(AmountDescription, 1, MaxStrLen(recAmzPayAmountDesc.Code));

                            if not recAmzPayAmountDesc.Get(UpperCase(AmountDescription)) then begin
                                recAmzPayAmountDesc.Init();
                                recAmzPayAmountDesc.Validate(Code, AmountDescription);
                                recAmzPayAmountDesc.Validate(Description, AmountDescription);
                                recAmzPayAmountDesc.Insert();
                            end;
                        end;
                    end;
                }
                textelement(Amount)
                {
                    MinOccurs = Zero;
                    trigger OnAfterAssignVariable()
                    begin
                        Amount := ConvertStr(Amount, '.', ',');
                    end;
                }
                textelement(FulfillmentID)
                {
                    MinOccurs = Zero;
                }
                textelement(PostedDate)
                {
                    MinOccurs = Zero;
                }
                textelement(PostedDateTime)
                {
                    MinOccurs = Zero;
                }
                textelement(OrderItemCode)
                {
                    MinOccurs = Zero;
                }
                textelement(MerchantOrderItemID)
                {
                    MinOccurs = Zero;
                }
                textelement(MerchantAdjustmentItemID)
                {
                    MinOccurs = Zero;
                }
                textelement(SKU)
                {
                    MinOccurs = Zero;
                }
                textelement(Quantity)
                {
                    MinOccurs = Zero;
                }
                textelement(PromotionID)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInitRecord()
                begin
                    NoOfLines += 1;
                    FileCaption := NoOfLines = 1;
                    FileHeader := NoOfLines = 2;
                    FilePayment := NoOfLines > 2;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    ZGT.UpdateProgressWindow(StrSubstNo('%1 %2', MerchantOrderID, ShipmentID), 0, true);
                    if FileHeader then begin
                        recAmzPayHead.SetRange("Settlement ID", SettlementID);
                        if recAmzPayHead.FindFirst() then
                            currXMLport.Break();
                        //ERROR(Text002,SettlementID);
                    end;

                    if FilePayment then begin
                        if (not HeaderInserted) or (not AmzMktPlaceLocated) then
                            InsertHeader;

                        InsertPayment;
                    end;

                    currXMLport.Skip();
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        ZGT.CloseProgressWindow;
    end;

    trigger OnPreXmlPort()
    begin
        if TotalRowCount = 0 then
            TotalRowCount := 10000;
        ZGT.OpenProgressWindow('', TotalRowCount);
    end;

    var
        recAmzPayHead: Record "eCommerce Payment Header";
        recAmzMktPlace: Record "eCommerce Market Place";
        ZGT: Codeunit "ZyXEL General Tools";
        NoOfLines: Integer;
        NexLineNo: Integer;
        SettleStartDate: DateTime;
        SettleEndDate: DateTime;
        DeposDate: DateTime;
        FileCaption: Boolean;
        FileHeader: Boolean;
        FilePayment: Boolean;
        HeaderInserted: Boolean;
        Text001: Label '%1 Transactions for statement period %2 - %3';
        AmzMktPlaceLocated: Boolean;
        ImportedAmount: Decimal;
        CurrCode: Code[10];
        Text002: Label 'Settlement ID %1 has already been imported.';
        Text003: Label '%1: %2 - %3';
        NewRecords: Integer;
        TotalRowCount: Integer;

    local procedure InsertHeader()
    var
        lText001: Label 'UNKNOWN';
    begin
        if not HeaderInserted then begin
            recAmzPayHead.Init();
            //recAmzPayHead."Transaction Summary" := STRSUBSTNO(Text001,recAmzMktPlace."Marketplace ID",SettleStartDate,SettleEndDate);
            //recAmzPayHead.Period := STRSUBSTNO(Text003,recAmzMktPlace."Marketplace ID",DT2DATE(SettleStartDate),DT2DATE(SettleEndDate));
            recAmzPayHead."Settlement ID" := SettlementID;
            recAmzPayHead.Date := Today;
            recAmzPayHead."Deposit Date" := Dt2Date(DeposDate);
            recAmzPayHead."Market Place ID" := lText001;
            recAmzPayHead.Validate("Total Amount", ImportedAmount / 100);
            recAmzPayHead.Validate("Currency Code", CurrCode);
            recAmzPayHead.Insert(true);

            HeaderInserted := true;
        end;

        if not AmzMktPlaceLocated then begin
            //>> 30-08-24 ZY-LD 002
            if MarketplaceName = '' then begin
                recAmzMktPlace.SetRange("Currency Code", CurrCode);
                if recAmzMktPlace.FindFirst() and (recAmzMktPlace.count = 1) then
                    MarketplaceName := recAmzMktPlace."Market Place Name";
                recAmzMktPlace.SetRange("Currency Code");
            end;
            //<< 30-08-24 ZY-LD 002

            if MarketplaceName <> '' then begin
                recAmzMktPlace.SetRange("Market Place Name", UpperCase(MarketplaceName));
                if recAmzMktPlace.FindFirst() then begin
                    recAmzPayHead."Transaction Summary" := StrSubstNo(Text001, recAmzMktPlace."Marketplace ID", SettleStartDate, SettleEndDate);
                    recAmzPayHead.Period := StrSubstNo(Text003, recAmzMktPlace."Marketplace ID", Dt2Date(SettleStartDate), Dt2Date(SettleEndDate));
                    //>> 30-10-23 ZY-LD 001
                    IF recAmzMktPlace."Use Main Market Place ID" THEN
                        recAmzPayHead."Market Place ID" := recAmzMktPlace."Main Market Place ID"
                    ELSE  //<< 30-10-23 ZY-LD 001                    
                        recAmzPayHead."Market Place ID" := recAmzMktPlace."Marketplace ID";
                    recAmzPayHead.TESTFIELD("Market Place ID");  // 30-10-23 ZY-LD 001
                    recAmzPayHead.Modify(true);

                    AmzMktPlaceLocated := true;
                end;
            end;
        end;
    end;

    local procedure InsertPayment()
    var
        recAmzPayment: Record "eCommerce Payment";
        recAmzPayAmountDesc: Record "eComm. Pay. Amount Descript.";
        recAmzPayMatrix: Record "eCommerce Pay. Matrix";
        i: Integer;
    begin
        NexLineNo += 10000;

        recAmzPayment.Init();
        recAmzPayment.Validate("Journal Batch No.", recAmzPayHead."No.");
        case UpperCase(AmountDescription) of
            UpperCase('Previous Reserve Amount Balance'):
                begin
                    recAmzPayment."Line No." := 1000;
                    recAmzPayment.Open := false;
                end;
            UpperCase('TRANSFER OF FUNDS UNSUCCESSFUL: WE COULD NOT TRANS'):
                begin
                    recAmzPayment."Line No." := 2000;
                    recAmzPayment.Open := false;
                end;
            UpperCase('Current Reserve Amount'):
                begin
                    recAmzPayment."Line No." := 3000;
                    recAmzPayment.Open := false;
                end;
            else
                recAmzPayment."Line No." := NexLineNo;
        end;
        /*CASE UPPERCASE(TransactType) OF
          UPPERCASE('Commingling VAT') : recAmzPayment.VALIDATE("Transaction Type",recAmzPayment."Transaction Type"::"Commingling VAT");
          UPPERCASE('Order') : recAmzPayment.VALIDATE("Transaction Type",recAmzPayment."Transaction Type"::Order);
          UPPERCASE('other-transaction') : recAmzPayment.VALIDATE("Transaction Type",recAmzPayment."Transaction Type"::"Other Transaction");
          UPPERCASE('Refund') : recAmzPayment.VALIDATE("Transaction Type",recAmzPayment."Transaction Type"::Refund);
          UPPERCASE('ServiceFee') : recAmzPayment.VALIDATE("Transaction Type",recAmzPayment."Transaction Type"::"Service Fees");
          ELSE
            ERROR('Transaction Type is missing.');
        END;*/

        if StrLen(MerchantOrderID) <= MaxStrLen(recAmzPayment."Order ID") then
            recAmzPayment.Validate("Order ID", MerchantOrderID)
        else
            recAmzPayment.Validate("Order ID", OrderID);
        if ShipmentID <> '' then
            recAmzPayment.Validate("Shipment ID", ShipmentID)
        else
            if AdjustmentID <> '' then
                recAmzPayment.Validate("Shipment ID", AdjustmentID)
            else
                recAmzPayment."Shipment ID" := PostedDate;

        recAmzPayment.Validate("New Transaction Type", TransactType);
        recAmzPayment.Validate("Amount Type", AmountType);
        recAmzPayment.Validate("Amount Description", CopyStr(AmountDescription, 1, MaxStrLen(recAmzPayAmountDesc.Code)));
        if not recAmzPayMatrix.Get(recAmzPayment."New Transaction Type", recAmzPayment."Amount Type", recAmzPayment."Amount Description") then begin
            Clear(recAmzPayMatrix);
            recAmzPayMatrix.Init();
            recAmzPayMatrix.Validate("Transaction Type", recAmzPayment."New Transaction Type");
            recAmzPayMatrix.Validate("Amount Type", recAmzPayment."Amount Type");
            recAmzPayMatrix.Validate("Amount Description", recAmzPayment."Amount Description");
            recAmzPayMatrix.Insert(true);
        end;
        Evaluate(recAmzPayment.Amount, Amount);
        recAmzPayment.Validate(Amount);
        Evaluate(recAmzPayment.Date, PostedDate);
        recAmzPayment."Item No." := SKU;
        if Quantity <> '' then begin
            Evaluate(recAmzPayment.Quantity, Quantity);
            recAmzPayment.Validate(Quantity);
        end;

        //>> 30-10-23 ZY-LD 001
        GetMarketPlace(MarketplaceName);
        recAmzPayment.VALIDATE("Fee Market Place", recAmzMktPlace."Marketplace ID");
        //<< 30-10-23 ZY-LD 001

        NewRecords += 1;
        recAmzPayment.Insert(true);
        if AmzMktPlaceLocated then
            if ZGT.IsZNetCompany then
                recAmzPayment.SetSalesDocumentNo
            else
                recAmzPayment.SetSalesDocumentNo_ZCom;

    end;

    procedure GetQuantityImported(): Integer
    begin
        exit(NewRecords);
    end;

    procedure GetMarketPlaceID(): Code[20]
    begin
        exit(recAmzPayHead."Market Place ID");
    end;

    procedure InitXmlPort(NewSize: Integer)
    begin
        TotalRowCount := Round(NewSize / 1000 * 5.25, 1);
    end;

    local procedure GetMarketPlace(pMarketPlaceName: Text): Boolean;
    VAR
        recAmzMktPlace2: Record "eCommerce Market Place";
    BEGIN
        IF pMarketPlaceName = '' THEN BEGIN
            IF NOT recAmzMktPlace.GET(recAmzMktPlace."Main Market Place ID") THEN BEGIN
                recAmzMktPlace2.SETRANGE(Active, TRUE);
                COMMIT;
                IF PAGE.RUNMODAL(PAGE::"eCommerce Company Mapping", recAmzMktPlace2) = ACTION::LookupOK THEN begin
                    recAmzMktPlace.GET(recAmzMktPlace2."Marketplace ID");
                    if recAmzPayHead."Market Place ID" = 'UNKNOWN' then begin
                        recAmzPayHead."Market Place ID" := recAmzMktPlace2."Marketplace ID";
                        recAmzPayHead.Modify();
                    end;
                end;
            END;
        END ELSE
            IF recAmzMktPlace."Market Place Name" <> UPPERCASE(pMarketPlaceName) THEN BEGIN
                recAmzMktPlace.SETRANGE("Market Place Name", UPPERCASE(pMarketPlaceName));
                //IF NOT recAmzMktPlace.FINDFIRST THEN  // 30-08-24 ZY-LD 002
                recAmzMktPlace.FINDFIRST;  // 30-08-24 ZY-LD 002
                recAmzMktPlace.GET(recAmzMktPlace."Main Market Place ID");
            END;

        recAmzMktPlace.TESTFIELD("Vendor No.");
        recAmzMktPlace.TESTFIELD("Periodic Account No.");
        EXIT(TRUE);
    END;
}
