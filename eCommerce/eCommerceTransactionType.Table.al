table 50037 "eCommerce Transaction Type"
{
    Caption = 'eCommerce Transaction Type';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "eComm. Transaction Type List";
    LookupPageID = "eComm. Transaction Type List";

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}
