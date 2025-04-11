tableextension 50111 CustLedgerEntryZX extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; "External Order No."; Text[250])
        {
            Caption = 'External Order No.';
            Description = 'eCommerce';
        }
        field(50003; "Forecast Territory"; Code[20])
        {
            CalcFormula = lookup(Customer."Forecast Territory" where("No." = field("Sell-to Customer No.")));
            Caption = 'Forecast Territory';
            Description = '22-06-22 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Forecast Territory";
        }
        field(50004; "eCommerce Payment Relation"; Boolean)
        {
            CalcFormula = exist("eCommerce Payment" where("Sales Document Type" = field("Document Type"),
                                                        "Sales Document No." = field("Document No.")));
            Caption = 'eCommerce Payment Relation';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key50000; "Payment Reference")
        {
        }
    }
}
