Report 50023 "Exp. Acc. Sched. Entry to Ex."
{
    Caption = 'Export Acc. Sched. Entry to Excel';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                TempDimSetEntry: Record "Dimension Set Entry" temporary;
                GLSetup: Record "General Ledger Setup";
                DimMgt: Codeunit DimensionManagement;
                Window: Dialog;
                RecNo: Integer;
                TotalRecNo: Integer;
                RowNo: Integer;
                ClientFileName: Text;
                ShortcutDimCode: array[8] of Code[20];
            begin
                if DoUpdateExistingWorksheet then
                    if not UploadClientFile(ClientFileName, ServerFileName) then
                        exit;

                Window.Open(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
                Window.Update(1, 0);
                AccSchedLine.SetFilter(Show, '<>%1', AccSchedLine.Show::No);
                TotalRecNo := AccSchedLine.Count;
                RecNo := 0;

                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);

                AccSchedName.Get(AccSchedLine.GetRangeMin("Schedule Name"));
                AccSchedManagement.CheckAnalysisView(AccSchedName.Name, ColumnLayout.GetRangeMin("Column Layout Name"), true);
                if AccSchedName."Analysis View Name" <> '' then
                    AnalysisView.Get(AccSchedName."Analysis View Name");
                GLSetup.Get;

                RowNo := 1;
                EnterCell(RowNo, Text001, false, false, true, false, '', TempExcelBuffer."cell type"::Text);
                if AccSchedLine.GetFilter("Date Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("Date Filter"),
                      AccSchedLine.FieldCaption("Date Filter"),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;
                if AccSchedLine.GetFilter("G/L Budget Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("G/L Budget Filter"),
                      AccSchedLine.FieldCaption("G/L Budget Filter"),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;

                if AccSchedLine.GetFilter("Cost Budget Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("Cost Budget Filter"),
                      AccSchedLine.FieldCaption("Cost Budget Filter"),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;

                if AccSchedLine.GetFilter("Dimension 1 Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("Dimension 1 Filter"),
                      GetDimFilterCaption(1),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;
                if AccSchedLine.GetFilter("Dimension 2 Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("Dimension 2 Filter"),
                      GetDimFilterCaption(2),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;
                if AccSchedLine.GetFilter("Dimension 3 Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("Dimension 3 Filter"),
                      GetDimFilterCaption(3),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;
                if AccSchedLine.GetFilter("Dimension 4 Filter") <> '' then begin
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      AccSchedLine.GetFilter("Dimension 4 Filter"),
                      GetDimFilterCaption(4),
                      '',
                      TempExcelBuffer."cell type"::Text);
                end;

                GLSetup.Get();
                DimMgt.GetDimensionSet(TempDimSetEntry, recGLEntry."Dimension Set ID");
                AccSchedLine.Copyfilter("Date Filter", recGLEntry."Posting Date");
                AccSchedLine.Copyfilter("Dimension 1 Filter", recGLEntry."Global Dimension 1 Code");
                AccSchedLine.Copyfilter("Dimension 2 Filter", recGLEntry."Global Dimension 2 Code");
                TempDimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if not TempDimSetEntry.FindFirst() then
                    Clear(TempDimSetEntry);
                AccSchedLine.Copyfilter("Dimension 3 Filter", TempDimSetEntry."Dimension Value Code");
                TempDimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                if not TempDimSetEntry.FindFirst() then
                    Clear(TempDimSetEntry);
                AccSchedLine.Copyfilter("Dimension 4 Filter", TempDimSetEntry."Dimension Value Code");
                AccSchedLine.SetFilter(Totaling, '<>%1', '');
                if AccSchedLine.FindSet then begin
                    RowNo := RowNo + 2;
                    ColumnNo := 0;
                    EnterCell(RowNo, Text003, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text004, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text005, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text006, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text007, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text008, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text009, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text010, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text011, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text012, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text013, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text014, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text015, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text016, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text017, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text018, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text019, true, false, false, false, '', TempExcelBuffer."cell type"::Text);
                    EnterCell(RowNo, Text020, true, false, false, false, '', TempExcelBuffer."cell type"::Text);

                    repeat
                        recGLEntry.SetFilter("G/L Account No.", AccSchedLine.Totaling);
                        recGLEntry.SetAutocalcFields("G/L Account Name");
                        if recGLEntry.FindSet then
                            repeat
                                RowNo := RowNo + 1;
                                ColumnNo := 0;

                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, recGLEntry."Document No.", false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, Format(recGLEntry."Posting Date", 0, 9), false, false, false, false, 'yyyy-MM-dd', TempExcelBuffer."cell type"::Date);
                                EnterCell(RowNo, AccSchedLine."Row No.", false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, AccSchedLine.Description, false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, recGLEntry."Document No.", false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, Format(recGLEntry."Posting Date", 0, 9), false, false, false, false, 'yyyy-MM-dd', TempExcelBuffer."cell type"::Date);
                                EnterCell(RowNo, recGLEntry.Description, false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, Format(recGLEntry."Debit Amount"), false, false, false, false, '##,###,##0.00', TempExcelBuffer."cell type"::Number);
                                EnterCell(RowNo, Format(recGLEntry."Credit Amount"), false, false, false, false, '##,###,##0.00', TempExcelBuffer."cell type"::Number);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, Format(Today, 0, 9), false, false, false, false, 'yyyy-MM-dd', TempExcelBuffer."cell type"::Date);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                                EnterCell(RowNo, '', false, false, false, false, '', TempExcelBuffer."cell type"::Text);
                            until recGLEntry.Next() = 0;
                    until AccSchedLine.Next() = 0;
                end;

                /*
                RowNo := RowNo + 1;
                IF UseAmtsInAddCurr THEN BEGIN
                  IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      GLSetup."Additional Reporting Currency",
                      Currency.TABLECAPTION,
                      '',
                      TempExcelBuffer."Cell Type"::Text)
                  END;
                END ELSE
                  IF GLSetup."LCY Code" <> '' THEN BEGIN
                    RowNo := RowNo + 1;
                    EnterFilterInCell(
                      RowNo,
                      GLSetup."LCY Code",
                      Currency.TABLECAPTION,
                      '',
                      TempExcelBuffer."Cell Type"::Text);
                  END;
                
                RowNo := RowNo + 1;
                IF AccSchedLine.FIND('-') THEN BEGIN
                  IF ColumnLayout.FIND('-') THEN BEGIN
                    RowNo := RowNo + 1;
                    ColumnNo := 2; // Skip the "Row No." column.
                    REPEAT
                      ColumnNo := ColumnNo + 1;
                      EnterCell(
                        RowNo,
                        ColumnNo,
                        ColumnLayout."Column Header",
                        FALSE,
                        FALSE,
                        FALSE,
                        FALSE,
                        '',
                        TempExcelBuffer."Cell Type"::Text);
                    UNTIL ColumnLayout.Next() = 0;
                  END;
                  REPEAT
                    RecNo := RecNo + 1;
                    Window.UPDATE(1,ROUND(RecNo / TotalRecNo * 10000,1));
                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell(
                      RowNo,
                      ColumnNo,
                      AccSchedLine."Row No.",
                      AccSchedLine.Bold,
                      AccSchedLine.Italic,
                      AccSchedLine.Underline,
                      AccSchedLine."Double Underline",
                      '0',
                      TempExcelBuffer."Cell Type"::Number);
                    ColumnNo := 2;
                    EnterCell(
                      RowNo,
                      ColumnNo,
                      AccSchedLine.Description,
                      AccSchedLine.Bold,
                      AccSchedLine.Italic,
                      AccSchedLine.Underline,
                      AccSchedLine."Double Underline",
                      '',
                      TempExcelBuffer."Cell Type"::Text);
                    IF ColumnLayout.FIND('-') THEN BEGIN
                      REPEAT
                        IF AccSchedLine.Totaling = '' THEN
                          ColumnValue := 0
                        ELSE BEGIN
                          ColumnValue := AccSchedManagement.CalcCell(AccSchedLine,ColumnLayout,UseAmtsInAddCurr);
                          IF AccSchedManagement.GetDivisionError THEN
                            ColumnValue := 0
                        END;
                        ColumnNo := ColumnNo + 1;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          MatrixMgt.FormatValue(ColumnValue,ColumnLayout."Rounding Factor",UseAmtsInAddCurr),
                          AccSchedLine.Bold,
                          AccSchedLine.Italic,
                          AccSchedLine.Underline,
                          AccSchedLine."Double Underline",
                          '',
                          TempExcelBuffer."Cell Type"::Number)
                      UNTIL ColumnLayout.Next() = 0;
                    END;
                  UNTIL AccSchedLine.Next() = 0;
                END;
                */

                Window.Close;

                if DoUpdateExistingWorksheet then begin
                    TempExcelBuffer.UpdateBook(ServerFileName, SheetName);
                    TempExcelBuffer.WriteSheet('', CompanyName(), UserId());
                    TempExcelBuffer.CloseBook;
                    if not TestMode then
                        TempExcelBuffer.DownloadAndOpenExcel
                end else begin
                    TempExcelBuffer.CreateBook(ServerFileName, AccSchedName.Name);
                    TempExcelBuffer.WriteSheet(AccSchedName.Description, CompanyName(), UserId());
                    TempExcelBuffer.CloseBook;
                    if not TestMode then
                        TempExcelBuffer.OpenExcel;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Analyzing Data...\\';
        Text001: label 'Filters';
        Text002: label 'Update Workbook';
        AccSchedName: Record "Acc. Schedule Name";
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        AnalysisView: Record "Analysis View";
        Currency: Record Currency;
        recGLEntry: Record "G/L Entry";
        AccSchedManagement: Codeunit AccSchedManagement;
        MatrixMgt: Codeunit "Matrix Management";
        FileMgt: Codeunit "File Management";
        UseAmtsInAddCurr: Boolean;
        ColumnValue: Decimal;
        ServerFileName: Text;
        SheetName: Text[250];
        DoUpdateExistingWorksheet: Boolean;
        Text003: label 'JournalCode';
        Text004: label 'JournalLib';
        Text005: label 'EcritureNum';
        Text006: label 'EcritureDate';
        Text007: label 'CompteNum';
        Text008: label 'CompteLib';
        Text009: label 'CompAuxNum';
        Text010: label 'CompAuxLib';
        Text011: label 'PieceRef';
        Text012: label 'PieceDate';
        Text013: label 'EcritureLib';
        Text014: label 'Debit';
        Text015: label 'Credit';
        Text016: label 'EcritureLet';
        Text017: label 'DateLet';
        Text018: label 'ValidDate';
        Text019: label 'Montantdevise';
        Text020: label 'Idevise';
        ExcelFileExtensionTok: label '.xlsx', Locked = true;
        TestMode: Boolean;
        ColumnNo: Integer;


    procedure SetOptions(var AccSchedLine2: Record "Acc. Schedule Line"; ColumnLayoutName2: Code[10]; UseAmtsInAddCurr2: Boolean)
    begin
        AccSchedLine.CopyFilters(AccSchedLine2);
        ColumnLayout.SetRange("Column Layout Name", ColumnLayoutName2);
        UseAmtsInAddCurr := UseAmtsInAddCurr2;
    end;

    local procedure EnterFilterInCell(RowNo: Integer; "Filter": Text[250]; FieldName: Text[100]; Format: Text[30]; CellType: Option)
    begin
        if Filter <> '' then begin
            ColumnNo := 0;
            EnterCell(RowNo, FieldName, false, false, false, false, '', TempExcelBuffer."cell type"::Text);
            EnterCell(RowNo, Filter, false, false, false, false, Format, CellType);
        end;
    end;

    local procedure EnterCell(RowNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; DoubleUnderLine: Boolean; Format: Text[30]; CellType: Option)
    begin
        ColumnNo := ColumnNo + 1;

        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        if DoubleUnderLine = true then begin
            TempExcelBuffer."Double Underline" := true;
            TempExcelBuffer.Underline := false;
        end else begin
            TempExcelBuffer."Double Underline" := false;
            TempExcelBuffer.Underline := UnderLine;
        end;
        TempExcelBuffer.NumberFormat := Format;
        TempExcelBuffer."Cell Type" := CellType;
        TempExcelBuffer.Insert;
    end;

    local procedure GetDimFilterCaption(DimFilterNo: Integer): Text[80]
    var
        Dimension: Record Dimension;
    begin
        if AccSchedName."Analysis View Name" = '' then
            case DimFilterNo of
                1:
                    Dimension.Get(GLSetup."Global Dimension 1 Code");
                2:
                    Dimension.Get(GLSetup."Global Dimension 2 Code");
            end
        else
            case DimFilterNo of
                1:
                    Dimension.Get(AnalysisView."Dimension 1 Code");
                2:
                    Dimension.Get(AnalysisView."Dimension 2 Code");
                3:
                    Dimension.Get(AnalysisView."Dimension 3 Code");
                4:
                    Dimension.Get(AnalysisView."Dimension 4 Code");
            end;
        exit(CopyStr(Dimension.GetMLFilterCaption(GlobalLanguage), 1, 80));
    end;


    procedure SetUpdateExistingWorksheet(UpdateExistingWorksheet: Boolean)
    begin
        DoUpdateExistingWorksheet := UpdateExistingWorksheet;
    end;


    procedure SetFileNameSilent(NewFileName: Text)
    begin
        ServerFileName := NewFileName;
    end;


    procedure SetTestMode(NewTestMode: Boolean)
    begin
        TestMode := NewTestMode;
    end;

    local procedure UploadClientFile(var ClientFileName: Text; var ServerFileName: Text): Boolean
    begin
        ServerFileName := FileMgt.UploadFile(Text002, ExcelFileExtensionTok);

        if ServerFileName = '' then
            exit(false);

        SheetName := TempExcelBuffer.SelectSheetsName(ServerFileName);
        if SheetName = '' then
            exit(false);

        exit(true);
    end;
}
