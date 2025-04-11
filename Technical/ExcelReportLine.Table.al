Table 60006 "Excel Report Line"
{
    Caption = 'Excel Report Line';

    fields
    {
        field(1; "Excel Report Code"; Code[10])
        {
            TableRelation = "Excel Report Header";
        }
        field(2; "Column No."; Integer)
        {

            trigger OnValidate()
            begin
                ColNo := "Column No." - 1;
                "Column Name" := ZGT.GetExcelColumnHeader(ColNo);
            end;
        }
        field(3; "Column Name"; Code[2])
        {
        }
        field(4; "Table No."; Integer)
        {
            BlankZero = true;
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(5; "Field No."; Integer)
        {
            BlankZero = true;
            TableRelation = Field."No.";

            trigger OnLookup()
            begin
                recField.SetRange(TableNo, "Table No.");
                if Page.RunModal(Page::"Fields Lookup", recField) = Action::LookupOK then begin
                    "Field No." := recField."No.";
                    Caption := recField."Field Caption";
                    case recField.Type of
                        recField.Type::Date:
                            "Cell Type" := "cell type"::Date;
                        recField.Type::Integer:
                            Validate("Cell Type", "cell type"::Number);
                        recField.Type::Decimal:
                            Validate("Cell Type", "cell type"::Number);
                        recField.Type::Time:
                            Validate("Cell Type", "cell type"::Time);
                        else
                            "Cell Type" := "cell type"::Text;
                    end;
                end;
            end;
        }
        field(7; Formula; Text[250])
        {

            trigger OnValidate()
            begin
                Formula := UpperCase(Formula);
                "Show Formula as Text" := CopyStr(Formula, 1, 1) <> '=';

                ValidateFormula(Formula);
            end;
        }
        field(8; Caption; Text[50])
        {
        }
        field(9; Comment; Text[250])
        {
        }
        field(10; Active; Boolean)
        {
            InitValue = true;
        }
        field(11; "Show Formula as Text"; Boolean)
        {
        }
        field(12; "Cell Type"; Option)
        {
            Caption = 'Cell Type';
            InitValue = Text;
            OptionCaption = 'Number,Text,Date,Time';
            OptionMembers = Number,Text,Date,Time;

            trigger OnValidate()
            begin
                case "Cell Type" of
                    "cell type"::Number:
                        "Cell Format" := '###,###,##0.00';
                    "cell type"::Time:
                        "Cell Format" := 'dd:mm:yyyy';
                end;
            end;
        }
        field(13; "Cell Format"; Text[30])
        {
        }
        field(14; "Find Record"; Option)
        {
            OptionMembers = "First Record","Last Record";
        }
        field(15; "Next Record"; Integer)
        {
            BlankZero = true;
            MaxValue = 9;
            MinValue = 0;
        }
        field(16; Calculation; Option)
        {
            OptionMembers = " ","+","-","*","/";
        }
        field(17; "Calculation Value"; Decimal)
        {
        }
        field(18; "Previous Column Name"; Code[2])
        {
            Caption = 'Previous Column Name';
        }
        field(19; "Formula 2"; Text[250])
        {
        }
        field(20; "Formula 3"; Text[250])
        {
        }
        field(21; "Formula 4"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Excel Report Code", "Column No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recExRepLine.SetRange("Excel Report Code", "Excel Report Code");
        recExRepLine.SetFilter("Column No.", '<>%1', "Column No.");
        recExRepLine.SetFilter(Formula, '<>%1', '');
        if recExRepLine.FindSet then
            repeat
                if StrPos(recExRepLine.Formula, "Column Name") <> 0 then
                    Error(Text001, FieldCaption("Column Name"), "Column Name", FieldCaption(Formula), recExRepLine."Column Name");
            until recExRepLine.Next() = 0;
    end;

    trigger OnRename()
    var
        ColumnNo: Integer;
    begin
        ColumnNo := xRec."Column No." - 1;
        "Previous Column Name" := ZGT.GetExcelColumnHeader(ColumnNo);
    end;

    var
        recField: Record "Field";
        recExRepLine: Record "Excel Report Line";
        ZGT: Codeunit "ZyXEL General Tools";
        ColNo: Integer;
        Text001: label 'The "%1" "%2" is a part of the"%3" in "%1" "%4". Edit the formula, and delete the line again.';
        Position: Integer;
        ColumnNo: Integer;

    local procedure ValidateFormula(var pFormula: Text)
    var
        recExRepLine: Record "Excel Report Line";
        Position: Integer;
        TestOfPosition: Integer;
        i: Integer;
        j: Integer;
        PosValue: Integer;
        ToPos: Integer;
        NextPositionIsInteger: Boolean;
    begin
        recExRepLine.SetRange("Excel Report Code", "Excel Report Code");
        if recExRepLine.FindSet then
            repeat
                for i := 1 to 10 do begin
                    Position := GetNextPosition(pFormula, recExRepLine."Column Name");
                    NextPositionIsInteger := Evaluate(PosValue, CopyStr(pFormula, Position + 1, 1));
                    if (Position <> 0) and NextPositionIsInteger then begin
                        Position := Position + StrLen(recExRepLine."Column Name");
                        for j := 0 to 2 do begin
                            TestOfPosition := Position + j;
                            if Evaluate(PosValue, CopyStr(pFormula, TestOfPosition, 1)) then
                                ToPos := TestOfPosition
                            else
                                j := 9;
                        end;
                        if ToPos <> 0 then
                            pFormula := StrSubstNo('%1#%2',
                              CopyStr(pFormula, 1, Position - 1),
                              CopyStr(pFormula, ToPos + 1, StrLen(pFormula)));
                    end;
                end;
            until recExRepLine.Next() = 0;
        pFormula := ConvertStr(pFormula, ';', ',');
    end;

    local procedure GetNextPosition(pFormula: Text; pColumnName: Code[10]): Integer
    var
        i: Integer;
    begin
        for i := 1 to StrLen(pFormula) do
            if (CopyStr(pFormula, i, StrLen(pColumnName)) = pColumnName) and
               (CopyStr(pFormula, i + StrLen(pColumnName), 1) <> '#')
            then
                exit(i);
    end;


    procedure EnterFormula()
    var
        GenInputPage: Page "Generic Input Page";
        FormulaMax: Text;
        lText001: label 'Enter Formula';
        lText002: label 'Formula';
    begin
        FormulaMax := Formula + "Formula 2" + "Formula 3" + "Formula 4";
        GenInputPage.SetPageCaption(lText001);
        GenInputPage.SetFieldCaption(lText002);
        GenInputPage.SetVisibleField(0);  // Text
        GenInputPage.SetText(FormulaMax);
        if GenInputPage.RunModal = Action::OK then begin
            FormulaMax := GenInputPage.GetText;
            ValidateFormula(FormulaMax);
            if StrLen(FormulaMax) <= 1 then begin
                Formula := '';
                "Formula 2" := '';
                "Formula 3" := '';
                "Formula 4" := '';
            end else
                if StrLen(FormulaMax) <= 250 then
                    Formula := FormulaMax
                else
                    if StrLen(FormulaMax) <= 500 then begin
                        Formula := CopyStr(FormulaMax, 1, 250);
                        "Formula 2" := CopyStr(FormulaMax, 251, 250);
                    end else
                        if StrLen(FormulaMax) <= 750 then begin
                            Formula := CopyStr(FormulaMax, 1, 250);
                            "Formula 2" := CopyStr(FormulaMax, 251, 250);
                            "Formula 3" := CopyStr(FormulaMax, 501, 250);
                        end else begin
                            Formula := CopyStr(FormulaMax, 1, 250);
                            "Formula 2" := CopyStr(FormulaMax, 251, 250);
                            "Formula 3" := CopyStr(FormulaMax, 501, 250);
                            "Formula 4" := CopyStr(FormulaMax, 751, 250);
                        end;
        end;
    end;
}
