Report 50061 "Travel Expense Document"
{
    // 001. 16-10-20 ZY-LD 2020101510000192 - Filter is changed on the line.

    Caption = 'Travel Expense Document';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;
    AdditionalSearchTerms = 'concur';

    dataset
    {
        dataitem("Travel Expense Header"; "Travel Expense Header")
        {
            CalcFields = Amount, "Currency Code", "Employee Name";
            RequestFilterFields = "No.";
            dataitem("Travel Expense Line"; "Travel Expense Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where("Show Expense" = const(true));

                trigger OnAfterGetRecord()
                begin
                    MakeExcelLine;
                end;

                trigger OnPostDataItem()
                begin
                    CreateExcelbook("Travel Expense Header"."No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ExcelBuf.DeleteAll;
                ExcelBuf.ClearNewRow;
                MakeExcelHead;
            end;

            trigger OnPostDataItem()
            begin
                CloseExcelbook;
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

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50061, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        Col: Integer;
        ExcelBookCreated: Boolean;
        Text001: label 'HEADER';
        Text002: label 'LINES';
        DoNotGiveUserControl: Boolean;
        SI: Codeunit "Single Instance";


    procedure InitReport(pDoNotGiveUserControl: Boolean)
    begin
        DoNotGiveUserControl := pDoNotGiveUserControl;
    end;


    procedure MakeExcelHead()
    var
        recSalesShipHead: Record "Sales Shipment Header";
        lText001: label 'Full Name';
        lText002: label ' To';
        lText003: label ' From';
        lText004: label 'Manager Full Name';
        lText005: label 'Employee ID';
    begin
        begin
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn(Text001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header"."No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header"."Concur Batch ID"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."Concur Batch ID", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header"."Concur Report Name"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."Concur Report Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header"."Employee Name"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."Employee Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header"."Posting Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."Posting Date", false, '', false, false, false, '', ExcelBuf."cell type"::Date);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header"."Currency Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."Currency Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Travel Expense Header".Amount), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header".Amount, false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        end;
        begin
            ExcelBuf.NewRow;
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn(Text002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line".Type), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Expense Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Account Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Account No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Business Purpose"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Division Code - Zyxel"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Department Code - Zyxel"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header".FieldCaption("Cost Type Name"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."VAT Prod. Posting Group"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Currency Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line".Amount), false, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Bal. Account Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line".FieldCaption("Travel Expense Line"."Bal. Account No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
        end;
    end;


    procedure MakeExcelLine()
    var
        recHrHist: Record "HR Role History";
    begin
        begin
            ExcelBuf.AddColumn(Format("Travel Expense Line".Type), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(Format("Travel Expense Line"."Expense Type"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(Format("Travel Expense Line"."Account Type"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."Account No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."Business Purpose", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."Division Code - Zyxel", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."Department Code - Zyxel", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Header"."Cost Type Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."VAT Prod. Posting Group", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."Currency Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(Format("Travel Expense Line".Amount), false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
            ExcelBuf.AddColumn(Format("Travel Expense Line"."Bal. Account Type"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn("Travel Expense Line"."Bal. Account No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.NewRow;
        end;
    end;


    procedure CreateExcelbook(SheetName: Text)
    begin
        if not ExcelBookCreated then begin
            ExcelBuf.CreateBook('', SheetName);
            ExcelBuf.WriteSheet(SheetName, CompanyName(), UserId());
            ExcelBookCreated := true;
        end else begin
            ExcelBuf.AddNewSheet(SheetName);
            ExcelBuf.WriteSheet(SheetName, CompanyName(), UserId());
        end;
    end;


    procedure CloseExcelbook()
    begin
        ExcelBuf.CloseBook;

        if GuiAllowed and (not DoNotGiveUserControl) then begin
            ExcelBuf.OpenExcel;
        end;
    end;


    procedure GetFilename(): Text
    begin
        exit(ExcelBuf.GetFileNameServer);
    end;
}
