Report 50102 "Sales Order Recived - Excel"
{
    // 001. 07-03-18 ZY-LD 2018030710000019 - Country code can be missing on sales order.
    // 002. 11-04-19 ZY-LD 2019041110000034 - "Location Code" is added.
    // 003. 16-08-19 ZY-LD 000 - Don't show customers with "NO FORECAST".
    // 004. 04-08-22 ZY-LD 2022071110000184 - Forecast Territory added.

    Caption = 'Sales Order Recived - Excel';
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            RequestFilterFields = "Create Date", "Sell-to Customer No.", "Bill-to Customer No.", "Shortcut Dimension 1 Code";
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.", "Document Type") order(ascending) where("Document Type" = filter(Order), Type = filter(Item), "BOM Line No." = filter(= 0), Quantity = filter(<> 0));

                trigger OnAfterGetRecord()
                begin
                    AmountSum += "Sales Line".Quantity * "Sales Line"."Unit Price";
                    AmountSumLCY += "Sales Line".Quantity * "Sales Line"."Unit Price" / CurFactor;
                    TotalAmount += AmountSum;
                    TotalAmountLCY += AmountSumLCY;
                end;

                trigger OnPostDataItem()
                begin
                    MakeExcelLine(
                      Format("Sales Header"."Sales Order Type"),
                      "Sales Header"."No.",
                      "Sales Header"."Location Code",  // 11-04-19 ZY-LD 002
                      "Sales Header"."External Document No.",
                      "Sales Header"."Order Date",
                      "Sales Header"."Sell-to Customer No.",
                      "Sales Header"."Sell-to Customer Name",
                      "Sales Header"."Currency Code",
                      CountryRegion.Name,
                      DimSetEntry."Dimension Value Name",
                      recCust."Forecast Territory");  // 04-08-22 ZY-LD 004
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //>> 16-08-19 ZY-LD 003
                recCust.Get("Sales Header"."Sell-to Customer No.");
                if recCust."Forecast Territory" = 'NO FORECAST' then
                    CurrReport.Skip;
                //<< 16-08-19 ZY-LD 003

                CurFactor := "Sales Header"."Currency Factor";
                if CurFactor = 0 then
                    CurFactor := 1;

                AmountSum := 0;
                AmountSumLCY := 0;

                if DimSetEntry.Get("Sales Header"."Dimension Set ID", GlSetup."Shortcut Dimension 3 Code") then
                    DimSetEntry.CalcFields("Dimension Value Name")
                else
                    DimSetEntry."Dimension Value Name" := Text001;  // 07-03-18 ZY-LD 001

                if not CountryRegion.Get("Sales Header"."Bill-to Country/Region Code") then
                    Clear(CountryRegion);
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = where("Sales Order Type" = const(EICard));
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = const(Item), Quantity = filter(<> 0), "BOM Line No." = filter(= 0));

                trigger OnAfterGetRecord()
                begin
                    AmountSum += "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                    AmountSumLCY += "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price" / CurFactor;
                    TotalAmount += AmountSum;
                    TotalAmountLCY += AmountSumLCY;
                end;

                trigger OnPostDataItem()
                begin
                    MakeExcelLine(
                      Format("Sales Invoice Header"."Sales Order Type"),
                      "Sales Invoice Header"."No.",
                      "Sales Invoice Header"."Location Code",  // 11-04-19 ZY-LD 002
                      "Sales Invoice Header"."External Document No.",
                      "Sales Invoice Header"."Order Date",
                      "Sales Invoice Header"."Sell-to Customer No.",
                      "Sales Invoice Header"."Sell-to Customer Name",
                      "Sales Invoice Header"."Currency Code",
                      CountryRegion.Name,
                      DimSetEntry."Dimension Value Name",
                      recCust."Forecast Territory");  // 04-08-22 ZY-LD 004
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Invoice Header"."No.", 0, true);
                CurFactor := "Sales Invoice Header"."Currency Factor";
                if CurFactor = 0 then
                    CurFactor := 1;

                AmountSum := 0;
                AmountSumLCY := 0;

                DimSetEntry.Get("Sales Invoice Header"."Dimension Set ID", GlSetup."Shortcut Dimension 3 Code");
                DimSetEntry.CalcFields("Dimension Value Name");

                if not CountryRegion.Get("Sales Invoice Header"."Bill-to Country/Region Code") then
                    Clear(CountryRegion);

                //>> 04-08-22 ZY-LD 004
                recCust.Get("Sales Invoice Header"."Sell-to Customer No.");
                if recCust."Forecast Territory" = 'NO FORECAST' then
                    CurrReport.Skip;
                //<< 04-08-22 ZY-LD 004
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                "Sales Header".Copyfilter("Shortcut Dimension 1 Code", "Sales Invoice Header"."Shortcut Dimension 1 Code");
                "Sales Header".Copyfilter("Create Date", "Sales Invoice Header"."Order Date");
                "Sales Header".Copyfilter("Sell-to Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                "Sales Header".Copyfilter("Bill-to Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
                ZGT.OpenProgressWindow('', "Sales Invoice Header".Count);
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

    trigger OnPostReport()
    begin
        //MakeExcelGrandFoot;
        CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        MakeExcelHead;
        GlSetup.Get;

        SI.UseOfReport(3, 50102, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        GlSetup: Record "General Ledger Setup";
        CountryRegion: Record "Country/Region";
        recCust: Record Customer;
        Col: Integer;
        ChangeColour: Boolean;
        AmountSum: Decimal;
        AmountSumLCY: Decimal;
        TotalAmount: Decimal;
        TotalAmountLCY: Decimal;
        CurFactor: Decimal;
        ZGT: Codeunit "ZyXEL General Tools";
        FilenameServer: Text;
        Filename: Text;
        Text001: label 'Missing';
        SI: Codeunit "Single Instance";


    procedure Init(pFilename: Text)
    begin
        Filename := pFilename;
    end;


    procedure MakeExcelHead()
    begin
        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Order Type', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Document No.', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Location Code', false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 11-04-19 ZY-LD 002
        ExcelBuf.AddColumn('External Doc. No.', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Creation Date', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Customer No.', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Customer Name', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Currency Code', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Amount', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn('Amount LCY', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn('Country (Dimension)', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Forecast Territory', false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 04-08-22 ZY-LD 004
        //ExcelBuf.AddColumn('Dimension',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelLine(pSalesOrderType: Text[30]; pNo: Code[20]; pLocationCode: Code[20]; pExternalDocNo: Code[50]; pDate: Date; pSellToNo: Code[20]; pSellToName: Text[50]; pCurrencyCode: Code[10]; pCountryCode: Text[50]; pDimensionCode: Text[50]; pForecast: Text)
    begin
        if ChangeColour then begin
            Col := 15;
            ChangeColour := false;
        end else begin
            Col := 35;
            ChangeColour := true;
        end;

        ExcelBuf.AddColumn(pSalesOrderType, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pNo, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pLocationCode, false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 11-04-19 ZY-LD 002
        ExcelBuf.AddColumn(pExternalDocNo, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pDate, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pSellToNo, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pSellToName, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pCurrencyCode, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(AmountSum, false, '', false, false, false, '###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(AmountSumLCY, false, '', false, false, false, '###,##0.00', ExcelBuf."cell type"::Number);
        //ExcelBuf.AddColumn(pCountryCode,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(pDimensionCode, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(pForecast, false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 04-08-22 ZY-LD 004
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelGrandFoot()
    begin
        Col := 37;
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Grand Total:', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TotalAmount, false, '', false, false, false, '###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(TotalAmountLCY, false, '', false, false, false, '###,##0.00', ExcelBuf."cell type"::Number);
    end;


    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBook('', "Sales Header".GetFilter("Create Date"));
        ExcelBuf.WriteSheet('abc', CompanyName(), UserId());
        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
            //Error('');
        end else
            FilenameServer := ExcelBuf.GetFileNameServer;
    end;


    procedure GetFilename(): Text
    begin
        exit(FilenameServer);
    end;
}
