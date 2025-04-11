Report 50056 "Update Default Action Code"
{
    Caption = 'Update Default Action Code';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

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
                    }
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
                        begin
                            GetSheetName;
                        end;
                    }
                    field(SheetContainesHeaderRow; SheetContainesHeaderRow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contains Headings';
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
        SheetContainesHeaderRow := true;
        ActionCodeColumn := 'A';
        EmailColumn := 'F';
        CommentColumn := 'G';
        ImportedRows := 0;
    end;

    trigger OnPostReport()
    begin
        Message(Text004, ImportedRows, RowCount);
    end;

    trigger OnPreReport()
    var
        AmountDecimal: Decimal;
        EmailValue: Code[20];
        CommentValue: Code[20];
    begin
        SI.UseOfReport(3, 50042, 3);  // 14-10-20 ZY-LD 000

        if UploadedFileName = '' then
            Error(Text001);
        if SheetName = '' then
            Error(Text002);

        ReadExcelSheet;
        Window.Open(Text003 + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        if ExcelBuf.FindLast then begin
            RowCount := ExcelBuf."Row No.";
            StartRow := 1;
            if SheetContainesHeaderRow then
                StartRow := 3;

            for Row := StartRow to RowCount do begin
                RecNo := RecNo + 1;
                Window.Update(1, ROUND(RecNo / RowCount * 10000, 1));

                if ExcelBuf.Get(Row, ZGT.GetColumnNumber(ActionCodeColumn)) then begin
                    recActionCode.Get(ExcelBuf."Cell Value as Text");

                    EmailValue := '';
                    CommentValue := '';
                    if ExcelBuf.Get(Row, ZGT.GetColumnNumber(EmailColumn)) then
                        EmailValue := UpperCase(ExcelBuf."Cell Value as Text");
                    if ExcelBuf.Get(Row, ZGT.GetColumnNumber(CommentColumn)) then
                        CommentValue := UpperCase(ExcelBuf."Cell Value as Text");

                    if (EmailValue <> '') and (CommentValue = '') then begin
                        case EmailValue of
                            'NOTIFICATION':
                                recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::"E-mail Notification (Pre-Adv)");
                            'STOT-REQUEST':
                                if StrPos(UpperCase(recActionCode.Description), 'SLOT REQUEST:') <> 0 then
                                    recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::"E-mail Slot-Request");
                            else
                                Error('?');
                        end;

                        if ((StrPos(UpperCase(recActionCode.Description), 'PRE-ADV') <> 0) or
                            (StrPos(UpperCase(recActionCode.Description), 'SLOT REQUEST:') <> 0) or
                            (StrPos(UpperCase(recActionCode.Description), 'SLOTREQUEST:') <> 0)) and
                           (StrPos(recActionCode.Description, '@') <> 0)
                        then begin
                            recActionCode."Original Description" := recActionCode.Description;
                            recActionCode.Description := ConvertStr(recActionCode.Description, '&', ';');
                            recActionCode.Description := CopyStr(recActionCode.Description, StrPos(recActionCode.Description, ':'), StrLen(recActionCode.Description));
                            recActionCode.Description := ZGT.ValidateEmailAdd(recActionCode.Description);
                        end;
                    end else begin
                        if (EmailValue = '') and (CommentValue <> '') then begin
                            case CommentValue of
                                'EXPORT':
                                    recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::Export);
                                'GENERAL':
                                    recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::General);
                                'PACKING':
                                    recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::Packing);
                                'PICKING/PACKING':
                                    recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::Picking);
                                'TRANSPORT':
                                    recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::Transport);
                                else
                                    Error('??');
                            end;
                        end else
                            recActionCode.Validate("Default Comment Type", recActionCode."default comment type"::Value99);
                    end;
                    recActionCode.Modify(true);
                end;
            end;
        end;
        Window.Close;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recDelDocSNo: Record "VCK Delivery Document SNos";
        recCust: Record Customer;
        recActionCode: Record "Action Codes";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        FileName: Text[1024];
        SheetName: Text[1024];
        UploadedFileName: Text[1024];
        RecNo: Integer;
        Window: Dialog;
        Text001: label 'You must specify an Excel file first.';
        Text002: label 'You must specify the sheet name to import first.';
        Text003: label 'Loading Additional Item Lines...\\';
        SheetContainesHeaderRow: Boolean;
        RowCount: Integer;
        Row: Integer;
        StartRow: Integer;
        Text004: label 'For %1 out of %2 rows has the Pallet No. been attached to a Serial No.';
        ImportedRows: Integer;
        ActionCodeColumn: Code[1];
        EmailColumn: Code[1];
        CommentColumn: Code[1];
        DelDocNo: Code[20];


    procedure Init(pPurchHead: Record "Purchase Header")
    begin
        recPurchHead := pPurchHead;
    end;

    local procedure UploadFile()
    begin
        Upload('Upload', 'C:\', 'Excel file(*.xlsx)|*.xlsx', '', UploadedFileName);
        FileName := UploadedFileName;
        GetSheetName;
    end;

    local procedure GetSheetName()
    begin
        SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
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
}
