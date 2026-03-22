Table 73002 "Data Export Record Source"
{
    Caption = 'Data Export Record Source';
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
            Caption = 'Data Export Record Type Code';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "Data Export Record Type".Code;
        }
        field(3; "Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Table No.';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Object.ID where(Type = const(Table));

            trigger OnValidate()
            begin
                TestField("Table No.");
                if (xRec."Table No." <> 0) and (xRec."Table No." <> "Table No.") then
                    Error(CannotModifyErr, FieldCaption("Table No."));

                CalcFields("Table Name");
                Validate("Export Table Name", "Table Name");
                FindDataFilterField;
            end;
        }
        field(4; "Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Indentation; Integer)
        {
            Caption = 'Indentation';
            Description = 'PAB 1.0';
            MinValue = 0;

            trigger OnValidate()
            var
                DataExportManagement: Codeunit "Data Export Management";
            begin
                if Indentation <> xRec.Indentation then
                    DataExportManagement.UpdateSourceIndentation(Rec, xRec.Indentation);
            end;
        }
        field(6; "Fields Selected"; Boolean)
        {
            CalcFormula = exist("Data Export Record Definition" where("Data Export Code" = field("Data Export Code"),
                                                                       "Data Exp. Rec. Type Code" = field("Data Exp. Rec. Type Code")));
            Caption = 'Fields Selected';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Relation To Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Relation To Table No.';
            Description = 'PAB 1.0';
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(8; "Relation To Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Relation To Table No.")));
            Caption = 'Relation To Table Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Period Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Period Field No.';
            Description = 'PAB 1.0';
            TableRelation = Field."No." where(TableNo = field("Table No."),
                                               Type = filter(Date),
                                               Class = const(Normal));

            trigger OnLookup()
            var
                "Field": Record "Field";
            begin
                TestField("Table No.");
                Field.SetRange(TableNo, "Table No.");
                Field.SetRange(Type, Field.Type::Date);
                Field.SetRange(Class, Field.Class::Normal);
                if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then
                    Validate("Period Field No.", Field."No.");
            end;

            trigger OnValidate()
            begin
                CheckPeriodFieldInTableFilter;
            end;
        }
        field(10; "Period Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."),
                                                              "No." = field("Period Field No.")));
            Caption = 'Period Field Name';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Table Relation Defined"; Boolean)
        {
            CalcFormula = exist("Data Export Table Relation" where("Data Export Code" = field("Data Export Code"),
                                                                    "Data Exp. Rec. Type Code" = field("Data Exp. Rec. Type Code"),
                                                                    "To Table No." = field("Table No."),
                                                                    "From Table No." = field("Relation To Table No.")));
            Caption = 'Table Relation Defined';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'PAB 1.0';
        }
        field(13; "Export File Name"; Text[250])
        {
            Caption = 'Export File Name';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                FileMgt: Codeunit "File Management";
            begin
                TestField("Export File Name");
                if not FileMgt.IsValidFileName("Export File Name") then
                    Error(NotValidFileNameErr, "Export File Name");
                "Export File Name" :=
                  CopyStr(FindUniqueName("Export File Name", FieldNo("Export File Name"), '.txt'), 1, MaxStrLen("Export File Name"));
            end;
        }
        field(14; "Relation To Line No."; Integer)
        {
            Caption = 'Relation To Line No.';
            Description = 'PAB 1.0';
        }
        field(30; "Table Filter"; TableFilter)
        {
            Caption = 'Table Filter';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                CheckPeriodFieldInTableFilter;
            end;
        }
        field(31; "Key No."; Integer)
        {
            Caption = 'Key No.';
            Description = 'PAB 1.0';

            trigger OnLookup()
            var
                "Key": Record "Key";
                DataExportTableKeys: Page "Data Export Table Keys";
            begin
                TestField("Table No.");
                Clear(DataExportTableKeys);
                if "Key No." <> 0 then begin
                    Key.Get("Table No.", "Key No.");
                    DataExportTableKeys.SetRecord(Key);
                end;
                Key.SetRange(TableNo, "Table No.");
                Key.SetRange(Enabled, true);
                DataExportTableKeys.SetTableview(Key);
                DataExportTableKeys.LookupMode := true;
                if DataExportTableKeys.RunModal = Action::LookupOK then begin
                    DataExportTableKeys.GetRecord(Key);
                    Validate("Key No.", Key."No.");
                end;
            end;

            trigger OnValidate()
            var
                "Key": Record "Key";
            begin
                if "Key No." <> 0 then begin
                    TestField("Table No.");
                    Key.Get("Table No.", "Key No.");
                end;
                if ("Key No." <> 0) and (xRec."Key No." <> "Key No.") then
                    FindSeqNumberAmongActiveKeys;
            end;
        }
        field(32; "Date Filter Field No."; Integer)
        {
            Caption = 'Date Filter Field No.';
            Description = 'PAB 1.0';
            TableRelation = Field."No." where(TableNo = field("Table No."),
                                               Type = const(Date),
                                               Class = const(FlowFilter));
        }
        field(33; "Date Filter Handling"; Option)
        {
            Caption = 'Date Filter Handling';
            Description = 'PAB 1.0';
            OptionCaption = ' ,Period,End Date Only,Start Date Only';
            OptionMembers = " ",Period,"End Date Only","Start Date Only";
        }
        field(41; "Active Key Seq. No."; Integer)
        {
            Caption = 'Active Key Seq. No.';
            Description = 'PAB 1.0';
        }
        field(50; "Export Table Name"; Text[80])
        {
            Caption = 'Export Table Name';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                DataExportManagement: Codeunit "Data Export Management";
            begin
                "Export Table Name" :=
                  CopyStr(
                    FindUniqueName(DataExportManagement.FormatForIndexXML("Export Table Name"), FieldNo("Export Table Name"), ''),
                    1, MaxStrLen("Export Table Name"));
                TestField("Export Table Name");
                Validate("Export File Name", "Export Table Name" + '.txt');
            end;
        }
    }

    keys
    {
        key(Key1; "Data Export Code", "Data Exp. Rec. Type Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DataExportRecordSource: Record "Data Export Record Source";
        DataExportTableRelation: Record "Data Export Table Relation";
        DataExportRecordField: Record "Data Export Record Field";
    begin
        DataExportRecordField.Reset;
        DataExportRecordField.SetRange("Data Export Code", "Data Export Code");
        DataExportRecordField.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
        DataExportRecordField.SetRange("Source Line No.", "Line No.");
        DataExportRecordField.DeleteAll;

        if "Relation To Line No." <> 0 then begin
            DataExportTableRelation.Reset;
            DataExportTableRelation.SetRange("Data Export Code", "Data Export Code");
            DataExportTableRelation.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
            DataExportTableRelation.SetRange("To Table No.", "Table No.");
            if DataExportTableRelation.FindSet then
                repeat
                    if not DoesExistDuplicateSourceLine then
                        DataExportTableRelation.Delete;
                until DataExportTableRelation.Next() = 0;
        end;

        DataExportRecordSource.Reset;
        DataExportRecordSource.SetRange("Data Export Code", "Data Export Code");
        DataExportRecordSource.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
        DataExportRecordSource.SetRange("Relation To Line No.", "Line No.");
        DataExportRecordSource.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        TestField("Table No.");
        TestField("Export Table Name");
        TestField("Export File Name");
    end;

    trigger OnModify()
    begin
        TestField("Table No.");
        TestField("Export Table Name");
        TestField("Export File Name");
    end;

    trigger OnRename()
    begin
        Error(CannotRenameErr, TableCaption);
    end;

    var
        CannotModifyErr: label 'You cannot modify the %1 field.';
        CannotRenameErr: label 'You cannot rename a %1.';
        NotValidFileNameErr: label '%1 is not a valid file name.';
        CannotUsePeriodFieldErr: label 'You cannot use the period field %1 in the table filter.';

    local procedure GetAllNamesExceptCurrent(FieldId: Integer) AllNames: Text
    var
        DataExportRecordSource: Record "Data Export Record Source";
    begin
        DataExportRecordSource.Reset;
        DataExportRecordSource.SetRange("Data Export Code", "Data Export Code");
        DataExportRecordSource.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
        DataExportRecordSource.SetFilter("Line No.", '<>%1', "Line No.");
        if DataExportRecordSource.FindSet then
            repeat
                case FieldId of
                    DataExportRecordSource.FieldNo("Export File Name"):
                        AllNames += DataExportRecordSource."Export File Name" + ';';
                    DataExportRecordSource.FieldNo("Export Table Name"):
                        AllNames += DataExportRecordSource."Export Table Name" + ';';
                end;
            until DataExportRecordSource.Next() = 0;
    end;

    local procedure FindUniqueName(Name: Text; FieldId: Integer; Suffix: Text): Text
    var
        AllNames: Text;
        IsUnique: Boolean;
        ShortName: Text;
    begin
        AllNames := GetAllNamesExceptCurrent(FieldId);
        if StrPos(Lowercase(AllNames), Lowercase(Name)) = 0 then
            exit(Name);

        IsUnique := false;
        if Suffix = '' then
            ShortName := Name + '1'
        else
            ShortName := CopyStr(Name, 1, StrPos(Lowercase(Name), '.')) + '1';
        repeat
            Name := ShortName + Suffix;
            IsUnique := StrPos(Lowercase(AllNames), Lowercase(Name)) = 0;
            ShortName := IncStr(ShortName);
        until IsUnique;
        exit(Name);
    end;


    procedure FindSeqNumberAmongActiveKeys()
    var
        RecRef: RecordRef;
        KeyRef: KeyRef;
        KeyCounter: Integer;
        ActiveKeyCounter: Integer;
    begin
        if "Table No." <> 0 then begin
            RecRef.Open("Table No.");
            ActiveKeyCounter := 0;
            for KeyCounter := 1 to RecRef.KeyCount do begin
                KeyRef := RecRef.KeyIndex(KeyCounter);
                if KeyRef.Active then
                    ActiveKeyCounter += 1;
                if "Key No." = KeyCounter then
                    "Active Key Seq. No." := ActiveKeyCounter;
            end;
        end;
    end;


    procedure IsPeriodFieldInTableFilter(): Boolean
    var
        TableFilterText: Text;
    begin
        if "Period Field No." = 0 then
            exit(false);

        Evaluate(TableFilterText, Format("Table Filter"));
        if TableFilterText = '' then
            exit(false);

        CalcFields("Period Field Name");
        exit(StrPos(TableFilterText, "Period Field Name" + '=') <> 0);
    end;

    local procedure CheckPeriodFieldInTableFilter()
    begin
        if IsPeriodFieldInTableFilter then
            Error(CannotUsePeriodFieldErr, "Period Field Name");
    end;


    procedure FindDataFilterField()
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo, "Table No.");
        Field.SetRange(Type, Field.Type::Date);
        Field.SetRange(Class, Field.Class::FlowFilter);
        if Field.Count = 1 then begin
            Field.FindFirst;
            "Date Filter Field No." := Field."No.";
        end;
    end;

    local procedure DoesExistDuplicateSourceLine(): Boolean
    var
        DataExportRecordSource: Record "Data Export Record Source";
    begin
        DataExportRecordSource.Reset;
        DataExportRecordSource.SetRange("Data Export Code", "Data Export Code");
        DataExportRecordSource.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
        DataExportRecordSource.SetFilter("Line No.", '<>%1', "Line No.");
        DataExportRecordSource.SetRange("Table No.", "Table No.");
        exit(not DataExportRecordSource.IsEmpty);
    end;
}
