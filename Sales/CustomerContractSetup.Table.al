Table 50065 "Customer Contract Setup"
{
    Caption = 'Company Contract Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Folder Name"; Text[80])
        {
            Caption = 'Folder Name';

            trigger OnValidate()
            begin
                if CopyStr("Folder Name", StrLen("Folder Name") - 1, 1) <> '\' then
                    "Folder Name" += '\';

                "Folder Name (Test)" := StrSubstNo('%1\TEST\%2', CopyStr("Folder Name", 1, 21), CopyStr("Folder Name", 23, StrLen("Folder Name")));
            end;
        }
        field(3; "Serial No."; Code[10])
        {
            Caption = 'Serial No.';
            TableRelation = "No. Series";
        }
        field(4; "Folder Name (Test)"; Text[80])
        {
            Caption = 'Folder Name (Test)';

            trigger OnValidate()
            begin
                if CopyStr("Folder Name", StrLen("Folder Name") - 1, 1) <> '\' then
                    "Folder Name" += '\';
            end;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        FileMgt: Codeunit "File Management";
        SelectedFolder: Text;
}
