Table 61300 "Dimension Split Pct."
{
    Caption = 'Dimension Split Pct.';
    DataCaptionFields = "Dimension Code";
    DrillDownPageID = "Dimension Split Pct.";
    LookupPageID = "Dimension Split Pct.";

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
        }
        field(2; "Dimension Split Code"; Code[20])
        {
            Caption = 'Dimension Split Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
        }
        field(3; "Split %"; Decimal)
        {
            Caption = 'Split %';
            DecimalPlaces = 5 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(5; "Country Code"; Code[20])
        {
            Caption = 'Country Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('COUNTRY'));
        }
        field(6; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Cost Type Name,Division';
            OptionMembers = "Cost Type Name",Division;
        }
    }

    keys
    {
        key(Key1; "Dimension Code", "Dimension Split Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
