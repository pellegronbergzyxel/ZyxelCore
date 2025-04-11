tableextension 50004 ConfigPackageRecordZX extends "Config. Package Record"
{
    fields
    {
        field(50100; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Lookup("Config. Package Error"."Error Text" WHERE("Package Code" = FIELD("Package Code"), "Table ID" = FIELD("Table ID"), "Record No." = FIELD("No.")));
            Editable = false;
        }
    }
}
