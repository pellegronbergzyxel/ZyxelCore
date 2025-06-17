Report 50094 "Zyxel Item list"
{
    //16-06-2025 BK 511374
    Caption = 'Zyxel Item List';
    ApplicationArea = All;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {

            RequestFilterFields = "No.", "Gen. Prod. Posting Group", "Inventory Posting Group", "Item Category Code", "WEEE Category";
            trigger OnAfterGetRecord()
            begin
                MakeExcelLine();
            end;

            trigger OnPostDataItem()
            begin
                CreateExcelbook();
            end;

            trigger OnPreDataItem()
            begin
                MakeExcelHead();
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
        TempExcelBuf: Record "Excel Buffer" temporary;

        Text002: Label 'Item';

    procedure MakeExcelHead()
    begin
        TempExcelBuf.NewRow();
        TempExcelBuf.AddColumn(item.FieldCaption("No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption(Description), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Unit Price"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Unit Cost"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Last Direct Cost"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);

        TempExcelBuf.AddColumn(item.FieldCaption("No PLMS Update"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Update PLMS from Item No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Prevent Negative Inventory"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        tempExcelBuf.AddColumn(item.FieldCaption("Last Phys. Invt. Date"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Identifier Code"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Use Cross-Docking"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Serial Number Required"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);

        TempExcelBuf.AddColumn(item.FieldCaption(Amaz_ASIN), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("UN Code"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("Cartons Per Pallet"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Qty Per Pallet"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Pallet Length (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Pallet Width (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Pallet Height (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Battery weight"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Product Length (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);

        TempExcelBuf.AddColumn(item.FieldCaption("Length (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Width (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Height (cm)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Volume (cm3)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Paper Weight"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Plastic Weight"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Net Weight"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Qty. per Color Box"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Length (ctn)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Width (ctn)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Height (ctn)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Volume (ctn)"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item.FieldCaption("Carton Weight"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Total Qty. per Carton"), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item.FieldCaption("Stockout Warning"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption(GTIN), false, '', true, false, false, '', TempExcelBuf."cell type"::Number);
        tempExcelBuf.AddColumn(item.FieldCaption("Tariff No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.FieldCaption("No Tariff Code"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(Item.FieldCaption("Item Country Code"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(Item.FieldCaption("WEEE Category"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
    end;


    procedure MakeExcelLine()
    begin
        TempExcelBuf.AddColumn(item."No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.Description, false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Unit Price", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Unit Cost", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Last Direct Cost", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);

        TempExcelBuf.AddColumn(item."No PLMS Update", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Update PLMS from Item No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Prevent Negative Inventory", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        tempExcelBuf.AddColumn(item."Last Phys. Invt. Date", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Identifier Code", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Use Cross-Docking", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Serial Number Required", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);

        TempExcelBuf.AddColumn(item.Amaz_ASIN, false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."UN Code", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."Cartons Per Pallet", false, '', false, false, false, '0', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Qty Per Pallet", false, '', false, false, false, '0', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Pallet Length (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Pallet Width (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Pallet Height (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Battery weight", false, '', false, false, false, '0.0000', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Product Length (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);

        TempExcelBuf.AddColumn(item."Length (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Width (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Height (cm)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Volume (cm3)", false, '', false, false, false, '0.000000', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Paper Weight", false, '', false, false, false, '0.0000', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Plastic Weight", false, '', false, false, false, '0.000000', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Net Weight", false, '', false, false, false, '0.0000', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Qty. per Color Box", false, '', false, false, false, '0', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Length (ctn)", false, '', false, false, false, '0', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Width (ctn)", false, '', false, false, false, '0.0', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Height (ctn)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Volume (ctn)", false, '', false, false, false, '0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(item."Carton Weight", false, '', false, false, false, '0.000', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Total Qty. per Carton", false, '', false, false, false, '', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(Item."Stockout Warning", false, '', false, false, false, '0', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item.GTIN, false, '', false, false, false, '', TempExcelBuf."cell type"::Number);
        tempExcelBuf.AddColumn(item."Tariff No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(item."No Tariff Code", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(Item."Item Country Code", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(Item."WEEE Category", false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
    end;


    procedure CreateExcelbook()
    begin
        TempExcelBuf.CreateBook('', Text002);
        TempExcelBuf.WriteSheet(Text002, CompanyName(), UserId());
        TempExcelBuf.CloseBook();
        if GuiAllowed() then begin
            TempExcelBuf.OpenExcel();
            Error('');
        end;
    end;
}
