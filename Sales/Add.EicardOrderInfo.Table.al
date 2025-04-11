Table 50035 "Add. Eicard Order Info"
{
    Caption = 'Add. Eicard Order Info';
    DataCaptionFields = "Document Type", "Document No.", "Sales Line Line No.", "Line No.";
    DrillDownPageID = "Add. Eicard Order Info";
    LookupPageID = "Add. Eicard Order Info";

    fields
    {
        field(1; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." where("Document Type" = field("Document Type"));
        }
        field(3; "Sales Line Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; Validated; Boolean)
        {
        }
        field(11; "EMS Machine Code"; Code[35])
        {

            trigger OnValidate()
            begin
                Validated := "EMS Machine Code" <> '';
            end;
        }
        field(12; "GLC Serial No."; Code[20])
        {
            Caption = 'GLC Serial No.';

            trigger OnValidate()
            begin
                Validated := ("GLC Serial No." <> '') and ("GLC Mac Address" <> '');
            end;
        }
        field(13; "GLC Mac Address"; Code[20])
        {
            Caption = 'GLC Mac Address';

            trigger OnValidate()
            begin
                Validated := ("GLC Serial No." <> '') and ("GLC Mac Address" <> '');
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Sales Line Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
