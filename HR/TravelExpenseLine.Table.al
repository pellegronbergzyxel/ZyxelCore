Table 50119 "Travel Expense Line"
{
    // 001. 16-10-20 ZY-LD 2020101510000192 - New field "Payer Payment Type".
    // 002. 27-08-21 ZY-LD 2021082610000058 - Employee is accepted.
    // 003. 17-01-22 ZY-LD 2021122110000497 - "Cash Advance" is added to type.
    // 004. 10-05-22 ZY-LD 2022050610000081 - New calculation of "Show Expense".
    // 005. 23-05-22 ZY-LD 2022052310000085 - New calculation of "Show Expense".
    // 006. 30-05-23 ZY-LD 6905495 - New fields.

    Caption = 'Travel Expense Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Travel Expense Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Business Purpose"; Text[80])
        {
            Caption = 'Business Purpose';
        }
        field(11; "Concur Sequence No."; Integer)
        {
            Caption = 'Concur Sequence No.';
        }
        field(12; "Debit / Credit Type"; Option)
        {
            Caption = 'Debit / Credit Type';
            OptionCaption = ' ,CR,DR';
            OptionMembers = " ",CR,DR;

            trigger OnValidate()
            begin
                Validate("Show Expense");  // 16-10-20 ZY-LD 001
            end;
        }
        field(13; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Company,Personal Expense,Out of Pocket,Cash Advance';
            OptionMembers = Company,"Personal Expense","Out of Pocket","Cash Advance";

            trigger OnValidate()
            begin
                Validate("Show Expense");  // 10-05-22 ZY-LD 004
            end;
        }
        field(14; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,,Vendor';
            OptionMembers = "G/L Account",,Vendor;
        }
        field(15; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Vendor)) Vendor;
            ValidateTableRelation = false;
        }
        field(16; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
        }
        field(17; "Vendor Description"; Text[50])
        {
            Caption = 'Vendor Description';
        }
        field(18; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(19; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(20; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,,Vendor,Bank';
            OptionMembers = "G/L Account",,Vendor,Bank;
        }
        field(21; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                               Blocked = const(false))
            else
            if ("Bal. Account Type" = const(Vendor)) Vendor;
            ValidateTableRelation = false;
        }
        field(22; "Division Code - Concur"; Code[20])
        {
            Caption = 'Division Code - Concur';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                "Division Code - Zyxel" := "Division Code - Concur";
            end;
        }
        field(23; "Department Code - Zyxel"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                "Department Code - Concur" := "Department Code - Zyxel";
            end;
        }
        field(25; "Original Amount"; Decimal)
        {
            Caption = 'Original Amount';

            trigger OnValidate()
            begin
                Amount := "Original Amount";
            end;
        }
        field(26; "Posting Date"; Date)
        {
            CalcFormula = lookup("Travel Expense Header"."Posting Date" where("No." = field("Document No.")));
            Caption = 'Posting Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
        field(28; "Division Code - Zyxel"; Code[20])
        {
            Caption = 'Division Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(29; "Purchasing Amount"; Decimal)
        {
            Caption = 'Purchasing Amount';
        }
        field(30; "Purchasing Currency Code"; Code[10])
        {
            Caption = 'Purchasing Currency Code';
        }
        field(31; "Expense Type"; Code[35])
        {
            Caption = 'Expense Type';
            TableRelation = "Travel Exp. Expense Type";
        }
        field(32; "Transaction Date"; Date)
        {
        }
        field(33; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            ValidateTableRelation = false;
        }
        field(34; "Posting Type"; Option)
        {
            CalcFormula = lookup("Travel Exp. Expense Type"."Posting Type" where(Code = field("Expense Type")));
            Caption = 'Posting Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'G/L Journal,Salary';
            OptionMembers = "G/L Journal",Salary;
        }
        field(35; "Car Business Distance"; Decimal)
        {
            BlankZero = true;
            Caption = 'Car Business Distance';
            DecimalPlaces = 0 : 2;
        }
        field(36; "Car Personal Distance"; Decimal)
        {
            BlankZero = true;
            Caption = 'Car Personal Distance';
            DecimalPlaces = 0 : 2;
        }
        field(37; "Vehicle Id"; Code[20])
        {
            Caption = 'Vehicle Id';
        }
        field(38; "Payer Payment Type"; Option)
        {
            Caption = 'Payer Payment Type';
            OptionCaption = ' ,Company,Master Card,VAT,TVA10,TVA20,Employee';
            OptionMembers = " ",Company,"Master Card",VAT,TVA10,TVA20,Employee;

            trigger OnValidate()
            begin
                Validate("Show Expense");  // 16-10-20 ZY-LD 001
            end;
        }
        field(39; "Show Expense"; Boolean)
        {
            Caption = 'Show Expense';

            trigger OnValidate()
            begin
                //>> 10-05-22 ZY-LD 004
                /*//>> 16-10-20 ZY-LD 001
                "Show Expense" :=
                  ("Debit / Credit Type" = "Debit / Credit Type"::DR) OR
                  ("Payer Payment Type" IN
                    ["Payer Payment Type"::Company,
                     "Payer Payment Type"::"Master Card",  //<< 16-10-20 ZY-LD 001
                     "Payer Payment Type"::Employee]);  // 27-08-21 ZY-LD 002*/

                //>> 23-05-22 ZY-LD 005
                /*"Show Expense" :=
                  ("Debit / Credit Type" = "Debit / Credit Type"::DR) OR
                  ("Payer Payment Type" IN ["Payer Payment Type"::Company,"Payer Payment Type"::"Master Card"]) OR
                  (("Payer Payment Type" = "Payer Payment Type"::Employee) AND (Type <> Type::"Out of Pocket"));*/
                //<< 10-05-22 ZY-LD 004

                "Show Expense" :=
                  ("Debit / Credit Type" = "debit / credit type"::DR) or
                  ("Payer Payment Type" in ["payer payment type"::Company, "payer payment type"::"Master Card"]) or
                  (("Payer Payment Type" = "payer payment type"::Employee) and ((Type <> Type::"Out of Pocket") and (Type <> Type::"Cash Advance")));
                //<< 23-05-22 ZY-LD 005

            end;
        }
        field(40; "Cost Type"; Code[20])
        {
            Caption = 'Cost Type';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                          Blocked = const(false));
        }
        field(41; "Milage is Sent to Salary"; Boolean)
        {
            Caption = 'Milage is Sent to Salary';
        }
        field(42; "Country Code"; Code[20])
        {
            Caption = 'Country Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));
        }
        field(43; "Department Code - Concur"; Code[20])
        {
            Caption = 'Department Code - Concur';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
        field(44; "Purpose of the Trip"; Text[30])  // 30-05-23 ZY-LD 006
        {
            Caption = 'Purpose of the Trip';
        }
        field(45; "From Location"; Text[100])  // 30-05-23 ZY-LD 006
        {
            Caption = 'From Location';
        }
        field(46; "To Location"; Text[100])  // 30-05-23 ZY-LD 006
        {
            Caption = 'To Location';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Bal. Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CurrExchRate: Record "Currency Exchange Rate";
}
