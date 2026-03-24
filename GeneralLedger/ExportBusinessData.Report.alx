Report 50100 "Export Business Data"
{
    // 001. 15-12-21 ZY-LD 2021121310000038 - Decimal and dates are changed to xml-format. Language is selectable to get the correct caption for optionfields.

    Caption = 'Export Business Data';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Data Export Record Definition"; "Data Export Record Definition")
        {
            DataItemTableView = sorting("Data Export Code", "Data Exp. Rec. Type Code");
            RequestFilterFields = "Data Export Code", "Data Exp. Rec. Type Code";

            trigger OnAfterGetRecord()
            var
                DataExportManagement: Codeunit "Data Export Management";
                ExportPath: Text;
                ServerPath: Text;
                StartDateTime: DateTime;
                LastStreamNo: Integer;
            begin
                case "Data Export Record Definition"."Export Language" of
                    "Data Export Record Definition"."export language"::English:
                        GlobalLanguage(1033);
                    "Data Export Record Definition"."export language"::German:
                        GlobalLanguage(1031);
                end;

                "Data Export Record Definition".TestField("Data Export Record Definition".Description);
                if "Data Export Record Definition"."DTD File Name" = '' then
                    Error(DTDFileNotExistsErr);

                "Data Export Record Definition".TestField("Data Export Record Definition"."Export Path");
                ExportPath := CreateExportFolder("Data Export Record Definition"."Export Path", "Data Export Record Definition"."Data Exp. Rec. Type Code");
                ServerPath := GetTempFilePath;

                CheckRecordDefinition("Data Export Record Definition"."Data Export Code", "Data Export Record Definition"."Data Exp. Rec. Type Code");
                StartDateTime := CurrentDatetime;
                LastStreamNo := OpenFiles("Data Export Record Definition", ServerPath);

                if GuiAllowed then
                    Window.Update(1, CreatingXMLFileMsg);

                DataExportManagement.CreateIndexXML(TempDataExportRecordSource, ServerPath, "Data Export Record Definition".Description, StartDate, EndDate, "Data Export Record Definition"."DTD File Name");
                ExportDTDFile("Data Export Record Definition", ServerPath);

                WriteData("Data Export Record Definition");
                CloseStreams(LastStreamNo);

                if GuiAllowed then
                    Window.Update(1, CreatingLogFileMsg);
                CreateLogFile(ServerPath, CurrentDatetime - StartDateTime);

                DownloadFiles("Data Export Record Definition", ServerPath, ExportPath);
            end;

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then
                    Error(StartDateErr);

                if EndDate = 0D then
                    Error(EndDateErr);

                if GuiAllowed then
                    Window.Open(TableNameMsg + ProgressBarMsg);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                    field(CloseDate; CloseDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Closing Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        AccPeriod: Record "Accounting Period";
    begin
        FillCharsToDelete;

        StartDate := AccPeriod.GetFiscalYearStartDate(WorkDate);
        EndDate := AccPeriod.GetFiscalYearEndDate(WorkDate);
    end;

    trigger OnPostReport()
    begin
        GlobalLanguage(SaveGlobalLanguage);  // 15-12-21 ZY-LD 001
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get;
        SI.UseOfReport(3, 50100, 2);  // 14-10-20 ZY-LD 000

        SaveGlobalLanguage := GlobalLanguage;  // 15-12-21 ZY-LD 001
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempDataExportRecordSource: Record "Data Export Record Source" temporary;
        FileMgt: Codeunit "File Management";
        PathHelper: dotnet Path;
        StreamArr: array[100] of dotnet StreamWriter;
        StartDate: Date;
        EndDate: Date;
        Window: Dialog;
        TotalNoOfRecords: Integer;
        NoOfRecords: Integer;
        NoOfRecordsArr: array[100] of Integer;
        StepValue: Integer;
        NextStep: Integer;
        CloseDate: Boolean;
        ValueWithQuotesMsg: label '"%1"';
        PathDoesNotExistErr: label 'The export path does not exist.';
        CreatingXMLFileMsg: label 'Creating XML File...';
        StartDateErr: label 'You must enter a starting date.';
        EndDateErr: label 'You must enter an ending date.';
        DateFilterMsg: label '%1 to %2.', Comment = '<01.01.2014> to <31.01.2014>';
        DefineTableRelationErr: label 'You must define a %1 for table %2.';
        DTDFileNotExistsErr: label 'The DTD file does not exist.';
        NoticeMsg: label 'Important Notice:';
        PrimaryKeyField1Msg: label 'The %1 for table %2 that you defined contains primary key fields that are not specified at the top of the list.', Comment = 'The <Data Export Record Field> for table <G/L Entry> that you defined.';
        PrimaryKeyField2Msg: label 'In this case, the order of the fields that you want to export will not match the order that is stated in the .xml file.';
        PrimaryKeyField3Msg: label 'If you want to use the exported data for GDPdU purposes, make sure that primary key fields are specified first, followed by ordinary fields.';
        PrimaryKeyField4Msg: label 'Do you want to continue?';
        TableNameMsg: label 'Table Name:       #1#################\';
        CreatingLogFileMsg: label 'Creating Log File...';
        DurationMsg: label 'Duration: %1.';
        LogEntryMsg: label 'For table %1, %2 data records were exported, and file %3 was created.', Comment = 'For table <G/L Entry>, <9491> data records were exported, and file <GL_Entry.txt> was created.';
        LogFileNameTxt: label 'Log.txt';
        IndexFileNameTxt: label 'index.xml';
        NoOfDefinedTablesMsg: label 'Number of defined tables: %1.';
        NoOfEmptyTablesMsg: label 'Number of empty tables: %1.';
        OverwriteFolderQst: label 'A file or folder with the same name alreadys exists. Do you want to overwrite it?';
        ProgressBarMsg: label 'Progress:         @5@@@@@@@@@@@@@@@@@\';
        NoExportFieldsErr: label 'Data cannot be exported because no fields have been defined for one or more tables in the %1 data export.';
        CharsToDelete: Text;
        NewLine: Text[2];
        ExceedNoOfStreamsErr: label 'Microsoft Dynamics NAV cannot write to more than %1 files.';
        SI: Codeunit "Single Instance";
        SaveGlobalLanguage: Integer;


    procedure InitializeRequest(FromDate: Date; ToDate: Date)
    begin
        StartDate := FromDate;
        EndDate := ToDate;
        CloseDate := false;
    end;

    local procedure OpenFiles(DataExportRecordDefinition: Record "Data Export Record Definition"; ServerPath: Text) LastStreamNo: Integer
    var
        DataExportRecordSource: Record "Data Export Record Source";
        OutServerFile: dotnet File;
        MaxNumOfStreams: Integer;
    begin
        Clear(NoOfRecordsArr);
        Clear(StreamArr);

        begin
            DataExportRecordSource.Reset;
            DataExportRecordSource.SetCurrentkey(DataExportRecordSource."Data Export Code", DataExportRecordSource."Data Exp. Rec. Type Code", DataExportRecordSource."Line No.");
            DataExportRecordSource.SetRange(DataExportRecordSource."Data Export Code", DataExportRecordDefinition."Data Export Code");
            DataExportRecordSource.SetRange(DataExportRecordSource."Data Exp. Rec. Type Code", DataExportRecordDefinition."Data Exp. Rec. Type Code");
            MaxNumOfStreams := ArrayLen(StreamArr);
            if DataExportRecordSource.Count > MaxNumOfStreams then
                Error(ExceedNoOfStreamsErr, MaxNumOfStreams);
            LastStreamNo := 0;
            if DataExportRecordSource.FindSet then
                repeat
                    DataExportRecordSource.TestField(DataExportRecordSource."Export File Name");
                    DataExportRecordSource.Validate(DataExportRecordSource."Table Filter");

                    DataExportRecordSource.CalcFields(DataExportRecordSource."Table Name");
                    if GuiAllowed then
                        Window.Update(1, DataExportRecordSource."Table Name");

                    LastStreamNo += 1;
                    StreamArr[LastStreamNo] := OutServerFile.CreateText(ServerPath + '\' + DataExportRecordSource."Export File Name");

                    InsertFilesExportBuffer(DataExportRecordSource, LastStreamNo);

                    TotalNoOfRecords += CountRecords(TempDataExportRecordSource);
                until DataExportRecordSource.Next() = 0;
            StepValue := TotalNoOfRecords DIV 100;
            if GuiAllowed then
                Window.Update(1, '');
        end;
    end;

    local procedure CountRecords(DataExportRecordSource: Record "Data Export Record Source") TotalRecords: Integer
    var
        RecordRef: RecordRef;
    begin
        begin
            RecordRef.Open(DataExportRecordSource."Table No.");
            RecordRef.CurrentKeyIndex(DataExportRecordSource."Key No.");
            SetPeriodFilter(DataExportRecordSource."Period Field No.", RecordRef);
            TotalRecords := RecordRef.Count;
            RecordRef.Close;
        end;
    end;

    local procedure InsertFilesExportBuffer(DataExportRecordSource: Record "Data Export Record Source"; StreamNo: Integer)
    begin
        begin
            TempDataExportRecordSource := DataExportRecordSource;
            TempDataExportRecordSource.Indentation := StreamNo;
            if TempDataExportRecordSource."Key No." = 0 then
                TempDataExportRecordSource."Key No." := 1;
            TempDataExportRecordSource.Insert;
        end;
    end;

    local procedure ExportDTDFile(DataExportRecordDefinition: Record "Data Export Record Definition"; ServerPath: Text)
    var
        DTDFileOnServer: File;
        InStr: InStream;
        OutStr: OutStream;
    begin
        begin
            DataExportRecordDefinition.CalcFields(DataExportRecordDefinition."DTD File");
            DataExportRecordDefinition."DTD File".CreateInstream(InStr);
            DTDFileOnServer.Create(ServerPath + '\' + DataExportRecordDefinition."DTD File Name");
            DTDFileOnServer.CreateOutstream(OutStr);
            CopyStream(OutStr, InStr);
            DTDFileOnServer.Close;
        end;
    end;

    local procedure CreateLogFile(ExportPath: Text; Duration: Duration)
    var
        LogFile: File;
        NoOfDefinedTables: Integer;
        NoOfEmptyTables: Integer;
    begin
        LogFile.TextMode(true);
        LogFile.Create(ExportPath + '\' + LogFileNameTxt);

        LogFile.Write(StrSubstNo(DateFilterMsg, Format(StartDate), Format(CalcEndDate(EndDate))));
        LogFile.Write(Format(Today));
        begin
            TempDataExportRecordSource.Reset;
            if TempDataExportRecordSource.FindSet then begin
                NoOfDefinedTables := 0;
                NoOfEmptyTables := 0;
                LogFile.Write(TempDataExportRecordSource."Data Export Code" + ';' + TempDataExportRecordSource."Data Exp. Rec. Type Code");
                repeat
                    if NoOfRecordsArr[TempDataExportRecordSource.Indentation] = 0 then
                        NoOfEmptyTables += 1
                    else
                        NoOfDefinedTables += 1;
                    TempDataExportRecordSource.CalcFields(TempDataExportRecordSource."Table Name");
                    LogFile.Write(StrSubstNo(LogEntryMsg, TempDataExportRecordSource."Table Name", NoOfRecordsArr[TempDataExportRecordSource.Indentation], TempDataExportRecordSource."Export File Name"));
                until TempDataExportRecordSource.Next() = 0;
            end;
        end;
        LogFile.Write(StrSubstNo(NoOfDefinedTablesMsg, NoOfDefinedTables));
        LogFile.Write(StrSubstNo(NoOfEmptyTablesMsg, NoOfEmptyTables));
        LogFile.Write(StrSubstNo(DurationMsg, Duration));
        LogFile.Close;
    end;

    local procedure WriteData(DataExportRecordDefinition: Record "Data Export Record Definition")
    var
        CurrTempDataExportRecordSource: Record "Data Export Record Source";
        RecRef: RecordRef;
    begin
        begin
            TempDataExportRecordSource.Reset;
            TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Data Export Code", DataExportRecordDefinition."Data Export Code");
            TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Data Exp. Rec. Type Code", DataExportRecordDefinition."Data Exp. Rec. Type Code");
            TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Relation To Line No.", 0);
            if TempDataExportRecordSource.FindSet then
                repeat
                    CurrTempDataExportRecordSource.Copy(TempDataExportRecordSource);
                    RecRef.Open(TempDataExportRecordSource."Table No.");
                    ApplyTableFilter(TempDataExportRecordSource, RecRef);
                    WriteTable(TempDataExportRecordSource, RecRef);
                    RecRef.Close;
                    TempDataExportRecordSource.Copy(CurrTempDataExportRecordSource);
                until TempDataExportRecordSource.Next() = 0;
        end;
    end;

    local procedure WriteTable(DataExportRecordSource: Record "Data Export Record Source"; var RecRef: RecordRef)
    var
        RecRefToExport: RecordRef;
    begin
        if RecRef.FindSet then begin
            NoOfRecordsArr[DataExportRecordSource.Indentation] += RecRef.Count;
            if GuiAllowed then
                Window.Update(1, RecRef.Caption);
            repeat
                RecRefToExport := RecRef.Duplicate;
                WriteRecord(DataExportRecordSource, RecRefToExport);
                UpdateProgressBar;
                WriteRelatedRecords(DataExportRecordSource, RecRefToExport);
            until RecRef.Next() = 0;
        end;
    end;

    local procedure UpdateProgressBar()
    begin
        NoOfRecords := NoOfRecords + 1;
        if NoOfRecords >= NextStep then begin
            if TotalNoOfRecords <> 0 then
                if GuiAllowed then
                    Window.Update(5, ROUND(NoOfRecords / TotalNoOfRecords * 10000, 1));
            NextStep := NextStep + StepValue;
        end;
    end;

    local procedure ApplyTableFilter(DataExportRecordSource: Record "Data Export Record Source"; var RecRef: RecordRef)
    var
        TableFilterPage: Page "Table Filter";
        TableFilterText: Text;
    begin
        begin
            TableFilterText := Format(DataExportRecordSource."Table Filter");
            if TableFilterText <> '' then begin
                TableFilterPage.SetSourceTable(TableFilterText, DataExportRecordSource."Table No.", DataExportRecordSource."Table Name");

                RecRef.SetView(TableFilterPage.GetViewFilter);
                SetFlowFilterDateFields(DataExportRecordSource, RecRef);
            end;
            RecRef.CurrentKeyIndex(DataExportRecordSource."Key No.");
            SetPeriodFilter(DataExportRecordSource."Period Field No.", RecRef);
        end;
    end;

    local procedure WriteRelatedRecords(var ParentDataExportRecordSource: Record "Data Export Record Source"; ParentRecRef: RecordRef)
    var
        DataExportTableRelation: Record "Data Export Table Relation";
        RelatedRecRef: RecordRef;
        RelatedFieldRef: FieldRef;
        ParentFieldRef: FieldRef;
    begin
        begin
            TempDataExportRecordSource.Reset;
            TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Data Export Code", ParentDataExportRecordSource."Data Export Code");
            TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Data Exp. Rec. Type Code", ParentDataExportRecordSource."Data Exp. Rec. Type Code");
            TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Relation To Line No.", ParentDataExportRecordSource."Line No.");
            if TempDataExportRecordSource.FindSet then begin
                DataExportTableRelation.Reset;
                DataExportTableRelation.SetRange("Data Export Code", TempDataExportRecordSource."Data Export Code");
                DataExportTableRelation.SetRange("Data Exp. Rec. Type Code", TempDataExportRecordSource."Data Exp. Rec. Type Code");
                DataExportTableRelation.SetRange("From Table No.", ParentDataExportRecordSource."Table No.");
                repeat
                    DataExportTableRelation.SetRange("To Table No.", TempDataExportRecordSource."Table No.");
                    if DataExportTableRelation.FindSet then begin
                        RelatedRecRef.Open(TempDataExportRecordSource."Table No.");
                        ApplyTableFilter(TempDataExportRecordSource, RelatedRecRef);
                        repeat
                            ParentFieldRef := ParentRecRef.Field(DataExportTableRelation."From Field No.");
                            RelatedFieldRef := RelatedRecRef.Field(DataExportTableRelation."To Field No.");
                            RelatedFieldRef.SetRange(ParentFieldRef.Value);
                        until DataExportTableRelation.Next() = 0;

                        WriteTable(TempDataExportRecordSource, RelatedRecRef);

                        TempDataExportRecordSource.SetRange(TempDataExportRecordSource."Relation To Line No.", ParentDataExportRecordSource."Line No.");

                        RelatedRecRef.Close;
                    end else begin
                        TempDataExportRecordSource.CalcFields(TempDataExportRecordSource."Table Name");
                        Error(DefineTableRelationErr, DataExportTableRelation.TableCaption, TempDataExportRecordSource."Table Name");
                    end;
                until TempDataExportRecordSource.Next() = 0;
            end;
        end;
    end;

    local procedure SetPeriodFilter(PeriodFieldNo: Integer; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
    begin
        if PeriodFieldNo <> 0 then begin
            FieldRef := RecRef.Field(PeriodFieldNo);
            FieldRef.SetRange(StartDate, CalcEndDate(EndDate));
        end;
    end;

    local procedure WriteRecord(var DataExportRecordSource: Record "Data Export Record Source"; var RecRef: RecordRef)
    var
        DataExportRecordField: Record "Data Export Record Field";
        RecordText: Text;
        FieldValue: Text;
    begin
        if FindFields(DataExportRecordField, DataExportRecordSource) then begin
            repeat
                FieldValue :=
                  GetDataExportRecFieldValue(
                    DataExportRecordField, DataExportRecordSource."Date Filter Field No.", RecRef);
                RecordText += FieldValue + ';';
            until DataExportRecordField.Next() = 0;
            RecordText := CopyStr(RecordText, 1, StrLen(RecordText) - 1);
            StreamArr[DataExportRecordSource.Indentation].WriteLine(RecordText);
        end else
            Error(NoExportFieldsErr, DataExportRecordSource."Data Export Code");
    end;

    local procedure FormatField2String(var FieldRef: FieldRef; DataExportRecordField: Record "Data Export Record Field") FieldValueText: Text
    var
        OptionNo: Integer;
    begin
        begin
            case DataExportRecordField."Field Type" of
                DataExportRecordField."field type"::Option:
                    begin
                        OptionNo := FieldRef.Value;
                        if OptionNo <= GetMaxOptionIndex(FieldRef.OptionCaption) then
                            FieldValueText := SelectStr(OptionNo + 1, Format(FieldRef.OptionCaption))
                        else
                            FieldValueText := Format(OptionNo);
                    end;
                DataExportRecordField."field type"::Decimal:
                    FieldValueText := Format(FieldRef.Value, 0, 9);  // 15-12-21 ZY-LD 001
                                                                     //FieldValueText := FORMAT(FieldRef.VALUE,0,'<Precision,' + GLSetup."Amount Decimal Places" + '><Standard Format,0>');  // 15-12-21 ZY-LD 001
                DataExportRecordField."field type"::Date:
                    FieldValueText := Format(FieldRef.Value, 0, 9);  // 15-12-21 ZY-LD 001
                                                                     //FieldValueText := FORMAT(FieldRef.VALUE,10,'<day,2>.<month,2>.<year4>');  // 15-12-21 ZY-LD 001
                else
                    FieldValueText := Format(FieldRef.Value);
            end;
            if DataExportRecordField."Field Type" in [DataExportRecordField."field type"::Boolean, DataExportRecordField."field type"::Code, DataExportRecordField."field type"::Option, DataExportRecordField."field type"::Text] then
                FieldValueText := StrSubstNo(ValueWithQuotesMsg, ConvertString(FieldValueText));
        end;
    end;

    local procedure ConvertString(String: Text) NewString: Text
    var
        i: Integer;
        StrLength: Integer;
    begin
        NewString := DelChr(String, '=', CharsToDelete);
    end;

    local procedure CreateExportFolder(DefExportPath: Text[250]; DataExpRecTypeCode: Text) NewFolder: Text
    var
        ClientDirectoryHelper: dotnet Directory;
    begin
        if DefExportPath[StrLen(DefExportPath)] = '\' then
            DefExportPath := DelStr(DefExportPath, StrLen(DefExportPath), 1);
        if not ClientDirectoryHelper.Exists(DefExportPath) then
            Error(PathDoesNotExistErr);

        NewFolder := DefExportPath + '\' + DataExpRecTypeCode;
        if ClientDirectoryHelper.Exists(NewFolder) then begin
            if GuiAllowed then
                if not Confirm(OverwriteFolderQst) then
                    CurrReport.Break();
            ClientDirectoryHelper.Delete(NewFolder, true);
        end;
        ClientDirectoryHelper.CreateDirectory(NewFolder)
    end;

    local procedure GetTempFilePath(): Text[1024]
    var
        TempFile: File;
        TempFileName: Text[1024];
    begin
        TempFile.CreateTempfile;
        TempFileName := TempFile.Name;
        TempFile.Close;
        exit(
          PathHelper.GetFullPath(
            PathHelper.Combine(
              PathHelper.GetDirectoryName(TempFileName),
              '..')));
    end;

    local procedure CheckRecordDefinition(ExportCode: Code[10]; RecordCode: Code[10])
    var
        DataExportRecordSource: Record "Data Export Record Source";
        DataExportRecordField: Record "Data Export Record Field";
        RecRef: RecordRef;
        KeyRef: KeyRef;
        FieldRef: FieldRef;
        ActiveKeyFound: Boolean;
        KeyFieldFound: Boolean;
        NonKeyFieldFound: Boolean;
        FieldMismatch: Boolean;
        i: Integer;
        j: Integer;
    begin
        DataExportRecordSource.Reset;
        DataExportRecordSource.SetRange("Data Export Code", ExportCode);
        DataExportRecordSource.SetRange("Data Exp. Rec. Type Code", RecordCode);
        if DataExportRecordSource.FindSet then
            repeat
                RecRef.Open(DataExportRecordSource."Table No.");
                i := 0;
                ActiveKeyFound := false;
                NonKeyFieldFound := false;
                FieldMismatch := false;
                repeat
                    i := i + 1;
                    KeyRef := RecRef.KeyIndex(i);
                    if KeyRef.Active then
                        ActiveKeyFound := true;
                until (i >= RecRef.KeyCount) or ActiveKeyFound;
                if ActiveKeyFound then
                    if FindFields(DataExportRecordField, DataExportRecordSource) then
                        repeat
                            KeyFieldFound := false;
                            for j := 1 to KeyRef.FieldCount do begin
                                FieldRef := KeyRef.FieldIndex(j);
                                if DataExportRecordField."Field No." = FieldRef.Number then
                                    KeyFieldFound := true;
                            end;
                            if not KeyFieldFound then
                                NonKeyFieldFound := true;
                            if NonKeyFieldFound and KeyFieldFound then begin
                                FieldMismatch := true;
                                DataExportRecordField.CalcFields("Table Name");
                                if GuiAllowed then
                                    if not Confirm(NoticeMsg + '\' + '\' +
                                         PrimaryKeyField1Msg + ' ' +
                                         PrimaryKeyField2Msg + ' ' +
                                         PrimaryKeyField3Msg + '\' + '\' +
                                         PrimaryKeyField4Msg,
                                         true,
                                         DataExportRecordField.TableCaption,
                                         DataExportRecordField."Table Name")
                                    then
                                        Error('');
                            end;
                        until FieldMismatch or (DataExportRecordField.Next() = 0);
                RecRef.Close;
            until FieldMismatch or (DataExportRecordSource.Next() = 0);
    end;


    procedure FindFields(var DataExportRecordField: Record "Data Export Record Field"; var DataExportRecordSource: Record "Data Export Record Source"): Boolean
    begin
        begin
            DataExportRecordField.SetRange(DataExportRecordField."Data Export Code", DataExportRecordSource."Data Export Code");
            DataExportRecordField.SetRange(DataExportRecordField."Data Exp. Rec. Type Code", DataExportRecordSource."Data Exp. Rec. Type Code");
            DataExportRecordField.SetRange(DataExportRecordField."Source Line No.", DataExportRecordSource."Line No.");
            exit(DataExportRecordField.FindSet);
        end;
    end;

    local procedure SetFlowFilterDateFields(DataExportRecordSource: Record "Data Export Record Source"; var RecRef: RecordRef)
    var
        DataExportRecordField: Record "Data Export Record Field";
    begin
        if DataExportRecordSource."Date Filter Handling" <> DataExportRecordSource."date filter handling"::" " then begin
            DataExportRecordField.Init;
            DataExportRecordField."Table No." := DataExportRecordSource."Table No.";
            DataExportRecordField."Date Filter Handling" := DataExportRecordSource."Date Filter Handling";
            SetFlowFilterDateField(DataExportRecordField, DataExportRecordSource."Date Filter Field No.", RecRef);
        end;
    end;

    local procedure SetFlowFilterDateField(var DataExportRecordField: Record "Data Export Record Field"; DateFilterFieldNo: Integer; var RecRef: RecordRef)
    var
        "Field": Record "Field";
    begin
        if DateFilterFieldNo > 0 then
            SetFlowFilter(DateFilterFieldNo, DataExportRecordField."Date Filter Handling", RecRef)
        else begin
            Field.Reset;
            Field.SetRange(TableNo, DataExportRecordField."Table No.");
            Field.SetRange(Type, Field.Type::Date);
            Field.SetRange(Class, Field.Class::FlowFilter);
            Field.SetRange(Enabled, true);
            if Field.FindSet then
                repeat
                    SetFlowFilter(Field."No.", DataExportRecordField."Date Filter Handling", RecRef)
                until Field.Next() = 0;
        end;
    end;


    procedure GetDataExportRecFieldValue(var DataExportRecordField: Record "Data Export Record Field"; FlowFilterFieldNo: Integer; RecRef: RecordRef) FieldValueText: Text
    var
        FieldRef: FieldRef;
    begin
        FieldRef := RecRef.Field(DataExportRecordField."Field No.");
        if DataExportRecordField."Field Class" = DataExportRecordField."field class"::FlowField then begin
            SetFlowFilterDateField(DataExportRecordField, FlowFilterFieldNo, RecRef);
            FieldRef := RecRef.Field(DataExportRecordField."Field No.");
            FieldRef.CalcField;
        end;
        FieldValueText := FormatField2String(FieldRef, DataExportRecordField);
    end;


    procedure SetFlowFilter(FlowFilterFieldNo: Integer; DateFilterHandling: Option; var RecRef: RecordRef)
    var
        DataExportRecField: Record "Data Export Record Field";
        FieldRef: FieldRef;
    begin
        FieldRef := RecRef.Field(FlowFilterFieldNo);
        case DateFilterHandling of
            DataExportRecField."date filter handling"::" ":
                FieldRef.SetRange;
            DataExportRecField."date filter handling"::Period:
                FieldRef.SetRange(StartDate, CalcEndDate(EndDate));
            DataExportRecField."date filter handling"::"End Date Only":
                FieldRef.SetRange(0D, CalcEndDate(EndDate));
            DataExportRecField."date filter handling"::"Start Date Only":
                FieldRef.SetRange(0D, ClosingDate(StartDate - 1));
        end;
    end;

    local procedure CalcEndDate(Date: Date): Date
    begin
        if CloseDate then
            exit(ClosingDate(Date));
        exit(Date);
    end;

    local procedure FillCharsToDelete()
    var
        i: Integer;
        S: Text;
    begin
        NewLine[1] := 13;
        NewLine[2] := 10;

        CharsToDelete := NewLine;
        CharsToDelete[3] := 34;
        CharsToDelete[4] := 39;
        for i := 128 to 255 do begin
            S[1] := i;
            if not (S in ['Ä', 'ä', 'Ö', 'ö', 'Ü', 'ü', 'ß']) then
                CharsToDelete := CharsToDelete + S;
        end;
    end;

    local procedure CloseStreams(LastStreamNo: Integer)
    var
        i: Integer;
    begin
        for i := 1 to LastStreamNo do
            StreamArr[i].Close;
    end;

    local procedure DownloadFiles(DataExportRecordDefinition: Record "Data Export Record Definition"; ServerPath: Text; ExportPath: Text)
    var
        ZipFileNameOnClient: Text;
        ZipFileNameOnServer: Text;
    begin
        ZipFileNameOnServer := ZipFilesOnServer(ServerPath, DataExportRecordDefinition."DTD File Name");
        ZipFileNameOnClient := ExportPath + '\' + DataExportRecordDefinition."Data Exp. Rec. Type Code" + '.zip';
        FileMgt.CopyServerFile(ZipFileNameOnServer, ZipFileNameOnClient, true);
        ExtractFilesOnClient(ExportPath + '\', ZipFileNameOnClient);
    end;

    local procedure ZipFilesOnServer(ServerPath: Text; DTDFileName: Text) ZipFileNameOnServer: Text
    begin
        ZipFileNameOnServer := CreateZipArchiveObject;
        begin
            TempDataExportRecordSource.Reset;
            if TempDataExportRecordSource.FindSet then
                repeat
                    MoveToZipFile(ServerPath, TempDataExportRecordSource."Export File Name");
                until TempDataExportRecordSource.Next() = 0;
            TempDataExportRecordSource.DeleteAll;
        end;
        MoveToZipFile(ServerPath, IndexFileNameTxt);
        MoveToZipFile(ServerPath, LogFileNameTxt);
        MoveToZipFile(ServerPath, DTDFileName);
        CloseZipArchive;
    end;

    local procedure MoveToZipFile(ServerPath: Text; FileName: Text)
    begin
        if Exists(PathHelper.GetFullPath(ServerPath + '\' + FileName)) then begin
            AddFileToZipArchive(ServerPath + '\' + FileName, FileName);
            Erase(ServerPath + '\' + FileName);
        end;
    end;

    local procedure ExtractFilesOnClient(ExtractDirectory: Text; FileName: Text)
    var
        ZipFile: dotnet ZipFile;
    begin
        ZipFile.ExtractToDirectory(FileName, ExtractDirectory);
    end;


    procedure GetMaxOptionIndex(InputString: Text): Integer
    begin
        exit(StrLen(DelChr(InputString, '=', DelChr(InputString, '=', ','))));
    end;


    local procedure CreateZipArchiveObject() FilePath: Text
    var
        FileMgt: Codeunit "File Management";
    begin
        FilePath := FileMgt.ServerTempFileName('zip');
        OpenZipFile(FilePath);
    end;

    local procedure OpenZipFile(ServerZipFilePath: Text)
    begin
        ZipArchive := Zipfile.Open(ServerZipFilePath, ZipArchiveMode.Create);
    end;

    local procedure CloseZipArchive()
    begin
        IF NOT ISNULL(ZipArchive) THEN
            ZipArchive.Dispose;
    end;

    local procedure AddFileToZipArchive(SourceFileFullPath: Text; PathInZipFile: Text)
    begin
        Zip.CreateEntryFromFile(ZipArchive, SourceFileFullPath, PathInZipFile);
    end;


    var
        Zip: DotNet Zip;
        ZipFile: DotNet ZipFile;
        ZipArchive: DotNet ZipArchive;
        ZipArchiveMode: DotNet ZipArchiveMode;

}

