Report 50060 "Export Category Code"
{
    // 001. 28-02-18 ZY-LD 2018022810000071 - Amounts is added.

    Caption = 'Export Category Code';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = "Purchases (Qty.)", "Purchases (LCY)", "Sales (Qty.)", "Sales (LCY)";
            RequestFilterFields = "No.", Blocked, Status;

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Item."No.", 0, true);
                MakeExcelLine;
            end;

            trigger OnPostDataItem()
            begin
                if "Import/Export" = "import/export"::Export then
                    CreateExcelbook;
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                if "Import/Export" = "import/export"::Import then
                    CurrReport.Break();
                ZGT.OpenProgressWindow('', Item.Count);
                MakeExcelHead;
                Item.SetRange(Item."Date Filter", CalcDate('<-1Y>', Today), Today);
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
                    Caption = 'Options';
                    field("Import/Export"; "Import/Export")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export / Import';
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
        if CompanyName() <> ZGT.GetRHQCompanyName then
            Error(Text001, ZGT.GetRHQCompanyName);

        SI.UseOfReport(3, 50060, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        Col: Integer;
        Changecolour: Boolean;
        "Import/Export": Option Export,Import;
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: label 'Can only be run in %1.';
        Text002: label 'Item Category Codes';
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";


    procedure MakeExcelHead()
    begin
        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Item.FieldCaption("No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Status), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Blocked), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Block Reason"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Category 1 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Category 2 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Category 3 Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Business Center"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(SBU), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("PP-Product CAT"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        //>> 28-02-18 ZY-LD 001
        ExcelBuf.AddColumn(Item.FieldCaption("Purchases (Qty.)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Purchases (LCY)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Sales (Qty.)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Sales (LCY)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
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
        ExcelBuf.AddColumn(Item."No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Item.Status), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Item.Blocked), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Block Reason", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Category 1 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Category 2 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Category 3 Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item."Business Center", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.SBU, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Item."PP-Product CAT"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        //>> 28-02-18 ZY-LD 001
        if Item."Purchases (Qty.)" <> 0 then
            ExcelBuf.AddColumn(Item."Purchases (Qty.)", false, '', false, false, false, '#,###,##0', ExcelBuf."cell type"::Number)
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        if Item."Purchases (LCY)" <> 0 then
            ExcelBuf.AddColumn(Item."Purchases (LCY)", false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number)
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        if Item."Sales (Qty.)" <> 0 then
            ExcelBuf.AddColumn(Item."Sales (Qty.)", false, '', false, false, false, '#,###,##0', ExcelBuf."cell type"::Number)
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        if Item."Sales (LCY)" <> 0 then
            ExcelBuf.AddColumn(Item."Sales (LCY)", false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number)
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        //<< 28-02-18 ZY-LD 001
        ExcelBuf.NewRow;
    end;


    procedure CreateExcelbook()
    var
        lText001: label 'Item Category Code List.xlsx';
    begin
        ExcelBuf.CreateBook('', Text002);
        ExcelBuf.WriteSheet(Text002, CompanyName(), UserId());
        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
            Error('');
        end else begin
            EmailAddMgt.CreateSimpleEmail('CATEGORY', '', '');
            EmailAddMgt.AddAttachment(ExcelBuf.GetFileNameServer, lText001, false);
            EmailAddMgt.Send;
        end;
    end;
}
