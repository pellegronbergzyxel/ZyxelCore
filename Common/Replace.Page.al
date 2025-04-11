page 50060 Replace
{
    // In order to call this page correctly ...
    // ----------------------------------------------------------------
    // 0) Create an Action on the page
    // 1) Create PAGE variable that points to this page.
    //   e.g. "Replace"
    // Replace OnAction Code:
    // 2) Call the LoadDataSet with name of table, run modal and clear afterwards
    //   e.g.
    //       Replace.LoadDataSet(DATABASE::"Gen. Journal Line",GETFILTERS);
    //       Replace.RUNMODAL;
    //       CurrPage.UPDATE;
    //       CLEAR(Replace);
    // 
    // 3) if you want validation to occur, then call SetValidations
    // 4) run this page as modal.

    LinksAllowed = false;
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group("<Replace>")
            {
                Caption = 'General';
                field(SelectedField; SelectedField)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selected Field';
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Fields.Reset();
                        Fields.FilterGroup(2);
                        Fields.SetRange(TableNo, RecRef.Number);
                        Fields.SetRange(Enabled, true);
                        Fields.FilterGroup(0);
                        if Page.RunModal(Page::"Fields Lookup", Fields) = Action::LookupOK then begin
                            SelectedField := Fields.FieldName;
                            SelectedFieldNo := Fields."No.";
                        end;

                        FldRef := RecRef.field(SelectedFieldNo);

                        if not VerifyClass then begin
                            Clear(SelectedField);
                            Clear(SelectedFieldNo);
                            Error(StrSubstNo(Text014, Format(FldRef.Caption)));
                        end;

                        SetReplaceWholeField(Format(FldRef.Type));
                    end;

                    trigger OnValidate()
                    begin
                        Fields.SetRange(TableNo, RecRef.Number);
                        Fields.SetRange(FieldName, SelectedField);
                        Fields.SetRange(Enabled, true);
                        if not Fields.FindFirst() then
                            Error(StrSubstNo(Text004, SelectedField));

                        SelectedFieldNo := Fields."No.";

                        FldRef := RecRef.field(SelectedFieldNo);

                        if not VerifyClass then
                            Error(StrSubstNo(Text014, Format(FldRef.Caption)));

                        SetReplaceWholeField(Format(FldRef.Type));
                    end;
                }
                field(FindWhat; FindWhat)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find What';

                    trigger OnValidate()
                    var
                        ErrorText: Text;
                    begin
                        ValidateFieldType(FindWhat, ErrorText);
                        if ErrorText <> '' then
                            Error(ErrorText);
                    end;
                }
                field(ReplaceWith; ReplaceWith)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replace With';

                    trigger OnValidate()
                    var
                        ErrorText: Text;
                    begin
                        ValidateFieldType(ReplaceWith, ErrorText);
                        if ErrorText <> '' then
                            Error(ErrorText);
                    end;
                }
                group(Options)
                {
                    field(Match; Match)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Match';
                    }
                    field(MatchCase; MatchCase)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Match Case';

                        trigger OnValidate()
                        begin
                            if UpperCase(Format(FldRef.Type)) <> 'TEXT' then
                                Error(Text005);
                        end;
                    }
                    field(ReplaceWholeField; ReplaceWholeField)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Replace Whole Field';
                    }
                    field(RecordCount; RecordCount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Records in Data Set';
                        Editable = false;
                        Enabled = false;
                    }
                }
            }
            group(Validation)
            {
                Caption = 'Validation';
                Editable = false;
                Enabled = false;
                Visible = false;
                field(ValidateRecord; ValidateRecord)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Record Level';
                }
                field(ValidateField; ValidateField)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Field Level';
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        ClearAll;
        RecRef.Close();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ErrorText: Text;
    begin
        if CloseAction = Action::OK then begin
            if VerifyFields then begin
                ValidateFieldType(FindWhat, ErrorText);
                if ErrorText <> '' then
                    exit;
                ValidateFieldType(ReplaceWith, ErrorText);
                if ErrorText <> '' then
                    exit;
                ReplaceValue;
            end;
        end;
    end;

    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        "Fields": Record "Field";
        ReplaceValueTableNo: Integer;
        FindWhat: Text;
        ReplaceWith: Text;
        Match: Option "Whole Field","Any Part of Field";
        MatchCase: Boolean;
        ReplaceWholeField: Boolean;
        MatchTimeBy: Option Minutes,Seconds,Milliseconds;
        OverrideReplaceWholeField: Boolean;
        SelectedField: Text;
        SelectedFieldNo: Integer;
        RecordCount: Integer;
        FieldTableNo: Integer;
        Text001: Label 'You must enter a value in the "Selected Field" field.';
        Text002: Label 'You must enter a value in the "Find What" field.';
        Text003: Label 'The "Replace With" field is blank.  Do you want to continue?';
        Text004: Label 'The "Selected Field" value ''%1'' is not valid.';
        UpdateKey: Boolean;
        ModifiedCount: Integer;
        ValidateField: Boolean;
        ValidateRecord: Boolean;
        Text005: Label 'The "Match Case" option can only be used with Text fields.';
        Text006: Label 'There are %1 records in this data set.';
        Text007: Label '%1  is an invalid %2 value.';
        Text008: Label 'Either ''Yes'' or ''No'' must be used with Boolean type fields.';
        Text012: Label 'You must clear the error\  %1 \ before continuing.';
        Text013: Label '\\Note: If a different result was expected, then make sure you have \write permissions to the "%1" table.';
        Text014: Label 'The selected field "%1" is a FlowField.  \A FlowField''s value must be changed on the base table.\Please select another field.';
        Text020: Label 'You must be assigned a role that has been setup in the Find & Replace Role Limits.';
        Text021: Label 'The current dataset exceeds your Find & Replace Role Limit (%1).';
        Text022: Label 'No Find & Replace Role Limits have been created.';

    local procedure ReplaceValue()
    var
        ReplaceRecRef: RecordRef;
        ReplaceFldRef: FieldRef;
        DataMatch: Boolean;
        MatchPos: Integer;
        ResultText: Text;
        Status: Dialog;
        CurrentRecord: Integer;
        MatchText: Text;
        DecimalPlaces: Integer;
    begin
        FindBestKey(RecRef);

        RecRef.LockTable;
        if RecRef.FindSet(true) then begin
            Status.Open('Processing Records: @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
            repeat
                CurrentRecord += 1;
                Status.Update(1, Round(CurrentRecord / RecordCount * 10000, 1));
                if RecRef.WritePermission then begin
                    FldRef := RecRef.field(SelectedFieldNo);
                    MatchPos := 0;
                    DataMatch := false;
                    if UpperCase(Format(FldRef.Type)) = 'DECIMAL' then begin
                        DecimalPlaces := StrLen(FindWhat) - StrPos(FindWhat, '.');
                        MatchText := Format(FldRef.Value, 0, '<Precision,2:' + Format(DecimalPlaces) + '><Standard Format,0>');
                    end else
                        MatchText := Format(FldRef.Value);
                    if Match = Match::"Whole Field" then begin
                        if MatchCase then
                            DataMatch := (FindWhat = MatchText)
                        else
                            DataMatch := (UpperCase(FindWhat) = UpperCase(MatchText))
                    end else begin
                        if MatchCase then begin
                            MatchPos := StrPos(MatchText, FindWhat);
                            DataMatch := (MatchPos <> 0);
                        end else begin
                            MatchPos := StrPos(UpperCase(MatchText), UpperCase(FindWhat));
                            DataMatch := (MatchPos <> 0);
                        end;
                    end;

                    if ((not ReplaceWholeField) and (StrLen(MatchText) = StrLen(FindWhat)) or ReplaceWholeField) then
                        OverrideReplaceWholeField := true
                    else
                        OverrideReplaceWholeField := false;

                    if DataMatch then begin
                        ReplaceRecRef := RecRef.Duplicate;
                        ReplaceFldRef := ReplaceRecRef.field(SelectedFieldNo);
                        FormatNewValue(ReplaceFldRef, MatchPos, StrLen(FindWhat), OverrideReplaceWholeField);
                        ReplaceRecRef.Modify(ValidateRecord);
                        ModifiedCount += 1;
                    end;
                end;
            until (RecRef.Next() = 0);
            Status.Close();
        end;

        if ModifiedCount > 0 then
            ReplaceRecRef.Close();

        if (ModifiedCount > 1) or (ModifiedCount = 0) then begin
            ResultText := ' Records were updated.';
            if ModifiedCount = 0 then
                ResultText += StrSubstNo(Text013, RecRef.Caption);

        end else
            ResultText := ' Record was updated.';

        Message(Format(ModifiedCount) + ResultText);
    end;

    procedure ShowRecordCount(TableNo: Integer; FilterString: Text)
    var
        RecordCountRecRef: RecordRef;
    begin
        RecordCountRecRef.Open(TableNo);
        Message('tableno', TableNo);
        if FilterString <> '' then
            ApplyFilters(RecordCountRecRef, FilterString);
        RecordCount := RecordCountRecRef.Count();
        Message(StrSubstNo(Text006, Format(RecordCount)));
        RecordCountRecRef.Close();
    end;

    local procedure FindBestKey(var KeyRecRef: RecordRef)
    var
        ICount: Integer;
        FCount: Integer;
        PreferedKey: Integer;
        FieldPos: Integer;
        IdxFldRef: FieldRef;
        IdxRef: KeyRef;
    begin
        FieldPos := 0;
        UpdateKey := false;

        for ICount := 1 to KeyRecRef.KeyCount do begin
            IdxRef := KeyRecRef.KeyIndex(ICount);
            for FCount := 1 to IdxRef.FieldCount do begin
                IdxFldRef := IdxRef.FieldIndex(FCount);
                if UpperCase(IdxFldRef.Name) = UpperCase(SelectedField) then begin
                    if (FCount < FieldPos) or (FieldPos = 0) then begin
                        FieldPos := FCount;
                        PreferedKey := ICount;
                    end;
                end;
            end;
        end;

        if FieldPos <> 0 then begin
            KeyRecRef.CurrentKeyIndex(PreferedKey);
            UpdateKey := true;
        end else
            KeyRecRef.CurrentKeyIndex(1);
    end;

    local procedure FormatNewValue(var FormatFldRef: FieldRef; ValuePos: Integer; ValueLen: Integer; ReplaceWholeValue: Boolean)
    var
        TempString: Text;
        TempBoolean: Boolean;
        TempInteger: Integer;
        TempDate: Date;
        TempDecimal: Decimal;
        TempBigInteger: BigInteger;
        TempDateTime: DateTime;
        TempTime: Time;
        TempCode: Code[10];
        TempText: Text;
        TempOption: Text;
        OptionCount: Integer;
        OptionNo: Integer;
        ICount: Integer;
        TempDateFormula: DateFormula;
    begin
        case UpperCase(Format(FormatFldRef.Type)) of
            'BOOLEAN':
                begin
                    Evaluate(TempBoolean, ReplaceWith);
                    if ValidateField then
                        FormatFldRef.Validate(TempBoolean)
                    else
                        FormatFldRef.Value := TempBoolean;
                end;
            'BIGINTEGER':
                begin
                    Evaluate(TempBigInteger, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempBigInteger)
                    else
                        FormatFldRef.Value := TempBigInteger;
                end;
            'CODE':
                begin
                    TempCode := BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue);
                    if ValidateField then
                        FormatFldRef.Validate(TempCode)
                    else
                        FormatFldRef.Value := TempCode;
                end;
            'DATE':
                begin
                    Evaluate(TempDate, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempDate)
                    else
                        FormatFldRef.Value := TempDate;
                end;
            'DATEFORMULA':
                begin
                    Evaluate(TempDateFormula, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempDateFormula)
                    else
                        FormatFldRef.Value := TempDateFormula;
                end;
            'DATETIME':
                begin
                    Evaluate(TempDateTime, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempDateTime)
                    else
                        FormatFldRef.Value := TempDateTime;
                end;
            'DECIMAL':
                begin
                    Evaluate(TempDecimal, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempDecimal)
                    else
                        FormatFldRef.Value := TempDecimal;
                end;
            'INTEGER':
                begin
                    Evaluate(TempInteger, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempInteger)
                    else
                        FormatFldRef.Value := TempInteger;
                end;
            'OPTION':
                begin
                    OptionCount := 0;
                    TempOption := FormatFldRef.OptionMembers();

                    for ICount := 1 to StrLen(TempOption) do begin
                        if TempOption[ICount] = ',' then
                            OptionCount += 1;
                    end;

                    for ICount := 1 to OptionCount + 1 do begin
                        if BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue) =
                           SelectStr(ICount, TempOption) then begin
                            OptionNo := ICount;
                            ICount := OptionCount + 1
                        end;
                    end;

                    if ValidateField then
                        FormatFldRef.Validate(OptionNo - 1)
                    else
                        FormatFldRef.Value := OptionNo - 1;
                end;
            'TIME':
                begin
                    Evaluate(TempTime, BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue));
                    if ValidateField then
                        FormatFldRef.Validate(TempTime)
                    else
                        FormatFldRef.Value := TempTime;
                end;
            else begin
                TempText := BuildReplaceValue(FormatFldRef, ValuePos, ValueLen, ReplaceWholeValue);
                if ValidateField then
                    FormatFldRef.Validate(TempText)
                else
                    FormatFldRef.Value := TempText;
            end;
        end;
    end;

    local procedure ApplyFilters(var FilteredRecRef: RecordRef; FilterString: Text)
    var
        FilteredFldRef: FieldRef;
        ICount: Integer;
        FilterCount: Integer;
        FldCount: Integer;
        Filters: array[20, 2] of Text;
        PosComma: Integer;
        PosColon: Integer;
        TempString: Text;
        TempBoolean: Boolean;
        TempInteger: Integer;
        TempDate: Date;
        TempDecimal: Decimal;
        TempBigInteger: BigInteger;
        TempTime: Time;
        TempDateTime: DateTime;
        TempOption: Text;
        OptionCount: Integer;
        OptionNo: Integer;
        TempDateFormula: DateFormula;
    begin
        // Count the number of the filters
        FilterCount := 1;
        for ICount := 1 to StrLen(FilterString) do begin
            if FilterString[ICount] = ',' then
                FilterCount += 1;
        end;

        // Parse the Filters
        for ICount := 1 to FilterCount do begin
            PosColon := StrPos(FilterString, ':');
            PosComma := StrPos(FilterString, ',');
            if PosComma <> 0 then
                TempString := CopyStr(FilterString, 1, PosComma - 1)
            else
                TempString := FilterString;
            Filters[ICount] [1] := DelChr(CopyStr(TempString, 1, PosColon - 1), '<', ' ');
            Filters[ICount] [2] := DelChr(CopyStr(TempString, PosColon + 1), '<', ' ');
            if PosComma <> 0 then
                FilterString := CopyStr(FilterString, PosComma + 1);
        end;

        // Apply the filters
        for ICount := 1 to FilterCount do begin
            for FldCount := 1 to FilteredRecRef.FieldCount do begin
                FilteredFldRef := FilteredRecRef.FieldIndex(FldCount);
                if FilteredFldRef.Name = Filters[ICount] [1] then begin
                    if IsFilter(Filters[ICount] [2]) then
                        FilteredFldRef.SetFilter(Filters[ICount] [2])
                    else begin
                        case UpperCase(Format(FilteredFldRef.Type)) of
                            'BOOLEAN':
                                begin
                                    Evaluate(TempBoolean, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempBoolean);
                                end;
                            'BIGINTEGER':
                                begin
                                    Evaluate(TempBigInteger, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempBigInteger);
                                end;
                            'DATE':
                                begin
                                    Evaluate(TempDate, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempDate);
                                end;
                            'DATEFORMULA':
                                begin
                                    Evaluate(TempDateFormula, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempDateFormula);
                                end;
                            'DATETIME':
                                begin
                                    Evaluate(TempDateTime, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempDateTime);
                                end;
                            'DECIMAL':
                                begin
                                    Evaluate(TempDecimal, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempDecimal);
                                end;
                            'INTEGER':
                                begin
                                    Evaluate(TempInteger, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempInteger);
                                end;
                            'OPTION':
                                begin
                                    TempOption := FilteredFldRef.OptionMembers();
                                    OptionCount := 0;

                                    for ICount := 1 to StrLen(TempOption) do begin
                                        if TempOption[ICount] = ',' then
                                            OptionCount += 1;
                                    end;

                                    for ICount := 1 to OptionCount + 1 do begin
                                        if Filters[ICount] [2] = SelectStr(ICount, TempOption) then begin
                                            OptionNo := ICount;
                                            ICount := OptionCount + 1
                                        end;
                                    end;
                                    FilteredFldRef.SetRange(OptionNo - 1);
                                end;
                            'TIME':
                                begin
                                    Evaluate(TempTime, Filters[ICount] [2]);
                                    FilteredFldRef.SetRange(TempTime);
                                end;
                            else
                                FilteredFldRef.SetRange(Filters[ICount] [2]);
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure InitFields()
    begin
        Clear(SelectedField);
        Clear(FindWhat);
        Clear(ReplaceWith);
        Clear(Match);
        Clear(MatchCase);
        Clear(ReplaceWholeField);
        Clear(ModifiedCount);
    end;

    local procedure VerifyFields() Proceed: Boolean
    begin
        Proceed := true;

        if SelectedField = '' then
            Error(Text001);

        if FindWhat = '' then
            Error(Text002);

        if ReplaceWith = '' then
            Proceed := Confirm(Text003, false, true);

        exit(Proceed);
    end;


    procedure VerifyClass(): Boolean
    var
        FieldClass: Code[10];
        FieldList: Page "Fields Lookup";
    begin
        FldRef := RecRef.field(SelectedFieldNo);
        FieldClass := Format(FldRef.CLASS);
        exit((FieldClass <> 'FLOWFIELD') and (FieldClass <> 'FLOWFILTER'));
    end;

    local procedure ValidateFieldType(var InputValue: Text; var ErrorMsg: Text)
    var
        TempString: Text;
        TempBoolean: Boolean;
        TempInteger: Integer;
        TempDate: Date;
        TempDecimal: Decimal;
        TempBigInteger: BigInteger;
        TempTime: Time;
        TempDateTime: DateTime;
        TempOption: Text;
        OptionCount: Integer;
        ICount: Integer;
        Result: Boolean;
        TempDateFormula: DateFormula;
    begin
        case UpperCase(Format(FldRef.Type)) of
            'BOOLEAN':
                begin
                    Result := Evaluate(TempBoolean, InputValue);
                    InputValue := Format(TempBoolean);
                end;
            'BIGINTEGER':
                begin
                    Result := Evaluate(TempBigInteger, InputValue);
                end;
            'DATE':
                begin
                    Result := Evaluate(TempDate, InputValue);
                    InputValue := Format(TempDate);
                end;
            'DATEFORMULA':
                begin
                    Result := Evaluate(TempDateFormula, InputValue);
                    InputValue := Format(TempDateFormula);
                end;
            'DATETIME':
                begin
                    Result := Evaluate(TempDateTime, InputValue);
                    InputValue := Format(TempDateTime);
                end;
            'DECIMAL':
                begin
                    Result := Evaluate(TempDecimal, InputValue);
                end;
            'INTEGER':
                begin
                    Result := Evaluate(TempInteger, InputValue);
                end;
            'OPTION':
                begin
                    OptionCount := 0;
                    TempOption := FldRef.OptionMembers();

                    for ICount := 1 to StrLen(TempOption) do begin
                        if TempOption[ICount] = ',' then
                            OptionCount += 1;
                    end;

                    for ICount := 1 to OptionCount + 1 do begin
                        if InputValue = SelectStr(ICount, TempOption) then begin
                            Result := true;
                            InputValue := SelectStr(ICount, TempOption);
                        end;
                    end;
                end;
            'TIME':
                begin
                    Result := Evaluate(TempTime, InputValue);
                    InputValue := Format(TempTime);
                end;
            else
                Result := true;
        end;

        if not Result then
            ErrorMsg := StrSubstNo(Text007, InputValue, FldRef.Type);
    end;

    local procedure BuildReplaceValue(var BuildFldRef: FieldRef; ValuePos: Integer; ValueLen: Integer; ReplaceWholeValue: Boolean): Text
    begin
        if ReplaceWholeValue then
            exit(ReplaceWith)
        else
            exit(CopyStr(Format(BuildFldRef.Value), 1, ValuePos - 1) + ReplaceWith +
                 CopyStr(Format(BuildFldRef.Value), ValuePos + ValueLen));
    end;

    local procedure SetReplaceWholeField(Type: Code[10])
    begin
        ReplaceWholeField := not ((Type = 'TEXT') or (Type = 'CODE'));
    end;


    procedure LoadDataSet(TableNo: Integer; FilterString: Text)
    begin
        Error('If you use this function, then send an e-mail to navsupport@zyxel.eu.');

        RecRef.Open(TableNo);
        if FilterString <> '' then
            ApplyFilters(RecRef, FilterString);
        RecordCount := RecRef.Count();
        FieldTableNo := ReplaceValueTableNo;
    end;


    procedure SetValidations(ModifyLevel: Boolean; FieldLevel: Boolean)
    begin
        ValidateRecord := ModifyLevel;
        ValidateField := FieldLevel;
    end;

    local procedure IsFilter(FilterText: Text): Boolean
    var
        ValidOperator: array[8] of Text;
        ICount: Integer;
    begin
        ValidOperator[1] := '..';
        ValidOperator[2] := '&';
        ValidOperator[3] := '|';
        ValidOperator[4] := '<';
        ValidOperator[5] := '=';
        ValidOperator[6] := '>';
        ValidOperator[7] := '*';
        ValidOperator[8] := '@';

        for ICount := 1 to ArrayLen(ValidOperator) do begin
            if StrPos(FilterText, ValidOperator[ICount]) <> 0 then
                exit(true);
        end;

        exit(false);
    end;
}
