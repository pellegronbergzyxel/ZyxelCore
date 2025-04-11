table 50088 "Customer Credit Limited"
{
    // // 13-10-17 ZY-LD 001 New field.
    // 002. 07-11-18 ZY-LD 2017121310000064 - New field.

    fields
    {
        field(1; Company; Code[20])
        {
            Caption = 'Company';
            Description = 'PAB 1.0';
        }
        field(2; Status; Option)
        {
            Caption = 'Status';
            Description = 'PAB 1.0';
            OptionCaption = 'OK,Investigate,Warning';
            OptionMembers = OK,Investigate,Warning;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Description = 'PAB 1.0';
        }
        field(5; "Credit Limit Sub (LCY)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Credit Limit Sub (LCY)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(6; "Balance Due Sub (LCY)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Balance Due Sub (LCY)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(7; "Outstanding Orders Sub (LCY)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Outstanding Orders Sub (LCY)';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(8; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Description = 'PAB 1.0';
        }
        field(9; Division; Code[20])
        {
            Caption = 'Division';
            Description = 'PAB 1.0';
        }
        field(10; Country; Code[20])
        {
            Caption = 'Country';
            Description = 'PAB 1.0';
        }
        field(11; Blocked; Enum "Customer Blocked")
        {
            Caption = 'Blocked';
            Description = 'PAB 1.0';
        }
        field(12; "Outstanding Orders RHQ (LCY)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Outstanding Orders RHQ (EUR)';
            Description = 'PAB 1.0';
        }
        field(50038; "Credit Limit Sub (EUR)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Credit Limit Sub (EUR)';
            DecimalPlaces = 2 : 2;
            Description = '07-11-18 ZY-LD 002';
        }
        field(50039; "Current Exchange Rate"; Decimal)
        {
            BlankZero = true;
            Caption = 'Current Exchange Rate';
            DecimalPlaces = 2 : 5;
            Description = '07-11-18 ZY-LD 002';
        }
        field(50040; "Balance Due Sub (EUR)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Balance Due Sub (EUR)';
            DecimalPlaces = 2 : 2;
            Description = '07-11-18 ZY-LD 002';
        }
        field(50041; "Balance Due + Outstanding EUR"; Decimal)
        {
            BlankZero = true;
            Caption = 'Balance Due + Outstanding (EUR)';
            Description = '07-11-18 ZY-LD 002';
        }
        field(55033; Category; Option)
        {
            Caption = 'Category';
            Description = 'PAB 1.0';
            OptionCaption = 'Not Set,A: Minor risk of co-operation,B: Medium risk at co-operation,C: High risk at co-operation,D: Very high risk at co-operation';
            OptionMembers = "Not Set","A: Minor risk of co-operation","B: Medium risk at co-operation","C: High risk at co-operation","D: Very high risk at co-operation";
        }
        field(55034; Tier; Code[10])
        {
            Caption = 'Tier';
            Description = 'PAB 1.0';
        }
        field(55035; "Balance Due + Outstanding LCY"; Decimal)
        {
            BlankZero = true;
            Caption = 'Balance Due + Outstanding LCY';
            Description = 'PAB 1.0';
        }
        field(55036; "Payment Terms"; Text[50])
        {
            Caption = 'Payment Terms';
            Description = '13-10-17 ZY-LD 001';
        }
        field(55037; "Cust. Only Created in Sub"; Boolean)
        {
            Caption = 'Customer Only Created in Sub';
            Description = '13-10-17 ZY-LD 001';
        }
    }

    keys
    {
        key(Key1; "Customer No.", Company)
        {
            Clustered = true;
        }
    }
}
