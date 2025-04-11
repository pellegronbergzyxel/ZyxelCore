table 50060 "eComm. Pay. Amount Descript."
{
    Caption = 'eCommerce Pay. Amount Descript.';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "eComm. Pay Amount Desc. List";
    LookupPageID = "eComm. Pay Amount Desc. List";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[250])
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
