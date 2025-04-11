table 50123 "Customs Broker"
{
    Caption = 'Customs Broker';
    DataCaptionFields = "Code",Name;
    DrillDownPageID = "Customs Brokers";
    LookupPageID = "Customs Brokers";

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Name;Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Name)
        {
        }
    }
}