xmlport 50017 "Import eComm. Payment - TEMP"
{
    Caption = 'Import eCommerce Payment';
    Direction = Import;
    FieldDelimiter = '""';
    Format = VariableText;
    RecordSeparator = '<LF>';

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Attribute';
                SourceTableView = sorting(Number);
                textelement(PaymentDate)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    begin
                        PaymentDate := DelChr(PaymentDate, '=', '"');
                    end;
                }
                textelement(TransactType)
                {
                    MinOccurs = Zero;
                }
                textelement(OrderID)
                {
                    MinOccurs = Zero;
                }
                textelement(ProductDetail)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalProductCharge)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalPromotionalRebate)
                {
                    MinOccurs = Zero;
                }
                textelement(eCommerceFee)
                {
                    MinOccurs = Zero;
                }
                textelement(OtherAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalGBP)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                var
                    CreateOrder: Boolean;
                begin
                    if recAmzPayBatch."Transaction Summary" = '' then begin
                        recAmzPayBatch."Transaction Summary" := FileMgt.GetFileNameWithoutExtension(currXMLport.Filename);
                        recAmzPayBatch.Date := Today;
                        recAmzPayBatch."Transfered Amount" := TransferedAmount;
                        recAmzPayBatch.Insert(true);
                    end;

                    if UpperCase(TransactType) <> UpperCase('Transaction type') then
                        InsertLine;
                    currXMLport.Skip();
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(TransferedAmount; TransferedAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transferred Bank Amount';
                    }
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        if TransferedAmount = 0 then
            if not Confirm(Text002) then
                Error('');
    end;

    var
        recAmzPayBatch: Record "eCommerce Payment Header";
        recAmzPayJnl: Record "eCommerce Payment";
        FileMgt: Codeunit "File Management";
        gTransactType: Integer;
        gTransactStatus: Integer;
        gPaymentType: Integer;
        gPaymentDetail: Integer;
        Text001: Label '%1 "%2" was not found.';
        TransferedAmount: Decimal;
        Text002: Label 'Are you sure that you want to import payments with "Transferred Bank Amount" = 0,00?';

    local procedure InsertLine(): Boolean
    begin
        gTransactType := 0;
        gPaymentType := 0;
        gPaymentDetail := recAmzPayJnl."payment detail"::Blank;

        //>> 08-08-22 ZY-LD 001
        /*CASE UPPERCASE(DELCHR(TransactStatus,'=',''' ')) OF
          UPPERCASE(DELCHR('Released','=',' ')) : gTransactStatus := recAmzPayJnl."Transaction Status"::Released;
          UPPERCASE(DELCHR('Deferred','=',' ')) : gTransactStatus := recAmzPayJnl."Transaction Status"::Deferred;
          ELSE
            ERROR(Text001,recAmzPayJnl.FieldCaption("Transaction Status"),TransactStatus);
        END;*/
        //<< 08-08-22 ZY-LD 001

        case UpperCase(DelChr(TransactType, '=', ''' ')) of
            UpperCase(DelChr('Order Payment', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::Order;
            UpperCase(DelChr('Order Retro Charge', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Order retrocharge";
            UpperCase(DelChr('Other', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Other Transaction";
            UpperCase(DelChr('Paid to eCommerce | Seller Prepayment', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Paid to eCommerce or Seller repayment";
            UpperCase(DelChr('Previous statements unavailable balance', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Other Transaction";
            UpperCase(DelChr('Refund', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::Refund;
            UpperCase(DelChr('Retro Charge Refund', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Retrocharge refund";
            UpperCase(DelChr('Service Fees', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Service Fees";
            UpperCase(DelChr('Unavailable Balance', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Other Transaction";
            UpperCase(DelChr('Commingling VAT', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::"Commingling VAT";  // 08-08-22 ZY-LD 001
            UpperCase(DelChr('Carryover', '=', ' ')):
                gTransactType := recAmzPayJnl."transaction type"::Carryover;  // 08-08-22 ZY-LD 001
            else
                Error(Text001, recAmzPayJnl.FieldCaption("Transaction Type"), TransactType);
        end;

        case UpperCase(DelChr(ProductDetail, '=', ' :')) of
            UpperCase(DelChr('Commission', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::Commission;
            UpperCase(DelChr('Cost of Advertising', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Cost of Advertising";
            UpperCase(DelChr('Current Reserve Amount', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Current Reserve Amount";
            UpperCase(DelChr('Failed disbursement', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Failed disbursement";
            UpperCase(DelChr('FBA Disposal Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"FBA Disposal Fee";
            UpperCase(DelChr('FBA Fulfilment Fee per Unit', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"FBA fulfilment fee per unit";
            UpperCase(DelChr('FBA Inventory Reimbursement', '=', ' ')):
                gPaymentType := recAmzPayJnl."payment type"::"FBA Inventory Reimbursement - Damaged:Warehouse";
            UpperCase(DelChr('FBA Long-Term Storage Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"FBA Long-Term Storage Fee";
            UpperCase(DelChr('FBA Return Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"FBA Return Fee";
            UpperCase(DelChr('FBA Storage fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"FBA storage fee";
            UpperCase(DelChr('FBA transportation fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"FBA transportation fee";
            UpperCase(DelChr('Gift wrap chargeback', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Gift wrap chargeback";
            UpperCase(DelChr('Gift wrap tax', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Gift wrap tax";
            UpperCase(DelChr('Gift wrap', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Gift wrap chargeback";
            UpperCase(DelChr('Inbound Transportation Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Inbound Transportation Fee";
            UpperCase(DelChr('Inbound Transportation Program Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Inbound Transportation Program Fee";
            UpperCase(DelChr('Label fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Label fee";
            UpperCase(DelChr('Lightning Deal Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Lightning Deal Fee";
            UpperCase(DelChr('Manual Processing Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Manual Processing Fee";
            UpperCase(DelChr('Manual Processing Fee Reimbursement', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::Other;
            UpperCase(DelChr('Non-subscription Fee Adjustment', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Non-subscription Fee Adjustment";
            UpperCase(DelChr('Other', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::Other;
            UpperCase(DelChr('Other concession', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Other concession";
            UpperCase(DelChr('Previous Reserve Amount Balance', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Previous Reserve Amount Balance";
            UpperCase(DelChr('Product Tax', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Product Tax";
            UpperCase(DelChr('Refund commission', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Refund commission";
            UpperCase(DelChr('Shipping', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::Shipping;
            UpperCase(DelChr('Shipping chargeback', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Shipping chargeback";
            UpperCase(DelChr('Shipping holdback', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Shipping holdback";
            UpperCase(DelChr('Shipping tax', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Shipping tax";
            UpperCase(DelChr('Subscription', '=', ' :')):
                gPaymentDetail := recAmzPayJnl."payment detail"::Subscription;
            UpperCase(DelChr('Taping Fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Taping Fee";
            UpperCase(DelChr('Tax', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::Tax;
            UpperCase(DelChr('Unplanned Service Fee - Barcode label missing', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Unplanned Service Fee - Barcode label missing";
            UpperCase(DelChr('Variable closing fee', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Variable closing fee";
            UpperCase(DelChr('Total Inbound Transportation Fees', '=', ' ')):
                gPaymentDetail := recAmzPayJnl."payment detail"::"Total Inbound Transportation Fees";
            '':
                gPaymentDetail := recAmzPayJnl."payment detail"::Blank;
            else
                if OrderID = '---' then
                    Error(Text001, recAmzPayJnl.FieldCaption("Payment Detail"), ProductDetail);
        end;

        // Product Charge
        if TotalProductCharge <> '0' then begin
            gPaymentType := recAmzPayJnl."payment type"::"Product charges";
            InsertAmzPayJnl(TotalProductCharge);
        end;

        // Other
        if OtherAmount <> '0' then begin
            //IF gPaymentType = 0 THEN
            gPaymentType := recAmzPayJnl."payment type"::Other;
            InsertAmzPayJnl(OtherAmount);
        end;

        // Promotional Rebate
        if TotalPromotionalRebate <> '0' then begin
            gPaymentType := recAmzPayJnl."payment type"::"Promo rebates";
            InsertAmzPayJnl(TotalPromotionalRebate);
        end;

        // eCommerce Fee
        if eCommerceFee <> '0' then begin
            gPaymentType := recAmzPayJnl."payment type"::"eCommerce fees";
            InsertAmzPayJnl(eCommerceFee);
        end;

        /*      IF ExcelBuf.GET(Row,5) THEN PaymentTypeStr := ExcelBuf."Cell Value as Text";
        
              PaymentTypeStr := DELCHR(PaymentTypeStr,'=',' ');
              PaymentTypeStr := UPPERCASE(PaymentTypeStr);
        
              CASE PaymentTypeStr OF
        
                'eCommerceFEES' : PaymentType := PaymentType::"eCommerce fees";
                'OTHER' : PaymentType := PaymentType::Other;
                'PRODUCTCHARGES' : PaymentType := PaymentType::"Product charges";
                'PROMOREBATES' : PaymentType := PaymentType::"Promo rebates";
                'TRANSACTIONDETAILS' : PaymentType := PaymentType::"Transaction Details";
                'FBAINVENTORYREIMBURSEMENT-DAMAGED:WAREHOUSE' : PaymentType := PaymentType::"FBA Inventory Reimbursement - Damaged:Warehouse";
                'FBAINVENTORYREIMBURSEMENT-LOST:INBOUND' : PaymentType := PaymentType::"FBA Inventory Reimbursement - Lost:Inbound";
                'FBAINVENTORYREIMBURSEMENT-FEECORRECTION' : PaymentType := PaymentType::"FBA Inventory Reimbursement - Fee Correction";
                'FBAINVENTORYREIMBURSEMENT-CUSTOMERRETURN' : PaymentType := PaymentType::"FBA Inventory Reimbursement - Customer Return";
                'FBAINVENTORYREIMBURSEMENT-LOST:WAREHOUSE' : PaymentType := PaymentType::"FBA Inventory Reimbursement - Lost:Warehouse";
                '' : PaymentType := PaymentType::Blank
                ELSE
                  ERROR(Text006,receCommercePayments.FieldCaption("Payment Type"),PaymentTypeStr);
              END;
        
              IF ExcelBuf.GET(Row,6) THEN PaymentDetailStr := ExcelBuf."Cell Value as Text";
              PaymentDetailStr := DELCHR(PaymentDetailStr,'=',' ');
              PaymentDetailStr := UPPERCASE(PaymentDetailStr);
        
        
              IF ExcelBuf.GET(Row,7) THEN BEGIN
                AmountStr := ExcelBuf."Cell Value as Text";
                AmountStr := DELCHR(AmountStr,'=','£$');
                IF (COPYSTR(AmountStr,1,1) <> '-') AND (NOT EVALUATE(EvaluateTest,COPYSTR(AmountStr,1,1))) THEN
                  AmountStr := COPYSTR(AmountStr,2,MAXSTRLEN(AmountStr));  // Removing ?
                //>> 01-05-18 ZY-LD 002
        //        IF DanishFormat THEN BEGIN
        //          AmountStr := DELCHR(AmountStr,'=',',');
        //          AmountStr := CONVERTSTR(AmountStr, '.', ',');
        //        END;
        
                //>> 16-05-18 ZY-LD 003
                DevideBy := 1;
                FOR i := STRLEN(AmountStr) DOWNTO STRLEN(AmountStr) - 2 DO BEGIN
                  IF i > 0 THEN BEGIN
                    IF (AmountStr[i] = '.') OR (AmountStr[i] = ',') THEN
                      DevideBy := j;
        
                    IF j = 0 THEN
                      j := 10
                    ELSE
                      j := j * 10;
                  END;
                END;
                //<< 16-05-18 ZY-LD 003
        
                AmountStr := DELCHR(AmountStr,'=',',.');
                EVALUATE(Amount,AmountStr);
                Amount := Amount / DevideBy;
                //<< 01-05-18 ZY-LD 002
              END;
              IF ExcelBuf.GET(Row,8) THEN EVALUATE(Quantity, ExcelBuf."Cell Value as Text");
              IF ExcelBuf.GET(Row,9) THEN ProductTitle := TrimString(ExcelBuf."Cell Value as Text",30);
              */

    end;

    local procedure InsertAmzPayJnl(pAmount: Text)
    var
        recAmzPayMatrix: Record "eCommerce Payment Matrix";
        AmzPaymMgt: Codeunit "eCommerce Update Payments";
    begin
        Clear(recAmzPayJnl);
        recAmzPayJnl.Init();
        recAmzPayJnl."Journal Batch No." := recAmzPayBatch."No.";

        recAmzPayJnl.Validate("Transaction Summary", recAmzPayBatch."Transaction Summary");
        Evaluate(recAmzPayJnl.Date, PaymentDate);
        recAmzPayJnl.Validate(Date);
        if StrPos(OrderID, '-') <> 0 then
            recAmzPayJnl.Validate("Order ID", OrderID);
        recAmzPayJnl.Validate("Transaction Status", gTransactStatus);  //>> 08-08-22 ZY-LD 001
        recAmzPayJnl.Validate("Transaction Type", gTransactType);
        recAmzPayJnl.Validate("Payment Type", gPaymentType);
        recAmzPayJnl.Validate("Payment Detail", gPaymentDetail);
        Evaluate(recAmzPayJnl.Amount, pAmount, 9);
        recAmzPayJnl.Validate(Amount);

        if not recAmzPayMatrix.Get(recAmzPayJnl."Payment Detail", recAmzPayJnl."Payment Type") then begin
            recAmzPayMatrix."Payment Detail" := recAmzPayJnl."Payment Detail";
            recAmzPayMatrix."Payment Type" := recAmzPayJnl."Payment Type";
            recAmzPayMatrix.Insert();
        end else
            recAmzPayJnl.Validate("Posting Type", recAmzPayMatrix."Posting Type");

        case recAmzPayJnl."Transaction Type" of
            recAmzPayJnl."transaction type"::Order:
                recAmzPayJnl."Sales Invoice No." := AmzPaymMgt.GeteCommerceInvoiceNo(recAmzPayJnl."Transaction Type", recAmzPayJnl."Order ID");
            recAmzPayJnl."transaction type"::Refund:
                recAmzPayJnl."Sales Credit No." := AmzPaymMgt.GeteCommerceInvoiceNo(recAmzPayJnl."Transaction Type", recAmzPayJnl."Order ID");
        end;
        recAmzPayJnl.Insert(true);
    end;
}
