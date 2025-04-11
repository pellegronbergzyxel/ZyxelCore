report 50112 "Personnel Budget Report"
{
    // 001. 24-09-19 ZY-LD 2019092410000064 - Key index changed from 2 to 1.
    // 002. 29-10-20 ZY-LD 2020102810000061 - New table added.

    Caption = 'Personnel Budget Report';
    ProcessingOnly = true;

    dataset
    {
        dataitem(CaptionItem; "Excel Report Line")
        {
            DataItemTableView = sorting("Column No.");

            trigger OnAfterGetRecord()
            begin
                if CaptionItem.Active then begin
                    CaptionItem.Caption := MapVariable(CaptionItem.Caption, StartLeaveYear, '[STARTLEAVEYEAR]', false);
                    CaptionItem.Caption := MapVariable(CaptionItem.Caption, SalaryRevDate, '[SALARYREVIEWDATE]', false);
                    ExcelBuf.AddColumn(CaptionItem.Caption, false, CaptionItem.Comment, true, false, false, '', ExcelBuf."cell type"::Text);
                end else
                    ExcelBuf.AddColumn('', false, CaptionItem.Comment, true, false, false, '', ExcelBuf."cell type"::Text);
            end;

            trigger OnPreDataItem()
            begin
                CaptionItem.SetRange(CaptionItem."Excel Report Code", ExcelReportCode);
                ExcelBuf.NewRow;
            end;
        }
        dataitem("ZyXEL Employee"; "ZyXEL Employee")
        {
            RequestFilterFields = "No.", "Termination Date", "Company Option";
            dataitem("Excel Report Line"; "Excel Report Line")
            {
                trigger OnAfterGetRecord()
                var
                    xx: Decimal;
                    i: Integer;
                    Steps: Integer;
                    NumValue: Decimal;
                    FormulaMax: Text;
                    FieldClass: Code[10];
                begin
                    if "Excel Report Line".Active then begin
                        FormulaMax := "Excel Report Line".Formula + "Excel Report Line"."Formula 2" + "Excel Report Line"."Formula 3" + "Excel Report Line"."Formula 4";

                        if "Excel Report Line"."Table No." <> 0 then begin
                            RRef.Open("Excel Report Line"."Table No.");
                            // Set filter and get record
                            case "Excel Report Line"."Table No." of
                                //>> 29-10-20 ZY-LD 001
                                5207:
                                    begin
                                        RRef.CurrentKeyIndex(2);
                                        FRef := RRef.Field(recEmpAbsence.FieldNo("Employee No."));
                                        FRef.SetRange("ZyXEL Employee"."No.");
                                        FRef := RRef.Field(recEmpAbsence.FieldNo("From Date"));
                                        FRef.SetFilter('..%1', FromDate);
                                        case "Excel Report Line"."Find Record" of
                                            "Excel Report Line"."find record"::"First Record":
                                                RecordFound := RRef.FindFirst();
                                            "Excel Report Line"."find record"::"Last Record":
                                                RecordFound := RRef.FindLast();
                                        end;
                                        if RecordFound and ("Excel Report Line"."Next Record" <> 0) then begin
                                            FRef := RRef.Field(recHRSalaryLine.FieldNo("Valid From"));
                                            FRef.SetFilter('..%1', ToDate);
                                            Steps := "Excel Report Line"."Next Record" / Abs("Excel Report Line"."Next Record");
                                            for i := 1 to Abs("Excel Report Line"."Next Record") do
                                                RecordFound := RRef.Next(Steps) <> 0;
                                        end;
                                    end;
                                //<< 29-10-20 ZY-LD 001
                                50072:
                                    begin
                                        RRef.CurrentKeyIndex(1);
                                        FRef := RRef.Field(recKPIEntry.FieldNo("Employee No."));
                                        FRef.SetRange("ZyXEL Employee"."No.");
                                        FRef := RRef.Field(recKPIEntry.FieldNo(Year));
                                        FRef.SetFilter('..%1', Date2dmy(FromDate, 3));
                                        case "Excel Report Line"."Find Record" of
                                            "Excel Report Line"."find record"::"First Record":
                                                RecordFound := RRef.FindFirst();
                                            "Excel Report Line"."find record"::"Last Record":
                                                RecordFound := RRef.FindLast();
                                        end;
                                        /*IF RecordFound AND ("Next Record" <> 0) THEN BEGIN
                                          FRef := RRef.FIELD(reckpientry.FieldNo("Valid From"));
                                          FRef.SETFILTER('..%1',ToDate);
                                          Steps := "Next Record" / ABS("Next Record");
                                          FOR i := 1 TO ABS("Next Record") DO
                                            RecordFound := RRef.NEXT(Steps) <> 0;
                                        END;*/
                                    end;
                                50095:
                                    begin
                                        RRef.CurrentKeyIndex(2);
                                        FRef := RRef.Field(recHRSalaryLine.FieldNo("Employee No."));
                                        FRef.SetRange("ZyXEL Employee"."No.");
                                        FRef := RRef.Field(recHRSalaryLine.FieldNo("Valid From"));
                                        FRef.SetFilter('..%1', FromDate);
                                        case "Excel Report Line"."Find Record" of
                                            "Excel Report Line"."find record"::"First Record":
                                                RecordFound := RRef.FindFirst();
                                            "Excel Report Line"."find record"::"Last Record":
                                                RecordFound := RRef.FindLast();
                                        end;
                                        if RecordFound and ("Excel Report Line"."Next Record" <> 0) then begin
                                            FRef := RRef.Field(recHRSalaryLine.FieldNo("Valid From"));
                                            FRef.SetFilter('..%1', ToDate);
                                            Steps := "Excel Report Line"."Next Record" / Abs("Excel Report Line"."Next Record");
                                            for i := 1 to Abs("Excel Report Line"."Next Record") do
                                                RecordFound := RRef.Next(Steps) <> 0;
                                        end;
                                    end;
                                50100:
                                    begin
                                        RRef.CurrentKeyIndex(1);  // 24-09-19 ZY-LD 001
                                        FRef := RRef.Field(recHRRoleHist.FieldNo("Employee No."));
                                        FRef.SetRange("ZyXEL Employee"."No.");
                                        FRef := RRef.Field(recHRRoleHist.FieldNo("Start Date"));
                                        FRef.SetFilter('..%1', FromDate);
                                        case "Excel Report Line"."Find Record" of
                                            "Excel Report Line"."find record"::"First Record":
                                                RecordFound := RRef.FindFirst();
                                            "Excel Report Line"."find record"::"Last Record":
                                                RecordFound := RRef.FindLast();
                                        end;
                                        if RecordFound and ("Excel Report Line"."Next Record" <> 0) then begin
                                            FRef := RRef.Field(recHRSalaryLine.FieldNo("Valid From"));
                                            FRef.SetFilter('..%1', ToDate);
                                            Steps := "Excel Report Line"."Next Record" / Abs("Excel Report Line"."Next Record");
                                            for i := 1 to Abs("Excel Report Line"."Next Record") do
                                                RecordFound := RRef.Next(Steps) <> 0;
                                        end;
                                    end;
                                50109:
                                    begin
                                        RRef.CurrentKeyIndex(1);
                                        FRef := RRef.Field("ZyXEL Employee".FieldNo("No."));
                                        FRef.SetRange("ZyXEL Employee"."No.");
                                        case "Excel Report Line"."Find Record" of
                                            "Excel Report Line"."find record"::"First Record":
                                                RecordFound := RRef.FindFirst();
                                            "Excel Report Line"."find record"::"Last Record":
                                                RecordFound := RRef.FindLast();
                                        end;
                                    end;
                            end;

                            // Send to Excel Buffer
                            if RecordFound then begin
                                FRef := RRef.Field("Excel Report Line"."Field No.");
                                FieldClass := Format(FRef.CLASS);
                                if FieldClass = 'FLOWFIELD' then
                                    FRef.CalcField;
                                if FormulaMax <> '' then begin
                                    //        IF "Cell Type" = "Cell Type"::Number THEN
                                    //          FormulaMax := CONVERTSTR(FormulaMax,',','!');
                                    FormulaMax := MapVariable(FormulaMax, FRef.Value, '%', "Excel Report Line"."Cell Type" = "Excel Report Line"."cell type"::Number);
                                    //        IF "Cell Type" = "Cell Type"::Number THEN BEGIN
                                    //          FormulaMax := DELCHR(FormulaMax,'=',',');
                                    //          FormulaMax := CONVERTSTR(FormulaMax,'!',',');
                                    //        END;
                                    if StrPos(FormulaMax, '#') <> 0 then begin
                                        ExcelBuf.UTgetGlobalValue('CurrentRow', CurrentRow);
                                        FormulaMax := MapVariable(FormulaMax, CurrentRow, '#', false);
                                    end;

                                    ExcelBuf.AddColumn(FormulaMax, not "Excel Report Line"."Show Formula as Text", '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type");
                                end else
                                    if ("Excel Report Line"."Cell Type" = "Excel Report Line"."cell type"::Number) then begin
                                        NumValue := FRef.Value;
                                        if NumValue = 0 then
                                            ExcelBuf.AddColumn('', false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type")
                                        else
                                            ExcelBuf.AddColumn(FRef.Value, false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type");
                                    end else
                                        ExcelBuf.AddColumn(FRef.Value, false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type");
                            end else
                                ExcelBuf.AddColumn('', false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type");

                            RRef.Close();
                        end else
                            if FormulaMax <> '' then begin
                                FormulaMax := MapVariable(FormulaMax, StartLeaveYear, '[STARTLEAVEYEAR]', false);
                                FormulaMax := MapVariable(FormulaMax, SalaryRevDate, '[SALARYREVIEWDATE]', false);
                                if StrPos(FormulaMax, '#') <> 0 then begin
                                    ExcelBuf.UTgetGlobalValue('CurrentRow', CurrentRow);
                                    FormulaMax := MapVariable(FormulaMax, CurrentRow, '#', false);
                                end;
                                if CopyStr(FormulaMax, 1, 1) = '=' then
                                    ExcelBuf.AddColumn(FormulaMax, not "Excel Report Line"."Show Formula as Text", '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type")
                                else
                                    ExcelBuf.AddColumn(FormulaMax, false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type")
                            end else
                                ExcelBuf.AddColumn('', false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type");
                    end else
                        ExcelBuf.AddColumn('', false, '', false, false, false, "Excel Report Line"."Cell Format", "Excel Report Line"."Cell Type");

                end;

                trigger OnPreDataItem()
                begin
                    "Excel Report Line".SetRange("Excel Report Line"."Excel Report Code", ExcelReportCode);
                    ExcelBuf.NewRow;
                end;
            }
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
                    field(StartLeaveYear; StartLeaveYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start/Leave Year';

                        trigger OnValidate()
                        begin
                            SetValues(StartLeaveYear);
                        end;
                    }
                    field(SalaryRevDate; SalaryRevDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Salary Review Date';
                    }
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'To Date';
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
    begin
        SetValues(Date2dmy(Today, 3) + 1);
        ExcelReportCode := 'PERSBUDGET';
    end;

    trigger OnPostReport()
    begin
        CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        if not recExRepPers.Get(ExcelReportCode, UserId()) then
            Error(Text002);

        SI.UseOfReport(3, 50112, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        Text001: label 'Personel Budget';
        recHRRoleHist: Record "HR Role History";
        recHRSalaryLine: Record "HR Salary Line";
        recEmpAbsence: Record "Employee Absence";
        recExRepPers: Record "Excel Report Permission";
        recKPIEntry: Record "HR Zyxel KPI Entry";
        RRef: RecordRef;
        FRef: FieldRef;
        RecordFound: Boolean;
        StartLeaveYear: Integer;
        CurrentRow: Variant;
        SalaryRevDate: Date;
        FromDate: Date;
        ToDate: Date;
        ExcelReportCode: Code[10];
        Text002: label 'You do not have permission to run this report.';
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";


    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBook('', Text001);
        ExcelBuf.WriteSheet(Text001, CompanyName(), UserId());
        ExcelBuf.CloseBook;
        if GuiAllowed() then begin
            ExcelBuf.OpenExcel;
        end;
    end;

    local procedure MapVariable(pString: Text; pValue: Variant; pVariable: Code[50]; pNumberField: Boolean): Text
    var
        ValueText: Text;
    begin
        repeat
            if StrPos(pString, pVariable) <> 0 then begin
                ValueText := Format(pValue);
                if pNumberField then
                    ValueText := ZGT.ConvertToUKDecimalFormat(ValueText);
                pString := StrSubstNo('%1%2%3',
                  CopyStr(pString, 1, StrPos(pString, pVariable) - 1),
                  ValueText,
                  CopyStr(pString, StrPos(pString, pVariable) + StrLen(pVariable), StrLen(pString)));
            end;
        until StrPos(pString, pVariable) = 0;
        exit(pString);
    end;

    local procedure SetValues(pStartLeaveYear: Integer)
    begin
        StartLeaveYear := pStartLeaveYear;
        SalaryRevDate := Dmy2date(30, 6, pStartLeaveYear);
        FromDate := CalcDate('<-CM>', Today);
        FromDate := Dmy2date(Date2dmy(FromDate, 1), Date2dmy(FromDate, 2), pStartLeaveYear);
        ToDate := Dmy2date(31, 12, pStartLeaveYear);
    end;
}
