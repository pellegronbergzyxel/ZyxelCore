Table 73001 "Data Export Record Definition"
{
    Caption = 'Data Export Record Definition';
    DataCaptionFields = "Data Export Code", "Data Exp. Rec. Type Code";
    LookupPageID = "Data Export Record Definitions";

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

            trigger OnValidate()
            var
                DataExportRecordType: Record "Data Export Record Type";
            begin
                if DataExportRecordType.Get("Data Exp. Rec. Type Code") and (Description = '') then
                    Description := DataExportRecordType.Description;
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
        field(4; "Export Path"; Text[250])
        {
            Caption = 'Export Path';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin

                if ("Export Path" <> '') and not FileMgt.ServerDirectoryExists("Export Path") then
                    if Confirm(CreateFolderQst, true, "Export Path") then
                        FileMgt.ServerCreateDirectory("Export Path");
            end;
        }
        field(5; "DTD File Name"; Text[50])
        {
            Caption = 'DTD File Name';
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(6; "DTD File"; Blob)
        {
            Caption = 'DTD File';
            Description = 'PAB 1.0';
        }
        field(50000; "Export Language"; Option)
        {
            Caption = 'Export Language';
            OptionMembers = English,German;
        }
    }

    keys
    {
        key(Key1; "Data Export Code", "Data Exp. Rec. Type Code")
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
    begin
        DataExportRecordSource.Reset;
        DataExportRecordSource.SetRange("Data Export Code", "Data Export Code");
        DataExportRecordSource.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
        DataExportRecordSource.DeleteAll(true);
    end;

    trigger OnRename()
    begin
        Error(MustRenameErr, TableCaption);
    end;

    var
        MustRenameErr: label 'You must not rename a %1.';
        CreateFolderQst: label 'Do you want to create the folder %1?';
        FileMgt: Codeunit "File Management";
        NotFirstFieldMsg: label 'The %1 field is not the first field that is specified for the %2 table. You must change the data export setup to list the primary key field first.';
        CannotIncludePeriodFieldMsg: label 'You cannot include the period field %1 in the table filter expression for the %2 table.';
        ValidatedCorrectlyMsg: label 'The data export record source validated correctly.';


    procedure ValidateExportSources()
    var
        DataExportRecordSource: Record "Data Export Record Source";
        DataExportRecordField: Record "Data Export Record Field";
        KeyBuffer: Record "Key Buffer";
        "Field": Record "Field";
        KeyArray: array[20] of Text[250];
        PrimaryKeyText: Text[250];
        ErrorsFound: Boolean;
        IsPrimary: Boolean;
        IsKey: Boolean;
        ShowMessage: Boolean;
        Count1: Integer;
        Count2: Integer;
        i: Integer;
        NoOfComma: Integer;
    begin
        ErrorsFound := false;

        DataExportRecordSource.Reset;
        DataExportRecordSource.SetRange("Data Export Code", "Data Export Code");
        DataExportRecordSource.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
        UpdateRecordSources(DataExportRecordSource);
        if DataExportRecordSource.FindSet then
            repeat
                Count1 := 0;
                i := 1;
                NoOfComma := 0;
                PrimaryKeyText := '';
                FillKeyBuffer(DataExportRecordSource."Table No.", KeyBuffer);
                if KeyBuffer.FindFirst then begin
                    PrimaryKeyText := KeyBuffer.Key;
                    repeat
                        KeyArray[i] := SelectStr(1, PrimaryKeyText);
                        i := i + 1;
                        NoOfComma := StrPos(PrimaryKeyText, ',');
                        PrimaryKeyText := CopyStr(PrimaryKeyText, NoOfComma + 1, MaxStrLen(PrimaryKeyText));
                        Count1 := Count1 + 1;
                    until NoOfComma = 0;
                    Count2 := Count1;
                end;

                i := 1;
                IsKey := true;
                IsPrimary := true;
                ShowMessage := true;
                DataExportRecordField.Reset;
                DataExportRecordField.SetRange("Data Export Code", "Data Export Code");
                DataExportRecordField.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
                DataExportRecordField.SetRange("Table No.", DataExportRecordSource."Table No.");
                DataExportRecordField.SetRange("Source Line No.", DataExportRecordSource."Line No.");
                if DataExportRecordField.FindSet then
                    repeat
                        repeat
                            DataExportRecordField.CalcFields("Table Name", "Field Name");
                            Field.Reset;
                            Field.SetRange(TableNo, DataExportRecordField."Table No.");
                            Field.SetRange("No.", DataExportRecordField."Field No.");
                            Field.FindFirst;
                            if KeyArray[i] = Field.FieldName then begin
                                if IsPrimary and not IsKey and ShowMessage then begin
                                    ErrorsFound := true;
                                    Message(NotFirstFieldMsg, DataExportRecordField."Field Name", DataExportRecordField."Table Name");
                                    ShowMessage := false;
                                end else begin
                                    IsPrimary := true;
                                    IsKey := true;
                                end;
                                Count1 := 0;
                            end else begin
                                i := i + 1;
                                Count1 := Count1 - 1;
                                if Count1 = 0 then
                                    IsKey := false;
                            end;
                        until Count1 = 0;
                        i := 1;
                        Count1 := Count2;
                    until DataExportRecordField.Next() = 0;

                if DataExportRecordSource.IsPeriodFieldInTableFilter then begin
                    ErrorsFound := true;
                    DataExportRecordSource.CalcFields("Table Name");
                    Message(CannotIncludePeriodFieldMsg, DataExportRecordSource."Period Field Name", DataExportRecordSource."Table Name");
                end;

            until DataExportRecordSource.Next() = 0;

        if not ErrorsFound then
            Message(ValidatedCorrectlyMsg);
    end;


    procedure FillKeyBuffer(TableNo: Integer; var KeyBuffer: Record "Key Buffer")
    var
        "Key": Record "Key";
    begin
        KeyBuffer.DeleteAll;
        Key.Reset;
        Key.SetRange(TableNo, TableNo);
        if Key.FindSet then
            repeat
                KeyBuffer.Init;
                KeyBuffer."Table No" := Key.TableNo;
                KeyBuffer."Field No." := Key."No.";
                KeyBuffer.Key := CopyStr(Key.Key, 1, 250);
                KeyBuffer.Insert;
            until Key.Next() = 0;
    end;


    procedure ImportFile(DataExportRecordDefinition: Record "Data Export Record Definition")
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        FileName: Text;
        RecRef: RecordRef;
    begin
        FileName := FileMgt.BLOBImport(TempBlob, FileName);
        if FileName = '' then
            exit;
        while StrPos(FileName, '\') <> 0 do
            FileName := CopyStr(FileName, StrPos(FileName, '\') + 1);
        with DataExportRecordDefinition do begin
            "DTD File Name" := CopyStr(FileName, 1, MaxStrLen("DTD File Name"));
            RecRef.GetTable(DataExportRecordDefinition);
            TempBlob.ToRecordRef(RecRef, DataExportRecordDefinition.FieldNo("DTD File"));
            CalcFields("DTD File");
            Modify;
        end;
    end;


    procedure ExportFile(DataExportRecordDefinition: Record "Data Export Record Definition"; ShowDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        ToFile: Text;
        RecRef: RecordRef;
    begin
        with DataExportRecordDefinition do begin
            CalcFields("DTD File");
            if "DTD File".Hasvalue or not ShowDialog then begin
                TempBlob.FromRecord(DataExportRecordDefinition, DataExportRecordDefinition.FieldNo("DTD File"));
                ToFile := FileMgt.BLOBExport(TempBlob, "DTD File Name", ShowDialog);
                exit(ToFile);
            end;
        end;
        exit('');
    end;

    local procedure UpdateRecordSources(var DataExportRecordSource: Record "Data Export Record Source")
    var
        ParentLineNo: array[100] of Integer;
    begin
        if DataExportRecordSource.FindSet then
            repeat
                if DataExportRecordSource.Indentation > 0 then
                    DataExportRecordSource."Relation To Line No." := ParentLineNo[DataExportRecordSource.Indentation];

                if UpdateFields(DataExportRecordSource) then
                    DataExportRecordSource."Date Filter Handling" := FindDateFilterHandling(DataExportRecordSource);
                DataExportRecordSource.Modify;

                ParentLineNo[DataExportRecordSource.Indentation + 1] := DataExportRecordSource."Line No.";
            until DataExportRecordSource.Next() = 0;
    end;

    local procedure FindDateFilterHandling(DataExportRecordSource: Record "Data Export Record Source"): Integer
    var
        TableFilterPage: Page "Table Filter";
        TempTableFilter: Record "Table Filter";
        DataExportRecordField: Record "Data Export Record Field";
        TableFilterText: Text;
    begin
        with DataExportRecordSource do begin
            TableFilterText := Format("Table Filter");
            if TableFilterText <> '' then begin
                TableFilterPage.SetSourceTable(TableFilterText, "Table No.", "Table Name");
                TableFilterPage.GetFilterFieldsList(TempTableFilter);
                if TempTableFilter.FindSet then
                    repeat
                        DataExportRecordField.SetRange("Data Export Code", "Data Export Code");
                        DataExportRecordField.SetRange("Data Exp. Rec. Type Code", "Data Exp. Rec. Type Code");
                        DataExportRecordField.SetRange("Table No.", "Table No.");
                        DataExportRecordField.SetRange("Field No.", TempTableFilter."Field Number");
                        DataExportRecordField.SetRange("Field Class", DataExportRecordField."field class"::FlowField);
                        if DataExportRecordField.FindFirst then
                            exit(DataExportRecordField."Date Filter Handling");
                    until TempTableFilter.Next() = 0;
            end;
        end;
    end;

    local procedure UpdateFields(DataExportRecordSource: Record "Data Export Record Source") Updated: Boolean
    var
        DataExportRecordField: Record "Data Export Record Field";
        NewDataExportRecordField: Record "Data Export Record Field";
    begin
        with DataExportRecordField do begin
            SetRange("Data Export Code", DataExportRecordSource."Data Export Code");
            SetRange("Data Exp. Rec. Type Code", DataExportRecordSource."Data Exp. Rec. Type Code");
            SetRange("Table No.", DataExportRecordSource."Table No.");
            SetRange("Source Line No.", 0);
            if FindSet then begin
                repeat
                    NewDataExportRecordField := DataExportRecordField;
                    NewDataExportRecordField."Source Line No." := DataExportRecordSource."Line No.";
                    NewDataExportRecordField.Validate("Field No.");
                    NewDataExportRecordField.Insert;
                until Next = 0;
                DeleteAll;
                Updated := true;
            end;
        end;
    end;
}

