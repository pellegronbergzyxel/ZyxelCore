report 50038 "Import Geneal Journal Lines"
{
    // 29th January 2014
    // Paul Bowden
    // 
    // Import Excel file into General Journal
    // 
    // 001. 03-08-20 ZY-LD 2020073010000062 - Customer is added.
    // 002. 28-04-21 ZY-LD 2021042710000171 - Currency Code is added.

    Caption = 'Import Geneal Journal Lines';
    Description = 'Import Geneal Journal Lines';
    ProcessingOnly = true;

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
                    }
                    field(SheetName; SheetName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Worksheet Name';

                        trigger OnAssistEdit()
                        var
                            ExcelBuf: Record "Excel Buffer";
                        begin
                            SheetName := ExcelBuf.SelectSheetsName(UploadedFileName);
                        end;
                    }
                    field(SheetContainesHeaderRow; SheetContainesHeaderRow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sheet Has Header';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        SheetContainesHeaderRow := true;
    end;

    trigger OnPreReport()
    var
        SkipFirstRow: Boolean;
        CurrentColumn: Integer;
        CreditMemoNo: Code[20];
        Date: Date;
        DocumentNo: Code[20];
        AccountType: Code[30];
        AccountNo: Code[20];
        recGenJournalLine: Record "Gen. Journal Line";
        LastError: Code[20];
        Updated: Integer;
        Created: Integer;
        Amount: Decimal;
        Division: Code[20];
        Department: Code[20];
        Country: Code[20];
        LineNo: Integer;
        Description: Text[50];
        Costtype: Code[20];
        Direction: Text[1];
        Precision: Decimal;
        RowCount: Integer;
        startrow: Integer;
        row: Integer;
        BalAccountNo: Code[20];
        ReasonCode: Code[10];
        VATProdPostGroup: Code[10];
        CurrencyCode: Code[10];
    begin
        SI.UseOfReport(3, 50038, 3);  // 14-10-20 ZY-LD 000

        Direction := '>';
        Precision := 0.1;

        if UploadedFileName = '' then begin
            Message(Text001);
            exit;
        end;
        if SheetName = '' then begin
            Message(Text002);
            exit;
        end;
        ReadExcelSheet();

        Window.Open(Text003 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        if ExcelBuf.FindLast() then begin
            RowCount := ExcelBuf."Row No.";
            startrow := 1;
            if SheetContainesHeaderRow then startrow := 2;
            for row := startrow to RowCount do begin
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / RowCount * 10000, 1));
                Date := 0D;
                DocumentNo := '';
                AccountNo := '';
                Description := '';
                Amount := 0;
                Division := '';
                Department := '';
                Country := '';
                Costtype := '';
                BalAccountNo := '';
                ReasonCode := '';
                AccountType := '';
                VATProdPostGroup := '';
                CurrencyCode := '';  // 28-04-21 ZY-LD 002
                if ExcelBuf.Get(row, 1) then Evaluate(Date, ExcelBuf."Cell Value as Text");
                if ExcelBuf.Get(row, 2) then DocumentNo := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 3) then AccountNo := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 4) then Description := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 5) then Evaluate(Amount, ExcelBuf."Cell Value as Text");
                if ExcelBuf.Get(row, 6) then Division := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 7) then Department := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 8) then Country := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 9) then Costtype := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 10) then BalAccountNo := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 11) then ReasonCode := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 12) then AccountType := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 13) then VATProdPostGroup := ExcelBuf."Cell Value as Text";
                if ExcelBuf.Get(row, 14) then CurrencyCode := ExcelBuf."Cell Value as Text";  // 28-04-21 ZY-LD 002
                recGenJournalLine.Init();
                Amount := Round(Amount, 0.01, '>');
                LineNo := GetNextLineNo("Journal Template Name", "Journal Batch Name");
                recGenJournalLine."Line No." := LineNo;
                recGenJournalLine."Journal Template Name" := "Journal Template Name";
                recGenJournalLine."Journal Batch Name" := "Journal Batch Name";
                recGenJournalLine."Posting Date" := Date;
                recGenJournalLine."Document No." := DocumentNo;
                case (AccountType) of
                    'VENDOR':
                        recGenJournalLine."Account Type" := recGenJournalLine."account type"::Vendor;
                    'G/L ACCOUNT', '':
                        recGenJournalLine."Account Type" := recGenJournalLine."account type"::"G/L Account";
                    'CUSTOMER':
                        recGenJournalLine."Account Type" := recGenJournalLine."account type"::Customer;  // 03-08-20 ZY-LD 001
                end;
                recGenJournalLine.Validate("Account No.", AccountNo);
                recGenJournalLine.Description := Description;

                recGenJournalLine.Validate(Amount, Amount);
                recGenJournalLine.Validate("Amount (LCY)", Amount);

                recGenJournalLine.Validate("Shortcut Dimension 1 Code", Division);
                recGenJournalLine.Validate("Shortcut Dimension 2 Code", Department);
                recGenJournalLine.ValidateShortcutDimCode(3, Country);
                recGenJournalLine.ValidateShortcutDimCode(4, Costtype);
                recGenJournalLine."Bal. Account No." := BalAccountNo;
                recGenJournalLine."Reason Code" := ReasonCode;
                recGenJournalLine.Validate("VAT Prod. Posting Group", VATProdPostGroup);
                if CurrencyCode <> '' then  // 28-04-21 ZY-LD 002
                    recGenJournalLine.Validate("Currency Code", CurrencyCode);  // 28-04-21 ZY-LD 002
                recGenJournalLine.Insert(true);
            end;
        end;
        Window.Close();
    end;

    var
        FileName: Text[250];
        SheetName: Text[250];
        ExcelBuf: Record "Excel Buffer" temporary;
        UploadedFileName: Text[1024];
        Text006: Label 'Import Excel File';
        RecNo: Integer;
        Window: Dialog;
        Text001: Label 'You must specify an Excel file first.';
        Text002: Label 'You must specify the sheet name to import first.';
        Text003: Label 'Analyzing Data...\\';
        TotalRecNo: Integer;
        SheetContainesHeaderRow: Boolean;
        "Journal Template Name": Code[10];
        "Journal Batch Name": Code[10];
        Text19047774: Label 'Worksheet Name';
        Text19051956: Label 'Contains Headings';
        CountryDim: Code[20];
        CosttypeDim: Code[20];
        SI: Codeunit "Single Instance";

    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
    begin
        //UploadedFileName := CommonDialogMgt.OpenFile(Text006,'',2,'',0);
        //UploadedFileName := FileMgt.OpenFileDialog(Text006,'','');

        Upload('Upload', 'C:\', 'Excel file(*.xlsx)|*.xlsx', '', UploadedFileName);
        FileName := UploadedFileName;
    end;

    local procedure ReadExcelSheet()
    begin
        if UploadedFileName = '' then
            UploadFile()
        else
            FileName := UploadedFileName;

        ExcelBuf.OpenBook(FileName, SheetName);
        ExcelBuf.ReadSheet();
    end;

    local procedure FormatData(TextToFormat: Text[250]): Text[250]
    var
        FormatInteger: Integer;
        FormatDecimal: Decimal;
        FormatDate: Date;
    begin
        case true of
            Evaluate(FormatInteger, TextToFormat):
                exit(Format(FormatInteger));
            Evaluate(FormatDecimal, TextToFormat):
                exit(Format(FormatDecimal));
            Evaluate(FormatDate, TextToFormat):
                exit(Format(FormatDate));
            else
                exit(TextToFormat);
        end;
    end;

    procedure SetInitialValues(JournalTemplateName: Code[10]; JournalBatchName: Code[10])
    begin
        "Journal Template Name" := JournalTemplateName;
        "Journal Batch Name" := JournalBatchName;
    end;

    procedure GetNextLineNo(JournalTemplateName: Code[20]; JournalBatchName: Code[20]) LastLineNo: Integer
    var
        recGenJournalLine: Record "Gen. Journal Line";
    begin
        recGenJournalLine.SetFilter("Journal Template Name", JournalTemplateName);
        recGenJournalLine.SetFilter("Journal Batch Name", JournalBatchName);
        if recGenJournalLine.FindFirst() then begin
            repeat
                LastLineNo := recGenJournalLine."Line No.";
            until recGenJournalLine.Next() = 0;
        end;
        LastLineNo := LastLineNo + 10000;
    end;
}
