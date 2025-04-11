tableextension 50169 ExcelBufferZX extends "Excel Buffer"
{
    fields
    {
        field(50000; Center; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50001; Width; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50002; BackColor; Integer)
        {
            Description = 'PAB 1.0';
            InitValue = -1;
        }
        field(50003; ForeColor; Integer)
        {
            Description = 'PAB 1.0';
            InitValue = -1;
        }
        field(50004; "Cell Comment as Text"; Text[250])
        {
            Description = 'PAB 1.0';
        }
    }

    local procedure CreateBookAndSaveExcel(SheetName: Text[250]; ReportHeader: Text[80]; CompanyName: Text[30]; UserID2: Text[30])
    begin
        //CreateBook(SheetName);
        Rec.WriteSheet(ReportHeader, CompanyName, UserID2);
        Rec.CloseBook;
        //SaveExcel;
    end;

    procedure AddNewSheet(SheetName: Text[30])
    begin
        //>> 10-10-17 ZY-LD 001
        Rec.SelectOrAddSheet(SheetName);
        Rec.ClearNewRow;
        //<< 10-10-17 ZY-LD 001
    end;

    procedure GetFileNameServer(): Text
    var
        ServerFileName: Text;
        ServerFileNameVar: Variant;
    begin
        Rec.UTgetGlobalValue('ExcelFile', ServerFileNameVar);
        ServerFileName := Format(ServerFileNameVar);
        exit(ServerFileName);
    end;
}
