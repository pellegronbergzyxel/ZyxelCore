table 50059 "Substitute Report"
{
    Caption = 'Substitute Report';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Report Id"; Integer)
        {
            Caption = 'Report Id';
            BlankZero = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(2; "New Report Id"; Integer)
        {
            Caption = 'New Report Id';
            BlankZero = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(3; "Report Caption"; Text[250])
        {
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                          "Object ID" = field("Report Id")));
        }
        field(4; "New Report Caption"; Text[250])
        {
            Caption = 'New Report Caption';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                          "Object ID" = field("New Report Id")));
        }
        field(5; "New Report Name"; Text[250])
        {
            Caption = 'New Report Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Report),
                                                                       "Object ID" = field("New Report Id")));
        }
    }
    keys
    {
        key(PK; "Report Id")
        {
            Clustered = true;
        }
    }
}
