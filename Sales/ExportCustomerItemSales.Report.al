Report 50004 "Export Customer/Item Sales"
{
    // // Added category 1 -3 codes 09/04/18 2018040910000317
    // 001. 23-10-18 ZY-LD 2018102210000058 - Ship-to Code is added.
    // 002. 14-01-22 ZY-LD 2022011110000051 - Show External Document No. and Del. Doc No.

    Caption = 'Export Customer/Item Sales';
    Description = 'Export Customer/Item Sales';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            CalcFields = "Sales (LCY)";
            RequestFilterFields = "No.";
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Source No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Source Type", "Source No.", "Item Ledger Entry Type", "Item No.", "Posting Date") where("Source Type" = const(Customer), "Item Ledger Entry Type" = filter(<> " "));
                RequestFilterFields = "Posting Date", "Global Dimension 1 Code";

                trigger OnAfterGetRecord()
                var
                    dint: Integer;
                    mint: Integer;
                    yint: Integer;
                    dstr: Text;
                    mstr: Text;
                    ystr: Text;
                begin
                    //"Value Entry".SETRANGE ("Value Entry"."Source Code", 'SALES');
                    Item.Get("Value Entry"."Item No.");

                    if item.Type <> item.Type::Inventory then
                        CurrReport.Skip();

                    //>> 23-10-18 ZY-LD 001
                    ShipToCode := '';
                    ShipToName := '';
                    ExtDocNo := '';  // 14-01-22 ZY-LD 002
                    DelDocNo := '';  // 14-01-22 ZY-LD 002
                    case "Value Entry"."Document Type" of
                        "Value Entry"."document type"::"Sales Invoice":
                            if recSalesInvHead.Get("Value Entry"."Document No.") then begin
                                ShipToCode := recSalesInvHead."Ship-to Code";
                                ShipToName := copystr(recSalesInvHead."Ship-to Name", 1, 50);
                                ExtDocNo := recSalesInvHead."Your Reference";  // 14-01-22 ZY-LD 002
                                DelDocNo := recSalesInvHead."Picking List No.";  // 14-01-22 ZY-LD 002
                                if recSalesInvHead."Currency Code" <> '' then begin
                                    Currency.get(recSalesInvHead."Currency Code");
                                    CurrencyFactor := recSalesInvHead."Currency Factor";
                                end;

                            end;
                        "Value Entry"."document type"::"Sales Credit Memo":
                            if recSalesCrMemoHead.Get("Value Entry"."Document No.") then begin
                                ShipToCode := recSalesCrMemoHead."Ship-to Code";
                                ShipToName := copystr(recSalesCrMemoHead."Ship-to Name", 1, 50);
                                ExtDocNo := recSalesCrMemoHead."Your Reference";  // 14-01-22 ZY-LD 002
                                if recSalesCrMemoHead."Currency Code" <> '' then begin
                                    Currency.get(recSalesCrMemoHead."Currency Code");
                                    CurrencyFactor := recSalesCrMemoHead."Currency Factor";
                                end;
                            end;
                    end;

                    //<< 23-10-18 ZY-LD 001

                    if ("Value Entry"."Invoiced Quantity" <> 0) then begin
                        EnterCell(RowNo, 1, CompanyName(), false, false, false);
                        EnterCell(RowNo, 2, Customer."No.", false, false, false);
                        EnterCell(RowNo, 3, Customer.Name + ' ' + Customer."Name 2", false, false, false);
                        EnterCell(RowNo, 4, Customer.Address, false, false, false);
                        EnterCell(RowNo, 5, Customer."Post Code", false, false, false);
                        EnterCell(RowNo, 6, Customer.City, false, false, false);
                        if Customer."Country/Region Code" = '' then
                            EnterCell(RowNo, 7, 'DE', false, false, false)
                        else
                            if Customer."Country/Region Code" = 'A' then
                                EnterCell(RowNo, 7, 'AT', false, false, false)
                            else
                                EnterCell(RowNo, 7, Customer."Country/Region Code", false, false, false);

                        EnterCell(RowNo, 8, Customer."VAT Registration No.", false, false, false);
                        EnterCell(RowNo, 9, Customer."Phone No.", false, false, false);
                        dint := Date2dmy("Value Entry"."Posting Date", 1);
                        mint := Date2dmy("Value Entry"."Posting Date", 2);
                        yint := Date2dmy("Value Entry"."Posting Date", 3);
                        dstr := Format(dint);
                        mstr := Format(mint);
                        ystr := Format(yint);
                        if StrLen(dstr) = 1 then dstr := '0' + dstr;
                        if StrLen(mstr) = 1 then mstr := '0' + mstr;
                        if StrLen(ystr) = 1 then ystr := '0' + ystr;
                        EnterCell(RowNo, 10, dstr + '/' + mstr + '/' + ystr, false, false, false);
                        EnterCell(RowNo, 11, "Value Entry"."Document No.", false, false, false);
                        EnterCell(RowNo, 12, Format("Value Entry"."Entry No."), false, false, false);
                        EnterCell(RowNo, 13, Format("Value Entry"."Invoiced Quantity" * (-1)), false, false, false);
                        EnterCell(RowNo, 14, '', false, false, false);
                        EnterCell(RowNo, 15, "Value Entry"."Item No.", false, false, false);
                        // 489194 >>
                        // EnterCell(RowNo, 16, Item.Description, false, false, false);
                        if "Value Entry".Description <> '' then
                            EnterCell(RowNo, 16, "Value Entry".Description, false, false, false)
                        else
                            EnterCell(RowNo, 16, Item.Description, false, false, false);
                        // 489194 <<
                        if "Value Entry"."Sales Amount (Actual)" <> 0 then
                            EnterCell(RowNo, 17, Format(ROUND("Value Entry"."Sales Amount (Actual)" / "Value Entry"."Invoiced Quantity" * (-1), 0.01, '<')), false, false, false)
                        else
                            EnterCell(RowNo, 17, '0', false, false, false);
                        EnterCell(RowNo, 18, Format(ROUND("Value Entry"."Sales Amount (Actual)", 0.01, '<')), false, false, false);
                        EnterCell(RowNo, 19, 'EUR', false, false, false);
                        EnterCell(RowNo, 20, Format(Round("Value Entry"."Sales Amount (Actual)" * -1 * CurrencyFactor / "Value Entry"."Invoiced Quantity", Currency."Amount Rounding Precision", '<')), false, false, false);
                        EnterCell(RowNo, 21, Format(Round("Value Entry"."Sales Amount (Actual)" * CurrencyFactor, Currency."Amount Rounding Precision", '<')), false, false, false);
                        EnterCell(RowNo, 22, Currency.Code, false, false, false);
                        EnterCell(RowNo, 23, Customer."Global Dimension 1 Code", false, false, false);

                        // PAB 09/04/18
                        EnterCell(RowNo, 24, Item."Category 1 Code", false, false, false);
                        EnterCell(RowNo, 25, Item."Category 2 Code", false, false, false);
                        EnterCell(RowNo, 26, Item."Category 3 Code", false, false, false);
                        EnterCell(RowNo, 27, ShipToCode, false, false, false);  // 23-10-18 ZY-LD 001
                        EnterCell(RowNo, 28, ShipToName, false, false, false);  // 24-11-20 ZY-LD 001
                        EnterCell(RowNo, 29, ExtDocNo, false, false, false);  // 14-01-22 ZY-LD 002
                        EnterCell(RowNo, 30, DelDocNo, false, false, false);  // 14-01-22 ZY-LD 002

                        RowNo := RowNo + 1;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Customer."No.", 0, true);
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                EnterCell(RowNo, 1, 'Distributor Name', true, false, false);
                EnterCell(RowNo, 2, 'Customer No.', true, false, false);
                EnterCell(RowNo, 3, 'Customer Name', true, false, false);
                EnterCell(RowNo, 4, 'Customer Address', true, false, false);
                EnterCell(RowNo, 5, 'Customer Post Code', true, false, false);
                EnterCell(RowNo, 6, 'Customer City', true, false, false);
                EnterCell(RowNo, 7, 'Customer Country', true, false, false);
                EnterCell(RowNo, 8, 'Customer VAT No.', true, false, false);
                EnterCell(RowNo, 9, 'Customer Telephone No.', true, false, false);
                EnterCell(RowNo, 10, 'Posting Date', true, false, false);
                EnterCell(RowNo, 11, 'Document No.', true, false, false);
                EnterCell(RowNo, 12, 'Entry No.', true, false, false);
                EnterCell(RowNo, 13, 'Invoiced Qty.', true, false, false);
                EnterCell(RowNo, 14, 'Item No.', true, false, false);
                EnterCell(RowNo, 15, 'ZyXEL Item No.', true, false, false);
                EnterCell(RowNo, 16, 'Item Description', true, false, false);
                EnterCell(RowNo, 17, 'Invoiced Amount', true, false, false);
                EnterCell(RowNo, 18, 'Sales Amount', true, false, false);
                EnterCell(RowNo, 19, 'Currency Code', true, false, false);
                EnterCell(RowNo, 20, 'Original Invoiced Amount', true, false, false);
                EnterCell(RowNo, 21, 'Original Sales Amount', true, false, false);
                EnterCell(RowNo, 22, 'Original Currency Code', true, false, false);
                EnterCell(RowNo, 23, 'Division Code', true, false, false);
                EnterCell(RowNo, 24, 'Category 1 Code', true, false, false);
                EnterCell(RowNo, 25, 'Category 2 Code', true, false, false);
                EnterCell(RowNo, 26, 'Category 3 Code', true, false, false);
                EnterCell(RowNo, 27, Text001, true, false, false);  // 23-10-18 ZY-LD 001
                EnterCell(RowNo, 28, Text002, true, false, false);  // 24-11-20 ZY-LD 001
                EnterCell(RowNo, 29, Text003, true, false, false);  // 14-01-22 ZY-LD 002
                EnterCell(RowNo, 30, Text004, true, false, false);  // 14-01-22 ZY-LD 002

                RowNo := 2;

                ZGT.OpenProgressWindow('', Customer.Count);
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
        TempExcelBuffer.CreateBook('', 'Customer Item Sales');
        TempExcelBuffer.WriteSheet('Customer Item Sales', CompanyName(), UserId());
        TempExcelBuffer.CloseBook;
        TempExcelBuffer.OpenExcel;
    end;

    trigger OnPreReport()
    begin

        CustFilter := Customer.GetFilters;
        ItemLedgEntryFilter := "Value Entry".GetFilters;
        PeriodText := "Value Entry".GetFilter("Posting Date");
        RecNo := 0;
        TempExcelBuffer.DeleteAll;
        Clear(TempExcelBuffer);
        RowNo := 1;
        TotalRecNo := "Value Entry".Count;

        SI.UseOfReport(3, 50004, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        Item: Record Item;
        ValueEntryBuffer: Record "Value Entry" temporary;
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        Currency: Record Currency;
        CustFilter: Text[250];
        ItemLedgEntryFilter: Text[250];
        PeriodText: Text[30];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        RecNo: Integer;
        TotalRecNo: Integer;
        RowNo: Integer;
        ColumnNo: Integer;
        Text000: label 'Analyzing Customer Item Sales...\\';
        Profit: Decimal;
        ProfitPct: Decimal;
        Text001: label 'Ship-to Code';
        SI: Codeunit "Single Instance";
        Text002: label 'Ship-to Name';
        ZGT: Codeunit "ZyXEL General Tools";
        ShipToCode: Code[20];
        ShipToName: Text[50];
        CurrencyFactor: Decimal;
        ExtDocNo: Code[35];
        DelDocNo: Code[20];
        Text003: label 'External Document No.';
        Text004: label 'Delivery Document No.';

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.Insert;
    end;

    local procedure CalcProfitPct()
    begin
        begin
            if ValueEntryBuffer."Sales Amount (Actual)" <> 0 then
                ProfitPct := ROUND(100 * Profit / ValueEntryBuffer."Sales Amount (Actual)", 0.1)
            else
                ProfitPct := 0;
        end;
    end;
}
