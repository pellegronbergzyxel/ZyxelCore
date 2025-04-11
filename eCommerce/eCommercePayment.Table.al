table 50111 "eCommerce Payment"
{
    Caption = 'eCommerce Payment';

    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = false;
            Description = 'PAB 1.0';
        }
        field(2; Date; Date)
        {
            Description = 'PAB 1.0';
        }
        field(4; "Item No."; Code[30])
        {
            Description = 'PAB 1.0';
            TableRelation = Item."No.";
        }
        field(5; "Transaction Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = ' ,Order,Refund,Service Fees,Other Transaction,Paid to eCommerce or Seller repayment,Retrocharge refund,Order retrocharge,Commingling VAT,Carryover';
            OptionMembers = " ","Order",Refund,"Service Fees","Other Transaction","Paid to eCommerce or Seller repayment","Retrocharge refund","Order retrocharge","Commingling VAT",Carryover;

            trigger OnValidate()
            begin
                case "Transaction Type" of
                    "transaction type"::Order:
                        "Sales Document Type" := "sales document type"::Invoice;
                    "transaction type"::Refund:
                        "Sales Document Type" := "sales document type"::"Credit Memo";
                end;
            end;
        }
        field(6; "Payment Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = ',eCommerce fees,Other,Product charges,Promo rebates,Transaction Details,Blank,FBA Inventory Reimbursement - Damaged:Warehouse,FBA Inventory Reimbursement - Lost:Inbound,FBA Inventory Reimbursement - Fee Correction,FBA Inventory Reimbursement - Customer Return,FBA Inventory Reimbursement - Lost:Warehouse,Order Fee,Payment Fee';
            OptionMembers = ,"eCommerce fees",Other,"Product charges","Promo rebates","Transaction Details",Blank,"FBA Inventory Reimbursement - Damaged:Warehouse","FBA Inventory Reimbursement - Lost:Inbound","FBA Inventory Reimbursement - Fee Correction","FBA Inventory Reimbursement - Customer Return","FBA Inventory Reimbursement - Lost:Warehouse","Order Fee","Payment Fee";
        }
        field(7; "Payment Detail"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Commission,Cost of Advertising,FBA fulfilment fee per unit,FBA Return Fee,FBA storage fee,Label fee,Previous Reserve Amount Balance,Product Tax,Refund commission,Shipping,Shipping chargeback,Shipping tax,Other,Current Reserve Amount,Blank,Subscription,Failed disbursement,Taping Fee,Tax,Lightning Deal Fee,Other concession,FBA Disposal Fee,Unplanned Service Fee - Barcode label missing,FBA Long-Term Storage Fee,Shipping holdback,FBA transportation fee,Non-subscription Fee Adjustment,Manual Processing Fee,Variable closing fee,Inbound Transportation Fee,Inbound Transportation Program Fee,Gift wrap chargeback,Gift wrap tax,Gift rap,Total Inbound Transportation Fees,Vine enrolment fee';
            OptionMembers = Commission,"Cost of Advertising","FBA fulfilment fee per unit","FBA Return Fee","FBA storage fee","Label fee","Previous Reserve Amount Balance","Product Tax","Refund commission",Shipping,"Shipping chargeback","Shipping tax",Other,"Current Reserve Amount",Blank,Subscription,"Failed disbursement","Taping Fee",Tax,"Lightning Deal Fee","Other concession","FBA Disposal Fee","Unplanned Service Fee - Barcode label missing","FBA Long-Term Storage Fee","Shipping holdback","FBA transportation fee","Non-subscription Fee Adjustment","Manual Processing Fee","Variable closing fee","Inbound Transportation Fee","Inbound Transportation Program Fee","Gift wrap chargeback","Gift wrap tax","Gift rap","Total Inbound Transportation Fees","Vine enrolment fee";
        }
        field(8; Amount; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(9; Quantity; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(10; "Product Title"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(11; "Transaction Summary"; Text[100])
        {
            Description = 'PAB 1.0';
        }
        field(12; Open; Boolean)
        {
            Description = 'PAB 1.0';
            InitValue = true;
        }
        field(13; Filename; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(14; "Journal Line Created"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(15; "Journal Line Posted"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(16; "Posting Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = ' ,Charge,Fee,None,Payment,Sale';
            OptionMembers = " ",Charge,Fee,"None",Payment,Sale;
        }
        field(17; "Transaction Status"; Option)
        {
            Caption = 'Transaction Status';
            OptionCaption = ' ,Released,Deferred';
            OptionMembers = " ",Released,Deferred;
        }
        field(18; "Payment Belongs to"; Text[10])
        {
            Caption = 'Payment Belongs to';
        }
        field(23; "Order ID"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(24; "Source Invoice No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(25; "Purchase Invoice No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(26; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            Description = 'PAB 1.0';
            TableRelation = "Sales Invoice Header";
        }
        field(27; "Sales Credit No."; Code[20])
        {
            Caption = 'Sales Credit Memo No.';
            Description = 'PAB 1.0';
            TableRelation = "Sales Cr.Memo Header";
        }
        field(28; "eCommerce Market Place"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(29; "Ship To Country"; Code[30])
        {
            Description = 'PAB 1.0';
        }
        field(30; "Error x"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(31; "Posting Currency Code"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(35; "eCommerce Invoice No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(36; "Fee Purchase Invoice No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(37; Exception; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(38; "Cash Receipt Journals Line"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(39; "Payment is Posted"; Boolean)
        {
            CalcFormula = exist("Cust. Ledger Entry" where("External Document No." = field("Order ID"),
                                                            "Document Type" = const(Payment)));
            Caption = 'Payment is Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Journal Batch No."; Code[10])
        {
            Caption = 'Journal Batch No.';
            TableRelation = "eCommerce Payment Header";
        }
        field(41; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(42; "Payment Detail Text"; Text[250])
        {
            Caption = 'Payment Detail Text';
        }
        field(43; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(44; "Amount Type"; Code[30])
        {
            Caption = 'Amount Type';
            TableRelation = "eCommerce Payment Amount Type";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if not recAmzPayAmountType.Get("Amount Type") then begin
                    recAmzPayAmountType.Init();
                    recAmzPayAmountType.Validate(Code, "Amount Type");
                    recAmzPayAmountType.Validate(Description, "Amount Type");
                    recAmzPayAmountType.Insert();
                end;

                SetSalesDocumentType;
            end;
        }
        field(45; "Amount Description"; Code[50])
        {
            Caption = 'Amount Description';
            TableRelation = "eComm. Pay. Amount Descript.";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if not recAmzPayAmountDesc.Get("Amount Description") then begin
                    recAmzPayAmountDesc.Init();
                    recAmzPayAmountDesc.Validate(Code, "Amount Description");
                    recAmzPayAmountDesc.Validate(Description, "Amount Description");
                    recAmzPayAmountDesc.Insert();
                end;

                SetSalesDocumentType;
            end;
        }
        field(46; "Shipment ID"; Code[40])
        {
            Caption = 'Shipment ID';
        }
        field(47; "Total Line Payment"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("Journal Batch No."),
                                                               "Order ID" = field("Order ID"),
                                                               "Shipment ID" = field("Shipment ID"),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'Total Line Payment';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "eCommerce Payment" where("Journal Batch No." = field("Journal Batch No."),
                                                      "Order ID" = field("Order ID"),
                                                      "Shipment ID" = field("Shipment ID"));
        }
        field(48; "Amount Posting Type"; Option)
        {
            CalcFormula = lookup("eCommerce Pay. Matrix"."Posting Type" where("Transaction Type" = field("New Transaction Type"),
                                                                              "Amount Type" = field("Amount Type"),
                                                                              "Amount Description" = field("Amount Description")));
            Caption = 'Amount Posting Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Charge,Fee,None,Payment,Sale,Tax,Advertising';
            OptionMembers = " ",Charge,Fee,"None",Payment,Sale,Tax,Advertising;
        }
        field(49; "Sales Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Sales Document Type';
        }
        field(50; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
            TableRelation = "Cust. Ledger Entry"."Document No." where("Document Type" = field("Sales Document Type"),
                                                                      "External Document No." = field("Order ID"));

            trigger OnLookup()
            var
                IncomingDocument: Record "Incoming Document";
            begin
            end;
        }
        field(51; "G/L Account No."; Code[20])
        {
            CalcFormula = lookup("eCommerce Pay. Matrix"."G/L Account No." where("Transaction Type" = field("New Transaction Type"),
                                                                                 "Amount Type" = field("Amount Type"),
                                                                                 "Amount Description" = field("Amount Description")));
            Caption = 'Amount Posting Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "Amount Incl. VAT"; Option)
        {
            CalcFormula = lookup("eCommerce Pay. Matrix"."Amount Incl. VAT" where("Transaction Type" = field("New Transaction Type"),
                                                                                  "Amount Type" = field("Amount Type"),
                                                                                  "Amount Description" = field("Amount Description")));
            Caption = 'Amount Incl. VAT';
            FieldClass = FlowField;
            InitValue = " ";
            OptionMembers = No,Yes," ";
        }
        field(53; "Payment Statement Type"; Option)
        {
            CalcFormula = lookup("eCommerce Pay. Matrix"."Payment Statement Type" where("Transaction Type" = field("New Transaction Type"),
                                                                                        "Amount Type" = field("Amount Type"),
                                                                                        "Amount Description" = field("Amount Description")));
            Caption = 'Payment Statement Type';
            FieldClass = FlowField;
            OptionCaption = ' ,Sales,Refunds,Expense,Cash';
            OptionMembers = " ",Sales,Refunds,Expense,Cash;
        }
        field(54; "Payment Statement Description"; Option)
        {
            CalcFormula = lookup("eCommerce Pay. Matrix"."Payment Statement Description" where("Transaction Type" = field("New Transaction Type"),
                                                                                               "Amount Type" = field("Amount Type"),
                                                                                               "Amount Description" = field("Amount Description")));
            Caption = 'Payment Statement Description';
            FieldClass = FlowField;
            OptionCaption = ' ,eCommerce Fees,Cost of Advertising,FBA Fees,Other,Product Charge,Promo Rebates,Refunded Expenses,Refunded Sales,Shipping,Tax,Beginning Balance,Account Level Reserve';
            OptionMembers = " ","eCommerce Fees","Cost of Advertising","FBA Fees",Other,"Product Charge","Promo Rebates","Refunded Expenses","Refunded Sales",Shipping,Tax,"Beginning Balance","Account Level Reserve";
        }
        field(55; "New Transaction Type"; Code[30])
        {
            Caption = 'Transaction Type';
            TableRelation = "eCommerce Transaction Type";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if not recAmzTransactType.Get("New Transaction Type") then begin
                    recAmzTransactType.Init();
                    recAmzTransactType.Validate(Code, "New Transaction Type");
                    recAmzTransactType.Validate(Description, "New Transaction Type");
                    recAmzTransactType.Insert();
                end;

                SetSalesDocumentType;
            end;
        }
        field(56; "Sales Document Created"; Boolean)
        {
            Caption = 'Sales Document Created';
        }
        field(57; "Fee Market Place"; Code[10])
        {
            Caption = 'Fee Market Place';
            TableRelation = "eCommerce Market Place";
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
        key(Key2; "Transaction Summary")
        {
        }
        key(Key3; Date, "Transaction Summary", "eCommerce Market Place")
        {
        }
        key(Key4; "Journal Batch No.", "Line No.")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "New Transaction Type", "Amount Type", "Amount Description")
        {
        }
        key(Key6; "Journal Batch No.", "Line No.", "Sales Document No.", Open, "Order ID")
        {
        }
        key(Key7; "Journal Batch No.", "Fee Market Place")
        {
        }
    }

    trigger OnInsert()
    begin
        if UID = 0 then begin
            if recAmzPayJnl.FindLast() then
                UID := recAmzPayJnl.UID + 1
            else
                UID := 1;
        end;
    end;

    var
        recAmzPayJnl: Record "eCommerce Payment";
        recAmzTransactType: Record "eCommerce Transaction Type";
        recAmzPayAmountType: Record "eCommerce Payment Amount Type";
        recAmzPayAmountDesc: Record "eComm. Pay. Amount Descript.";

    procedure SetSalesDocumentNo()
    var
        recCustLedgEntry: Record "Cust. Ledger Entry";
        recAmzPay: Record "eCommerce Payment";
        recAmzArch: Record "eCommerce Order Archive";
        recAmzPayHead: Record "eCommerce Payment Header";
        recAmzMktPlace: Record "eCommerce Market Place";
        eCommerceUpdatePayments: Codeunit "eCommerce Update Payments";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ("New Transaction Type" <> '') and ("Amount Type" <> '') and ("Amount Description" <> '') then begin
            CalcFields("Amount Posting Type", "Total Line Payment");
            if ("Amount Posting Type" = "amount posting type"::Payment) and ("Total Line Payment" <> 0) then begin
                TestField("Sales Document Type");
                recAmzPayHead.Get("Journal Batch No.");
                recAmzMktPlace.Get(recAmzPayHead."Market Place ID");

                recCustLedgEntry.Reset();
                recCustLedgEntry.SetCurrentkey("External Document No.");
                recCustLedgEntry.SetAutoCalcFields("eCommerce Payment Relation");
                recCustLedgEntry.SetRange("External Document No.", "Order ID");
                recCustLedgEntry.SetRange("Document Type", "Sales Document Type");
                //recCustLedgEntry.SETRANGE(Amount,"Total Line Payment");
                recCustLedgEntry.SetFilter(Amount, '%1..%2', "Total Line Payment" - recAmzMktPlace."Accepted Rounding", "Total Line Payment" + recAmzMktPlace."Accepted Rounding");
                //recCustLedgEntry.SETRANGE("eCommerce Payment Relation",FALSE);
                recCustLedgEntry.SetRange(Open, true);
                if recCustLedgEntry.FindSet() then
                    repeat
                        if not recCustLedgEntry."eCommerce Payment Relation" then begin
                            Validate("Sales Document No.", recCustLedgEntry."Document No.");
                            Modify(true);

                            recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.");
                            recAmzPay.SetRange("Journal Batch No.", "Journal Batch No.");
                            recAmzPay.SetRange("Sales Document Type", "Sales Document Type");
                            recAmzPay.SetRange("Order ID", "Order ID");
                            recAmzPay.SetRange("Shipment ID", "Shipment ID");
                            recAmzPay.SetRange(Date, Date);
                            recAmzPay.SetRange("Amount Posting Type", recAmzPay."amount posting type"::Payment);
                            recAmzPay.SetFilter("Line No.", '<>%1', "Line No.");
                            if recAmzPay.FindSet(true) then
                                repeat
                                    recAmzPay."Sales Document No." := "Sales Document No.";
                                    recAmzPay.Modify(true);
                                until recAmzPay.Next() = 0;
                        end;
                    until ("Sales Document No." <> '') or (recCustLedgEntry.Next() = 0);
            end;
        end;
    end;

    procedure SetSalesDocumentNo_ZCom()
    var
        recAmzPay: Record "eCommerce Payment";
        recAmzArch: Record "eCommerce Order Archive";
        recAmzPayHead: Record "eCommerce Payment Header";
        recAmzMktPlace: Record "eCommerce Market Place";
        recPostSalesInv: Record "Sales Invoice Header";
        recPostSalesCrMemo: Record "Sales Cr.Memo Header";
        eCommerceUpdatePayments: Codeunit "eCommerce Update Payments";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ("New Transaction Type" <> '') and ("Amount Type" <> '') and ("Amount Description" <> '') then begin
            CalcFields("Amount Posting Type", "Total Line Payment");
            if ("Amount Posting Type" = "amount posting type"::Payment) and ("Total Line Payment" <> 0) then begin
                TestField("Sales Document Type");
                recAmzPayHead.Get("Journal Batch No.");
                recAmzMktPlace.Get(recAmzPayHead."Market Place ID");

                case "New Transaction Type" of
                    'ORDER':
                        begin
                            recPostSalesInv.SetCurrentkey("Your Reference");
                            recPostSalesInv.SetRange("Your Reference", "Order ID");
                            recPostSalesInv.SetFilter("Amount Including VAT", '%1..%2', "Total Line Payment" - recAmzMktPlace."Accepted Rounding", "Total Line Payment" + recAmzMktPlace."Accepted Rounding");
                            if recPostSalesInv.FindLast() then begin
                                "Sales Document No." := recPostSalesInv."No.";
                                Modify(true);

                                recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.");
                                recAmzPay.SetRange("Journal Batch No.", "Journal Batch No.");
                                recAmzPay.SetRange("Sales Document Type", "Sales Document Type");
                                recAmzPay.SetRange("Order ID", "Order ID");
                                recAmzPay.SetRange("Shipment ID", "Shipment ID");
                                recAmzPay.SetRange(Date, Date);
                                recAmzPay.SetRange("Amount Posting Type", recAmzPay."amount posting type"::Payment);
                                recAmzPay.SetFilter("Line No.", '<>%1', "Line No.");
                                if recAmzPay.FindSet(true) then
                                    repeat
                                        recAmzPay."Sales Document No." := "Sales Document No.";
                                        recAmzPay.Modify(true);
                                    until recAmzPay.Next() = 0;
                            end;
                        end;
                    'REFUND':
                        begin
                            recPostSalesCrMemo.SetCurrentkey("Your Reference");
                            recPostSalesCrMemo.SetRange("Your Reference", "Order ID");
                            recPostSalesCrMemo.SetFilter("Amount Including VAT", '%1..%2', "Total Line Payment" - recAmzMktPlace."Accepted Rounding", "Total Line Payment" + recAmzMktPlace."Accepted Rounding");
                            if recPostSalesCrMemo.FindLast() then begin
                                "Sales Document No." := recPostSalesCrMemo."No.";
                                Modify(true);

                                recAmzPay.SetCurrentkey("Journal Batch No.", "Line No.");
                                recAmzPay.SetRange("Journal Batch No.", "Journal Batch No.");
                                recAmzPay.SetRange("Sales Document Type", "Sales Document Type");
                                recAmzPay.SetRange("Order ID", "Order ID");
                                recAmzPay.SetRange("Shipment ID", "Shipment ID");
                                recAmzPay.SetRange(Date, Date);
                                recAmzPay.SetRange("Amount Posting Type", recAmzPay."amount posting type"::Payment);
                                recAmzPay.SetFilter("Line No.", '<>%1', "Line No.");
                                if recAmzPay.FindSet(true) then
                                    repeat
                                        recAmzPay."Sales Document No." := "Sales Document No.";
                                        recAmzPay.Modify(true);
                                    until recAmzPay.Next() = 0;
                            end;
                        end;
                end;
            end;
        end;
    end;

    procedure GeteCommerceInvoiceNo_New(pTransactionType: Option ,Payment,Refund; pDocumentNo: Code[20]; pPaymentAmount: Decimal) rValue: Text[250]
    var
        receCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        lSalesInvHead: Record "Sales Invoice Header";
        lSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recCustLedgEntryDE: Record "Cust. Ledger Entry";
        recCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        // In the beginning of the period of eCommerce there can be two invoices with the same orderno, and we want the last invoice no.
        /*  recCustLedgEntry.SetCurrentKey("External Document No.");
          recCustLedgEntry.SETRANGE("External Document No.",pDocumentNo);
          IF pTransactionType = pTransactionType::Payment THEN
            recCustLedgEntry.SETRANGE("Document Type",recCustLedgEntryDE."Document Type"::Invoice)
          ELSE
            recCustLedgEntry.SETRANGE("Document Type",recCustLedgEntryDE."Document Type"::"Credit Memo");
          IF recCustLedgEntry.FINDFIRST THEN BEGIN
            IF recCustLedgEntry.COUNT = 1 THEN
              rValue := recCustLedgEntry."Document No."
            ELSE BEGIN
              recCustLedgEntry.SETRANGE("Amount (LCY)",pPaymentAmount);
              IF recCustLedgEntry.FINDFIRST THEN
                rValue := recCustLedgEntry."Document No.";
            END;
        */
    end;

    local procedure SetSalesDocumentType()
    var
        recAmzTActType: Record "eCommerce Transaction Type";
        recAmzPayMatrix: Record "eCommerce Pay. Matrix";
    begin
        if ("New Transaction Type" <> '') and ("Amount Type" <> '') and ("Amount Description" <> '') then
            if not recAmzPayMatrix.Get("New Transaction Type", "Amount Type", "Amount Description") then begin
                recAmzPayMatrix.Validate("Transaction Type", "New Transaction Type");
                recAmzPayMatrix.Validate("Amount Type", "Amount Type");
                recAmzPayMatrix.Validate("Amount Description", "Amount Description");
                recAmzPayMatrix.Insert(true);
            end;

        if recAmzPayMatrix.Get("New Transaction Type", "Amount Type", "Amount Description") and (recAmzPayMatrix."Sales Document Type" <> "sales document type"::" ") then
            "Sales Document Type" := recAmzPayMatrix."Sales Document Type"
        else begin
            if recAmzTActType.Get("New Transaction Type") then
                "Sales Document Type" := recAmzTActType."Sales Document Type";
        end;
    end;
}
