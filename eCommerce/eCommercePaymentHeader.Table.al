table 50112 "eCommerce Payment Header"
{
    Caption = 'eCommerce Payment Header';

    fields
    {
        field(1; "Transaction Summary"; Text[100])
        {
            Caption = 'Description';
        }
        field(2; Date; Date)
        {
            Caption = 'Import Date';
        }
        field(3; "No."; Code[10])
        {
            Caption = 'Name';
        }
        field(4; "Market Place ID"; Code[20])
        {
            Caption = 'Market Place ID';
            TableRelation = "eCommerce Market Place";
        }
        field(5; "Settlement ID"; Code[20])
        {
            Caption = 'Settlement ID';
        }
        field(10; Open; Boolean)
        {
            BlankZero = true;
            CalcFormula = min("eCommerce Payment".Open where("Journal Batch No." = field("No."),
                                                             "Amount Posting Type" = filter(<> None),
                                                             "Sales Document No." = filter(<> 'ZYND DE')));
            Caption = 'Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Line Amount"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No.")));
            Caption = 'Line Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Transfered Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Transfered Amount';
        }
        field(15; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(16; "Deposit Date"; Date)
        {
            Caption = 'Deposit Date';
        }
        field(17; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
        }
        field(18; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(19; Period; Text[50])
        {
            Caption = 'Period';
        }
        field(51; "Sales Product Charge"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const("Product Charge")));
            Caption = 'Sales Product Charge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "Sales Tax"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Tax)));
            Caption = 'Sales Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Sales Shipping"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Shipping)));
            Caption = 'Sales Shipping';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Refund Refunded Expenses"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Refunds),
                                                               "Payment Statement Description" = const("Refunded Expenses")));
            Caption = 'Refund Refunded Expenses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Refund Refunded Sales"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Refunds),
                                                               "Payment Statement Description" = const("Refunded Sales")));
            Caption = 'Refund Refunded Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(56; "Expense Promo Rebates"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Expense),
                                                               "Payment Statement Description" = const("Promo Rebates")));
            Caption = 'Expense Promo Rebates';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; "Expense Cost of Advertising"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Expense),
                                                               "Payment Statement Description" = const("Cost of Advertising")));
            Caption = 'Expense Cost of Advertising';
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Expense eCommerce Fee"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Expense),
                                                               "Payment Statement Description" = const("eCommerce Fees")));
            Caption = 'Expense eCommerce Fee';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Sales Other"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Other)));
            Caption = 'Sales Other';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Expense Other"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Expense),
                                                               "Payment Statement Description" = const(Other)));
            Caption = 'Expenses Other';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Expense FBA Fee"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Expense),
                                                               "Payment Statement Description" = const("FBA Fees")));
            Caption = 'Expense FBA Fee';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Not Inplaced Type"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(" "),
                                                               "Payment Statement Description" = filter(<> " ")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Not Inplaced Description"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = filter(<> " "),
                                                               "Payment Statement Description" = const(" ")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Not Inplaced Both"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(" "),
                                                               "Payment Statement Description" = const(" ")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Cash Beginning Balance"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Cash),
                                                               "Payment Statement Description" = const("Beginning Balance")));
            Caption = 'Cash Beginning Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Cash Account Level Reserve"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Cash),
                                                               "Payment Statement Description" = const("Account Level Reserve")));
            Caption = 'Cash Account Level Reserve';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "CRJ Sales Product Charge"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const("Product Charge"),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'CRJ Product Charge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(68; "CRJ Sales Tax"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Tax),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'CRJ Sales Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; "CRJ Sales Shipping"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Shipping),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'CRJ Sales Shipping';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "CRJ Refunded Sales"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Refunds),
                                                               "Payment Statement Description" = const("Refunded Sales"),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'CRJ Refunded Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "RRB Sales Other"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Other),
                                                               "Amount Posting Type" = const(Sale)));
            Caption = 'RRB Sales Other';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "PI Sales Other"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Other),
                                                               "Amount Posting Type" = filter(<> Payment & <> Sale)));
            Caption = 'PI Sales Other';
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "PI Refunded Expense"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Refunds),
                                                               "Payment Statement Description" = const("Refunded Expenses"),
                                                               "Amount Posting Type" = filter(<> Payment & <> Sale)));
            Caption = 'PI Refunded Expense';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "PI Refunded Sales"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Refunds),
                                                               "Payment Statement Description" = const("Refunded Sales"),
                                                               "Amount Posting Type" = filter(<> Payment & <> Sale)));
            Caption = 'PI Refunded Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "PI Sales Tax"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Tax),
                                                               "Amount Posting Type" = filter(<> Payment & <> Sale)));
            Caption = 'PI Sales Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "CRJ Sales Other"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Sales),
                                                               "Payment Statement Description" = const(Other),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'CRJ Sales Other';
            Editable = false;
            FieldClass = FlowField;
        }
        field(77; "CRJ Refunded Expense"; Decimal)
        {
            CalcFormula = sum("eCommerce Payment".Amount where("Journal Batch No." = field("No."),
                                                               "Payment Statement Type" = const(Refunds),
                                                               "Payment Statement Description" = const("Refunded Expenses"),
                                                               "Amount Posting Type" = const(Payment)));
            Caption = 'CRJ Sales Other';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
    }

    trigger OnDelete()
    begin
        //>> 08-01-19 ZY-LD 002
        recAmzPayJnl.SETRANGE("Journal Batch No.", "No.");  // 22-09-22 ZY-LD 003
        CalcFields(Open);
        if recServEnviron.ProductionEnvironment and (recAmzPayJnl.COUNT > 0) then
            Error(Text001);
        //<< 08-01-19 ZY-LD 002
        //recAmzPayJnl.SETRANGE("Transaction Summary","Transaction Summary");  // 22-09-22 ZY-LD 003
        recAmzPayJnl.SetRange("Journal Batch No.", "No.");  // 22-09-22 ZY-LD 003
        recAmzPayJnl.DeleteAll();
    end;

    trigger OnInsert()
    var
        eCommerceSetup: Record "eCommerce Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            eCommerceSetup.Get();
            eCommerceSetup.TestField("Payment Batch Nos.");
            NoSeriesMgt.InitSeries(eCommerceSetup."Payment Batch Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        Date := Today;
    end;

    var
        recAmzPayJnl: Record "eCommerce Payment";
        recServEnviron: Record "Server Environment";
        Text001: Label 'Entries has been posted, and can not be deleted.';
        SalesTotal: Decimal;
        RefundTotal: Decimal;
        ExpenseTotal: Decimal;
        CashTotal: Decimal;
        NotInplTotal: Decimal;
        SalesInvTotal: Decimal;
        CashRcptTotal: Decimal;
        PurchInvTotal: Decimal;
        DashbTotal: Decimal;
        PostTotal: Decimal;
        SRETotal: Decimal;

    procedure GetSalesTotal(): Decimal
    begin
        exit(SalesTotal);
    end;

    procedure GetRefundTotal(): Decimal
    begin
        exit(RefundTotal);
    end;

    procedure GetExpenseTotal(): Decimal
    begin
        exit(ExpenseTotal);
    end;

    procedure GetSalesInvTotal(): Decimal
    begin
        exit(SalesInvTotal);
    end;

    procedure GetNotInplacedTotal(): Decimal
    begin
        exit(NotInplTotal)
    end;

    procedure GetDashboardTotal(): Decimal
    begin
        exit(DashbTotal);
    end;

    procedure GetSRETotal(): Decimal
    begin
        exit(SRETotal);
    end;

    procedure GetCahsRcptTotal(): Decimal
    begin
        exit(CashRcptTotal);
    end;

    procedure GetPurchInvTotal(): Decimal
    begin
        exit(PurchInvTotal);
    end;

    procedure GetPostingTotal(): Decimal
    begin
        exit(PostTotal);
    end;

    procedure CalculateTotal(Type: Option "Payment Dashboard","Post Reconciliation")
    begin
        CalcFields(
          "Sales Product Charge", "Sales Tax", "Sales Shipping", "Sales Other",
          "Refund Refunded Expenses", "Refund Refunded Sales",
          "Expense Promo Rebates", "Expense FBA Fee", "Expense Cost of Advertising", "Expense eCommerce Fee", "Expense Other",
          "Cash Beginning Balance", "Cash Account Level Reserve");

        CalcFields(
          "RRB Sales Other",
          "CRJ Sales Product Charge", "CRJ Sales Tax", "CRJ Sales Shipping", "CRJ Refunded Expense", "CRJ Refunded Sales",
          "PI Sales Tax", "PI Sales Other", "PI Refunded Expense", "PI Refunded Sales");

        if (Type = Type::"Payment Dashboard") and ("Expense Other" > 0) then begin
            "Sales Other" := "Sales Other" + "Expense Other";
            "Expense Other" := 0;
        end;

        SalesTotal := "Sales Product Charge" + "Sales Tax" + "Sales Shipping" + "Sales Other";
        RefundTotal := "Refund Refunded Expenses" + "Refund Refunded Sales";
        ExpenseTotal := "Expense Promo Rebates" + "Expense FBA Fee" + "Expense Cost of Advertising" + "Expense eCommerce Fee" + "Expense Other";
        CashTotal := "Cash Beginning Balance" + "Cash Account Level Reserve";
        NotInplTotal := "Not Inplaced Type" + "Not Inplaced Description" + "Not Inplaced Both";
        DashbTotal := SalesTotal + RefundTotal + ExpenseTotal + CashTotal;
        SRETotal := SalesTotal + RefundTotal + ExpenseTotal;

        //SalesInvTotal := "RRB Sales Other";
        CashRcptTotal := "CRJ Sales Product Charge" + "CRJ Sales Tax" + "CRJ Sales Shipping" + "CRJ Sales Other" + "RRB Sales Other" + "CRJ Refunded Expense" + "CRJ Refunded Sales" + "Expense Promo Rebates";
        PurchInvTotal := "PI Sales Tax" + "PI Sales Other" + "PI Refunded Expense" + "PI Refunded Sales" + "Expense FBA Fee" + "Expense Cost of Advertising" + "Expense eCommerce Fee" + "Expense Other";
        PostTotal := SalesInvTotal + CashRcptTotal + PurchInvTotal;
    end;

    procedure AssistEdit(): Boolean
    var
        eCommerceSetup: Record "eCommerce Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        eCommerceSetup.Get();
        eCommerceSetup.TestField("Payment Batch Nos.");
        if NoSeriesMgt.SelectSeries(eCommerceSetup."Payment Batch Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;
}
