tableextension 50244 FinanceCueZX extends "Finance Cue"
{
    fields
    {
        field(50000; "Open Travel Expenses"; Integer)
        {
            CalcFormula = Count("Travel Expense Header" where("Document Status" = filter(<= Released)));
            Caption = 'Open Travel Expenses';
            Description = '29-05-20 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Items not Invoiced"; Integer)
        {
            CalcFormula = Count("Item Ledger Entry" where("Posting Date" = filter(010118 ..),
                                                          "Invoiced Quantity" = const(0)));
            Description = '13-08-20 ZY-LD 002';
            FieldClass = FlowField;
        }
        field(50002; Revenue; Decimal)
        {
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = filter('30050' .. '30600'),
                                                       "Related Company" = const(false),
                                                       "Posting Date" = field("Date Filter Revenue")));
            Caption = 'Revenue';
            Description = '01-09-20 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Revenue 2"; Decimal)
        {
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = filter('30050' .. '30600'),
                                                       "Related Company" = const(false),
                                                       "Posting Date" = field("Date Filter Revenue 2")));
            Caption = 'Revenue';
            Description = '01-09-20 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Date Filter Revenue"; Date)
        {
            Caption = 'Date Filter Revenue';
            Description = '01-09-20 ZY-LD 003';
            FieldClass = FlowFilter;
        }
        field(50005; "Date Filter Revenue 2"; Date)
        {
            Caption = 'Date Filter Revenue 2';
            Description = '01-09-20 ZY-LD 003';
            FieldClass = FlowFilter;
        }
        field(50008; "eCommerce Orders"; Integer)
        {
            CalcFormula = Count("eCommerce Order Header" where(Open = const(true)));
            Caption = 'eCommerce Orders';
            Description = '07-09-21 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "eCommerce Invoices"; Integer)
        {
            CalcFormula = Count("Sales Header" where("Document Type" = const(Invoice),
                                                      "eCommerce Order" = const(true)));
            Caption = 'eCommerce Invoices';
            Description = '07-09-21 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "eCommerce Cr. Memo"; Integer)
        {
            CalcFormula = Count("Sales Header" where("Document Type" = const("Credit Memo"),
                                                      "eCommerce Order" = const(true)));
            Caption = 'eCommerce Cr. Memo';
            Description = '07-09-21 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Whse. Purcase Resp. not Posted"; Integer)
        {
            CalcFormula = Count("Rcpt. Response Header" where(Open = const(true)));
            Caption = 'Whse. Purcase Response  not Posted';
            Description = '14-01-22 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Whse. Ship Resp. not Posted"; Integer)
        {
            CalcFormula = Count("Ship Response Header" where(Open = const(true)));
            Caption = 'Whse. Shipment Response not Posted';
            Description = '14-01-22 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
