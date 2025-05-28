Report 50091 "GL Entries To Excel"
{
    //26-05-2025 BK #Maria
    Caption = 'GL Entries To Excel';
    ApplicationArea = All;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "Posting Date";

            trigger OnAfterGetRecord()
            var
                DimMgt: Codeunit DimensionManagement;
                TempDimSetEntry: Record "Dimension Set Entry" temporary;
            begin
                clear(TempDimSetEntry);
                Clear(Dim3Value);
                clear(Dim4Value);
                DimMgt.GetDimensionSet(TempDimSetEntry, "G/L Entry"."Dimension Set ID");
                If TempDimSetEntry.FindFirst() then
                    repeat
                        if TempDimSetEntry."Dimension Code" = GLSetup."Shortcut Dimension 3 Code" then
                            Dim3Value := TempDimSetEntry."Dimension Value Code";

                        if TempDimSetEntry."Dimension Code" = GLSetup."Shortcut Dimension 4 Code" then
                            Dim4Value := TempDimSetEntry."Dimension Value Code";
                    until TempDimSetEntry.Next() = 0;
                MakeExcelLine;
            end;

            trigger OnPostDataItem()
            begin
                CreateExcelbook;
            end;

            trigger OnPreDataItem()
            begin
                if GLSetup.get() then;
                MakeExcelHead;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {

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

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        FileMgt: Codeunit "File Management";
        Col: Integer;
        Dim3Value: code[20];
        Dim4Value: code[20];
        Changecolour: Boolean;

        Text002: Label 'GL Entries';

    procedure MakeExcelHead()
    begin
        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Posting Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Document No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("G/L Account No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption(Description), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("External Document No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption(Amount), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Additional-Currency Amount"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Global Dimension 1 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Global Dimension 2 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Shortcut Dimension 3 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Shortcut Dimension 4 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("VAT Prod. Posting Group"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("VAT Bus. Posting Group"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Gen. Bus. Posting Group"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Gen. Prod. Posting Group"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".FieldCaption("Source No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        //<< 28-02-18 ZY-LD 001
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelLine()
    begin
        if Changecolour then begin
            Col := 15;
            Changecolour := false;
        end else begin
            Col := 35;
            Changecolour := true;
        end;
        ExcelBuf.AddColumn("G/L Entry"."Posting Date", false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn("G/L Entry"."Document No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."G/L Account No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".Description, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."External Document No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry".Amount, false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("G/L Entry"."Additional-Currency Amount", false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("G/L Entry"."Global Dimension 1 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."Global Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Dim3Value, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Dim4Value, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."VAT Prod. Posting Group", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."VAT Bus. Posting Group", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."Gen. Bus. Posting Group", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."Gen. Prod. Posting Group", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Entry"."Source No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
    end;


    procedure CreateExcelbook()
    var
        lText001: label 'GL Entries List.xlsx';
    begin
        ExcelBuf.CreateBook('', Text002);
        ExcelBuf.WriteSheet(Text002, CompanyName(), UserId());
        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
            Error('');
        end else begin
        end;
    end;
}
