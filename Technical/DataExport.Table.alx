Table 73000 "Data Export"
{
    Caption = 'Data Export';
    DataCaptionFields = "Code", Description;
    LookupPageID = "Data Exports";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnDelete()
    var
        DataExportRecordDefinition: Record "Data Export Record Definition";
    begin
        DataExportRecordDefinition.Reset;
        DataExportRecordDefinition.SetRange("Data Export Code", Code);
        DataExportRecordDefinition.DeleteAll(true);
    end;
}
