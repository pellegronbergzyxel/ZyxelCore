Table 75063 "Report Selections - Adv.Paym."
{
    //       //EZ4.20: Sales advanced payment;
    //       //EZ4.30: Purchase advanced payment;


    fields
    {
        field(1; Usage; Option)
        {
            Caption = 'Usage';
            OptionCaption = 'S.Adv.Payment,S.VAT Apply,S.VAT Cancel,P.Adv.Payment,P.VAT Apply,P.VAT Cancel';
            OptionMembers = "S.Adv.Payment","S.VAT Apply","S.VAT Cancel","P.Adv.Payment","P.VAT Apply","P.VAT Cancel";
        }
        field(2; Sequence; Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(3; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = Object.ID where(Type = const(Report));

            trigger OnValidate()
            begin
                CalcFields("Report Name");
            end;
        }
        field(4; "Report Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Report ID")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Usage, Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        greReportSelection2: Record "Report Selections - Adv.Paym.";


    procedure NewRecord()
    begin
        greReportSelection2.SetRange(Usage, Usage);
        if greReportSelection2.Find('+') and (greReportSelection2.Sequence <> '') then
            Sequence := IncStr(greReportSelection2.Sequence)
        else
            Sequence := '1';
    end;
}
