table 50044 "eCommerce Payment Amount Type"
{
    Caption = 'eCommerce Payment Amount Type';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "eComm. Pay. Amount Type List";
    LookupPageID = "eComm. Pay. Amount Type List";

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
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}
