Table 60009 "Replication Company"
{
    // 001. 30-11-18 ZY-LD 000 - Replicate E-mail Address.
    // 002. 06-12-18 ZY-LD 000 - New field.
    // 003. 07-02-19 ZY-LD 2019020610000093 - New field.
    // 004. 21-05-19 ZY-LD 000 - ValidateTableRelation is set to No on "Company Name".

    Caption = 'Replication Company';
    DataCaptionFields = "Company Name";
    DrillDownPageID = "Replication Setup";
    LookupPageID = "Replication Setup";

    fields
    {
        field(1; "Company Name"; Text[30])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = Company;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Save XML File"; Boolean)
        {
        }
        field(11; "Replicate Customer"; Boolean)
        {
            Caption = 'Replicate Customer';
        }
        field(12; "Replicate Item"; Boolean)
        {
            Caption = 'Replicate Item';
        }
        field(13; "Replicate Chart of Account"; Boolean)
        {
            Caption = 'Replicate Chart of Account';
        }
        field(14; "Country/Region Code"; Code[50])
        {
            TableRelation = "Country/Region";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(15; "Customer Credit Limit"; Boolean)
        {
            Caption = 'Customer Credit Limit';
        }
        field(16; "Replicate E-mail Address"; Boolean)
        {
            Caption = 'Replicate E-mail Address';
            Description = '30-11-18 ZY-LD 001';
        }
        field(17; "Replicate User Setup"; Boolean)
        {
            Caption = 'Replicate User Setup';
            Description = '06-12-18 ZY-LD 002';
        }
        field(18; "Company Information"; Boolean)
        {
            Caption = 'Company Information';
        }
        field(19; "Replicate Cost Type Name"; Boolean)
        {
            Caption = 'Replicate Cost Type Name';
            Description = '07-02-19 ZY-LD 003';
        }
        field(20; "Get End Cust. Sales Inv. No."; Boolean)
        {
            Caption = 'Get End Customer Sales Invoice No.';
        }
        field(21; "Replicate Exchange Rate"; Option)
        {
            Caption = 'Replicate Exchange Rate';
            OptionCaption = ' ,Yes,No,Never';
            OptionMembers = " ",Yes,No,Never;

            trigger OnValidate()
            begin
                if (xRec."Replicate Exchange Rate" = "replicate exchange rate"::Never) and
                   ("Replicate Exchange Rate" > "replicate exchange rate"::" ")
                then
                    "Replicate Exchange Rate" := xRec."Replicate Exchange Rate";
            end;
        }
        field(22; "Get Concur Vendor"; Option)
        {
            Caption = 'Get Concur Vendor';
            OptionCaption = ' ,Yes,No,Never';
            OptionMembers = " ",Yes,No,Never;
        }
        field(23; "Travel Expense E-mail Address"; Code[10])
        {
            Caption = 'Travel Expense E-mail Address';
            TableRelation = "E-mail address";
        }
        field(24; "Concur Vendor Sequence"; Integer)
        {
            BlankZero = true;
            Caption = 'Sequence';
            InitValue = 999;
        }
        field(25; "HQ Account Payable Details"; Boolean)
        {
            Caption = 'HQ Account Payable Details';
        }
        field(26; "HQ Account Receivable Details"; Boolean)
        {
            Caption = 'HQ Account Receivable Details';
        }
        field(27; "Download HQ Sales Document"; Boolean)
        {
            Caption = 'Download HQ Sales Document';
        }
        field(28; "HQ Account Receivable WebSrv."; Boolean)
        {
            Caption = 'HQ Account Receivable Web Service';
        }
        field(29; "SII Spain"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Company Name")
        {
            Clustered = true;
        }
        key(Key2; "Concur Vendor Sequence")
        {
        }
    }

    fieldgroups
    {
    }
}
