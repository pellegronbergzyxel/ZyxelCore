Table 73004 "Data Export Table Relation"
{
    Caption = 'Data Export Table Relationship';
    DataCaptionFields = "Data Export Code", "Data Exp. Rec. Type Code";

    fields
    {
        field(1; "Data Export Code"; Code[10])
        {
            Caption = 'Data Export Code';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "Data Export".Code;
        }
        field(2; "Data Exp. Rec. Type Code"; Code[10])
        {
            Caption = 'Data Exp. Rec. Type Code';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "Data Export Record Type".Code;
        }
        field(3; "From Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'From Table No.';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(4; "From Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("From Table No.")));
            Caption = 'From Table Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "From Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'From Field No.';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Field."No." where(TableNo = field("From Table No."),
                                               Type = filter(Option | Text | Code | Integer | Decimal | Date | Boolean),
                                               Class = const(Normal));

            trigger OnLookup()
            begin
                FromField.Reset;
                FromField.FilterGroup(4);
                FromField.SetRange(TableNo, "From Table No.");
                FromField.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7',
                  FromField.Type::Option,
                  FromField.Type::Text,
                  FromField.Type::Code,
                  FromField.Type::Integer,
                  FromField.Type::Decimal,
                  FromField.Type::Date,
                  FromField.Type::Boolean);
                FromField.SetRange(Class, FromField.Class::Normal);
                FromField.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", FromField) = Action::LookupOK then
                    Validate("From Field No.", FromField."No.");
            end;

            trigger OnValidate()
            begin
                CalcFields("From Field Name");
            end;
        }
        field(6; "From Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("From Table No."),
                                                              "No." = field("From Field No.")));
            Caption = 'From Field Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "To Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'To Table No.';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(8; "To Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("To Table No.")));
            Caption = 'To Table Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "To Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'To Field No.';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Field."No." where(TableNo = field("To Table No."),
                                               Type = filter(Option | Text | Code | Integer | Decimal | Date | Boolean));

            trigger OnLookup()
            begin
                if "From Table No." = 0 then
                    Error(MustSpecifyErr, FieldCaption("From Table No."));

                if "From Field No." = 0 then
                    Error(MustSpecifyErr, FieldCaption("From Field No."));

                FromField.Get("From Table No.", "From Field No.");
                TestField("To Table No.");
                ToField.Reset;
                ToField.FilterGroup(4);
                ToField.SetRange(TableNo, "To Table No.");
                ToField.SetRange(Type, FromField.Type);
                ToField.SetRange(Class, FromField.Class);
                ToField.FilterGroup(0);
                if Page.RunModal(Page::"Fields Lookup", ToField) = Action::LookupOK then
                    Validate("To Field No.", ToField."No.");
            end;

            trigger OnValidate()
            begin
                CalcFields("To Field Name");
            end;
        }
        field(10; "To Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("To Table No."),
                                                              "No." = field("To Field No.")));
            Caption = 'To Field Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Data Export Code", "Data Exp. Rec. Type Code", "From Table No.", "From Field No.", "To Table No.", "To Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        FromField.Get("From Table No.", "From Field No.");
        ToField.Get("To Table No.", "To Field No.");
        if ToField.Type <> FromField.Type then
            Error(
              MustBeSameErr,
              FieldCaption("From Field No."),
              FromField.Type,
              FieldCaption("To Field No."),
              ToField.Type);
    end;

    var
        MustSpecifyErr: label 'You must specify %1.';
        MustBeSameErr: label 'Fields %1 (data type %2) and %3 (data type %4) should have same data type.';
        FromField: Record "Field";
        ToField: Record "Field";
}
