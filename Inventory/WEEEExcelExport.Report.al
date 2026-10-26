Report 50026 "WEEE Excel Export"
{

    Caption = 'WEEE Excel Export';
    ProcessingOnly = true;
    UsageCategory = Lists;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            CalcFields = "Sales Amount (Actual)";
            DataItemTableView = sorting("Item No.", "Posting Date") where("Entry Type" = const(Sale));
            RequestFilterFields = "Posting Date", "Country/Region Code", "Document Type";

            trigger OnAfterGetRecord()
            var
                Qty: Integer;
                recBatteryUNCodes: Record "Battery UN Codes";
                Item: Record Item;
                Exclude: Boolean; //15-10-2026 BK #569701
                LastItemNo: Code[20]; //15-10-2026 BK #569701

            begin
                ZGT.UpdateProgressWindow("Item Ledger Entry"."Item No.", 0, true);
                //15-10-2026 BK #569701
                if ItemSelection = ItemSelection::Marked then begin
                    if LastItemNo <> "item ledger entry"."Item No." then begin
                        if item.get("Item Ledger Entry"."Item No.") then
                            if Item."Included in WEEE" then begin
                                HandleItemLedgerEntry("Item Ledger Entry", '', 'RHQ');
                                lastItemNo := "Item Ledger Entry"."Item No.";
                            end;
                    end else begin
                        if Item."Included in WEEE" then begin
                            HandleItemLedgerEntry("Item Ledger Entry", '', 'RHQ');
                            lastItemNo := "Item Ledger Entry"."Item No.";
                        end;
                    end;
                end else begin
                    HandleItemLedgerEntry("Item Ledger Entry", '', 'RHQ');
                end;

            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow();
            end;

            trigger OnPreDataItem()
            begin
                ShipToCountries := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Country/Region Code");
                "Item Ledger Entry".SetRange("Item Ledger Entry"."Country/Region Code");
                "Item Ledger Entry".SetFilter("Item Ledger Entry"."Location Code", '<>%1', 'PP*');
                ZGT.OpenProgressWindow('', "Item Ledger Entry".Count);
                MakeExcelHead();
                GetExcluedCust();
            end;
        }
        dataitem(ItemLedgerEntryRMA; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", "Posting Date") where("Entry Type" = filter("Positive Adjmt." | "Negative Adjmt."), "Global Dimension 2 Code" = const('RMA'));

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(ItemLedgerEntryRMA."Item No.", 0, true);
                HandleItemLedgerEntry(ItemLedgerEntryRMA, '', 'RMA');
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow();
            end;

            trigger OnPreDataItem()
            begin
                "Item Ledger Entry".Copyfilter("Posting Date", ItemLedgerEntryRMA."Posting Date");
                ZGT.OpenProgressWindow('', ItemLedgerEntryRMA.Count);
            end;
        }
        dataitem("Country/Region"; "Country/Region")
        {
            DataItemTableView = sorting(Code);

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Country/Region".Code, 0, true);

                ExcelBuf.Reset();
                ExcelBuf.SetRange("Column No.", 5);
                ExcelBuf.SetFilter("Cell Value as Text", '%1|%2', "Country/Region".Code, "Country/Region".Code + Text003);
                if ExcelBuf.FindSet then begin
                    RowTmp.DeleteAll();
                    repeat
                        if not RowTmp.Get(ExcelBuf."Row No.") then begin
                            RowTmp.Number := ExcelBuf."Row No.";
                            RowTmp.Insert;
                        end;
                    until ExcelBuf.Next() = 0;
                    RowTmp.Number := 1;
                    RowTmp.Insert();

                    if RowTmp.FindSet then begin
                        ExcelBuf.Reset();
                        ExcelBuf2.DeleteAll();
                        repeat
                            ExcelBuf2.NewRow;
                            ExcelBuf.SetRange("Row No.", RowTmp.Number);
                            if ExcelBuf.FindSet() then
                                repeat
                                    ExcelBuf2 := ExcelBuf;
                                    ExcelBuf2."Row No." := GetCurRowNo;
                                    ExcelBuf2.Insert();
                                until ExcelBuf.Next() = 0;
                        until RowTmp.Next() = 0;

                        MakeExcelGrandFoot();

                        if FirstLoop then begin
                            CreateExcelbook("Country/Region".Code);
                            FirstLoop := false;
                        end else
                            AddNewSheet("Country/Region".Code);
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuf.Reset;
                ExcelBuf2.DeleteAll;
                if ExcelBuf.FindSet then begin
                    repeat
                        ExcelBuf2 := ExcelBuf;
                        ExcelBuf2.Insert;
                    until ExcelBuf.Next() = 0;

                    ExcelBuf2.SetCurrent(ExcelBuf2."Row No.", 0);
                    MakeExcelGrandFoot();

                    if FirstLoop then
                        CreateExcelbook(Text004)
                    else
                        AddNewSheet(Text004);
                end;

                OpenExcelbook();
                ZGT.CloseProgressWindow();
            end;

            trigger OnPreDataItem()
            begin
                FirstLoop := true;
                ZGT.OpenProgressWindow('', "Country/Region".Count);
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
                    Caption = 'Option';

                    Field(Itemselection; ItemSelection)
                    {
                        ApplicationArea = All;
                        Caption = 'Selection Filter';
                        OptionCaption = 'All,Marked';
                        ToolTip = 'Choose if the report should be all Items or only Items with Yes in Included in WEEE';
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
        if not ZGT.IsRhq then
            Message(Text005, ZGT.GetRHQCompanyName);

        SI.UseOfReport(3, 50026, 3);
    end;

    var
        recBatteryUNCodes: Record "Battery UN Codes";
        ExcelBuf: Record "Excel Buffer" temporary;
        ExcelBuf2: Record "Excel Buffer" temporary;
        RowTmp: Record "Integer" temporary;
        CustTmp: Record Customer temporary;
        recItem: Record Item;
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        ItemSelection: option All,Marked;   //23-10-2026 BK #569701     
        Col: Integer;
        ShipToCountry: Text[20];
        ShipToCountries: Code[250];
        FirstLoop: Boolean;
        Text004: label 'All';
        Text005: label 'Please, You should confirm excel numbers if the report is not extracted from %1.';
        Text003: label ' - (Sell-to)';


    local procedure HandleItemLedgerEntry(pItemLedgerEntry: Record "Item Ledger Entry"; pCompanyName: Text; pRelation: Code[10])
    var
        recSalesShipHead: Record "Sales Shipment Header";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        begin
            pItemLedgerEntry.Quantity := -pItemLedgerEntry.Quantity;
            ShipToCountry := '';

            if pItemLedgerEntry."Entry Type" = pItemLedgerEntry."entry type"::Sale then begin
                if (not CustTmp.Get(pItemLedgerEntry."Source No.")) then begin
                    case pItemLedgerEntry."Document Type" of
                        pItemLedgerEntry."document type"::"Sales Shipment":
                            begin
                                if pCompanyName <> '' then
                                    recSalesShipHead.ChangeCompany(pCompanyName);

                                recSalesShipHead.Get(pItemLedgerEntry."Document No.");
                                if (recSalesShipHead."Ship-to Country/Region Code" = '') or (StrPos(ShipToCountries, recSalesShipHead."Ship-to Country/Region Code") <> 0) then begin
                                    if recSalesShipHead."Ship-to Country/Region Code" <> '' then
                                        ShipToCountry := recSalesShipHead."Ship-to Country/Region Code"
                                    else
                                        if StrPos(ShipToCountries, recSalesShipHead."Sell-to Country/Region Code") <> 0 then
                                            ShipToCountry := recSalesShipHead."Sell-to Country/Region Code" + Text003
                                        else
                                            if recSalesShipHead."Sell-to Country/Region Code" <> '' then
                                                CurrReport.Skip();
                                end else
                                    CurrReport.Skip();

                                pItemLedgerEntry."Return Reason Code" := '';
                            end;
                        pItemLedgerEntry."document type"::"Sales Credit Memo":
                            begin
                                if pCompanyName <> '' then
                                    recSalesCrMemoHead.ChangeCompany(pCompanyName);

                                IF (pItemLedgerEntry."Return Reason Code" = '1') then begin
                                    recSalesCrMemoHead.Get(pItemLedgerEntry."Document No.");
                                    if (recSalesCrMemoHead."Ship-to Country/Region Code" = '') or (StrPos(ShipToCountries, recSalesCrMemoHead."Ship-to Country/Region Code") <> 0) then begin
                                        if recSalesCrMemoHead."Ship-to Country/Region Code" <> '' then
                                            ShipToCountry := recSalesCrMemoHead."Ship-to Country/Region Code"
                                        else
                                            if StrPos(ShipToCountries, recSalesCrMemoHead."Sell-to Country/Region Code") <> 0 then
                                                ShipToCountry := recSalesCrMemoHead."Sell-to Country/Region Code" + Text003
                                            else
                                                if recSalesCrMemoHead."Sell-to Country/Region Code" <> '' then
                                                    CurrReport.Skip();
                                    end else
                                        CurrReport.Skip()
                                end else
                                    CurrReport.Skip();
                            end;
                        pItemLedgerEntry."document type"::"Sales Invoice":
                            begin
                                if (Not ZGT.IsRhq()) then begin
                                    if pCompanyName <> '' then
                                        SalesInvoiceHeader.ChangeCompany(pCompanyName);


                                    SalesInvoiceHeader.Get(pItemLedgerEntry."Document No.");
                                    if (SalesInvoiceHeader."Ship-to Country/Region Code" = '') or (StrPos(ShipToCountries, SalesInvoiceHeader."Ship-to Country/Region Code") <> 0) then begin
                                        if SalesInvoiceHeader."Ship-to Country/Region Code" <> '' then
                                            ShipToCountry := SalesInvoiceHeader."Ship-to Country/Region Code"
                                        else
                                            if StrPos(ShipToCountries, SalesInvoiceHeader."Sell-to Country/Region Code") <> 0 then
                                                ShipToCountry := SalesInvoiceHeader."Sell-to Country/Region Code" + Text003
                                            else
                                                if SalesInvoiceHeader."Sell-to Country/Region Code" <> '' then
                                                    CurrReport.Skip();
                                    end else
                                        CurrReport.Skip();

                                    pItemLedgerEntry."Return Reason Code" := '';
                                end else
                                    CurrReport.Skip();
                            end;

                        else
                    end;

                    recItem.SetRange("No.", pItemLedgerEntry."Item No.");
                    recItem.SetRange(IsEICard, false);
                    recItem.SetRange("Non ZyXEL License", false);
                    if recItem.FindFirst then begin
                        Clear(recBatteryUNCodes);
                        if recItem."UN Code" <> '' then
                            if not recBatteryUNCodes.Get(recItem."UN Code") then;

                        MakeExcelLine(pItemLedgerEntry, pRelation);
                    end;
                end;
            end else begin  // Entry type
                ShipToCountry := CopyStr(pItemLedgerEntry."Location Code", 5, 2);
                if StrPos(ShipToCountries, ShipToCountry) <> 0 then begin
                    recItem.SetRange("No.", pItemLedgerEntry."Item No.");
                    recItem.SetRange(IsEICard, false);
                    recItem.SetRange("Non ZyXEL License", false);
                    if recItem.FindFirst then begin
                        Clear(recBatteryUNCodes);
                        if recItem."UN Code" <> '' then
                            if not recBatteryUNCodes.Get(recItem."UN Code") then;

                        MakeExcelLine(pItemLedgerEntry, pRelation);
                    end;
                end;
            end;
        end;
    end;


    procedure MakeExcelHead()
    var
        lText001: label ' Total';
        lText002: label ' Description';
        lText003: label 'Customer No.';
        recSalesShipHead: Record "Sales Shipment Header";
        lText004: label 'Relation';
        lText005: label 'Product Length is Above 50 cm.';
    begin
        Col := 37;
        ExcelBuf.NewRow();


        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Posting Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption(Quantity), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Net Weight"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Net Weight") + lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('WEEE Weight', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('WEEE Weight Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText005, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Product Length (cm)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Tariff No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Battery weight"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Battery weight") + lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Business to"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Paper Weight"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Paper Weight") + lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Total Qty. per Carton"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Cartons Per Pallet"), false, '', true, false, false, '', ExcelBuf."cell type"::Text); //13-04-2026 BK #567065
        ExcelBuf.AddColumn(recItem.FieldCaption("Empty Outer Carton Weight"), false, '', true, false, false, '', ExcelBuf."cell type"::Text); //03-02-2026 BK #553504
        ExcelBuf.AddColumn(recItem.FieldCaption("Empty Outer Carton Weight") + lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text); //03-02-2026 BK #553504
        ExcelBuf.AddColumn(recItem.FieldCaption("Plastic Weight"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Plastic Weight") + lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption("Qty Per Pallet"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Pallet Type', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Empty Pallet Weight', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Empty Pallet Weight Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Strapping Belt Type', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Strapping Belt Weight', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Strapping Belt Weight Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Edgeboard Type', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Edgeboard Weight', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Edgeboard Weight Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Stretch Film Type', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Stretch Film Weight', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Stretch Film Weight Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Cloth Bag Type', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Cloth Bag Weight', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Cloth Bag Weight Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Location Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Item No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recItem.FieldCaption(Description), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recSalesShipHead.FieldCaption("Ship-to Country/Region Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Document Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Document No."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".FieldCaption("Sales Amount (Actual)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        ExcelBuf.NewRow();
    end;


    procedure MakeExcelLine(pItemLedgerEntry: Record "Item Ledger Entry"; pRelation: Code[10])
    begin
        begin

            ExcelBuf.AddColumn(pItemLedgerEntry."Posting Date", false, '', false, false, false, '', ExcelBuf."cell type"::Date);
            AddColumnDecimal(pItemLedgerEntry.Quantity, '#,###,##0');
            AddColumnDecimal(recItem."Net Weight", '#,###,##0.000');
            AddColumnDecimal(recItem."Net Weight" * pItemLedgerEntry.Quantity, '#,###,##0.000');
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(recItem."Product Length (cm)" > 50, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            AddColumnDecimal(RecItem."Product Length (cm)", '#,###,##0.000');
            ExcelBuf.AddColumn(recItem."Tariff No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            AddColumnDecimal(recItem."Battery weight", '#,###,##0.0000000000');
            AddColumnDecimal(recItem."Battery weight" * pItemLedgerEntry.Quantity, '#,###,##0.0000000000');
            ExcelBuf.AddColumn(StrSubstNo('%1 %2', recItem.FieldCaption("Business to"), Format(recItem."Business to")), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
            AddColumnDecimal(recItem."Paper Weight", '#,###,##0.000');
            AddColumnDecimal(recItem."Paper Weight" * pItemLedgerEntry.Quantity, '#,###,##0.000');
            AddColumnDecimal(RecItem."Total Qty. per Carton", '#,###,##0.000');
            AddColumnDecimal(recItem."Cartons Per Pallet", '#,###,##0'); //13-04-2026 BK #567065
            AddColumnDecimal(recItem."Empty Outer Carton Weight", '#,###,##0.000'); //03-02-2026 BK #553504
            AddColumnDecimal(recItem."Empty Outer Carton Weight" * pItemLedgerEntry.Quantity, '#,###,##0.000'); //03-02-2026 BK #553504
            AddColumnDecimal(recItem."Plastic Weight", '#,###,##0.0000000000');
            AddColumnDecimal(recItem."Plastic Weight" * pItemLedgerEntry.Quantity, '#,###,##0.000');
            AddColumnDecimal(recItem."Qty Per Pallet", '#,###,##0.00');
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(pItemLedgerEntry."Location Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(pItemLedgerEntry."Item No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(recItem.Description, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(pItemLedgerEntry."Source No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(ShipToCountry, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(Format(pItemLedgerEntry."Document Type"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            ExcelBuf.AddColumn(pItemLedgerEntry."Document No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
            AddColumnDecimal(pItemLedgerEntry."Sales Amount (Actual)", '#,###,##0.00');
            ExcelBuf.NewRow();
        end;
    end;

    local procedure AddColumnDecimal(pDecimal: Decimal; pFormat: Text)
    begin
        if pDecimal <> 0 then
            ExcelBuf.AddColumn(pDecimal, false, '', false, false, false, pFormat, ExcelBuf."cell type"::Number)
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Number);
    end;


    procedure MakeExcelGrandFoot()
    var
        lText001: label '=SUM(%1%2:%1%3)';
        ToRowNo: Integer;
    begin
        ExcelBuf2.SetCurrent(GetCurRowNo() + 2, 0);
        ExcelBuf2.AddColumn('Grand Total:', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf2.SetCurrent(GetCurRowNo(), 7);
        ToRowNo := GetCurRowNo() - 2;
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.0000000000', ExcelBuf."cell type"::Number);
        ExcelBuf2.AddColumn(StrSubstNo(lText001, GetColumn, 2, ToRowNo), true, '', true, false, false, '##,###,##0.0000000000', ExcelBuf."cell type"::Number);
    end;


    procedure CreateExcelbook(SheetName: Text[30])
    var

    begin
        // ExcelBuf2.CreateBook('', SheetName); CLOUD ready DELETE
        ExcelBuf2.CreateNewBook(SheetName);
        ExcelBuf2.WriteSheet(SheetName, SheetName, UserId());
        ExcelBuf2.ClearNewRow();
    end;

    local procedure AddNewSheet(SheetName: Text[30])
    begin
        ExcelBuf2.AddNewSheet(SheetName);
        ExcelBuf2.WriteSheet(SheetName, SheetName, UserId());
    end;


    procedure OpenExcelbook()
    var
        FileManagement: Codeunit "File Management";
    begin
        ExcelBuf2.CloseBook();
        ExcelBuf2.OpenExcel();
        Error('');
    end;

    local procedure GetColumn(): Code[10]
    var
        CurrentColNo: Variant;
        CurrColNo: Integer;
    begin
        ExcelBuf2.UTgetGlobalValue('CurrentCol', CurrentColNo);
        CurrColNo := CurrentColNo;
        exit(ZGT.GetExcelColumnHeader(CurrColNo));
    end;

    local procedure GetCurRowNo() rValue: Integer
    var
        CurrentRowNo: Variant;
    begin
        ExcelBuf2.UTgetGlobalValue('CurrentRow', CurrentRowNo);
        rValue := CurrentRowNo;
    end;

    local procedure GetExcluedCust()
    var
        recCust: Record Customer;
    begin
        recCust.SetRange("Exclude Wee Report", true);
        if recCust.FindSet() then
            repeat
                CustTmp := recCust;
                CustTmp.Insert();
            until recCust.Next() = 0;
    end;

    procedure SetItemSelection(NewItemSelection: Option All,Marked)
    begin
        ItemSelection := NewItemSelection;
    end;
}
