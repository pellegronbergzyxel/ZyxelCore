Report 62038 "Import Concur Travel Expense"
{
    // 001. 16-10-20 ZY-LD 2020101510000192 - Import of "Payer Payment Type".
    // 002. 21-10-20 ZY-LD 2020101210000205 - Check on the existense of "Country Code", "VAT Prod Posting Group" and G/L Account. // 29-11-21 ZY-LD - After implementing Turkish G/L Account No. we can´t validate G/L Account
    // 003. 17-12-20 ZY-LD 2020121710000131 - If the line is splitted, car milage is set to zero on the copied line, so we don´t calculate it twice.
    // 004. 27-08-21 ZY-LD 2021082610000058 - Employee is added as option.
    // 005. 17-01-22 ZY-LD 000 - Handling Cash Advance.
    // 006. 10-05-22 ZY-LD 2022050610000081 - Cash advance was not setup correct.
    // 007. 09-06-22 ZY-LD 2022060910000056 - Cash advance must be handled different in TR.
    // 008. 30-05-23 ZY-LD 6905495 - New fields.
    // 009. 24-09-24 ZY-LD 000 - Users often write wrong dimensions in Concur, therefore we now read the dimensions internally instead.

    Caption = 'Import Concur Travel Expense';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Import Credit Memo Lines';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Import from")
                    {
                        Caption = 'Import from';
                        field(FileName; FileName)
                        {
                            ApplicationArea = Basic, Suite;
                            AssistEdit = true;
                            Caption = 'Workbook File Name';

                            trigger OnAssistEdit()
                            begin
                                UploadFile;
                            end;
                        }
                        field(SheetName; SheetName)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Worksheet Name';

                            trigger OnAssistEdit()
                            var
                                ExcelBuf: Record "Excel Buffer";
                            begin
                                SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                            end;
                        }
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

    trigger OnPreReport()
    begin
        if UploadedFileName = '' then
            Error(Text001);

        if SheetName = '' then
            Error(Text002);

        if ZGT.IsRhq and ZGT.IsZNetCompany then
            Error(Text004);

        CDT := CurrentDatetime;
        ReadExcelSheet;
        ImportExcelSheet;

        recTrExpHead.SetRange("Importing Date", CDT);
        recTrExpHead.ModifyAll("Document Status", recTrExpHead."document status"::Open);

        SI.UseOfReport(3, 62038, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        recTrExpHead: Record "Travel Expense Header";
        recCostType: Record "Cost Type Name";
        FileName: Text[1024];
        SheetName: Text[1024];
        ExcelBuf: Record "Excel Buffer" temporary;
        UploadedFileName: Text[1024];
        DimType: Option "Cost Type",Country,Departmant,Division;
        RecNo: Integer;
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'You must specify the sheet name to import first.';
        TotalRecNo: Integer;
        Text003: label 'Importing Sheet';
        Text004: label 'The import can only run from ZCom RHQ.';
        Text005: label 'Travel Expence BatchID %1 has been imported.\\Reported Line(s): %2, Inserted Line(s): %3.\Reported Amount: %4, Inserted Amount %5\\Inserted Document(s): %6\Rejected Document(s): %7.';
        Text006: label '"%1" %2 is not a part of the option field.';
        Text007: label 'The "%1" "%2" is not allowed.\\Review the setup in Concur. This code should not occur in Concur.\Correct the value in the Excel sheet, and import again.';
        Text19047774: label 'Worksheet Name';
        No: Code[20];
        ExpectedRows: Integer;
        ExpectedAmount: Decimal;
        BatchID: Code[10];
        ConcurID: Code[20];
        ZGT: Codeunit "ZyXEL General Tools";
        ImportedRows: Integer;
        ImportedAmount: Decimal;
        BalVendAmount: Decimal;
        CDT: DateTime;
        SI: Codeunit "Single Instance";
        HeaderDate: Date;
        InsertedDocuments: Integer;
        RejectedDocuments: Integer;


    procedure InitReport(NewFilename: Text)
    begin
        FileName := NewFilename;
        UploadedFileName := FileName;
        SheetName := ExcelBuf.SelectSheetsName(FileName);
    end;

    local procedure ImportExcelSheet()
    var
        recTrExpLine: Record "Travel Expense Line";
        recDimSplit: Record "Dimension Split Pct.";
        recTrExpType: Record "Travel Exp. Expense Type";
        recGLAcc: Record "G/L Account";
        recGenSetup: Record "General Ledger Setup";
        recConcurSetup: Record "Concur Setup";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        RowCount: Integer;
        Row: Integer;
        StartRow: Integer;
        SplitAmount: Decimal;
        SplittedAmount: Decimal;
        CurrentLineHandled: Boolean;
        OldDimensionInplacement: Boolean;
        lText001: label 'Travel Expense';
        lText002: label 'Unknown type "%1". Value is coming from column 250 in the Excel Sheet.';
    begin
        recConcurSetup.Get;

        if ExcelBuf.FindLast then begin
            ReadFileHeader;
            if ExpectedRows > 0 then begin
                FindDataRows(StartRow, RowCount);
                ZGT.OpenProgressWindow('', RowCount);

                for Row := StartRow to RowCount do begin
                    ZGT.UpdateProgressWindow(Text003, 0, true);

                    if GetTravelExpHeader(Row, OldDimensionInplacement) then begin
                        Clear(recTrExpLine);
                        recTrExpLine.Init;
                        recTrExpLine."Document No." := recTrExpHead."No.";
                        if ExcelBuf.Get(Row, 4) then begin
                            Evaluate(recTrExpLine."Concur Sequence No.", ExcelBuf."Cell Value as Text");
                            recTrExpLine."Line No." := recTrExpLine."Concur Sequence No." * 10000;
                        end;

                        if ExcelBuf.Get(Row, 168) then  // Debit / Credit
                            case UpperCase(ExcelBuf."Cell Value as Text") of
                                'CR':
                                    recTrExpLine.Validate("Debit / Credit Type", recTrExpLine."debit / credit type"::CR);
                                'DR':
                                    recTrExpLine.Validate("Debit / Credit Type", recTrExpLine."debit / credit type"::DR);
                            end;
                        //>> 16-10-20 ZY-LD 001
                        if ExcelBuf.Get(Row, 163) then  // Journal Payer Payment Type Name
                            case UpperCase(ExcelBuf."Cell Value as Text") of
                                'COMPANY':
                                    recTrExpLine.Validate("Payer Payment Type", recTrExpLine."payer payment type"::Company);
                                'ZYXEL MASTERCARD':
                                    recTrExpLine.Validate("Payer Payment Type", recTrExpLine."payer payment type"::"Master Card");
                                'VAT':
                                    recTrExpLine.Validate("Payer Payment Type", recTrExpLine."payer payment type"::VAT);
                                'TVA10':
                                    recTrExpLine.Validate("Payer Payment Type", recTrExpLine."payer payment type"::TVA10);
                                'TVA20':
                                    recTrExpLine.Validate("Payer Payment Type", recTrExpLine."payer payment type"::TVA20);
                                'EMPLOYEE':
                                    recTrExpLine.Validate("Payer Payment Type", recTrExpLine."payer payment type"::Employee);  // 27-08-21 ZY-LD 004
                                else
                                    if recTrExpLine."Debit / Credit Type" = recTrExpLine."debit / credit type"::DR then
                                        Error(Text006, recTrExpLine.FieldCaption("Payer Payment Type"), ExcelBuf."Cell Value as Text");
                            end;
                        //<< 16-10-20 ZY-LD 001

                        //>> 10-05-22 ZY-LD 006
                        /*IF (ExcelBuf.GET(Row,68) AND (UPPERCASE(ExcelBuf."Cell Value as Text") = 'Y')) THEN  // Personal Expense
                          recTrExpLine.Type := recTrExpLine.Type::"Personal Expense";
                        IF ExcelBuf.GET(Row,126) AND (UPPERCASE(ExcelBuf."Cell Value as Text") = 'CASH') THEN  // Out of Pocket
                          recTrExpLine.Type := recTrExpLine.Type::"Out of Pocket";
                        //>> 17-01-22 ZY-LD 005
                        IF ExcelBuf.GET(Row,250) AND (UPPERCASE(ExcelBuf."Cell Value as Text") = 'CASH ADVANCE') THEN  // Cash Advance
                          recTrExpLine.Type := recTrExpLine.Type::"Cash Advance";
                        //<< 17-01-22 ZY-LD 005*/
                        if ExcelBuf.Get(Row, 250) then
                            case UpperCase(ExcelBuf."Cell Value as Text") of
                                'CASH ADVANCE',
                              'CASH ADVANCE RETURN':
                                    recTrExpLine.Validate(Type, recTrExpLine.Type::"Cash Advance");  // Cash Advance
                                'OUT OF POCKET':
                                    recTrExpLine.Validate(Type, recTrExpLine.Type::"Out of Pocket");  // Out of Pocket
                                'ZYXEL MASTERCARD':
                                    recTrExpLine.Validate(Type, recTrExpLine.Type::Company);  // Company
                                else
                                    Error(lText002, ExcelBuf."Cell Value as Text");
                            end;
                        if (ExcelBuf.Get(Row, 68) and (UpperCase(ExcelBuf."Cell Value as Text") = 'Y')) then  // Personal Expense
                            recTrExpLine.Type := recTrExpLine.Type::"Personal Expense";
                        //<< 10-05-22 ZY-LD 006

                        case recTrExpLine.Type of
                            recTrExpLine.Type::Company:
                                begin
                                    recTrExpLine."Account Type" := recTrExpLine."account type"::"G/L Account";
                                    if ExcelBuf.Get(Row, 167) then begin  // Account No.
                                                                          //recGLAcc.GET(ExcelBuf."Cell Value as Text");  // 21-10-20 ZY-LD 002  // 29-11-21 ZY-LD 002
                                        recTrExpLine."Account No." := ExcelBuf."Cell Value as Text";
                                    end;

                                    //recTrExpLine."Bal. Account Type" := recTrExpLine."Bal. Account Type"::Vendor;  // 03-03-21 ZY-LD 004
                                    recTrExpLine."Bal. Account Type" := recCostType."Bal. Account Type";  // 03-03-21 ZY-LD 004
                                    recTrExpLine."Bal. Account No." := recCostType."Concur Credit Card Vendor No."
                                end;
                            recTrExpLine.Type::"Personal Expense":
                                begin
                                    recTrExpLine."Account Type" := recTrExpLine."account type"::Vendor;
                                    recTrExpLine."Account No." := recCostType."Concur Personal Vendor No.";

                                    //recTrExpLine."Bal. Account Type" := recTrExpLine."Bal. Account Type"::Vendor;  // 03-03-21 ZY-LD 004
                                    recTrExpLine."Bal. Account Type" := recCostType."Bal. Account Type";  // 03-03-21 ZY-LD 004
                                    recTrExpLine."Bal. Account No." := recCostType."Concur Credit Card Vendor No."
                                end;
                            recTrExpLine.Type::"Out of Pocket":
                                begin
                                    recTrExpLine."Account Type" := recTrExpLine."account type"::"G/L Account";
                                    if ExcelBuf.Get(Row, 167) then begin  // Account No.
                                                                          //recGLAcc.GET(ExcelBuf."Cell Value as Text");  // 21-10-20 ZY-LD 002  // 29-11-21 ZY-LD 002
                                        recTrExpLine."Account No." := ExcelBuf."Cell Value as Text";
                                    end;

                                    //>> 10-05-22 ZY-LD 006 - Moved to Cash Advance.
                                    /*//>> 16-11-21 ZY-LD 005
                                    IF ExcelBuf.GET(Row,165) AND (UPPERCASE(ExcelBuf."Cell Value as Text") = 'CASH ADVANCE') THEN BEGIN
                                      recConcurSetup.TESTFIELD("Cash Advance Account No.");
                                      recTrExpLine."Bal. Account Type" := recTrExpLine."Bal. Account Type"::"G/L Account";
                                      recTrExpLine."Bal. Account No." := recConcurSetup."Cash Advance Account No.";
                                    END ELSE BEGIN  //<< 16-11-21 ZY-LD 005*/  //<< 10-05-22 ZY-LD 006
                                                                               //recTrExpLine."Bal. Account Type" := recTrExpLine."Bal. Account Type"::Vendor;  // 03-03-21 ZY-LD 004
                                    recTrExpLine."Bal. Account Type" := recCostType."Bal. Account Type";  // 03-03-21 ZY-LD 004
                                    recTrExpLine."Bal. Account No." := recCostType."Concur Personal Vendor No."
                                    //END;
                                end;
                            //>> 10-05-22 ZY-LD 006
                            recTrExpLine.Type::"Cash Advance":
                                begin
                                    if ExcelBuf.Get(Row, 167) then  // Account No.
                                        recTrExpLine."Account No." := ExcelBuf."Cell Value as Text";
                                    //>> 09-06-22 ZY-LD 007
                                    if StrPos(recCostType."Concur Company Name", 'TR') <> 0 then begin
                                        recTrExpLine."Bal. Account Type" := recCostType."Bal. Account Type";
                                        recTrExpLine."Bal. Account No." := recCostType."Concur Credit Card Vendor No.";
                                    end else begin  //<< 09-06-22 ZY-LD 007
                                        recConcurSetup.TestField("Cash Advance Account No.");
                                        recTrExpLine.Validate("Bal. Account No.", recConcurSetup."Cash Advance Account No.");
                                    end;
                                end;
                        //<< 10-05-22 ZY-LD 006
                        end;

                        if ExcelBuf.Get(Row, 69) then  // Business Purpose
                            recTrExpLine."Business Purpose" := ExcelBuf."Cell Value as Text";
                        if ExcelBuf.Get(Row, 70) then  // Vendor Name
                            recTrExpLine."Vendor Name" := ExcelBuf."Cell Value as Text";
                        if ExcelBuf.Get(Row, 71) then  // Vendor Description
                            recTrExpLine."Vendor Description" := ExcelBuf."Cell Value as Text";
                        if ExcelBuf.Get(Row, 63) then begin  // Expense Type
                            recTrExpLine."Expense Type" := ExcelBuf."Cell Value as Text";
                            if not recTrExpType.Get(recTrExpLine."Expense Type") then begin
                                recTrExpType.Code := recTrExpLine."Expense Type";
                                recTrExpType.Name := recTrExpLine."Expense Type";
                                recTrExpType.Insert;
                            end;
                        end;
                        if ExcelBuf.Get(Row, 64) then  // Transaction Date
                            recTrExpLine."Transaction Date" := ZGT.ConvertTextToDate(ExcelBuf."Cell Value as Text", 1);
                        //>> 30-05-23 ZY-LD 008
                        IF ExcelBuf.GET(Row, 336) THEN  // From Location
                            recTrExpLine."From Location" := ExcelBuf."Cell Value as Text";
                        IF ExcelBuf.GET(Row, 337) THEN  // To Location
                            recTrExpLine."To Location" := ExcelBuf."Cell Value as Text";
                        //<< 30-05-23 ZY-LD 008

                        GetConcurID(row);  // 24-09-24 ZY-LD 009
                        recGenSetup.Get;
                        if OldDimensionInplacement then begin
                            if ExcelBuf.Get(Row, 193) then  // Division Code
                                recTrExpLine.Validate("Division Code - Concur", ExcelBuf."Cell Value as Text");
                            if ExcelBuf.Get(Row, 194) then  // Department Code
                                if recTrExpLine."Account Type" = recTrExpLine."account type"::"G/L Account" then begin
                                    recTrExpLine.Validate("Department Code - Zyxel", GetDimensionValue(recTrExpLine."Account No.", recGenSetup."Global Dimension 2 Code", ExcelBuf."Cell Value as Text"));
                                    recTrExpLine."Department Code - Concur" := ExcelBuf."Cell Value as Text";
                                end else
                                    recTrExpLine.Validate("Department Code - Zyxel", ExcelBuf."Cell Value as Text");
                            if ExcelBuf.Get(Row, 191) then  // Country Code
                                if ExcelBuf."Cell Value as Text" <> 'UK' then
                                    recTrExpLine.Validate("Country Code", ExcelBuf."Cell Value as Text")
                                else
                                    Error(Text007, recTrExpLine.FieldCaption("Country Code"), ExcelBuf."Cell Value as Text");
                        end else begin
                            //>> 24-09-24 ZY-LD 009
                            recTrExpLine."Division Code - Zyxel" := GetCostNameDim(ConcurID, DimType::Division);  // Division Code (192)
                            if recTrExpLine."Account Type" = recTrExpLine."account type"::"G/L Account" then  // Department Code (193)
                                recTrExpLine."Department Code - Zyxel" := GetDimensionValue(recTrExpLine."Account No.", recGenSetup."Global Dimension 2 Code", GetCostNameDim(ConcurID, DimType::Departmant))
                            else
                                recTrExpLine."Department Code - Zyxel" := GetCostNameDim(ConcurID, DimType::Departmant);
                            recTrExpLine."Country Code" := GetCostNameDim(ConcurID, DimType::Country);  // Country Code (194)

                            // if ExcelBuf.Get(Row, 192) then  // Division Code
                            //     recTrExpLine.Validate("Division Code - Concur", ExcelBuf."Cell Value as Text");
                            // if ExcelBuf.Get(Row, 193) then  // Department Code
                            //     if recTrExpLine."Account Type" = recTrExpLine."account type"::"G/L Account" then begin
                            //         recTrExpLine.Validate("Department Code - Zyxel", GetDimensionValue(recTrExpLine."Account No.", recGenSetup."Global Dimension 2 Code", ExcelBuf."Cell Value as Text"));
                            //         recTrExpLine."Department Code - Concur" := ExcelBuf."Cell Value as Text";
                            //     end else
                            //         recTrExpLine.Validate("Department Code - Zyxel", ExcelBuf."Cell Value as Text");
                            // if ExcelBuf.Get(Row, 194) then  // Country Code
                            //     recTrExpLine.Validate("Country Code", ExcelBuf."Cell Value as Text");
                            //<< 24-09-24 ZY-LD 009
                        end;

                        //>> 24-09-24 ZY-LD 009
                        // if ExcelBuf.Get(Row, 197) and (ExcelBuf."Cell Value as Text" <> '') then  // Cost Type - Line
                        //     recTrExpLine."Cost Type" := GetCostType(ExcelBuf."Cell Value as Text")
                        // else
                        //     if ExcelBuf.Get(Row, 5) and (ExcelBuf."Cell Value as Text" <> '') then  // Cost Type - Header
                        //         recTrExpLine."Cost Type" := GetCostType(ExcelBuf."Cell Value as Text");
                        recTrExpLine."Cost Type" := GetCostNameDim(ConcurID, DimType::"Cost Type");
                        //<< 24-09-24 ZY-LD 009

                        if ExcelBuf.Get(Row, 65) then  // Purchasing Currency Code
                            recTrExpLine.Validate("Purchasing Currency Code", ExcelBuf."Cell Value as Text");
                        if ExcelBuf.Get(Row, 137) then begin  // Purchasing Amount
                            Evaluate(recTrExpLine."Purchasing Amount", ExcelBuf."Cell Value as Text", 9);
                            recTrExpLine.Validate("Purchasing Amount");
                        end;
                        if ExcelBuf.Get(Row, 22) then  // Currency Code
                            recTrExpLine.Validate("Currency Code", ExcelBuf."Cell Value as Text");

                        if ExcelBuf.Get(Row, 171) then begin  // Car Business Distance
                            Evaluate(recTrExpLine."Car Business Distance", ExcelBuf."Cell Value as Text", 9);
                            recTrExpLine.Validate("Car Business Distance");
                        end;
                        if ExcelBuf.Get(Row, 172) then begin  // Car Personal Distance
                            Evaluate(recTrExpLine."Car Personal Distance", ExcelBuf."Cell Value as Text", 9);
                            recTrExpLine.Validate("Car Personal Distance");
                        end;
                        if ExcelBuf.Get(Row, 174) then  // Vehicle Id
                            recTrExpLine.Validate("Vehicle Id", ExcelBuf."Cell Value as Text");

                        if ExcelBuf.Get(Row, 120) then begin  // VAT Code
                            if ExcelBuf."Cell Value as Text" = '' then
                                recTrExpLine.Validate("VAT Prod. Posting Group", '0')
                            else
                                if ExcelBuf."Cell Value as Text" <> 'NO VAT' then
                                    recTrExpLine.Validate("VAT Prod. Posting Group", ExcelBuf."Cell Value as Text")
                                else
                                    Error(Text007, recTrExpLine.FieldCaption("VAT Prod. Posting Group"), ExcelBuf."Cell Value as Text");
                        end else
                            recTrExpLine.Validate("VAT Prod. Posting Group", '0');

                        if ExcelBuf.Get(Row, 169) then begin  // Amount
                            Evaluate(recTrExpLine."Original Amount", ExcelBuf."Cell Value as Text", 9);
                            recTrExpLine.Validate("Original Amount");
                        end;

                        ImportedRows += 1;
                        ImportedAmount += recTrExpLine."Original Amount";
                        recTrExpLine.Insert(true);

                        // Split line
                        //IF recTrExpLine."Debit / Credit Type" = recTrExpLine."Debit / Credit Type"::DR THEN BEGIN
                        if recTrExpLine."Show Expense" then begin
                            //recDimSplit.SetRange("Dimension Code", recTrExpLine."Division Code - Concur");  // 24-09-24 ZY-LD 009
                            recDimSplit.SetRange("Source Type", recDimSplit."Source Type"::Division);  // 24-09-24 ZY-LD 009
                            recDimSplit.SetRange("Dimension Code", recTrExpLine."Division Code - Zyxel");  // 24-09-24 ZY-LD 009
                            if recDimSplit.FindSet then begin
                                SplitAmount := recTrExpLine.Amount;
                                SplittedAmount := 0;
                                CurrentLineHandled := false;
                                repeat
                                    recTrExpLine.Validate("Division Code - Zyxel", recDimSplit."Dimension Split Code");
                                    recTrExpLine.Validate(Amount, ROUND(SplitAmount * (recDimSplit."Split %" / 100)));
                                    if not CurrentLineHandled then begin
                                        recTrExpLine.Modify(true);
                                        CurrentLineHandled := true;
                                    end else begin
                                        recTrExpLine.Validate("Line No.", recTrExpLine."Line No." + 100);
                                        recTrExpLine."Car Business Distance" := 0;  // 17-12-20 ZY-LD 003
                                        recTrExpLine."Car Personal Distance" := 0;  // 17-12-20 ZY-LD 003
                                        recTrExpLine.Insert(true);
                                    end;

                                    SplittedAmount += recTrExpLine.Amount;
                                until recDimSplit.Next() = 0;

                                if SplitAmount <> SplittedAmount then begin
                                    recTrExpLine.Validate(Amount, recTrExpLine.Amount + (SplitAmount - SplittedAmount));
                                    recTrExpLine.Modify(true);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        ZGT.CloseProgressWindow;
        if GuiAllowed then
            Message(Text005, BatchID, ExpectedRows, ImportedRows, ExpectedAmount, ImportedAmount, InsertedDocuments, RejectedDocuments)
        else begin
            recConcurSetup.TestField("Import Success E-mail Code");
            recConcurSetup.TestField("No Lines to Import E-mail Code");
            SI.SetMergefield(100, lText001);
            SI.SetMergefield(101, Format(HeaderDate));
            SI.SetMergefield(102, Format(InsertedDocuments));
            SI.SetMergefield(103, Format(RejectedDocuments));
            if ExpectedRows > 0 then begin
                if InsertedDocuments > 0 then begin
                    EmailAddMgt.CreateSimpleEmail(recConcurSetup."Import Success E-mail Code", '', '');
                    EmailAddMgt.Send;
                end;
                if RejectedDocuments > 0 then begin
                    EmailAddMgt.CreateSimpleEmail(recConcurSetup."Rejected E-mail Code", '', '');
                    EmailAddMgt.Send;
                end;
            end else begin
                EmailAddMgt.CreateSimpleEmail(recConcurSetup."No Lines to Import E-mail Code", '', '');
                EmailAddMgt.Send;
            end;
        end;

    end;

    local procedure ReadFileHeader()
    begin
        ExcelBuf.Reset;
        if ExcelBuf.FindSet then
            repeat
                if ExcelBuf."Cell Value as Text" = 'EXTRACT' then
                    ExcelBuf.SetRange("Row No.", ExcelBuf."Row No.");
            until (ExcelBuf.Next() = 0) or (ExcelBuf.GetFilter("Row No.") <> '');

        if ExcelBuf.FindSet then
            repeat
                case ExcelBuf."Column No." of
                    2:
                        Evaluate(HeaderDate, ExcelBuf."Cell Value as Text", 9);
                    3:
                        Evaluate(ExpectedRows, ExcelBuf."Cell Value as Text", 9);
                    4:
                        Evaluate(ExpectedAmount, ExcelBuf."Cell Value as Text", 9);
                    5:
                        BatchID := ExcelBuf."Cell Value as Text";
                end;
            until ExcelBuf.Next() = 0;
    end;

    local procedure FindDataRows(var pStartRow: Integer; var pRowCount: Integer)
    begin
        ExcelBuf.Reset;
        ExcelBuf.SetRange("Column No.", 1);
        ExcelBuf.SetRange("Cell Value as Text", 'DETAIL');
        if ExcelBuf.FindFirst then
            pStartRow := ExcelBuf."Row No.";
        if ExcelBuf.FindLast then
            pRowCount := ExcelBuf."Row No.";
    end;

    local procedure ReadExcelSheet()
    begin
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;
        ExcelBuf.OpenBook(FileName, SheetName);
        ExcelBuf.ReadSheet;
    end;

    local procedure UploadFile()
    var
        recConcurSetup: Record "Concur Setup";
        FileMgt: Codeunit "File Management";
    begin
        recConcurSetup.Get;
        if recConcurSetup."Import Folder - Travel Expense" = '' then
            recConcurSetup."Import Folder - Travel Expense" := 'C:\';
        Upload('Upload', recConcurSetup."Import Folder - Travel Expense", 'Excel file(*.xlsx)|*.xlsx', '', UploadedFileName);
        FileName := UploadedFileName;
        ExcelBuf.SelectSheetsName(UploadedFileName);
    end;

    local procedure GetConcurID(pRow: Integer) rValue: Code[20]
    begin
        if ExcelBuf.Get(pRow, 197) and (ExcelBuf."Cell Value as Text" <> '') then  // Cost Type - Line
            ConcurID := ExcelBuf."Cell Value as Text"
        else
            if ExcelBuf.Get(pRow, 5) and (ExcelBuf."Cell Value as Text" <> '') then  // Cost Type - Header
                ConcurID := ExcelBuf."Cell Value as Text";
    end;

    procedure GetTravelExpHeader(pRow: Integer; var pOldDimensionInplacement: Boolean) rValue: Boolean
    var
        CcReportID: Code[20];
        xEmployeeNo: Code[40];
        IntVar: Integer;
        lText002: label 'Cost type (Column 5) was not found.';
    begin
        ExcelBuf.Get(pRow, 19);
        CcReportID := ExcelBuf."Cell Value as Text";
        if recTrExpHead."Concur Report ID" <> CcReportID then begin
            recTrExpHead.SetRange("Concur Report ID", CcReportID);
            if not recTrExpHead.FindFirst then begin
                Clear(recTrExpHead);
                recTrExpHead.Init;
                recTrExpHead.Insert(true);
                recTrExpHead."Concur Report ID" := CcReportID;

                if ExcelBuf.Get(pRow, 5) and (ExcelBuf."Cell Value as Text" <> '') then
                    GetCostNameDim(ExcelBuf."Cell Value as Text", DimType::"Cost Type")  // 24-09-24 ZY-LD 009
                else
                    Error(lText002);
                recTrExpHead."Cost Type Name" := recCostType.Code;
                recTrExpHead."Concur Company Name" := recCostType."Concur Company Name";
                recTrExpHead."Concur Batch ID" := BatchID;

                if ExcelBuf.Get(pRow, 27) then  // Description
                    recTrExpHead."Concur Report Name" := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(pRow, 26) then  // Posting Date
                    recTrExpHead."Posting Date" := ZGT.ConvertTextToDate(ExcelBuf."Cell Value as Text", 1);
                if ExcelBuf.Get(pRow, 9) then
                    if ExcelBuf."Cell Value as Text" <> 'UK' then
                        recTrExpHead."Country Code" := ValidateCountryCode(ExcelBuf."Cell Value as Text")
                    else
                        Error(Text007, recTrExpHead.FieldCaption("Country Code"), ExcelBuf."Cell Value as Text");

                pOldDimensionInplacement := false;
                if ExcelBuf.Get(pRow, 192) then
                    if Evaluate(IntVar, ExcelBuf."Cell Value as Text") then
                        pOldDimensionInplacement := true;
                recTrExpHead."Importing Date" := CDT;
                recTrExpHead.Modify(true);

                InsertedDocuments += 1;
                rValue := true;
            end else
                if recTrExpHead."Document Status" = recTrExpHead."document status"::Importing then
                    rValue := true
                else
                    RejectedDocuments += 1;
        end else
            if recTrExpHead."Document Status" = recTrExpHead."document status"::Importing then
                rValue := true;

        if recCostType.Code <> recTrExpHead."Cost Type Name" then
            recCostType.Get(recTrExpHead."Cost Type Name");
    end;

    local procedure ValidateCountryCode(pCountryCode: Code[10]): Code[10]
    var
        recGenSetup: Record "General Ledger Setup";
        recDimValue: Record "Dimension Value";
        lText001: label 'Country Code %1 is not valid.';
    begin
        //>> 21-10-20 ZY-LD 002
        recGenSetup.Get;
        if not recDimValue.Get(recGenSetup."Shortcut Dimension 3 Code", pCountryCode) or recDimValue.Blocked then
            Error(lText001, pCountryCode);
        exit(pCountryCode);
        //<< 21-10-20 ZY-LD 002
    end;

    local procedure GetCostNameDim(pEmployeeNo: Code[40]; pDimType: Option "Cost Type",Country,Departmant,Division) rValue: Code[20]
    begin
        if StrLen(pEmployeeNo) > 30 then
            Error(Text007, 'Cost Type/Concur ID', pEmployeeNo);

        if (recCostType.Code <> pEmployeeNo) and (recCostType."Concur Id" <> pEmployeeNo) then begin
            recCostType.Reset;
            if not recCostType.Get(pEmployeeNo) then begin
                recCostType.SetRange("Concur Id", pEmployeeNo);
                recCostType.FindFirst;
            end;
            recCostType.TestField("Concur Company Name");
            //recCostType.TESTFIELD("Concur Credit Card Vendor No.");
            //recCostType.TESTFIELD("Concur Personal Vendor No.");
        end;

        //>> 23-09-24 ZY-LD 009
        //rValue := recCostType.Code;
        case pDimType of
            pDimType::"Cost Type":
                rValue := recCostType.Code;
            pDimType::Country:
                rValue := recCostType.Country;
            pDimType::Departmant:
                rValue := recCostType.Department;
            pDimType::Division:
                rValue := recCostType.Division;
        end;
        //<<< 23-09-24 ZY-LD 009
    end;

    local procedure GetDimensionValue(pAccountNo: Code[20]; pDimensionCode: Code[20]; pDimensionCodeValue: Code[20]) rValue: Code[20]
    var
        recDefDim: Record "Default Dimension";
    begin
        if recDefDim.Get(Database::"G/L Account", pAccountNo, pDimensionCode) and (recDefDim."Mandatory Concur Dimension" <> '') then
            rValue := recDefDim."Mandatory Concur Dimension"
        else
            rValue := pDimensionCodeValue;
    end;

    local procedure xConvertAmount(pAmountStr: Text) rValue: Decimal
    var
        EvaluateTest: Decimal;
        DevideBy: Integer;
        i: Integer;
        j: Integer;
    begin
        if StrLen(pAmountStr) > 1 then
            pAmountStr := DelChr(pAmountStr, '>', '0');

        for i := StrLen(pAmountStr) downto StrLen(pAmountStr) - 2 do begin
            if i > 0 then begin
                if (pAmountStr[i] = '.') or (pAmountStr[i] = ',') then
                    DevideBy := j;

                if j = 0 then
                    j := 10
                else
                    j := j * 10;
            end;
        end;
        if DevideBy = 0 then
            DevideBy := 1;

        pAmountStr := DelChr(pAmountStr, '=', ',.');
        Evaluate(rValue, pAmountStr);
        rValue := rValue / DevideBy;
    end;
}
