Table 75004 "Payment/Receivables Statistic"
{
    fields
    {
        field(1; "Customer/Vendor No."; Code[20])
        {
            Caption = 'Customer/Vendor No.';
            NotBlank = true;
            TableRelation = if (Type = const(Sales)) Customer."No." where("No." = field("Customer/Vendor No."))
            else
            if (Type = const(Purchase)) Vendor."No." where("No." = field("Customer/Vendor No."));
        }
        field(2; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            InitValue = Payment;
        }
        field(3; "Receivable/Payable Type"; Code[10])
        {
            Caption = 'Receivable/Payable Type';
            TableRelation = if (Type = const(Purchase)) "Payable Type".Code where(Code = field("Receivable/Payable Type"))
            else
            if (Type = const(Sales)) "Receivable Type".Code where(Code = field("Receivable/Payable Type"));
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(55; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(59; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance (LCY)';
        }
        field(67; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance Due (LCY)';
        }
        field(111; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(5903; "Ship-to Filter"; Code[10])
        {
            Caption = 'Ship-to Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Customer/Vendor No.", "Document Type", "Receivable/Payable Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text003: label 'You cannot rename a %1.';


    procedure UpdateBuffer(ldeBalance: Decimal; ldeDueBalance: Decimal)
    begin
        if Find then begin
            "Balance (LCY)" := "Balance (LCY)" + ldeBalance;
            "Balance Due (LCY)" := "Balance Due (LCY)" + ldeDueBalance;
            Modify;
        end else begin
            "Balance (LCY)" := ldeBalance;
            "Balance Due (LCY)" := ldeDueBalance;
            Insert;
        end;
    end;


    procedure ShowCustStat(var lreCustomer: Record Customer)
    var
        lreCustLedgEntry: Record "Cust. Ledger Entry";
        lreRecStat: Record "Payment/Receivables Statistic" temporary;
    begin
        lreCustLedgEntry.SetCurrentkey("Customer No.");
        lreCustLedgEntry.SetRange("Customer No.", lreCustomer."No.");
        if lreCustomer.GetFilter("Global Dimension 1 Filter") <> '' then begin
            lreCustLedgEntry.SetFilter("Global Dimension 1 Code", lreCustomer.GetFilter("Global Dimension 1 Filter"));
            lreRecStat.SetFilter("Global Dimension 1 Filter", lreCustomer.GetFilter("Global Dimension 1 Filter"));
        end;
        if lreCustomer.GetFilter("Global Dimension 2 Filter") <> '' then begin
            lreCustLedgEntry.SetFilter("Global Dimension 2 Code", lreCustomer.GetFilter("Global Dimension 2 Filter"));
            lreRecStat.SetFilter("Global Dimension 2 Filter", lreCustomer.GetFilter("Global Dimension 2 Filter"));
        end;
        if lreCustomer.GetFilter("Currency Filter") <> '' then begin
            lreCustLedgEntry.SetFilter("Currency Code", lreCustomer.GetFilter("Currency Filter"));
            lreRecStat.SetFilter("Currency Filter", lreCustomer.GetFilter("Currency Filter"));
        end;
        if lreCustLedgEntry.Find('-') then begin
            repeat
                lreCustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                if lreCustLedgEntry."Remaining Amt. (LCY)" <> 0 then begin
                    lreRecStat.Type := lreRecStat.Type::Sales;
                    lreRecStat."Customer/Vendor No." := lreCustomer."No.";
                    lreRecStat."Document Type" := lreCustLedgEntry."Document Type";
                    //15-51643 - "Receivable Type" does not exist      lreRecStat."Receivable/Payable Type" := lreCustLedgEntry."Receivable Type";
                    lreRecStat.UpdateBuffer(lreCustLedgEntry."Remaining Amt. (LCY)", 0);
                end;
            until lreCustLedgEntry.Next() = 0;
            if lreCustomer.GetFilter("Date Filter") <> '' then begin
                lreCustLedgEntry.SetFilter("Date Filter", lreCustomer.GetFilter("Date Filter"));
                lreCustLedgEntry.SetFilter("Due Date", lreCustomer.GetFilter("Date Filter"));
                lreRecStat.SetFilter("Date Filter", lreCustomer.GetFilter("Date Filter"));
            end;
            if lreCustLedgEntry.Find('-') then begin
                repeat
                    lreCustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                    if lreCustLedgEntry."Remaining Amt. (LCY)" <> 0 then begin
                        lreRecStat.Type := lreRecStat.Type::Sales;
                        lreRecStat."Customer/Vendor No." := lreCustomer."No.";
                        lreRecStat."Document Type" := lreCustLedgEntry."Document Type";
                        //15-51643 - "Receivable Type" does not exist          lreRecStat."Receivable/Payable Type" := lreCustLedgEntry."Receivable Type";
                        lreRecStat.UpdateBuffer(0, lreCustLedgEntry."Remaining Amt. (LCY)");
                    end;
                until lreCustLedgEntry.Next() = 0;
            end;
        end;

        if Page.RunModal(0, lreRecStat) = Action::LookupOK then;
    end;


    procedure ShowVendStat(var lreVendor: Record Vendor)
    var
        lreVendLedgEntry: Record "Vendor Ledger Entry";
        lreRecStat: Record "Payment/Receivables Statistic" temporary;
    begin
        lreVendLedgEntry.SetCurrentkey("Vendor No.");
        lreVendLedgEntry.SetRange("Vendor No.", lreVendor."No.");
        if lreVendor.GetFilter("Global Dimension 1 Filter") <> '' then begin
            lreVendLedgEntry.SetFilter("Global Dimension 1 Code", lreVendor.GetFilter("Global Dimension 1 Filter"));
            lreRecStat.SetFilter("Global Dimension 1 Filter", lreVendor.GetFilter("Global Dimension 1 Filter"));
        end;
        if lreVendor.GetFilter("Global Dimension 2 Filter") <> '' then begin
            lreVendLedgEntry.SetFilter("Global Dimension 2 Code", lreVendor.GetFilter("Global Dimension 2 Filter"));
            lreRecStat.SetFilter("Global Dimension 2 Filter", lreVendor.GetFilter("Global Dimension 2 Filter"));
        end;
        if lreVendor.GetFilter("Currency Filter") <> '' then begin
            lreVendLedgEntry.SetFilter("Currency Code", lreVendor.GetFilter("Currency Filter"));
            lreRecStat.SetFilter("Currency Filter", lreVendor.GetFilter("Currency Filter"));
        end;
        if lreVendLedgEntry.Find('-') then begin
            repeat
                lreVendLedgEntry.CalcFields("Remaining Amt. (LCY)");
                if lreVendLedgEntry."Remaining Amt. (LCY)" <> 0 then begin
                    lreRecStat.Type := lreRecStat.Type::Purchase;
                    lreRecStat."Customer/Vendor No." := lreVendor."No.";
                    lreRecStat."Document Type" := lreVendLedgEntry."Document Type";
                    //15-51643 - "Payable Type" does not exist        lreRecStat."Receivable/Payable Type" := lreVendLedgEntry."Payable Type";
                    lreRecStat.UpdateBuffer(lreVendLedgEntry."Remaining Amt. (LCY)", 0);
                end;
            until lreVendLedgEntry.Next() = 0;
            if lreVendor.GetFilter("Date Filter") <> '' then begin
                lreVendLedgEntry.SetFilter("Date Filter", lreVendor.GetFilter("Date Filter"));
                lreVendLedgEntry.SetFilter("Due Date", lreVendor.GetFilter("Date Filter"));
                lreRecStat.SetFilter("Date Filter", lreVendor.GetFilter("Date Filter"));
            end;
            if lreVendLedgEntry.Find('-') then begin
                repeat
                    lreVendLedgEntry.CalcFields("Remaining Amt. (LCY)");
                    if lreVendLedgEntry."Remaining Amt. (LCY)" <> 0 then begin
                        lreRecStat.Type := lreRecStat.Type::Purchase;
                        lreRecStat."Customer/Vendor No." := lreVendor."No.";
                        lreRecStat."Document Type" := lreVendLedgEntry."Document Type";
                        //15-51643 - "Payable Type" does not exist        lreRecStat."Receivable/Payable Type" := lreVendLedgEntry."Payable Type";
                        lreRecStat.UpdateBuffer(0, lreVendLedgEntry."Remaining Amt. (LCY)");
                    end;
                until lreVendLedgEntry.Next() = 0;
            end;
        end;

        if Page.RunModal(0, lreRecStat) = Action::LookupOK then;
    end;
}
