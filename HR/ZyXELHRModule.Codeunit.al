Codeunit 50041 "ZyXEL HR Module"
{
    // 001. 23-02-18 ZY-LD 0012018022310000133 - Round is added.
    // 002. 22-08-18 ZY-LD 2018050910000191 - Return Value Type on NolidaysDaysThisYear is changed from integer to decimal.
    // 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 003. 02-10-19 ZY-LD 2019100110000032 - Return Value is changed from Integer to Decimal on HolidaysRemainingThisYear.


    trigger OnRun()
    begin
    end;

    var
        ImportTxt: label 'Insert HR File';
        FileDialogTxt: label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        Err001: label 'The content of the document could not be found in the database.';


    procedure SickDaysThisYear(EmployeeNo: Code[20]) Days: Integer
    var
        recSetup: Record "HR Holiday/Sickness Setup";
        SickCode: Code[20];
        recEmployeeAbsence: Record "Employee Absence";
        FirstDayOfYear: Date;
        LastDayOfYear: Date;
    begin
        if recSetup.FindFirst then
            SickCode := recSetup."Sick Code";

        if SickCode <> '' then begin
            FirstDayOfYear := CalcDate('<-CY>', Today);
            LastDayOfYear := CalcDate('<CY>', Today);
            recEmployeeAbsence.SetFilter("Employee No.", EmployeeNo);
            recEmployeeAbsence.SetFilter("Cause of Absence Code", SickCode);
            recEmployeeAbsence.SetRange("From Date", FirstDayOfYear, LastDayOfYear);
            if recEmployeeAbsence.FindFirst then begin
                repeat
                    Days := Days + recEmployeeAbsence.Quantity;
                until recEmployeeAbsence.Next() = 0;
            end;
        end;
    end;


    procedure HolidaysDaysThisYear(EmployeeNo: Code[20]) Days: Decimal
    var
        recSetup: Record "HR Holiday/Sickness Setup";
        HolidayCode: Code[20];
        recEmployeeAbsence: Record "Employee Absence";
        FirstDayOfYear: Date;
        LastDayOfYear: Date;
    begin
        if recSetup.FindFirst then
            HolidayCode := recSetup."Holiday Code";

        if HolidayCode <> '' then begin
            FirstDayOfYear := CalcDate('<-CY>', Today);
            LastDayOfYear := CalcDate('<CY>', Today);
            recEmployeeAbsence.SetFilter("Employee No.", EmployeeNo);
            recEmployeeAbsence.SetFilter("Cause of Absence Code", HolidayCode);
            recEmployeeAbsence.SetRange("From Date", FirstDayOfYear, LastDayOfYear);
            if recEmployeeAbsence.FindFirst then begin
                repeat
                    Days := Days + recEmployeeAbsence.Quantity;
                until recEmployeeAbsence.Next() = 0;
            end;
        end;
    end;


    procedure HolidaysRemainingThisYear(EmployeNo: Code[20]) Days: Decimal
    var
        recEmployee: Record "ZyXEL Employee";
        Entitlement: Integer;
    begin
        recEmployee.SetFilter("No.", EmployeNo);
        if recEmployee.FindFirst then begin
            Entitlement := recEmployee."Holiday Entitlement";
            Days := Entitlement - HolidaysDaysThisYear(EmployeNo);
        end;
    end;


    procedure CalculateSinceToday(StartDate: Date) Years: Integer
    begin
        if StartDate <> 0D then
            Years := ROUND((WorkDate - StartDate) / 365.2364, 1, '<')  // 23-02-18 ZY-LD 001
        else
            Years := 0;
    end;


    procedure CalculateBirthdate(pCurrentAge: Integer; pBirthDate: Date) rValue: Integer
    begin
        //>> 23-02-18 ZY-LD 001
        rValue := pCurrentAge;
        if pBirthDate <> 0D then begin
            if (Date2dmy(pBirthDate, 1) = 29) and (Date2dmy(pBirthDate, 2) = 2) then
                if not Evaluate(pBirthDate, Format(Dmy2date(Date2dmy(pBirthDate, 1), Date2dmy(pBirthDate, 2), Date2dmy(WorkDate, 3)))) then
                    pBirthDate += 1;
            if WorkDate < Dmy2date(Date2dmy(pBirthDate, 1), Date2dmy(pBirthDate, 2), Date2dmy(WorkDate, 3)) then
                rValue += 1;
        end;
        //<< 23-02-18 ZY-LD 001
    end;

    local procedure JobTitle(Employee: Code[20]) JobTitle: Text[50]
    var
        recRoles: Record "HR Role History";
    begin
        recRoles.Ascending(false);
        recRoles.SetRange("Employee No.", Employee);
        if recRoles.FindFirst then JobTitle := recRoles."Job Title";
    end;

    local procedure Manager(Employee: Code[20]) Manager: Text[50]
    var
        recRoles: Record "HR Role History";
        ManagerCode: Code[20];
        recEmployee: Record "ZyXEL Employee";
    begin
        recRoles.Ascending(false);
        recRoles.SetRange("Employee No.", Employee);
        if recRoles.FindFirst then ManagerCode := recRoles."Line Manager";
        if ManagerCode <> '' then begin
            recEmployee.SetFilter("No.", ManagerCode);
            if recEmployee.FindFirst then Manager := recEmployee."Full Name";
        end;
    end;


    procedure UploadFile(EmployeeID: Code[20]; TableID: Integer; RecordID: Text[30])
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        FileName: Text;
        recContent: Record "HR Content";
        RecRef: RecordRef;
    begin
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
        recContent.Init;
        recContent."Created Date" := Today;
        recContent."Created By User Name" := UserId;
        recContent."Employee No." := EmployeeID;
        recContent.TableID := TableID;
        recContent.RecordID := RecordID;
        recContent.Validate(recContent.Extension, Lowercase(CopyStr(FileManagement.GetExtension(FileName), 1, 20)));
        recContent.Name := CopyStr(FileManagement.GetFileNameWithoutExtension(FileName), 1, MaxStrLen(recContent.Name));
        if not TempBlob.Hasvalue then begin
            if FileManagement.ServerFileExists(FileName) then
                FileManagement.BLOBImportFromServerFile(TempBlob, FileName)
            else
                FileManagement.BLOBImportFromServerFile(TempBlob, FileManagement.UploadFile('', FileName));
        end;
        RecRef.GetTable(recContent);
        TempBlob.ToRecordRef(RecRef, recContent.FieldNo(Content));
        recContent.Insert;
    end;
}
