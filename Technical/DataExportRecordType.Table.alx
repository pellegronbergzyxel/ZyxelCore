Table 73005 "Data Export Record Type"
{
    Caption = 'Data Export Record Type';
    LookupPageID = "Data Export Record Types";

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
        DataExportRecordDefinition.SetRange("Data Exp. Rec. Type Code", Code);
        if DataExportRecordDefinition.FindFirst then
            Error(MustNotDeleteErr, Code);
    end;

    var
        MustNotDeleteErr: label 'You must not delete the Data Export Record Type %1 if there exists a Data Export Record Definition for it.';
}
