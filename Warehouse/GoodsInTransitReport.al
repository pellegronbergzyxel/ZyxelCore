report 50127 "Goods in Transit to Excel"
{ //24-08-2026 BK #590491
    ApplicationArea = Basic, Suite;
    Caption = 'HQ - Goods in Transit to Excel';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ShippingDetail; "VCK Shipping Detail")
        {
            trigger OnPreDataItem()
            begin
                TempExcelBuffer.Reset();
                TempExcelBuffer.DeleteAll();

                CalETAVisible := ZGT.IsZComCompany();

                AddExcelHeader();
            end;

            trigger OnAfterGetRecord()
            begin
                ShippingDetail.CalcFields(
                    "Quantity Received",
                    "Direct Unit Cost",
                    "Item Description",
                    "Item Category 1 Code",
                    "Item Category 2 Code",
                    "Item Category 3 Code",
                    "Division Code");

                CalculatedQuantity :=
                    ShippingDetail.Quantity -
                    ShippingDetail."Quantity Received";

                CalculatedAmount :=
                    CalculatedQuantity *
                    ShippingDetail."Direct Unit Cost";

                AddExcelLine();
            end;

            trigger OnPostDataItem()
            begin
                CreateExcelBook();
            end;
        }
    }

    local procedure AddExcelHeader()
    begin
        TempExcelBuffer.NewRow();

        AddTextColumn('Invoice No.', true);
        AddTextColumn('Bill of Lading No.', true);
        AddTextColumn('Purchase Order No.', true);
        AddTextColumn('Purchase Order Line No.', true);
        AddTextColumn('Item No.', true);
        AddTextColumn('Item Description', true);
        AddTextColumn('Expected Receipt Date', true);
        AddTextColumn('Category 1 Code', true);
        AddTextColumn('Category 2 Code', true);
        AddTextColumn('Category 3 Code', true);
        AddTextColumn('Division Code', true);
        AddTextColumn('Calculated Quantity', true);
        AddTextColumn('Unit Price', true);
        AddTextColumn('Amount', true);

        if CalETAVisible then
            AddTextColumn('Calculated ETA Date', true);
    end;

    local procedure AddExcelLine()
    begin
        TempExcelBuffer.NewRow();

        AddTextColumn(ShippingDetail."Invoice No.", false);
        AddTextColumn(ShippingDetail."Bill of Lading No.", false);
        AddTextColumn(ShippingDetail."Purchase Order No.", false);

        TempExcelBuffer.AddColumn(ShippingDetail."Purchase Order Line No.", false, '', false, false, false, '0', TempExcelBuffer."Cell Type"::Number);

        AddTextColumn(ShippingDetail."Item No.", false);
        AddTextColumn(ShippingDetail."Item Description", false);
        AddDateColumn(ShippingDetail."Expected Receipt Date");
        AddTextColumn(ShippingDetail."Item Category 1 Code", false);
        AddTextColumn(ShippingDetail."Item Category 2 Code", false);
        AddTextColumn(ShippingDetail."Item Category 3 Code", false);
        AddTextColumn(ShippingDetail."Division Code", false);

        TempExcelBuffer.AddColumn(CalculatedQuantity, false, '', false, false, false, '0.##', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(ShippingDetail."Direct Unit Cost", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(CalculatedAmount, false, '', false, false, false, '0.00', TempExcelBuffer."Cell Type"::Number);
        if CalETAVisible then
            AddDateColumn(ShippingDetail."Calculated ETA Date");
    end;

    local procedure AddTextColumn(Value: Variant; Bold: Boolean)
    begin
        TempExcelBuffer.AddColumn(Value, false, '', Bold, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddDateColumn(Value: Date)
    begin
        if Value = 0D then
            TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
        else
            TempExcelBuffer.AddColumn(Value, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
    end;

    local procedure CreateExcelBook()
    begin
        TempExcelBuffer.CreateNewBook(WorksheetNameLbl);

        TempExcelBuffer.WriteSheet(ReportCaptionLbl, CompanyName, UserId);

        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(FileNameLbl);
        TempExcelBuffer.OpenExcel();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ZGT: Codeunit "ZyXEL General Tools";
        CalculatedQuantity: Decimal;
        CalculatedAmount: Decimal;
        CalETAVisible: Boolean;

        WorksheetNameLbl: Label 'Goods in Transit';
        ReportCaptionLbl: Label 'HQ - Goods in Transit';
        FileNameLbl: Label 'Goods in Transit';
}