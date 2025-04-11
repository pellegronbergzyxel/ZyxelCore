Table 50028 "IC Reconciliation Template"
{
    Caption = 'IC Reconciliation Template';
    LookupPageID = "IC Reconciliation Templ. List";

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(6; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Page));

            trigger OnValidate()
            begin
                if "Page ID" = 0 then
                    "Page ID" := Page::"IC Reconciliation";
                "IC Reconciliation Report ID" := Report::"IC Reconciliation";
            end;
        }
        field(7; "IC Reconciliation Report ID"; Integer)
        {
            Caption = 'IC Reconciliation Report ID';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));
        }
        field(16; "Page Caption"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Page),
                                                                           "Object ID" = field("Page ID")));
            Caption = 'Page Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "IC Recon Report Caption"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("IC Reconciliation Report ID")));
            Caption = 'IC Reconciliation Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IcReconLine.SetRange("Reconciliation Template Name", Name);
        IcReconLine.DeleteAll;
        IcReconName.SetRange("Reconciliation Template Name", Name);
        IcReconName.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Page ID");
    end;

    var
        IcReconName: Record "IC Reconciliation Name";
        IcReconLine: Record "IC Reconciliation Line";
}
