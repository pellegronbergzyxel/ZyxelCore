xmlport 50038 "WS Replicate Sales Price"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/RepSalesPrice';
    Encoding = UTF8;
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(SalesPrice; "Price List Line")
            {
                MinOccurs = Zero;
                XmlName = 'SalesPrice';
                UseTemporary = true;
                SourceTableView = where("Asset Type" = filter("Price Source Type"::"All Customers" | "Price Source Type"::Customer | "Price Source Type"::"Customer Disc. Group" | "Price Source Type"::"Customer Price Group"));
                fieldelement(PriceListCode; SalesPrice."Price List Code")
                {
                }
                fieldelement(LineNo; SalesPrice."Line No.")
                {
                }
                fieldelement(SalesType; SalesPrice."Source Type")
                {
                }
                fieldelement(SourceNo; SalesPrice."Source No.")
                {
                }
                fieldelement(ParentSourceNo; SalesPrice."Parent Source No.")
                {
                }
                fieldelement(AssertType; SalesPrice."Asset Type")
                {
                }
                fieldelement(AssetNo; SalesPrice."Asset No.")
                {
                }
                fieldelement(VariantCode; SalesPrice."Variant Code")
                {
                }
                fieldelement(CurrencyCode; SalesPrice."Currency Code")
                {
                }
                fieldelement(WorkTypeCode; SalesPrice."Work Type Code")
                {
                }
                textelement(StartingDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        StartingDate := Format(SalesPrice."Starting Date", 0, '<Closing><Month,2>/<Day,2>/<Year>');
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        Evaluate(SalesPrice."Starting Date", StartingDate);
                    end;
                }
                textelement(EndingDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EndingDate := Format(SalesPrice."Ending Date", 0, '<Closing><Month,2>/<Day,2>/<Year>');
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        Evaluate(SalesPrice."Ending Date", EndingDate);
                    end;
                }
                fieldelement(MinQty; SalesPrice."Minimum Quantity")
                {
                }
                fieldelement(UnitOfMeasureCode; SalesPrice."Unit of Measure Code")
                {
                }
                fieldelement(AmountType; SalesPrice."Amount Type")
                {
                }
                fieldelement(UnitPrice; SalesPrice."Unit Price")
                {
                }
                fieldelement(CostFactor; SalesPrice."Cost Factor")
                {
                }
                fieldelement(UnitCost; SalesPrice."Unit Cost")
                {
                }
                fieldelement(LineDiscPct; SalesPrice."Line Discount %")
                {
                }
                fieldelement(AllowLineDisc; SalesPrice."Allow Line Disc.")
                {
                }
                fieldelement(AllowInvDisc; SalesPrice."Allow Invoice Disc.")
                {
                }
                fieldelement(PriceInclVat; SalesPrice."Price Includes VAT")
                {
                }
                fieldelement(VatBusPostGrp; SalesPrice."VAT Bus. Posting Gr. (Price)")
                {
                }
                fieldelement(VatProdPostGrp; SalesPrice."VAT Prod. Posting Group")
                {
                }
                fieldelement(LineAmount; SalesPrice."Line Amount")
                {
                }
                fieldelement(PriceType; SalesPrice."Price Type")
                {
                }
                fieldelement(Description; SalesPrice.Description)
                {
                }
                fieldelement(Status; SalesPrice.Status)
                {
                }
                fieldelement(DirectUnitCost; SalesPrice."Direct Unit Cost")
                {
                }
                fieldelement(SourceGroup; SalesPrice."Source Group")
                {
                }
                fieldelement(ProductNo; SalesPrice."Product No.")
                {
                }
                fieldelement(AssignToNo; SalesPrice."Assign-to No.")
                {
                }
                fieldelement(AssignToParentNo; SalesPrice."Assign-to Parent No.")
                {
                }
                fieldelement(VariantCodeLookup; SalesPrice."Variant Code Lookup")
                {
                }
                fieldelement(UnitOfMeasureCodeLookup; SalesPrice."Unit of Measure Code Lookup")
                {
                }
            }
        }
    }

    procedure SetData(pStartDate: Date)
    var
        PriceListLine: Record "Price List Line";
    begin
        PriceListLine.SetFilter("Source Type", '%1|%2|%3|%4', "Price Source Type"::"All Customers", "Price Source Type"::Customer, "Price Source Type"::"Customer Disc. Group", "Price Source Type"::"Customer Price Group");
        PriceListLine.SetFilter("Starting Date", '%1..', pStartDate);
        if PriceListLine.FindSet() then
            repeat
                SalesPrice := PriceListLine;
                SalesPrice.Insert();
            until PriceListLine.Next() = 0;
    end;

    procedure ReplicateData(pStartDate: Date)
    var
        PriceListLine: Record "Price List Line";
    begin
        PriceListLine.SetFilter("Source Type", '%1|%2|%3|%4', "Price Source Type"::"All Customers", "Price Source Type"::Customer, "Price Source Type"::"Customer Disc. Group", "Price Source Type"::"Customer Price Group");
        PriceListLine.SetFilter("Starting Date", '%1..', pStartDate);
        PriceListLine.DeleteAll();
        PriceListLine.Reset();

        if SalesPrice.FindSet() then
            repeat
                PriceListLine := SalesPrice;
                PriceListLine.Insert(true);
            until SalesPrice.Next() = 0;
    end;
}
