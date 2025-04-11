Table 50081 "Use of Report Entry"
{
    Caption = 'Use of Report Entry';
    DataPerCompany = false;
    DrillDownPageID = "Use of Report Entries";
    LookupPageID = "Use of Report Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionCaption = 'TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber';
            OptionMembers = TableData,"Table",,"Report",,"Codeunit","XMLport",MenuSuite,"Page","Query",System,FieldNumber;
        }
        field(4; "Object Id"; Integer)
        {
            Caption = 'Object Id';
        }
        field(5; "User Id"; Code[50])
        {
            Caption = 'User Id';
        }
        field(6; Date; DateTime)
        {
            Caption = 'Date';
        }
        field(7; "Report Type"; Option)
        {
            Caption = 'Report Type';
            OptionCaption = ' ,Report,Processing Only,Excel,Usable (but unused),Document,Page';
            OptionMembers = " ","Report","Processing Only",Excel,"Usable (but unused)",Document,"Page";
        }
        field(8; "Object Description"; Text[30])
        {
            CalcFormula = lookup(Object.Name where(Type = field("Object Type"),
                                                    ID = field("Object Id")));
            Caption = 'Object Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Month; Integer)
        {
            Caption = 'Month';
            MaxValue = 12;
            MinValue = 1;
        }
        field(10; Year; Integer)
        {
            Caption = 'Year';
        }
        field(11; Quantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(12; "Object Description 2"; Text[30])
        {
            Caption = 'Object Description';
        }
        field(13; "Real Object Name"; Text[50])
        {
            CalcFormula = lookup(AllObj."Object Name" where("Object Type" = const(Report),
                                                             "Object ID" = field("Object Id")));
            Caption = 'Real Object Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Company Name", "Object Type", "Object Id", "User Id", Month, Year)
        {
        }
    }

    fieldgroups
    {
    }
}
