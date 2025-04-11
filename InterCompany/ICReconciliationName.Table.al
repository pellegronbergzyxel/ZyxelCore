Table 50030 "IC Reconciliation Name"
{
    Caption = 'IC Reconciliation Name';
    LookupPageID = "IC Reconciliation Names";

    fields
    {
        field(1; "Reconciliation Template Name"; Code[10])
        {
            Caption = 'Reconciliation Template Name';
            NotBlank = true;
            TableRelation = "IC Reconciliation Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Reconciliation Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IcReconLine.SetRange("Reconciliation Template Name", "Reconciliation Template Name");
        IcReconLine.SetRange("Reconciliation Name", Name);
        IcReconLine.DeleteAll;
    end;

    trigger OnRename()
    begin
        IcReconLine.SetRange("Reconciliation Template Name", xRec."Reconciliation Template Name");
        IcReconLine.SetRange("Reconciliation Name", xRec.Name);
        while IcReconLine.FindFirst do
            IcReconLine.Rename("Reconciliation Template Name", Name, IcReconLine."Line No.");
    end;

    var
        IcReconLine: Record "IC Reconciliation Line";
}
